function Get-WinSCPHostKeyFingerprint {

    [CmdletBinding(
        ConfirmImpact = "Low",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Get-WinSCPHostKeyFingerprint",
        PositionalBinding = $false
    )]
    [OutputType(
        [String]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [WinSCP.SessionOptions[]]
        $SessionOption,

        [Parameter(
            Mandatory = $true
        )]
        [ValidateSet(
            "SHA-256", "MD5"
        )]
        [String]
        $Algorithm
    )

    begin {
        $session = New-Object -TypeName WinSCP.Session -Property @{
            ExecutablePath = "$PSScriptRoot\..\bin\winscp.exe"
        }
    }

    process {
        foreach ($sessionOptionValue in $SessionOption) {
            try {
                $output = $session.ScanFingerprint(
                    $sessionOptionValue, $Algorithm
                )

                Write-Output -InputObject $output
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
            }
        }
    }

    end {
        $session.Dispose()
    }
}
