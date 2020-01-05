
[CmdletBinding()]
param (
	[Parameter(Mandatory)]
	[string]
	$RuleName,

	[Parameter(Mandatory)]
	[string]
	$Address
)

try {
	$rule = Get-NetFirewallRule -DisplayName $RuleName -ErrorAction Stop
	$ips = ($rule | Get-NetFirewallAddressFilter).RemoteAddress

	if ($ips -isnot [array]) {
		$ips = @($ips)
	}

	$ips += $Address

	Write-Output $ips

	Set-NetFirewallRule -DisplayName $rule.DisplayName -RemoteAddress $ips
}
catch {
	$ips = @($Address)
	New-NetFirewallRule -DisplayName $RuleName -Enabled False -Direction Inbound -Action Block -RemoteAddress $ips
}
