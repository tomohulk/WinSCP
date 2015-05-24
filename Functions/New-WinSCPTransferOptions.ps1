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
    PS C:\> New-WinSCPTransferOptions -PreserveTimeStamp -TransferMode Binary

    PreserveTimestamp : True
    FilePermissions   : 
    TransferMode      : Binary
    FileMask          : 
    ResumeSupport     : default
.EXAMPLE
    PS C:\> New-WinSCPTransferOptions -FilePermissions (New-WinSCPFilePermissions -GroupExecute -OtherRead)

    PreserveTimestamp : True
    FilePermissions   : -----xr--
    TransferMode      : Binary
    FileMask          : 
    ResumeSupport     : default
.NOTES
.LINK
    http://dotps1.github.io/WinSCP
.LINK
    http://winscp.net/eng/docs/library_transferoptions
#>
Function New-WinSCPTransferOptions
{
    [CmdletBinding()]
    [OutputType([WinSCP.TransferOptions])]

    Param
    (
        [Parameter()]
        [ValidateScript({ -not ([String]::IsNullOrWhiteSpace($_)) })]
        [String]
        $FileMask,

        [Parameter()]
        [WinSCP.FilePermissions]
        $FilePermissions,

        [Parameter()]
        [Switch]
        $PreserveTimeStamp,

        [Parameter()]
        [WinSCP.TransferResumeSupportState]
        $State,

        [Parameter()]
        [Int]
        $Threshold,
        
        [Parameter()]
        [Int]
        $SpeedLimit,

        [Parameter()]
        [WinSCP.TransferMode]
        $TransferMode
    )

    Begin
    {
        $transferOptions = New-Object -TypeName WinSCP.TransferOptions

        foreach ($key in $PSBoundParameters.Keys)
        {
            try
            {
                if ($key -eq 'State' -or $key -eq 'Threshold')
                {
                    $transferOptions.ResumeSupport.$($key) = $PSBoundParameters.$($key)
                }
                else
                {
                    $transferOptions.$($key) = $PSBoundParameters.$($key)
                }
            }
            catch [System.Exception]
            {
                throw $_
            }
        }
    }

    End
    {
        return $transferOptions
    }
}