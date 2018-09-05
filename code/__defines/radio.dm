#define RADIO_LOW_FREQ 1200
#define PUBLIC_LOW_FREQ 1441
#define PUBLIC_HIGH_FREQ 1489
#define RADIO_HIGH_FREQ 1600

#define BOT_FREQ 1447
#define COMM_FREQ 1353
#define ERT_FREQ 1345
#define AI_FREQ 1343
#define DTH_FREQ 1341
#define SYND_FREQ 1213
#define RAID_FREQ 1277
#define ENT_FREQ 1461 //entertainment frequency. This is not a diona exclusive frequency.

// department channels
var/const/PUB_FREQ = 1459
var/const/SEC_FREQ = 1359
var/const/ENG_FREQ = 1357
var/const/MED_FREQ = 1355
var/const/SCI_FREQ = 1351
var/const/SRV_FREQ = 1349
var/const/SUP_FREQ = 1347

// internal department channels
#define MED_I_FREQ 1485
#define SEC_I_FREQ 1475

var/list/radiochannels = list(
	"Common"		= PUB_FREQ,
	"Science"		= SCI_FREQ,
	"Command"		= COMM_FREQ,
	"Medical"		= MED_FREQ,
	"Engineering"	= ENG_FREQ,
	"Security" 		= SEC_FREQ,
	"Response Team" = ERT_FREQ,
	"Special Ops" 	= DTH_FREQ,
	"Mercenary" 	= SYND_FREQ,
	"Raider"		= RAID_FREQ,
	"Supply" 		= SUP_FREQ,
	"Service" 		= SRV_FREQ,
	"AI Private"	= AI_FREQ,
	"Entertainment" = ENT_FREQ,
	"Medical (I)"	= MED_I_FREQ,
	"Security (I)"	= SEC_I_FREQ
)

// The assoc variants are separate lists because they need the keys to be strings, but some code expects numbers.

// central command channels, i.e deathsquid & response teams
var/list/CENT_FREQS = list(
	ERT_FREQ, 
	DTH_FREQ
)

var/list/CENT_FREQS_ASSOC = list(
	"[ERT_FREQ]" = TRUE,
	"[DTH_FREQ]" = TRUE
)

// Antag channels, i.e. Syndicate
var/list/ANTAG_FREQS = list(
	SYND_FREQ, 
	RAID_FREQ
)

var/list/ANTAG_FREQS_ASSOC = list(
	"[SYND_FREQ]" = TRUE,
	"[RAID_FREQ]" = TRUE
)

//Department channels, arranged lexically
var/list/DEPT_FREQS = list(
	AI_FREQ,
	COMM_FREQ,
	ENG_FREQ,
	MED_FREQ,
	SEC_FREQ,
	SCI_FREQ,
	SRV_FREQ,
	SUP_FREQ,
	ENT_FREQ
)

var/list/DEPT_FREQS_ASSOC = list(
	"[AI_FREQ]" = TRUE,
	"[COMM_FREQ]" = TRUE,
	"[ENG_FREQ]" = TRUE,
	"[MED_FREQ]" = TRUE,
	"[SEC_FREQ]" = TRUE,
	"[SCI_FREQ]" = TRUE,
	"[SRV_FREQ]" = TRUE,
	"[SUP_FREQ]" = TRUE,
	"[ENT_FREQ]" = TRUE
)

#define TRANSMISSION_WIRE	0
#define TRANSMISSION_RADIO	1

/* filters */
//When devices register with the radio controller, they might register under a certain filter.
//Other devices can then choose to send signals to only those devices that belong to a particular filter.
//This is done for performance, so we don't send signals to lots of machines unnecessarily.

//This filter is special because devices belonging to default also receive signals sent to any other filter.
#define RADIO_DEFAULT "radio_default"

#define RADIO_TO_AIRALARM "radio_airalarm" //air alarms
#define RADIO_FROM_AIRALARM "radio_airalarm_rcvr" //devices interested in recieving signals from air alarms
#define RADIO_CHAT "radio_telecoms"
#define RADIO_ATMOSIA "radio_atmos"
#define RADIO_NAVBEACONS "radio_navbeacon"
#define RADIO_AIRLOCK "radio_airlock"
#define RADIO_SECBOT "radio_secbot"
#define RADIO_MULEBOT "radio_mulebot"
#define RADIO_MAGNETS "radio_magnet"
#define RADIO_ARRIVALS "radio_arrvl"
