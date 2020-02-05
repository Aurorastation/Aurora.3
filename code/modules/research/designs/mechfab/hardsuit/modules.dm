/datum/design/hardsuitmodules
	build_type = MECHFAB
	category = "Hardsuit (Modules)"
	time = 10

/datum/design/hardsuitmodules/iss_module
	name = "IIS module"
	desc = "An integrated intelligence system module suitable for most hardsuits."
	id = "iis_module"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 3)
	materials = list("glass" = 7500, DEFAULT_WALL_MATERIAL = 5000)
	build_path = /obj/item/rig_module/ai_container

/datum/design/hardsuitmodules/sink_module
	name = "hardsuit power sink"
	desc = "An heavy-duty power sink suitable for hardsuits."
	id = "power_sink_module"
	req_tech = list(TECH_POWER = 4, TECH_MATERIAL = 3, TECH_ENGINEERING = 4, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "gold"= 2000, "silver"= 3000, "glass"= 2000)
	build_path = /obj/item/rig_module/power_sink

/datum/design/hardsuitmodules/meson_module
	name = "hardsuit meson scanner"
	desc = "A layered, translucent visor system for a hardsuit."
	id = "meson_module"
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	materials = list("glass"= 5000, DEFAULT_WALL_MATERIAL= 1500)
	build_path = /obj/item/rig_module/vision/meson

/datum/design/hardsuitmodules/sechud_module
	name = "hardsuit security hud"
	desc = "A simple tactical information system for a hardsuit."
	id = "sechud_module"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 2, TECH_MAGNET = 3)
	materials = list("glass" = 5000, DEFAULT_WALL_MATERIAL =1500)
	build_path = /obj/item/rig_module/vision/sechud

/datum/design/hardsuitmodules/medhud_module
	name = "hardsuit medical hud"
	desc = "A simple medical status indicator for a hardsuit."
	id = "medhu_module"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 2, TECH_MAGNET = 3)
	materials = list("glass"= 5000, DEFAULT_WALL_MATERIAL =1500)
	build_path = /obj/item/rig_module/vision/medhud

/datum/design/hardsuitmodules/nvg_module
	name = "hardsuit night vision interface"
	desc = "A multi input night vision system for a hardsuit."
	id = "nvg_module"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 3, TECH_MAGNET = 4)
	materials = list("glass" = 5000, DEFAULT_WALL_MATERIAL = 1500, "uranium" = 5000)
	build_path = /obj/item/rig_module/vision/nvg

/datum/design/hardsuitmodules/healthscanner_module
	name = "hardsuit health scanner"
	desc = "A hardsuit-mounted health scanner."
	id = "healthscanner_module"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list("glass" = 5250, DEFAULT_WALL_MATERIAL = 2500)
	build_path = /obj/item/rig_module/device/healthscanner

/datum/design/hardsuitmodules/chem_module
	name = "mounted chemical injector"
	desc = "A complex web of tubing and a large needle suitable for hardsuit use."
	id = "chem_module"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_DATA = 3, TECH_PHORON = 2)
	materials = list("glass" = 9250, DEFAULT_WALL_MATERIAL = 10000, "gold" = 2500, "silver" = 4250, "phoron" = 5500)
	build_path = /obj/item/rig_module/chem_dispenser/injector

/datum/design/hardsuitmodules/plasmacutter_module
	name = "hardsuit plasma cutter"
	desc = "A self-sustaining plasma arc capable of cutting through walls."
	id = "plasmacutter_module"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_PHORON = 4)
	materials = list("glass" = 5250, DEFAULT_WALL_MATERIAL = 30000, "silver" = 5250, "phoron" = 7250)
	build_path = /obj/item/rig_module/mounted/plasmacutter

/datum/design/hardsuitmodules/jet_module
	name = "hardsuit maneuvering jets"
	desc = "A compact gas thruster system for a hardsuit."
	id = "jet_module"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list("glass" = 4250, DEFAULT_WALL_MATERIAL = 15000, "silver" = 4250,"uranium" = 5250)
	build_path = /obj/item/rig_module/maneuvering_jets

/datum/design/hardsuitmodules/drill_module
	name = "hardsuit drill mount"
	desc = "A very heavy diamond-tipped drill."
	id = "drill_module"
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials = list("glass" = 2250, DEFAULT_WALL_MATERIAL = 55000, "silver" = 5250, "diamond" = 3750)
	build_path = /obj/item/rig_module/device/drill

/datum/design/hardsuitmodules/rfd_c_module
	name = "RFD-C mount"
	desc = "A cell-powered Rapid-Fabrication-Device C-Class for a hardsuit."
	id = "rcd_module"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 5, TECH_POWER = 5, TECH_BLUESPACE = 4)
	materials = list(DEFAULT_WALL_MATERIAL= 30000, "phoron" = 12500, "silver" = 10000, "gold" = 10000)
	build_path = /obj/item/rig_module/device/rfd_c

/datum/design/hardsuitmodules/actuators_module
	name = "leg actuators"
	desc = "A set of electromechanical actuators, for safe traversal of multilevelled areas."
	id = "actuators_module"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 85000, "glass" = 1250, "silver" = 5250, "gold" = 2750)
	build_path = /obj/item/rig_module/actuators

/datum/design/hardsuitmodules/taser_module
	name = "mounted taser"
	desc = "A palm-mounted nonlethal energy projector."
	id = "taser_module"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_COMBAT = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 5250)
	build_path = /obj/item/rig_module/mounted/taser

/datum/design/hardsuitmodules/egun_module
	name = "mounted energy gun"
	desc = "A forearm-mounted energy projector."
	id = "egun_module"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 4, TECH_COMBAT = 4, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL= 7000, "glass"= 2250, "uranium"= 3250, "gold"= 2500)
	build_path = /obj/item/rig_module/mounted/egun

/datum/design/hardsuitmodules/cooling_module
	name = "mounted cooling unit"
	desc = "A heat sink with liquid cooled radiator."
	id = "cooling_module"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL= 7000, "glass"= 5500)
	build_path = /obj/item/rig_module/cooling_unit