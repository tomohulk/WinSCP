Before opening a new Pull Request, please make sure that all the of the Unit Tests in `.\Tests` are passing.
And please add any additional Unit Tests to ensure your contribuiton is reliable.

The environment the tests are running against include the follow key points:

* Ftp Server Flavor: `filezilla v0.9.60.2`.
* Credentials: `filezilla\filezilla`.
* Ftp Root: `C:\temp\ftproot`.
* Requried PowerShell Modules: `Pester, PSScriptAnalyzer`

You can easily setup this environment on your dev machine by running the `.\Install-FileZillaServer.ps1` located in the project root.

Also, please update the Help files with any applicable changes that you may have made.
All the help is compiled using [platyPS](https://github.com/PowerShell/platyPS).
So please update the help in `.\Help\<CmdletName>.md`, then compile a new `WinSCP-Help.xml`
```powershell
New-ExternalHelp -Path .\Help -OutputPath .\WinSCP\en-US -Force
```
And, if your feeling exceptionally helpful, the Wiki is its own repo, so you could also update that as well.:
```
git clone https://github.io/dotps1/WinSCP/wiki.git ..\Wiki
New-MarkdownHelp -Path .\Help -OutputPath ..\Wiki -NoMetadata -Force
```
### BUT PLEASE PLEASE PLEASE DO NOT CLONE THE WIKI INTO THIS REPO AND COMMIT IT BACK.
### THE WIKI RENDERS IN THE PROJECT ALREADY, I WOULD LIKE TO KEEP THE REPO SEPERATE.
