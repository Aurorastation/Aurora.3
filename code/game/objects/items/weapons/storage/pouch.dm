/obj/item/storage/pouch
	name = "storage pouch"
	desc = "A small storage pouch."
	icon = 'icons/obj/contained_items/storage/pouch.dmi'
	icon_state = "pouch"
	contained_sprite = TRUE
	use_sound = /decl/sound_category/rustle_sound
	drop_sound = 'sound/items/drop/hat.ogg'
	pickup_sound = 'sound/items/pickup/hat.ogg'
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_SMALL
	max_storage_space = 14 // 7 small items
	storage_slots = 7
	allow_same_size_storage = TRUE
	pocket_storage = TRUE

/obj/item/storage/pouch/medical
	name = "medical pouch"
	desc = "A small storage pouch, with various compartments to hold medical essentials."
	icon_state = "pouch_med"
	can_hold = list(/obj/item/storage/pill_bottle, /obj/item/reagent_containers/hypospray, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/pill, /obj/item/reagent_containers/food/drinks/medcup, /obj/item/reagent_containers/spray, /obj/item/stack/medical, /obj/item/device/breath_analyzer, /obj/item/device/healthanalyzer, /obj/item/clothing/mask/smokable, /obj/item/reagent_containers/ecig_cartridge)

/obj/item/storage/pouch/circuit
	name = "circuit pouch"
	desc = "A small storage pouch, with various compartments to hold various circuitboards."
	icon_state = "pouch_circuit"
	can_hold = list(/obj/item/circuitboard, /obj/item/airlock_electronics, /obj/item/airalarm_electronics, /obj/item/firealarm_electronics, /obj/item/module, /obj/item/clothing/mask/smokable, /obj/item/reagent_containers/ecig_cartridge)