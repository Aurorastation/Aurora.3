
param (
    [string]$Path
)

# if you want to run this script but it opens in notepad
# you may want to right click it and "run with powershell"

# relaunch in 32-bit powershell if currently running in 64-bit
if ([Environment]::Is64BitProcess) {
    $PowerShell32 = "$env:SystemRoot\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
    & $PowerShell32 -ExecutionPolicy Bypass -File $MyInvocation.MyCommand.Path @PSBoundParameters @args
    exit
}

# script explanation
Write-Host "*****"
Write-Host ""
Write-Host "This script will run map manipulations on every `.dmm` map that has a `.jsonc` config file,"
Write-Host "and write it to a `.mapmanipout.dmm` file in the same location."
Write-Host "Make sure to not commit these files to the repo."
Write-Host "You may have to launch the actual server to get stacktraces and the like."
Write-Host "You may provide a path to a specific map directory as an argument."
Write-Host ""
Write-Host "Example usage:"
Write-Host "./mapmanip.ps1"
Write-Host "./mapmanip.ps1 -Path maps/away/ships/my_map_folder"
Write-Host "./mapmanip.ps1 -Path D:/Git/Aurora.3/maps/away/ships/my_map_folder"
Write-Host ""
Write-Host "*****"
Write-Host ""

# find path to bapi.dll
if (Test-Path "./../../rust/bapi/target/i686-pc-windows-msvc/release/bapi.dll") {
	$BapiPath = "./../../rust/bapi/target/i686-pc-windows-msvc/release/bapi.dll"
} elseif (Test-Path "./../../rust/bapi/target/i686-pc-windows-msvc/debug/bapi.dll") {
	$BapiPath = "./../../rust/bapi/target/i686-pc-windows-msvc/debug/bapi.dll"
} elseif (Test-Path "./../../bapi.dll") {
	$BapiPath = "./../../bapi.dll"
} else {
	Write-Host "Cannot find bapi."
}

# run ffi function from bapi.dll
Write-Host "Executing..."
$HasPath = $PSBoundParameters.ContainsKey('Path') -or ($null -ne $Path)
$BapiExecutionTime = Measure-Command {
    # load the dll into powershell natively
    $Signature = @"
    [DllImport("$BapiPath", CallingConvention = CallingConvention.StdCall)]
    public static extern void all_mapmanip_configs_execute_ffi(string path);
"@
    try {
        Add-Type -MemberDefinition $Signature -Name "Bapi" -Namespace "RustTools" -ErrorAction Stop
    } catch {
        # already loaded in this PowerShell session, safely ignore
    }

    # call the rust function natively
    Write-Host "on path $Path..."
    [RustTools.Bapi]::all_mapmanip_configs_execute_ffi($Path)
}

# done
Write-Host "Done!"
Write-Host ("Took {0} seconds, or {1} milliseconds in total." -f $BapiExecutionTime.Seconds,$BapiExecutionTime.Milliseconds)
Write-Host "*****"
Read-Host -Prompt "Press Enter to exit..."
