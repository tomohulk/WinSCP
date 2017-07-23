function New-WinSCPItem {

    [CmdletBinding(
        HelpUri = "https://dotps1.github.io/WinSCP/New-WinSCPItem.html",
        PositionalBinding = $false
    )]
    [OutputType(
        [WinSCP.RemoteFileInfo]
    )]
    
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({ 
            if ($_.Opened) { 
                return $true 
            } else { 
                throw "The WinSCP Session is not in an Open state."
            }
        })]
        [WinSCP.Session]
        $WinSCPSession,

        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path = $WinSCPSession.HomePath,

        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [String]
        $Name,

        [Parameter()]
        [String]
        $ItemType = "File",

        [Parameter()]
        [String]
        $Value,

        [Parameter()]
        [Switch]
        $Force,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = ( New-Object -TypeName WinSCP.TransferOptions )
    )

    process {
        foreach ($pathValue in ( Format-WinSCPPathString -Path $Path )) {
            $nameParameterUsed = $PSBoundParameters.ContainsKey(
                "Name"
            )
            if ($nameParameterUsed) {
                $pathValue = Format-WinSCPPathString -Path ( Join-Path -Path $pathValue -ChildPath $Name )
            }

            $pathExists = Test-WinSCPPath -WinSCPSession $WinSCPSession -Path ( Split-Path -Path $pathValue -Parent )
            if (-not $pathExists) {
                Write-Error -Message "Cannot find path '$pathValue' because it does not exist."

                continue
            }

            $itemExits = Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $pathValue
            if ($itemExits -and -not $Force.IsPresent) {
                Write-Error -Message "An item with the specified name '$pathValue' already exists."

                continue
            } 

            try {
                $newItemParams = @{
                    Path = $env:TEMP
                    Name = (Split-Path -Path $pathValue -Leaf)
                    ItemType = $ItemType
                    Value = $Value
                    Force = $true
                }

                $newItem = New-Item @newItemParams
                $result = $WinSCPSession.PutFiles(
                    $newItem.FullName, $pathValue, $true, $TransferOptions
                )

                if ($result.IsSuccess) {
                    Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $result.Transfers.Destination
                } else {
                    $PSCmdlet.WriteError(
                        $result.Check()
                    )
                }
            } catch {
                $PSCmdlet.WriteError(
                    $_
                )
            } finally {
                # Make sure to clean up our temp item if the transfer fails.
                if (Test-Path -Path $newItem.FullName) {
                    Remove-Item -Path $newItem.FullName -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue
                }
            }
        }
    }
}
