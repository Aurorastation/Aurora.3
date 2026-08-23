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
/datum/access/security
	id = 1
	desc = "Security Equipment"
	region = ACCESS_REGION_SECURITY

/// Brig timers and permabrig
/datum/access/holding
	id = 2
	desc = "Holding Cells"
	region = ACCESS_REGION_SECURITY

/datum/access/armory
	id = 3
	desc = "Armory"
	region = ACCESS_REGION_SECURITY

/datum/access/forensics_lockers
	id = 4
	desc = "Forensics"
	region = ACCESS_REGION_SECURITY

/datum/access/medical
	id = 5
	desc = "Medical"
	region = ACCESS_REGION_MEDBAY

/datum/access/morgue
	id = 6
	desc = "Morgue"
	region = ACCESS_REGION_MEDBAY

/datum/access/tox
	id = 7
	desc = "R&D Lab"
	region = ACCESS_REGION_RESEARCH

/// Used only for science lockers/science gun cabinets
/datum/access/tox_storage
	id = 8
	desc = "Toxins Lab"
	region = ACCESS_REGION_RESEARCH

/// NOT CURRENT USED ANYWHERE
/datum/access/genetics
	id = 9
	desc = "Genetics Lab"
	region = ACCESS_REGION_MEDBAY

/datum/access/engine
	id = 10
	desc = "Engineering"
	region = ACCESS_REGION_ENGINEERING

/datum/access/engine_equip
	id = 11
	desc = "Engine Room"
	region = ACCESS_REGION_ENGINEERING

/datum/access/maint_tunnels
	id = 12
	desc = "Maintenance"
	region = ACCESS_REGION_ENGINEERING

/datum/access/external_airlocks
	id = 13
	desc = "External Airlocks"
	region = ACCESS_REGION_ENGINEERING

/// NOT CURRENTLY USED ANYWHERE
/datum/access/emergency_storage
	id = 14
	desc = "Emergency Storage"
	region = ACCESS_REGION_ENGINEERING

/// Used only in '/datum/computer_file/program/card_mod'
/datum/access/change_ids
	id = 15
	desc = "ID Computer"
	region = ACCESS_REGION_COMMAND

/datum/access/ai_upload
	id = 16
	desc = "AI Upload"
	region = ACCESS_REGION_COMMAND

/datum/access/teleporter
	id = 17
	desc = "Teleporter"
	region = ACCESS_REGION_COMMAND

/datum/access/eva
	id = 18
	desc = "EVA"
	region = ACCESS_REGION_COMMAND

/datum/access/heads
	id = 19
	desc = "Bridge"
	region = ACCESS_REGION_COMMAND

/datum/access/captain
	id = 20
	desc = "Captain"
	region = ACCESS_REGION_COMMAND

/datum/access/all_personal_lockers
	id = 21
	desc = "Personal Lockers"
	region = ACCESS_REGION_COMMAND

/datum/access/chapel_office
	id = 22
	desc = "Chapel Office"
	region = ACCESS_REGION_GENERAL

/datum/access/tech_storage
	id = 23
	desc = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

/datum/access/atmospherics
	id = 24
	desc = "Atmospherics"
	region = ACCESS_REGION_ENGINEERING

/datum/access/bar
	id = 25
	desc = "Bar"
	region = ACCESS_REGION_GENERAL

/datum/access/janitor
	id = 26
	desc = "Custodial Closet"
	region = ACCESS_REGION_GENERAL

/// Only used for morgue crematorium switch, and the only one that exists has its access vars nulled anyway.
/datum/access/crematorium
	id = 27
	desc = "Crematorium"
	region = ACCESS_REGION_GENERAL

/datum/access/galley
	id = 28
	desc = "Galley"
	region = ACCESS_REGION_GENERAL

/datum/access/robotics
	id = 29
	desc = "Robotics"
	region = ACCESS_REGION_RESEARCH

/datum/access/rd
	id = 30
	desc = "Research Director"
	region = ACCESS_REGION_RESEARCH

/datum/access/cargo
	id = 31
	desc = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

/// Used only for locked welding lockers and engineering suit cyclers, weirdly.
/datum/access/construction
	id = 32
	desc = "Construction Areas"
	region = ACCESS_REGION_ENGINEERING

/datum/access/pharmacy
	id = 33
	desc = "Pharmacy Lab"
	region = ACCESS_REGION_MEDBAY

/// NOT CURRENTLY USED ANYWHERE
/datum/access/cargo_bot
	id = 34
	desc = "Cargo Bot Delivery"
	region = ACCESS_REGION_SUPPLY

/datum/access/hydroponics
	id = 35
	desc = "Hydroponics"
	region = ACCESS_REGION_GENERAL

/// NOT CURRENTLY USED ANYWHERE
/datum/access/manufacturing
	id = 36
	desc = "Manufacturing"
	access_type = ACCESS_TYPE_NONE

/datum/access/library
	id = 37
	desc = "Library"
	region = ACCESS_REGION_GENERAL

/datum/access/lawyer
	id = 38
	desc = "Representative"
	region = ACCESS_TYPE_CENTCOM

/// Used only for '/obj/item/storage/lockbox/vials' and a smartfridge variant no longer mapped anywhere.
/datum/access/virology
	id = 39
	desc = "Virology"
	region = ACCESS_REGION_MEDBAY

/datum/access/cmo
	id = 40
	desc = "Chief Medical Officer"
	region = ACCESS_REGION_COMMAND

/datum/access/qm
	id = 41
	desc = "Operations Manager"
	region = ACCESS_REGION_SUPPLY

/datum/access/network
	id = 42
	desc = "Station Network"
	region = ACCESS_REGION_RESEARCH

/// NOT CURRENTLY USED ANYWHERE
/datum/access/leviathan
	id = 43
	desc = "Leviathan"
	region = ACCESS_REGION_COMMAND

// free_access_id = 44

/datum/access/surgery
	id = 45
	desc = "Surgery"
	region = ACCESS_REGION_MEDBAY

// free_access_id = 46

/datum/access/research
	id = 47
	desc = "Science"
	region = ACCESS_REGION_RESEARCH

/datum/access/mining
	id = 48
	desc = "Mining"
	region = ACCESS_REGION_SUPPLY

/// NOT CURRENTLY USED ANYWHERE
/datum/access/mining_office
	id = 49
	desc = "Mining Office"
	access_type = ACCESS_TYPE_NONE

/// Only used as a weird standin for Operations in camera network access.
/datum/access/mailsorting
	id = 50
	desc = "Cargo Office"
	region = ACCESS_REGION_SUPPLY

// free_access_id = 51

/datum/access/xenobotany
	id = 52
	desc = "Xenobotany"
	region = ACCESS_REGION_RESEARCH

/// NOT CURRENTLY USED ANYWHERE
/datum/access/heads_vault
	id = 53
	desc = "Main Vault"
	region = ACCESS_REGION_COMMAND

/// NOT CURRENTLY USED ANYWHERE
/datum/access/mining_station
	id = 54
	desc = "Mining EVA"
	region = ACCESS_REGION_SUPPLY

/datum/access/xenobiology
	id = 55
	desc = "Xenobiology Lab"
	region = ACCESS_REGION_RESEARCH

/datum/access/ce
	id = 56
	desc = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

/datum/access/hop
	id = 57
	desc = "Executive Officer"
	region = ACCESS_REGION_COMMAND

/datum/access/hos
	id = 58
	desc = "Head of Security"
	region = ACCESS_REGION_SECURITY

/// Requests console announcements
/datum/access/RC_announce
	id = 59
	desc = "RC Announcements"
	region = ACCESS_REGION_COMMAND

/// Used for events which require at least two people to confirm them
/datum/access/keycard_auth
	id = 60
	desc = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

/// Has access to the interior Telecomms compartment
/datum/access/tcomsat
	id = 61
	desc = "Telecommunications"
	region = ACCESS_REGION_COMMAND

/// NOT CURRENTLY USED ANYWHERE
/datum/access/gateway
	id = 62
	desc = "Gateway"
	region = ACCESS_REGION_COMMAND

/// Security front doors
/datum/access/sec_doors
	id = 63
	desc = "Security"
	region = ACCESS_REGION_SECURITY

/// Psychiatrist's office
/datum/access/psychiatrist
	id = 64
	desc = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

/datum/access/xenoarch
	id = 65
	desc = "Xenoarchaeology"
	region = ACCESS_REGION_RESEARCH

/datum/access/medical_equip
	id = 66
	desc = "Medical Equipment"
	region = ACCESS_REGION_MEDBAY

/datum/access/paramedic
	id = 67
	desc = "Paramedic Equipment"
	region = ACCESS_REGION_MEDBAY

// free_access_id = 68

/// Used by firing pins.
/datum/access/weapons
	id = 69
	desc = "Weaponry Permission"
	region = ACCESS_REGION_SECURITY

/// Journalist's office access
/datum/access/journalist
	id = 70
	desc = "Media Office"
	region = ACCESS_REGION_GENERAL

/// Allows some unique interactions with devices
/datum/access/tech_support
	id = 71
	desc = "Tech Support"

/datum/access/consular
	id = 72
	desc = "Consular"

/datum/access/intrepid
	id = 73
	desc = "Intrepid Shuttle"
	region = ACCESS_REGION_COMMAND

/datum/access/bridge_crew
	id = 74
	desc = "Bridge Crew"
	region = ACCESS_REGION_COMMAND

/datum/access/ship_weapons
	id = 75
	desc = "Ship Weapons"
	region = ACCESS_REGION_SUPPLY

/datum/access/spark
	id = 76
	desc = "Spark Shuttle"
	region = ACCESS_REGION_COMMAND

/datum/access/quark
	id = 77
	desc = "Quark Shuttle"
	region = ACCESS_REGION_COMMAND

/datum/access/canary
	id = 78
	desc = "Canary Shuttle"
	region = ACCESS_REGION_COMMAND

/******************
* Central Command *
******************/
//General facilities. - Everyone on central has that --> Use this for doors that every central role should have access to, but not the aurora people
/datum/access/cent_general
	id = 101
	desc = "Code Grey"
	access_type = ACCESS_TYPE_CENTCOM

//Thunderdome.
/datum/access/cent_thunder
	id = 102
	desc = "Code Yellow"
	access_type = ACCESS_TYPE_CENTCOM

//Centcom Security - This access is used by the ERT / Odin Security and CCIA
// Separation between Odin Sec/CCIA and ERT is achieved via the ERT Commander Access (/datum/access/cent_creed::id)
/datum/access/cent_specops
	id = 103
	desc = "Code Black"
	access_type = ACCESS_TYPE_CENTCOM

//Medical/Research - Thats the access for the medical section. Used for the odin doctors/chemists
/datum/access/cent_medical
	id = 104
	desc = "Code White"
	access_type = ACCESS_TYPE_CENTCOM

//Living quarters, the access used by the odin bartenders/chefs
/datum/access/cent_living
	id = 105
	desc = "Code Green"
	access_type = ACCESS_TYPE_CENTCOM

//Generic storage areas, used for the Maint Tunnels on Centcom
/datum/access/cent_storage
	id = 106
	desc = "Code Orange"
	access_type = ACCESS_TYPE_CENTCOM

//107 is unused

//Creed's office. - ERT/TCFL Commander
/datum/access/cent_creed
	id = 108
	desc = "Code Silver"
	access_type = ACCESS_TYPE_CENTCOM

//CCIA Access on Centcom
/datum/access/cent_ccia
	id = 109
	desc = "Code Gold"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/merchant
	id = 110//merchant
	desc = "Merchant Access"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/tcaf
	id = 111//tau
	desc = "Tau Ceti Armed Forces Access"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/distress
	id = 112
	desc = "General ERT Base Access"
	access_type = ACCESS_TYPE_CENTCOM


/****************************
* Kataphract Chapter Access *
****************************/
/datum/access/kataphract
	id = 113
	desc = "Kataphract Chapter Access"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/kataphract/knight
	id = 114
	desc = "Kataphract Knight Access"

/***************
* Antag access *
***************/
/datum/access/syndicate
	id = 150//General
	access_type = ACCESS_TYPE_SYNDICATE

/datum/access/syndicate_leader
	id = 151
	access_type = ACCESS_TYPE_SYNDICATE

/*******
* Misc *
*******/
/datum/access/equipment
	id = 199
	desc = "Equipment"
	access_type = ACCESS_TYPE_NONE

/datum/access/crate_cash
	id = 200
	access_type = ACCESS_TYPE_NONE

/datum/access/exress_ship
	id = 201
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/generic_away_site
	id = 202
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/none
	id = -1
	access_type = ACCESS_TYPE_NONE

/datum/access/sol_ships
	id = 203
	access_type = ACCESS_TYPE_CENTCOM

/// 204 is vacant

/datum/access/ee_spy_ship
	id = 205
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/civilian_station
	id = 206
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/elyran_naval_infantry_ship
	id = 207
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/skrell
	id = 208
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/pra
	id = 209
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/unathi_pirate
	id = 210
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/iac_rescue_shit
	id = 211
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/imperial_fleet_voidsman_ship
	id = 212
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/nka
	id = 213
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/dpra
	id = 214
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/merchants_guild
	id = 215
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/hephaestus
	id = 216
	access_type = ACCESS_TYPE_CENTCOM

// For the Golden Deep ghostrole. This is the access for the merchant and guards, but not for the owned synthetics.
/datum/access/golden_deep
	id = 217
	access_type = ACCESS_TYPE_CENTCOM
	desc = "Golden Deep"

/datum/access/portofcall_police
	id = 218
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/portofcall_vendors
	id = 219
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/idris
	id = 220
	desc = "Idris Ship Crew Member"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/coalition
	id = 221
	desc = "Coalition of Colonies"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/coalition_navy
	id = 222
	desc = "Coalition Navy"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/gadpathur_navy
	id = 223
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/gadpathur_navy_officer
	id = 224
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/portofcall_corporate
	id = 225
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/house_volvalaad_ship
	id = 226
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/moghes_wasteland_ozeuoi
	id = 227
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/autakh
	id = 228
	access_type = ACCESS_TYPE_CENTCOM

// For the Golden Deep ghostrole. This is for the owned synthetics, so they lack some of the access their superiors enjoy.
/datum/access/golden_deep_owned
	id = 229
	access_type = ACCESS_TYPE_CENTCOM
	desc = "Golden Deep, Limited Access"

//guest rooms - for any ship/event that requires hotel-esque rooms

/datum/access/guest_rooms
	id = 230
	desc = "Guest Rooms - All"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/guest_room_1
	id = 231
	desc = "Guest Room 1"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/guest_room_2
	id = 232
	desc = "Guest Room 2"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/guest_room_3
	id = 233
	desc = "Guest Room 3"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/guest_room_4
	id = 234
	desc = "Guest Room 4"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/guest_room_5
	id = 235
	desc = "Guest Room 5"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/guest_room_6
	id = 236
	desc = "Guest Room 6"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/guest_room_7
	id = 237
	desc = "Guest Room 7"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/guest_room_8
	id = 238
	desc = "Guest Room 8"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/guest_room_9
	id = 239
	desc = "Guest Room 9"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/guest_room_10
	id = 240
	desc = "Guest Room 10"

/datum/access/unathi_trawler_access
	id = 241
	desc = "General Fishing Trawler Access"

/datum/access/tramp_freighter_access
	id = 242
	desc = "Independent Freighter Access"

/datum/access/lone_spacer_access
	id = 243
	desc = "Independent Skiff Access"

/datum/access/cryo_outpost_access
	id = 244
	desc = "Outpost #187-D Access"

/datum/access/ruined_propellant_depot_access
	id = 245
	desc = "Propellant Depot AG5 Access"

/datum/access/splf_access
	id = 246
	desc = "SPLF Access"

/datum/access/nuclear_missile_silo_access
	id = 247
	desc = "Nuclear Missile Silo Access"

/datum/access/nuclear_missile_silo_access_high
	id = 248
	desc = "Nuclear Missile Silo Access High Security"

/datum/access/enviro_testing_facility_access_control
	id = 249
	desc = "Env-Test Facility Zoya, Control Access"

/datum/access/enviro_testing_facility_access_medres
	id = 250
	desc = "Env-Test Facility Zoya, Medical-Research Access"

/datum/access/enviro_testing_facility_access_engops
	id = 251
	desc = "Env-Test Facility Zoya, Engineering-Operations Access"

/datum/access/enviro_testing_facility_access_sec
	id = 252
	desc = "Env-Test Facility Zoya, Security Access"

	id = 253
	desc = "Himean Military Patrol Vessel"

/datum/access/quarantined_outpost_engineer
	id = 254
	desc = "Outpost Nemora, Engineering Clearance"

/datum/access/decrepit_shipyard_staff
	id = 255
	desc = "Decrepit Shipyard, Staff Access"

/datum/access/voidtamer_ship
	id = 256
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/abandoned_casino
	id = 257

