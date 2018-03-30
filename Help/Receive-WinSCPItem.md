---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/Receive-WinSCPItem
schema: 2.0.0
---

# Receive-WinSCPItem

## SYNOPSIS
Downloads one or more files from remote directory to local directory.

## SYNTAX

```
Receive-WinSCPItem [-WinSCPSession] <Session> [-RemotePath] <String[]> [[-LocalPath] <String>] [-Remove]
 [[-TransferOptions] <TransferOptions>] [<CommonParameters>]
```

## DESCRIPTION
Downloads one or more files from remote directory to local directory.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Receive-WinSCPItem -RemotePath ftpDoc1.txt


   Destination: C:\

IsSuccess FileName
--------- --------
True      ftpDoc1.txt
```

### EXAMPLE 2
```
PS C:\> New-WinSCPItem -Path NewWinSCPItem.txt -ItemType File -Value "Hello World!"


   Directory: ./

Mode                  LastWriteTime     Length Name
----                  -------------     ------ ----
---------      7/5/2017 10:54:45 AM         12 NewWinSCPItem.txt


PS C:\> Receive-WinSCPItem -RemotePath NewWinSCPItem.txt -LocalPath C:\Users\dotps1\Desktop -Remove


   Destination: C:\Users\dotps1\Desktop

IsSuccess FileName
--------- --------
True      NewWinSCPItem.txt
```

## PARAMETERS

### -WinSCPSession
It represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

```yaml
Type: Session
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -RemotePath
Full path to remote directory followed by slash and wildcard to select files or subdirectories to download.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Path

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LocalPath
Full path to download the file to.
When downloading multiple files, the filename in the path should be replaced with operation mask or omitted (path ends with backslash).

```yaml
Type: String
Parameter Sets: (All)
Aliases: Destination

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remove
When set to true, deletes source remote file(s) after transfer.
Defaults to false.

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

### -TransferOptions
Transfer options.
Defaults to null, what is equivalent to New-WinSCPTransferOption.

```yaml
Type: TransferOptions
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### WinSCP.Session
System.String\[\]

## OUTPUTS

### WinSCP.TransferOperationResult

## NOTES

## RELATED LINKS

[WinSCP reference:](https://winscp.net/eng/docs/library_session_getfiles)

