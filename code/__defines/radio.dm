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
#define BLSP_FREQ 1253
#define NINJ_FREQ 1255
#define BURG_FREQ 1257
#define RAID_FREQ 1277
#define SHIP_FREQ 1280
#define ENT_FREQ 1461 //entertainment frequency. This is not a diona exclusive frequency.

//Away ship/site frequencies. If we ever spawn more than 5 away ghost roles at a time, just add more defines, and add it to avail_ship_freqs
#define AWAY_FREQ_A 1283
#define AWAY_FREQ_B 1285
#define AWAY_FREQ_C 1287
#define AWAY_FREQ_D 1289
#define AWAY_FREQ_E 1291

// department channels
var/const/PUB_FREQ = 1459
var/const/PEN_FREQ = 1451
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
	"Penal"			= PEN_FREQ,
	"Response Team" = ERT_FREQ,
	"Special Ops" 	= DTH_FREQ,
	"Mercenary" 	= SYND_FREQ,
	"Ninja"			= NINJ_FREQ,
	"Bluespace"		= BLSP_FREQ,
	"Burglar"		= BURG_FREQ,
	"Raider"		= RAID_FREQ,
	"Operations" 	= SUP_FREQ,
	"Service" 		= SRV_FREQ,
	"AI Private"	= AI_FREQ,
	"Entertainment" = ENT_FREQ,
	"Medical (I)"	= MED_I_FREQ,
	"Security (I)"	= SEC_I_FREQ,
	"Shuttle"		= SHIP_FREQ
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
	"[SHIP_FREQ]" = TRUE
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
	ENT_FREQ,
	SHIP_FREQ
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

//Generated away ship/site frequencies
var/list/AWAY_FREQS = list(
	AWAY_FREQ_A,
	AWAY_FREQ_B,
	AWAY_FREQ_C,
	AWAY_FREQ_D,
	AWAY_FREQ_E
)

var/list/AWAY_FREQS_ASSOC = list(
	"[AWAY_FREQ_A]" = TRUE,
	"[AWAY_FREQ_B]" = TRUE,
	"[AWAY_FREQ_C]" = TRUE,
	"[AWAY_FREQ_D]" = TRUE,
	"[AWAY_FREQ_E]" = TRUE
)

//List of available frequencies left in each round for away sites to choose from. 
var/list/avail_ship_freqs = list(
	AWAY_FREQ_A,
	AWAY_FREQ_B,
	AWAY_FREQ_C,
	AWAY_FREQ_D,
	AWAY_FREQ_E
)

#define TRANSMISSION_WIRE        0 // Wired transmission, unused at the moment
#define TRANSMISSION_RADIO       1
#define TRANSMISSION_SUBSPACE    2

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

#define JAMMER_OFF -1
#define JAMMER_ALL 1 // affects ALL wireless streams
#define JAMMER_SYNTHETIC 2 // affects only synthetic wireless connections (attack_ai)