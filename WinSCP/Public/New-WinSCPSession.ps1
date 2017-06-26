function New-WinSCPSession {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/New-WinSCPSession.html"
    )]
    [OutputType(
        [WinSCP.Session]
    )]
    
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [WinSCP.SessionOptions]
        $SessionOption,

        [Parameter()]
        [PSCredential]
        $ExecutableProcessCredential,

        [Parameter()]
        [ValidateScript({
            if (Test-Path -Path (Split-Path -Path $_ -Parent)) {
                return $true
            } else {
                throw "Path not found $(Split-Path -Path $_ -Parent)."
            } 
        })]
        [String]
        $DebugLogPath,

        [Parameter()]
        [ValidateRange(
            0,2
        )]
        [Int]
        $DebugLogLevel = 0,

        [Parameter()]
        [ValidateScript({
            if (Test-Path -Path (Split-Path -Path $_ -Parent)) {
                return $true
            } else {
                throw "Path not found $(Split-Path -Path $_ -Parent)."
            } 
        })]
        [String]
        $SessionLogPath,

        [Parameter()]
        [TimeSpan]
        $ReconnectTime = (New-TimeSpan -Seconds 120),

        [Parameter()]
        [ScriptBlock]
        $FileTransferProgress
    )

    # Create WinSCP.Session and WinSCP.SessionOptions Objects, parameter values will be assigned to matching object properties.
    $session = New-Object -TypeName WinSCP.Session -Property @{
        ExecutablePath = "$PSScriptRoot\..\bin\winscp.exe"
    }

    $executableProcessCredentialUsed = $PSBoundParameters.ContainsKey(
        "ExecutableProcessCredential"
    )
    if ($executableProcessCredentialUsed) {
        $PSBoundParameters.Add(
            "ExecutableProcessUserName", $ExecutableProcessCredential.UserName
        )
        $PSBoundParameters.Add(
            "ExecutableProcessPassword", $ExecutableProcessCredential.Password
        )
    }

    try {
        # Enumerate each parameter.
        $sessionObjectProperties = $session |
            Get-Member -MemberType Property |
                Select-Object -ExpandProperty Name
        $keys = ($PSBoundParameters.Keys).Where({
            $_ -in $sessionObjectProperties
        })

        foreach ($key in $keys) {
            $session.$key = $PSBoundParameters.$key
        }

		# Add FileTransferProgress ScriptBlock if present.
        $fileTransferProgressUsed = $PSBoundParameters.ContainsKey(
            "FileTransferProgress"
        )
        if ($fileTransferProgressUsed) {
            $session.Add_FileTransferProgress(
                $FileTransferProgress
            )
        }
    } catch {
        $PSCmdlet.ThrowTerminatingError(
            $_
        )
    }

    try {
        # Open the WinSCP.Session object using the WinSCP.SessionOptions object.
        $session.Open(
            $SessionOption
        )

        # Set the default -WinSCPSession Parameter Value for other cmdlets.
        (Get-Command -Module WinSCP -ParameterName WinSCPSession).ForEach({
            $Global:PSDefaultParameterValues.Remove(
                "$($_.Name):WinSCPSession"
            )
            $Global:PSDefaultParameterValues.Add(
                "$($_.Name):WinSCPSession", $session
            )
        })

        # Return the WinSCP.Session object.
        Write-Output -InputObject $session
    } catch {
        $PSCmdlet.WriteError(
            $_
        )

        $session.Dispose()
    }
}
