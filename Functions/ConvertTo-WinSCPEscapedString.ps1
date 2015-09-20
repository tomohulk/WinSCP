Function ConvertTo-WinSCPEscapedString {
    [OutputType([String])]

    Param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [String]
        $FileMask
    )

    Begin {
        $sessionObject = New-Object -TypeName WinSCP.Session
    }

    Process {
        try {
            return ($sessionObject.EscapeFileMask($FileMask))
        } catch {
            Write-Error -Message $_.ToString()
        }
    }
    
    End {
        $sessionObject.Dispose()
    }
}