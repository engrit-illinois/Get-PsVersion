function Get-PsVersion($comp) {
	function log($msg) {
		Write-Host $msg
	}
	
	function Do-IcMethod {
		Write-Host "Trying Invoke-Command method..."
		# Invoke-Command method	
		$scriptBlock = {
			$PSVersionTable.PSVersion
		}
		$resultIc = Invoke-Command -ComputerName $comp -ScriptBlock $scriptBlock
		Write-Host "    Result: `"$resultIc`"."
	}

	function Do-WmiMethod {
		Write-Host "Trying WMI method..."
		# WMI method
		$hklm = 2147483650 # This is some sort of unique identifier that always means "HKEY_LOCAL_MACHINE", I guess
		$key = "SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine"
		$value = "PowerShellVersion"
		$resultWmi = (([wmiclass]"\\$comp\root\default:stdRegProv").GetStringValue("$hklm","$key","$value")).svalue
		Write-Host "    Result: `"$resultWmi`"."
	}
	
	function Do-Stuff {
		Do-IcMethod
		Do-WmiMethod
	}
	
	Do-Stuff
	
	log "EOF"
}
