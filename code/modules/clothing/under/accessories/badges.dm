/*
	Badges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on holobadges with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/badge
	name = "detective's badge"
	desc = "A corporate security badge, made from gold and set on false leather."
	icon_state = "badge"
	item_state = "marshalbadge"
	slot_flags = SLOT_BELT | SLOT_TIE

	var/stored_name
	var/badge_string = "Corporate Security"

/obj/item/clothing/accessory/badge/press
	name = "corporate press pass"
	desc = "A corporate reporter's pass, emblazoned with the NanoTrasen logo."
	icon_state = "pressbadge"
	item_state = "pbadge"
	badge_string = "Corporate Reporter"

/obj/item/clothing/accessory/badge/press/independent
	name = "press pass"
	desc = "A freelance journalist's pass."
	icon_state = "pressbadge-i"
	badge_string = "Freelance Journalist"

/obj/item/clothing/accessory/badge/old
	name = "faded badge"
	desc = "A faded security badge, backed with leather."
	icon_state = "badge_round"

/obj/item/clothing/accessory/badge/proc/set_name(var/new_name)
	stored_name = new_name
	name = "[initial(name)] ([stored_name])"

/obj/item/clothing/accessory/badge/attack_self(mob/user as mob)

	if(!stored_name)
		to_chat(user, "You inspect your [src.name]. Everything seems to be in order and you give it a quick cleaning with your hand.")
		set_name(user.real_name)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")

/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='danger'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")

//.Holobadges.
/obj/item/clothing/accessory/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as a member of corporate security."
	icon_state = "holobadge"
	item_state = "holobadge"
	var/emagged //Emagging removes Sec check.

/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE | SLOT_OCLOTHING

/obj/item/clothing/accessory/badge/holo/attack_self(mob/user as mob)
	if(!stored_name)
		to_chat(user, "Waving around a holobadge before swiping an ID would be pretty pointless.")
		return
	return ..()

/obj/item/clothing/accessory/badge/holo/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, "<span class='danger'>\The [src] is already cracked.</span>")
		return
	else
		emagged = 1
		to_chat(user, "<span class='danger'>You crack the holobadge security checks.</span>")
		return 1

/obj/item/clothing/accessory/badge/holo/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/device/pda))

		var/obj/item/weapon/card/id/id_card = null

		if(istype(O, /obj/item/weapon/card/id))
			id_card = O
		else
			var/obj/item/device/pda/pda = O
			id_card = pda.id

		if(access_security in id_card.access || emagged)
			to_chat(user, "You imprint your ID details onto the badge.")
			set_name(user.real_name)
		else
			to_chat(user, "[src] rejects your insufficient access rights.")
		return
	..()

/obj/item/weapon/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	New()
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		..()
		return


/obj/item/clothing/accessory/badge/warden
	name = "warden's badge"
	desc = "A silver corporate security badge. Stamped with the words 'Brig Officer.'"
	icon_state = "silverbadge"
	slot_flags = SLOT_TIE


/obj/item/clothing/accessory/badge/hos
	name = "commander's badge"
	desc = "An immaculately polished gold security badge. Labeled 'Commander.'"
	icon_state = "goldbadge"
	slot_flags = SLOT_TIE


//Contractor IDs

/obj/item/clothing/accessory/badge/contractor
	name = "Necropolis Industries ID"
	desc = "An old-fashioned, practical plastic card. Smells faintly of gunpowder."
	icon_state = "necro_card"
	item_state = "necro_card"
	icon_override = 'icons/mob/ties.dmi'
	badge_string = "Necropolis Industries"	//Will be the contractor's 'position.'
	slot_flags = SLOT_TIE
	slot = "over"

/obj/item/clothing/accessory/badge/contractor/attack_self(mob/user as mob)
	if(!isliving(user))
		return
	if(!stored_name)
		set_name(user.real_name)
		to_chat(user, "You inspect your [src.name]. Everything seems to be in order and you give it a quick cleaning with your hand.")
		return
	user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")

/obj/item/clothing/accessory/badge/contractor/necrosec
	name = "Necropolis Industries Security ID"
	desc = "An old-fashioned, practical plastic card. This one is of a higher rank, for Security personnel."
	icon_state = "necrosec_card"
	item_state = "necrosec_card"
	badge_string = "Necropolis Industries Security"

/obj/item/clothing/accessory/badge/contractor/einstein
	name = "Einstein Engines ID"
	desc = "A stylized plastic card, belonging to one of the many specialists at EE.."
	icon_state = "einstein_card"
	item_state = "einstein_card"
	badge_string = "Einstein Engines"

/obj/item/clothing/accessory/badge/contractor/hephaestus
	name = "Hephaestus Industries ID"
	desc = "A metal-backed card, belonging to the powerful Hephaestus Industries."
	icon_state = "heph_card"
	item_state = "heph_card"
	badge_string = "Hephaestus Industries"

/obj/item/clothing/accessory/badge/contractor/zenghu
	name = "Zeng-Hu Pharmaceuticals ID"
	desc = "A synthleather card, belonging to one of the highly skilled members of Zeng-Hu."
	icon_state = "zhu_card"
	item_state = "zhu_card"
	badge_string = "Zeng-Hu Pharmaceuticals"

/obj/item/clothing/accessory/badge/contractor/eridani
	name = "Eridani Corporate Federation ID"
	desc = "A high tech holobadge, designed to project information about an Eridanian Private Military Contractor."
	icon_state = "erisec_card"
	item_state = "erisec_card"
	badge_string = "Eridani Corporate Federation"

/obj/item/clothing/accessory/badge/contractor/idris
	name = "Idris Incorporated ID"
	desc = "A high tech holocard, designed to project information about a civilian worker at Idris."
	icon_state = "idris_card"
	item_state = "idris_card"
	badge_string = "Idris Incorporated"

/obj/item/clothing/accessory/badge/contractor/idrissec
	name = "Idris Security ID"
	desc = "A high tech holobadge, designed to project information about Security personnel at Idris."
	icon_state = "idrissec_card"
	item_state = "idrissec_card"
	badge_string = "Idris Security"

/obj/item/clothing/accessory/badge/contractor/iru
	name = "Idris Reclamation Unit ID"
	desc = "A high tech holobadge, designed to project information about an asset reclamation synthetic at Idris."
	icon_state = "iru_card"
	item_state = "iru_card"
	badge_string = "Idris Reclamation Unit"