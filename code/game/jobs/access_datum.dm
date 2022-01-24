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
/var/const/access_security = 1
/datum/access/security
	id = access_security
	desc = "Security Equipment"
	region = ACCESS_REGION_SECURITY

/var/const/access_brig = 2 // Brig timers and permabrig
/datum/access/holding
	id = access_brig
	desc = "Holding Cells"
	region = ACCESS_REGION_SECURITY

/var/const/access_armory = 3
/datum/access/armory
	id = access_armory
	desc = "Armory"
	region = ACCESS_REGION_SECURITY

/var/const/access_forensics_lockers = 4
/datum/access/forensics_lockers
	id = access_forensics_lockers
	desc = "Forensics"
	region = ACCESS_REGION_SECURITY

/var/const/access_medical = 5
/datum/access/medical
	id = access_medical
	desc = "Medical"
	region = ACCESS_REGION_MEDBAY

/var/const/access_morgue = 6
/datum/access/morgue
	id = access_morgue
	desc = "Morgue"
	region = ACCESS_REGION_MEDBAY

/var/const/access_tox = 7
/datum/access/tox
	id = access_tox
	desc = "R&D Lab"
	region = ACCESS_REGION_RESEARCH

/var/const/access_tox_storage = 8
/datum/access/tox_storage
	id = access_tox_storage
	desc = "Toxins Lab"
	region = ACCESS_REGION_RESEARCH

/var/const/access_genetics = 9
/datum/access/genetics
	id = access_genetics
	desc = "Genetics Lab"
	region = ACCESS_REGION_MEDBAY

/var/const/access_engine = 10
/datum/access/engine
	id = access_engine
	desc = "Engineering"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_engine_equip = 11
/datum/access/engine_equip
	id = access_engine_equip
	desc = "Engine Room"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_maint_tunnels = 12
/datum/access/maint_tunnels
	id = access_maint_tunnels
	desc = "Maintenance"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_external_airlocks = 13
/datum/access/external_airlocks
	id = access_external_airlocks
	desc = "External Airlocks"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_emergency_storage = 14
/datum/access/emergency_storage
	id = access_emergency_storage
	desc = "Emergency Storage"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_change_ids = 15
/datum/access/change_ids
	id = access_change_ids
	desc = "ID Computer"
	region = ACCESS_REGION_COMMAND

/var/const/access_ai_upload = 16
/datum/access/ai_upload
	id = access_ai_upload
	desc = "AI Upload"
	region = ACCESS_REGION_COMMAND

/var/const/access_teleporter = 17
/datum/access/teleporter
	id = access_teleporter
	desc = "Teleporter"
	region = ACCESS_REGION_COMMAND

/var/const/access_eva = 18
/datum/access/eva
	id = access_eva
	desc = "EVA"
	region = ACCESS_REGION_COMMAND

/var/const/access_heads = 19
/datum/access/heads
	id = access_heads
	desc = "Bridge"
	region = ACCESS_REGION_COMMAND

/var/const/access_captain = 20
/datum/access/captain
	id = access_captain
	desc = "Captain"
	region = ACCESS_REGION_COMMAND

/var/const/access_all_personal_lockers = 21
/datum/access/all_personal_lockers
	id = access_all_personal_lockers
	desc = "Personal Lockers"
	region = ACCESS_REGION_COMMAND

/var/const/access_chapel_office = 22
/datum/access/chapel_office
	id = access_chapel_office
	desc = "Chapel Office"
	region = ACCESS_REGION_GENERAL

/var/const/access_tech_storage = 23
/datum/access/tech_storage
	id = access_tech_storage
	desc = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_atmospherics = 24
/datum/access/atmospherics
	id = access_atmospherics
	desc = "Atmospherics"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_bar = 25
/datum/access/bar
	id = access_bar
	desc = "Bar"
	region = ACCESS_REGION_GENERAL

/var/const/access_janitor = 26
/datum/access/janitor
	id = access_janitor
	desc = "Custodial Closet"
	region = ACCESS_REGION_GENERAL

/var/const/access_crematorium = 27
/datum/access/crematorium
	id = access_crematorium
	desc = "Crematorium"
	region = ACCESS_REGION_GENERAL

/var/const/access_kitchen = 28
/datum/access/kitchen
	id = access_kitchen
	desc = "Kitchen"
	region = ACCESS_REGION_GENERAL

/var/const/access_robotics = 29
/datum/access/robotics
	id = access_robotics
	desc = "Robotics"
	region = ACCESS_REGION_RESEARCH

/var/const/access_rd = 30
/datum/access/rd
	id = access_rd
	desc = "Research Director"
	region = ACCESS_REGION_RESEARCH

/var/const/access_cargo = 31
/datum/access/cargo
	id = access_cargo
	desc = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

/var/const/access_construction = 32
/datum/access/construction
	id = access_construction
	desc = "Construction Areas"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_pharmacy = 33
/datum/access/pharmacy
	id = access_pharmacy
	desc = "Pharmacy Lab"
	region = ACCESS_REGION_MEDBAY

/var/const/access_cargo_bot = 34
/datum/access/cargo_bot
	id = access_cargo_bot
	desc = "Cargo Bot Delivery"
	region = ACCESS_REGION_SUPPLY

/var/const/access_hydroponics = 35
/datum/access/hydroponics
	id = access_hydroponics
	desc = "Hydroponics"
	region = ACCESS_REGION_GENERAL

/var/const/access_manufacturing = 36
/datum/access/manufacturing
	id = access_manufacturing
	desc = "Manufacturing"
	access_type = ACCESS_TYPE_NONE

/var/const/access_library = 37
/datum/access/library
	id = access_library
	desc = "Library"
	region = ACCESS_REGION_GENERAL

/var/const/access_lawyer = 38
/datum/access/lawyer
	id = access_lawyer
	desc = "Representative"
	region = ACCESS_TYPE_CENTCOM

/var/const/access_virology = 39
/datum/access/virology
	id = access_virology
	desc = "Virology"
	region = ACCESS_REGION_MEDBAY

/var/const/access_cmo = 40
/datum/access/cmo
	id = access_cmo
	desc = "Chief Medical Officer"
	region = ACCESS_REGION_COMMAND

/var/const/access_qm = 41
/datum/access/qm
	id = access_qm
	desc = "Quartermaster"
	region = ACCESS_REGION_SUPPLY

/var/const/access_network = 42
/datum/access/network
	id = access_network
	desc = "Station Network"
	region = ACCESS_REGION_RESEARCH

// /var/const/free_access_id = 43
// /var/const/free_access_id = 44

/var/const/access_surgery = 45
/datum/access/surgery
	id = access_surgery
	desc = "Surgery"
	region = ACCESS_REGION_MEDBAY

// /var/const/free_access_id = 46

/var/const/access_research = 47
/datum/access/research
	id = access_research
	desc = "Science"
	region = ACCESS_REGION_RESEARCH

/var/const/access_mining = 48
/datum/access/mining
	id = access_mining
	desc = "Mining"
	region = ACCESS_REGION_SUPPLY

/var/const/access_mining_office = 49
/datum/access/mining_office
	id = access_mining_office
	desc = "Mining Office"
	access_type = ACCESS_TYPE_NONE

/var/const/access_mailsorting = 50
/datum/access/mailsorting
	id = access_mailsorting
	desc = "Cargo Office"
	region = ACCESS_REGION_SUPPLY

// /var/const/free_access_id = 51
// /var/const/free_access_id = 52

/var/const/access_heads_vault = 53
/datum/access/heads_vault
	id = access_heads_vault
	desc = "Main Vault"
	region = ACCESS_REGION_COMMAND

/var/const/access_mining_station = 54
/datum/access/mining_station
	id = access_mining_station
	desc = "Mining EVA"
	region = ACCESS_REGION_SUPPLY

/var/const/access_xenobiology = 55
/datum/access/xenobiology
	id = access_xenobiology
	desc = "Xenobiology Lab"
	region = ACCESS_REGION_RESEARCH

/var/const/access_ce = 56
/datum/access/ce
	id = access_ce
	desc = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

/var/const/access_hop = 57
/datum/access/hop
	id = access_hop
	desc = "Head of Personnel"
	region = ACCESS_REGION_COMMAND

/var/const/access_hos = 58
/datum/access/hos
	id = access_hos
	desc = "Head of Security"
	region = ACCESS_REGION_SECURITY

/var/const/access_RC_announce = 59 //Requests console announcements
/datum/access/RC_announce
	id = access_RC_announce
	desc = "RC Announcements"
	region = ACCESS_REGION_COMMAND

/var/const/access_keycard_auth = 60 //Used for events which require at least two people to confirm them
/datum/access/keycard_auth
	id = access_keycard_auth
	desc = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

/var/const/access_tcomsat = 61 // has access to the entire telecomms satellite / machinery
/datum/access/tcomsat
	id = access_tcomsat
	desc = "Telecommunications"
	region = ACCESS_REGION_COMMAND

/var/const/access_gateway = 62
/datum/access/gateway
	id = access_gateway
	desc = "Gateway"
	region = ACCESS_REGION_COMMAND

/var/const/access_sec_doors = 63 // Security front doors
/datum/access/sec_doors
	id = access_sec_doors
	desc = "Security"
	region = ACCESS_REGION_SECURITY

/var/const/access_psychiatrist = 64 // Psychiatrist's office
/datum/access/psychiatrist
	id = access_psychiatrist
	desc = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

/var/const/access_xenoarch = 65
/datum/access/xenoarch
	id = access_xenoarch
	desc = "Xenoarchaeology"
	region = ACCESS_REGION_RESEARCH

/var/const/access_medical_equip = 66
/datum/access/medical_equip
	id = access_medical_equip
	desc = "Medical Equipment"
	region = ACCESS_REGION_MEDBAY

/var/const/access_first_responder = 67
/datum/access/access_first_responder
	id = access_first_responder
	desc = "First Responder Equipment"
	region = ACCESS_REGION_MEDBAY

/var/const/access_detective = 68
/datum/access/access_detective
	id = access_detective
	desc = "Detective Equipment"
	region = ACCESS_REGION_SECURITY

/var/const/access_weapons = 69
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

/******************
* Central Command *
******************/
//General facilities. - Everyone on central has that --> Use this for doors that every central role should have access to, but not the aurora people
/var/const/access_cent_general = 101
/datum/access/cent_general
	id = access_cent_general
	desc = "Code Grey"
	access_type = ACCESS_TYPE_CENTCOM

//Thunderdome.
/var/const/access_cent_thunder = 102
/datum/access/cent_thunder
	id = access_cent_thunder
	desc = "Code Yellow"
	access_type = ACCESS_TYPE_CENTCOM

//Centcom Security - This access is used by the ERT / Odin Security and CCIA
// Separation between Odin Sec/CCIA and ERT is achieved via the ERT Commander Access (access_cent_creed)
/var/const/access_cent_specops = 103
/datum/access/cent_specops
	id = access_cent_specops
	desc = "Code Black"
	access_type = ACCESS_TYPE_CENTCOM

//Medical/Research - Thats the access for the medical section. Used for the odin doctors/chemists
/var/const/access_cent_medical = 104
/datum/access/cent_medical
	id = access_cent_medical
	desc = "Code White"
	access_type = ACCESS_TYPE_CENTCOM

//Living quarters. - Thats the accesse used by the odin bartenders/chefs
/var/const/access_cent_living = 105
/datum/access/cent_living
	id = access_cent_living
	desc = "Code Green"
	access_type = ACCESS_TYPE_CENTCOM

//Generic storage areas. - Thats used for the Maint Tunnels on Centcom
/var/const/access_cent_storage = 106
/datum/access/cent_storage
	id = access_cent_storage
	desc = "Code Orange"
	access_type = ACCESS_TYPE_CENTCOM

//107 is unused

//Creed's office. - ERT/TCFL Commander
/var/const/access_cent_creed = 108
/datum/access/cent_creed
	id = access_cent_creed
	desc = "Code Silver"
	access_type = ACCESS_TYPE_CENTCOM

//CCIA Access on Centcom
/var/const/access_cent_ccia = 109
/datum/access/cent_ccia
	id = access_cent_ccia
	desc = "Code Gold"
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_merchant = 110//merchant access
/datum/access/merchant
	id = access_merchant
	desc = "Merchant Access"
	access_type = ACCESS_TYPE_CENTCOM

/var/const/access_legion = 111//tau ceti foreign legion access
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

var/const/access_kataphract_quartermaster = 115
/datum/access/kataphract/quartermaster
	id = access_kataphract_quartermaster
	desc = "Kataphract Quartermaster Access"

var/const/access_kataphract_trader = 116
/datum/access/kataphract/trader
	id = access_kataphract_trader
	desc = "Kataphract Trader Access"

/***************
* Antag access *
***************/
/var/const/access_syndicate = 150//General Syndicate Access
/datum/access/syndicate
	id = access_syndicate
	access_type = ACCESS_TYPE_SYNDICATE

/var/const/access_syndicate_leader = 151 //Syndie Commander Access
/datum/access/syndicate_leader
	id = access_syndicate_leader
	access_type = ACCESS_TYPE_SYNDICATE

/*******
* Misc *
*******/
/var/const/access_synth = 199
/datum/access/synthetic
	id = access_synth
	desc = "Synthetic"
	access_type = ACCESS_TYPE_NONE

/var/const/access_crate_cash = 200
/datum/access/crate_cash
	id = access_crate_cash
	access_type = ACCESS_TYPE_NONE

/var/const/access_none = -1
/datum/access/none
	id = access_none
	access_type = ACCESS_TYPE_NONE

