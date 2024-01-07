#define RADIO_LOW_FREQ 1200
#define PUBLIC_LOW_FREQ 1441
#define PUBLIC_HIGH_FREQ 1489
#define RADIO_HIGH_FREQ 1600
// Reminder: frequencies should only be odd numbers

// Public frequencies (no encryption key required), see range above
#define EXP_FREQ	1445
#define BOT_FREQ	1447
#define INT_FREQ	1449
#define PEN_FREQ	1451
#define PUB_FREQ	1459
#define ENT_FREQ	1461
#define HAIL_FREQ	1463
#define SEC_I_FREQ	1475
#define MED_I_FREQ	1485

// Department / private frequencies

#define SYND_FREQ 1213
#define COAL_FREQ 1217
#define BLSP_FREQ 1253
#define NINJ_FREQ 1255
#define BURG_FREQ 1257
#define JOCK_FREQ 1259
#define RAID_FREQ 1277
#define DTH_FREQ 1341
#define AI_FREQ 1343
#define ERT_FREQ 1345
#define COMM_FREQ 1353

#define SUP_FREQ 1347
#define SRV_FREQ 1349
#define SCI_FREQ 1351
#define MED_FREQ 1355
#define ENG_FREQ 1357
#define SEC_FREQ 1359

var/list/AWAY_FREQS_UNASSIGNED = list(1491, 1493, 1495, 1497, 1499, 1501, 1503, 1505, 1507, 1509)
var/list/AWAY_FREQS_ASSIGNED = list("Hailing" = HAIL_FREQ)

var/list/radiochannels = list(
	"Common"		= PUB_FREQ,
	"Hailing"		= HAIL_FREQ,
	"Science"		= SCI_FREQ,
	"Command"		= COMM_FREQ,
	"Medical"		= MED_FREQ,
	"Engineering"	= ENG_FREQ,
	"Security" 		= SEC_FREQ,
	"Penal"			= PEN_FREQ,
	"Response Team" = ERT_FREQ,
	"Special Ops" 	= DTH_FREQ,
	"Mercenary" 	= SYND_FREQ,
	"Coalition Navy"= COAL_FREQ,
	"Ninja"			= NINJ_FREQ,
	"Bluespace"		= BLSP_FREQ,
	"Burglar"		= BURG_FREQ,
	"Jockey"		= JOCK_FREQ,
	"Raider"		= RAID_FREQ,
	"Operations" 	= SUP_FREQ,
	"Service" 		= SRV_FREQ,
	"AI Private"	= AI_FREQ,
	"Entertainment" = ENT_FREQ,
	"Medical (I)"	= MED_I_FREQ,
	"Security (I)"	= SEC_I_FREQ,
	"Interrogation" = INT_FREQ,
	"Expeditionary" = EXP_FREQ
)

var/list/reverseradiochannels = list(
	"[PUB_FREQ]"	= "Common",
	"[HAIL_FREQ]"	= "Hailing",
	"[SCI_FREQ]"	= "Science",
	"[COMM_FREQ]"	= "Command",
	"[MED_FREQ]"	= "Medical",
	"[ENG_FREQ]"	= "Engineering",
	"[SEC_FREQ]" 	= "Security",
	"[PEN_FREQ]"	= "Penal",
	"[ERT_FREQ]"	= "Response Team",
	"[DTH_FREQ]"	= "Special Ops",
	"[SYND_FREQ]"	= "Mercenary",
	"[COAL_FREQ]"	= "Coalition Navy",
	"[NINJ_FREQ]"	= "Ninja",
	"[BLSP_FREQ]"	= "Bluespace",
	"[BURG_FREQ]"	= "Burglar",
	"[JOCK_FREQ]"	= "Jockey",
	"[RAID_FREQ]"	= "Raider",
	"[SUP_FREQ]"	= "Operations",
	"[SRV_FREQ]"	= "Service",
	"[AI_FREQ]"		= "AI Private",
	"[ENT_FREQ]"	= "Entertainment",
	"[MED_I_FREQ]"	= "Medical (I)",
	"[SEC_I_FREQ]"	= "Security (I)"
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
	RAID_FREQ,
	NINJ_FREQ,
	BLSP_FREQ,
	BURG_FREQ
)

var/list/ANTAG_FREQS_ASSOC = list(
	"[SYND_FREQ]" = TRUE,
	"[RAID_FREQ]" = TRUE,
	"[NINJ_FREQ]" = TRUE,
	"[BURG_FREQ]" = TRUE,
	"[BLSP_FREQ]" = TRUE
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

#define TRANSMISSION_WIRE        0 // Wired transmission, unused at the moment
#define TRANSMISSION_RADIO       1 // Default radiowave transmission
#define TRANSMISSION_SUBSPACE    2 // Subspace transmission (headsets)
#define TRANSMISSION_SUPERSPACE  3 // Independent / CentCom radios only

#define RADIO_NO_Z_LEVEL_RESTRICTION 0

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
#define RADIO_MAGNETS "radio_magnet"
#define RADIO_ARRIVALS "radio_arrvl"

#define JAMMER_OFF -1
#define JAMMER_ALL 1 // affects ALL wireless streams
#define JAMMER_SYNTHETIC 2 // affects only synthetic wireless connections (attack_ai)

#define DEFAULT_LAW_CHANNEL "Main Frequency"
