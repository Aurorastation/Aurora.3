/datum/design/item/disk
	p_category = "Data Disk Designs"

/datum/design/item/disk/design_disk
	name = "Design Storage"
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 10)
	build_path = /obj/item/disk/design_disk

/datum/design/item/disk/tech_disk
	name = "Technology Data Storage"
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 10)
	build_path = /obj/item/disk/tech_disk

/datum/design/item/disk/flora_disk
	name = "Flora Data Storage"
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 10)
	build_path = /obj/item/disk/botany
