---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/Sync-WinSCPPath
schema: 2.0.0
---

# Sync-WinSCPPath

## SYNOPSIS
Synchronizes directories.

## SYNTAX

```
Sync-WinSCPPath -WinSCPSession <Session> -Mode <SynchronizationMode> [[-LocalPath] <String>]
 [[-RemotePath] <String>] [-Remove] [-Mirror] [-Criteria <SynchronizationCriteria>]
 [-TransferOptions <TransferOptions>] [<CommonParameters>]
```

## DESCRIPTION
Synchronizes directories.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> Sync-WinSCPPath -Mode Local


Uploads   : {}
Downloads : {/ftpDoc1.txt, /ftpDoc2.txt}
Removals  : {}
Failures  : {}
IsSuccess : True
```

### EXAMPLE 2
```
PS C:\> Sync-WinSCPPath -Mode Both -Criteria Time


Uploads   : {C:\Users\us165614\Desktop\local\localDoc1.txt, C:\Users\us165614\Desktop\local\localDoc2.txt}
Downloads : {/ftpDoc1.txt, /ftpDoc2.txt}
Removals  : {}
Failures  : {}
IsSuccess : True
```

## PARAMETERS

### -Criteria
Comparison criteria.
Possible values are SynchronizationCriteria.None, SynchronizationCriteria.Time (default), SynchronizationCriteria.Size and SynchronizationCriteria.Either.
For SynchronizationMode.Both SynchronizationCriteria.Time can be used only.

```yaml
Type: SynchronizationCriteria
Parameter Sets: (All)
Aliases:
Accepted values: None, Time, Size, Either

Required: False
Position: Named
Default value: Time
Accept pipeline input: False
Accept wildcard characters: False
```

### -LocalPath
Full path to local directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mirror
When set to true, synchronizes in mirror mode (synchronizes also older files).
Cannot be used for SynchronizationMode.Both.
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

### -Mode
Synchronization mode.
Possible values are SynchronizationMode.Local, SynchronizationMode.Remote and SynchronizationMode.Both.

```yaml
Type: SynchronizationMode
Parameter Sets: (All)
Aliases:
Accepted values: Local, Remote, Both

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemotePath
Full path to remote directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remove
When set to true, deletes obsolete files.
Cannot be used for SynchronizationMode.Both.

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

## OUTPUTS

### WinSCP.SynchronizationResult

## NOTES

## RELATED LINKS

[WinSCP reference](https://winscp.net/eng/docs/library_session_synchronizedirectories)

