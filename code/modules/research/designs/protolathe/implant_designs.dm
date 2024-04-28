/datum/design/item/implant
	materials = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)
	p_category = "Implantable Biocircuit Designs"

/datum/design/item/implant/adrenaline
	name = "Adrenaline"
	req_tech = list(TECH_MATERIAL = 1, TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/adrenaline

/datum/design/item/implant/chemical
	name = "Chemical"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/chem

/datum/design/item/implant/death_alarm
	name = "Death Alarm"
	req_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3, TECH_DATA = 2)
	build_path = /obj/item/implantcase/death_alarm

/datum/design/item/implant/freedom
	name = "Freedom"
	req_tech = list(TECH_MATERIAL = 1, TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/implantcase/freedom
