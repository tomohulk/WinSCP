---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/Test-WinSCPPath
schema: 2.0.0
---

# Test-WinSCPPath

## SYNOPSIS
Checks for existence of remote file or directory.

## SYNTAX

```
Test-WinSCPPath -WinSCPSession <Session> [-Path] <String[]> [<CommonParameters>]
```

## DESCRIPTION
Checks for existence of remote file or directory.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Test-WinSCPPath -Path /
True
```

## PARAMETERS

### -Path
Full path to remote file.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -WinSCPSession
It represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

```yaml
Type: Session
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### WinSCP.Session
System.String\[\]

## OUTPUTS

### System.Boolean

## NOTES

## RELATED LINKS

[WinSCP reference:](https://winscp.net/eng/docs/library_session_fileexists)

