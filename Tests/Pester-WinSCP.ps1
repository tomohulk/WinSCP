$tests = Get-ChildItem -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Filter *.Tests.ps1

if (Test-Path -Path "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\Ftp")
{
    Remove-Item -Path "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\Ftp" -Confirm:$false -Recurse -Force
}
if (Test-Path -Path "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\Local")
{
    Remove-Item -Path "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\Local" -Confirm:$false -Recurse -Force
}

foreach ($test in $tests)
{
    &"$($test.FullName)"
}