/datum/design/item/disk
	design_order = 11

/datum/design/item/disk/AssembleDesignName()
	name = "Data Disk Design ([name])"

/datum/design/item/disk/design_disk
	name = "Design Storage"
	desc = "Produce additional disks for storing device designs."
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 10)
	build_path = /obj/item/disk/design_disk

/datum/design/item/disk/tech_disk
	name = "Technology Data Storage"
	desc = "Produce additional disks for storing technology data."
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 10)
	build_path = /obj/item/disk/tech_disk

/datum/design/item/disk/flora_disk
	name = "Flora Data Storage"
	desc = "Produce additional disks for storing flora data."
	req_tech = list(TECH_DATA = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 30, MATERIAL_GLASS = 10)
	build_path = /obj/item/disk/botany