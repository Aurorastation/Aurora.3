
/obj/item/clothing/wrists
	name = "wrists"
	w_class = ITEMSIZE_TINY
	icon = 'icons/obj/clothing/wrists.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/clothing/lefthand_wrists.dmi',
		slot_r_hand_str = 'icons/mob/items/clothing/righthand_wrists.dmi'
		)
	slot_flags = SLOT_WRISTS
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	siemens_coefficient = 1.0

/obj/item/clothing/wrists/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wrists()

/obj/item/clothing/wrists/Initialize()
	..()
	update_flip_verb()

/obj/item/clothing/wrists/proc/update_flip_verb()
	if((gender != PLURAL) && (("[initial(icon_state)]_alt") in icon_states(icon))) // Check for plurality and whether it has a flipped icon.
		verbs += /obj/item/clothing/wrists/watch/verb/swapwrists

/obj/item/clothing/wrists/watch/verb/swapwrists()
	set category = "Object"
	set name = "Flip Wristwear"
	set src in usr

	if(use_check_and_message(usr))
		return 0

	flipped = !flipped
	icon_state = "[initial(icon_state)][flipped ? "_alt" : ""]"
	item_state = icon_state
	to_chat(usr, "You change \the [src] to be on your [src.flipped ? "left" : "right"] wrist.")
	update_clothing_icon()

/obj/item/clothing/wrists/bracelet
	name = "bracelet"
	desc = "Made out of some synthetic polymer, management encourages you to not ask questions."
	icon_state = "bracelet"
	item_state = "bracelet"

/obj/item/clothing/wrists/armchain
	name = "cobalt arm chains"
	desc = "A set of luxurious chains intended to be wrapped around long, lanky arms. They don't seem particularly comfortable. They're encrusted with cobalt-blue gems, and made of <b>REAL</b> faux gold."
	icon_state = "cobalt_armchains"
	item_state = "cobalt_armchains"
	gender = PLURAL

/obj/item/clothing/wrists/armchain/emerald
	name = "emerald arm chains"
	desc = "A set of luxurious chains intended to be wrapped around long, lanky arms. They don't seem particularly comfortable. They're encrusted with emerald-green gems, and made of <b>REAL</b> faux gold."
	icon_state = "emerald_armchains"
	item_state = "emerald_armchains"

/obj/item/clothing/wrists/armchain/ruby
	name = "ruby arm chains"
	desc = "A set of luxurious chains intended to be wrapped around long, lanky arms. They don't seem particularly comfortable. They're encrusted with ruby-red gems, and made of <b>REAL</b> faux gold."
	icon_state = "ruby_armchains"
	item_state = "ruby_armchains"

/obj/item/clothing/wrists/goldbracer
	name = "cobalt bracers"
	desc = "A pair of sturdy and thick decorative bracers, seeming better for fashion than protection. They're encrusted with cobalt-blue gems, and made of <b>REAL</b> faux gold."
	icon_state = "cobalt_bracers"
	item_state = "cobalt_bracers"
	gender = PLURAL

/obj/item/clothing/wrists/goldbracer/emerald
	name = "emerald bracers"
	desc = "A pair of sturdy and thick decorative bracers, seeming better for fashion than protection. They're encrusted with emerald-green gems, and made of <b>REAL</b> faux gold."
	icon_state = "emerald_bracers"
	item_state = "emerald_bracers"

/obj/item/clothing/wrists/goldbracer/ruby
	name = "ruby bracers"
	desc = "A pair of sturdy and thick decorative bracers, seeming better for fashion than protection. They're encrusted with ruby-red gems, and made of <b>REAL</b> faux gold."
	icon_state = "ruby_bracers"
	item_state = "ruby_bracers"
