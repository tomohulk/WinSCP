function New-WinSCPSessionOption {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/New-WinSCPSessionOption.html"
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
        [Switch]
        $GiveUpSecurityAndAcceptAnySshHostKey,

        [Parameter()]
        [Switch]
        $GiveUpSecurityAndAcceptAnyTlsHostCertificate,

        [Parameter(
            Mandatory = $true
        )]
        [String]
        $HostName,

        [Parameter()]
        [Int]
        $PortNumber = 0,

        [Parameter()]
        [WinSCP.Protocol]
        $Protocol = (New-Object -TypeName WinSCP.Protocol),

        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $SshHostKeyFingerprint,

        [Parameter()]
        [ValidateScript({ 
            if (Test-Path -Path $_) { 
                return $true
            } else { 
                throw "Unable to find part of Path: '$_'." 
            } 
        })]
        [String]
        $SshPrivateKeyPath,

        [Parameter()]
        [SecureString]
        $SshPrivateKeySecurePassphrase,

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
        $WebdavRoot,

        [Parameter()]
        [HashTable]
        $RawSetting
    )

    $sessionOptions = New-Object -TypeName WinSCP.SessionOptions

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
            Select-Object -ExpandProperty Path
    }

    # Convert SshPrivateKeySecurePasspahrase to plain text and set it to the corresponding SessionOptions property.
    $sshPrivateKeySecurePassphraseUsed = $PSBoundParameters.ContainsKey(
        "SshPrivateKeySecurePassphrase"
    )
    if ($sshPrivateKeySecurePassphraseUsed) {
		try {
			$SshPrivateKeySecurePasspahrase = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(
                    $SshPrivateKeySecurePassphrase
                )
            )
		} catch {
            $PSCmdlet.ThrowTerminatingError(
                $_
            )
		}
    }

    # Enumerate each parameter.
    try {
        $sessionOptionObjectProperties = $sessionOptions |
            Get-Member -MemberType Property |
                Select-Object -ExpandProperty Name
        $keys = ($PSBoundParameters.Keys).Where({
            $_ -in $sessionOptionObjectProperties
        })
        
        foreach ($key in $keys) {
            $sessionOptions.$key = $PSBoundParameters.$key
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

    Write-Output -InputObject $sessionOptions
}
