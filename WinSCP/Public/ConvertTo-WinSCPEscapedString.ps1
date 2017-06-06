function ConvertTo-WinSCPEscapedString {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/ConvertTo-WinSCPEscapedString.html"
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
        $sessionObject = New-Object -TypeName WinSCP.Session
    }

    process {
        foreach ($fileMaskValue in $FileMask) {
            try {
                $sessionObject.EscapeFileMask(
                    $fileMaskValue
                )
            } catch {
                Write-Error -Message $_.ToString()
            }
        }
    }
    
    end {
        $sessionObject.Dispose()
    }
}
