function ConvertTo-WinSCPEscapedString {

    [CmdletBinding(
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/ConvertTo-WinSCPEscapedString"
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
        [String[]]
        $FileMask
    )

    begin {
        $session = New-Object -TypeName WinSCP.Session -Property @{
            ExecutablePath = "$PSScriptRoot\..\bin\winscp.exe"
        }
    }

    process {
        foreach ($fileMaskValue in $FileMask) {
            try {
                $output = $session.EscapeFileMask(
                    $fileMaskValue
                )

                Write-Output -InputObject $output
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
                continue
            }
        }
    }
    
    end {
        $session.Dispose()
    }
}
