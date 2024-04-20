/datum/design/item/mechfab/exosuit_equipment
	name = "Hydraulic Clamp"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(3), MATERIAL_GLASS = MATERIAL_AMOUNT_FOR_SHEETS(2))
	time = 50
	build_path = /obj/item/mecha_equipment/clamp
	category = "Exosuit (Equipment)"

/datum/design/item/mechfab/exosuit_equipment/gravity_catapult
	name = "Gravity Catapult"
	build_path = /obj/item/mecha_equipment/catapult

/datum/design/item/mechfab/exosuit_equipment/drill
	name = "Drill"
	build_path = /obj/item/mecha_equipment/drill

/datum/design/item/mechfab/exosuit_equipment/taser
	name = "Mounted Taser"
	req_tech = list(TECH_COMBAT = 1)
	build_path = /obj/item/mecha_equipment/mounted_system/combat/taser

/datum/design/item/mechfab/exosuit_equipment/smg
	name = "Mounted Ballistic Submachine Gun"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(5), MATERIAL_GLASS = MATERIAL_AMOUNT_FOR_SHEETS(3))
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/combat/smg

/datum/design/item/mechfab/exosuit_equipment/rifle
	name = "Mounted Ballistic Automatic Rifle"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(10), MATERIAL_GLASS = MATERIAL_AMOUNT_FOR_SHEETS(5))
	req_tech = list(TECH_COMBAT = 5)
	build_path = /obj/item/mecha_equipment/mounted_system/combat/smg/rifle

/datum/design/item/mechfab/exosuit_equipment/plasma
	name = "Mounted Plasma Cutter"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(5), MATERIAL_GLASS = MATERIAL_AMOUNT_FOR_SHEETS(5), MATERIAL_GOLD = MATERIAL_AMOUNT_FOR_SHEETS(0.5), MATERIAL_PHORON = MATERIAL_AMOUNT_FOR_SHEETS(0.5))
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/plasmacutter

/datum/design/item/mechfab/exosuit_equipment/ion
	name = "Mounted Ion Rifle"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(5), MATERIAL_GOLD = MATERIAL_AMOUNT_FOR_SHEETS(1.5), MATERIAL_URANIUM = MATERIAL_AMOUNT_FOR_SHEETS(1.5), MATERIAL_PHORON = MATERIAL_AMOUNT_FOR_SHEETS(1.5))
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/combat/ion

/datum/design/item/mechfab/exosuit_equipment/laser
	name = "Mounted Laser Gun"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(5))
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/combat/laser

/datum/design/item/mechfab/exosuit_equipment/rcd
	name = "Mounted RFD-C"
	time = 90
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(10), MATERIAL_PHORON = MATERIAL_AMOUNT_FOR_SHEETS(2), MATERIAL_GOLD = MATERIAL_AMOUNT_FOR_SHEETS(3))
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/rfd

/datum/design/item/mechfab/exosuit_equipment/floodlight
	name = "Mounted Floodlight"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(2.5), MATERIAL_GLASS = MATERIAL_AMOUNT_FOR_SHEETS(2.5))
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/mecha_equipment/light

/datum/design/item/mechfab/exosuit_equipment/sleeper
	name = "Mounted Sleeper"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(2.5), MATERIAL_GLASS = MATERIAL_AMOUNT_FOR_SHEETS(5))
	build_path = /obj/item/mecha_equipment/sleeper

/datum/design/item/mechfab/exosuit_equipment/extinguisher
	name = "Mounted Extinguisher"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(2))
	build_path = /obj/item/mecha_equipment/mounted_system/extinguisher

/datum/design/item/mechfab/exosuit_equipment/xray
	name = "Mounted X-Ray Gun"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(10), MATERIAL_GOLD = MATERIAL_AMOUNT_FOR_SHEETS(3), MATERIAL_PHORON = MATERIAL_AMOUNT_FOR_SHEETS(3))
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/combat/xray

/datum/design/item/mechfab/exosuit_equipment/flashbang
	name = "Mounted Flashbang Launcher"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(10), MATERIAL_GOLD = MATERIAL_AMOUNT_FOR_SHEETS(1.5), MATERIAL_SILVER = MATERIAL_AMOUNT_FOR_SHEETS(1.5))
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/combat/grenadeflash

/datum/design/item/mechfab/exosuit_equipment/stinger
	name = "Mounted Stinger Launcher"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(10), MATERIAL_GOLD = MATERIAL_AMOUNT_FOR_SHEETS(1.5), MATERIAL_SILVER = MATERIAL_AMOUNT_FOR_SHEETS(1.5))
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/combat/grenadestinger

/datum/design/item/mechfab/exosuit_equipment/cleaner
	name = "Mounted Cleaner Grenade Launcher"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(5), MATERIAL_GLASS = MATERIAL_AMOUNT_FOR_SHEETS(2.5))
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/mecha_equipment/mounted_system/grenadecleaner

/datum/design/item/mechfab/exosuit_equipment/crisisdrone
	name = "Mounted Crisis Drone"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(5), MATERIAL_GLASS = MATERIAL_AMOUNT_FOR_SHEETS(2), MATERIAL_GOLD = MATERIAL_AMOUNT_FOR_SHEETS(0.5), MATERIAL_SILVER = MATERIAL_AMOUNT_FOR_SHEETS(1))
	build_path = /obj/item/mecha_equipment/crisis_drone
	req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_BIO = 3)

/datum/design/item/mechfab/exosuit_equipment/analyzer
	name = "Mounted Health Analyzer"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(2), MATERIAL_GLASS = MATERIAL_AMOUNT_FOR_SHEETS(2))
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/medanalyzer

/datum/design/item/mechfab/exosuit_equipment/flaregun
	name = "Mounted Flare Launcher"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(3))
	build_path = /obj/item/mecha_equipment/mounted_system/flarelauncher

/datum/design/item/mechfab/exosuit_equipment/passenger_compartment
	name = "Mounted Passenger Compartment"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(3))
	build_path = /obj/item/mecha_equipment/sleeper/passenger_compartment

/datum/design/item/mechfab/exosuit_equipment/mechshields
	name = "Energy Shield Drone"
	time = 90
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(10), MATERIAL_SILVER = MATERIAL_AMOUNT_FOR_SHEETS(6), MATERIAL_GOLD = MATERIAL_AMOUNT_FOR_SHEETS(6))
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 2)
	build_path = /obj/item/mecha_equipment/shield

/datum/design/item/mechfab/exosuit_equipment/autolathe
	name = "Mounted Autolathe"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(5), MATERIAL_SILVER = MATERIAL_AMOUNT_FOR_SHEETS(0.5))
	build_path = /obj/item/mecha_equipment/autolathe

/datum/design/item/mechfab/exosuit_equipment/toolset
	name = "Mounted Toolset"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(2))
	build_path = /obj/item/mecha_equipment/toolset

/datum/design/item/mechfab/exosuit_equipment/quick_enter
	name = "Mounted Rapid-Entry System"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(3))
	build_path = /obj/item/mecha_equipment/quick_enter

/datum/design/item/mechfab/exosuit_equipment/drill_mover
	name = "Mounted Drill Loader System"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(3))
	build_path = /obj/item/mecha_equipment/drill_mover

/datum/design/item/mechfab/exosuit_equipment/phazon
	name = "Phazon Bluespace Transmission System"
	materials = list(MATERIAL_STEEL = MATERIAL_AMOUNT_FOR_SHEETS(12.5), MATERIAL_PHORON = MATERIAL_AMOUNT_FOR_SHEETS(5))
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_BLUESPACE = 5)
	build_path = /obj/item/mecha_equipment/phazon

/datum/design/item/mechfab/exosuit_equipment/phazon/AssembleDesignDesc()
	. = ..()
	desc += " It needs an anomaly core to function, however."

