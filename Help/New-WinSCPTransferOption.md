---
external help file: WinSCP-Help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/New-WinSCPTransferOption
schema: 2.0.0
---

# New-WinSCPTransferOption

## SYNOPSIS
Defines options for file transfers.

## SYNTAX

```
New-WinSCPTransferOption [[-FileMask] <String>] [[-FilePermissions] <FilePermissions>]
 [[-OverwriteMode] <OverwriteMode>] [[-PreserveTimestamp] <Boolean>]
 [[-TransferResumeSupport] <TransferResumeSupport>] [[-SpeedLimit] <Int32>] [[-TransferMode] <TransferMode>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Defines options for file transfers.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> New-WinSCPTransferOption


PreserveTimestamp : True
FilePermissions   :
TransferMode      : Binary
FileMask          :
ResumeSupport     : default
SpeedLimit        : 0
OverwriteMode     : Overwrite
```

### EXAMPLE 2
```
PS C:\> New-WinSCPTransferOption -PreserveTimestamp:$false -FilePermissions (New-WinSCPItemPermission -OtherExecute)


PreserveTimestamp : False
FilePermissions   : --------x
TransferMode      : Binary
FileMask          :
ResumeSupport     : default
SpeedLimit        : 0
OverwriteMode     : Overwrite
```

## PARAMETERS

### -FileMask
@{Text=}

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

### -FilePermissions
Permissions to applied to a remote file (used for uploads only).
Use default null to keep default permissions.

```yaml
Type: FilePermissions
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OverwriteMode
Behavior when overwriting existing files.
Possible values are: OverwriteMode.Overwrite (default) to overwrite the existing files.
OverwriteMode.Resume to assume that the existing and smaller file is a remnant of an interrupted transfer and resumes the transfer.
SFTP and FTP protocols only.
OverwriteMode.Append to append the source file to the end of existing target file.
SFTP protocol only.

```yaml
Type: OverwriteMode
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreserveTimestamp
Preserve timestamp (set last write time of destination file to that of source file).
Defaults to true.
When used with Session.SynchronizeDirectories, timestamp is always preserved, disregarding property value, unless criteria parameter is SynchronizationCriteria.None or SynchronizationCriteria.Size.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TransferResumeSupport
Configures automatic resume/transfer to temporary filename.

```yaml
Type: TransferResumeSupport
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SpeedLimit
Limit transfer speed (in KB/s).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TransferMode
Possible values are TransferMode.Binary (default), TransferMode.Ascii and TransferMode.Automatic (based on file extension).

```yaml
Type: TransferMode
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### WinSCP.TransferOptions

## NOTES

## RELATED LINKS

[WinSCP reference:](https://winscp.net/eng/docs/library_transferoptions)

