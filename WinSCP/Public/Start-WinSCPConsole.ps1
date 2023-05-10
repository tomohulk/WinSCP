function Start-WinSCPConsole {

    [CmdletBinding(
        ConfirmImpact = "Medium",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/Start-WinSCPConsole",
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    param()

    $process = "$PSScriptRoot\..\bin\WinSCP.exe"
    $arguments = "/Console"

    $shouldProcess = $PSCmdlet.ShouldProcess(
        $process
    )

    if ($shouldProcess) {
        Start-Process -FilePath $process -ArgumentList $arguments -Wait
    }
}
