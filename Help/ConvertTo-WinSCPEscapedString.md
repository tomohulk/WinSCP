---
external help file: WinSCP-help.xml
Module Name: WinSCP
online version: https://github.com/dotps1/WinSCP/wiki/ConvertTo-WinSCPEscapedString
schema: 2.0.0
---

# ConvertTo-WinSCPEscapedString

## SYNOPSIS
Converts special characters in file path to make it unambiguous file mask/wildcard.

## SYNTAX

```
ConvertTo-WinSCPEscapedString -FileMask <String[]> [<CommonParameters>]
```

## DESCRIPTION
Converts special characters in file path to make it unambiguous file mask/wildcard.

## EXAMPLES

### EXAMPLE 1
```
PS C:\> ConvertTo-WinSCPEscapedString -FileMask "./WhosFileIsThis?.txt"
./WhosFileIsThis[?].txt
```

### EXAMPLE 2
```
PS C:\> $sessionOption = New-WinSCPSessionOption -HostName $env:COMPUTERNAME -Protocol Ftp
PS C:\> New-WinSCPSession -SessionOption $sessionOption


Opened       Timeout HostName
------       ------- --------
True        00:01:00 ftp.dotps1.github.io


PS C:\> $escapedString = ConvertTo-WinSCPEscapedString -FileMask "./WhosFileIsThis?.txt"
PS C:\> Get-WinSCPItem -Path $escapedString


   Directory: ./

Mode                  LastWriteTime     Length Name
----                  -------------     ------ ----
---------     4/25/2017 11:30:02 AM        349 WhosFileIsThis?.txt


PS C:\> Remove-WinSCPSession
```

## PARAMETERS

### -FileMask
File path to convert.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

[WinSCP reference](https://winscp.net/eng/docs/library_session_escapefilemask)

