
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Miscellaneous xenoarchaeology tools

/obj/item/device/measuring_tape
	name = "measuring tape"
	desc = "A coiled metallic tape used to check dimensions and lengths."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "measuring"
	w_class = WEIGHT_CLASS_SMALL

//todo: dig site tape

/obj/item/storage/bag/fossils
	name = "fossil satchel"
	desc = "Transports delicate fossils in suspension so they don't break during transit."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "fossil_satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = WEIGHT_CLASS_NORMAL
	max_storage_space = 100
	max_w_class = WEIGHT_CLASS_NORMAL
	can_hold = list(/obj/item/fossil)
