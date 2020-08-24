Describe "WinSCP" {
    It "Test-ModuleManifest" {
        Test-ModuleManifest -Path "$((Get-Module -Name WinSCP).ModuleBase)\WinSCP.psd1" |
            Should -Not -BeNullOrEmpty

        $? |
            Should -Be $true
    }
}
