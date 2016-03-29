---
layout: post
title: "New-WinSCPItemPermission "
synopsis: "Represents *nix-style remote file permissions."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
New-WinSCPItemPermission [-GroupExecute] [-GroupRead] [-GroupWrite] [[-Numeric] <Int32>] [[-Octal] <String>] [-OtherExecute] [-OtherRead] [-OtherWrite] [-SetGid] [-SetUid] [-Sticky] [[-Text] <String>] [-UserExecute] [-UserRead] [-UserWrite] [-WhatIf] [-Confirm] [<CommonParameters>]
```

---

#### **Description**

Creates a new WinSCP.FilePermmissions object that can be used with [New-WinSCPTransferOption]({{ site.url }}/New-WinSCPTransferOption.html) to apply permissions when sending objects.

---

#### **Parameters**

[GroupExecute \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Execute permission for group.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False 
* Accept Wildcard Characters: False

[GroupRead \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Read permission for group.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[GroupWrite \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Write permission for group.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Numeric \<Int32\>](http://winscp.net/eng/docs/library_filepermissions)

Permissions as a number.

* Required: False
* Position: 0
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Octal \<Int32\>](http://winscp.net/eng/docs/library_filepermissions)

Permissions in octal format, e.g. "644".  Octal foramt has 3 or 4 (when any special permissions are set) digits.

* Required: False
* Position: 1
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[OtherExecute \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Execute permission for others.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[OtherRead \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Read permission for others.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[OtherWrite \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Write permission for others.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[SetGid \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Grants the user, who executes the file, permissions of file group.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[SetUid \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Grants the user, who executes the file, permissions of file owner.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Sticky \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Sticky bit.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Text \<String\>](http://winscp.net/eng/docs/library_filepermissions)

Permissions as a text in format "rwxrwxrwx".

* Required: False
* Position: 2
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[UserExecute \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Execute permission for owner.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[UserRead \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Read permission for owner.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[UserWrite \<SwitchParameter\>](http://winscp.net/eng/docs/library_filepermissions)

Write permission for owner.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[CommonParameters \<CommonParameters\>](http://go.microsoft.com/fwlink/?LinkID=113216)

This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.

---

#### **Inputs**

None

---

#### **Outputs**

[WinSCP.FilePermissions](http://winscp.net/eng/docs/library_filepermissions)

---

#### **Notes**

Can only be used with File Uploads.

---

#### **Example 1**

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

#### **Example 2**

```powershell
PS C:\> New-WinSCPItemPermission -GroupExecute -GroupRead -UserExecute -UserRead

Text         : r-xr-x---
Octal        : 550
OtherExecute : False
OtherWrite   : False
OtherRead    : False
GroupExecute : True
GroupWrite   : False
GroupRead    : True
UserExecute  : True
UserWrite    : False
UserRead     : True
Sticky       : False
SetGid       : False
SetUid       : False
```