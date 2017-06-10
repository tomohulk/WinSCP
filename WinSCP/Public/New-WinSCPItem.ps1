function New-WinSCPItem {

    [CmdletBinding(
        SupportsShouldProcess = $true,
        HelpUri = "https://dotps1.github.io/WinSCP/New-WinSCPItem.html"
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
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]
        $Path = $WinSCPSession.HomePath,

        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [String]
        $Name = $null,

        [Parameter()]
        [String]
        $ItemType = "File",

        [Parameter()]
        [String]
        $Value = $null,

        [Parameter()]
        [Switch]
        $Force,

        [Parameter()]
        [WinSCP.TransferOptions]
        $TransferOptions = (New-Object -TypeName WinSCP.TransferOptions)
    )

    process {
        foreach ($pathValue in (Format-WinSCPPathString -Path $($Path))) {
            if ($PSBoundParameters.ContainsKey('Name')) {
                $item = Format-WinSCPPathString -Path $(Join-Path -Path $pathValue -ChildPath $Name)
            }

            if (-not (Test-WinSCPPath -WinSCPSession $WinSCPSession -Path (Split-Path -Path $item -Parent))) {
                Write-Error -Message "Could not find a part of the path '$item'"

                continue
            }

            if ((Test-WinSCPPath -WinSCPSession $WinSCPSession -Path $item) -and -not $Force.IsPresent) {
                Write-Error -Message "An item with the specified name '$item' already exists."

                continue
            } 

            try {
                $newItemParams = @{
                    Path = $env:TEMP
                    Name = (Split-Path -Path $item -Leaf)
                    ItemType = $ItemType
                    Value = $Value
                    Force = $true
                }

                if ($PSCmdlet.ShouldProcess($item)) {
                    $newItem = New-Item @newItemParams
                    $result = $WinSCPSession.PutFiles(
                        $newItem.FullName, $item, $true, $TransferOptions
                    )

                    if ($result.IsSuccess) {
                        Get-WinSCPItem -WinSCPSession $WinSCPSession -Path $item
                    } else {
                        Write-Error $result.Check()

                        continue
                    }
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
