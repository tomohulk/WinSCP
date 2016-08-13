#requires -Modules Configuration, Pester, PSScriptAnalyzer

try {
    Set-Location -Path $env:APPVEYOR_BUILD_FOLDER -ErrorAction Stop

    $timestamp = Get-Date -uformat "%Y%m%d-%H%M%S"
    $resultsFile = "Results_${timestamp}.xml"

    Import-Module -Name .\$env:APPVEYOR_PROJECT_NAME -Force -ErrorAction Stop

    Invoke-Pester -Path '.\Tests' -OutputFormat NUnitXml -OutputFile ".\$resultsFile" -PassThru -ErrorAction Stop | 
        Export-Clixml -Path ".\Pester$resultsFile"

    (New-Object -TypeName System.Net.WebClient).UploadFile(
        "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path -Path ".\$resultsFile")
    )
    
    [Int]$failures = Import-Clixml -Path ".\Pester$resultsFile" -ErrorAction Stop | 
        Select-Object -ExpandProperty FailedCount | 
            Measure-Object -Sum | 
                Select-Object -ExpandProperty Sum

    if ($failures -gt 0) {
        throw "Build failed."
    } else {
        # Publish to the PowerShell Gallery if the build is successful.
        Update-Metadata -Path ".\${env:APPVEYOR_PROJECT_NAME}\${env:APPVEYOR_PROJECT_NAME}.psd1" -PropertyName ModuleVersion -Value $env:APPVEYOR_BUILD_VERSION -ErrorAction Stop
        Update-Metadata -Path ".\${env:APPVEYOR_PROJECT_NAME}\${env:APPVEYOR_PROJECT_NAME}.psd1" -PropertyName ReleaseNotes -Value $env:APPVEYOR_REPO_COMMIT_MESSAGE -ErrorAction Stop

        Publish-Module -Path .\$env:APPVEYOR_PROJECT_NAME -NuGetApiKey $env:POWERSHELL_GALLERY_API_TOKEN -Verbose -ErrorAction Stop
    }
} catch {
    throw $_
}
