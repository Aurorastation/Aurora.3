//Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/storage/hooded
	var/obj/item/clothing/head/winterhood/hood
	var/hoodtype = null
	var/suittoggled = FALSE
	var/opened = FALSE

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
	suittoggled = FALSE
	icon_state = "[initial(icon_state)][opened ? "_open" : ""][suittoggled ? "_t" : ""]"
	item_state = icon_state
	// Hood got nuked. Probably because of RIGs or the like.
	if(!hood)
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
				suittoggled = TRUE
				icon_state = "[initial(icon_state)][opened ? "_open" : ""]"
				 //spawn appropriate hood.
				CreateHood()
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
				H.update_inv_wear_suit()
	else
		RemoveHood()

/obj/item/clothing/suit/storage/hooded/proc/CreateHood()
	hood.color = src.color
	hood.icon_state = "[icon_state]_hood"
	hood.item_state = "[icon_state]_hood"
	icon_state = "[icon_state][suittoggled ? "_t" : ""]"
	item_state = icon_state

//hoodies and the like

/obj/item/clothing/suit/storage/hooded/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from animal furs."
	icon = 'icons/obj/hoodies.dmi'
	icon_state = "coatwinter"
	item_state = "coatwinter"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	siemens_coefficient = 0.75
	hoodtype = /obj/item/clothing/head/winterhood

/obj/item/clothing/head/winterhood
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon = 'icons/obj/hoodies.dmi'
	icon_state = "coatwinter_hood"
	contained_sprite = TRUE
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

/obj/item/clothing/suit/storage/hooded/wintercoat/medical
	name = "medical winter coat"
	icon_state = "coatmedical"
	item_state = "coatmedical"

/obj/item/clothing/suit/storage/hooded/wintercoat/iac
	name = "IAC winter coat"
	icon_state = "coatIAC"
	item_state = "coatIAC"

/obj/item/clothing/suit/storage/hooded/wintercoat/science
	name = "science winter coat"
	icon_state = "coatscience"
	item_state = "coatscience"

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	name = "engineering winter coat"
	icon_state = "coatengineer"
	item_state = "coatengineer"

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

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie
	name = "hoodie"
	desc = "Warm and cozy."
	icon_state = "hoodie"
	item_state = "hoodie"
	hoodtype = /obj/item/clothing/head/winterhood/hoodie

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/verb/Toggle()
	set name = "Toggle Coat Zipper"
	set category = "Object"
	set src in usr
	if(use_check_and_message(usr))
		return 0
	opened = !opened
	to_chat(usr, "You [opened ? "unzip" : "zip"] \the [src].")
	playsound(src, 'sound/items/zip.ogg', EQUIP_SOUND_VOLUME, TRUE)
	icon_state = "[initial(icon_state)][opened ? "_open" : ""]"
	item_state = icon_state
	if(suittoggled)
		CreateHood() //rebuild the hood with open/closed version
	update_clothing_icon()
	usr.update_inv_head()

/obj/item/clothing/head/winterhood/hoodie
	name = "hood"
	desc = "A hood attached to a warm hoodie."

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/random/Initialize()
	. = ..()
	color = get_random_colour(lower = 150)

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/short
	icon_state = "hoodie_short"
	item_state = "hoodie_short"

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/crop
	icon_state = "hoodie_crop"
	item_state = "hoodie_crop"

/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/sleeveless
	icon_state = "hoodie_sleeveless"
	item_state = "hoodie_sleeveless"
