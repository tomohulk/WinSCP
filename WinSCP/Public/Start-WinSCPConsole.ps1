Function Start-WinSCPConsole {
    [CmdletBinding(
        ConfirmImpact = "None",
        HelpUri = 'https://github.com/dotps1/WinSCP/wiki/Start-WinSCPConsole',
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    Param()

    $process = "$PSScriptRoot\..\bin\WinSCP.exe"
    $args = '/Console'

    if ($PSCmdlet.ShouldProcess($process)) {
        Start-Process -FilePath $process -ArgumentList $args -Wait
    }
}
