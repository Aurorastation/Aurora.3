//crime scene kit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	item_state = "case"
	storage_slots = 14
	max_storage_space = 35
	contained_sprite = 1

	..()
	new /obj/item/device/uv_light(src)
