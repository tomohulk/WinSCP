#requires -Modules PSAppVeyor

[CmdletBinding()]
[OutputType()]

param ()

$uri = "https://winscp.net"

# Current version of dll in PowerShell build.
[Version]$currentVersion = (Get-Item -Path "${pwd}\WinSCP\lib\netstandard2.0\WinSCPnet.dll").VersionInfo.ProductVersion

try {
    $payloadName = ((Invoke-WebRequest -Uri "${uri}/eng/downloads.php" -UseBasicParsing -ErrorAction Stop).Links | Select-String -Pattern "WinSCP-.*?\d+-Automation\.zip").Matches.Value
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
        Write-Error $_
        exit
    }

    try {
        Move-Item -Path "${env:TEMP}\WinSCP\*.txt" -Destination "${pwd}\WinSCP\en-US\" -Force -Confirm:$false -ErrorAction Stop
        Move-Item -Path "${env:TEMP}\WinSCP\*.exe" -Destination "${pwd}\WinSCP\bin\" -Force -Confirm:$false -ErrorAction Stop
        Move-Item -Path "${env:TEMP}\WinSCP\net40\*.dll" -Destination "${pwd}\WinSCP\lib\net40\" -Force -Confirm:$false -ErrorAction Stop
        Move-Item -Path "${env:TEMP}\WinSCP\netstandard2.0\*.dll" -Destination "${pwd}\WinSCP\lib\netstandard2.0\" -Force -Confirm:$false -ErrorAction Stop
    } catch {
        Write-Error $_
        exit
    }

    # Update AppVeyor yml build info.
    $yml = Get-Content -Path ${pwd}\appveyor.yml
    $yml = $yml -replace ($yml | Select-String -Pattern "\d.*\d").Matches.Value[0], $publishedVersion
    Set-Content -Path ${pwd}\appveyor.yml -Value $yml
    Update-AppVeyorProjectBuildNumber -AccountName dotps1 -ProjectName WinSCP -BuildNumber 0

    # TODO
    # Ensure PlatyPS is updated to the latest module version.
    # Recompile help files.

    # Clean up downloaded and extracted files.
    Remove-Item -Path "${env:TEMP}\$payloadName" -Force -Confirm:$false
    Remove-Item -Path "${env:TEMP}\WinSCP" -Recurse -Force -Confirm:$false

    try {
        git add .
        git commit -a -m "Build - Updating WinSCP Core to $publishedVersion."
        git push
    } catch {
        Write-Error $_
        exit
    }
}
