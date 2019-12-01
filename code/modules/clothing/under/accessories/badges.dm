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
	overlay_state = "marshalbadge"
	slot_flags = SLOT_BELT | SLOT_TIE

	var/stored_name
	var/badge_string = "Corporate Security"
	var/v_flippable = 1

	drop_sound = 'sound/items/drop/ring.ogg'

/obj/item/clothing/accessory/badge/press
	name = "corporate press pass"
	desc = "A corporate reporter's pass, emblazoned with the NanoTrasen logo."
	icon_state = "pressbadge"
	item_state = "pbadge"
	overlay_state = "pbadge"
	badge_string = "Corporate Reporter"
	w_class = 1

	drop_sound = 'sound/items/drop/rubber.ogg'

/obj/item/clothing/accessory/badge/press/independent
	name = "press pass"
	desc = "A freelance journalist's pass."
	icon_state = "pressbadge-i"
	badge_string = "Freelance Journalist"

/obj/item/clothing/accessory/badge/press/plastic
	name = "plastic press pass"
	desc = "A journalist's 'pass' shaped, for whatever reason, like a security badge. It is made of plastic."
	icon_state = "pbadge"
	badge_string = "Sicurity Journelist"
	w_class = 2

/obj/item/clothing/accessory/badge/old
	name = "faded badge"
	desc = "A faded security badge, backed with leather."
	icon_state = "badge_round"
	overlay_state = "badge_round"

/obj/item/clothing/accessory/badge/proc/set_name(var/new_name)
	stored_name = new_name
	name = "[name] ([stored_name])"

/obj/item/clothing/accessory/badge/attack_self(mob/user as mob)

	if(!stored_name)
		to_chat(user, "You inspect your [src.name]. Everything seems to be in order and you give it a quick cleaning with your hand.")
		set_name(user.real_name)
		return

	if(isliving(user))
		if(badge_string)
			if(stored_name)
				user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
			else
				user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")
		else
			if(stored_name)
				user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name].</span>")
			else
				user.visible_message("<span class='notice'>[user] displays their [src.name].</span>","<span class='notice'>You display your [src.name].</span>")

/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='danger'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")

/obj/item/clothing/accessory/badge/verb/flip_side()
	set category = "Object"
	set name = "Flip badge"
	set src in usr

	if (use_check_and_message(usr))
		return
	if (!v_flippable)
		to_chat(usr, "You cannot flip \the [src] as it is not a flippable item.")
		return

	src.flipped = !src.flipped
	if(src.flipped)
		if(!overlay_state)
			src.icon_state = "[icon_state]_flip"
		else
			src.overlay_state = "[overlay_state]_flip"
	else
		if(!overlay_state)
			src.icon_state = initial(icon_state)
		else
			src.overlay_state = initial(overlay_state)
	to_chat(usr, "You change \the [src] to be on your [src.flipped ? "right" : "left"] side.")
	update_clothing_icon()
	src.inv_overlay = null
	src.mob_overlay = null

//.Holobadges.
/obj/item/clothing/accessory/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as a member of corporate security."
	icon_state = "holobadge"
	item_state = "holobadge"
	overlay_state = "holobadge"
	var/emagged //Emagging removes Sec check.

	drop_sound = 'sound/items/drop/rubber.ogg'

/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	overlay_state = null
	slot_flags = SLOT_MASK | SLOT_TIE

	drop_sound = 'sound/items/drop/ring.ogg'

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
	if(istype(O, /obj/item/card/id) || istype(O, /obj/item/device/pda))

		var/obj/item/card/id/id_card = null

		if(istype(O, /obj/item/card/id))
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

/obj/item/clothing/accessory/badge/warden
	name = "warden's badge"
	desc = "A silver corporate security badge. Stamped with the words 'Brig Officer.'"
	icon_state = "silverbadge"
	overlay_state = "silverbadge"
	slot_flags = SLOT_TIE


/obj/item/clothing/accessory/badge/hos
	name = "commander's badge"
	desc = "An immaculately polished gold security badge. Labeled 'Commander.'"
	icon_state = "goldbadge"
	overlay_state = "goldbadge"
	slot_flags = SLOT_TIE

/obj/item/clothing/accessory/badge/sol_visa
	name = "\improper ASSN visa recommendation slip"
	desc = "A compact piece of legal paperwork that can replace the enormous amounts of documents required to obtain a Sol Alliance visa."
	icon_state = "sol-visa"
	overlay_state = "sol-visa"
	slot_flags = SLOT_TIE
	badge_string = "Priority ASSN Visa Applicant"

	drop_sound = 'sound/items/drop/card.ogg'

/obj/item/clothing/accessory/badge/tcfl_papers
	name = "\improper TCFL enlistment"
	desc = "A compact piece of legal paperwork, making one an official recruit of the Tau Ceti Foreign Legion. Go Biesel!"
	icon_state = "tc-visa"
	overlay_state = "tc-visa"
	slot_flags = SLOT_TIE
	badge_string = "Tau Ceti Foreign Legion Recruit"

	drop_sound = 'sound/items/drop/card.ogg'

/obj/item/clothing/accessory/badge/hadii_card
	name = "honorary party member card"
	desc = "A card denoting a honorary member of the Hadiist party."
	icon_state = "hadii-id"
	overlay_state = "hadii-id"
	slot_flags = SLOT_TIE
	badge_string = "Honorary Member of Party of the Free Tajara under the Leadership of Hadii"
	description_fluff = "The Party of the Free Tajara under the Leadership of Hadii is the only and ruling party in the PRA, with its leader always being the elected president. \
	They follow Hadiism as their main ideology, with the objective of securing the tajaran freedom and place in the galactic community. Membership of the Hadiist Party is not open. \
	For anyone to become a member, they must be approved by a committee that will consider their qualifications and past. Goverment officials can grant honorary memberships, this is \
	seem as nothing but a honor and does not grant any status or position that a regular Party member would have."
	w_class = 1

	drop_sound = 'sound/items/drop/card.ogg'

/obj/item/clothing/accessory/badge/sheriff
	name = "sheriff badge"
	desc = "A star-shaped brass badge denoting who the law is around these parts."
	icon_state = "sheriff"
	overlay_state = "sheriff"
	badge_string = "County Sheriff"

/obj/item/clothing/accessory/badge/marshal
	name = "marshal badge"
	desc = "A hefty gold-plated badge which tells you who's in charge."
	icon_state = "marshalbadge"
	badge_string = "Federal Marshal"

/obj/item/clothing/accessory/badge/dia
	name = "\improper DIA badge"
	desc = "This badge marks the holder of an investigative agent."
	icon_state = "diabadge"
	overlay_state = "diabadge"
	badge_string = "Corporate Investigator"

/obj/item/clothing/accessory/badge/idbadge
	name = "\improper ID badge"
	desc = "A descriptive identification badge with the holder's credentials."
	icon_state = "solbadge"
	overlay_state = "solbadge"
	badge_string = null
	w_class = 1

/obj/item/clothing/accessory/badge/idbadge/nt
	name = "\improper NT ID badge"
	desc = "A descriptive identification badge with the holder's credentials. This one has red marks with the NanoTrasen logo on it."
	icon_state = "ntbadge"
	overlay_state = "ntbadge"
	badge_string = null

/obj/item/clothing/accessory/badge/idbadge/intel
	name = "electronic ID badge"
	desc = "A descriptive identification badge with the holder's credentials displayed with a harsh digital glow."
	icon_state = "intelbadge"
	overlay_state = "intelbadge"
	badge_string = null