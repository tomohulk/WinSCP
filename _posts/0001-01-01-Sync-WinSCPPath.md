---
layout: post
title: "Sync-WinSCPPath"
synopsis: "Synchronizes directories with an active WinSCP Session."
---

---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Sync-WinSCPPath [-WinSCPSession] <Session> [[-Mode] <SynchronizationMode>] [[-LocalPath] <String>] [[-RemotePath] <String>] [-Remove] [-Mirror] [[-Criteria] <SynchronizationCriteria>] [[-TransferOptions] <TransferOptions>] [<CommonParameters>]
```

---

#### **Description**

Synchronizes a local directory with a remote directory, or vise versa with an active remote host.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
* Accept Wildcard Characters: False

[Mode \<WinSCP.SynchronizationMode\>](http://winscp.net/eng/docs/task_synchronize_full#synchronization_mode)

Possible values are SynchronizationMode.Local, SynchronizationMode.Remote and SynchronizationMode.Both.

* Required: False
* Position: 1
* Default Value: New-Object -TypeName WinSCP.SyncronizationMode
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[LocalPath \<String\>](http://winscp.net/eng/docs/library_session_synchronizedirectories)

Full path to local directory.

* Required: False
* Position: 2
* Default Value: $pwd (Primary Working Directory)
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[RemotePath \<String\>](http://winscp.net/eng/docs/library_session_synchronizedirectories)

Full path to remote directory.

* Required: False
* Position: 3
* Default Value: /
* Accept Pipeline Input: False
* Accept Wildcard Characters: False


[Mirror \<SwitchParameter\>](http://winscp.net/eng/docs/library_session_synchronizedirectories)

When used, synchronizes in mirror mode (synchronizes also older files). Cannot be used for -Mode Both.

* Required: False
* Position: Named
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Criteria \<SwitchParameter\>](http://winscp.net/eng/docs/ui_synchronize#comparison_criteria)

Comparison criteria. Possible values are None, Time (default), .Size and Either. For -Mode Both Time can be used only.

* Required: False
* Position: 4
* Default Value: New-Object -TypeName WinSCP.SynchronizationCriteria
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[TransferOptions \<WinSCP.TransferOptions\>](http://winscp.net/eng/docs/library_transferoptions)

Defines options for file transfers.

* Required: False
* Position: 5
* Default Value: New-Object -TypeName WinSCP.TransferOptions
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[CommonParameters \<CommonParameters\>](http://go.microsoft.com/fwlink/?LinkID=113216)

This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.

---

#### **Inputs**

[WinSCP.Session](http://winscp.net/eng/docs/library_session)

* Represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

---

#### **Outputs**

[WinSCP.SynchronizationResult](http://winscp.net/eng/docs/library_synchronizationresult)

* Represents results of synchronization.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Sync-WinSCPDirectory -RemotePath '/' -LocalPath 'C:\lDir\' -Mode Local

Uploads   : {}
Downloads : {/rDir/rSubDir/rFile.txt}
Removals  : {}
Failures  : {}
IsSuccess : True
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Sync-WinSCPDirectory -WinSCPSession $session -RemotePath '/' -LocalPath 'C:\lDir\' -SyncMode Local

Uploads   : {}
Downloads : {/rDir/rSubDir/rFile.txt}
Removals  : {}
Failures  : {}
IsSuccess : True
```