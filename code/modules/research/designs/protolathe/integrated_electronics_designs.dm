/datum/design/item/integrated_electronics
	design_order = 8

/datum/design/item/integrated_electronics/AssembleDesignName()
	..()
	name = "Integrated Electronic Design ([item_name])"

/datum/design/item/integrated_electronics/wirer
	name = "Custom Wirer Tool"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 2500)
	build_path = /obj/item/device/integrated_electronics/wirer

/datum/design/item/integrated_electronics/debugger
	name = "Custom Circuit Debugger Tool"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 2500)
	build_path = /obj/item/device/integrated_electronics/debugger

/datum/design/item/integrated_electronics/custom_circuit_assembly
	name = "Small Custom Assembly"
	desc = "A customizable assembly for simple, small devices."
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/device/electronic_assembly

/datum/design/item/integrated_electronics/custom_circuit_assembly/medium
	name = "Medium Custom Assembly"
	desc = "A customizable assembly suited for more ambitious mechanisms."
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 20000)
	build_path = /obj/item/device/electronic_assembly/medium

/datum/design/item/integrated_electronics/custom_circuit_assembly/drone
	name = "Drone Custom Assembly"
	desc = "A customizable assembly optimized for autonomous devices."
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 30000)
	build_path = /obj/item/device/electronic_assembly/drone

/datum/design/item/integrated_electronics/custom_circuit_assembly/large
	name = "Large Custom Assembly"
	desc = "A customizable assembly for large machines."
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 40000)
	build_path = /obj/item/device/electronic_assembly/large

/datum/design/item/integrated_electronics/custom_circuit_assembly/implant
	name = "Implant Custom Assembly"
	desc = "An customizable assembly for very small devices, implanted into living entities."
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 3, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/implant/integrated_circuit

/datum/design/item/integrated_electronics/custom_circuit_assembly/device
	name = "Device Custom Assembly"
	desc = "An customizable assembly designed to interface with other devices."
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000)
	build_path = /obj/item/device/assembly/electronic_assembly

/datum/design/item/integrated_electronics/custom_circuit_printer
	name = "Portable Integrated Circuit Printer"
	desc = "A portable(ish) printer for modular machines."
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 4, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/device/integrated_circuit_printer

/datum/design/item/integrated_electronics/custom_circuit_printer_upgrade
	name = "Integrated Circuit Printer Upgrade - Advanced Designs"
	desc = "Allows the integrated circuit printer to create advanced circuits."
	req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 2000)
	build_path = /obj/item/disk/integrated_circuit/upgrade/advanced