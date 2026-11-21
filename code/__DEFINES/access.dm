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

/// Converts any `/datum/access` typepaths in a list into their numeric `::id` values.
/// Takes a mixed list like `list(42, ACCESS_SECURITY, /datum/access/horizon/security::id, /datum/access/horizon/armory)`.
/// Returns a list with only numeric IDs.
/proc/resolve_access_list(list/access_list)
	// if null or empty, do nothing
	if(!access_list)
		return access_list

	// copy prevents mutating lists shared across instances
	var/list/resolved = access_list.Copy()

	for(var/i in 1 to length(resolved))
		var/entry = resolved[i]

		// valid raw numeric ID
		if(isnum(entry))
			continue

		// valid access datum path
		if(ispath(entry, /datum/access))
			var/datum/access/acc_type = entry

			// abstract types should not be used
			#ifdef UNIT_TEST
			if(is_abstract(acc_type))
				dbg_stack_trace("resolve_access_list(): access path '[entry]' is abstract")
			#endif

			var/resolved_id = acc_type::id
			resolved[i] = resolved_id
			continue

		// neither a number nor a valid access typepath
		dbg_stack_trace("resolve_access_list(): item '[entry]' is neither number nor /datum/access path")

	return resolved

/*****************
* Station access *
*****************/
ABSTRACT_TYPE(/datum/access/horizon)

/datum/access/horizon/security
	id = 1
	desc = "Security Equipment"
	region = ACCESS_REGION_SECURITY

/// Brig timers and permabrig
/datum/access/horizon/holding
	id = 2
	desc = "Holding Cells"
	region = ACCESS_REGION_SECURITY

/datum/access/horizon/armory
	id = 3
	desc = "Armory"
	region = ACCESS_REGION_SECURITY

/datum/access/horizon/forensics_lockers
	id = 4
	desc = "Forensics"
	region = ACCESS_REGION_SECURITY

/datum/access/horizon/medical
	id = 5
	desc = "Medical"
	region = ACCESS_REGION_MEDBAY

/datum/access/horizon/morgue
	id = 6
	desc = "Morgue"
	region = ACCESS_REGION_MEDBAY

/datum/access/horizon/tox
	id = 7
	desc = "R&D Lab"
	region = ACCESS_REGION_RESEARCH

/// Used only for science lockers/science gun cabinets
/datum/access/horizon/tox_storage
	id = 8
	desc = "Toxins Lab"
	region = ACCESS_REGION_RESEARCH

/// NOT CURRENT USED ANYWHERE
/datum/access/horizon/genetics
	id = 9
	desc = "Genetics Lab"
	region = ACCESS_REGION_MEDBAY

/datum/access/horizon/engine
	id = 10
	desc = "Engineering"
	region = ACCESS_REGION_ENGINEERING

/datum/access/horizon/engine_equip
	id = 11
	desc = "Engine Room"
	region = ACCESS_REGION_ENGINEERING

/datum/access/horizon/maint_tunnels
	id = 12
	desc = "Maintenance"
	region = ACCESS_REGION_ENGINEERING

/datum/access/horizon/external_airlocks
	id = 13
	desc = "External Airlocks"
	region = ACCESS_REGION_ENGINEERING

/// NOT CURRENTLY USED ANYWHERE
/datum/access/horizon/emergency_storage
	id = 14
	desc = "Emergency Storage"
	region = ACCESS_REGION_ENGINEERING

/// Used only in '/datum/computer_file/program/card_mod'
/datum/access/horizon/change_ids
	id = 15
	desc = "ID Computer"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/ai_upload
	id = 16
	desc = "AI Upload"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/teleporter
	id = 17
	desc = "Teleporter"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/eva
	id = 18
	desc = "EVA"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/heads
	id = 19
	desc = "Bridge"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/captain
	id = 20
	desc = "Captain"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/all_personal_lockers
	id = 21
	desc = "Personal Lockers"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/chapel_office
	id = 22
	desc = "Chapel Office"
	region = ACCESS_REGION_GENERAL

/datum/access/horizon/tech_storage
	id = 23
	desc = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

/datum/access/horizon/atmospherics
	id = 24
	desc = "Atmospherics"
	region = ACCESS_REGION_ENGINEERING

/datum/access/horizon/bar
	id = 25
	desc = "Bar"
	region = ACCESS_REGION_GENERAL

/datum/access/horizon/janitor
	id = 26
	desc = "Custodial Closet"
	region = ACCESS_REGION_GENERAL

/// Only used for morgue crematorium switch, and the only one that exists has its access vars nulled anyway.
/datum/access/horizon/crematorium
	id = 27
	desc = "Crematorium"
	region = ACCESS_REGION_GENERAL

/datum/access/horizon/galley
	id = 28
	desc = "Galley"
	region = ACCESS_REGION_GENERAL

/datum/access/horizon/robotics
	id = 29
	desc = "Robotics"
	region = ACCESS_REGION_RESEARCH

/datum/access/horizon/rd
	id = 30
	desc = "Research Director"
	region = ACCESS_REGION_RESEARCH

/datum/access/horizon/cargo
	id = 31
	desc = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

/// Used only for locked welding lockers and engineering suit cyclers, weirdly.
/datum/access/horizon/construction
	id = 32
	desc = "Construction Areas"
	region = ACCESS_REGION_ENGINEERING

/datum/access/horizon/pharmacy
	id = 33
	desc = "Pharmacy Lab"
	region = ACCESS_REGION_MEDBAY

/// NOT CURRENTLY USED ANYWHERE
/datum/access/horizon/cargo_bot
	id = 34
	desc = "Cargo Bot Delivery"
	region = ACCESS_REGION_SUPPLY

/datum/access/horizon/hydroponics
	id = 35
	desc = "Hydroponics"
	region = ACCESS_REGION_GENERAL

/// NOT CURRENTLY USED ANYWHERE
/datum/access/horizon/manufacturing
	id = 36
	desc = "Manufacturing"
	access_type = ACCESS_TYPE_NONE

/datum/access/horizon/library
	id = 37
	desc = "Library"
	region = ACCESS_REGION_GENERAL

/datum/access/horizon/lawyer
	id = 38
	desc = "Representative"
	region = ACCESS_TYPE_CENTCOM

/// Used only for '/obj/item/storage/lockbox/vials' and a smartfridge variant no longer mapped anywhere.
/datum/access/horizon/virology
	id = 39
	desc = "Virology"
	region = ACCESS_REGION_MEDBAY

/datum/access/horizon/cmo
	id = 40
	desc = "Chief Medical Officer"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/qm
	id = 41
	desc = "Operations Manager"
	region = ACCESS_REGION_SUPPLY

/datum/access/horizon/network
	id = 42
	desc = "Station Network"
	region = ACCESS_REGION_RESEARCH

/// NOT CURRENTLY USED ANYWHERE
/datum/access/horizon/leviathan
	id = 43
	desc = "Leviathan"
	region = ACCESS_REGION_COMMAND

// free_access_id = 44

/datum/access/horizon/surgery
	id = 45
	desc = "Surgery"
	region = ACCESS_REGION_MEDBAY

// free_access_id = 46

/datum/access/horizon/research
	id = 47
	desc = "Science"
	region = ACCESS_REGION_RESEARCH

/datum/access/horizon/mining
	id = 48
	desc = "Mining"
	region = ACCESS_REGION_SUPPLY

/// NOT CURRENTLY USED ANYWHERE
/datum/access/horizon/mining_office
	id = 49
	desc = "Mining Office"
	access_type = ACCESS_TYPE_NONE

/// Only used as a weird standin for Operations in camera network access.
/datum/access/horizon/mailsorting
	id = 50
	desc = "Cargo Office"
	region = ACCESS_REGION_SUPPLY

// free_access_id = 51

/datum/access/horizon/xenobotany
	id = 52
	desc = "Xenobotany"
	region = ACCESS_REGION_RESEARCH

/// NOT CURRENTLY USED ANYWHERE
/datum/access/horizon/heads_vault
	id = 53
	desc = "Main Vault"
	region = ACCESS_REGION_COMMAND

/// NOT CURRENTLY USED ANYWHERE
/datum/access/horizon/mining_station
	id = 54
	desc = "Mining EVA"
	region = ACCESS_REGION_SUPPLY

/datum/access/horizon/xenobiology
	id = 55
	desc = "Xenobiology Lab"
	region = ACCESS_REGION_RESEARCH

/datum/access/horizon/ce
	id = 56
	desc = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

/datum/access/horizon/hop
	id = 57
	desc = "Executive Officer"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/hos
	id = 58
	desc = "Head of Security"
	region = ACCESS_REGION_SECURITY

/// Requests console announcements
/datum/access/horizon/RC_announce
	id = 59
	desc = "RC Announcements"
	region = ACCESS_REGION_COMMAND

/// Used for events which require at least two people to confirm them
/datum/access/horizon/keycard_auth
	id = 60
	desc = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

/// Has access to the interior Telecomms compartment
/datum/access/horizon/tcomsat
	id = 61
	desc = "Telecommunications"
	region = ACCESS_REGION_COMMAND

/// NOT CURRENTLY USED ANYWHERE
/datum/access/horizon/gateway
	id = 62
	desc = "Gateway"
	region = ACCESS_REGION_COMMAND

/// Security front doors
/datum/access/horizon/sec_doors
	id = 63
	desc = "Security"
	region = ACCESS_REGION_SECURITY

/// Psychiatrist's office
/datum/access/horizon/psychiatrist
	id = 64
	desc = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

/datum/access/horizon/xenoarch
	id = 65
	desc = "Xenoarchaeology"
	region = ACCESS_REGION_RESEARCH

/datum/access/horizon/medical_equip
	id = 66
	desc = "Medical Equipment"
	region = ACCESS_REGION_MEDBAY

/datum/access/horizon/paramedic
	id = 67
	desc = "Paramedic Equipment"
	region = ACCESS_REGION_MEDBAY

// free_access_id = 68

/// Used by firing pins.
/datum/access/horizon/weapons
	id = 69
	desc = "Weaponry Permission"
	region = ACCESS_REGION_SECURITY

/// Journalist's office access
/datum/access/horizon/journalist
	id = 70
	desc = "Media Office"
	region = ACCESS_REGION_GENERAL

/// Allows some unique interactions with devices
/datum/access/horizon/tech_support
	id = 71
	desc = "Tech Support"

/datum/access/horizon/consular
	id = 72
	desc = "Consular"

/datum/access/horizon/intrepid
	id = 73
	desc = "Intrepid Shuttle"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/bridge_crew
	id = 74
	desc = "Bridge Crew"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/ship_weapons
	id = 75
	desc = "Ship Weapons"
	region = ACCESS_REGION_SUPPLY

/datum/access/horizon/spark
	id = 76
	desc = "Spark Shuttle"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/quark
	id = 77
	desc = "Quark Shuttle"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/canary
	id = 78
	desc = "Canary Shuttle"
	region = ACCESS_REGION_COMMAND

/******************
* Central Command *
******************/
ABSTRACT_TYPE(/datum/access/centcomm)

//General facilities. - Everyone on central has that --> Use this for doors that every central role should have access to, but not the aurora people
/datum/access/centcomm/cent_general
	id = 101
	desc = "Code Grey"
	access_type = ACCESS_TYPE_CENTCOM

//Thunderdome.
/datum/access/centcomm/cent_thunder
	id = 102
	desc = "Code Yellow"
	access_type = ACCESS_TYPE_CENTCOM

//Centcom Security - This access is used by the ERT / Odin Security and CCIA
// Separation between Odin Sec/CCIA and ERT is achieved via the ERT Commander Access (/datum/access/centcomm/cent_creed::id)
/datum/access/centcomm/cent_specops
	id = 103
	desc = "Code Black"
	access_type = ACCESS_TYPE_CENTCOM

//Medical/Research - Thats the access for the medical section. Used for the odin doctors/chemists
/datum/access/centcomm/cent_medical
	id = 104
	desc = "Code White"
	access_type = ACCESS_TYPE_CENTCOM

//Living quarters, the access used by the odin bartenders/chefs
/datum/access/centcomm/cent_living
	id = 105
	desc = "Code Green"
	access_type = ACCESS_TYPE_CENTCOM

//Generic storage areas, used for the Maint Tunnels on Centcom
/datum/access/centcomm/cent_storage
	id = 106
	desc = "Code Orange"
	access_type = ACCESS_TYPE_CENTCOM

//107 is unused

//Creed's office. - ERT/TCFL Commander
/datum/access/centcomm/cent_creed
	id = 108
	desc = "Code Silver"
	access_type = ACCESS_TYPE_CENTCOM

//CCIA Access on Centcom
/datum/access/centcomm/cent_ccia
	id = 109
	desc = "Code Gold"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/centcomm/merchant
	id = 110//merchant
	desc = "Merchant Access"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/centcomm/tcaf
	id = 111//tau
	desc = "Tau Ceti Armed Forces Access"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/centcomm/distress
	id = 112
	desc = "General ERT Base Access"
	access_type = ACCESS_TYPE_CENTCOM


/****************************
* Kataphract Chapter Access *
****************************/
/datum/access/centcomm/kataphract
	id = 113
	desc = "Kataphract Chapter Access"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/centcomm/kataphract/knight
	id = 114
	desc = "Kataphract Knight Access"

/***************
* Antag access *
***************/
ABSTRACT_TYPE(/datum/access/antag)

/datum/access/antag/syndicate
	id = 150//General
	access_type = ACCESS_TYPE_SYNDICATE

/datum/access/antag/syndicate_leader
	id = 151
	access_type = ACCESS_TYPE_SYNDICATE

/*******
* Misc *
*******/
ABSTRACT_TYPE(/datum/access/other)

/datum/access/other/equipment
	id = 199
	desc = "Equipment"
	access_type = ACCESS_TYPE_NONE

/datum/access/other/crate_cash
	id = 200
	access_type = ACCESS_TYPE_NONE

/datum/access/other/exress_ship
	id = 201
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/generic_away_site
	id = 202
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/none
	id = -1
	access_type = ACCESS_TYPE_NONE

/datum/access/other/sol_ships
	id = 203
	access_type = ACCESS_TYPE_CENTCOM

/// 204 is vacant

/datum/access/other/ee_spy_ship
	id = 205
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/civilian_station
	id = 206
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/elyran_naval_infantry_ship
	id = 207
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/skrell
	id = 208
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/pra
	id = 209
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/unathi_pirate
	id = 210
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/iac_rescue_shit
	id = 211
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/imperial_fleet_voidsman_ship
	id = 212
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/nka
	id = 213
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/dpra
	id = 214
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/merchants_guild
	id = 215
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/hephaestus
	id = 216
	access_type = ACCESS_TYPE_CENTCOM

// For the Golden Deep ghostrole. This is the access for the merchant and guards, but not for the owned synthetics.
/datum/access/other/golden_deep
	id = 217
	access_type = ACCESS_TYPE_CENTCOM
	desc = "Golden Deep"

/datum/access/other/portofcall_police
	id = 218
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/portofcall_vendors
	id = 219
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/idris
	id = 220
	desc = "Idris Ship Crew Member"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/coalition
	id = 221
	desc = "Coalition of Colonies"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/coalition_navy
	id = 222
	desc = "Coalition Navy"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/gadpathur_navy
	id = 223
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/gadpathur_navy_officer
	id = 224
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/portofcall_corporate
	id = 225
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/house_volvalaad_ship
	id = 226
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/moghes_wasteland_ozeuoi
	id = 227
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/autakh
	id = 228
	access_type = ACCESS_TYPE_CENTCOM

// For the Golden Deep ghostrole. This is for the owned synthetics, so they lack some of the access their superiors enjoy.
/datum/access/other/golden_deep_owned
	id = 229
	access_type = ACCESS_TYPE_CENTCOM
	desc = "Golden Deep, Limited Access"

//guest rooms - for any ship/event that requires hotel-esque rooms

/datum/access/other/guest_rooms
	id = 230
	desc = "Guest Rooms - All"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/guest_room_1
	id = 231
	desc = "Guest Room 1"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/guest_room_2
	id = 232
	desc = "Guest Room 2"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/guest_room_3
	id = 233
	desc = "Guest Room 3"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/guest_room_4
	id = 234
	desc = "Guest Room 4"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/guest_room_5
	id = 235
	desc = "Guest Room 5"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/guest_room_6
	id = 236
	desc = "Guest Room 6"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/guest_room_7
	id = 237
	desc = "Guest Room 7"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/guest_room_8
	id = 238
	desc = "Guest Room 8"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/guest_room_9
	id = 239
	desc = "Guest Room 9"
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/guest_room_10
	id = 240
	desc = "Guest Room 10"

/datum/access/other/unathi_trawler_access
	id = 241
	desc = "General Fishing Trawler Access"

/datum/access/other/tramp_freighter_access
	id = 242
	desc = "Independent Freighter Access"

/datum/access/other/lone_spacer_access
	id = 243
	desc = "Independent Skiff Access"

/datum/access/other/cryo_outpost_access
	id = 244
	desc = "Outpost #187-D Access"

/datum/access/other/ruined_propellant_depot_access
	id = 245
	desc = "Propellant Depot AG5 Access"

/datum/access/other/splf_access
	id = 246
	desc = "SPLF Access"

/datum/access/other/nuclear_missile_silo_access
	id = 247
	desc = "Nuclear Missile Silo Access"

/datum/access/other/nuclear_missile_silo_access_high
	id = 248
	desc = "Nuclear Missile Silo Access High Security"

/datum/access/other/enviro_testing_facility_access_control
	id = 249
	desc = "Env-Test Facility Zoya, Control Access"

/datum/access/other/enviro_testing_facility_access_medres
	id = 250
	desc = "Env-Test Facility Zoya, Medical-Research Access"

/datum/access/other/enviro_testing_facility_access_engops
	id = 251
	desc = "Env-Test Facility Zoya, Engineering-Operations Access"

/datum/access/other/enviro_testing_facility_access_sec
	id = 252
	desc = "Env-Test Facility Zoya, Security Access"

	id = 253
	desc = "Himean Military Patrol Vessel"

/datum/access/other/quarantined_outpost_engineer
	id = 254
	desc = "Outpost Nemora, Engineering Clearance"

/datum/access/other/decrepit_shipyard_staff
	id = 255
	desc = "Decrepit Shipyard, Staff Access"

/datum/access/other/voidtamer_ship
	id = 256
	access_type = ACCESS_TYPE_CENTCOM

/datum/access/other/abandoned_casino
	id = 257

/datum/access/other/crevus_rhan_cresh
	id = 258
	desc = "Rhan-Cresh Charities', Highway Patrol Office Access"

/datum/access/other/crevus_azaula_enforcer
	id = 259
	desc = "Azaula Entertainment, Enforcer Office Access"

/datum/access/other/crevus_the_lock
	id = 260
	desc = "The Lock Hideout Access"

/datum/access/other/crevus_casino
	id = 261
	desc = "Keltra Zav Nikal, Casino Access"

/datum/access/other/crevus_general_store
	id = 262
	desc = "Ane-Mart Staff Access"

/datum/access/other/crevus_firearm_store
	id = 263
	desc = "Firearm Store Access"

/datum/access/other/crevus_nt_pharmacy
	id = 264
	desc = "NanoTrasen Pharmacy Access"

/datum/access/other/crevus_artisan_shop
	id = 265
	desc = "Artisan Shop Access"

/datum/access/other/crevus_clothing_store
	id = 266
	desc = "Clothing Store Access"

/datum/access/other/modular_freelancer_ship
	id = 267
	desc = "Freelancer Ship Access"
