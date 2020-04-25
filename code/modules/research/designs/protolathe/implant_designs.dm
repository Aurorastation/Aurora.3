/datum/design/item/implant
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)
	design_order = 5

/datum/design/item/implant/AssembleDesignName()
	..()
	name = "Implantable Biocircuit Design ([item_name])"

/datum/design/item/implant/chemical
	name = "Chemical"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/chem

/datum/design/item/implant/freedom
	name = "Freedom"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/freedom