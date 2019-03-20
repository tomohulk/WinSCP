function Start-WinSCPConsole {

    [CmdletBinding(
        ConfirmImpact = "None",
        HelpUri = "https://github.com/dotps1/WinSCP/wiki/Start-WinSCPConsole",
        PositionalBinding = $false
    )]
    [OutputType(
        [Void]
    )]

    param()

    $process = "$PSScriptRoot\..\bin\WinSCP.exe"
    $args = "/Console"

    Start-Process -FilePath $process -ArgumentList $args -Wait
}
