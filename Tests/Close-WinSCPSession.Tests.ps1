Import-Module -Name "$((Get-Item -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Parent)\WinSCP.psd1"

Describe "Close-WinSCPSession" {
    It "WinSCP Module should be loaded." {
        Get-Module -Name WinSCP | Should be $true
    }
}