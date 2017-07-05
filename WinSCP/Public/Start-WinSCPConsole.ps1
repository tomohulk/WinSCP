function Start-WinSCPConsole {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/Start-WinSCPConsole.html"
    )]
    [OutputType(
        [Void]
    )]

    param()

    $process = "$PSScriptRoot\..\bin\WinSCP.exe"
    $args = "/Console"

    Start-Process -FilePath $process -ArgumentList $args -Wait
}
