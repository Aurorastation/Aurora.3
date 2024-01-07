#define ACCESS_REGION_NONE -1
#define ACCESS_REGION_ALL 0
#define ACCESS_REGION_SECURITY 1
#define ACCESS_REGION_MEDBAY 2
#define ACCESS_REGION_RESEARCH 3
#define ACCESS_REGION_ENGINEERING 4
#define ACCESS_REGION_COMMAND 5
#define ACCESS_REGION_GENERAL 6
#define ACCESS_REGION_SUPPLY 7

#define ACCESS_TYPE_NONE 0
#define ACCESS_TYPE_CENTCOM 1
#define ACCESS_TYPE_STATION 2
#define ACCESS_TYPE_SYNDICATE 4
#define ACCESS_TYPE_ALL (ACCESS_TYPE_CENTCOM|ACCESS_TYPE_STATION|ACCESS_TYPE_SYNDICATE)

/datum/access
	var/id = 0
	var/desc = ""
	var/region = ACCESS_REGION_NONE
	var/access_type = ACCESS_TYPE_STATION

/datum/access/proc/get_info_list()
	var/list/info = list()
	info["id"] = id
	info["desc"] = desc
	info["region"] = region
	info["access_type"] = access_type
	return info

/*****************
* Station access *
*****************/
#define ACCESS_SECURITY 1
/datum/access/security
	id = ACCESS_SECURITY
	desc = "Security Equipment"
	region = ACCESS_REGION_SECURITY

#define ACCESS_BRIG 2 // Brig timers and permabrig
/datum/access/holding
	id = ACCESS_BRIG
	desc = "Holding Cells"
	region = ACCESS_REGION_SECURITY

#define ACCESS_ARMORY 3
/datum/access/armory
	id = ACCESS_ARMORY
	desc = "Armory"
	region = ACCESS_REGION_SECURITY

#define ACCESS_FORENSICS_LOCKERS 4
/datum/access/forensics_lockers
	id = ACCESS_FORENSICS_LOCKERS
	desc = "Forensics"
	region = ACCESS_REGION_SECURITY

#define ACCESS_MEDICAL 5
/datum/access/medical
	id = ACCESS_MEDICAL
	desc = "Medical"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_MORGUE 6
/datum/access/morgue
	id = ACCESS_MORGUE
	desc = "Morgue"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_TOX 7
/datum/access/tox
	id = ACCESS_TOX
	desc = "R&D Lab"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_TOX_STORAGE 8
/datum/access/tox_storage
	id = ACCESS_TOX_STORAGE
	desc = "Toxins Lab"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_GENETICS 9
/datum/access/genetics
	id = ACCESS_GENETICS
	desc = "Genetics Lab"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_ENGINE 10
/datum/access/engine
	id = ACCESS_ENGINE
	desc = "Engineering"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_ENGINE_EQUIP 11
/datum/access/engine_equip
	id = ACCESS_ENGINE_EQUIP
	desc = "Engine Room"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_MAINT_TUNNELS 12
/datum/access/maint_tunnels
	id = ACCESS_MAINT_TUNNELS
	desc = "Maintenance"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_EXTERNAL_AIRLOCKS 13
/datum/access/external_airlocks
	id = ACCESS_EXTERNAL_AIRLOCKS
	desc = "External Airlocks"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_EMERGENCY_STORAGE 14
/datum/access/emergency_storage
	id = ACCESS_EMERGENCY_STORAGE
	desc = "Emergency Storage"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_CHANGE_IDS 15
/datum/access/change_ids
	id = ACCESS_CHANGE_IDS
	desc = "ID Computer"
	region = ACCESS_REGION_COMMAND

#define ACCESS_AI_UPLOAD 16
/datum/access/ai_upload
	id = ACCESS_AI_UPLOAD
	desc = "AI Upload"
	region = ACCESS_REGION_COMMAND

#define ACCESS_TELEPORTER 17
/datum/access/teleporter
	id = ACCESS_TELEPORTER
	desc = "Teleporter"
	region = ACCESS_REGION_COMMAND

#define ACCESS_EVA 18
/datum/access/eva
	id = ACCESS_EVA
	desc = "EVA"
	region = ACCESS_REGION_COMMAND

#define ACCESS_HEADS 19
/datum/access/heads
	id = ACCESS_HEADS
	desc = "Bridge"
	region = ACCESS_REGION_COMMAND

#define ACCESS_CAPTAIN 20
/datum/access/captain
	id = ACCESS_CAPTAIN
	desc = "Captain"
	region = ACCESS_REGION_COMMAND

#define ACCESS_ALL_PERSONAL_LOCKERS 21
/datum/access/all_personal_lockers
	id = ACCESS_ALL_PERSONAL_LOCKERS
	desc = "Personal Lockers"
	region = ACCESS_REGION_COMMAND

#define ACCESS_CHAPEL_OFFICE 22
/datum/access/chapel_office
	id = ACCESS_CHAPEL_OFFICE
	desc = "Chapel Office"
	region = ACCESS_REGION_GENERAL

#define ACCESS_TECH_STORAGE 23
/datum/access/tech_storage
	id = ACCESS_TECH_STORAGE
	desc = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_ATMOSPHERICS 24
/datum/access/atmospherics
	id = ACCESS_ATMOSPHERICS
	desc = "Atmospherics"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_BAR 25
/datum/access/bar
	id = ACCESS_BAR
	desc = "Bar"
	region = ACCESS_REGION_GENERAL

#define ACCESS_JANITOR 26
/datum/access/janitor
	id = ACCESS_JANITOR
	desc = "Custodial Closet"
	region = ACCESS_REGION_GENERAL

#define ACCESS_CREMATORIUM 27
/datum/access/crematorium
	id = ACCESS_CREMATORIUM
	desc = "Crematorium"
	region = ACCESS_REGION_GENERAL

#define ACCESS_KITCHEN 28
/datum/access/kitchen
	id = ACCESS_KITCHEN
	desc = "Kitchen"
	region = ACCESS_REGION_GENERAL

#define ACCESS_ROBOTICS 29
/datum/access/robotics
	id = ACCESS_ROBOTICS
	desc = "Robotics"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_RD 30
/datum/access/rd
	id = ACCESS_RD
	desc = "Research Director"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_CARGO 31
/datum/access/cargo
	id = ACCESS_CARGO
	desc = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_CONSTRUCTION 32
/datum/access/construction
	id = ACCESS_CONSTRUCTION
	desc = "Construction Areas"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_PHARMACY 33
/datum/access/pharmacy
	id = ACCESS_PHARMACY
	desc = "Pharmacy Lab"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_CARGO_BOT 34
/datum/access/cargo_bot
	id = ACCESS_CARGO_BOT
	desc = "Cargo Bot Delivery"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_HYDROPONICS 35
/datum/access/hydroponics
	id = ACCESS_HYDROPONICS
	desc = "Hydroponics"
	region = ACCESS_REGION_GENERAL

#define ACCESS_MANUFACTURING 36
/datum/access/manufacturing
	id = ACCESS_MANUFACTURING
	desc = "Manufacturing"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_LIBRARY 37
/datum/access/library
	id = ACCESS_LIBRARY
	desc = "Library"
	region = ACCESS_REGION_GENERAL

#define ACCESS_LAWYER 38
/datum/access/lawyer
	id = ACCESS_LAWYER
	desc = "Representative"
	region = ACCESS_TYPE_CENTCOM

#define ACCESS_VIROLOGY 39
/datum/access/virology
	id = ACCESS_VIROLOGY
	desc = "Virology"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_CMO 40
/datum/access/cmo
	id = ACCESS_CMO
	desc = "Chief Medical Officer"
	region = ACCESS_REGION_COMMAND

#define ACCESS_QM 41
/datum/access/qm
	id = ACCESS_QM
	desc = "Operations Manager"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_NETWORK 42
/datum/access/network
	id = ACCESS_NETWORK
	desc = "Station Network"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_LEVIATHAN 43
/datum/access/leviathan
	id = ACCESS_LEVIATHAN
	desc = "Leviathan"
	region = ACCESS_REGION_COMMAND

// free_access_id = 44

#define ACCESS_SURGERY 45
/datum/access/surgery
	id = ACCESS_SURGERY
	desc = "Surgery"
	region = ACCESS_REGION_MEDBAY

// free_access_id = 46

#define ACCESS_RESEARCH 47
/datum/access/research
	id = ACCESS_RESEARCH
	desc = "Science"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_MINING 48
/datum/access/mining
	id = ACCESS_MINING
	desc = "Mining"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_MINING_OFFICE 49
/datum/access/mining_office
	id = ACCESS_MINING_OFFICE
	desc = "Mining Office"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_MAILSORTING 50
/datum/access/mailsorting
	id = ACCESS_MAILSORTING
	desc = "Cargo Office"
	region = ACCESS_REGION_SUPPLY

// free_access_id = 51

#define ACCESS_XENOBOTANY 52
/datum/access/xenobotany
	id = ACCESS_XENOBOTANY
	desc = "Xenobotany"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_HEADS_VAULT 53
/datum/access/heads_vault
	id = ACCESS_HEADS_VAULT
	desc = "Main Vault"
	region = ACCESS_REGION_COMMAND

#define ACCESS_MINING_STATION 54
/datum/access/mining_station
	id = ACCESS_MINING_STATION
	desc = "Mining EVA"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_XENOBIOLOGY 55
/datum/access/xenobiology
	id = ACCESS_XENOBIOLOGY
	desc = "Xenobiology Lab"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_CE 56
/datum/access/ce
	id = ACCESS_CE
	desc = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_HOP 57
/datum/access/hop
	id = ACCESS_HOP
	desc = "Executive Officer"
	region = ACCESS_REGION_COMMAND

#define ACCESS_HOS 58
/datum/access/hos
	id = ACCESS_HOS
	desc = "Head of Security"
	region = ACCESS_REGION_SECURITY

#define ACCESS_RC_ANNOUNCE 59 //Requests console announcements
/datum/access/RC_announce
	id = ACCESS_RC_ANNOUNCE
	desc = "RC Announcements"
	region = ACCESS_REGION_COMMAND

#define ACCESS_KEYCARD_AUTH 60 //Used for events which require at least two people to confirm them
/datum/access/keycard_auth
	id = ACCESS_KEYCARD_AUTH
	desc = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

#define ACCESS_TCOMSAT 61 // has access to the entire telecomms satellite / machinery
/datum/access/tcomsat
	id = ACCESS_TCOMSAT
	desc = "Telecommunications"
	region = ACCESS_REGION_COMMAND

#define ACCESS_GATEWAY 62
/datum/access/gateway
	id = ACCESS_GATEWAY
	desc = "Gateway"
	region = ACCESS_REGION_COMMAND

#define ACCESS_SEC_DOORS 63 // Security front doors
/datum/access/sec_doors
	id = ACCESS_SEC_DOORS
	desc = "Security"
	region = ACCESS_REGION_SECURITY

#define ACCESS_PSYCHIATRIST 64 // Psychiatrist's office
/datum/access/psychiatrist
	id = ACCESS_PSYCHIATRIST
	desc = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_XENOARCH 65
/datum/access/xenoarch
	id = ACCESS_XENOARCH
	desc = "Xenoarchaeology"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_MEDICAL_EQUIP 66
/datum/access/medical_equip
	id = ACCESS_MEDICAL_EQUIP
	desc = "Medical Equipment"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_FIRST_RESPONDER 67
/datum/access/first_responder
	id = ACCESS_FIRST_RESPONDER
	desc = "First Responder Equipment"
	region = ACCESS_REGION_MEDBAY

// free_access_id = 68

#define ACCESS_WEAPONS 69
/datum/access/weapons
	id = ACCESS_WEAPONS
	desc = "Weaponry Permission"
	region = ACCESS_REGION_SECURITY

#define ACCESS_JOURNALIST 70//journalist's office access
/datum/access/journalist
	id = ACCESS_JOURNALIST
	desc = "Journalist Office"
	region = ACCESS_REGION_GENERAL

#define ACCESS_IT 71 // allows some unique interactions with devices
/datum/access/tech_support
	id = ACCESS_IT
	desc = "Tech Support"

#define ACCESS_CONSULAR 72
/datum/access/consular
	id = ACCESS_CONSULAR
	desc = "Consular"

#define ACCESS_INTREPID 73
/datum/access/intrepid
	id = ACCESS_INTREPID
	desc = "Intrepid Shuttle"
	region = ACCESS_REGION_COMMAND

#define ACCESS_BRIDGE_CREW 74
/datum/access/bridge_crew
	id = ACCESS_BRIDGE_CREW
	desc = "Bridge Crew"
	region = ACCESS_REGION_COMMAND

#define ACCESS_SHIP_WEAPONS 75
/datum/access/ship_weapons
	id = ACCESS_SHIP_WEAPONS
	desc = "Ship Weapons"
	region = ACCESS_REGION_SUPPLY

/******************
* Central Command *
******************/
//General facilities. - Everyone on central has that --> Use this for doors that every central role should have access to, but not the aurora people
#define ACCESS_CENT_GENERAL 101
/datum/access/cent_general
	id = ACCESS_CENT_GENERAL
	desc = "Code Grey"
	access_type = ACCESS_TYPE_CENTCOM

//Thunderdome.
#define ACCESS_CENT_THUNDER 102
/datum/access/cent_thunder
	id = ACCESS_CENT_THUNDER
	desc = "Code Yellow"
	access_type = ACCESS_TYPE_CENTCOM

//Centcom Security - This access is used by the ERT / Odin Security and CCIA
// Separation between Odin Sec/CCIA and ERT is achieved via the ERT Commander Access (ACCESS_CENT_CREED)
#define ACCESS_CENT_SPECOPS 103
/datum/access/cent_specops
	id = ACCESS_CENT_SPECOPS
	desc = "Code Black"
	access_type = ACCESS_TYPE_CENTCOM

//Medical/Research - Thats the access for the medical section. Used for the odin doctors/chemists
#define ACCESS_CENT_MEDICAL 104
/datum/access/cent_medical
	id = ACCESS_CENT_MEDICAL
	desc = "Code White"
	access_type = ACCESS_TYPE_CENTCOM

//Living quarters, the access used by the odin bartenders/chefs
#define ACCESS_CENT_LIVING 105
/datum/access/cent_living
	id = ACCESS_CENT_LIVING
	desc = "Code Green"
	access_type = ACCESS_TYPE_CENTCOM

//Generic storage areas, used for the Maint Tunnels on Centcom
#define ACCESS_CENT_STORAGE 106
/datum/access/cent_storage
	id = ACCESS_CENT_STORAGE
	desc = "Code Orange"
	access_type = ACCESS_TYPE_CENTCOM

//107 is unused

//Creed's office. - ERT/TCFL Commander
#define ACCESS_CENT_CREED 108
/datum/access/cent_creed
	id = ACCESS_CENT_CREED
	desc = "Code Silver"
	access_type = ACCESS_TYPE_CENTCOM

//CCIA Access on Centcom
#define ACCESS_CENT_CCIA 109
/datum/access/cent_ccia
	id = ACCESS_CENT_CCIA
	desc = "Code Gold"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_MERCHANT 110//merchant access
/datum/access/merchant
	id = ACCESS_MERCHANT
	desc = "Merchant Access"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_LEGION 111//tau ceti foreign legion access
/datum/access/legion
	id = ACCESS_LEGION
	desc = "Tau Ceti Foreign Legion Access"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_DISTRESS 112
/datum/access/distress
	id = ACCESS_DISTRESS
	desc = "General ERT Base Access"
	access_type = ACCESS_TYPE_CENTCOM


/****************************
* Kataphract Chapter Access *
****************************/
#define ACCESS_KATAPHRACT 113
/datum/access/kataphract
	id = ACCESS_KATAPHRACT
	desc = "Kataphract Chapter Access"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_KATAPHRACT_KNIGHT 114
/datum/access/kataphract/knight
	id = ACCESS_KATAPHRACT_KNIGHT
	desc = "Kataphract Knight Access"

/***************
* Antag access *
***************/
#define ACCESS_SYNDICATE 150//General Syndicate Access
/datum/access/syndicate
	id = ACCESS_SYNDICATE
	access_type = ACCESS_TYPE_SYNDICATE

#define ACCESS_SYNDICATE_LEADER 151 //Syndie Commander Access
/datum/access/syndicate_leader
	id = ACCESS_SYNDICATE_LEADER
	access_type = ACCESS_TYPE_SYNDICATE

/*******
* Misc *
*******/
#define ACCESS_EQUIPMENT 199
/datum/access/equipment
	id = ACCESS_EQUIPMENT
	desc = "Equipment"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_CRATE_CASH 200
/datum/access/crate_cash
	id = ACCESS_CRATE_CASH
	access_type = ACCESS_TYPE_NONE

#define ACCESS_ORION_EXPRESS_SHIP 201
/datum/access/exress_ship
	id = ACCESS_ORION_EXPRESS_SHIP
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_GENERIC_AWAY_SITE 202
/datum/access/generic_away_site
	id = ACCESS_GENERIC_AWAY_SITE
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_NONE -1
/datum/access/none
	id = ACCESS_NONE
	access_type = ACCESS_TYPE_NONE

#define ACCESS_SOL_SHIPS 203
/datum/access/sol_ships
	id = ACCESS_SOL_SHIPS
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_TCFL_PEACEKEEPER_SHIP 204
/datum/access/tcfl_peacekeeper_ship
	id = ACCESS_TCFL_PEACEKEEPER_SHIP
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_EE_SPY_SHIP 205
/datum/access/ee_spy_ship
	id = ACCESS_EE_SPY_SHIP
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CIVILIAN_STATION 206
/datum/access/civilian_station
	id = ACCESS_CIVILIAN_STATION
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_ELYRAN_NAVAL_INFANTRY_SHIP 207
/datum/access/elyran_naval_infantry_ship
	id = ACCESS_ELYRAN_NAVAL_INFANTRY_SHIP
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_SKRELL 208
/datum/access/skrell
	id = ACCESS_SKRELL
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_PRA 209
/datum/access/pra
	id = ACCESS_PRA
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_UNATHI_PIRATE 210
/datum/access/unathi_pirate
	id = ACCESS_UNATHI_PIRATE
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_IAC_RESCUE_SHIP 211
/datum/access/iac_rescue_shit
	id = ACCESS_IAC_RESCUE_SHIP
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_IMPERIAL_FLEET_VOIDSMAN_SHIP 212
/datum/access/imperial_fleet_voidsman_ship
	id = ACCESS_IMPERIAL_FLEET_VOIDSMAN_SHIP
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_NKA 213
/datum/access/nka
	id = ACCESS_NKA
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_DPRA 214
/datum/access/dpra
	id = ACCESS_DPRA
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_MERCHANTS_GUILD 215
/datum/access/merchants_guild
	id = ACCESS_MERCHANTS_GUILD
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_HEPHAESTUS 216
/datum/access/hephaestus
	id = ACCESS_HEPHAESTUS
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_GOLDEN_DEEP 217
/datum/access/golden_deep
	id = ACCESS_GOLDEN_DEEP
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_KONYANG_POLICE 218
/datum/access/konyang_police
	id = ACCESS_KONYANG_POLICE
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_KONYANG_VENDORS 219
/datum/access/konyang_vendors
	id = ACCESS_KONYANG_VENDORS
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_IDRIS 220
/datum/access/idris
	id = ACCESS_IDRIS
	desc = "Idris Vault Ship"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_COALITION 221
/datum/access/coalition
	id = ACCESS_COALITION
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_COALITION_NAVY 222
/datum/access/coalition_navy
	id = ACCESS_COALITION_NAVY
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_GADPATHUR_NAVY 223
/datum/access/gadpathur_navy
	id = ACCESS_GADPATHUR_NAVY
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_GADPATHUR_NAVY_OFFICER 224
/datum/access/gadpathur_navy_officer
	id = ACCESS_GADPATHUR_NAVY_OFFICER
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_KONYANG_CORPORATE 225
/datum/access/konyang_corporate
	id = ACCESS_KONYANG_CORPORATE
	access_type = ACCESS_TYPE_CENTCOM
