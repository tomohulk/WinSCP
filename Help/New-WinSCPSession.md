---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/New-WinSCPSession
schema: 2.0.0
---

# New-WinSCPSession

## SYNOPSIS
This is the main interface class of the WinSCP assembly.

## SYNTAX

```
New-WinSCPSession [-SessionOption] <SessionOptions> [-AdditionalExecutableArguments <String>]
 [-DebugLogLevel <Int32>] [-DebugLogPath <String>] [-ExecutableProcessCredential <PSCredential>]
 [-ReconnectTime <TimeSpan>] [-SessionLogPath <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This is the main interface class of the WinSCP assembly.
It represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> New-WinSCPSession -SessionOption (New-WinSCPSessionOption -HostName ftp.dotps1.github.io -Protocol Ftp)

Opened       Timeout HostName
------       ------- --------
True        00:01:00 ftp.dotps1.github.io
```

### EXAMPLE 2
```
PS C:\> $credential = Get-Credential
PS C:\> $sshHostKeyFingerprint = "ssh-dss 2048 01:aa:23:bb:45:cc:67:dd:89:ee:01:ff:23:aa:45:bb"
PS C:\> $sessionOption = New-WinSCPSessionOption -HostName ftp.dotps1.github.io -SshHostKeyFingerprint $sshHostKeyFingerprint -Credential $credential
PS C:\> New-WinSCPSession -SessionOption $sessionOption

Opened       Timeout HostName
------       ------- --------
True        00:01:00 ftp.dotps1.github.io
```

## PARAMETERS

### -SessionOption
Defines information to allow an automatic connection and authentication of the session.
Returned from the New-WinSCPSessionOption command.

```yaml
Type: SessionOptions
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -AdditionalExecutableArguments
Additional command-line arguments to be passed to winscp.com.
In general, this should be left with default null.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DebugLogLevel
Logging level of debug log to.
The default value is 0.
The maximal logging level is 2.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DebugLogPath
Path to store assembly debug log to.
Default null means, no debug log file is created.
See also SessionLogPath.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Null
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExecutableProcessCredential
If the .NET process is running in an impersonated environment, you need to provide credentials of the impersonated account, so that the winscp.exe process can be started with the same privileges.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReconnectTime
Sets time limit in seconds to try reconnecting broken sessions.
Default is 120 seconds.
Use TimeSpan.MaxValue to remove any limit.

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SessionLogPath
Path to store session log file to.
Default null means, no session log file is created.
See also DebugLogPath.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Null
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### WinSCP.SessionOptions

## OUTPUTS

### WinSCP.Session

## NOTES

## RELATED LINKS

[WinSCP reference:](https://winscp.net/eng/docs/library_session_open)

