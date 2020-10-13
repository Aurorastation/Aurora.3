/datum/design/item/mechfab/exosuit_equipment
	name = "Hydraulic Clamp"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	time = 50
	build_path = /obj/item/mecha_equipment/clamp
	category = "Exosuit (Equipment)"

/datum/design/item/mechfab/exosuit_equipment/gravity_catapult
	name = "Gravity Catapult"
	build_path = /obj/item/mecha_equipment/catapult

/datum/design/item/mechfab/exosuit_equipment/drill
	name = "Drill"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/drill

/datum/design/item/mechfab/exosuit_equipment/taser
	name = "Mounted Taser"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	req_tech = "{'combat':1}"
	build_path = /obj/item/mecha_equipment/mounted_system/taser

/datum/design/item/mechfab/exosuit_equipment/uac
	name = "Mounted Automatic Weapon"
	req_tech = "{'combat':4}"
	build_path = /obj/item/mecha_equipment/mounted_system/taser/smg

/datum/design/item/mechfab/exosuit_equipment/plasma
	name = "Mounted Plasma Cutter"
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 1000, MATERIAL_GOLD = 1000, MATERIAL_PHORON = 1000)
	req_tech = "{'combat':2,'materials':4,'engineering':3}"
	build_path = /obj/item/mecha_equipment/mounted_system/plasmacutter

/datum/design/item/mechfab/exosuit_equipment/ion
	name = "Mounted Ion Rifle"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	req_tech = "{'combat':4,'magnets':4}"
	build_path = /obj/item/mecha_equipment/mounted_system/taser/ion

/datum/design/item/mechfab/exosuit_equipment/laser
	name = "Mounted Laser Gun"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	req_tech = "{'combat':4,'magnets':4}"
	build_path = /obj/item/mecha_equipment/mounted_system/taser/laser

/datum/design/item/mechfab/exosuit_equipment/rcd
	name = "Mounted RFD-C"
	time = 90
	materials = list(DEFAULT_WALL_MATERIAL = 30000, MATERIAL_PHORON = 25000, DEFAULT_WALL_MATERIAL = 15000, MATERIAL_GOLD = 15000)
	req_tech = "{'materials':4,'bluespace':3,'magnets':4,'powerstorage':4,'engineering':4}"
	build_path = /obj/item/mecha_equipment/mounted_system/rfd

/datum/design/item/mechfab/exosuit_equipment/floodlight
	name = "Mounted Floodlight"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 5000)
	req_tech = "{'engineering':1}"
	build_path = /obj/item/mecha_equipment/light

/datum/design/item/mechfab/exosuit_equipment/sleeper
	name = "Mounted Sleeper"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 10000)
	build_path = /obj/item/mecha_equipment/sleeper

/datum/design/item/mechfab/exosuit_equipment/extinguisher
	name = "Mounted Extinguisher"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/mounted_system/extinguisher

/datum/design/item/mechfab/exosuit_equipment/xray
	name = "Mounted X-Ray Gun"
	req_tech = "{'combat':4,'magnets':4,'materials':5,'syndicate':3}"
	build_path = /obj/item/mecha_equipment/mounted_system/xray
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GOLD = 6000, MATERIAL_PHORON = 6000)

/datum/design/item/mechfab/exosuit_equipment/flashbang
	name = "Mounted Flashbang Launcher"
	req_tech = "{'combat':3}"
	build_path = /obj/item/mecha_equipment/mounted_system/grenadeflash
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GOLD = 6000, MATERIAL_PHORON = 6000)

/datum/design/item/mechfab/exosuit_equipment/crisisdrone
	name = "Mounted Crisis Drone"
	build_path = /obj/item/mecha_equipment/crisis_drone
	req_tech = "{'magnets':3,'programming':3,'biotech':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GOLD = 1000, MATERIAL_SILVER = 2000, MATERIAL_GLASS = 5000)

/datum/design/item/mechfab/exosuit_equipment/analyzer
	name = "Mounted Health Analyzer"
	req_tech = "{'magnets':2,'biotech':3}"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 5000)
	build_path = /obj/item/mecha_equipment/mounted_system/medanalyzer

/datum/design/item/mechfab/exosuit_equipment/flaregun
	name = "Mounted Flare Launcher"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/mounted_system/flarelauncher

/datum/design/item/mechfab/exosuit_equipment/passenger_compartment
	name = "Mounted Passenger Compartment"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/sleeper/passenger_compartment

/datum/design/item/mechfab/exosuit_equipment/mechshields
	name = "Energy Shield Drone"
	time = 90
	materials = list(MATERIAL_STEEL = 20000, MATERIAL_SILVER = 12000, MATERIAL_GOLD = 12000)
	req_tech = "{'materials':4,'magnets':4,'powerstorage':4,'combat':2}"
	build_path = /obj/item/mecha_equipment/shield

/datum/design/item/mechfab/exosuit_equipment/autolathe
	name = "Mounted Autolathe"
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_SILVER = 1000)
	build_path = /obj/item/mecha_equipment/autolathe

/datum/design/item/mechfab/exosuit_equipment/toolset
	name = "Mounted Toolset"
	materials = list(DEFAULT_WALL_MATERIAL = 7500)
	build_path = /obj/item/mecha_equipment/toolset

/datum/design/item/mechfab/exosuit_equipment/quick_enter
	name = "Mounted Rapid-Entry System"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/quick_enter

/datum/design/item/mechfab/exosuit_equipment/drill_mover
	name = "Mounted Drill Loader System"
	materials = list(DEFAULT_WALL_MATERIAL = 15000)
	build_path = /obj/item/mecha_equipment/drill_mover