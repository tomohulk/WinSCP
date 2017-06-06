Function ConvertTo-WinSCPEscapedString {
    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/ConvertTo-WinSCPEscapedString.html"
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
