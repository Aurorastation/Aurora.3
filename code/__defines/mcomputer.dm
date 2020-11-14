// defines for modular computers
// NTNet module-configuration values. Do not change these. If you need to add another use larger number (5..6..7 etc)
#define NTNET_SOFTWAREDOWNLOAD 1 	// Downloads of software from NTNet
#define NTNET_PEERTOPEER 2			// P2P transfers of files between devices
#define NTNET_COMMUNICATION 3		// Communication (messaging)
#define NTNET_SYSTEMCONTROL 4		// Control of various systems, RCon, air alarm control, etc.

// NTNet transfer speeds, used when downloading/uploading a file/program.
#define NTNETSPEED_LOWSIGNAL 0.05	// GQ/s transfer speed when the device is wirelessly connected and on Low signal
#define NTNETSPEED_HIGHSIGNAL 0.25	// GQ/s transfer speed when the device is wirelessly connected and on High signal
#define NTNETSPEED_ETHERNET 1	  // GQ/s transfer speed when the device is using wired connection
#define NTNETSPEED_DOS_AMPLIFICATION 20	// Multiplier for Denial of Service program. Resulting load on NTNet relay is this multiplied by NTNETSPEED of the device

// Program bitflags
#define PROGRAM_CONSOLE 1
#define PROGRAM_LAPTOP 2
#define PROGRAM_TABLET 4
#define PROGRAM_TELESCREEN 8
#define PROGRAM_SILICON_AI 16
#define PROGRAM_WRISTBOUND 32
#define PROGRAM_SILICON_ROBOT 64
#define PROGRAM_SILICON_PAI 128

#define PROGRAM_ALL (PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TABLET | PROGRAM_WRISTBOUND | PROGRAM_TELESCREEN | PROGRAM_SILICON_AI | PROGRAM_SILICON_ROBOT | PROGRAM_SILICON_PAI)
#define PROGRAM_SILICON (PROGRAM_SILICON_AI | PROGRAM_SILICON_ROBOT | PROGRAM_SILICON_PAI)
#define PROGRAM_STATIONBOUND (PROGRAM_SILICON_AI | PROGRAM_SILICON_ROBOT)
#define PROGRAM_ALL_REGULAR (PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_TABLET | PROGRAM_WRISTBOUND | PROGRAM_TELESCREEN)
#define PROGRAM_ALL_HANDHELD (PROGRAM_TABLET | PROGRAM_WRISTBOUND)

#define PROGRAM_STATE_KILLED 0
#define PROGRAM_STATE_BACKGROUND 1
#define PROGRAM_STATE_ACTIVE 2

// Caps for NTNet logging. Less than 10 would make logging useless anyway, more than 500 may make the log browser too laggy. Defaults to 100 unless user changes it.
#define MAX_NTNET_LOGS 500
#define MIN_NTNET_LOGS 10

#define PROGRAM_ACCESS_ONE 1
#define PROGRAM_ACCESS_LIST_ONE 2
#define PROGRAM_ACCESS_LIST_ALL 3

#define PROGRAM_NORMAL 1
#define PROGRAM_SERVICE 2
#define PROGRAM_TYPE_ALL (PROGRAM_NORMAL | PROGRAM_SERVICE)

#define DEVICE_UNKNOWN 0
#define DEVICE_COMPANY 1
#define DEVICE_PRIVATE 2

#define SCANNER_MEDICAL 1
#define SCANNER_REAGENT 2
#define SCANNER_GAS 4

// hardware types
#define MC_CPU "processor unit"
#define MC_NET "network card"
#define MC_HDD "hard drive"
#define MC_BAT "battery"
#define MC_CARD "card slot"
#define MC_PRNT "nano printer"
#define MC_USB "portable drive"
#define MC_AI "AI slot"
#define MC_PWR "charging system"
#define MC_FLSH "flashlight"

// hardware sizes
#define HW_MICRO 1
#define HW_STANDARD 2
#define HW_CONSOLE 3
