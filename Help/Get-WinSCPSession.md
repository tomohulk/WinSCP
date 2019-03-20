---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/Get-WinSCPSession
schema: 2.0.0
---

# Get-WinSCPSession

## SYNOPSIS
Gets a WinSCP.Session object.

## SYNTAX

```
Get-WinSCPSession [-WinSCPSession <Session>] [<CommonParameters>]
```

## DESCRIPTION
Gets a WinSCP.Session object.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Get-WinSCPSession

Opened       Timeout HostName
------       ------- --------
True        00:01:00 ftp.dotps1.github.io
```

## PARAMETERS

### -WinSCPSession
It represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

```yaml
Type: Session
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### WinSCP.Session

## OUTPUTS

### WinSCP.Session

## NOTES
When creating/opeing a WinSCP.Session with the New-WinSCPSession cmdlet, the WinSCPSession PSDefaultParameterValue is set in all other commands in this module.
This command is useful to retreive that object if necessary.

## RELATED LINKS
