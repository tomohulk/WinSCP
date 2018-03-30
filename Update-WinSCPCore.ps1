#requires -Modules platyPS

[CmdletBinding()]
[OutputType()]


$uri = "https://winscp.net"

# Current version of dll in PowerShell build.
[Version]$currentVersion = (Get-Item -Path "${pwd}\WinSCP\lib\WinSCPnet.dll").VersionInfo.ProductVersion

try {
    $payloadName = ((Invoke-WebRequest -Uri "${uri}/eng/downloads.php" -UseBasicParsing -ErrorAction Stop).Links | Select-String -Pattern "WinSCP-.*?-Automation\.zip").Matches.Value
} catch {
    $PSCmdlet.ThrowTerminatingError(
        $_
    )
    exit
}

# Lastest version of dll on WinSCP.net.
[Version]$publishedVersion = ($payloadName | Select-String -Pattern "\d.*\d").Matches.Value

if ($publishedVersion -gt $currentVersion) {
    try {
        $payloadPage = Invoke-WebRequest -Uri "${uri}/download/${payloadName}" -UseBasicParsing
        $payload = ($payloadPage.Links | Select-String -Pattern "https://cdn.+?(?=`")").Matches.Value[0]

        $downloader = New-Object -TypeName System.Net.WebClient
        $downloader.DownloadFile(
            $payload, "${env:TEMP}\$payloadName"
        )

        Unblock-File -Path "${env:TEMP}\$payloadName"
        Expand-Archive -Path "${env:TEMP}\$payloadName" -DestinationPath "${env:TEMP}\WinSCP\"

        $downloader.Dispose()
    } catch {
        $PSCmdlet.ThrowTerminatingError(
            $_
        )
        exit
    }

    try {
        Move-Item -Path "${env:TEMP}\WinSCP\*.txt" -Destination "${pwd}\WinSCP\en-US\" -Force -Confirm:$false -ErrorAction Stop
        Move-Item -Path "${env:TEMP}\WinSCP\*.exe" -Destination "${pwd}\WinSCP\bin\" -Force -Confirm:$false -ErrorAction Stop
        Move-Item -Path "${env:TEMP}\WinSCP\*.dll" -Destination "${pwd}\WinSCP\lib\" -Force -Confirm:$false -ErrorAction Stop
    } catch {
        $PSCmdlet.ThrowTerminatingError(
            $_
        )
        exit
    }

    # Clean up downloaded and extracted files.
    Remove-Item -Path "${env:TEMP}\$payloadName" -Force -Confirm:$false
    Remove-Item -Path "${env:TEMP}\WinSCP" -Recurse -Force -Confirm:$false

    try {
        git add .
        git commit -a -m "Build - Updating WinSCP Core to $publishedVersion."
        git push
    } catch {
        $PSCmdlet.ThrowTerminatingError(
            $_
        )
        exit
    }
}
