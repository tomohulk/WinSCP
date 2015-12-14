#requires -Modules Pester
Set-Location -Path $ENV:APPVEYOR_BUILD_FOLDER

$timestamp = Get-Date -uformat "%Y%m%d-%H%M%S"
$psVersion = $PSVersionTable.PSVersion.Major
$resultsFile = "Results_PS${psVersion}_${timestamp}.xml"

Import-Module -Name .\WinSCP\WinSCP.psd1 -Force

Invoke-Pester -Path '.\Tests' -OutputFormat NUnitXml -OutputFile ".\$results"

(New-Object -TypeName System.Net.WebClient).UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", ".\$resultsFile")

$results = @( Get-ChildItem -Path "$ProjectRoot\PesterResults_PS*.xml" | Import-Clixml )
            
$failedCount = 
    
if (($results | Select-Object -ExpandProperty FailedCount |Measure-Object -Sum |Select-Object -ExpandProperty Sum) -gt 0) {
    throw "Build failed."
}