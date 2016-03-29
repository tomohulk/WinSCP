---
layout: post
title: "New-WinSCPTransferOption"
synopsis: "Sets options for object transfers."
---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
New-WinSCPTransferOption [[-FileMask] <String>] [[-FilePermissions] <FilePermissions>] [-PreserveTimeStamp] [[-State] <TransferResumeSupportState>] [[-Threshold] <Int32>] [[-SpeedLimit] <Int32>] [[-TransferMode] <TransferMode>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

---

#### **Description**

Sets available options for object transfers between the client and server.

---

#### **Parameters**

[FileMask \<String\>](http://winscp.net/eng/docs/file_mask)

* See [FileMask](http://winscp.net/eng/docs/file_mask) for detailed explanation.

* Required: False
* Position: 0
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: True

[FilePermmission \<WinSCP.FilePermissions\>]({{ site.url }}/New-WinSCPFilePermission.html)

Permissions to applied to a remote object (used for uploads only).

* Required: False
* Position: 1
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[PreserveTimeStamp \<SwitchParameter\>](http://winscp.net/eng/docs/library_transferoptions)

Preserve timestamp (set last write time of destination file to that of source file).

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[State \<WinSCP.TransferResumeSupportState\>](http://winscp.net/eng/docs/library_transferresumesupport)

Sets what files will be transferred with resume support/to temporary filename. Use TransferResumeSupportState.Default for built-in default (currently all files above 100 KB), TransferResumeSupportState.On for all files, TransferResumeSupportState.Off for no file (turn off) or TransferResumeSupportState.Smart for all files above threshold (see Threshold).

* Required: False
* Position: 2
* Default Value: New-Object -TypeName WinSCP.TransferResumeSupportState
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Threshold \<Int32\>](http://winscp.net/eng/docs/library_transferresumesupport)

Threshold (in KB) for State.Smart mode.

* Required: False
* Position: 3
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[SpeedLimit \<Int32\>](http://winscp.net/eng/docs/library_transferoptions)

Limit transfer speed (in KB/s).

* Required: False
* Position: 4
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[TransferMode \<WinSCP.TransferMode\>](http://winscp.net/eng/docs/library_transferoptions)

Possible values are TransferMode.Binary (default), TransferMode.Ascii and TransferMode.Automatic (based on file extension).

* Required: False
* Position: 5
* Default Value: New-Object -TypeName WinSCP.TransferMode
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[CommonParameters \<CommonParameters\>](http://go.microsoft.com/fwlink/?LinkID=113216)

This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.

---

#### **Inputs**

None

---

#### **Outputs**

[WinSCP.TransferOptions](http://winscp.net/eng/docs/library_transferoptions)

* Defines options for file transfers.

---

#### **Notes**

New-WinSCPTransferOption is equivalent to New-Object -TypeName WinSCP.TransferOptions.

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPTransferOption -PreserveTimeStamp:$false -TransferMode Binary

PreserveTimestamp : False
FilePermissions   : 
TransferMode      : Binary
FileMask          : 
ResumeSupport     : default
SpeedLimit        : 0
```

#### **Example 2**

```powershell
PS C:\> New-WinSCPTransferOption -FilePermissions (New-WinSCPItemPermission -GroupExecute -OtherRead)

PreserveTimestamp : True
FilePermissions   : -----xr--
TransferMode      : Binary
FileMask          :
ResumeSupport     : default
SpeedLimit        : 0
```