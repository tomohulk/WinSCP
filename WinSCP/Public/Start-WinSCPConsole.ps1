function Start-WinSCPConsole {

    [CmdletBinding(
        ConfirmImpact = "None",
        HelpUri = "https://dotps1.github.io/WinSCP/Start-WinSCPConsole.html",
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [Void]
    )]

    param()

    $process = "$PSScriptRoot\..\bin\WinSCP.exe"
    $args = "/Console"

    Start-Process -FilePath $process -ArgumentList $args -Wait
}
