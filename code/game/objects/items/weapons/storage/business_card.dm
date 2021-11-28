/obj/item/storage/business_card_holder
	name = "business card holder"
	desc = "A sleek holster for your business card. You wouldn't want it getting damaged in any way."
	storage_slots = 5
	icon = 'icons/obj/office_supplies.dmi'
	icon_state = "holder"
	w_class = ITEMSIZE_TINY
	max_w_class = ITEMSIZE_TINY
	can_hold = list(/obj/item/paper/business_card)

/obj/item/storage/business_card_holder/update_icon()
	cut_overlays()
	if(length(contents))
		var/mutable_appearance/card_overlay = mutable_appearance(icon, "holder-overlay")
		card_overlay.appearance_flags = RESET_COLOR
		add_overlay(card_overlay)

/obj/item/paper/business_card
	name = "business card"
	desc = "A small slip of paper, capable of elevating your status on the social hierachy between you and your co-workers, provided you picked the right font."
	icon = 'icons/obj/office_supplies.dmi'
	icon_state = "generic_card1"

/obj/item/paper/business_card/attack_self(mob/living/user)
	user.examinate(src)

/obj/item/paper/business_card/alt
	icon_state = "generic_card2"

/obj/item/paper/business_card/rounded
	icon_state = "rounded_corners"

/obj/item/paper/business_card/glass
	name = "glass business card"
	desc = "A fancy variant of the classic business card. This one immediately indicates that you're serious about your business, but the contents of the card will seal the deal."
	icon_state = "glass_card"