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
	w_class = 1.0
	var/associated_account_number = 0

	var/list/files = list(  )
	drop_sound = 'sound/items/drop/card.ogg'

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

/obj/item/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	layer = 3
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

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

/obj/item/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"
	overlay_state = "id"

	var/list/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	var/mob/living/carbon/human/mob
	slot_flags = SLOT_ID

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/citizenship = "\[UNSET\]"
	var/religion = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/icon/front
	var/icon/side
	var/mining_points //miners gotta eat

	var/flipped = 0
	var/wear_over_suit = 0

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already

/obj/item/card/id/Destroy()
	mob = null
	return ..()

/obj/item/card/id/examine(mob/user)
	if (..(user, 1))
		show(user)

/obj/item/card/id/proc/prevent_tracking()
	return 0

/obj/item/card/id/proc/show(mob/user as mob)
	if(front && side)
		to_chat(user, browse_rsc(front, "front.png"))
		to_chat(user, browse_rsc(side, "side.png"))
	var/datum/browser/popup = new(user, "idcard", name, 650, 260)
	popup.set_content(dat())
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/item/card/id/proc/update_name()
	name = "[src.registered_name]'s ID Card ([src.assignment])"

/obj/item/card/id/proc/set_id_photo(var/mob/M)
	front = getFlatIcon(M, SOUTH, always_use_defdir = 1)
	front.Scale(128, 128)
	side = getFlatIcon(M, WEST, always_use_defdir = 1)
	side.Scale(128, 128)

/mob/proc/set_id_info(var/obj/item/card/id/id_card)
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.sex 				= capitalize(gender)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)
	id_card.update_name()

/mob/living/carbon/human/set_id_info(var/obj/item/card/id/id_card)
	..()
	id_card.age 				= age
	id_card.citizenship			= citizenship
	id_card.religion 			= SSrecords.get_religion_record_name(religion)
	id_card.mob					= src

/obj/item/card/id/proc/dat()
	var/dat = ("<table><tr><td>")
	dat += text("Name: []</A><BR>", registered_name)
	dat += text("Sex: []</A><BR>\n", sex)
	dat += text("Age: []</A><BR>\n", age)
	dat += text("Citizenship: []</A><BR>\n", citizenship)
	dat += text("Religion: []</A><BR>\n", religion)
	dat += text("Rank: []</A><BR>\n", assignment)
	dat += text("Fingerprint: []</A><BR>\n", fingerprint_hash)
	dat += text("Blood Type: []<BR>\n", blood_type)
	dat += text("DNA Hash: []<BR><BR>\n", dna_hash)
	if(mining_points)
		dat += text("Ore Redemption Points: []<BR><BR>\n", mining_points)
	if(front && side)
		dat +="<td align = center valign = top>Photo:<br><img src=front.png height=128 width=128 border=4><img src=side.png height=128 width=128 border=4></td>"
	dat += "</tr></table>"
	return dat

/obj/item/card/id/attack_self(mob/user as mob)
	if (dna_hash == "\[UNSET\]" && ishuman(user))
		var/response = alert(user, "This ID card has not been imprinted with biometric data. Would you like to imprint yours now?", "Biometric Imprinting", "Yes", "No")
		if (response == "Yes")
			var/mob/living/carbon/human/H = user
			if(H.gloves)
				to_chat(user, "<span class='warning'>You cannot imprint [src] while wearing \the [H.gloves].</span>")
				return
			else
				mob = H
				blood_type = H.dna.b_type
				dna_hash = H.dna.unique_enzymes
				fingerprint_hash = md5(H.dna.uni_identity)
				citizenship = H.citizenship
				religion = SSrecords.get_religion_record_name(H.religion)
				age = H.age
				to_chat(user, "<span class='notice'>Biometric Imprinting successful!</span>")
				return

	for(var/mob/O in viewers(user, null))
		O.show_message(text("[] shows you: \icon[] []: assignment: []", user, src, src.name, src.assignment), 1)

	src.add_fingerprint(user)
	return

/obj/item/card/id/attack(var/mob/living/M, var/mob/user, proximity)

	if(user.zone_sel.selecting == BP_R_HAND || user.zone_sel.selecting == BP_L_HAND)

		if(!ishuman(M))
			return ..()

		if (dna_hash == "\[UNSET\]" && ishuman(user))
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
				mob = H
				blood_type = H.dna.b_type
				dna_hash = H.dna.unique_enzymes
				fingerprint_hash = md5(H.dna.uni_identity)
				citizenship = H.citizenship
				religion = H.religion
				age = H.age
				src.add_fingerprint(H)
				to_chat(user, "<span class='notice'>Biometric Imprinting Successful!.</span>")
				return 1
	return ..()

/obj/item/card/id/GetAccess()
	return access

/obj/item/card/id/GetID()
	return src

/obj/item/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment))
	to_chat(usr, "The age on the card is [age].")
	to_chat(usr, "The citizenship on the card is [citizenship].")
	to_chat(usr, "The religion on the card is [religion].")
	to_chat(usr, "The blood type on the card is [blood_type].")
	to_chat(usr, "The DNA hash on the card is [dna_hash].")
	to_chat(usr, "The fingerprint hash on the card is [fingerprint_hash].")
	if(mining_points)
		to_chat(usr, "A ticker indicates the card has [mining_points] ore redemption points available.")
	return

/obj/item/card/id/proc/mob_icon_update()
	if (ismob(src.loc))
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

/obj/item/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	icon_state = "dark"
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate, access_external_airlocks)

/obj/item/card/id/syndicate_ert
	name = "\improper Syndicate Commando ID"
	assignment = "Commando"
	icon_state = "centcom"

/obj/item/card/id/syndicate_ert/New()
	access = get_all_accesses()
	..()

/obj/item/card/id/syndicate/raider
	name = "passport"
	assignment = "Visitor"

/obj/item/card/id/highlander
	name = "\improper Highlander ID"
	assignment = "Highlander"
	icon_state = "centcom"

/obj/item/card/id/highlander/New()
	access = get_all_station_access() | get_all_centcom_access()
	..()

/obj/item/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	overlay_state = "gold"
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/card/id/captains_spare/New()
	access = get_all_station_access()
	..()

/obj/item/card/id/merchant
	name = "merchant pass"
	icon_state = "centcom"
	overlay_state = "centcom"
	desc = "An identification card issued to NanoTrasen sanctioned merchants, indicating their right to sell and buy goods."
	access = list(access_merchant)

/obj/item/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for NanoTrasen Synthetics"
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Synthetic"

/obj/item/card/id/synthetic/New()
	access = get_all_station_access() + access_synth
	..()

/obj/item/card/id/minedrone
	name = "\improper Minedrone ID"
	desc = "Access module for NanoTrasen Minedrones"
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Minedrone"

/obj/item/card/id/minedrone/New()
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	..()

/obj/item/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	overlay_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/card/id/centcom/New()
	access = get_all_centcom_access()
	..()

/obj/item/card/id/ert
	name = "\improper Nanotrasen Emergency Response Team ID"
	icon_state = "centcom"
	overlay_state = "centcom"
	assignment = "Emergency Response Team"

/obj/item/card/id/ert/New()
	access = get_all_station_access() + get_centcom_access("Emergency Response Team")
	..()

/obj/item/card/id/asset_protection
	name = "\improper Nanotrasen Asset Protection ID"
	icon_state = "centcom"
	overlay_state = "centcom"
	assignment = "Asset Protection"

/obj/item/card/id/asset_protection/New()
	access = get_all_accesses()
	..()

/obj/item/card/id/distress
	name = "\improper Freelancer Mercenary ID"
	icon_state = "centcom"
	assignment = "Freelancer Mercenary"

/obj/item/card/id/distress/New()
	access = list(access_distress, access_maint_tunnels, access_external_airlocks)
	..()

/obj/item/card/id/distress/kataphract
	name = "\improper Kataphract ID"
	icon_state = "centcom"
	assignment = "Kataphract"

/obj/item/card/id/distress/legion
	name = "\improper Tau Ceti Foreign Legion ID"
	assignment = "Tau Ceti Foreign Legion Volunteer"
	icon_state = "legion"

/obj/item/card/id/distress/legion/New()
	access = list(access_legion, access_maint_tunnels, access_external_airlocks, access_security, access_engine, access_engine_equip, access_medical, access_research, access_atmospherics, access_medical_equip)
	..()

/obj/item/card/id/distress/iac
	name = "\improper Interstellar Aid Corps ID"
	assignment = "Interstellar Aid Corps Responder"
	icon_state = "centcom"

/obj/item/card/id/distress/iac/New()
	access = get_distress_access()
	..()

/obj/item/card/id/all_access
	name = "\improper Administrator's spare ID"
	desc = "The spare ID of the Lord of Lords himself."
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

/obj/item/card/id/eridani
	name = "\improper Eridani identification card"
	desc = "A high-tech holobadge, identifying the owner as a contractor from one of the many PMCs from the Eridani Corporate Federation."
	icon_state = "erisec_card"
	overlay_state = "erisec_card"

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

/obj/item/card/id/necropolis
	name = "\improper Necropolis Incorporated identification card"
	desc = "An old-fashioned, practical plastic card. Smells faintly of gunpowder."
	icon_state = "necro_card"
	overlay_state = "necro_card"

/obj/item/card/id/necropolis/sec
	desc = "An old-fashioned, practical plastic card. This one is of a higher rank, for Security personnel."
	icon_state = "necrosec_card"
	overlay_state = "necrosec_card"

/obj/item/card/id/einstein
	name = "\improper Einstein Engines identification card"
	desc = "A stylized plastic card, belonging to one of the many specialists at Einstein Engines."
	icon_state = "einstein_card"
	overlay_state = "einstein_card"
