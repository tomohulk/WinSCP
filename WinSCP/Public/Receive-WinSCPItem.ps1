Function Receive-WinSCPItem {
    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Receive-WinSCPItem.html"
    )]
    [OutputType(
        [WinSCP.TransferOperationResult]
    )]

    Param (
            [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript({ 
            if ($_.Opened) { 
                return $true 
            } else { 
                throw 'The WinSCP Session is not in an Open state.'
            }
        })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path,

        [Parameter()]
        [String]
        $Destination = $pwd,

        [Parameter()]
        [Switch]
        $Remove,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = (
            New-Object -TypeName WinSCP.TransferOptions
        )
    )

    Begin {
        $sessionValueFromPipeLine = $PSBoundParameters.ContainsKey('WinSCPSession')

        if ((Get-Item -Path $Destination -ErrorAction SilentlyContinue).PSIsContainer -and -not $Destination.EndsWith('\')) {
            $Destination = "$Destination\"
        }
    }

    Process {
        foreach ($item in (Format-WinSCPPathString -Path $($Path))) {
            try {
                $result = $WinSCPSession.GetFiles(
                    $item, $Destination, $Remove.IsPresent, $TransferOptions
                )

                if ($result.IsSuccess) {
                    Write-Output -InputObject $result
                } else {
                    $result.Failures[0] | 
                        Write-Error
                }
            } catch {
                Write-Error -Message $_.ToString()
            }
        }
    }

    End {
        if (-not ($sessionValueFromPipeLine)) {
            Remove-WinSCPSession -WinSCPSession $WinSCPSession
        }
    }
}
