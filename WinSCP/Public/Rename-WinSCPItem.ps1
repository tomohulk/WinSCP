function Rename-WinSCPItem {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Rename-WinSCPItem",
        PositionalBinding = $false
    )]
    [OutputType(
        [Void]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript({
            if ($_.Opened) {
                return $true
            } else {
                throw "The WinSCP Session is not in an Open state."
            }
        })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [String]
        $Path,

        [Parameter(
            Mandatory = $true
        )]
        [String]
        $NewName,

        [Parameter()]
        [Switch]
        $PassThru
    )

    process {
        $parent = ( Split-Path -Path $Path -Parent ).Replace(
            [System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar
        )
        $destination = [WinSCP.RemotePath]::CombinePaths(
            $parent, $NewName
        )

        Move-WinSCPItem -WinSCPSession $WinSCPSession -Path $Path -Destination $destination -PassThru:$PassThru.IsPresent
    }
}
