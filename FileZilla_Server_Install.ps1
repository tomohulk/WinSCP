$CurrentErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Stop"

try {
    $is64Bit = ( Get-WmiObject -Class Win32_Processor ).AddressWidth -eq 64
    $programFiles = $env:ProgramFiles
    if ($is64Bit -and $programFiles -notmatch "x86") {
        $programFiles = "$programFiles (x86)"
    }
    $installDirectory = Join-Path -Path $programFiles -ChildPath "FileZilla Server"
    if (-not ( Test-Path -Path $installDirectory )) {
        New-Item -Path $installDirectory -ItemType Directory |
            Out-Null
    }

    $ftpRoot = "$env:SystemDrive\temp\ftproot"
    if (-not ( Test-Path -Path $ftpRoot )) {
        New-Item -Path $ftpRoot -ItemType Directory |
            Out-Null
    }

    Copy-Item -Path "$pwd\FileZilla*.xml" -Destination $installDirectory -Force

    Start-Process -FilePath "$pwd\FileZilla*.exe" -ArgumentList "/S" -Wait
} catch {
    throw "$($_.Exception.Message)"
}

$ErrorActionPreference = $CurrentErrorActionPreference
return 0
