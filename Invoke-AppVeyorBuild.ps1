#requires -Modules Configuration, Pester, PSScriptAnalyzer

try {
    Set-Location -Path $env:APPVEYOR_BUILD_FOLDER -ErrorAction Stop

    Import-Module -Name ".\${env:APPVEYOR_PROJECT_NAME}" -Force -ErrorAction Stop

    $pesterResults = "${env:APPVEYOR_BUILD_FOLDER}\testResults.xml"
    $pesterContainer = New-PesterContainer -Path ".\Tests"
    $pesterConfiguration = [PesterConfiguration]@{
        Run = @{
            Container = $pesterContainer
        }
        Output = @{
            Verbosity = "Detailed"
        }
        TestResult = @{
            Enabled = $true
            OutputPath = $pesterResults
        }
    }
    Invoke-Pester -Configuration $pesterConfiguration

    (New-Object -TypeName System.Net.WebClient).UploadFile(
        "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path -Path $pesterResults)
    )

    $failures = ([Xml](Get-Content -Path $pesterResults))."text-results".failures

    if ($failures -gt 0) {
        throw "Build failed."
    } else {
        Remove-Item -Path .\WinSCP\bin\winscp.ini -Force -Confirm:$false
        Update-Metadata -Path ".\${env:APPVEYOR_PROJECT_NAME}\${env:APPVEYOR_PROJECT_NAME}.psd1" -PropertyName ModuleVersion -Value $env:APPVEYOR_BUILD_VERSION -ErrorAction Stop
        Update-Metadata -Path ".\${env:APPVEYOR_PROJECT_NAME}\${env:APPVEYOR_PROJECT_NAME}.psd1" -PropertyName ReleaseNotes -Value $env:APPVEYOR_REPO_COMMIT_MESSAGE -ErrorAction Stop
        # Publish to the PowerShell Gallery if the build is successful.
        Publish-Module -Path ".\${env:APPVEYOR_PROJECT_NAME}" -NuGetApiKey $env:POWERSHELL_GALLERY_API_TOKEN -Verbose -ErrorAction Stop
    }
} catch {
    throw $_
}
