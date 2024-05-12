---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/tomohulk/WinSCP/wiki/Get-WinSCPItemChecksum
schema: 2.0.0
---

# Get-WinSCPItemChecksum

## SYNOPSIS
Calculates a checksum of a remote file.

## SYNTAX

```
Get-WinSCPItemChecksum -WinSCPSession <Session> -Algorithm <String> [-Path] <String[]>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Calculates a checksum of a remote file.

## EXAMPLES

### Example 1
```
PS C:\> Get-WinSCPItemCecksum -Path /TestDoc.txt -Algorithm MD5
174
102
29
8
209
202
21
118
166
239
203
130
183
188
80
47
```

## PARAMETERS

### -Algorithm
A name of a checksum algorithm to use.
Use IANA name of algorithm or use a name of any proprietary algorithm the server supports (with SFTP protocol only).
Commonly supported algorithms are sha-1 and md5.

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

### -Path
A full path to a remote file to calculate a checksum for.

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

### WinSCP.Session
System.String\[\]

## OUTPUTS

### System.Array

## NOTES

## RELATED LINKS

[WinSCP reference](https://winscp.net/eng/docs/library_session_calculatefilechecksum)

