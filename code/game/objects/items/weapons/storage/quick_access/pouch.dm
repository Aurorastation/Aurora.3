/obj/item/quick/pouch
	name = "pouch"
	desc = "A small leather pouch, the perfect size to fit into pockets."
	icon_state = "pouch"
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'
	w_class = ITEMSIZE_SMALL

	can_put_back = TRUE
	max_amount = 5

	allowed_items = list(/obj/item/stack/medical)
	spawn_new = FALSE

/obj/item/quick/pouch/set_item_name()
	..()
	name = "[item_name] [name]"

/obj/item/quick/pouch/medical
	additional_overlay = "pouch-medical"

/obj/item/quick/pouch/medical/gauze
	spawn_type = /obj/item/stack/medical/bruise_pack

/obj/item/quick/pouch/medical/ointment
	spawn_type = /obj/item/stack/medical/ointment

/obj/item/quick/pouch/medical/trauma_kit
	spawn_type = /obj/item/stack/medical/advanced/bruise_pack

/obj/item/quick/pouch/medical/burn_kit
	spawn_type = /obj/item/stack/medical/advanced/ointment