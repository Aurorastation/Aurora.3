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
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = 1.0
	var/associated_account_number = 0

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
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

/obj/item/weapon/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)

/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	var/uses = 10

var/const/NO_EMAG_ACT = -50
/obj/item/weapon/card/emag/resolve_attackby(atom/A, mob/user)
	var/used_uses = A.emag_act(uses, user, src)
	if(used_uses == NO_EMAG_ACT)
		return ..(A, user)

	uses -= used_uses
	A.add_fingerprint(user)
	if(used_uses)
		log_and_message_admins("emagged \an [A].")

	if(uses<1)
		user.visible_message("<span class='warning'>\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent.</span>")
		var/obj/item/weapon/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		user.drop_from_inventory(src,get_turf(junk))
		qdel(src)

	return 1

/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"

	sprite_sheets = list(
		"Resomi" = 'icons/mob/species/resomi/id.dmi'
		)

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

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already

/obj/item/weapon/card/id/Destroy()
	mob = null
	return ..()

/obj/item/weapon/card/id/examine(mob/user)
	if (..(user, 1))
		show(user)

/obj/item/weapon/card/id/proc/prevent_tracking()
	return 0

/obj/item/weapon/card/id/proc/show(mob/user as mob)
	if(front && side)
		user << browse_rsc(front, "front.png")
		user << browse_rsc(side, "side.png")
	var/datum/browser/popup = new(user, "idcard", name, 650, 260)
	popup.set_content(dat())
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/item/weapon/card/id/proc/update_name()
	name = "[src.registered_name]'s ID Card ([src.assignment])"

/obj/item/weapon/card/id/proc/set_id_photo(var/mob/M)
	front = getFlatIcon(M, SOUTH, always_use_defdir = 1)
	front.Scale(128, 128)
	side = getFlatIcon(M, WEST, always_use_defdir = 1)
	side.Scale(128, 128)

/mob/proc/set_id_info(var/obj/item/weapon/card/id/id_card)
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.sex 				= capitalize(gender)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)
	id_card.update_name()

/mob/living/carbon/human/set_id_info(var/obj/item/weapon/card/id/id_card)
	..()
	id_card.age = age
	id_card.citizenship			= citizenship
	id_card.religion			= religion
	id_card.mob					= src

/obj/item/weapon/card/id/proc/dat()
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

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	if (dna_hash == "\[UNSET\]" && ishuman(user))
		var/response = alert(user, "This ID card has not been imprinted with biometric data. Would you like to imprint yours now?", "Biometric Imprinting", "Yes", "No")
		if (response == "Yes")
			var/mob/living/carbon/human/H = user
			if(H.gloves)
				user << "<span class='warning'>You cannot imprint [src] while wearing \the [H.gloves].</span>"
				return
			else
				mob = H
				blood_type = H.dna.b_type
				dna_hash = H.dna.unique_enzymes
				fingerprint_hash = md5(H.dna.uni_identity)
				citizenship = H.citizenship
				religion = H.religion
				age = H.age
				user << "<span class='notice'>Biometric Imprinting Successful!.</span>"
				return

	for(var/mob/O in viewers(user, null))
		O.show_message(text("[] shows you: \icon[] []: assignment: []", user, src, src.name, src.assignment), 1)

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/attack(var/mob/living/M, var/mob/user, proximity)

	if(user.zone_sel.selecting == "r_hand" || user.zone_sel.selecting == "l_hand")

		if(!ishuman(M))
			return ..()

		if (dna_hash == "\[UNSET\]" && ishuman(user))
			var/response = alert(user, "This ID card has not been imprinted with biometric data. Would you like to imprint [M]'s now?", "Biometric Imprinting", "Yes", "No")
			if (response == "Yes")

				if (!user.Adjacent(M) || user.restrained() || user.lying || user.stat)
					user << "<span class='warning'>You must remain adjacent to [M] to scan their biometric data.</span>"
					return

				var/mob/living/carbon/human/H = M

				if(H.gloves)
					user << "<span class='warning'>\The [H] is wearing gloves.</span>"
					return 1

				if(user != H && H.a_intent != "help" && !H.lying)
					user.visible_message("<span class='danger'>\The [user] tries to take prints from \the [H], but they move away.</span>")
					return 1

				var/has_hand
				var/obj/item/organ/external/O = H.organs_by_name["r_hand"]
				if(istype(O) && !O.is_stump())
					has_hand = 1
				else
					O = H.organs_by_name["l_hand"]
					if(istype(O) && !O.is_stump())
						has_hand = 1
				if(!has_hand)
					user << "<span class='warning'>They don't have any hands.</span>"
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
				user << "<span class='notice'>Biometric Imprinting Successful!.</span>"
				return 1
	return ..()

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetID()
	return src

/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	usr << text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment)
	usr << "The age on the card is [age]."
	usr << "The citizenship on the card is [citizenship]."
	usr << "The religion on the card is [religion]."
	usr << "The blood type on the card is [blood_type]."
	usr << "The DNA hash on the card is [dna_hash]."
	usr << "The fingerprint hash on the card is [fingerprint_hash]."
	if(mining_points)
		usr << "A ticker indicates the card has [mining_points] ore redemption points available."
	return

/obj/item/weapon/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/weapon/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate, access_external_airlocks)

/obj/item/weapon/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/weapon/card/id/captains_spare/New()
	access = get_all_station_access()
	..()

/obj/item/weapon/card/id/merchant
	name = "merchant pass"
	icon_state = "centcom"
	desc = "An identification card issued to NanoTrasen sanctioned merchants, indicating their right to sell and buy goods."
	access = list(access_merchant)

/obj/item/weapon/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for NanoTrasen Synthetics"
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Synthetic"

/obj/item/weapon/card/id/synthetic/New()
	access = get_all_station_access() + access_synth
	..()

/obj/item/weapon/card/id/minedrone
	name = "\improper Minedrone ID"
	desc = "Access module for NanoTrasen Minedrones"
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Minedrone"

/obj/item/weapon/card/id/minedrone/New()
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	..()

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/weapon/card/id/centcom/New()
	access = get_all_centcom_access()
	..()

/obj/item/weapon/card/id/ert
	name = "\improper Emergency Response Team ID"
	icon_state = "centcom"
	assignment = "Emergency Response Team"

obj/item/weapon/card/id/ert/New()
	access = get_all_station_access() + get_centcom_access("Emergency Response Team")
	..()

/obj/item/weapon/card/id/all_access
	name = "\improper Administrator's spare ID"
	desc = "The spare ID of the Lord of Lords himself."
	icon_state = "data"
	item_state = "tdgreen"
	registered_name = "Administrator"
	assignment = "Administrator"
/obj/item/weapon/card/id/all_access/New()
	access = get_access_ids()
	..()
