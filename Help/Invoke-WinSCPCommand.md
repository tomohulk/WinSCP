---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/Invoke-WinSCPCommand
schema: 2.0.0
---

# Invoke-WinSCPCommand

## SYNOPSIS
Executes command on the remote server.

## SYNTAX

```
Invoke-WinSCPCommand -WinSCPSession <Session> -Command <String[]> [<CommonParameters>]
```

## DESCRIPTION
Executes command on the remote server.

## EXAMPLES

### Example 1
```
PS C:\> Invoke-WinSCPCommand -Command "HASH ./TestDoc.txt"


Output      : 213 MD5 ae661d08d1ca1576a6efcb82b7bc502f
ErrorOutput :
ExitCode    : 0
Failures    : {}
IsSuccess   : True
```

## PARAMETERS

### -Command
Command to execute.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
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

### WinSCP.CommandExecutionResult

## NOTES

## RELATED LINKS

[WinSCP reference](https://winscp.net/eng/docs/library_session_executecommand)

