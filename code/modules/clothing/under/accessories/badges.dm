/*
	Badges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on holobadges with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/badge
	name = "badge"
	desc = "A corporate security badge, made from gold and set on false leather."
	icon_state = "badge"
	item_state = "marshalbadge"
	overlay_state = "marshalbadge"
	slot_flags = SLOT_BELT | SLOT_TIE

	var/stored_name
	var/badge_string = "Corporate Security"
	var/v_flippable = 1

	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

/obj/item/clothing/accessory/badge/press
	name = "corporate press pass"
	desc = "A corporate reporter's pass, emblazoned with the NanoTrasen logo."
	icon_state = "pressbadge"
	item_state = "pbadge"
	overlay_state = "pbadge"
	badge_string = "Corporate Reporter"
	w_class = ITEMSIZE_TINY

	drop_sound = 'sound/items/drop/rubber.ogg'
	pickup_sound = 'sound/items/pickup/rubber.ogg'

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
	w_class = ITEMSIZE_SMALL

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

/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	overlay_state = null
	slot_flags = SLOT_MASK | SLOT_TIE

	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'

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
	if(O.GetID())

		var/obj/item/card/id/id_card = O.GetID()

		if(!istype(id_card))
			return

		if(access_security in id_card.access || emagged)
			to_chat(user, "You imprint your ID details onto the badge.")
			set_name(user.real_name)
		else
			to_chat(user, "[src] rejects your insufficient access rights.")
		return
	..()

/obj/item/clothing/accessory/badge/officer
	name = "officer's badge"
	desc = "A bronze corporate security badge. Stamped with the words 'Security Officer.'"
	icon_state = "bronzebadge"
	overlay_state = "bronzebadge"
	slot_flags = SLOT_TIE

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
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/clothing/accessory/badge/tcfl_papers
	name = "\improper TCFL enlistment"
	desc = "A compact piece of legal paperwork, making one an official recruit of the Tau Ceti Foreign Legion. Go Biesel!"
	icon_state = "tc-visa"
	overlay_state = "tc-visa"
	slot_flags = SLOT_TIE
	badge_string = "Tau Ceti Foreign Legion Recruit"

	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

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
	desc = "This badge marks the holder as an investigative agent."
	icon_state = "diabadge"
	overlay_state = "diabadge"
	badge_string = "Corporate Investigator"

/obj/item/clothing/accessory/badge/idbadge
	name = "\improper ID badge"
	desc = "A descriptive identification badge with the holder's credentials."
	icon_state = "solbadge"
	overlay_state = "solbadge"
	badge_string = null
	w_class = ITEMSIZE_TINY

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

/obj/item/clothing/accessory/badge/trinary
    name = "trinary perfection brooch"
    desc = "A metal brooch worn by those who serve or follow the beliefs of the Trinary Perfection. It resembles a gear with a triangle inside."
    icon_state = "trinary_badge"
    overlay_state = "trinary_badge"
    badge_string = null

/obj/item/clothing/accessory/badge/passcard_ceti
	name = "republic of biesel passcard"
	desc = "A passcard issued to citizens of the Republic of Biesel, typically from planets in Biesel proper and smaller territories."
	desc_fluff = "A passcard is a modern evolution of the state-issued identification card, with all the functionality of a driver's license, birth certificate, passport, or other document, \
	updated as necessary or able by a central government. The concept was pioneered in the early days of the Sol Alliance, and continues in most human stellar nations to this day, owing to the availability \
	and price of consumer plastics and self-powered microholograms."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_ceti"
	item_state = "passcard_ceti"
	overlay_state = "passport_ceti"
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_sol
	name = "\improper ASSN passcard"
	desc = "A passcard issued to citizens of the Alliance of Sovereign Solarian Nations, typically from planets such as the Jewel Worlds or smaller zones of authority."
	desc_fluff = "A passcard is a modern evolution of the state-issued identification card, with all the functionality of a driver's license, birth certificate, passport, or other document, \
	updated as necessary or able by a central government. The concept was pioneered in the early days of the Sol Alliance, and continues in most human stellar nations to this day, owing to the availability \
	and price of consumer plastics and self-powered microholograms."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_sol"
	item_state = "passcard_sol"
	overlay_state = "passcard_sol"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_pluto
	name = "plutonian passcard"
	desc = "A passcard issued to citizens of the Solarian planetoid, Pluto."
	desc_fluff = "Plutonian passcards, in addition to the features of their cousins in the greater Sol Alliance, include details such as Party membership and occupation, available for viewing by personnel \
	with the appropriate scanning measures."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_pluto"
	item_state = "passcard_pluto"
	overlay_state = "passcard_pluto"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_silversun
	name = "silversun commemorative passcard"
	desc = "A passcard issued to Idris employees currently or formerly employed or residing on the planet Silversun."
	desc_fluff = "While Silversun itself is a member of the Sol Alliance, Idris Incorporated has secured a number of obscure patents, permits, and bureaucratic channels that allows them to commemorate \
	faithful employees from the resort world with unique passcards that double as membership cards to some of the cheaper resorts on-world."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_silversun"
	item_state = "passcard_silversun"
	overlay_state = "passcard_silversun"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_eridani
	name = "eridani corporate republic passcard"
	desc = "A holographic passcard issued to residents of the Free Economic Zone of Epsilon Eridani."
	desc_fluff = "Known with a number of unfavorable acronyms across the Republic, Eridani passcards tend to include unhelpful details such as credit score, personal debts, and insurance providers to those \
	equipped with the right equipment. Infamous across the Orion Spur for being the most sought-after passcards for counterfeiting."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_eridani"
	item_state = "passcard_eridani"
	overlay_state = "passcard_eridani"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_elyra
	name = "elyran passcard"
	desc = "A passcard issued to citizens of the Serene Republic of Elyra."
	desc_fluff = "Much like synthetics manufactured in the Serene Republic, Elyran passcards include high-grade anti-counterfeiting through a wafer of borosilicate reinforced with a randomly-chosen alloy. \
	Unlike other nations, however, Elyra allows for heavy personal customization of their passcards, with some of the most expensive government contractors offering simple musical notes or integration with \
	jewelry such as a bracelet or necklace."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_elyra"
	item_state = "passcard_elyra"
	overlay_state = "passcard_elyra"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_dominia
	name = "dominian passcard"
	desc = "A passcard issued to citizens of the Empire of Dominia."
	desc_fluff = "Dominian passcards, aside from the usual information, also include details such as one's House, their remaining Mo'ri'zal debt, their status as an Edict Breaker, or- most uniquely- their most recent \
	testing for status as a synthetic infiltrator."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_dominia"
	item_state = "passcard_dominia"
	overlay_state = "passcard_dominia"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_coalition
	name = "coalition passcard"
	desc = "A passcard issued to a citizen of the Coalition of Colonies, typically from worlds like Xanu Prime or the 'wilder' frontier-ward planets lacking in strong central government."
	desc_fluff = "Due to its terse relations with the Sol Alliance, the Coalition of Colonies has likewise refused to make their passcard software compatible with Alliance verification technology as a \
	whole. Those travelling from the Coalition to Sol space, for whatever reason, are thus likely to carry paper copies of their identity paperwork with them."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_coc"
	item_state = "passcard_coc"
	overlay_state = "passcard_coc"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_himeo
	name = "himean passcard"
	desc = "A passcard issued to a citizen of the planet Himeo."
	desc_fluff = "Himean passcards are descended from a series of modifications made to the original design, meant to show the user had membership in a worker's syndicate without arousing suspicion from \
	overseers with paper union cards. These 'defaced' Solarian passcards often find their way into planetary museums, or private collections."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_himeo"
	item_state = "passcard_himeo"
	overlay_state = "passcard_himeo"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_gad
	name = "gadpathurian passcard"
	desc = "A passcard issued to an active member of a Gadpathurian cadre."
	desc_fluff = "While identification tabs remain the de facto proof of a Gadpathurian's pride to their cadre and nation, more recent innovations in identification-locked facilities and equipment have demanded \
	a temporary solution to the low-technology tabs until widespread reform can be made to their manufacturing. As such, Gadpathurian passcards are developed from the ground-up, and are notorious for including \
	hostile electronics that overheat Solarian examination equipment and can be easily destroyed in the event of capture."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_gad"
	item_state = "passcard_gad"
	overlay_state = "passcard_gad"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_vysoka
	name = "vysokan passcard"
	desc = "A passcard issued to a citizen of the planet Vysoka."
	desc_fluff = "Vysokan passcards often include metals and plastics derived from the place of origin for their recipient, and may make small aesthetic changes to reflect family traditions. They are often \
	objects of incredible sentimental value to their bearer."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_vysoka"
	item_state = "passcard_vysoka"
	overlay_state = "passcard_vysoka"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_assu
	name = "assunzionii passcard"
	desc = "A passcard issued to a citizen of the planet Assunzione."
	desc_fluff = "Assunzionii passcards, while unable to provide the same light as a warding sphere, are known for having light-absorbing compounds in their assembly, and thus glow in the dark for easy reading."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_assu"
	item_state = "passcard_assu"
	overlay_state = "passcard_assu"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_scarab
	name = "scarab passblade"
	desc = "A dagger issued as a writ of passage to scarabs abroad."
	desc_fluff = "By Scarab traditions, one should show their weapon to non-Scarabs upon first meeting. This dagger, sheathed in hakhma chitin, is often given to noncombatants, the Released, or the young, so they \
	may meet with outsiders with at least a blade between them. Despite this, the blade is sealed tightly within the scabbard."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_scarab"
	item_state = "passcard_scarab"
	overlay_state = "passcard_scarab"
	contained_sprite = 1
	slot_flags = SLOT_HOLSTER
	w_class = ITEMSIZE_SMALL
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_techno
	name = "techno-conglomerate passcard"
	desc = "A clump of machinery scraps repurposed into a functional passcard, used by the Techno-Conglomerate."
	desc_fluff = "In a society that values progress towards perfection, the Techno-Conglomerate has also applied this to their 'governance'. Prospective wayfarers and explorers will often be required to assemble \
	their own cards from scraps left over from the early days of the technology, often leading to outdated or buggy versions. Urban legend claims that some have even found a way to exploit this technology to 'sequence' \
	their way into more secure locales."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_techno"
	item_state = "passcard_techno"
	overlay_state = "passcard_techno"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passcard_burszia
	name = "burszian passcard"
	desc = "A passcard issued to Burszian Hephaestus employees and- owned IPCs- working abroad."
	desc_fluff = "Despite protest from the Himean representatives in government, Hephaestus Industries- citing their 'Home is where the Hephaestus is' initiative- is permitted to issue up to five thousand \
	sponsored passcards to participating employees on a yearly basis, both to remind them of their home and to save on imported labor costs."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passcard_burs"
	item_state = "passcard_burs"
	overlay_state = "passcard_burs"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passport_sol
	name = "solarian passport"
	desc = "A passport issued to a citizen of the Alliance of Sovereign Solarian Nations, or Sol Alliance. A more generalized document for passage abroad."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passport_sol"
	item_state = "passport_sol"
	overlay_state = "passport_sol"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passport_coc
	name = "coalition passport"
	desc = "A passport issued to a citizen of the Coalition of Colonies, typically from worlds like Xanu Prime or the 'wilder' frontier-ward planets lacking in strong central government."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passport_coc"
	item_state = "passport_coc"
	overlay_state = "passport_coc"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passport_elyra
	name = "elyran passport"
	desc = "A passport issued to a citizen of the Serene Republic of Elyra. Vintage!"
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passport_elyra"
	item_state = "passport_elyra"
	overlay_state = "passport_elyra"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE

/obj/item/clothing/accessory/badge/passport_dominia
	name = "dominian passport"
	desc = "A passport issued to a resident of the Empire of Dominia. Popular among those whose debt is great but pockets light."
	icon = 'icons/clothing/accessories/passcards.dmi'
	icon_state = "passport_dominia"
	item_state = "passport_dominia"
	overlay_state = "passport_dominia"
	contained_sprite = 1
	slot_flags = null
	w_class = ITEMSIZE_TINY
	flippable = FALSE
	v_flippable = FALSE