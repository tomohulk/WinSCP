<#
.SYNOPSIS
    Sets options for file transfers.
.DESCRIPTION
    Sets available options for file transfers between the client and server.
.INPUTS
    None.
.OUTPUTS
    WinSCP.TransferOptions.
.PARAMETER FileMask
    http://winscp.net/eng/docs/file_mask
.PARAMETER FilePermissions
    Permissions to applied to a remote file (used for uploads only).
.PARAMETER State
    Sets what files will be transferred with resume support/to temporary filename. Use TransferResumeSupportState.Default for built-in default (currently all files above 100 KB), TransferResumeSupportState.On for all files, TransferResumeSupportState.Off for no file (turn off) or TransferResumeSupportState.Smart for all files above threshold (see Threshold).
.PARAMETER Threshold
    Threshold (in KB) for State.Smart mode.
.PARAMETER SpeedLimit
     Limit transfer speed (in KB/s).
.PARAMETER PreserveTimeStamp
    Preserve timestamp (set last write time of destination file to that of source file). Defaults to true.
.PARAMETER TransferMode
    Possible values are TransferMode.Binary (default), TransferMode.Ascii and TransferMode.Automatic (based on file extension).
.EXAMPLE
    PS C:\> New-WinSCPTransferOption -PreserveTimeStamp:$false -TransferMode Binary

    PreserveTimestamp : False
    FilePermissions   : 
    TransferMode      : Binary
    FileMask          : 
    ResumeSupport     : default
    SpeedLimit        : 0
.EXAMPLE
    PS C:\> New-WinSCPTransferOption -FilePermissions (New-WinSCPFilePermissions -GroupExecute -OtherRead)

    PreserveTimestamp : True
    FilePermissions   : 
    TransferMode      : Binary
    FileMask          : 
    ResumeSupport     : default
    SpeedLimit        : 0
.NOTES
    New-WinSCPTransferOption is equivialnt to New-Object -TypeName WinSCP.TransferOptions.
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_transferoptions
#>
Function New-WinSCPTransferOption {
    
    [OutputType([WinSCP.TransferOptions])]

    Param (
        [Parameter()]
        [String]
        $FileMask = $null,

        [Parameter()]
        [WinSCP.FilePermissions]
        $FilePermissions = $null,

        [Parameter()]
        [Switch]
        $PreserveTimeStamp,

        [Parameter()]
        [WinSCP.TransferResumeSupportState]
        $State = (New-Object -TypeName WinSCP.TransferResumeSupportState),

        [Parameter()]
        [Int]
        $Threshold = 100,
        
        [Parameter()]
        [Int]
        $SpeedLimit = 0,

        [Parameter()]
        [WinSCP.TransferMode]
        $TransferMode = (New-Object -TypeName WinSCP.TransferMode)
    )

    Begin {
        $transferOptions = New-Object -TypeName WinSCP.TransferOptions

        foreach ($key in $PSBoundParameters.Keys) {
            try {
                if ($key -eq 'State' -or $key -eq 'Threshold') {
                    $transferOptions.ResumeSupport.$($key) = $PSBoundParameters.$($key)
                } else {
                    $transferOptions.$($key) = $PSBoundParameters.$($key)
                }
            } catch {
                Write-Error -Message $_.ToString()
            }
        }
    }

    End {
        return $transferOptions
    }
}