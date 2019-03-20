---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/Send-WinSCPItem
schema: 2.0.0
---

# Send-WinSCPItem

## SYNOPSIS
Uploads one or more files from local directory to remote directory.

## SYNTAX

```
Send-WinSCPItem -WinSCPSession <Session> [-LocalPath] <String[]> [[-RemotePath] <String>] [-Remove]
 [-TransferOptions <TransferOptions>] [<CommonParameters>]
```

## DESCRIPTION
Uploads one or more files from local directory to remote directory.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Send-WinSCPItem -LocalPath ftpDoc3.txt


   Destination: \

IsSuccess FileName
--------- --------
True      ftpDoc3.txt
```

### EXAMPLE 2
```
PS C:\> New-Item -Name NewItem.txt -ItemType File -Value "Hello World!"


    Directory: C:\


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         7/5/2017   2:48 PM             12 NewItem.txt


PS C:\ Send-WinSCPItem -LocalPath NewItem.txt -Remove


   Destination: \

IsSuccess FileName
--------- --------
True      NewItem.txt
```

## PARAMETERS

### -LocalPath
Full path to local file or directory to upload.
Filename in the path can be replaced with Windows wildcard to select multiple files.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Path

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -RemotePath
Full path to upload the file to.
When uploading multiple files, the filename in the path should be replaced with operation mask or omitted (path ends with slash).

```yaml
Type: String
Parameter Sets: (All)
Aliases: Destination

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remove
When set to true, deletes source local file(s) after transfer.
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
Position: Named
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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### WinSCP.Session
System.String\[\]

## OUTPUTS

### WinSCP.TransferOperationResult

## NOTES

## RELATED LINKS

[WinSCP reference:](https://winscp.net/eng/docs/library_session_putfiles)

