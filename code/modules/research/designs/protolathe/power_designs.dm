/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB
	category = "Misc" // For the mechfab
	design_order = 7

/datum/design/item/powercell/AssembleDesignName()
	name = "Power Cell Design ([item_name])"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

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
	materials = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 50)
	build_path = /obj/item/cell/device