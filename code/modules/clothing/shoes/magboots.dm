/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear."
	name = "magboots"
	icon = 'icons/obj/item/clothing/shoes/magboots.dmi'
	icon_state = "magboots0"
	item_state = "magboots0"
	contained_sprite = TRUE
	center_of_mass = list("x" = 17,"y" = 12)
	species_restricted = null
	force = 11
	overshoes = 1
	item_flags = ITEM_FLAG_THICK_MATERIAL|ITEM_FLAG_AIRTIGHT|ITEM_FLAG_INJECTION_PORT
	var/magpulse = 0
	var/icon_base = "magboots"
	var/slowdown_active = 3
	action_button_name = "Toggle Magboots"
	var/obj/item/clothing/shoes/shoes = null	//Undershoes
	var/mob/living/carbon/human/wearer = null	//For shoe procs
	drop_sound = 'sound/items/drop/toolbox.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

/obj/item/clothing/shoes/magboots/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/state = "disabled"
	if(item_flags & ITEM_FLAG_NO_SLIP)
		state = "enabled"
	. += "Its mag-pulse traction system appears to be [state]."

/obj/item/clothing/shoes/magboots/Destroy()
	. = ..()
	src.shoes = null
	src.wearer = null

/obj/item/clothing/shoes/magboots/proc/set_slowdown(mob/user)
	slowdown = shoes? max(0, shoes.slowdown): 0	//So you can't put on magboots to make you walk faster.
	if(magpulse)
		slowdown += slowdown_active
	user.update_equipment_speed_mods()

/obj/item/clothing/shoes/magboots/proc/update_wearer()
	if(QDELETED(wearer))
		return

	var/mob/living/carbon/human/H = wearer
	if(shoes && istype(H))
		if(!H.equip_to_slot_if_possible(shoes, slot_shoes))
			shoes.forceMove(get_turf(src))
		src.shoes = null
	wearer.update_floating()
	wearer = null

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		item_flags &= ~ITEM_FLAG_NO_SLIP
		magpulse = 0
		set_slowdown(user)
		force = 3
		if(icon_base)
			icon_state = "[icon_base]0"
			item_state = icon_state
		to_chat(user, "You disable the mag-pulse traction system.")
	else
		item_flags |= ITEM_FLAG_NO_SLIP
		magpulse = 1
		set_slowdown(user)
		force = 11
		if(icon_base)
			icon_state = "[icon_base]1"
			item_state = icon_state
		playsound(get_turf(src), 'sound/effects/magnetclamp.ogg', 20)
		to_chat(user, "You enable the mag-pulse traction system.")
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_action_buttons()
	user.update_floating()

/obj/item/clothing/shoes/magboots/negates_gravity()
	if(magpulse)
		return 1
	else
		return 0

/obj/item/clothing/shoes/magboots/mob_can_equip(mob/user, slot, disable_warning = FALSE)
	if(slot != slot_shoes)
		return ..()

	var/mob/living/carbon/human/H = user
	if(H.shoes)
		shoes = H.shoes
		if(shoes.overshoes)
			to_chat(user, "You are unable to wear \the [src] as \the [H.shoes] are in the way.")
			shoes = null
			return 0
		H.drop_from_inventory(shoes,src)	//Remove the old shoes so you can put on the magboots.

	if(!..())
		if(shoes) 	//Put the old shoes back on if the check fails.
			if(H.equip_to_slot_if_possible(shoes, slot_shoes))
				src.shoes = null
		return 0

	if (shoes)
		to_chat(user, "You slip \the [src] on over \the [shoes].")
	set_slowdown(user)
	wearer = H
	return 1

/obj/item/clothing/shoes/magboots/dropped()
	..()
	INVOKE_ASYNC(src, PROC_REF(update_wearer))

/obj/item/clothing/shoes/magboots/mob_can_unequip()
	. = ..()
	if (.)
		INVOKE_ASYNC(src, PROC_REF(update_wearer))

/obj/item/clothing/shoes/magboots/hegemony
	name = "hegemony magboots"
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear. This variant is frequently seen in the Hegemony Navy."
	icon_state = "hegemony_magboots0"
	item_state = "hegemony_magboots"
	icon_base = "hegemony_magboots"

/obj/item/clothing/shoes/magboots/advance
	desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer."
	name = "advanced magboots"
	icon_state = "advmag0"
	item_state = "advmag0"
	icon_base = "advmag"
	slowdown_active = 0

/obj/item/clothing/shoes/magboots/syndie
	desc = "Reverse-engineered magnetic boots that have a heavy magnetic pull. Manufactured in the United Syndicates of Himeo."
	name = "blood-red magboots"
	icon_state = "syndiemag0"
	item_state = "syndiemag0"
	icon_base = "syndiemag"
