---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/Rename-WinSCPItem
schema: 2.0.0
---

# Rename-WinSCPItem

## SYNOPSIS
Moves remote file to another remote directory and/or renames remote file.

## SYNTAX

```
Rename-WinSCPItem -WinSCPSession <Session> [-Path] <String> -NewName <String> [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Moves remote file to another remote directory and/or renames remote file.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Rename-WinSCPItem -Path NewWinSCPItem.txt -NewName RenameWinSCPItem.txt
```

### EXAMPLE 2
```
PS C:\> New-WinSCPItem -Path NewWinSCPItem.txt -ItemType File


   Directory: ./

Mode                  LastWriteTime     Length Name
----                  -------------     ------ ----
---------      7/5/2017 12:14:55 PM          0 NewWinSCPItem.txt


PS C:\> Rename-WinSCPItem -Path NewWinSCPItem.txt -NewName RenameWinSCPItem.txt -PassThru


   Directory: ./

Mode                  LastWriteTime     Length Name
----                  -------------     ------ ----
---------       7/5/2017 2:26:09 PM          0 RenameWinSCPItem.txt
```

## PARAMETERS

### -NewName
The new name for the item.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Output the WinSCP.RemoteFileInfo object.

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

### -Path
The full path to the item to e renamed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
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

[WinSCP reference](https://winscp.net/eng/docs/library_session_movefile)

