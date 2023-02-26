/obj/item/disk/autolathe
	name = "autolathe design disk"
	icon = 'icons/obj/item/autolathe_disks.dmi'
	icon_state = "disk"
	item_icons = null
	var/holo_style = "generic"
	var/name_override = ""
	var/list/compatible_categories = list()
	var/list/disk_specific_recipies

/obj/item/disk/autolathe/Initialize()
	. = ..()
	name = "[name] ([name_override || holo_style])"
	var/image/cover = image(icon, null, "cover")
	cover.appearance_flags = RESET_COLOR
	add_overlay(cover)
	var/image/hologram = image(icon, null, holo_style)
	hologram.appearance_flags = RESET_COLOR
	add_overlay(hologram)

/obj/item/disk/autolathe/engineering
	holo_style = "engineering"
	compatible_categories = list("Tools", "Engineering")
	color = COLOR_GOLD

/obj/item/disk/autolathe/medical
	holo_style = "medical"
	compatible_categories = list("Medical")
	color = COLOR_GREEN

/obj/item/disk/autolathe/security
	holo_style = "security"
	compatible_categories = list("Arms and Ammunition")
	color = COLOR_MAROON

/obj/item/disk/autolathe/science
	holo_style = "science"
	compatible_categories = list("Devices and Components")
	color = COLOR_PURPLE

// 9mm Trash Loot
/obj/item/disk/autolathe/trash_gun
	name_override = "Trash Blaster DO NOT STEAL!!!"
	disk_specific_recipies = list(
		/datum/autolathe/recipe/disk/trash_gun,
		/datum/autolathe/recipe/disk/trash_ammo
	)
	color = COLOR_MAROON

/datum/autolathe/recipe/disk/trash_gun
	name = "9mm pistol"
	path = /obj/item/gun/projectile/pistol
	resources = list(DEFAULT_WALL_MATERIAL = 40000)

/datum/autolathe/recipe/disk/trash_ammo
	name = "magazine (9mm)"
	path = /obj/item/ammo_magazine/mc9mm
