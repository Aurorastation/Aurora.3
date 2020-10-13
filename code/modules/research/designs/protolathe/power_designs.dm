/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB
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
	req_tech = "{'powerstorage':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 50)
	build_path = /obj/item/cell

/datum/design/item/powercell/high
	name = "High-Capacity"
	req_tech = "{'powerstorage':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 60)
	build_path = /obj/item/cell/high

/datum/design/item/powercell/super
	name = "Super-Capacity"
	req_tech = "{'powerstorage':3,'materials':2}"
	materials = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 70)
	build_path = /obj/item/cell/super

/datum/design/item/powercell/hyper
	name = "Hyper-Capacity"
	req_tech = "{'powerstorage':5,'materials':4}"
	materials = list(DEFAULT_WALL_MATERIAL = 400, MATERIAL_GOLD = 150, MATERIAL_SILVER = 150, MATERIAL_GLASS = 70)
	build_path = /obj/item/cell/hyper

/datum/design/item/powercell/device
	name = "Device"
	req_tech = "{'powerstorage':1}"
	materials = list(DEFAULT_WALL_MATERIAL = 700, MATERIAL_GLASS = 50)
	build_path = /obj/item/cell/device