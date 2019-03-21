---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/Remove-WinSCPSession
schema: 2.0.0
---

# Remove-WinSCPSession

## SYNOPSIS
Closes and disposes the WinSCP.Session object.

## SYNTAX

```
Remove-WinSCPSession -WinSCPSession <Session> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Closes and disposes the WinSCP.Session object.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Remove-WinSCPSession
```

## PARAMETERS

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

### -WinSCPSession
It represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

```yaml
Type: Session
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### WinSCP.Session

## OUTPUTS

### System.Void

## NOTES

## RELATED LINKS

[WinSCP reference](https://winscp.net/eng/docs/library_session_close)

