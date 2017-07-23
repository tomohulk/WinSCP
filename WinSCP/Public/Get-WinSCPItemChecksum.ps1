function Get-WinSCPItemChecksum {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Get-WinSCPItemChecksum.html",
        PositionalBinding = $false
    )]
    [OutputType(
        [Array]
    )]

    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
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
            Position = 1
        )]
        [String]
        $Algorithm,

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path
    )

    process {
        foreach ($pathValue in ( Format-WinSCPPathString -Path $Path )) {
            $pathExists = Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $pathValue 
            if (-not $pathExists) {
                Write-Error -Message "Cannot find path '$pathValue' because it does not exist."
                continue
            }

            try {
                $output = $WinSCPSession.CalculateFileChecksum(
                    $Algorithm, $pathValue
                )

                Write-Output -InputObject $output
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
            }
        }
    }   
}
