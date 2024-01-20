/datum/design/item/powercell
	build_type = PROTOLATHE
	category = "Misc" // For the mechfab
	p_category = "Power Cell Designs"

/datum/design/item/powercell/AssembleDesignDesc()
	..()
	var/obj/item/cell/C = build_path
	desc += " This level of power cell stores [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/Fabricate()
	var/obj/item/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	return C

/datum/design/item/powercell/basic
	name = "Basic"
	req_tech = list(TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 50)
	build_path = /obj/item/cell

/datum/design/item/powercell/high
	name = "High-Capacity"
	req_tech = list(TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 60)
	build_path = /obj/item/cell/high

/datum/design/item/powercell/super
	name = "Super-Capacity"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 70)
	build_path = /obj/item/cell/super

/datum/design/item/powercell/hyper
	name = "Hyper-Capacity"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 400, MATERIAL_GOLD = 150, MATERIAL_SILVER = 150, MATERIAL_GLASS = 70)
	build_path = /obj/item/cell/hyper

/datum/design/item/powercell/device
	name = "Device"
	req_tech = list(TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 70, MATERIAL_GLASS = 5)
	build_path = /obj/item/cell/device

/datum/design/item/powercell/device/high
	name = "Advanced Device"
	req_tech = list(TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 150, MATERIAL_GLASS = 10)
	build_path = /obj/item/cell/device/high

/datum/design/item/powercell/mecha
	name = "Power Core"
	build_type = MECHFAB
	req_tech = list(TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GLASS = 10000)
	build_path = /obj/item/cell/mecha

/datum/design/item/powercell/mecha/nuclear
	name = "Nuclear Power Core"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GLASS = 10000, MATERIAL_URANIUM = 10000)
	build_path = /obj/item/cell/mecha/nuclear

/datum/design/item/powercell/mecha/phoron
	name = "Phoron Power Core"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GLASS = 10000, MATERIAL_PHORON = 5000)
	build_path = /obj/item/cell/mecha/phoron
