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
/datum/access/ACCESS_EXTERNAL_AIRLOCKS
	id = access_external_airlocks
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
	id = access_ai_upload
	desc = "AI Upload"
	region = ACCESS_REGION_COMMAND

#define ACCESS_TELEPORTER 17
/datum/access/teleporter
	id = access_teleporter
	desc = "Teleporter"
	region = ACCESS_REGION_COMMAND

#define ACCESS_EVA 18
/datum/access/eva
	id = access_eva
	desc = "EVA"
	region = ACCESS_REGION_COMMAND

#define ACCESS_HEADS 19
/datum/access/heads
	id = access_heads
	desc = "Bridge"
	region = ACCESS_REGION_COMMAND

#define ACCESS_CAPTAIN 20
/datum/access/captain
	id = access_captain
	desc = "Captain"
	region = ACCESS_REGION_COMMAND

#define ACCESS_ALL_PERSONAL_LOCKERS 21
/datum/access/all_personal_lockers
	id = access_all_personal_lockers
	desc = "Personal Lockers"
	region = ACCESS_REGION_COMMAND

#define ACCESS_CHAPEL_OFFICE 22
/datum/access/chapel_office
	id = access_chapel_office
	desc = "Chapel Office"
	region = ACCESS_REGION_GENERAL

#define ACCESS_TECH_STORAGE 23
/datum/access/tech_storage
	id = access_tech_storage
	desc = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_ATMOSPHERICS 24
/datum/access/atmospherics
	id = access_atmospherics
	desc = "Atmospherics"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_BAR 25
/datum/access/bar
	id = access_bar
	desc = "Bar"
	region = ACCESS_REGION_GENERAL

#define ACCESS_JANITOR 26
/datum/access/janitor
	id = access_janitor
	desc = "Custodial Closet"
	region = ACCESS_REGION_GENERAL

#define ACCESS_CREMATORIUM 27
/datum/access/crematorium
	id = access_crematorium
	desc = "Crematorium"
	region = ACCESS_REGION_GENERAL

#define ACCESS_KITCHEN 28
/datum/access/kitchen
	id = access_kitchen
	desc = "Kitchen"
	region = ACCESS_REGION_GENERAL

#define ACCESS_ROBOTICS 29
/datum/access/robotics
	id = access_robotics
	desc = "Robotics"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_RD 30
/datum/access/rd
	id = access_rd
	desc = "Research Director"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_CARGO 31
/datum/access/cargo
	id = access_cargo
	desc = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_CONSTRUCTION 32
/datum/access/construction
	id = access_construction
	desc = "Construction Areas"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_PHARMACY 33
/datum/access/pharmacy
	id = access_pharmacy
	desc = "Pharmacy Lab"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_CARGO_BOT 34
/datum/access/cargo_bot
	id = access_cargo_bot
	desc = "Cargo Bot Delivery"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_HYDROPONICS 35
/datum/access/hydroponics
	id = access_hydroponics
	desc = "Hydroponics"
	region = ACCESS_REGION_GENERAL

#define ACCESS_MANUFACTURING 36
/datum/access/manufacturing
	id = access_manufacturing
	desc = "Manufacturing"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_LIBRARY 37
/datum/access/library
	id = access_library
	desc = "Library"
	region = ACCESS_REGION_GENERAL

#define ACCESS_LAWYER 38
/datum/access/lawyer
	id = access_lawyer
	desc = "Representative"
	region = ACCESS_TYPE_CENTCOM

#define ACCESS_VIROLOGY 39
/datum/access/virology
	id = access_virology
	desc = "Virology"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_CMO 40
/datum/access/cmo
	id = access_cmo
	desc = "Chief Medical Officer"
	region = ACCESS_REGION_COMMAND

#define ACCESS_QM 41
/datum/access/qm
	id = access_qm
	desc = "Operations Manager"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_NETWORK 42
/datum/access/network
	id = access_network
	desc = "Station Network"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_LEVIATHAN 43
/datum/access/leviathan
	id = access_leviathan
	desc = "Leviathan"
	region = ACCESS_REGION_COMMAND

// /var/const/free_access_id = 44

#define ACCESS_SURGERY 45
/datum/access/surgery
	id = access_surgery
	desc = "Surgery"
	region = ACCESS_REGION_MEDBAY

// /var/const/free_access_id = 46

#define ACCESS_RESEARCH 47
/datum/access/research
	id = access_research
	desc = "Science"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_MINING 48
/datum/access/mining
	id = access_mining
	desc = "Mining"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_MINING_OFFICE 49
/datum/access/mining_office
	id = access_mining_office
	desc = "Mining Office"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_MAILSORTING 50
/datum/access/mailsorting
	id = access_mailsorting
	desc = "Cargo Office"
	region = ACCESS_REGION_SUPPLY

// /var/const/free_access_id = 51
#define ACCESS_XENOBOTANY 52
/datum/access/xenobotany
	id = access_xenobotany
	desc = "Xenobotany"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_HEADS_VAULT 53
/datum/access/heads_vault
	id = access_heads_vault
	desc = "Main Vault"
	region = ACCESS_REGION_COMMAND

#define ACCESS_MINING_STATION 54
/datum/access/mining_station
	id = access_mining_station
	desc = "Mining EVA"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_XENOBIOLOGY 55
/datum/access/xenobiology
	id = access_xenobiology
	desc = "Xenobiology Lab"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_CE 56
/datum/access/ce
	id = access_ce
	desc = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_HOP 57
/datum/access/hop
	id = access_hop
	desc = "Executive Officer"
	region = ACCESS_REGION_COMMAND

#define ACCESS_HOS 58
/datum/access/hos
	id = access_hos
	desc = "Head of Security"
	region = ACCESS_REGION_SECURITY

#define ACCESS_RC_ANNOUNCE 59 //Requests console announcements
/datum/access/RC_announce
	id = access_RC_announce
	desc = "RC Announcements"
	region = ACCESS_REGION_COMMAND

#define ACCESS_KEYCARD_AUTH 60 //Used for events which require at least two people to confirm them
/datum/access/keycard_auth
	id = access_keycard_auth
	desc = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

#define ACCESS_TCOMSAT 61 // has access to the entire telecomms satellite / machinery
/datum/access/tcomsat
	id = access_tcomsat
	desc = "Telecommunications"
	region = ACCESS_REGION_COMMAND

#define ACCESS_GATEWAY 62
/datum/access/gateway
	id = access_gateway
	desc = "Gateway"
	region = ACCESS_REGION_COMMAND

#define ACCESS_SEC_DOORS 63 // Security front doors
/datum/access/sec_doors
	id = access_sec_doors
	desc = "Security"
	region = ACCESS_REGION_SECURITY

#define ACCESS_PSYCHIATRIST 64 // Psychiatrist's office
/datum/access/psychiatrist
	id = access_psychiatrist
	desc = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_XENOARCH 65
/datum/access/xenoarch
	id = access_xenoarch
	desc = "Xenoarchaeology"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_MEDICAL_EQUIP 66
/datum/access/medical_equip
	id = access_medical_equip
	desc = "Medical Equipment"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_FIRST_RESPONDER 67
/datum/access/access_first_responder
	id = access_first_responder
	desc = "First Responder Equipment"
	region = ACCESS_REGION_MEDBAY

// /var/const/free_access_id = 68

#define ACCESS_WEAPONS 69
/datum/access/access_weapons
	id = access_weapons
	desc = "Weaponry Permission"
	region = ACCESS_REGION_SECURITY

var/const/access_journalist = 70//journalist's office access
/datum/access/journalist
	id = access_journalist
	desc = "Journalist Office"
	region = ACCESS_REGION_GENERAL

var/const/access_it = 71 // allows some unique interactions with devices
/datum/access/tech_support
	id = access_it
	desc = "Tech Support"

var/const/access_consular = 72
/datum/access/consular
	id = access_consular
	desc = "Consular"

var/const/access_intrepid = 73
/datum/access/intrepid
	id = access_intrepid
	desc = "Intrepid Shuttle"
	region = ACCESS_REGION_COMMAND

var/const/access_bridge_crew = 74
/datum/access/bridge_crew
	id = access_bridge_crew
	desc = "Bridge Crew"
	region = ACCESS_REGION_COMMAND

#define ACCESS_SHIP_WEAPONS 75
/datum/access/access_ship_weapons
	id = access_ship_weapons
	desc = "Ship Weapons"
	region = ACCESS_REGION_SUPPLY

/******************
* Central Command *
******************/
//General facilities. - Everyone on central has that --> Use this for doors that every central role should have access to, but not the aurora people
#define ACCESS_CENT_GENERAL 101
/datum/access/cent_general
	id = access_cent_general
	desc = "Code Grey"
	access_type = ACCESS_TYPE_CENTCOM

//Thunderdome.
#define ACCESS_CENT_THUNDER 102
/datum/access/cent_thunder
	id = access_cent_thunder
	desc = "Code Yellow"
	access_type = ACCESS_TYPE_CENTCOM

//Centcom Security - This access is used by the ERT / Odin Security and CCIA
// Separation between Odin Sec/CCIA and ERT is achieved via the ERT Commander Access (access_cent_creed)
#define ACCESS_CENT_SPECOPS 103
/datum/access/cent_specops
	id = access_cent_specops
	desc = "Code Black"
	access_type = ACCESS_TYPE_CENTCOM

//Medical/Research - Thats the access for the medical section. Used for the odin doctors/chemists
#define ACCESS_CENT_MEDICAL 104
/datum/access/cent_medical
	id = access_cent_medical
	desc = "Code White"
	access_type = ACCESS_TYPE_CENTCOM

//Living quarters. - Thats the accesse used by the odin bartenders/chefs
#define ACCESS_CENT_LIVING 105
/datum/access/cent_living
	id = access_cent_living
	desc = "Code Green"
	access_type = ACCESS_TYPE_CENTCOM

//Generic storage areas. - Thats used for the Maint Tunnels on Centcom
#define ACCESS_CENT_STORAGE 106
/datum/access/cent_storage
	id = access_cent_storage
	desc = "Code Orange"
	access_type = ACCESS_TYPE_CENTCOM

//107 is unused

//Creed's office. - ERT/TCFL Commander
#define ACCESS_CENT_CREED 108
/datum/access/cent_creed
	id = access_cent_creed
	desc = "Code Silver"
	access_type = ACCESS_TYPE_CENTCOM

//CCIA Access on Centcom
#define ACCESS_CENT_CCIA 109
/datum/access/cent_ccia
	id = access_cent_ccia
	desc = "Code Gold"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_MERCHANT 110//merchant access
/datum/access/merchant
	id = access_merchant
	desc = "Merchant Access"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_LEGION 111//tau ceti foreign legion access
/datum/access/legion
	id = access_legion
	desc = "Tau Ceti Foreign Legion Access"
	access_type = ACCESS_TYPE_CENTCOM

var/const/access_distress = 112
/datum/access/distress
	id = access_distress
	desc = "General ERT Base Access"
	access_type = ACCESS_TYPE_CENTCOM


/****************************
* Kataphract Chapter Access *
****************************/
var/const/access_kataphract = 113
/datum/access/kataphract
	id = access_kataphract
	desc = "Kataphract Chapter Access"
	access_type = ACCESS_TYPE_CENTCOM

var/const/access_kataphract_knight = 114
/datum/access/kataphract/knight
	id = access_kataphract_knight
	desc = "Kataphract Knight Access"

/***************
* Antag access *
***************/
#define ACCESS_SYNDICATE 150//General Syndicate Access
/datum/access/syndicate
	id = access_syndicate
	access_type = ACCESS_TYPE_SYNDICATE

#define ACCESS_SYNDICATE_LEADER 151 //Syndie Commander Access
/datum/access/syndicate_leader
	id = access_syndicate_leader
	access_type = ACCESS_TYPE_SYNDICATE

/*******
* Misc *
*******/
#define ACCESS_EQUIPMENT 199
/datum/access/equipment
	id = access_equipment
	desc = "Equipment"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_CRATE_CASH 200
/datum/access/crate_cash
	id = access_crate_cash
	access_type = ACCESS_TYPE_NONE

#define ACCESS_ORION_EXPRESS_SHIP 201
/datum/access/exress_ship
	id = access_orion_express_ship
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_GENERIC_AWAY_SITE 202
/datum/access/generic_away_site
	id = access_generic_away_site
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_NONE -1
/datum/access/none
	id = access_none
	access_type = ACCESS_TYPE_NONE

#define ACCESS_SOL_SHIPS 203
/datum/access/sol_ships
	id = access_sol_ships
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_TCFL_PEACEKEEPER_SHIP 204
/datum/access/tcfl_peacekeeper_ship
	id = access_tcfl_peacekeeper_ship
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_EE_SPY_SHIP 205
/datum/access/ee_spy_ship
	id = access_ee_spy_ship
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CIVILIAN_STATION 206
/datum/access/access_civilian_station
	id = access_civilian_station
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_ELYRAN_NAVAL_INFANTRY_SHIP 207
/datum/access/access_elyran_naval_infantry_ship
	id = access_elyran_naval_infantry_ship
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_SKRELL 208
/datum/access/access_skrell
	id = access_skrell
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_PRA 209
/datum/access/access_pra
	id = access_pra
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_UNATHI_PIRATE 210
/datum/access/access_unathi_pirate
	id = access_unathi_pirate
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_IAC_RESCUE_SHIP 211
/datum/access/access_iac_rescue_ship
	id = access_iac_rescue_ship
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_IMPERIAL_FLEET_VOIDSMAN_SHIP 212
/datum/access/access_imperial_fleet_voidsman_ship
	id = access_imperial_fleet_voidsman_ship
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_NKA 213
/datum/access/access_nka
	id = access_nka
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_DPRA 214
/datum/access/access_dpra
	id = access_dpra
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_MERCHANTS_GUILD 215
/datum/access/access_merchants_guild
	id = access_merchants_guild
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_hephaestus= 216
/datum/access/access_hephaestus
	id = access_hephaestus
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_GOLDEN_DEEP 217
/datum/access/access_golden_deep
	id = access_golden_deep
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_KONYANG_POLICE 218
/datum/access/access_konyang_police
	id = access_konyang_police
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_KONYANG_VENDORS 219
/datum/access/access_konyang_vendors
	id = access_konyang_vendors
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_IDRIS 220
/datum/access/access_idris
	id = access_idris
	desc = "Idris Vault Ship"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_COALITION 221
/datum/access/access_coalition
	id = access_coalition
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_COALITION_NAVY 222
/datum/access/access_coalition_navy
	id = access_coalition_navy
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_GADPATHUR_NAVY 223
/datum/access/access_gadpathur_navy
	id = access_gadpathur_navy
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_GADPATHUR_NAVY_OFFICER 224
/datum/access/access_gadpathur_navy_officer
	id = access_gadpathur_navy_officer
	access_type = ACCESS_TYPE_CENTCOM
