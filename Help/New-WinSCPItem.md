---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/New-WinSCPItem
schema: 2.0.0
---

# New-WinSCPItem

## SYNOPSIS
Creates a new item on a remote system.

## SYNTAX

```
New-WinSCPItem -WinSCPSession <Session> [[-Path] <String[]>] [-Name <String>] [-ItemType <String>]
 [-Value <String>] [-Force] [-TransferOptions <TransferOptions>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new item on a remote system.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> New-WinSCPItem -Path NewWinSCPItem.txt


   Directory: ./

Mode                  LastWriteTime     Length Name
----                  -------------     ------ ----
---------      6/30/2017 1:41:47 PM          0 NewWinSCPItem.txt
```

### EXAMPLE 2
```
PS C:\> $sessionOption = New-WinSCPSessionOption -HostName $env:COMPUTERNAME -Protocol Ftp
PS C:\> New-WinSCPSession -SessionOption $sessionOption


Opened       Timeout HostName
------       ------- --------
True        00:01:00 ftp.dotps1.github.io


PS C:\> New-WinSCPItem -Path NewWinSCPItem.txt -Value "Hello World!"


   Directory: ./

Mode                  LastWriteTime     Length Name
----                  -------------     ------ ----
---------      6/30/2017 2:05:35 PM         12 NewWinSCPItem.txt


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

### -Force
Overwrite the item if it already exists.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ItemType
The type of item to create, file or directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: File
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the new item.
If this parameter is not used, the item will be named the last segment in the Path parameter value.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
The full path to the new item.
If the Name parameter is used, it will be appened to this value.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -TransferOptions
Defines options for file transfers.

```yaml
Type: TransferOptions
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
An initial value to put in the item.

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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### WinSCP.Session
System.String\[\] System.String

## OUTPUTS

### WinSCP.RemoteFileInfo

## NOTES

## RELATED LINKS
