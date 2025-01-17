﻿function New-WinSCPSession {

    [CmdletBinding(
        ConfirmImpact = "Low",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/New-WinSCPSession",
        PositionalBinding = $false,
        SupportsShouldProcess = $true
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
        [String]
        $AdditionalExecutableArguments = $null,

        [Parameter()]
        [ValidateRange(
            -1,2
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
        $DebugLogPath,

        [Parameter()]
        [Bool]
        $DisableVersionCheck = $false,

        [Parameter()]
        [ValidateScript({
            if (Test-Path -Path $_) {
                return $true
            } else {
                throw "Path not found $_."
            }
        })]
        [String]
        $ExecutablePath = "$PSScriptRoot\..\bin\winscp.exe",

        [Parameter()]
        [PSCredential]
        $ExecutableProcessCredential,

        [Parameter()]
        [TimeSpan]
        $ReconnectTime = (New-TimeSpan -Seconds 120),

        [Parameter()]
        [ValidateScript({
            if (Test-Path -Path (Split-Path -Path $_ -Parent)) {
                return $true
            } else {
                throw "Path not found $(Split-Path -Path $_ -Parent)."
            }
        })]
        [String]
        $SessionLogPath = $null,

        [Parameter()]
        [ValidateScript({
            if (Test-Path -Path (Split-Path -Path $_ -Parent)) {
                return $true
            } else {
                throw "Path not found $(Split-Path -Path $_ -Parent)."
            }
        })]
        [String]
        $XmlLogPath = $null,

        [Parameter()]
        [Bool]
        $XmlLogPreserve = $false
    )

    begin {
        # Create WinSCP.Session, parameter values will be assigned to matching object properties.
        $session = New-Object -TypeName WinSCP.Session
    }

    process {
        $shouldProcess = $PSCmdlet.ShouldProcess(
            $session
        )
        if ($shouldProcess) {
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
                foreach ($parameter in ([System.Management.Automation.CommandMetadata]::new($MyInvocation.MyCommand).Parameters.GetEnumerator())) {
                    if (-not ($PSBoundParameters.ContainsKey($parameter.Key))) {
                        if ($value = $ExecutionContext.SessionState.PSVariable.GetValue($parameter.Key)) {
                            $PSBoundParameters[$parameter.Key] = $value
                        }
                    }
                }

                $keys = ($PSBoundParameters.Keys).Where({
                    $_ -in ($session | Get-Member -MemberType Property | Select-Object -ExpandProperty Name)
                })

                foreach ($key in $keys) {
                    $session.$key = $PSBoundParameters.$key
                }
            } catch {
                $PSCmdlet.ThrowTerminatingError(
                    $_
                )
            }
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

            # Append the host name to the WinSCP.Session object.
            Add-Member -InputObject $session -NotePropertyName "HostName" -NotePropertyValue $SessionOption.HostName

            # Return the WinSCP.Session object.
            Write-Output -InputObject $session
        } catch {
            $PSCmdlet.WriteError(
                $_
            )

            $session.Dispose()
        }
    }
}
