---
layout: post
title:  "Get-WinSCPChildItem"
synopsis: "Shows the contents of a remote directory."
---

---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Get-WinSCPChildItem [-WinSCPSession] <Session> [[-Path] <String[]>] [[-Filter] <String>] [-Recurse] [<CommonParameters>]
```

---

#### **Description**

Displays the contents within a remote directory, including other directories and files.

---

#### **Parameters**

[WinSCPSession \<WinSCP.Session\>](http://winscp.net/eng/docs/library_session)

A valid open WinSCP Session, returned from [New-WinSCPSession]({{ site.url }}/New-WinSCPSession.html).

* Required: True
* Position: 0
* Default Value:
* Accept Pipeline Input: True (ByValue)
* Accept Wildcard Charcters: False

[Path \<String\[\]\>](http://winscp.net/eng/docs/library_session_getfileinfo)

Specifies a path to one or more locations. Wildcards are permitted. The default location is the home directory of the user making the connection.

* Required: False
* Position: 1
* Default Value:
* Accept Pipeline Input: True (ByPropertyName)
* Accept Wildcard Characters: False

[Filter \<String\>](http://winscp.net/eng/docs/operation_mask)

Filter to be applied to returned objects.

* Required: False
* Position: 2
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[Recurse \<SwitchParameter\>](https://msdn.microsoft.com/en-us/library/system.management.automation.switchparameter(v=vs.85).aspx)

Return items from all sub directories.

* Required: False
* Position: 3
* Default Value:
* Accept Pipeline Input: False
* Accept Wildcard Characters: False

[CommonParameters \<CommonParameters\>](http://go.microsoft.com/fwlink/?LinkID=113216)

This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.

---

#### **Inputs**

[WinSCP.Session](http://winscp.net/eng/docs/library_session)

* Represents a session and provides methods for manipulating remote files over SFTP, SCP or FTP session.

[System.String](https://msdn.microsoft.com/en-us/library/system.string(v=vs.110).aspx)

* Represents text as a series of Unicode characters.

---

#### **Outputs**

[System.Array](https://msdn.microsoft.com/en-us/library/system.array(v=vs.110).aspx)

* Provides methods for creating, manipulating, searching, and sorting arrays, thereby serving as the base class for all arrays in the common language runtime.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command

---

#### **Example 1**

```powershell
PS C:\> New-WinSCPSession -Credential (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:USERNAME, (New-Object -TypeName System.Security.SecureString)) -HostName $env:COMPUTERNAME -Protocol Ftp | Get-WinSCPChildItem -Path '/rDir/'

   Directory: /rDir

FileType             LastWriteTime     Length Name
--------             -------------     ------ ----
D             1/1/2015 12:00:00 AM          0 rSubDir
-             1/1/2015 12:00:00 AM       
```

#### **Example 2**

```powershell
PS C:\> $credential = Get-Credential
PS C:\> $session = New-WinSCPSession -Credential $credential -Hostname 'myftphost.org' -SshHostKeyFingerprint 'ssh-rsa 1024 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx'
PS C:\> Get-WinSCPChildItem -WinSCPSession $session -Path '/rDir/' -Recurse

   Directory: /rDir

FileType             LastWriteTime     Length Name
--------             -------------     ------ ----
D             1/1/2015 12:00:00 AM          0 rSubDir
-             1/1/2015 12:00:00 AM          0 rTextFile.txt


   Directory: /rDir/rSubDir

FileType             LastWriteTime     Length Name
--------             -------------     ------ ----
-             1/1/2015 12:00:00 AM          0 rSubDirTextFile.txt
```