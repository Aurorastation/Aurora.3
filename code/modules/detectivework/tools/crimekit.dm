//crime scene kit
/obj/item/storage/briefcase/crimekit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	item_state = "case"
	storage_slots = 14
	max_storage_space = 35
	contained_sprite = 1

/obj/item/storage/briefcase/crimekit/fill()
	..()
	new /obj/item/storage/box/swabs(src)
	new /obj/item/storage/box/fingerprints(src)
	new /obj/item/reagent_containers/spray/luminol(src)
	new /obj/item/device/uv_light(src)
	new /obj/item/forensics/sample_kit(src)
	new /obj/item/forensics/sample_kit/powder(src)
