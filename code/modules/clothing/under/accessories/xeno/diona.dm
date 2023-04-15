/obj/item/clothing/accessory/badge/passcard/sol_diona
	name = "Dionae Passcard"
	desc = "A passcard issued to Dionae citizens of the Alliance of Sovereign Solarian Nations who have cleared their assigned contract. "
	desc_extended = "A passcard is a modern evolution of the state-issued identification card, with all the functionality of a driver's license, birth certificate, passport, or other document, \
	updated as necessary or able by a central government. The concept was pioneered in the early days of the Sol Alliance, and continues in most human stellar nations to this day, owing to the availability \
	and price of consumer plastics and self-powered microholograms."
	icon_state = "passcard_sol_dionae"
	item_state = "passcard_sol_dionae"
	contained_sprite = TRUE
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE
	badge_string = null

	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'
	
/obj/item/clothing/accessory/poncho/eumponcho
	name = "adorned poncho"
	desc = "A poncho made of some sort of mesh weave material adorned by a piece of colored fabric wrapped around it."
	icon = 'icons/obj/diona_items.dmi'
	icon_state = "eumponcho"
	item_state = "eumponcho"
	icon_override = null
	contained_sprite = TRUE
	var/additional_color = COLOR_GRAY

/obj/item/clothing/accessory/poncho/eumponcho/update_icon()
	cut_overlays()
	var/image/gem = image(icon, null, "eumponcho_gem")
	gem.appearance_flags = RESET_COLOR
	gem.color = additional_color
	add_overlay(gem)
	var/image/chain = image(icon, null, "eumponcho_chain")
	chain.appearance_flags = RESET_COLOR
	add_overlay(chain)

/obj/item/clothing/accessory/poncho/eumponcho/get_mob_overlay(var/mob/living/carbon/human/H, var/mob_icon, var/mob_state, var/slot)
	var/image/I = ..()
	if(slot == slot_wear_suit_str)
		var/image/gem = image(mob_icon, null, "eumponcho_un_gem")
		gem.appearance_flags = RESET_COLOR
		gem.color = additional_color
		I.add_overlay(gem)
		var/image/chain = image(mob_icon, null, "eumponcho_un_chain")
		chain.appearance_flags = RESET_COLOR
		I.add_overlay(chain)
	return I

/obj/item/clothing/accessory/poncho/eumponcho/get_accessory_mob_overlay(mob/living/carbon/human/H, force)
	var/image/base = ..()
	var/image/gem = image(icon, null, "eumponcho_un_gem")
	gem.appearance_flags = RESET_COLOR
	gem.color = additional_color
	base.add_overlay(gem)
	var/image/chain = image(icon, null, "eumponcho_un_chain")
	chain.appearance_flags = RESET_COLOR
	base.add_overlay(chain)
	return base
