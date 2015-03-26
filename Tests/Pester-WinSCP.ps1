$tests = Get-ChildItem -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Filter *.Tests.ps1

foreach ($test in $tests)
{
    &"$($test.FullName)"
}