function Rename-WinSCPItem {

    [CmdletBinding(
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Rename-WinSCPItem"
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
            Mandatory = $true
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
        try {
            $item = Get-WinSCPItem -WinSCPSession $WinSCPSession -Path (Format-WinSCPPathString -Path $($Path)) -ErrorAction Stop
            
            if ($NewName -contains "/" -or $NewName -contains "\") {
                $NewName = $NewName.Substring(
                    $NewName.LastIndexOfAny(
                        "/\"
                    )
                )
            }

            $parentPath = (Split-Path -Path $item.FullName -Parent).Replace(
                "\", "/"
            )
            $newPath = $WinSCPSession.CombinePaths(
                $parentPath , $NewName
            )

            $WinSCPSession.MoveFile(
                $item.FullName, $newPath
            )

            if ($PassThru.IsPresent) {
                Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $newPath
            }
        } catch {
            $PSCmdlet.WriteError(
                $_
            )
        }
    }
}
