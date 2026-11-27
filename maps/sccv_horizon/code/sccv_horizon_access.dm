/*****************
* Station access *
*****************/
ABSTRACT_TYPE(/datum/access/horizon)

/datum/access/horizon/security
	id = 1
	desc = "Security Equipment"
	region = ACCESS_REGION_SECURITY

/obj/effect/map_effect/marker/access/req_one/security
	name = "access marker (req_one: security)"
	req_one_access = list(/datum/access/horizon/security::id)

/obj/effect/map_effect/marker/access/req_all/security
	name = "access marker (req_all: security)"
	req_access = list(/datum/access/horizon/security::id)

/// Brig timers and permabrig
/datum/access/horizon/holding
	id = 2
	desc = "Holding Cells"
	region = ACCESS_REGION_SECURITY

/obj/effect/map_effect/marker/access/req_one/holding
	name = "access marker (req_one: holding)"
	req_one_access = list(/datum/access/horizon/holding::id)

/obj/effect/map_effect/marker/access/req_all/holding
	name = "access marker (req_all: holding)"
	req_access = list(/datum/access/horizon/holding::id)

/datum/access/horizon/armory
	id = 3
	desc = "Armory"
	region = ACCESS_REGION_SECURITY

/obj/effect/map_effect/marker/access/req_one/armory
	name = "access marker (req_one: armory)"
	req_one_access = list(/datum/access/horizon/armory::id)

/obj/effect/map_effect/marker/access/req_all/armory
	name = "access marker (req_all: armory)"
	req_access = list(/datum/access/horizon/armory::id)

/datum/access/horizon/forensics_lockers
	id = 4
	desc = "Forensics"
	region = ACCESS_REGION_SECURITY

/obj/effect/map_effect/marker/access/req_one/forensics_lockers
	name = "access marker (req_one: forensics_lockers)"
	req_one_access = list(/datum/access/horizon/forensics_lockers::id)

/obj/effect/map_effect/marker/access/req_all/forensics_lockers
	name = "access marker (req_all: forensics_lockers)"
	req_access = list(/datum/access/horizon/forensics_lockers::id)

/datum/access/horizon/medical
	id = 5
	desc = "Medical"
	region = ACCESS_REGION_MEDBAY

/obj/effect/map_effect/marker/access/req_one/medical
	name = "access marker (req_one: medical)"
	req_one_access = list(/datum/access/horizon/medical::id)

/obj/effect/map_effect/marker/access/req_all/medical
	name = "access marker (req_all: medical)"
	req_access = list(/datum/access/horizon/medical::id)

/datum/access/horizon/morgue
	id = 6
	desc = "Morgue"
	region = ACCESS_REGION_MEDBAY

/obj/effect/map_effect/marker/access/req_one/morgue
	name = "access marker (req_one: morgue)"
	req_one_access = list(/datum/access/horizon/morgue::id)

/obj/effect/map_effect/marker/access/req_all/morgue
	name = "access marker (req_all: morgue)"
	req_access = list(/datum/access/horizon/morgue::id)

/datum/access/horizon/tox
	id = 7
	desc = "R&D Lab"
	region = ACCESS_REGION_RESEARCH

/obj/effect/map_effect/marker/access/req_one/tox
	name = "access marker (req_one: tox)"
	req_one_access = list(/datum/access/horizon/tox::id)

/obj/effect/map_effect/marker/access/req_all/tox
	name = "access marker (req_all: tox)"
	req_access = list(/datum/access/horizon/tox::id)

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

/obj/effect/map_effect/marker/access/req_all/genetics
	name = "access marker (req_all: genetics)"
	req_access = list(/datum/access/horizon/genetics::id)

/datum/access/horizon/engine
	id = 10
	desc = "Engineering"
	region = ACCESS_REGION_ENGINEERING

/obj/effect/map_effect/marker/access/req_one/engine
	name = "access marker (req_one: engine)"
	req_one_access = list(/datum/access/horizon/engine::id)

/obj/effect/map_effect/marker/access/req_all/engine
	name = "access marker (req_all: engine)"
	req_access = list(/datum/access/horizon/engine::id)

/datum/access/horizon/engine_equip
	id = 11
	desc = "Engine Room"
	region = ACCESS_REGION_ENGINEERING

/obj/effect/map_effect/marker/access/req_one/engine_equip
	name = "access marker (req_one: engine_equip)"
	req_one_access = list(/datum/access/horizon/engine_equip::id)

/obj/effect/map_effect/marker/access/req_all/engine_equip
	name = "access marker (req_all: engine_equip)"
	req_access = list(/datum/access/horizon/engine_equip::id)

/datum/access/horizon/maint_tunnels
	id = 12
	desc = "Maintenance"
	region = ACCESS_REGION_ENGINEERING

/obj/effect/map_effect/marker/access/req_one/maint_tunnels
	name = "access marker (req_one: maint_tunnels)"
	req_one_access = list(/datum/access/horizon/maint_tunnels::id)

/obj/effect/map_effect/marker/access/req_all/maint_tunnels
	name = "access marker (req_all: maint_tunnels)"
	req_access = list(/datum/access/horizon/maint_tunnels::id)

/datum/access/horizon/external_airlocks
	id = 13
	desc = "External Airlocks"
	region = ACCESS_REGION_ENGINEERING

/obj/effect/map_effect/marker/access/req_one/external_airlocks
	name = "access marker (req_one: external_airlocks)"
	req_one_access = list(/datum/access/horizon/external_airlocks::id)

/obj/effect/map_effect/marker/access/req_all/external_airlocks
	name = "access marker (req_all: external_airlocks)"
	req_access = list(/datum/access/horizon/external_airlocks::id)

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

/obj/effect/map_effect/marker/access/req_all/ai_upload
	name = "access marker (req_all: ai_upload)"
	req_access = list(/datum/access/horizon/ai_upload::id)

/datum/access/horizon/teleporter
	id = 17
	desc = "Teleporter"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/eva
	id = 18
	desc = "EVA"
	region = ACCESS_REGION_COMMAND

/obj/effect/map_effect/marker/access/req_one/eva
	name = "access marker (req_one: eva)"
	req_one_access = list(/datum/access/horizon/eva::id)

/obj/effect/map_effect/marker/access/req_all/eva
	name = "access marker (req_all: eva)"
	req_access = list(/datum/access/horizon/eva::id)

/datum/access/horizon/heads
	id = 19
	desc = "Bridge"
	region = ACCESS_REGION_COMMAND

/obj/effect/map_effect/marker/access/req_one/heads
	name = "access marker (req_one: heads)"
	req_one_access = list(/datum/access/horizon/heads::id)

/obj/effect/map_effect/marker/access/req_all/heads
	name = "access marker (req_all: heads)"
	req_access = list(/datum/access/horizon/heads::id)

/datum/access/horizon/captain
	id = 20
	desc = "Captain"
	region = ACCESS_REGION_COMMAND

/obj/effect/map_effect/marker/access/req_one/captain
	name = "access marker (req_one: captain)"
	req_one_access = list(/datum/access/horizon/captain::id)

/obj/effect/map_effect/marker/access/req_all/captain
	name = "access marker (req_all: captain)"
	req_access = list(/datum/access/horizon/captain::id)

/datum/access/horizon/all_personal_lockers
	id = 21
	desc = "Personal Lockers"
	region = ACCESS_REGION_COMMAND

/datum/access/horizon/chapel_office
	id = 22
	desc = "Chapel Office"
	region = ACCESS_REGION_GENERAL

/obj/effect/map_effect/marker/access/req_one/chapel_office
	name = "access marker (req_one: chapel_office)"
	req_one_access = list(/datum/access/horizon/chapel_office::id)

/obj/effect/map_effect/marker/access/req_all/chapel_office
	name = "access marker (req_all: chapel_office)"
	req_access = list(/datum/access/horizon/chapel_office::id)

/datum/access/horizon/tech_storage
	id = 23
	desc = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

/obj/effect/map_effect/marker/access/req_all/tech_storage
	name = "access marker (req_all: tech_storage)"
	req_access = list(/datum/access/horizon/tech_storage::id)

/datum/access/horizon/atmospherics
	id = 24
	desc = "Atmospherics"
	region = ACCESS_REGION_ENGINEERING

/obj/effect/map_effect/marker/access/req_one/atmospherics
	name = "access marker (req_one: atmospherics)"
	req_one_access = list(/datum/access/horizon/atmospherics::id)

/obj/effect/map_effect/marker/access/req_all/atmospherics
	name = "access marker (req_all: atmospherics)"
	req_access = list(/datum/access/horizon/atmospherics::id)

/datum/access/horizon/bar
	id = 25
	desc = "Bar"
	region = ACCESS_REGION_GENERAL

/obj/effect/map_effect/marker/access/req_one/bar
	name = "access marker (req_one: bar)"
	req_one_access = list(/datum/access/horizon/bar::id)

/obj/effect/map_effect/marker/access/req_all/bar
	name = "access marker (req_all: bar)"
	req_access = list(/datum/access/horizon/bar::id)

/datum/access/horizon/janitor
	id = 26
	desc = "Custodial Closet"
	region = ACCESS_REGION_GENERAL

/obj/effect/map_effect/marker/access/req_one/janitor
	name = "access marker (req_one: janitor)"
	req_one_access = list(/datum/access/horizon/janitor::id)

/obj/effect/map_effect/marker/access/req_all/janitor
	name = "access marker (req_all: janitor)"
	req_access = list(/datum/access/horizon/janitor::id)

/// Only used for morgue crematorium switch, and the only one that exists has its access vars nulled anyway.
/datum/access/horizon/crematorium
	id = 27
	desc = "Crematorium"
	region = ACCESS_REGION_GENERAL

/datum/access/horizon/galley
	id = 28
	desc = "Galley"
	region = ACCESS_REGION_GENERAL

/obj/effect/map_effect/marker/access/req_one/galley
	name = "access marker (req_one: galley)"
	req_one_access = list(/datum/access/horizon/galley::id)

/obj/effect/map_effect/marker/access/req_all/galley
	name = "access marker (req_all: galley)"
	req_access = list(/datum/access/horizon/galley::id)

/datum/access/horizon/robotics
	id = 29
	desc = "Robotics"
	region = ACCESS_REGION_RESEARCH

/obj/effect/map_effect/marker/access/req_one/robotics
	name = "access marker (req_one: robotics)"
	req_one_access = list(/datum/access/horizon/robotics::id)

/obj/effect/map_effect/marker/access/req_all/robotics
	name = "access marker (req_all: robotics)"
	req_access = list(/datum/access/horizon/robotics::id)

/datum/access/horizon/rd
	id = 30
	desc = "Research Director"
	region = ACCESS_REGION_RESEARCH

/obj/effect/map_effect/marker/access/req_one/rd
	name = "access marker (req_one: rd)"
	req_one_access = list(/datum/access/horizon/rd::id)

/obj/effect/map_effect/marker/access/req_all/rd
	name = "access marker (req_all: rd)"
	req_access = list(/datum/access/horizon/rd::id)

/datum/access/horizon/cargo
	id = 31
	desc = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

/obj/effect/map_effect/marker/access/req_one/cargo
	name = "access marker (req_one: cargo)"
	req_one_access = list(/datum/access/horizon/cargo::id)

/obj/effect/map_effect/marker/access/req_all/cargo
	name = "access marker (req_all: cargo)"
	req_access = list(/datum/access/horizon/cargo::id)

/// Used only for locked welding lockers and engineering suit cyclers, weirdly.
/datum/access/horizon/construction
	id = 32
	desc = "Construction Areas"
	region = ACCESS_REGION_ENGINEERING

/datum/access/horizon/pharmacy
	id = 33
	desc = "Pharmacy Lab"
	region = ACCESS_REGION_MEDBAY

/obj/effect/map_effect/marker/access/req_one/pharmacy
	name = "access marker (req_one: pharmacy)"
	req_one_access = list(/datum/access/horizon/pharmacy::id)

/obj/effect/map_effect/marker/access/req_all/pharmacy
	name = "access marker (req_all: pharmacy)"
	req_access = list(/datum/access/horizon/pharmacy::id)

/// NOT CURRENTLY USED ANYWHERE
/datum/access/horizon/cargo_bot
	id = 34
	desc = "Cargo Bot Delivery"
	region = ACCESS_REGION_SUPPLY

/datum/access/horizon/hydroponics
	id = 35
	desc = "Hydroponics"
	region = ACCESS_REGION_GENERAL

/obj/effect/map_effect/marker/access/req_one/hydroponics
	name = "access marker (req_one: hydroponics)"
	req_one_access = list(/datum/access/horizon/hydroponics::id)

/obj/effect/map_effect/marker/access/req_all/hydroponics
	name = "access marker (req_all: hydroponics)"
	req_access = list(/datum/access/horizon/hydroponics::id)

/// NOT CURRENTLY USED ANYWHERE
/datum/access/horizon/manufacturing
	id = 36
	desc = "Manufacturing"
	access_type = ACCESS_TYPE_NONE

/datum/access/horizon/library
	id = 37
	desc = "Library"
	region = ACCESS_REGION_GENERAL

/obj/effect/map_effect/marker/access/req_one/library
	name = "access marker (req_one: library)"
	req_one_access = list(/datum/access/horizon/library::id)

/obj/effect/map_effect/marker/access/req_all/library
	name = "access marker (req_all: library)"
	req_access = list(/datum/access/horizon/library::id)

/datum/access/horizon/lawyer
	id = 38
	desc = "Representative"
	region = ACCESS_TYPE_CENTCOM

/obj/effect/map_effect/marker/access/req_one/lawyer
	name = "access marker (req_one: lawyer)"
	req_one_access = list(/datum/access/horizon/lawyer::id)

/obj/effect/map_effect/marker/access/req_all/lawyer
	name = "access marker (req_all: lawyer)"
	req_access = list(/datum/access/horizon/lawyer::id)

/// Used only for '/obj/item/storage/lockbox/vials' and a smartfridge variant no longer mapped anywhere.
/datum/access/horizon/virology
	id = 39
	desc = "Virology"
	region = ACCESS_REGION_MEDBAY

/obj/effect/map_effect/marker/access/req_all/virology
	name = "access marker (req_all: virology)"
	req_access = list(/datum/access/horizon/virology::id)

/datum/access/horizon/cmo
	id = 40
	desc = "Chief Medical Officer"
	region = ACCESS_REGION_COMMAND

/obj/effect/map_effect/marker/access/req_all/cmo
	name = "access marker (req_all: cmo)"
	req_access = list(/datum/access/horizon/cmo::id)

/datum/access/horizon/qm
	id = 41
	desc = "Operations Manager"
	region = ACCESS_REGION_SUPPLY

/obj/effect/map_effect/marker/access/req_one/qm
	name = "access marker (req_one: qm)"
	req_one_access = list(/datum/access/horizon/qm::id)

/obj/effect/map_effect/marker/access/req_all/qm
	name = "access marker (req_all: qm)"
	req_access = list(/datum/access/horizon/qm::id)

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

/obj/effect/map_effect/marker/access/req_one/surgery
	name = "access marker (req_one: surgery)"
	req_one_access = list(/datum/access/horizon/surgery::id)

/obj/effect/map_effect/marker/access/req_all/surgery
	name = "access marker (req_all: surgery)"
	req_access = list(/datum/access/horizon/surgery::id)

// free_access_id = 46

/datum/access/horizon/research
	id = 47
	desc = "Science"
	region = ACCESS_REGION_RESEARCH

/obj/effect/map_effect/marker/access/req_one/research
	name = "access marker (req_one: research)"
	req_one_access = list(/datum/access/horizon/research::id)

/obj/effect/map_effect/marker/access/req_all/research
	name = "access marker (req_all: research)"
	req_access = list(/datum/access/horizon/research::id)

/datum/access/horizon/mining
	id = 48
	desc = "Mining"
	region = ACCESS_REGION_SUPPLY

/obj/effect/map_effect/marker/access/req_one/mining
	name = "access marker (req_one: mining)"
	req_one_access = list(/datum/access/horizon/mining::id)

/obj/effect/map_effect/marker/access/req_all/mining
	name = "access marker (req_all: mining)"
	req_access = list(/datum/access/horizon/mining::id)

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

/obj/effect/map_effect/marker/access/req_all/mailsorting
	name = "access marker (req_all: mailsorting)"
	req_access = list(/datum/access/horizon/mailsorting::id)

// free_access_id = 51

/datum/access/horizon/xenobotany
	id = 52
	desc = "Xenobotany"
	region = ACCESS_REGION_RESEARCH

/obj/effect/map_effect/marker/access/req_one/xenobotany
	name = "access marker (req_one: xenobotany)"
	req_one_access = list(/datum/access/horizon/xenobotany::id)

/obj/effect/map_effect/marker/access/req_all/xenobotany
	name = "access marker (req_all: xenobotany)"
	req_access = list(/datum/access/horizon/xenobotany::id)

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

/obj/effect/map_effect/marker/access/req_one/xenobiology
	name = "access marker (req_one: xenobiology)"
	req_one_access = list(/datum/access/horizon/xenobiology::id)

/obj/effect/map_effect/marker/access/req_all/xenobiology
	name = "access marker (req_all: xenobiology)"
	req_access = list(/datum/access/horizon/xenobiology::id)

/datum/access/horizon/ce
	id = 56
	desc = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

/obj/effect/map_effect/marker/access/req_one/ce
	name = "access marker (req_one: ce)"
	req_one_access = list(/datum/access/horizon/ce::id)

/obj/effect/map_effect/marker/access/req_all/ce
	name = "access marker (req_all: ce)"
	req_access = list(/datum/access/horizon/ce::id)

/datum/access/horizon/hop
	id = 57
	desc = "Executive Officer"
	region = ACCESS_REGION_COMMAND

/obj/effect/map_effect/marker/access/req_one/hop
	name = "access marker (req_one: hop)"
	req_one_access = list(/datum/access/horizon/hop::id)

/obj/effect/map_effect/marker/access/req_all/hop
	name = "access marker (req_all: hop)"
	req_access = list(/datum/access/horizon/hop::id)

/datum/access/horizon/hos
	id = 58
	desc = "Head of Security"
	region = ACCESS_REGION_SECURITY

/obj/effect/map_effect/marker/access/req_all/hos
	name = "access marker (req_all: hos)"
	req_access = list(/datum/access/horizon/hos::id)

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

/obj/effect/map_effect/marker/access/req_all/tcomsat
	name = "access marker (req_all: tcomsat)"
	req_access = list(/datum/access/horizon/tcomsat::id)

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

/obj/effect/map_effect/marker/access/req_one/sec_doors
	name = "access marker (req_one: sec_doors)"
	req_one_access = list(/datum/access/horizon/sec_doors::id)

/obj/effect/map_effect/marker/access/req_all/sec_doors
	name = "access marker (req_all: sec_doors)"
	req_access = list(/datum/access/horizon/sec_doors::id)

/// Psychiatrist's office
/datum/access/horizon/psychiatrist
	id = 64
	desc = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

/obj/effect/map_effect/marker/access/req_all/psychiatrist
	name = "access marker (req_all: psychiatrist)"
	req_access = list(/datum/access/horizon/psychiatrist::id)

/datum/access/horizon/xenoarch
	id = 65
	desc = "Xenoarchaeology"
	region = ACCESS_REGION_RESEARCH

/obj/effect/map_effect/marker/access/req_one/xenoarch
	name = "access marker (req_one: xenoarch)"
	req_one_access = list(/datum/access/horizon/xenoarch::id)

/obj/effect/map_effect/marker/access/req_all/xenoarch
	name = "access marker (req_all: xenoarch)"
	req_access = list(/datum/access/horizon/xenoarch::id)

/datum/access/horizon/medical_equip
	id = 66
	desc = "Medical Equipment"
	region = ACCESS_REGION_MEDBAY

/obj/effect/map_effect/marker/access/req_one/medical_equip
	name = "access marker (req_one: medical_equip)"
	req_one_access = list(/datum/access/horizon/medical_equip::id)

/obj/effect/map_effect/marker/access/req_all/medical_equip
	name = "access marker (req_all: medical_equip)"
	req_access = list(/datum/access/horizon/medical_equip::id)

/datum/access/horizon/paramedic
	id = 67
	desc = "Paramedic Equipment"
	region = ACCESS_REGION_MEDBAY

/obj/effect/map_effect/marker/access/req_one/paramedic
	name = "access marker (req_one: paramedic)"
	req_one_access = list(/datum/access/horizon/paramedic::id)

/obj/effect/map_effect/marker/access/req_all/paramedic
	name = "access marker (req_all: paramedic)"
	req_access = list(/datum/access/horizon/paramedic::id)

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

/obj/effect/map_effect/marker/access/req_one/journalist
	name = "access marker (req_one: journalist)"
	req_one_access = list(/datum/access/horizon/journalist::id)

/obj/effect/map_effect/marker/access/req_all/journalist
	name = "access marker (req_all: journalist)"
	req_access = list(/datum/access/horizon/journalist::id)

/// Allows some unique interactions with devices
/datum/access/horizon/tech_support
	id = 71
	desc = "Tech Support"

/datum/access/horizon/consular
	id = 72
	desc = "Consular"

/obj/effect/map_effect/marker/access/req_one/consular
	name = "access marker (req_one: consular)"
	req_one_access = list(/datum/access/horizon/consular::id)

/obj/effect/map_effect/marker/access/req_all/consular
	name = "access marker (req_all: consular)"
	req_access = list(/datum/access/horizon/consular::id)

/datum/access/horizon/intrepid
	id = 73
	desc = "Intrepid Shuttle"
	region = ACCESS_REGION_COMMAND

/obj/effect/map_effect/marker/access/req_one/intrepid
	name = "access marker (req_one: intrepid)"
	req_one_access = list(/datum/access/horizon/intrepid::id)

/obj/effect/map_effect/marker/access/req_all/intrepid
	name = "access marker (req_all: intrepid)"
	req_access = list(/datum/access/horizon/intrepid::id)

/datum/access/horizon/bridge_crew
	id = 74
	desc = "Bridge Crew"
	region = ACCESS_REGION_COMMAND

/obj/effect/map_effect/marker/access/req_one/bridge_crew
	name = "access marker (req_one: bridge_crew)"
	req_one_access = list(/datum/access/horizon/bridge_crew::id)

/datum/access/horizon/ship_weapons
	id = 75
	desc = "Ship Weapons"
	region = ACCESS_REGION_SUPPLY

/obj/effect/map_effect/marker/access/req_all/ship_weapons
	name = "access marker (req_all: ship_weapons)"
	req_access = list(/datum/access/horizon/ship_weapons::id)

/datum/access/horizon/spark
	id = 76
	desc = "Spark Shuttle"
	region = ACCESS_REGION_COMMAND

/obj/effect/map_effect/marker/access/req_one/spark
	name = "access marker (req_one: spark)"
	req_one_access = list(/datum/access/horizon/spark::id)

/datum/access/horizon/quark
	id = 77
	desc = "Quark Shuttle"
	region = ACCESS_REGION_COMMAND

/obj/effect/map_effect/marker/access/req_one/quark
	name = "access marker (req_one: quark)"
	req_one_access = list(/datum/access/horizon/quark::id)

/datum/access/horizon/canary
	id = 78
	desc = "Canary Shuttle"
	region = ACCESS_REGION_COMMAND

/obj/effect/map_effect/marker/access/req_one/canary
	name = "access marker (req_one: canary)"
	req_one_access = list(/datum/access/horizon/canary::id)
