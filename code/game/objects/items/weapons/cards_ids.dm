/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_card.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_card.dmi',
		)
	w_class = ITEMSIZE_TINY
	var/associated_account_number = 0
	var/list/files = list(  )
	var/last_flash = 0 //Spam limiter.
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'

/obj/item/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"
	overlay_state = "data"

/obj/item/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/*
 * ID CARDS
 */
/obj/item/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	var/uses = 10

/obj/item/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag_broken"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)

var/const/NO_EMAG_ACT = -50
/obj/item/card/emag/resolve_attackby(atom/A, mob/user, var/click_parameters)
	var/used_uses = A.emag_act(uses, user, src)
	if(used_uses == NO_EMAG_ACT)
		return ..(A, user, click_parameters)

	uses -= used_uses
	A.add_fingerprint(user)
	if(used_uses)
		log_and_message_admins("emagged \an [A].")

	if(uses<1)
		user.visible_message("<span class='warning'>\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent.</span>")
		var/obj/item/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		user.drop_from_inventory(src,get_turf(junk))
		qdel(src)

	return 1

#define ID_CARD_UNSET "\[UNSET\]"

/obj/item/card/id
	name = "identification card"
	desc = "A card used to identify people and determine access."
	icon_state = "id"
	item_state = "card-id"
	overlay_state = "id"

	var/list/access = list()
	var/registered_name = ID_CARD_UNSET // The name registered_name on the card
	var/datum/weakref/mob_id
	slot_flags = SLOT_ID

	var/age = ID_CARD_UNSET
	var/blood_type = ID_CARD_UNSET
	var/dna_hash = ID_CARD_UNSET
	var/fingerprint_hash = ID_CARD_UNSET
	var/citizenship = ID_CARD_UNSET
	var/sex = ID_CARD_UNSET
	var/icon/front
	var/icon/side
	var/mining_points //miners gotta eat

	var/can_copy_access = FALSE
	var/access_copy_msg

	var/flipped = 0
	var/wear_over_suit = 0

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/employer_faction = null
	var/datum/ntnet_user/chat_user

	var/iff_faction = IFF_DEFAULT

/obj/item/card/id/Destroy()
	QDEL_NULL(chat_user)
	return ..()

/obj/item/card/id/examine(mob/user, distance)
	. = ..()
	if (distance <= 1)
		show(user)

/obj/item/card/id/on_slotmove(var/mob/living/user, slot)
	. = ..(user, slot)
	BITSET(user.hud_updateflag, ID_HUD) //Update ID HUD if an ID is ever moved

/obj/item/card/id/proc/prevent_tracking()
	return 0

/obj/item/card/id/proc/show(mob/user)
	if(front && side)
		send_rsc(user, front, "front.png")
		send_rsc(user, side, "side.png")
	var/datum/browser/popup = new(user, "idcard", name, 650, 260)
	popup.set_content(dat())
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/item/card/id/proc/update_name()
	name = "workplace ID card - [src.registered_name], [src.assignment]"
	if(istype(chat_user))
		chat_user.username = chat_user.generateUsernameIdCard(src)

/obj/item/card/id/proc/set_id_photo(var/mob/M)
	front = getFlatIcon(M, SOUTH, ignore_parent_dir = TRUE)
	front.Scale(128, 128)
	side = getFlatIcon(M, WEST, ignore_parent_dir = TRUE)
	side.Scale(128, 128)

/mob/proc/set_id_info(var/obj/item/card/id/id_card)
	id_card.age = 0
	id_card.registered_name	= real_name
	id_card.sex = capitalize(gender)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type = dna.b_type
		id_card.dna_hash  = dna.unique_enzymes
		id_card.fingerprint_hash = md5(dna.uni_identity)
	id_card.update_name()

/mob/living/carbon/human/set_id_info(var/obj/item/card/id/id_card)
	..()
	id_card.age 				= age
	id_card.citizenship			= citizenship
	id_card.mob_id				= WEAKREF(src)
	id_card.employer_faction    = employer_faction

/obj/item/card/id/proc/dat()
	var/dat = ("<table><tr><td>")
	dat += text("Name: []<br>", registered_name)
	dat += text("Age: []<br>\n", age)
	dat += text("Sex: []<br>\n", sex)
	dat += text("Citizenship: []<br>\n", citizenship)
	dat += text("Assignment and Employer: []<br>\n", assignment)
	dat += text("Blood Type: []<br>\n", blood_type)
	dat += text("Fingerprint Hash: []<br>\n", fingerprint_hash)
	dat += text("DNA Hash: []\n", dna_hash)
	if(mining_points)
		dat += text("<br>Ore Redemption Points: []\n", mining_points)
	if(front && side)
		dat +="<td align = center valign = top>Front and Side Photograph<br><img src=front.png height=128 width=128 border=4><img src=side.png height=128 width=128 border=4></td>"
	dat += "</tr></table>"
	return dat

/obj/item/card/id/attack_self(mob/user as mob)
	if(dna_hash == ID_CARD_UNSET && ishuman(user))
		var/response = alert(user, "This ID card has not been imprinted with biometric data. Would you like to imprint yours now?", "Biometric Imprinting", "Yes", "No")
		if (response == "Yes")
			var/mob/living/carbon/human/H = user
			if(H.gloves)
				to_chat(user, "<span class='warning'>You cannot imprint [src] while wearing \the [H.gloves].</span>")
				return
			else
				mob_id = WEAKREF(H)
				blood_type = H.dna.b_type
				dna_hash = H.dna.unique_enzymes
				fingerprint_hash = md5(H.dna.uni_identity)
				citizenship = H.citizenship
				age = H.age
				to_chat(user, "<span class='notice'>Biometric imprinting successful!</span>")
				return
	if(last_flash <= world.time - 20)
		last_flash = world.time
		id_flash(user)

	src.add_fingerprint(user)
	return

/obj/item/card/id/proc/id_flash(var/mob/user, var/add_text = "", var/blind_add_text = "")
	var/list/id_viewers = viewers(3, user) // or some other distance - this distance could be defined as a var on the ID
	var/message = "<b>[user]</b> flashes [user.get_pronoun("his")] [icon2html(src, id_viewers)] [src.name]."
	var/blind_message = "You flash your [icon2html(src, id_viewers)] [src.name]."
	if(add_text != "")
		message += " [add_text]"
	if(blind_add_text != "")
		blind_message += " [blind_add_text]"
	user.visible_message(message, blind_message)

/obj/item/card/id/attack(var/mob/living/M, var/mob/user, proximity)

	if(user.zone_sel.selecting == BP_R_HAND || user.zone_sel.selecting == BP_L_HAND)

		if(!ishuman(M))
			return ..()

		if (dna_hash == ID_CARD_UNSET && ishuman(user))
			var/response = alert(user, "This ID card has not been imprinted with biometric data. Would you like to imprint [M]'s now?", "Biometric Imprinting", "Yes", "No")
			if (response == "Yes")

				if (!user.Adjacent(M) || user.restrained() || user.lying || user.stat)
					to_chat(user, "<span class='warning'>You must remain adjacent to [M] to scan their biometric data.</span>")
					return

				var/mob/living/carbon/human/H = M

				if(H.gloves)
					to_chat(user, "<span class='warning'>\The [H] is wearing gloves.</span>")
					return 1

				if(user != H && H.a_intent != "help" && !H.lying)
					user.visible_message("<span class='danger'>\The [user] tries to take prints from \the [H], but they move away.</span>")
					return 1

				var/has_hand
				var/obj/item/organ/external/O = H.organs_by_name[BP_R_HAND]
				if(istype(O) && !O.is_stump())
					has_hand = 1
				else
					O = H.organs_by_name[BP_L_HAND]
					if(istype(O) && !O.is_stump())
						has_hand = 1
				if(!has_hand)
					to_chat(user, "<span class='warning'>They don't have any hands.</span>")
					return 1
				user.visible_message("[user] imprints [src] with \the [H]'s biometrics.")
				mob_id = WEAKREF(H)
				blood_type = H.dna.b_type
				dna_hash = H.dna.unique_enzymes
				fingerprint_hash = md5(H.dna.uni_identity)
				citizenship = H.citizenship
				age = H.age
				src.add_fingerprint(H)
				to_chat(user, SPAN_NOTICE("Biometric Imprinting Successful!"))
				return 1
	return ..()

/obj/item/card/id/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id))
		var/obj/item/card/id/ID = W
		if(ID.can_copy_access)
			ID.access |= src.access
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			if(player_is_antag(user.mind) || isgolem(user))
				to_chat(user, SPAN_NOTICE(ID.access_copy_msg))
			return
	. = ..()

/obj/item/card/id/GetAccess()
	return access

/obj/item/card/id/GetID()
	return src

/obj/item/card/id/proc/mob_icon_update()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_id()

/obj/item/card/id/verb/flip_side()
	set name = "Flip ID card"
	set category = "Object"
	set src in usr
	if(use_check_and_message(usr, use_flags = USE_DISALLOW_SILICONS))
		return

	src.flipped = !src.flipped
	if(src.flipped)
		src.overlay_state = "[overlay_state]_flip"
	else
		src.overlay_state = initial(overlay_state)
	to_chat(usr, "You change \the [src] to be on your [src.flipped ? "left" : "right"] side.")
	mob_icon_update()

/obj/item/card/id/verb/toggle_icon_layer()
	set name = "Switch ID Layer"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr, use_flags = USE_DISALLOW_SILICONS))
		return
	if(wear_over_suit == -1)
		to_chat(usr, "<span class='notice'>\The [src] cannot be worn above your suit!</span>")
		return
	wear_over_suit = !wear_over_suit
	mob_icon_update()

/obj/item/card/id/proc/InitializeChatUser()
	if(!istype(chat_user))
		chat_user = new()
		chat_user.username = chat_user.generateUsernameIdCard(src)

/obj/item/card/id/silver
	icon_state = "silver"
	item_state = "silver_id"
	overlay_state = "silver"

/obj/item/card/id/white
	icon_state = "white"
	item_state = "white_id"
	overlay_state = "white"

/obj/item/card/id/navy
	desc = "A navy card which shows honour and dedication."
	icon_state = "navy"
	item_state = "navy_id"
	overlay_state = "navy"

/obj/item/card/id/gold
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"
	overlay_state = "gold"

/obj/item/card/id/syndicate/command
	name = "illicit identification card"
	desc = "An identification card."
	icon_state = "dark"
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(ACCESS_SYNDICATE, ACCESS_EXTERNAL_AIRLOCKS)

/obj/item/card/id/syndicate/ert
	name = "illicit commando identification card"
	assignment = "Commando"
	icon_state = "centcom"

/obj/item/card/id/syndicate/ert/Initialize()
	. = ..()
	access = get_all_accesses()

/obj/item/card/id/syndicate/raider
	name = "passport"
	assignment = "Visitor"

/obj/item/card/id/syndicate/raider/update_name()
	name = "[registered_name]'s Passport"

/obj/item/card/id/highlander
	name = "highlander identification card"
	assignment = "Highlander"
	icon_state = "centcom"

/obj/item/card/id/highlander/New()
	access = get_all_station_access() | get_all_centcom_access()
	..()

/obj/item/card/id/captains_spare
	name = "captain's spare identification card"
	desc = "A captain's spare identification card."
	icon_state = "gold"
	item_state = "gold_id"
	overlay_state = "gold"
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/card/id/captains_spare/New()
	access = get_all_station_access()
	..()

/obj/item/card/id/merchant
	name = "merchant identification card"
	desc = "An identification card issued to SCC-sanctioned merchants, indicating their right to sell and buy goods."
	icon_state = "centcom"
	overlay_state = "centcom"
	access = list(ACCESS_MERCHANT)

/obj/item/card/id/synthetic
	name = "\improper SCC equipment identification card"
	desc = "Access module for SCC equipment."
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Equipment"

/obj/item/card/id/synthetic/New()
	access = get_all_station_access() + ACCESS_EQUIPMENT
	..()

/obj/item/card/id/synthetic/cyborg
	name = "\improper SCC equipment identification card"
	desc = "Access module for SCC equipment."
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Equipment"

/obj/item/card/id/synthetic/cyborg/New()
	..()
	access = list(ACCESS_EQUIPMENT, ACCESS_AI_UPLOAD, ACCESS_EXTERNAL_AIRLOCKS) // barebones cyborg access. Job special added in different place

/obj/item/card/id/minedrone
	name = "mine drone identification card"
	desc = "Access module for mine drones."
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Minedrone"

/obj/item/card/id/minedrone/New()
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_CARGO_BOT, ACCESS_QM, ACCESS_MINING, ACCESS_MINING_STATION, ACCESS_EXTERNAL_AIRLOCKS)
	..()

/obj/item/card/id/centcom
	name = "\improper CentCom identification card"
	desc = "An ID straight from CentCom."
	icon_state = "centcom"
	overlay_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/card/id/centcom/New()
	access = get_all_centcom_access()
	..()

/obj/item/card/id/ccia
	name = "\improper CentCom. Internal Affairs identification card"
	desc = "An ID straight from CentCom. Internal Affairs."
	icon_state = "ccia"
	overlay_state = "ccia"
	drop_sound = /singleton/sound_category/generic_drop_sound
	pickup_sound = /singleton/sound_category/generic_pickup_sound

/obj/item/card/id/ccia/id_flash(var/mob/user)
	var/add_text = "Done with prejudice and professionalism, [user.get_pronoun("he")] means business."
	var/blind_add_text = "Done with prejudice and professionalism, you mean business."
	return ..(user, add_text, blind_add_text)

/obj/item/card/id/ccia/bssb
	name = "\improper Biesel Security Services Bureau identification card"
	desc = "An ID straight from the Biesel Security Services Bureau."
	icon_state = "bssb"

/obj/item/card/id/ert
	name = "\improper NanoTrasen Emergency Response Team identification card"
	icon_state = "centcom"
	overlay_state = "centcom"
	assignment = "Emergency Response Team"

/obj/item/card/id/ert/New()
	access = get_all_station_access() + get_centcom_access("Emergency Response Team")
	..()

/obj/item/card/id/ert/scc
	name = "\improper SCC Emergency Response Team identification card"

/obj/item/card/id/asset_protection
	name = "\improper NanoTrasen Asset Protection identification card"
	icon_state = "centcom"
	overlay_state = "centcom"
	assignment = "Asset Protection"

/obj/item/card/id/asset_protection/New()
	access = get_all_accesses()
	..()

/obj/item/card/id/distress
	name = "\improper Freelancer Mercenary identification card"
	icon_state = "centcom"
	assignment = "Freelancer Mercenary"

/obj/item/card/id/distress/New()
	access = list(ACCESS_DISTRESS, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS)
	..()

/obj/item/card/id/distress/fsf
	name = "\improper Free Solarian Fleets identification card"
	icon_state = "centcom"
	assignment = "Free Solarian Fleets Marine"

/obj/item/card/id/distress/kataphract
	name = "\improper Kataphract identification card"
	icon_state = "centcom"
	assignment = "Kataphract"

/obj/item/card/id/distress/legion
	name = "\improper Tau Ceti Foreign Legion identification card"
	assignment = "Tau Ceti Foreign Legion Volunteer"
	icon_state = "legion"

/obj/item/card/id/distress/legion/New()
	access = list(ACCESS_LEGION, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_SECURITY, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_MEDICAL, ACCESS_RESEARCH, ACCESS_ATMOSPHERICS, ACCESS_MEDICAL_EQUIP)
	..()

/obj/item/card/id/distress/ap_eridani
	name = "\improper Eridani Private Military Contractor identification card"
	desc = "A high-tech holobadge, identifying the owner as a contractor from one of the many PMCs from the Eridani Corporate Federation."
	assignment = "EPMC Asset Protection"
	icon_state = "pmc_card"
	overlay_state = "pmc_card"

/obj/item/card/id/distress/ap_eridani/New()
	access = get_distress_access()
	..()

/obj/item/card/id/distress/iac
	name = "\improper Interstellar Aid Corps identification card"
	assignment = "Interstellar Aid Corps Responder"
	icon_state = "centcom"

/obj/item/card/id/distress/iac/New()
	access = get_distress_access()
	..()

/obj/item/card/id/all_access
	name = "\improper Administrator's spare identification card"
	desc = "An administrator's spare identification card."
	icon_state = "data"
	item_state = "tdgreen"
	overlay_state = "data"
	registered_name = "Administrator"
	assignment = "Administrator"

/obj/item/card/id/all_access/New()
	access = get_access_ids()
	..()

// Contractor cards

/obj/item/card/id/idris
	name = "\improper Idris Incorporated identification card"
	desc = "A high-tech holocard, designed to project information about a sub-contractor from Idris Incorporated."
	icon_state = "idris_card"
	overlay_state = "idris_card"

/obj/item/card/id/idris/sec
	icon_state = "idrissec_card"
	overlay_state = "idrissec_card"

/obj/item/card/id/iru
	name = "\improper IRU identification card"
	desc = "A high-tech holobadge, designed to project information about an asset reclamation synthetic at Idris Incorporated."
	icon_state = "iru_card"
	overlay_state = "iru_card"

/obj/item/card/id/pmc
	name = "\improper PMCG identification card"
	desc = "A high-tech holobadge, identifying the owner as a contractor from one of the many PMCs from the Private Military Contracting Group."
	icon_state = "pmc_card"
	overlay_state = "pmc_card"

/obj/item/card/id/zeng_hu
	name = "\improper Zeng-Hu Pharmaceuticals identification card"
	desc = "A synthleather card, belonging to one of the highly skilled members of Zeng-Hu."
	icon_state = "zhu_card"
	overlay_state = "zhu_card"

/obj/item/card/id/hephaestus
	name = "\improper Hephaestus Industries identification card"
	desc = "A metal-backed card, belonging to the powerful Hephaestus Industries."
	icon_state = "heph_card"
	overlay_state = "heph_card"

/obj/item/card/id/zavodskoi
	name = "\improper Zavodskoi Interstellar Incorporated identification card"
	desc = "An old-fashioned, practical plastic card. Smells faintly of gunpowder."
	icon_state = "necro_card"
	overlay_state = "necro_card"

/obj/item/card/id/zavodskoi/sec
	desc = "An old-fashioned, practical plastic card. This one is of a higher rank, for Security personnel."
	icon_state = "necrosec_card"
	overlay_state = "necrosec_card"

/obj/item/card/id/einstein
	name = "\improper Einstein Engines identification card"
	desc = "A stylized plastic card, belonging to one of the many specialists at Einstein Engines."
	icon_state = "einstein_card"
	overlay_state = "einstein_card"
	iff_faction = IFF_EE

/obj/item/card/id/orion
	name = "\improper Orion Express identification card"
	desc = "A well-worn identification pass, retrofitted with wireless transmission technology."
	icon_state = "orion_card"
	overlay_state = "orion_card"

/obj/item/card/id/bluespace
	name = "bluespace identification card"
	desc = "A bizarre imitation of an ID card; shifting and moving."
	desc_antag = "Access can be copied from other ID cards by clicking on them."
	icon_state = "crystalid"
	iff_faction = IFF_BLUESPACE

/obj/item/card/id/bluespace/update_name()
	return

/obj/item/card/id/bluespace/attack_self(mob/user)
	if(registered_name == user.real_name)
		switch(alert("Would you like edit the ID label, or show it?", "Show or Edit?", "Edit", "Show"))
			if("Edit")
				var/new_label = sanitize(input(user, "Enter the new label.", "Set Label") as text|null, 12)
				if(new_label)
					name = "[initial(name)] ([new_label])"
			if("Show")
				..()
	else
		..()

/obj/item/card/id/away_site
	access = list(ACCESS_GENERIC_AWAY_SITE, ACCESS_EXTERNAL_AIRLOCKS)

/obj/item/card/id/mecha
	name = "exosuit access card"

/obj/item/card/id/mecha/GetAccess()
	var/mob/living/heavy_vehicle/exosuit = loc
	if(!istype(loc) || !length(exosuit.pilots))
		return list()
	var/list/pilot_access = list()
	for(var/mob/pilot as anything in exosuit.pilots)
		var/obj/item/ID = pilot.GetIdCard()
		pilot_access |= ID.GetAccess()
	return pilot_access

#undef ID_CARD_UNSET
