/obj/item/clothing/mask/breath/lyodsuit
	name = "lyodsuit mask"
	desc = "A simple mask that forms a part of the Dominian lyodsuit. Rather cozy, if you're warm-blooded. It has a port to connect air tanks to."
	icon = 'icons/clothing/masks/lyodsuit.dmi'
	icon_state = "dom_thermal_mask"
	item_state = "dom_thermal_mask"
	gas_transfer_coefficient = 0.90 // it's made primarily for heat, not gas and chemical protection
	permeability_coefficient = 0.95
	flags_inv = BLOCKHAIR
	contained_sprite = TRUE
	canremove = FALSE

/obj/item/clothing/mask/breath/lyodsuit/adjust_sprites()
	if(hanging)
		icon_state = "[icon_state]down"
		item_state = "[item_state]down"
	else
		icon_state = initial(icon_state)
		item_state = initial(icon_state)

/obj/item/clothing/mask/breath/lyodsuit/lower_message(mob/user)
	user.visible_message("<b>[user]</b> rolls \the [src] up to reveal their face.", SPAN_NOTICE("You roll \the [src] up to reveal your face."), range = 3)

/obj/item/clothing/mask/breath/lyodsuit/raise_message(mob/user)
	user.visible_message("<b>[user]</b> pulls \the [src] down to cover their face.", SPAN_NOTICE("You pull \the [src] down to cover your face."), range = 3)

/obj/item/clothing/gloves/lyodsuit
	name = "lyodsuit gloves"
	desc = "A pair of thermal gloves, guaranteed to keep hands toasty."
	icon = 'icons/clothing/gloves/lyodsuit.dmi'
	icon_state = "dom_thermal_gloves"
	item_state = "dom_thermal_gloves"
	contained_sprite = TRUE

/obj/item/clothing/shoes/lyodsuit
	name = "lyodsuit boots"
	desc = "A pair of thermal boots, guaranteed to prevent cold feet."
	icon = 'icons/clothing/shoes/lyodsuit.dmi'
	icon_state = "dom_thermal_boots"
	item_state = "dom_thermal_boots"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/dominia_cape
	name = "dominian cape"
	desc = "This is a cape in the style of Dominian nobility. It's the latest fashion across Dominian space."
	icon = 'icons/clothing/suits/capes/dominia.dmi'
	icon_state = "dominian_cape"
	item_state = "dominian_cape"
	icon_override = null
	contained_sprite = TRUE
	var/cape_backing_state = "cape_backing"

/obj/item/clothing/accessory/poncho/dominia_cape/white
	name = "white dominian cape"
	icon_state = "dominian_capew"
	item_state = "dominian_capew"
	cape_backing_state = "capew_backing"

/obj/item/clothing/accessory/poncho/dominia_cape/get_mob_overlay(var/mob/living/carbon/human/human, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_wear_suit_str)
		var/image/cape_backing = image(mob_icon, null, cape_backing_state, human ? human.layer - 0.01 : MOB_LAYER - 0.01)
		I.add_overlay(cape_backing)
	return I

/obj/item/clothing/accessory/poncho/dominia_cape/get_accessory_mob_overlay(mob/living/carbon/human/human, force)
	var/image/base = ..()
	var/image/cape_backing = image(icon, null, cape_backing_state, human ? human.layer - 0.01 : MOB_LAYER - 0.01)
	base.add_overlay(cape_backing)
	return base

/obj/item/clothing/accessory/poncho/dominia_cape/strelitz
	name = "house strelitz cape"
	desc = "This is a cape in the style of Dominian nobility. This one is in the colours of House Strelitz."
	icon_state = "strelitz_cape"
	item_state = "strelitz_cape"

/obj/item/clothing/accessory/poncho/dominia_cape/strelitz/white
	name = "white house strelitz cape"
	icon_state = "strelitz_capew"
	item_state = "strelitz_capew"
	cape_backing_state = "capew_backing"

/obj/item/clothing/accessory/poncho/dominia_cape/volvalaad
	name = "house volvalaad cape"
	desc = "This is a cape in the style of Dominian nobility. This one is in the colours of House Volvalaad."
	icon_state = "volvalaad_cape"
	item_state = "volvalaad_cape"

/obj/item/clothing/accessory/poncho/dominia_cape/volvalaad/white
	name = "white house volvalaad cape"
	icon_state = "volvalaad_capew"
	item_state = "volvalaad_capew"
	cape_backing_state = "capew_backing"

/obj/item/clothing/accessory/poncho/dominia_cape/kazhkz
	name = "house kazhkz cape"
	desc = "This is a cape in the style of Dominian nobility. This one is in the colours of House Kazhkz."
	icon_state = "kazhkz_cape"
	item_state = "kazhkz_cape"

/obj/item/clothing/accessory/poncho/dominia_cape/kazhkz/white
	name = "white house kazhkz cape"
	icon_state = "kazhkz_capew"
	item_state = "kazhkz_capew"
	cape_backing_state = "capew_backing"

/obj/item/clothing/accessory/poncho/dominia_cape/caladius
	name = "house caladius cape"
	desc = "This is a cape in the style of Dominian nobility. This one is in the colours of House Caladius."
	icon_state = "caladius_cape"
	item_state = "caladius_cape"

/obj/item/clothing/accessory/poncho/dominia_cape/caladius/white
	name = "white house caladius cape"
	icon_state = "caladius_capew"
	item_state = "caladius_capew"
	cape_backing_state = "capew_backing"

/obj/item/clothing/accessory/poncho/dominia_cape/zhao
	name = "house zhao cape"
	desc = "This is a cape in the style of Dominian nobility. This one is in the colours of House Zhao."
	icon_state = "zhao_cape"
	item_state = "zhao_cape"

/obj/item/clothing/accessory/poncho/dominia_cape/zhao/white
	name = "white house zhao cape"
	icon_state = "zhao_capew"
	item_state = "zhao_capew"
	cape_backing_state = "capew_backing"

/obj/item/clothing/suit/storage/dominia/consular
	name = "Dominian consular officer's greatcoat"
	desc = "A Dominian greatcoat issued to members of His Majesty's Diplomatic Service, designed in the typical Dominian fashion."
	desc_extended = "His Majesty's Diplomatic Service - as with much of the Empire tends to be dominated by the great houses, though \
	the Service also employs many commoners - as long as they can pass the rigorous examinations required to become a full member."
	icon = 'icons/clothing/suits/coats/dominia_consular_coat.dmi'
	icon_state = "dominia_consular_coat"
	item_state = "dominia_consular_coat"

/obj/item/clothing/suit/storage/toggle/dominia
	name = "dominia great coat"
	desc = "This is a great coat in the style of Dominia nobility. It's the latest fashion across Dominian space."
	icon = 'icons/clothing/suits/coats/dominia_noble_red.dmi'
	icon_state = "dominia_noble_red"
	item_state = "dominia_noble_red"
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/toggle/dominia/gold
	icon = 'icons/clothing/suits/coats/dominia_noble_gold.dmi'
	icon_state = "dominia_noble_gold"
	item_state = "dominia_noble_gold"

/obj/item/clothing/suit/storage/toggle/dominia/black
	icon = 'icons/clothing/suits/coats/dominia_noble_black.dmi'
	icon_state = "dominia_noble_black"
	item_state = "dominia_noble_black"

/obj/item/clothing/suit/storage/toggle/dominia/bomber
	name = "fisanduhian bomber jacket"
	desc = "A bomber jacket based off of styles created by Fisanduhian refugees. The double-breasted design works well for insulating \
	heat, or concealing a small pistol."
	desc_extended = "Fisanduhian fashion remains as rugged and steadfast as its people, as well as very distinctive from the usual Morozi fashions \
	sourced from Moroz proper. Bomber jackets such as these were also frequently seen worn by members of the Fisanduh Freedom Front and came \
	to be seen as an enduring symbol of their struggle for liberty."
	icon = 'icons/clothing/suits/coats/dominia_bomber.dmi'
	icon_state = "dominia_bomber"
	item_state = "dominia_bomber"

/obj/item/clothing/suit/storage/toggle/dominia/bomber/long
	name = "long fisanduhian bomber jacket"
	desc = "A long bomber jacket based off of styles created by Fisanduhian refugees. The double-breasted design works well for insulating \
	heat, or concealing a small pistol."
	icon_state = "dominia_bomber_long"
	item_state = "dominia_bomber_long"

/obj/item/clothing/under/dominia
	contained_sprite = TRUE

/obj/item/clothing/under/dominia/imperial_suit
	name = "dominian suit"
	desc = "This is a suit in the style of Dominia nobility. It's the latest fashion across Dominian space."
	icon = 'icons/clothing/under/uniforms/dominia_suits.dmi'
	icon_state = "suit_imperial"
	item_state = "suit_imperial"
	var/house

/obj/item/clothing/under/dominia/imperial_suit/Initialize()
	. = ..()
	if(house)
		icon_state = "suit_[house]"
		item_state = "suit_[house]"
		initial_icon_override = icon_state

/obj/item/clothing/under/dominia/imperial_suit/strelitz
	name = "house strelitz suit"
	house = "strelitz"

/obj/item/clothing/under/dominia/imperial_suit/volvalaad
	name = "house volvalaad suit"
	house = "volvalaad"

/obj/item/clothing/under/dominia/imperial_suit/kazhkz
	name = "house kazhkz suit"
	house = "kazhkz"

/obj/item/clothing/under/dominia/imperial_suit/caladius
	name = "house caladius suit"
	house = "caladius"

/obj/item/clothing/under/dominia/imperial_suit/zhao
	name = "house zhao suit"
	house = "zhao"

/obj/item/clothing/under/dominia/imperial_suit/black
	icon_state = "suit_imperial_black"
	item_state = "suit_imperial_black"

/obj/item/clothing/under/dominia/sweater
	name = "fisanduhian sweater"
	desc = "This is a sweater of Fisanduhian style. Practical and utilitarian."
	desc_extended = "Fisanduhian fashion remains as rugged and steadfast as its people, as well as very distinctive from the usual Morozi fashions \
	sourced from Moroz proper. Sweaters such as this were a common sight in the region of Fisanduh, being comfortable to wear and very useful \
	in the cold mountainous environment they lived in. It tends to be seen as something rather basic and droll by Imperials when compared \
	to their more extravagant and colorful attire, but this suits the Confederates just fine."
	icon = 'icons/clothing/under/uniforms/dominia_sweater.dmi'
	icon_state = "dom_sweater"
	item_state = "dom_sweater"

/obj/item/clothing/under/dominia/lyodsuit
	name = "lyodsuit"
	desc = "An imitation Lyodsuit from Dominia. It's lightweight, and high has quality fabric that makes it extremely comfortable to wear."
	desc_extended = "This Lyodsuit was created in Dominia. It is fashionable amongst the middle and lower classes of Dominia."
	icon = 'icons/clothing/under/uniforms/lyodsuit.dmi'
	icon_state = "dom_thermal"
	item_state = "dom_thermal"
	contained_sprite = TRUE

/obj/item/clothing/under/dominia/lyodsuit/hoodie
	name = "hoodied lyodsuit"
	desc = "An imitation Lyodsuit from Dominia. It's lightweight, and high has quality fabric that makes it extremely comfortable to wear. This one has a hood mask attached."
	icon = 'icons/clothing/under/uniforms/lyodsuit_hoodie.dmi'
	icon_state = "dom_thermal_hoodie"
	item_state = "dom_thermal_hoodie"
	action_button_name = "Toggle Lyodsuit Mask"
	var/obj/item/clothing/mask/breath/lyodsuit/mask
	var/hood_raised = FALSE

/obj/item/clothing/under/dominia/lyodsuit/hoodie/Initialize()
	. = ..()
	create_mask()
	verbs += /obj/item/clothing/under/dominia/lyodsuit/hoodie/proc/toggle_mask

/obj/item/clothing/under/dominia/lyodsuit/hoodie/Destroy()
	QDEL_NULL(mask)
	return ..()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/dropped()
	remove_mask()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/on_slotmove()
	remove_mask()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/attack_self(mob/user)
	..()
	if(equip_slot == slot_w_uniform)
		toggle_mask()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/equipped(mob/user, slot)
	if(slot != slot_w_uniform)
		remove_mask()
	..()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/proc/create_mask()
	if(!mask)
		mask = new /obj/item/clothing/mask/breath/lyodsuit(src)

/obj/item/clothing/under/dominia/lyodsuit/hoodie/proc/remove_mask()
	// Mask got nuked. Probably because of RIGs or the like.
	create_mask()

	if(ishuman(mask.loc))
		var/mob/living/carbon/H = mask.loc
		H.unEquip(mask, 1)
		item_state = initial(item_state)
		H.update_inv_w_uniform()
	mask.forceMove(src)
	hood_raised = FALSE

/obj/item/clothing/under/dominia/lyodsuit/hoodie/proc/toggle_mask()
	set name = "Toggle Lyodsuit Mask"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return FALSE

	// double check to make sure the lyodsuit has its mask
	create_mask()

	if(!hood_raised)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.w_uniform != src)
				to_chat(H, SPAN_WARNING("You must be wearing \the [src] to put up the hood!"))
				return
			if(H.wear_mask)
				to_chat(H, SPAN_WARNING("You're already wearing something on your head!"))
				return
			else
				H.equip_to_slot_if_possible(mask, slot_wear_mask, 0, 0, 1)
				hood_raised = TRUE
				H.update_inv_wear_mask()
				item_state = "dom_thermal"
	else
		remove_mask()
	usr.update_action_buttons()
	update_clothing_icon()

/obj/item/clothing/under/dominia/lyodsuit/hoodie/rollsuit()
	..()
	if(rolled_down == TRUE)
		remove_mask()

/obj/item/clothing/under/dominia/dress
	name = "dominian noble greatdress"
	desc = "This is a greatdress in the style of Dominian nobility. Greatdresses are a Dominian fashion fad, distinguished from normal dresses by their colourful palettes \
			and oversized gowns. More modest nobility would define them as excessively gaudy and unreasonable, but it depends on the individual."
	icon = 'icons/clothing/under/uniforms/dominia_noble_dress.dmi'
	icon_state = "dom_dress"
	item_state = "dom_dress"
	contained_sprite = TRUE

/obj/item/clothing/under/dominia/dress/summer
	name = "dominian noble dress"
	desc = "A dress worn by Dominian nobility. This is the most commonly seen variant. While not as gaudy as the greatdress, this dress is luxurious nonetheless."
	icon = 'icons/clothing/under/uniforms/dominia_summer_dress.dmi'
	icon_state = "altdress_imperial"
	item_state = "altdress_imperial"
	var/house
	var/black = FALSE

/obj/item/clothing/under/dominia/dress/summer/Initialize()
	. = ..()
	if(house)
		icon_state = "altdress_[house]"
		item_state = "altdress_[house]"
	if(black)
		icon_state += "b"
		item_state += "b"

/obj/item/clothing/under/dominia/dress/summer/strelitz
	name = "strelitz noble dress"
	house = "strelitz"

/obj/item/clothing/under/dominia/dress/summer/volvalaad
	name = "volvalaad noble dress"
	house = "volvalaad"

/obj/item/clothing/under/dominia/dress/summer/kazhkz
	name = "kazhkz noble dress"
	house = "kazhkz"

/obj/item/clothing/under/dominia/dress/summer/caladius
	name = "caladius noble dress"
	house = "caladius"

/obj/item/clothing/under/dominia/dress/summer/zhao
	name = "zhao noble dress"
	house = "zhao"

/obj/item/clothing/under/dominia/dress/summer/black
	name = "black dominian noble dress"
	black = TRUE

/obj/item/clothing/under/dominia/dress/summer/black/strelitz
	name = "black strelitz noble dress"
	house = "strelitz"

/obj/item/clothing/under/dominia/dress/summer/black/volvalaad
	name = "black volvalaad noble dress"
	house = "volvalaad"

/obj/item/clothing/under/dominia/dress/summer/black/kazhkz
	name = "black kazhkz noble dress"
	house = "kazhkz"

/obj/item/clothing/under/dominia/dress/summer/black/caladius
	name = "black caladius noble dress"
	house = "caladius"

/obj/item/clothing/under/dominia/dress/summer/black/zhao
	name = "black zhao noble dress"
	house = "zhao"

/obj/item/clothing/accessory/poncho/dominia/red/surcoat
	name = "tribunalist surcoat"
	desc = "A simple red surcoat commonly worn by Dominian clergy members."
	desc_extended = "Spun with rough but hardy fabrics from the Dominian frontier, this surcoat is commonly worn by poorer Tribunal clergy as well as missionaries\
	seeking protection from the elements. This garment was popularized by the Kael'kah sect and remains respected as a symbol of humility and poverty amongst priests."
	icon = 'icons/clothing/suits/capes/dominia_surcoat.dmi'
	icon_state = "dominian_surcoat"
	item_state = "dominian_surcoat"
	overlay_state = "dominian_surcoat"
	icon_override = null

/obj/item/clothing/accessory/poncho/dominia/red/double
	name = "tribunalist's full cape"
	desc = "This is a large cape in the style of Dominian clergy. The symbol of 'The Eye' of the Tribunal is present on both the front and the back."
	desc_extended = "This style of cape is among the most flashy and ornate of the Tribunal's garb. Its weight and impracticality of use means that \
	it is often only worn by clergy of high station and on special occasions. Lower ranking members of the Tribunal or those who wear it frequently \
	are often frowned upon as arrogant and vain."
	icon = 'icons/clothing/suits/capes/dominia_doublecape.dmi'
	icon_state = "dominian_doublecape"
	item_state = "dominian_doublecape"
	overlay_state = "dominian_doublecape"
	icon_override = null

/obj/item/clothing/accessory/poncho/dominia/red
	name = "tribunalist cape"
	desc = "This is a cape in the style of Dominian clergy. The red differentiates the clergy from the nobility who wear traditionally black capes."
	desc_extended = "Dominian priests and priestesses are traditionally expected to wear red or golden clothing when discharging \
	their duties. Capes are worn as both a fashion statement to attract the attention of crowds and as a simple form of protection\
	against the elements."
	icon = 'icons/clothing/suits/capes/dominia_red.dmi'
	icon_state = "dominian_cape_red"
	item_state = "dominian_cape_red"
	overlay_state = "dominian_cape_red"
	contained_sprite = TRUE
	icon_override = null
	var/rolled = FALSE

/obj/item/clothing/accessory/poncho/dominia/red/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wear_suit()
	get_mob_overlay(TRUE)
	get_inv_overlay(TRUE)

/obj/item/clothing/accessory/poncho/dominia/red/verb/roll_up_mantle()
	set name = "Roll Up Cape Mantle"
	set desc = "Roll up your cape's mantle. Doesn't work with some capes."
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return FALSE

	var/list/icon_states = icon_states(icon)
	var/initial_state = initial(icon_state)
	var/new_state = "[initial_state]_h"
	if(!(new_state in icon_states))
		to_chat(usr, SPAN_WARNING("Your cape doesn't allow this!"))
		return

	rolled = !rolled
	to_chat(usr, SPAN_NOTICE("You roll your cape's mantle [rolled ? "up" : "down"]."))
	icon_state = rolled ? new_state : initial_state
	item_state = rolled ? new_state : initial_state
	overlay_state = rolled ? new_state : initial_state
	update_icon()
	update_clothing_icon()

/obj/item/clothing/accessory/poncho/dominia/consular
	name = "tribunalist consular's cape"
	desc = "A truly majestic gold and red cape worn by members of the clergy affiliated with His Majesty's Diplomatic Service."
	desc_extended = "His Majesty's Diplomatic Service - as with much of the Empire tends to be dominated by the great houses, though the Service also \
	employs may commoners - as long as they can pass the rigorous examinations required to become a full member of the Diplomatic Service."
	icon = 'icons/clothing/suits/capes/dominia_consular_cape.dmi'
	icon_state = "dominia_cape_consular"
	item_state = "dominia_cape_consular"
	overlay_state = "dominia_cape_consular"
	contained_sprite = TRUE
	icon_override = null
	var/rolled = FALSE

/obj/item/clothing/under/dominia/consular
	name = "dominian consular officer's uniform"
	desc = "The traditional red-black-gold uniform of a member of His Majesty's Diplomatic Service."
	desc_extended = "His Majesty's Diplomatic Service - as with much of the Empire tends to be dominated by the great houses, though the Service also employs many \
	commoners - as long as they can pass the rigorous examinations required to become a full member of the Diplomatic Service."
	icon = 'icons/clothing/under/uniforms/dominia_consular.dmi'
	icon_state = "dominia_consular"
	item_state = "dominia_consular"

/obj/item/clothing/under/dominia/consular/dress
	name = "dominian consular officer's uniform"
	desc = "The traditional red-black-gold uniform of a member of His Majesty's Diplomatic Service. This variant has a skirt, for the female diplomat on the go."
	icon = 'icons/clothing/under/uniforms/dominia_consular.dmi'
	icon_state = "dominia_consular_fem"
	item_state = "dominia_consular_fem"

/obj/item/clothing/under/dominia/initiate
	name = "tribunal initiate's robe"
	desc = "A simple white robe with red trim and a red sash to fasten it. It's commonly worn by initiates of the Moroz Holy Tribunal."
	desc_extended = "While the most obvious purpose of an initiate's red-and-white robe is to show that the hopeful clergy member is pure in mind and body, \
	the stark whites of the robe also show when an initiate has neglected their appearance. The white robes must be constantly maintained and washed in order to \
	maintain their pristine appearance, lest an initiate be found neglectful."
	icon = 'icons/clothing/under/uniforms/dominia_initiate.dmi'
	icon_state = "dominia_initiate"
	item_state = "dominia_initiate"
	slot_flags = SLOT_OCLOTHING | SLOT_ICLOTHING

/obj/item/clothing/under/dominia/priest
	name = "tribunalist's robe"
	desc = "A high-quality robe woven in black fabric with a golden trim with a red sash to fasten it. It's commonly worn by priests of the Moroz Holy Tribunal."
	desc_extended = "The black and gold robes of Imperial priests and priestesses have been deliberately designed by House Caladius to resemble the coats commonly \
	worn by Dominian nobility, in order to demonstrate the importance of Dominia's priestly classes. Each robe is tailor-made to fit an initiate upon their \
	successful ascension to full member of the clergy, and they are expected to care for their robes throughout their lives. The loss of one's robe is \
	considered a major embarrassment both for the individual and their church."
	icon = 'icons/clothing/under/uniforms/dominia_priest.dmi'
	icon_state = "dominia_priest"
	item_state = "dominia_priest"
	slot_flags = SLOT_OCLOTHING | SLOT_ICLOTHING

/obj/item/clothing/under/dominia/priest/consular
	name = "tribunalist consular's uniform"
	desc = "The traditional red-black-gold uniform of a priestly member of His Majesty's Diplomatic Service."
	desc_extended = "His Majesty's Diplomatic Service - as with much of the Empire tends to be dominated by the great houses, though the Service also employs many commoners \
	- as long as they can pass the rigorous examinations required to become a full member of the Diplomatic Service."
	icon = 'icons/clothing/under/uniforms/dominia_consular_priest.dmi'
	icon_state = "dominia_consular_priest"
	item_state = "dominia_consular_priest"
	slot_flags = SLOT_OCLOTHING | SLOT_ICLOTHING

/obj/item/clothing/head/dominia
	name = "dominian consular officer's dress cap"
	desc = "A quite fashionable cap issued to the members of His Majesty's Diplomatic Service."
	desc_extended = "His Majesty's Diplomatic Service - as with much of the Empire tends to be dominated by the great houses, though the Service also employs many \
    commoners - as long as they can pass the rigorous examinations required to become a full member of the Diplomatic Service."
	icon = 'icons/clothing/head/dominia_consular_cap.dmi'
	icon_state = "dominia_consular_cap"
	item_state = "dominia_consular_cap"
	contained_sprite = TRUE

/obj/item/clothing/head/beret/dominia
	name = "tribunal initiate's beret"
	desc = "A simple red beret with a golden badge marking its wearer as an initiate of the Moroz Holy Tribunal."
	desc_extended = "While initiates dress humbly in white and red clothing, this does not mean that House Caladius - the primary source of the Holy Tribunal's \
	funding - spares any expenses funding them, and these berets are made of luxurious velvet."
	icon = 'icons/clothing/head/dominia_beret.dmi'
	icon_state = "dominia_beret"
	item_state = "dominia_beret"

/obj/item/clothing/head/beret/dominia/medical
	name = "tribunalist medical beret"
	desc = "A white-and-green beret bearing the sigil of the Moroz Holy Tribunal on its front. Worn by those medical workers affiliated with the Moroz Holy Tribunal."
	desc_extended = "Unlike the black and gold clothing of their priestly counterparts, the medical staff of the Moroz Holy Tribunal's temples are generally clad in white and green due to typically not being full members of the clergy. Occasionally, if a doctor is dedicated enough, they will be granted the right to wear the beret of a full Tribunal priest. This beret features an emblem of the eye made of green and white cloth."
	icon = 'icons/clothing/head/dominia_beret_hospital.dmi'
	icon_state = "dominia_beret_hospital"
	item_state = "dominia_beret_hospital"

/obj/item/clothing/head/beret/dominia/priest
	name = "tribunalist's beret"
	desc = "A black beret bearing the sigil of the Moroz Holy Tribunal on its front. Worn by full members of the Tribunal's clergy."
	desc_extended = "With their black and gold clothing designed to resemble that of their noble counterparts, the full clergy of the Moroz Holy Tribunal \
	are a sight to behold both inside and outside of the Empire of Dominia. This beret features an emblem luxuriously and painstakingly crafted out of real gold."
	icon = 'icons/clothing/head/dominia_beret_priest.dmi'
	icon_state = "dominia_beret_priest"
	item_state = "dominia_beret_priest"

/obj/item/clothing/head/beret/dominia/priest/red
	name = "tribunalist's beret"
	desc = "A red beret bearing the sigil of the Moroz Holy Tribunal on its front. Worn by full members of the Tribunal's clergy."
	desc_extended = "With their red and gold clothing designed to resemble that of their noble counterparts, the full clergy of the Moroz Holy Tribunal \
	are a sight to behold both inside and outside of the Empire of Dominia. This beret features an emblem luxuriously and painstakingly crafted out of real gold."
	icon = 'icons/clothing/head/dominia_beret_priest.dmi'
	icon_state = "dominia_beret_priest_red"
	item_state = "dominia_beret_priest_red"

/obj/item/clothing/head/beret/dominia/consular
	name = "tribunalist's beret"
	desc = "A beret in gold and red worn by members of the clergy affiliated with His Majesty's Diplomatic Service."
	desc_extended = "His Majesty's Diplomatic Service - as with much of the Empire tends to be dominated by the great houses, though the Service also employs may commoners - \
	as long as they can pass the rigorous examinations required to become a full member of the Diplomatic Service."
	icon = 'icons/clothing/head/dominia_beret_consular.dmi'
	icon_state = "dominia_beret_consular_priest"
	item_state = "dominia_beret_consular_priest"

/obj/item/clothing/accessory/dominia
	name = "tribunal necklace"
	desc = "An amulet depicting 'The Eye', a prominent symbol of the Moroz Holy Tribunal worn by its clergy and layfolk alike."
	desc_extended = "One of the most prominent symbols of the Moroz Holy Tribunal is 'The Eye', with the square representing the four corners of the universe and the central 'eye' being the \
	Tribunal that watches all. Necklaces and amulets made from this symbol often have the eye being able to rotate. Although there is no official stance, others argue that necklaces should be made \
	from bare metal to represent how the Tribunal sees the unvarnished truth, while others insist that they must be made from gold to glorify the religion."
	icon = 'icons/clothing/accessories/dominia_amulet.dmi'
	item_state = "dominia_amulet"
	icon_state = "dominia_amulet"
	contained_sprite = TRUE

/obj/item/clothing/head/ushanka/dominia
	name = "fisanduhian ushanka"
	desc = "A warm fur hat with ear flaps that can be raised and tied to be out of the way. This one has a large Fisanduhian flag on the front."
	desc_extended = "Fisanduhian fashion remains as rugged and steadfast as its people, as well as very distinctive from the usual Morozi fashions \
	sourced from Moroz proper. Ushankas such as these are still a common sight in the semi-autonomous region of Fisanduh, flag and all. Much to \
	the ire of Moroz's Imperials."
	icon_state = "fishushanka"
	item_state = "fishushanka"

/obj/item/clothing/under/dominia/dress/fancy
	name = "Morozi dress"
	desc = "Feminine commoner's fashion from the Empire of Dominia."
	desc_extended = "Dresses such as this one are a common sight in the more developed colonies of the Empire of Dominia, and their origins can be traced back to \
	the fashion houses of Nova Luxembourg. While both sleeved and sleeveless variants exist, the sleeved one is far more common \
	due to the often frigid temperatures of Moroz."
	icon = 'icons/clothing/under/uniforms/dominia_dresses.dmi'
	icon_state = "dress_imperial"
	item_state = "dress_imperial"
	contained_sprite = TRUE
	var/house

/obj/item/clothing/under/dominia/dress/fancy/Initialize()
	. = ..()
	if(house)
		desc = "Feminine commoner's fashion from the Empire of Dominia. This particular variant has a colored sash marking its wearer as \
				an affiliate of House [capitalize(house)]."
		icon_state = "dress_[house]"
		item_state = "dress_[house]"
		initial_icon_override = icon_state
		update_clothing_icon()

/obj/item/clothing/under/dominia/dress/fancy/zhao
	name = "house zhao Morozi dress"
	house = "zhao"

/obj/item/clothing/under/dominia/dress/fancy/volvalaad
	name = "house volvalaad Morozi dress"
	house = "volvalaad"
/obj/item/clothing/under/dominia/dress/fancy/strelitz
	name = "house strelitz Morozi dress"
	house = "strelitz"

/obj/item/clothing/under/dominia/dress/fancy/caladius
	name = "house caladius Morozi dress"
	house = "caladius"

/obj/item/clothing/under/dominia/dress/fancy/kazhkz
	name = "house kazhkz Morozi dress"
	house = "kazhkz"

/obj/item/clothing/under/dominia/fleet
	name = "fleet voidsman uniform"
	desc = "The uniform of an enlisted sailor of the Imperial Fleet."
	desc_extended = "The kerchief of a Fleet voidsman varies from battlefleet to battlefleet, \
		and its color indicates where the rating originated from. This particular uniform comes from the elite 1st battlefleet, \
		which is under the command of Grand Admiral Huiling Zhao herself."
	icon = 'icons/clothing/under/uniforms/dominia_fleet.dmi'
	icon_state = "voidsman"
	item_state = "voidsman"
	contained_sprite = TRUE

/obj/item/clothing/under/dominia/fleet/officer
	name = "fleet officer uniform"
	desc = "An Imperial Fleet uniform belonging to an Ensign - a junior officer generally in command of a small ship."
	desc_extended = "The junior officers ranks of the Imperial Fleet are often as high as most Ma'zals rise, \
		and are often looked down upon by their higher-ranking and typically noble superiors."
	icon_state = "officer"
	item_state = "officer"
	build_from_parts = TRUE
	worn_overlay = "cord"

/obj/item/clothing/under/dominia/fleet/armsman
	name = "fleet armsman uniform"
	desc = "A no-nonsense uniform worn by Imperial Fleet armsmen."
	desc_extended = "Imperial Fleet armsmen are generally drawn from the Imperial Army and this uniform \
		has intentionally been designed to resemble that of the Army. Armsmen note it comes in two sizes: too large or too small."
	icon_state = "armsman"
	item_state = "armsman"
	build_from_parts = TRUE
	worn_overlay = "collar"

/obj/item/clothing/head/dominia/fleet
	name = "fleet voidsman duty cover"
	desc = "A garrison cap commonly worn by enlisted sailors of the Imperial Fleet."
	desc_extended = "Deliberately modest compared to their Officer counterparts, enlisted voidsmen's caps \
		typically display their vessel of origin on the right side of the cap. \
		These caps can easily be rolled and stored in the likely event other forms of headwear are required."
	icon = 'icons/clothing/under/uniforms/dominia_fleet.dmi'
	icon_state = "voidsmancap"
	item_state = "voidsmancap"
	contained_sprite = TRUE

/obj/item/clothing/head/dominia/fleet/officer
	name = "fleet officer peaked cap"
	desc = "A junior officer's peaked cap. The Grand Admiral's initials - HZ - are stamped on its badge."
	desc_extended = "The peaked cap of the Imperial Fleet is one of its most enduring symbols. \
		Noble officers will generally wear an additional badge on the cap indicating their house of origin."
	icon_state = "officercap"
	item_state = "officercap"

/obj/item/clothing/head/dominia/fleet/armsman
	name = "fleet armsman duty cover"
	desc = "A standard issue cap issued to Imperial Fleet armsmen."
	desc_extended = "The duty cover of Fleet armsmen is deliberately meant to resemble the same hat worn by Imperial Army enlisted. \
		Like its Army counterpart it lacks the second button found on officer's caps which indicates one's noble house of origin."
	icon_state = "armsmancap"
	item_state = "armsmancap"

/obj/item/clothing/suit/storage/dominia/fleet
	name = "fleet officer overcoat"
	desc = "An Imperial Fleet coat belonging to an officer. The single golden band around its wrist indicates it belongs to an Ensign."
	desc_extended = "Imperial Fleet officer's coats are both a symbol of rank and of social status, \
		and proudly bear the wearer's rank by the number of golden bands around their sleeves."
	icon = 'icons/clothing/under/uniforms/dominia_fleet.dmi'
	icon_state = "officercoat"
	item_state = "officercoat"
	contained_sprite = TRUE
