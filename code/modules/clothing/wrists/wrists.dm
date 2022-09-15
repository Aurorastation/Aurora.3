
/obj/item/clothing/wrists
	name = "wrists"
	w_class = ITEMSIZE_TINY
	icon = 'icons/obj/item/clothing/wrists.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/clothing/lefthand_wrists.dmi',
		slot_r_hand_str = 'icons/mob/items/clothing/righthand_wrists.dmi'
		)
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/wrist.dmi'
	)
	slot_flags = SLOT_WRISTS
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	siemens_coefficient = 1.0
	var/flipped = 0
	var/normal_layer = TRUE

/obj/item/clothing/wrists/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wrists()

/obj/item/clothing/wrists/Initialize()
	. = ..()
	update_flip_verb()

/obj/item/clothing/wrists/proc/update_flip_verb()
	if((gender != PLURAL) && (flipped != -1)) // Check for plurality and whether it has a flipped icon.
		verbs += /obj/item/clothing/wrists/watch/proc/swapwrists

/obj/item/clothing/wrists/watch/proc/swapwrists()
	set category = "Object"
	set name = "Flip Wristwear"
	set src in usr

	if(use_check_and_message(usr))
		return 0

	flipped = !flipped
	if(("[initial(icon_state)]_flip") in icon_states(icon))
		icon_state = "[initial(item_state)][flipped ? "_flip" : ""]"
	item_state = "[initial(item_state)][flipped ? "_flip" : ""]"
	to_chat(usr, "You change \the [src] to be on your [src.flipped ? "left" : "right"] wrist.")
	if(equip_sound)
		playsound(src, equip_sound, EQUIP_SOUND_VOLUME)
	else
		playsound(src, drop_sound, DROP_SOUND_VOLUME)
	update_clothing_icon()

/obj/item/clothing/wrists/proc/change_layer()
	set category = "Object"
	set name = "Change Wrist Layer"
	set src in usr

	normal_layer = !normal_layer
	to_chat(usr, SPAN_NOTICE("\The [src] will now layer [normal_layer ? "under" : "over"] your outerwear."))
	update_clothing_icon()

/obj/item/clothing/wrists/bracelet
	name = "bracelet"
	desc = "Made out of some synthetic polymer. Management encourages you to not ask questions."
	icon_state = "bracelet"
	item_state = "bracelet"

/obj/item/clothing/wrists/beaded
	name = "beaded bracelet"
	desc = "Made from loose beads with a center hole and connected by a piece of string or elastic band through said holes."
	icon_state = "beaded"
	item_state = "beaded"

/obj/item/clothing/wrists/slap
	name = "slap bracelet"
	desc = "Banned in schools! Popular with children and in poorly managed corporate events!"
	equip_sound = 'sound/effects/snap.ogg'
	icon_state = "slap"
	item_state = "slap"

/obj/item/clothing/wrists/armchain
	name = "cobalt arm chains"
	desc = "A set of luxurious chains intended to be wrapped around long, lanky arms. They don't seem particularly comfortable. They're encrusted with cobalt-blue gems, and made of <b>REAL</b> faux gold."
	icon_state = "cobalt_armchains"
	item_state = "cobalt_armchains"
	gender = PLURAL
	flipped = -1

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
	flipped = -1

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
