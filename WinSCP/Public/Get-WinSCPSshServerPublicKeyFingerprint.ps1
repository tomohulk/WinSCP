function Get-WinSCPSshServerPublicKeyFingerprint {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Get-WinSCPSshServerPublicKeyFingerprint.html"
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
        $SessionOption
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
                    $sessionOptionValue
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
