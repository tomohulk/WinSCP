---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/Get-WinSCPItem
schema: 2.0.0
---

# Get-WinSCPItem

## SYNOPSIS
Recursively enumerates remote files.

## SYNTAX

```
Get-WinSCPItem -WinSCPSession <Session> [-Path] <String[]> [-Filter <String>] [<CommonParameters>]
```

## DESCRIPTION
Recursively enumerates remote files.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Get-WinSCPItem -Path "ftpDir1"


   Directory: ./

Mode                  LastWriteTime     Length Name
----                  -------------     ------ ----
---------      6/30/2017 8:50:37 AM            ftpDir1
```

### EXAMPLE 2
```
PS C:\> $sessionOption = New-WinSCPSessionOption -HostName $env:COMPUTERNAME -Protocol Ftp
PS C:\> New-WinSCPSession -SessionOption $sessionOption


Opened       Timeout HostName
------       ------- --------
True        00:01:00 ftp.dotps1.github.io


PS C:\> Get-WinSCPItem -Path "ftpDir1"


   Directory: ./

Mode                  LastWriteTime     Length Name
----                  -------------     ------ ----
---------      6/30/2017 8:50:37 AM            ftpDir1


PS C:\> Remove-WinSCPSession
```

## PARAMETERS

### -Filter
@{Text=}

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

### WinSCP.RemoteFileInfo

## NOTES

## RELATED LINKS

[WinSCP reference](https://winscp.net/eng/docs/library_session_getfileinfo)

