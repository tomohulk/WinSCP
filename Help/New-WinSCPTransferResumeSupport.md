---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/New-WinSCPTransferResumeSupport
schema: 2.0.0
---

# New-WinSCPTransferResumeSupport

## SYNOPSIS
Configures automatic resume/transfer to temporary filename.

## SYNTAX

```
New-WinSCPTransferResumeSupport [-State <TransferResumeSupportState>] [[-Threshold] <Int32>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Configures automatic resume/transfer to temporary filename.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> New-WinSCPTransferResumeSupport

  State Threshold
  ----- ---------
Default
```

## PARAMETERS

### -Threshold
Threshold (in KB) for TransferResumeSupportState.Smart mode.
Setting the Threshold automatically sets the State to the TransferResumeSupportState.Smart.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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

### -State
{{Fill State Description}}

```yaml
Type: TransferResumeSupportState
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### WinSCP.TransferResumeSupport

## NOTES

## RELATED LINKS

[WinSCP reference:](https://winscp.net/eng/docs/library_transferresumesupport)

