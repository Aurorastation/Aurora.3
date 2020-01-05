
[CmdletBinding()]
param (
	[Parameter(Mandatory)]
	[string]
	$RuleName
)

try {
	Remove-NetFirewallRule -DisplayName $RuleName -ErrorAction Stop
}
catch {
	# No rule => nothing to drop /shrug
}
