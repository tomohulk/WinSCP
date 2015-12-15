#requires -Modules Pester
try {
    Set-Location -Path $env:APPVEYOR_BUILD_FOLDER -ErrorAction Stop

    $timestamp = Get-Date -uformat "%Y%m%d-%H%M%S"
    $resultsFile = "Results_$timestamp.xml"

    Import-Module -Name Pester -Force -ErrorAction Stop
    Import-Module -Name PSScriptAnalyzer -Force -ErrorAction Stop
    Import-Module -Name .\WinSCP\WinSCP.psd1 -Force -ErrorAction Stop

    Invoke-Pester -Path '.\Tests' -OutputFormat NUnitXml -OutputFile ".\$resultsFile" -PassThru -ErrorAction Stop | 
        Export-Clixml -Path ".\Pester$resultsFile"

    (New-Object -TypeName System.Net.WebClient).UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", ".\$resultsFile")
    
    if ((Import-Clixml -Path ".\Pester$resultsFile" -ErrorAction Stop | Select-Object -ExpandProperty FailedCount | Measure-Object -Sum | Select-Object -ExpandProperty Sum) -gt 0) {
        throw "Build failed."
    }
} catch {
    throw $_
}