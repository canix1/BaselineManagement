function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$SysLocale
	)

	Write-Verbose "Retrieving current System locale..."
    [string]$SysLocale = (Get-WinSystemLocale).Name
    Write-Verbose "System locale currently set to $SysLocale"

	$returnValue = @{
		SysLocale = $SysLocale
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$SysLocale
	)

    try
    {
        Write-Verbose "Setting System location..."
        Set-WinSystemLocale $SysLocale
        Write-Verbose "System location set to $SysLocale (reboot will be required)"

	    # requires a system reboot.
	    $global:DSCMachineStatus = 1
    }
    catch
    {
        Write-Verbose "Attempt to set System location to $SysLocale failed with the followng erorr: `n $Error "
    }
    finally
    {
        Write-Verbose "cleaning up ..."
    }

}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$SysLocale
	)

    try
    {
        [string]$CurrentSysLocale = (Get-WinSystemLocale).Name
               
        if ($CurrentSysLocale -like $SysLocale)
        {
            Write-Verbose "System location setting is consistent"
            $result = $true
        }
        else
        {
            Write-Verbose "System location  setting is inconsistent"
            $result = $false
        }
    }
    catch
    {
        Write-Verbose "Attempt to test System location to $SysLocale failed with the followng erorr: `n $Error "
    }
	
	$result
}

Export-ModuleMember -Function *-TargetResource
