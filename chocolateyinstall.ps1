$sourceFiles = Get-Item -Path ".\lib\winscp.powershell"
$moduleName = (Get-ChildItem -Path $sourceFiles -Filter "*.psd1").ToString().TrimEnd(".psd1")
$userModuleDirectory = "$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules"
$moduleDirectory = Join-Path -Path $userModuleDirectory -ChildPath $moduleName

if (Test-Path $moduleDirectory)
{
    Remove-Item -Path $moduleDirectory -Recurse -Force -Confirm:$false
}

Copy-Item -Path $sourceFiles -Destination $moduleDirectory -Recurse

Get-ChildItem -Path $moduleDirectory -Include "chocolateyinstall.ps1","chocolateyuninstall.ps1","*.nupkg" -Recurse | %{ Remove-Item -Path $_.FullName -Force -Confirm:$false }

Import-Module -Name (Get-Item -Path $moduleDirectory)