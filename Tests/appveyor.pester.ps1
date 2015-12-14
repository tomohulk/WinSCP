#requires -Modules Pester
Set-Location -Path $ENV:APPVEYOR_BUILD_FOLDER

$timestamp = Get-Date -uformat "%Y%m%d-%H%M%S"
$psVersion = $PSVersionTable.PSVersion.Major
$results = "Results_PS${psVersion}_${timestamp}.xml"

Invoke-Pester -Path '.\Tests' -OutputFormat NUnitXml -OutputFile ".\$results"

(New-Object -TypeName System.Net.WebClient).UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", ".\$results")