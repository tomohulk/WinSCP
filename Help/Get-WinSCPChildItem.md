---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/tomohulk/WinSCP/wiki/Get-WinSCPChildItem
schema: 2.0.0
---

# Get-WinSCPChildItem

## SYNOPSIS
Recursively enumerates remote files.

## SYNTAX

```
Get-WinSCPChildItem -WinSCPSession <Session> [[-Path] <String[]>] [-Filter <String>] [-Recurse]
 [-Depth <Int32>] [-Name] [-Directory] [-File] [<CommonParameters>]
```

## DESCRIPTION
Recursively enumerates remote files.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Get-WinSCPChildItem


   Directory: ./

Mode                  LastWriteTime     Length Name
----                  -------------     ------ ----
---------      6/30/2017 8:50:37 AM            ftpDir1
---------      6/30/2017 8:50:44 AM            ftpDir2
---------      6/30/2017 8:50:52 AM          0 ftpDoc1.txt
---------      6/30/2017 8:50:52 AM          0 ftpDoc2.txt
```

### EXAMPLE 2
```
PS C:\> $sessionOption = New-WinSCPSessionOption -HostName $env:COMPUTERNAME -Protocol Ftp
PS C:\> New-WinSCPSession -SessionOption $sessionOption


Opened       Timeout HostName
------       ------- --------
True        00:01:00 ftp.tomohulk.github.io


PS C:\> Get-WinSCPChildItem -File


   Directory: ./

Mode                  LastWriteTime     Length Name
----                  -------------     ------ ----
---------      6/30/2017 8:50:52 AM          0 ftpDoc1.txt
---------      6/30/2017 8:50:52 AM          0 ftpDoc2.txt


PS C:\> Remove-WinSCPSession
```

## PARAMETERS

### -Depth
The amount of directories to recurse.

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

### -Directory
Select directory objects only.

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

### -File
Select file objects only.

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

### -Filter
Windows wildcard to filter files.
To select all files, use null.

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

### -Name
Gets only the names of the items in the locations.

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
Full path to root remote directory to start enumeration in.

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

### -Recurse
Recurse into subdirectories.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### WinSCP.Session
System.String\[\]

## OUTPUTS

### System.Array

## NOTES
If both -Directory and -File switches are used, return nothing.
This mimics the functionality of Get-ChildItem.

## RELATED LINKS

[WinSCP reference](https://winscp.net/eng/docs/library_session_enumerateremotefiles)

