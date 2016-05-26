Function ConvertTo-WinSCPEscapedString {
    [CmdletBinding(
        HelpUri = 'https://github.com/dotps1/WinSCP/wiki/ConvertTo-WinSCPEscapedString'
    )]
    [OutputType(
        [String]
    )]

    Param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $FileMask
    )

    Begin {
        $sessionObject = New-Object -TypeName WinSCP.Session
    }

    Process {
        foreach ($item in $FileMask) {
            try {
                $sessionObject.EscapeFileMask($item)
            } catch {
                Write-Error -Message $_.ToString()
            }
        }
    }
    
    End {
        $sessionObject.Dispose()
    }
}
