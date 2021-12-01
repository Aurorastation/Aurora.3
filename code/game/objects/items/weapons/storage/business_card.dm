/obj/item/storage/business_card_holder
	name = "business card holder"
	desc = "A sleek holster for your business card. You wouldn't want it getting damaged in any way."
	storage_slots = 5
	icon = 'icons/obj/bureaucracy.dmi'
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

/obj/item/paper/business_card/attack_self(mob/living/user)

/obj/item/paper/business_card
	name = "business card"
	desc = "A small slip of paper, capable of elevating your status on the social hierachy between you and your co-workers, provided you picked the right font."
	icon_state = "generic_card1"

/obj/item/paper/business_card/attack_self(mob/living/user)
	if(last_flash <= world.time - 20)
		last_flash = world.time
		card_flash(user) // Shamelessly copypasta'd from id_flash from cards_ids.dm

/obj/item/paper/business_card/proc/card_flash(var/mob/user, var/add_text = "", var/blind_add_text = "")
	var/list/id_viewers = viewers(3, user) // or some other distance - this distance could be defined as a var on the ID
	var/message = "<b>[user]</b> flashes [user.get_pronoun("his")] [icon2html(src, id_viewers)] [src.name]."
	var/blind_message = "You flash your [icon2html(src, id_viewers)] [src.name]."
	var/quality = pick("the tasteful thickness of it", "that subtle off-white coloring", "the carefully curated font", "that watermark.", "that bold, contemporary serif.")
	var/complement = pick("Oh my god.", "Impressive.", "Very nice.", "Nice.", "Jesus.", "Cool.", "How'd they get so tasteful?")
	var/add_text = "Look at [quality]. [complement]"
	var/blind_add_text = "You show off [quality].
	if(add_text != "")
		message += " [add_text]"
	if(blind_add_text != "")
		blind_message += " [blind_add_text]"
	user.visible_message(message, blind_message)

/obj/item/paper/business_card/alt
	icon_state = "generic_card2"

/obj/item/paper/business_card/rounded
	icon_state = "rounded_corners"

/obj/item/paper/business_card/glass
	name = "glass business card"
	desc = "A fancy variant of the classic business card. This one immediately indicates that you're serious about your business, but the contents of the card will seal the deal."
	icon_state = "glass_card"

/obj/item/paper/business_card/glass/id_flash(var/mob/user)
    var/quality = pick("the slick professionalism of it", "that smooth glass", "the carefully curated font", "that watermark.", "that bold, contemporary serif.")
    return ..(user, add_text, blind_add_text)