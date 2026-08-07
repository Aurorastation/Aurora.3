$ErrorActionPreference = 'Stop'

Set-Location -LiteralPath (Split-Path -Parent $PSScriptRoot)

git fetch --prune upstream
if ($LASTEXITCODE -ne 0) {
	exit $LASTEXITCODE
}

# Update the fork without checking out files or disturbing local work.
git push origin upstream/master:master
exit $LASTEXITCODE
