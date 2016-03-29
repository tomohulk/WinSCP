---
layout: post
title: "ConvertTo-WinSCPEscapedString"
synopsis: "Converts the special characters in string."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
ConvertTo-WinSCPEscapedString [-FileMask] <String[]> [<CommonParameters>]
```

---

#### **Description**

Escapes special characters so they are not misinterpreted as wildcards or other special characters.

---

#### **Parameters**

[FileMask \<String\[\]\>](http://winscp.net/eng/docs/library_session_escapefilemask)

File path to convert.

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue, ByPropertyName)
* Accept Wildcard Characters: True

[CommonParameters \<CommonParameters\>](http://go.microsoft.com/fwlink/?LinkID=113216)

This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.

---

#### **Inputs**

[String](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

* Represents text as a series of Unicode characters.

---

#### **Outputs**

[String](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

* Represents text as a series of Unicode characters.

---

#### **Notes**

Useful with Send-WinSCPItem, Receive-WinSCPItem, Remove-WinSCPItem cmdlets.

---

#### **Example 1**

```powershell
PS C:\> ConvertTo-WinSCPEscapedString -FileMask 'FileWithA*InName.txt'

FileWithA[*]InName.txt
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> $fileName = ConvertTo-WinSCPEscapedString -FileMask 'FileWithA*InName.txt'
PS C:\> Receive-WinSCPItem -WinSCPSession $session -RemoteItem "/rDir/$fileName" -LocalItem 'C:\lDir\'

Transfers                    Failures IsSuccess
---------                    -------- ---------
{/rDir/FileWithA*InName.txt} {}       True
```