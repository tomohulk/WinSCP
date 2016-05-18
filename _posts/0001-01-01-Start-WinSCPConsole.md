---
layout: post
title: "Start-WinSCPConsole"
synopsis: "Opens a new instance of the WinSCP CLI."
---

---

#### **Synopsis**

{{ page.synopsis }}

---

#### **Syntax**

```powershell
Start-WinSCPConsole [<CommonParameters>]
```

---

#### **Description**

Opens a new instance of the WinSCP Command Line Interface where raw commands can be executed.

---

#### **Parameters**

[CommonParameters \<CommonParameters\>](http://go.microsoft.com/fwlink/?LinkID=113216)

This cmdlet supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, WarningVariable, OutBuffer, PipelineVariable, and OutVariable.

---

#### **Inputs**

[System.Void](https://msdn.microsoft.com/en-us/library/system.void(v=vs.110).aspx)

* Specifies a return value type for a method that does not return a value.

---

#### **Outputs**

[System.Void](https://msdn.microsoft.com/en-us/library/system.void(v=vs.110).aspx)

* Specifies a return value type for a method that does not return a value.

---

#### **Notes**

If the WinSCPSession is piped into this command, the connection will be closed and the object will be disposed upon completion of the command.

---

#### **Example 1**

```powershell
PS C:\> Start-WinSCPConsole
```