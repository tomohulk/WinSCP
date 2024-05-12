---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/tomohulk/WinSCP/wiki/New-WinSCPItemPermission
schema: 2.0.0
---

# New-WinSCPItemPermission

## SYNOPSIS
Represents *nix-style remote file permissions.

## SYNTAX

```
New-WinSCPItemPermission [-GroupExecute] [-GroupRead] [-GroupWrite] [-Numeric <Int32>] [-Octal <String>]
 [-OtherExecute] [-OtherRead] [-OtherWrite] [-SetGid] [-SetUid] [-Sticky] [-Text <String>] [-UserExecute]
 [-UserRead] [-UserWrite] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Represents *nix-style remote file permissions.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> New-WinSCPItemPermission


Numeric      : 0
Text         : ---------
Octal        : 000
OtherExecute : False
OtherWrite   : False
OtherRead    : False
GroupExecute : False
GroupWrite   : False
GroupRead    : False
UserExecute  : False
UserWrite    : False
UserRead     : False
Sticky       : False
SetGid       : False
SetUid       : False
```

### EXAMPLE 2
```
PS C:\> New-WinSCPItemPermission -OtherExecute -GroupExecute


Numeric      : 9
Text         : -----x--x
Octal        : 011
OtherExecute : True
OtherWrite   : False
OtherRead    : False
GroupExecute : True
GroupWrite   : False
GroupRead    : False
UserExecute  : False
UserWrite    : False
UserRead     : False
Sticky       : False
SetGid       : False
SetUid       : False
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

### -GroupExecute
Execute permission for group.

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

### -GroupRead
Read permission for group.

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

### -GroupWrite
Write permission for group.

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

### -Numeric
Permissions as a number.

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

### -Octal
Permissions in octal format, e.g.
"644".
Octal format has 3 or 4 (when any special permissions are set) digits.

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

### -OtherExecute
Execute permission for others.

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

### -OtherRead
Read permission for others.

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

### -OtherWrite
Write permission for others.

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

### -SetGid
Grants the user, who executes the file, permissions of file group.

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

### -SetUid
Grants the user, who executes the file, permissions of file owner.

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

### -Sticky
Sticky bit.

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

### -Text
Permissions as a text in format "rwxrwxrwx".

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

### -UserExecute
Execute permission for owner.

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

### -UserRead
Read permission for owner.

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

### -UserWrite
Write permission for owner.

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### WinSCP.FilePermissions

## NOTES

## RELATED LINKS

[WinSCP reference](https://winscp.net/eng/docs/library_filepermissions)

