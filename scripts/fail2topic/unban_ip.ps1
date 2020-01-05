
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
	$ips = ($rule | Get-NetFirewallAddressFilter).RemoteAddress;

	if ($ips -is [array]) {
		$ips = $ips | Where-Object { $_ -ne $Address }

		Set-NetFirewallRule -DisplayName $rule.DisplayName -RemoteAddress $ips
	} else {
		Remove-NetFirewallRule -DisplayName $rule.DisplayName
	}
}
catch {
	# No rule => nothing to unban /shrug
}
