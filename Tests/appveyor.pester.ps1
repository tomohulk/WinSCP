#requires -Modules Pester
try {
    Set-Location -Path $ENV:APPVEYOR_BUILD_FOLDER -ErrorAction Stop

    $timestamp = Get-Date -uformat "%Y%m%d-%H%M%S"
    $psVersion = $PSVersionTable.PSVersion.Major
    $resultsFile = "Results_PS${psVersion}_${timestamp}.xml"

    Import-Module -Name .\WinSCP\WinSCP.psd1 -Force -ErrorAction Stop

    Invoke-Pester -Path '.\Tests' -OutputFormat NUnitXml -OutputFile ".\$resultsFile" -ErrorAction Stop

    (New-Object -TypeName System.Net.WebClient -ErrorAction Stop).UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", ".\$resultsFile")
    
    if ((Import-Clixml -Path .\$resultsFile -ErrorAction Stop | Select-Object -ExpandProperty FailedCount | Measure-Object -Sum | Select-Object -ExpandProperty Sum) -gt 0) {
        throw "Build failed."
    }
} catch {
    throw $_
}