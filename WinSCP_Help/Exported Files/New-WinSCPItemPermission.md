# New-WinSCPItemPermission

## SYNOPSIS
Represents \*nix-style remote file permissions.

## SYNTAX

### Set 1
```
New-WinSCPItemPermission [[-Numeric] <Int32>] [[-Octal] <String>] [[-Text] <String>] [-GroupExecute] [-GroupRead] [-GroupWrite] [-OtherExecute] [-OtherRead] [-OtherWrite] [-SetGid] [-SetUid] [-Sticky] [-UserExecute] [-UserRead] [-UserWrite] [<CommonParameters>]
```

## DESCRIPTION
Represents \*nix-style remote file permissions.

## EXAMPLES

### EXAMPLE 1

```powershell
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

```powershell
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

### GroupExecute
Execute permission for group.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### GroupRead
Read permission for group.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### GroupWrite
Write permission for group.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### Numeric
Permissions as a number.

```yaml
Type: Int32
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 0
Default Value: 
Pipeline Input: false
```

### Octal
Permissions in octal format, e.g. "644". Octal format has 3 or 4 (when any special permissions are set) digits.

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 1
Default Value: 
Pipeline Input: false
```

### OtherExecute
Execute permission for others.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### OtherRead
Read permission for others.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### OtherWrite
Write permission for others.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### SetGid
Grants the user, who executes the file, permissions of file group.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### SetUid
Grants the user, who executes the file, permissions of file owner.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### Sticky
Sticky bit.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### Text
Permissions as a text in format "rwxrwxrwx".

```yaml
Type: String
Parameter Sets: Set 1
Aliases: 

Required: false
Position: 2
Default Value: 
Pipeline Input: false
```

### UserExecute
Execute permission for owner.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### UserRead
Read permission for owner.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### UserWrite
Write permission for owner.

```yaml
Type: SwitchParameter
Parameter Sets: Set 1
Aliases: 

Required: false
Position: named
Default Value: 
Pipeline Input: false
```

### \<CommonParameters\>
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None


## OUTPUTS

### WinSCP.FilePermissions


## NOTES

## RELATED LINKS

[Online version:](https://dotps1.github.io/WinSCP/New-WinSCPItemPermission.html)

[WinSCP reference:](https://winscp.net/eng/docs/library_filepermissions)


*Generated by:  PowerShell HelpWriter 2017 v2.1.35*
