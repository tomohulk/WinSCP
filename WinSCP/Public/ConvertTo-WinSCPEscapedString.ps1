function ConvertTo-WinSCPEscapedString {

    [CmdletBinding(
        ConfirmImpact = "Low",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/ConvertTo-WinSCPEscapedString",
        PositionalBinding = $false
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

    process {
        foreach ($fileMaskValue in $FileMask) {
            try {
                $output = [WinSCP.RemotePath]::EscapeFileMask(
                    $fileMaskValue
                )

                Write-Output -InputObject $output
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
                continue
            }
        }
    }
}
