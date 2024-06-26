function New-WinSCPSessionOption {

    [CmdletBinding(
        ConfirmImpact = "Low",
        HelpUri = "https://github.com/tomohulk/WinSCP/wiki/New-WinSCPSessionOption",
        PositionalBinding = $false,
        SupportsShouldProcess = $true
    )]
    [OutputType(
        [WinSCP.SessionOptions]
    )]

    param (
        [Parameter()]
        [ValidateNotNull()]
        [PSCredential]
        $Credential = [PSCredential]::new(
            "anonymous", [SecureString]::new()
        ),

        [Parameter()]
        [WinSCP.FtpMode]
        $FtpMode = (New-Object -TypeName WinSCP.FtpMode),

        [Parameter()]
        [WinSCP.FtpSecure]
        $FtpSecure = (New-Object -TypeName WinSCP.FtpSecure),

        [Parameter()]
        [Bool]
        $GiveUpSecurityAndAcceptAnyTlsHostCertificate = $false,

        [Parameter(
            Mandatory = $true
        )]
        [Alias(
            "ComputerName"
        )]
        [String]
        $HostName,

        [Parameter()]
        [Int]
        $PortNumber = 0,

        [Parameter()]
        [WinSCP.Protocol]
        $Protocol = (New-Object -TypeName WinSCP.Protocol),

        [Parameter()]
        [SecureString]
        $SecurePrivateKeyPassphrase,

        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $SshHostKeyFingerprint,

        [Parameter()]
        [WinSCP.SshHostKeyPolicy]
        $SshHostKeyPolicy = (New-Object -TypeName WinSCP.SshHostKeyPolicy),

        [Parameter()]
        [ValidateScript({
            if (Test-Path -Path $_) {
                if ((Get-Item -Path $_).PSIsContainer) {
                    throw "Target is not a file: '$_'."
                } else {
                    return $true
                }
            } else {
                throw "Unable to find part of Path: '$_'."
            }
        })]
        [String]
        $SshPrivateKeyPath,

        [Parameter()]
        [ValidateScript({
            if (Test-Path -Path $_) {
                if ((Get-Item -Path $_).PSIsContainer) {
                    throw "Target is not a file: '$_'."
                } else {
                    return $true
                }
            } else {
                throw "Unable to find part of Path: '$_'."
            }
        })]
        [String]
        $TlsClientCertificatePath,

        [Parameter()]
        [String]
        $TlsHostCertificateFingerprint,

        [Parameter()]
        [TimeSpan]
        $Timeout = (New-TimeSpan -Seconds 15),

        [Parameter()]
        [Switch]
        $WebdavSecure,

        [Parameter()]
        [String]
        $RootPath,

        [Parameter()]
        [HashTable]
        $RawSetting
    )

    begin {
        $sessionOption = New-Object -TypeName WinSCP.SessionOptions
    }

    process {
        $shouldProcess = $PSCmdlet.ShouldProcess(
            $sessionOption
        )
        if ($shouldProcess) {
            # Convert PSCredential Object to match names of the WinSCP.SessionOptions Object.
            # Remove the parameter "Credential", that is not a valid property of the WinSCP.SessionObject.
            $PSBoundParameters.Add(
                "UserName", $Credential.UserName
            )
            $PSBoundParameters.Add(
                "SecurePassword", $Credential.Password
            )

            # Resolve Full Path, WinSCP.exe does not like dot sourced path for the Certificate.
            $sshPrivateKeyPathUsed = $PSBoundParameters.ContainsKey(
                "SshPrivateKeyPath"
            )
            if ($sshPrivateKeyPathUsed) {
                $PSBoundParameters.SshPrivateKeyPath = Resolve-Path -Path $SshPrivateKeyPath |
                    Select-Object -ExpandProperty ProviderPath
            }

            $tlsClientCertificatePathUsed = $PSBoundParameters.ContainsKey(
                "TlsClientCertificatePath"
            )
            if ($tlsClientCertificatePathUsed) {
                $PSBoundParameters.TlsClientCertificatePath = Resolve-Path -Path $TlsClientCertificatePath |
                    Select-Object -ExpandProperty ProviderPath
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
                    $_ -in ($sessionOption | Get-Member -MemberType Property | Select-Object -ExpandProperty Name)
                })

                foreach ($key in $keys) {
                    $sessionOption.$key = $PSBoundParameters.$key
                }
            } catch {
                $PSCmdlet.ThrowTerminatingError(
                    $_
                )
            }

            # Enumerate raw settings and add the options to the WinSCP.SessionOptions object.
            foreach ($key in $RawSetting.Keys) {
                $sessionOptions.AddRawSettings(
                    $key, $RawSetting[$key]
                )
            }

            Write-Output -InputObject $sessionOption
        }
    }
}
