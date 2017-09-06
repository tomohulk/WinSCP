function Start-WinSCPConsole {

    [CmdletBinding(
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Start-WinSCPConsole"
    )]
    [OutputType(
        [Void]
    )]

    param()

    $process = "$PSScriptRoot\..\bin\WinSCP.exe"
    $args = "/Console"

    Start-Process -FilePath $process -ArgumentList $args -Wait
}
