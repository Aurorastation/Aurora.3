//Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/storage/hooded
	var/obj/item/clothing/head/winterhood/hood
	var/hoodtype = null
	var/suittoggled = 0
	var/hooded = 0

/obj/item/clothing/suit/storage/hooded/Initialize()
	. = ..()
	MakeHood()

/obj/item/clothing/suit/storage/hooded/Destroy()
	QDEL_NULL(hood)
	return ..()

/obj/item/clothing/suit/storage/hooded/proc/MakeHood()
	if(!hood)
		hood = new hoodtype(src)

/obj/item/clothing/suit/storage/hooded/equipped(mob/user, slot)
	if(slot != slot_wear_suit)
		RemoveHood()
	..()

/obj/item/clothing/suit/storage/hooded/proc/RemoveHood()
	icon_state = initial(icon_state)
	item_state = initial(item_state)
	suittoggled = 0

	// Hood got nuked. Probably because of RIGs or the like.
	if (!hood)
		MakeHood()
		return

	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.unEquip(hood, 1)
		H.update_inv_wear_suit()
	hood.forceMove(src)

/obj/item/clothing/suit/storage/hooded/dropped()
	RemoveHood()

/obj/item/clothing/suit/storage/hooded/on_slotmove()
	RemoveHood()

/obj/item/clothing/suit/storage/hooded/verb/ToggleHood()

	set name = "Toggle Coat Hood"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return 0

	if(!suittoggled)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, "<span class='warning'>You must be wearing [src] to put up the hood!</span>")
				return
			if(H.head)
				to_chat(H, "<span class='warning'>You're already wearing something on your head!</span>")
				return
			else
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
				suittoggled = 1
				icon_state = "[initial(icon_state)]_t"
				item_state = "[initial(item_state)]_t"
				H.update_inv_wear_suit()
	else
		RemoveHood()


//hoodies and the like

/obj/item/clothing/suit/storage/hooded/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from animal furs."
	icon = 'icons/obj/hoodies.dmi'
	icon_state = "coatwinter"
	item_state = "coatwinter"
	contained_sprite = 1
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	siemens_coefficient = 0.75
	hooded = 1
	hoodtype = /obj/item/clothing/head/winterhood

/obj/item/clothing/head/winterhood
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon = 'icons/obj/hoodies.dmi'
	icon_state = "generic_hood"
	body_parts_covered = HEAD
	cold_protection = HEAD
	siemens_coefficient = 0.75
	flags_inv = HIDEEARS | BLOCKHAIR | HIDEEARS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	canremove = 0

/obj/item/clothing/suit/storage/hooded/wintercoat/red
	name = "red winter coat"
	icon_state = "coatred"
	item_state = "coatred"

/obj/item/clothing/suit/storage/hooded/wintercoat/captain
	name = "captain's winter coat"
	icon_state = "coatcaptain"
	item_state = "coatcaptain"

/obj/item/clothing/suit/storage/hooded/wintercoat/security
	name = "security winter coat"
	icon_state = "coatsecurity"
	item_state = "coatsecurity"
	armor = list(melee = 25, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/medical
	name = "medical winter coat"
	icon_state = "coatmedical"
	item_state = "coatmedical"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/science
	name = "science winter coat"
	icon_state = "coatscience"
	item_state = "coatscience"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	name = "engineering winter coat"
	icon_state = "coatengineer"
	item_state = "coatengineer"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	name = "atmospherics winter coat"
	icon_state = "coatatmos"
	item_state = "coatatmos"

/obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	name = "hydroponics winter coat"
	icon_state = "coathydro"
	item_state = "coathydro"

/obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	name = "cargo winter coat"
	icon_state = "coatcargo"
	item_state = "coatcargo"

/obj/item/clothing/suit/storage/hooded/wintercoat/miner
	name = "mining winter coat"
	icon_state = "coatminer"
	item_state = "coatminer"

/obj/item/clothing/suit/storage/hooded/wintercoat/corgi
	name = "corgi costume"
	desc = "A corgi costume made of legit corgi hide."
	icon_state = "corgi"
	item_state = "corgi"
	flags_inv = HIDEJUMPSUIT
	hoodtype = /obj/item/clothing/head/winterhood/corgi

/obj/item/clothing/head/winterhood/corgi
	name = "corgi hood"
	desc = "A hood attached to a corgi costume."
	icon_state = "corgi_helm"

/obj/item/clothing/suit/storage/hooded/wintercoat/carp
	name = "space carp costume"
	desc = "A costume made from 'synthetic' carp scales."
	icon_state = "carp"
	item_state = "carp"
	flags_inv = HIDEJUMPSUIT
	hoodtype = /obj/item/clothing/head/winterhood/carp

/obj/item/clothing/head/winterhood/carp
	name = "space carp hood"
	desc = "A hood attached to a space carp costume."
	icon_state = "carp_helm"

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie
	name = "hoodie"
	desc = "Warm and cozy."
	icon_state = "hoodie"
	var/icon_open = "hoodie_open"
	var/icon_closed = "hoodie"
	item_state = "hoodie"
	hoodtype = /obj/item/clothing/head/winterhood/hoodie

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/RemoveHood()
	..()
	icon_open = initial(icon_open)
	icon_closed = initial(icon_closed)

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/verb/Toggle() //copied from storage toggle
	set name = "Toggle Coat Buttons"
	set category = "Object"
	set src in usr
	if(use_check_and_message(usr))
		return 0
	if(icon_state == icon_open)
		icon_state = icon_closed
		item_state = icon_closed
		to_chat(usr, "You zip the hoodie.")
	else if(icon_state == icon_closed)
		icon_state = icon_open
		item_state = icon_open
		to_chat(usr, "You unzip the hoodie.")
	else
		to_chat(usr, "You attempt to zip the velcro on your [src], before promptly realising how silly you are.")
		return
	update_clothing_icon()

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/ToggleHood()
	set name ="Toggle Coat Hood"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return 0

	if(!suittoggled)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, "<span class='warning'>You must be wearing [src] to put up the hood!</span>")
				return
			if(H.head)
				to_chat(H, "<span class='warning'>You're already wearing something on your head!</span>")
				return
			else
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
				suittoggled = 1
				icon_open = "[initial(icon_open)]_t" // this is where the change is.
				icon_closed = "[initial(icon_closed)]_t"
				icon_state = "[initial(icon_state)]_t"
				item_state = "[initial(item_state)]_t"
				H.update_inv_wear_suit()
	else
		RemoveHood()

/obj/item/clothing/head/winterhood/hoodie
	name = "hood"
	desc = "A hood attached to a warm hoodie."
	icon_state = "hoodie_hood"

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/grey //legacy item. for raiders, shuttle spawn
	color = "#777777"
