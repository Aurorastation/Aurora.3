/obj/item/device/hearing_aid
	name = "grey hearing aid"
	desc = "A device that allows the naturally deaf to hear, to an extent."
	icon = 'icons/obj/item/device/hearing_aid.dmi'
	icon_state = "hearing_aid"
	item_state = "hearing_aid"
	slot_flags = SLOT_EARS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/device/hearing_aid/black
	name = "black hearing aid"
	icon_state = "hearing_aid-b"
	item_state = "hearing_aid-b"

/obj/item/device/hearing_aid/silver
	name = "silver hearing aid"
	icon_state = "hearing_aid-s"
	item_state = "hearing_aid-s"

/obj/item/device/hearing_aid/white
	name = "white hearing aid"
	icon_state = "hearing_aid-w"
	item_state = "hearing_aid-w"

/obj/item/device/hearing_aid/skrell
	name = "skrellian hearing aid"
	desc = "A device that allows the naturally deaf to hear, to an extent. It seems to be Skrellian in design."
	icon_state = "hearing_aid_skrell"
	item_state = "hearing_aid_skrell"

/obj/item/storage/hearing_aid_case
	name = "hearing aid case"
	desc = "A small plastic case designed to hold a pair of hearing aids."
	w_class = WEIGHT_CLASS_SMALL
	can_hold = list(/obj/item/device/hearing_aid)
	icon = 'icons/obj/item/device/hearing_aid.dmi'
	icon_state = "hearing_aid_case"
	storage_slots = 2
	starts_with = list(/obj/item/device/hearing_aid = 2)

/obj/item/storage/hearing_aid_case/black
	starts_with = list(/obj/item/device/hearing_aid/black = 2)

/obj/item/storage/hearing_aid_case/silver
	starts_with = list(/obj/item/device/hearing_aid/silver = 2)

/obj/item/storage/hearing_aid_case/white
	starts_with = list(/obj/item/device/hearing_aid/white = 2)

/obj/item/storage/hearing_aid_case/skrell
	starts_with = list(/obj/item/device/hearing_aid/skrell = 2)
