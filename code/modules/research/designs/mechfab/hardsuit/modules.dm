/datum/design/hardsuitmodules
	build_type = MECHFAB
	category = "Hardsuit (Modules)"
	time = 10

/datum/design/hardsuitmodules/iss_module
	name = "IIS Module"
	desc = "An integrated intelligence system module suitable for most hardsuits."
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 7500)
	build_path = /obj/item/rig_module/ai_container

/datum/design/hardsuitmodules/sink_module
	name = "Hardsuit Powersink"
	desc = "An heavy-duty power sink suitable for hardsuits."
	req_tech = list(TECH_POWER = 4, TECH_MATERIAL = 3, TECH_ENGINEERING = 4, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 3000, MATERIAL_GLASS = 2000)
	build_path = /obj/item/rig_module/power_sink

/datum/design/hardsuitmodules/meson_module
	name = "Hardsuit Meson Scanner"
	desc = "A layered, translucent visor system for a hardsuit."
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 2, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000)
	build_path = /obj/item/rig_module/vision/meson

/datum/design/hardsuitmodules/sechud_module
	name = "Hardsuit Security HUD"
	desc = "A simple tactical information system for a hardsuit."
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 2, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000)
	build_path = /obj/item/rig_module/vision/sechud

/datum/design/hardsuitmodules/medhud_module
	name = "Hardsuit Medical HUD"
	desc = "A simple medical status indicator for a hardsuit."
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 2, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000)
	build_path = /obj/item/rig_module/vision/medhud

/datum/design/hardsuitmodules/nvg_module
	name = "Hardsuit Nightvision Interface"
	desc = "A multi input night vision system for a hardsuit."
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 3, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, MATERIAL_GLASS = 5000, MATERIAL_URANIUM = 5000)
	build_path = /obj/item/rig_module/vision/nvg

/datum/design/hardsuitmodules/healthscanner_module
	name = "Hardsuit Health Scanner"
	desc = "A hardsuit-mounted health scanner."
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2500, MATERIAL_GLASS = 5250)
	build_path = /obj/item/rig_module/device/healthscanner

/datum/design/hardsuitmodules/chem_module
	name = "Mounted Chemical Injector"
	desc = "A complex web of tubing and a large needle suitable for hardsuit use."
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 4, TECH_DATA = 3, TECH_PHORON = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GLASS = 9250, MATERIAL_GOLD = 2500, MATERIAL_SILVER = 4250, MATERIAL_PHORON = 5500)
	build_path = /obj/item/rig_module/chem_dispenser/injector

/datum/design/hardsuitmodules/plasmacutter_module
	name = "Hardsuit Plasma Cutter"
	desc = "A self-sustaining plasma arc capable of cutting through walls."
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 30000, MATERIAL_GLASS = 5250, MATERIAL_SILVER = 5250, MATERIAL_PHORON = 7250)
	build_path = /obj/item/rig_module/mounted/plasmacutter

/datum/design/hardsuitmodules/jet_module
	name = "Hardsuit Maneuvering Jets"
	desc = "A compact gas thruster system for a hardsuit."
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 15000, MATERIAL_GLASS = 4250, MATERIAL_SILVER = 4250, MATERIAL_URANIUM = 5250)
	build_path = /obj/item/rig_module/maneuvering_jets

/datum/design/hardsuitmodules/drill_module
	name = "Hardsuit Drill Mount"
	desc = "A very heavy diamond-tipped drill."
	req_tech = list(TECH_ENGINEERING = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 55000, MATERIAL_GLASS = 2250, MATERIAL_SILVER = 5250, MATERIAL_DIAMOND = 3750)
	build_path = /obj/item/rig_module/device/drill

/datum/design/hardsuitmodules/rfd_c_module
	name = "RFD-C Mount"
	desc = "A cell-powered Rapid-Fabrication-Device C-Class for a hardsuit."
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 5, TECH_POWER = 5, TECH_BLUESPACE = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 30000, MATERIAL_PHORON = 12500, MATERIAL_SILVER = 10000, MATERIAL_GOLD = 10000)
	build_path = /obj/item/rig_module/device/rfd_c

/datum/design/hardsuitmodules/actuators_module
	name = "Leg Actuators"
	desc = "A set of electromechanical actuators, for safe traversal of multilevelled areas."
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 85000, MATERIAL_GLASS = 1250, MATERIAL_SILVER = 5250, MATERIAL_GOLD = 2750)
	build_path = /obj/item/rig_module/actuators

/datum/design/hardsuitmodules/taser_module
	name = "Mounted Taser"
	desc = "A palm-mounted non-lethal energy projector."
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_COMBAT = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 7000, MATERIAL_GLASS = 5250)
	build_path = /obj/item/rig_module/mounted/taser

/datum/design/hardsuitmodules/egun_module
	name = "Mounted Energy Gun"
	desc = "A forearm-mounted energy projector."
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 4, TECH_COMBAT = 4, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 7000, MATERIAL_GLASS = 2250, MATERIAL_URANIUM = 3250, MATERIAL_GOLD = 2500)
	build_path = /obj/item/rig_module/mounted/egun

/datum/design/hardsuitmodules/cooling_module
	name = "Mounted Cooling Unit"
	desc = "A heat sink with liquid cooled radiator."
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 7000, MATERIAL_GLASS = 5500)
	build_path = /obj/item/rig_module/cooling_unit