//Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/storage/hooded
	var/opened = FALSE
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/hoodie.dmi'
	)
	var/hoodtype = /obj/item/clothing/head/winterhood

/obj/item/clothing/suit/storage/hooded/Initialize()
	. = ..()
	new hoodtype(src)

/obj/item/clothing/suit/storage/hooded/update_icon(var/hooded = FALSE)
	SEND_SIGNAL(src, COMSIG_ITEM_STATE_CHECK, args)
	icon_state = "[initial(icon_state)][opened ? "_open" : ""][hooded ? "_t" : ""]"
	item_state = icon_state
	. = ..()
	if(usr)
		usr.update_inv_wear_suit()

/obj/item/clothing/suit/storage/hooded/verb/ToggleHood()
	set name = "Toggle Coat Hood"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr))
		return 0

	SEND_SIGNAL(src, COMSIG_ITEM_UPDATE_STATE)
	update_icon()

//hoodies and the like

/obj/item/clothing/suit/storage/hooded/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from animal furs."
	icon = 'icons/obj/clothing/hoodies.dmi'
	icon_state = "coatwinter"
	item_state = "coatwinter"
	contained_sprite = TRUE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(
		bio = ARMOR_BIO_MINOR
	)
	siemens_coefficient = 0.75

/obj/item/clothing/head/winterhood
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon = 'icons/obj/clothing/hoodies.dmi'
	icon_state = "coatwinter_hood"
	contained_sprite = TRUE
	body_parts_covered = HEAD
	cold_protection = HEAD
	siemens_coefficient = 0.75
	flags_inv = HIDEEARS | BLOCKHAIR | HIDEEARS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	canremove = 0
	var/hooded = FALSE

/obj/item/clothing/head/winterhood/Initialize(mapload, material_key)
	. = ..()
	if(isclothing(loc))
		RegisterSignal(loc, COMSIG_ITEM_REMOVE, PROC_REF(RemoveHood))
		RegisterSignal(loc, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum, Destroy))
		RegisterSignal(loc, COMSIG_ITEM_STATE_CHECK, PROC_REF(hooded))
		RegisterSignal(loc, COMSIG_ITEM_UPDATE_STATE, PROC_REF(change_hood))
		RegisterSignal(loc, COMSIG_ITEM_ICON_UPDATE, TYPE_PROC_REF(/atom, update_icon))
		color = loc.color
		icon_state = "[loc.icon_state]_hood"
		item_state = "[loc.icon_state]_hood"

/obj/item/clothing/head/winterhood/update_icon(mob/user)
	. = ..()
	if(isclothing(loc))
		color = loc.color
		icon_state = "[loc.icon_state]_hood"
		item_state = "[loc.icon_state]_hood"

/obj/item/clothing/head/winterhood/proc/hooded(var/hood, list/arguments)
	arguments[1] = hooded

/obj/item/clothing/head/winterhood/proc/change_hood(var/parent)
	if(!hooded)
		if(CheckSlot(parent))
			var/mob/living/carbon/human/H = get_human(parent)
			hooded = TRUE
			update_icon(H)
			H.equip_to_slot_if_possible(src,slot_head,0,0,1)
			usr.visible_message(SPAN_NOTICE("[usr] pulls up the hood on \the [src]."))
	else
		RemoveHood(parent)
		usr.visible_message(SPAN_NOTICE("[usr] pulls down the hood on \the [src]."))

/obj/item/clothing/head/winterhood/proc/RemoveHood(var/parent)
	if(ishuman(loc))
		var/mob/living/carbon/H = loc
		H.unEquip(src, 1)
		forceMove(parent)
		update_icon(H)
		hooded = FALSE

/obj/item/clothing/head/winterhood/proc/get_human(var/obj/parent)
	var/mob/living/carbon/human/H
	if(isclothing(parent.loc))
		if(ishuman(parent.loc.loc))
			H = parent.loc.loc
	else if(ishuman(parent.loc))
		H = parent.loc
	return H

/obj/item/clothing/head/winterhood/proc/CheckSlot(var/parent)
	var/mob/living/carbon/human/H = get_human(parent)
	var/obj/base_item = loc
	if(isclothing(loc.loc))
		base_item = loc.loc

	if(H)
		if(H.wear_suit != base_item && H.w_uniform != base_item)
			to_chat(H, SPAN_WARNING("You must be wearing [base_item] to put up the hood!"))
			return FALSE
		else if(H.head)
			to_chat(H, SPAN_WARNING("You're already wearing something on your head!"))
			return FALSE
		else
			return TRUE
	return FALSE

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
	name = "operations winter coat"
	icon_state = "coatcargo"
	item_state = "coatcargo"

/obj/item/clothing/suit/storage/hooded/wintercoat/miner
	name = "mining winter coat"
	icon_state = "coatminer"
	item_state = "coatminer"

/obj/item/clothing/suit/storage/hooded/wintercoat/idris
	name = "idris winter coat"
	icon_state = "coatidris"
	item_state = "coatidris"

/obj/item/clothing/suit/storage/hooded/wintercoat/idris/alt
	icon_state = "coatidris_alt"
	item_state = "coatidris_alt"

/obj/item/clothing/suit/storage/hooded/wintercoat/zavod
	name = "zavodskoi winter coat"
	icon_state = "coatzavod"
	item_state = "coatzavod"

/obj/item/clothing/suit/storage/hooded/wintercoat/zavod/alt
	icon_state = "coatzavod_alt"
	item_state = "coatzavod_alt"

/obj/item/clothing/suit/storage/hooded/wintercoat/pmc
	name = "pmcg winter coat"
	icon_state = "coatpmc"
	item_state = "coatpmc"

/obj/item/clothing/suit/storage/hooded/wintercoat/pmc/alt
	name = "epmc winter coat"
	icon_state = "coatepmc"
	item_state = "coatepmc"

/obj/item/clothing/suit/storage/hooded/wintercoat/heph
	name = "hephaestus winter coat"
	icon_state = "coatheph"
	item_state = "coatheph"

/obj/item/clothing/suit/storage/hooded/wintercoat/heph/alt
	icon_state = "coatheph_alt"
	item_state = "coatheph_alt"

/obj/item/clothing/suit/storage/hooded/wintercoat/nt
	name = "nanotrasen winter coat"
	icon_state = "coatnt"
	item_state = "coatnt"

/obj/item/clothing/suit/storage/hooded/wintercoat/nt/alt
	icon_state = "coatnt_alt"
	item_state = "coatnt_alt"

/obj/item/clothing/suit/storage/hooded/wintercoat/zeng
	name = "zeng-hu winter coat"
	icon_state = "coatzeng"
	item_state = "coatzeng"

/obj/item/clothing/suit/storage/hooded/wintercoat/zeng/alt
	icon_state = "coatzeng_alt"
	item_state = "coatzeng_alt"

/obj/item/clothing/suit/storage/hooded/wintercoat/orion
	name = "orion winter coat"
	icon_state = "coatorion"
	item_state = "coatorion"

/obj/item/clothing/suit/storage/hooded/wintercoat/orion/alt
	icon_state = "coatorion_alt"
	item_state = "coatorion_alt"

/obj/item/clothing/suit/storage/hooded/wintercoat/scc
	name = "scc winter coat"
	icon_state = "coatscc"
	item_state = "coatscc"

/obj/item/clothing/suit/storage/hooded/wintercoat/scc/alt
	icon_state = "coatscc_alt"
	item_state = "coatscc_alt"

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
	update_icon()
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

/obj/item/clothing/suit/storage/hooded/wintercoat/konyang
	name = "konyang village coat"
	desc = "A highly prized hooded coat with unmatched breathability and insulation. Imported from Konyang, this garment is made with a weave derived from the feathers of indigenous birds."
	icon_state = "konyang_village"
	item_state = "konyang_village"
	hoodtype = /obj/item/clothing/head/winterhood/konyang

/obj/item/clothing/head/winterhood/konyang
	name = "konyang village hood"
	desc = "A light, waterproof hood attached to a Konyanger coat."

/obj/item/clothing/suit/storage/hooded/wintercoat/mars
	name = "martian hoodie"
	desc = "An orange hoodie jacket featuring the face of Warrant Officer August 'Gus' Maldarth, typically worn as a symbol of both solidarity with Mars, and a sign of protest against the Sol Alliance government. \
	Strangely, Maldarth seems to be mispelled as 'Maldrath' on this garment. Additionally, #GusticeForGus can be seen written on the back. It seems to have typeface issues."
	desc_extended = "In November 2462, the planet of Mars was devastated by a phoron explosion widely believed to be\
	caused by experiments the Solarian government was conducting on the planet. As a result, an earlier whistleblower,\
	Gus Maldarth was regarded as a martyr after being silenced by operatives allegedly working on the behalf of Sol."
	icon_state = "hoodie_mars"
	item_state = "hoodie_mars"

/obj/item/clothing/suit/storage/hooded/wintercoat/colorable
	icon_state = "coatwinter_w"
	item_state = "coatwinter_w"
	build_from_parts = TRUE
	hoodtype = /obj/item/clothing/head/winterhood/colorable
	worn_overlay = "collar"

/obj/item/clothing/head/winterhood/colorable
	icon_state = "coatwinter_w_hood"
	build_from_parts = TRUE
	worn_overlay = "collar"

/obj/item/clothing/head/winterhood/colorable/update_icon(mob/user)
	. = ..()

