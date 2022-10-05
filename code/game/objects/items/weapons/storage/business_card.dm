/obj/item/storage/business_card_holder
	name = "business card holder"
	desc = "A sleek holster for your business card. You wouldn't want it getting damaged in any way."
	storage_slots = 10
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "holder"
	w_class = ITEMSIZE_TINY
	max_w_class = ITEMSIZE_TINY
	can_hold = list(/obj/item/paper/business_card)

/obj/item/storage/business_card_holder/update_icon()
	cut_overlays()
	var/overlay_type
	if(length(contents))
		var/obj/O = contents[1]
		if(istype(O, /obj/item/paper/business_card/glass)) // Could be better, I guess. But it works well enough.
			overlay_type = "glass"
		else
			overlay_type = "paper"
		var/mutable_appearance/card_overlay = mutable_appearance(icon, "holder-overlay_[overlay_type]")
		if(O.color)
			card_overlay.color = O.color
		else
			card_overlay.appearance_flags = RESET_COLOR
		add_overlay(card_overlay)

/obj/item/storage/business_card_holder/wood
	icon_state = "holder_wood"

/obj/item/storage/business_card_holder/leather
	icon_state = "holder_leather"

/obj/item/storage/business_card_holder/plastic
	icon_state = "holder_plastic"

// Business cards (copied from lunchbox code)
var/list/business_cards_ = list(
	/obj/item/paper/business_card,
	/obj/item/paper/business_card/alt,
	/obj/item/paper/business_card/rounded,
	/obj/item/paper/business_card/glass,
	/obj/item/paper/business_card/glass/b,
	/obj/item/paper/business_card/glass/g,
	/obj/item/paper/business_card/glass/s,
	/obj/item/paper/business_card/glass/w
	)

/proc/business_cards()
	if(!(business_cards_[business_cards_[1]]))
		business_cards_ = init_cardable_list(business_cards_)
	return business_cards_

/proc/init_cardable_list(var/list/cardables)
	. = list()
	for(var/card in cardables)
		var/obj/O = card
		.[initial(O.name)] = card

	sortTim(., /proc/cmp_text_asc)

/obj/item/paper/business_card
	name = "business card, divided"
	desc = "A small slip of paper, capable of elevating your status on the social hierachy between you and your co-workers, provided you picked the right font."
	icon_state = "business_card"
	var/last_flash = 0 //spam limiter
	can_fold = FALSE

/obj/item/paper/business_card/update_icon()
	. = ..()
	if(worn_overlay)
		cut_overlays()
		add_overlay(overlay_image(icon, worn_overlay, flags=RESET_COLOR))

/obj/item/paper/business_card/attack_self(mob/living/user)
	if(last_flash <= world.time - 20)
		last_flash = world.time
		card_flash(user) // Shamelessly copypasta'd from id_flash from cards_ids.dm

/obj/item/paper/business_card/proc/card_flash(var/mob/user, var/quality = pick("the tasteful thickness of it", "that subtle off-white coloring", "the carefully curated font", "that watermark", "that bold, contemporary serif"), var/complement = pick("Oh my god.", "Impressive.", "Very nice.", "Nice.", "Jesus.", "Cool.", "How'd they get so tasteful?"))
	var/list/card_viewers = viewers(3, user) // or some other distance - this distance could be defined as a var on the ID
	var/message = "<b>[user]</b> flashes [user.get_pronoun("his")] [icon2html(src, card_viewers)] [src.name]."
	var/blind_message = "You flash your [icon2html(src, card_viewers)] [src.name]."
	var/add_text = "Look at [quality]. [complement]"
	var/blind_add_text = "You show off [quality]."
	if(add_text != "")
		message += " [add_text]"
	if(blind_add_text != "")
		blind_message += " [blind_add_text]"
	user.visible_message(message, blind_message)

/obj/item/paper/business_card/show_content(mob/user, forceshow)
	var/datum/browser/paper_win = new(user, name, null, 525, 300, null, TRUE)
	paper_win.set_content(get_content(user, can_read(user, forceshow)))
	paper_win.add_stylesheet("paper_languages", 'html/browser/paper_languages.css')
	paper_win.open()

/obj/item/paper/business_card/alt
	name = "business card, plain"
	icon_state = "business_card-alt"

/obj/item/paper/business_card/rounded
	name = "business card, rounded"
	icon_state = "business_card-rounded"

/obj/item/paper/business_card/glass
	name = "glass business card"
	desc = "A fancy variant of the classic business card. This one immediately indicates that you're serious about your business, but the contents of the card will seal the deal."
	icon_state = "business_card-glass"
	drop_sound = 'sound/items/drop/glass_small.ogg'
	pickup_sound = 'sound/items/pickup/glass_small.ogg'
	build_from_parts = TRUE
	paper_like = FALSE

/obj/item/paper/business_card/glass/card_flash(var/mob/user)
	var/quality = pick("the tasteful transparency of it", "that subtle light refraction", "the carefully curated font", "that watermark", "that bold, contemporary serif")
	var/complement = pick("Oh my god.", "Impressive.", "Very nice.", "Nice.", "Jesus.", "Cool.", "How'd they get so tasteful?")
	return ..(user, quality, complement)

/obj/item/paper/business_card/glass/b
	name = "glass business card, black flair"
	worn_overlay = "business_card-glass-b"

/obj/item/paper/business_card/glass/g
	name = "glass business card, grey flair"
	worn_overlay = "business_card-glass-g"

/obj/item/paper/business_card/glass/s
	name = "glass business card, silver flair"
	worn_overlay = "business_card-glass-s"

/obj/item/paper/business_card/glass/w
	name = "glass business card, white flair"
	worn_overlay = "business_card-glass-w"
