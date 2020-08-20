#requires -Modules Pester, PSScriptAnalyzer, WinSCP

BeforeAll {
    Get-Process -Name WinSCP -ErrorAction SilentlyContinue | 
        Stop-Process -Force
}

Describe "ConvertTo-WinSCPEscapedString" {
    Context "ConvertTo-WinSCPEscapedString -FileMask `"FileNameWith*.txt`"" {
        $escapedString = ConvertTo-WinSCPEscapedString -FileMask "FileNameWith*.txt"

        It "Star in file name should be escaped." {
            $escapedString | 
                Should -BeExactly "FileNameWith[*].txt"
        }
    }

    Context "Invoke-ScriptAnalyzer -Path `"$((Get-Module -Name WinSCP).ModuleBase)\Functions\ConvertTo-WinSCPEscapedString.ps1`"" {
        $results = Invoke-ScriptAnalyzer -Path "$((Get-Module -Name WinSCP).ModuleBase)\Public\ConvertTo-WinSCPEscapedString.ps1"

        It "Invoke-ScriptAnalyzer results of ConvertTo-WinSCPEscapedString count should be 0." {
            $results.Count | 
                Should -Be 0
        }
    }
}
