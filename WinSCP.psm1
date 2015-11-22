"$(Split-Path -Path $MyInvocation.MyCommand.Path)\Functions\*.ps1" | Resolve-Path | ForEach-Object { 
	. $_.ProviderPath 
}