function Start-WinSCPConsole {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Start-WinSCPConsole",
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    param()

    $process = "$PSScriptRoot\..\bin\WinSCP.exe"
    $args = "/Console"

    $shouldProcess = $PSCmdlet.ShouldProcess(
        $process
    )

    if ($shouldProcess) {
        Start-Process -FilePath $process -ArgumentList $args -Wait
    }
}
