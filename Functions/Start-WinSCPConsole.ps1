Function Start-WinSCPConsole {
    [OutputType(
        [Void]
    )]

    Param()

    $process = "$(Split-Path -Path $MyInvocation.MyCommand.Module.Path)\NeededAssemblies\WinSCP.exe"
    $args = '/Console'

    Start-Process -FilePath $process -ArgumentList $args -Wait
}