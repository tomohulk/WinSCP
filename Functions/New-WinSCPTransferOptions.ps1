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
                $transferOptions.$($key) = $PSBoundParameters.$($key)
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