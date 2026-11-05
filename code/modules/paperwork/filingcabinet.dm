/* Filing cabinets!
 * Contains:
 * * Filing Cabinets
 * * Security Record Cabinets
 * * Medical Record Cabinets
 */


/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "filing cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "filingcabinet"
	density = 1
	anchored = 1
	maxhealth = OBJECT_HEALTH_VERY_LOW
	armor = list(MELEE = ARMOR_MELEE_SMALL, BULLET = ARMOR_BALLISTIC_MINOR)
	/// Stable identity assigned to mapped Horizon cabinets for associating persistent papers.
	var/tmp/persistent_storage_id

	var/static/list/accepted_items = list(
		/obj/item/paper,
		/obj/item/folder,
		/obj/item/photo,
		/obj/item/paper_bundle,
		/obj/item/sample,
		/obj/item/book,
		/obj/item/card,
		/obj/item/forensics/slide,
		/obj/item/forensics/swab,
		/obj/item/storage/photo_album,
		/obj/item/clipboard,
		/obj/item/disk,
		/obj/item/pen,
		/obj/item/clothing/accessory/badge,
		/obj/item/pack,
		/obj/item/hand,
		/obj/item/key,
		/obj/item/paper_scanner
)


/obj/structure/filingcabinet/chestdrawer
	name = "chest drawer"
	icon_state = "chestdrawer"


/obj/structure/filingcabinet/filingcabinet	//not changing the path to avoid unecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"

/obj/structure/filingcabinet/Initialize(mapload)
	. = ..()
	if(mapload && SSpersistence.map_supports_persistence && is_station_level(z))
		persistent_storage_id = "[x],[y],[z],[type]"
		for(var/obj/item/paper/paper in SSpersistence.object_track_register)
			if(paper.persistent_filing_cabinet_id == persistent_storage_id)
				paper.forceMove(src)
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/paper))
			var/obj/item/paper/tracked_paper = I
			if(tracked_paper.persistent_objects_track_active && !is_long_term_paper(tracked_paper))
				continue
		if(is_type_in_list(I, accepted_items))
			I.forceMove(src)

/// Whether a paper's saved persistence data associates it with this cabinet's long-term storage.
/obj/structure/filingcabinet/proc/is_long_term_paper(obj/item/item)
	if(!persistent_storage_id || !istype(item, /obj/item/paper))
		return FALSE
	var/obj/item/paper/paper = item
	return paper.persistent_filing_cabinet_id == persistent_storage_id

/obj/structure/filingcabinet/attackby(obj/item/attacking_item, mob/user)
	if(is_type_in_list(attacking_item, accepted_items))
		if(istype(attacking_item, /obj/item/paper))
			var/obj/item/paper/paper = attacking_item
			paper.persistent_filing_cabinet_id = null
			SSpersistence.objectsDeregisterTrack(paper)
		to_chat(user, SPAN_NOTICE("You put [attacking_item] in [src]."))
		user.drop_from_inventory(attacking_item, src)
		flick("[initial(icon_state)]-open", src)
		playsound(loc, 'sound/items/bureaucracy/filingcabinet.ogg', 50, 1)
		sleep(40)
		icon_state = initial(icon_state)
		SStgui.update_uis(src)
	else if(attacking_item.tool_behaviour == TOOL_WRENCH)
		attacking_item.play_tool_sound(get_turf(src), 50)
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src]."))
	else
		to_chat(user, SPAN_NOTICE("You can't put [attacking_item] in [src]!"))

/obj/structure/filingcabinet/on_death(damage, damage_flags, damage_type, armor_penetration, obj/weapon)
	for(var/obj/item/thing in src)
		if(prob(25))
			if(istype(thing, /obj/item/paper))
				if(prob(50))
					var/obj/item/paper/paper = thing
					paper.crumple()
			thing.forceMove(get_turf(src))
	. = ..()

/obj/structure/filingcabinet/attack_hand(mob/user as mob)
	user.set_machine(src)
	ui_interact(user)

/obj/structure/filingcabinet/do_simple_ranged_interaction(mob/user)
	ui_interact(user)

/obj/structure/filingcabinet/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FilingCabinet", name)
		ui.open()

/obj/structure/filingcabinet/ui_data(mob/user)
	var/list/data = list()
	var/list/general = list()
	var/list/long_term = list()

	for(var/obj/item/item in contents)
		var/list/item_data = list(
			"name" = item.name,
			"ref" = REF(item),
			"can_archive" = istype(item, /obj/item/paper)
		)
		if(is_long_term_paper(item))
			long_term += list(item_data)
		else
			general += list(item_data)

	data["general"] = general
	data["long_term"] = long_term
	data["supports_persistence"] = !!persistent_storage_id
	var/obj/item/paper/paper_type = /obj/item/paper
	data["persistence_days"] = initial(paper_type.persistent_objects_expiration_time_days)
	return data

/obj/structure/filingcabinet/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!Adjacent(usr))
		return

	var/obj/item/item = locate(params["ref"])
	if(!istype(item) || item.loc != src)
		return

	switch(action)
		if("retrieve")
			if(is_long_term_paper(item))
				var/obj/item/paper/retrieved_paper = item
				retrieved_paper.persistent_filing_cabinet_id = null
				SSpersistence.objectsDeregisterTrack(retrieved_paper)
			usr.put_in_hands(item)
			flick("[initial(icon_state)]-open", src)
			playsound(loc, 'sound/items/bureaucracy/filingcabinet.ogg', 50, 1)
			addtimer(CALLBACK(src, PROC_REF(reset_icon_state)), 2 SECONDS)
			return TRUE

		if("archive")
			if(!persistent_storage_id || !istype(item, /obj/item/paper) || is_long_term_paper(item))
				return
			var/obj/item/paper/archived_paper = item
			archived_paper.persistent_filing_cabinet_id = persistent_storage_id
			SSpersistence.objectsRegisterTrack(archived_paper, ckey(usr.key))
			return TRUE

		if("unarchive")
			if(!is_long_term_paper(item))
				return
			var/obj/item/paper/unarchived_paper = item
			unarchived_paper.persistent_filing_cabinet_id = null
			SSpersistence.objectsDeregisterTrack(unarchived_paper)
			return TRUE

/obj/structure/filingcabinet/proc/reset_icon_state()
	icon_state = initial(icon_state)


/*
 * Security Record Cabinets
 */
/obj/structure/filingcabinet/security
	var/virgin = 1


/obj/structure/filingcabinet/security/proc/populate()
	if(virgin)
		for(var/datum/record/general/R in SSrecords.records)
			if(istype(R) && istype(R.security))
				var/obj/item/paper/P = new /obj/item/paper(src)
				P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
				P.info += {"
Name: [R.name] ID: [R.id]<BR>
Sex: [R.sex]<BR>
Age: [R.age]<BR>
Fingerprint: [R.fingerprint]<BR>
Physical Status: [R.physical_status]<BR>
Mental Status: [R.mental_status]<BR>
<BR>
<CENTER><B>Security Data</B></CENTER><BR>
Criminal Status: [R.security.criminal]<BR><BR>
Crimes: [R.security.crimes]<BR><BR>
Important Notes:<BR>
\t[replacetext(R.security.notes, "\n", "<BR>")]<BR>\n<BR>
<CENTER><B>Comments/Log</B></CENTER><BR>
"}
				for(var/comment in R.security.comments)
					P.info += "[comment]<BR>"
				P.info += "</TT>"
				P.name = "Security Record ([R.name])"
				virgin = 0	//tabbing here is correct- it's possible for people to try and use it
							//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/security/attack_hand()
	populate()
	..()

/obj/structure/filingcabinet/security/do_simple_ranged_interaction(var/mob/user)
	populate()
	..()

/*
 * Medical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	var/virgin = 1

/obj/structure/filingcabinet/medical/proc/populate()
	if(virgin)
		for(var/datum/record/general/R in SSrecords.records)
			if(istype(R) && istype(R.medical))
				var/obj/item/paper/P = new /obj/item/paper(src)
				var/info = "<CENTER><B>Medical Record</B></CENTER><BR>"
				info += {"
Name: [R.name] ID: [R.id]<BR>
Sex: [R.sex]<BR>
Age: [R.age]<BR>
Fingerprint: [R.fingerprint]<BR>
Physical Status: [R.physical_status]<BR>
Mental Status: [R.mental_status]<BR>
<BR>
<CENTER><B>Medical Data</B></CENTER><BR>
Blood Type: [R.medical.blood_type]<BR>
DNA: [R.medical.blood_dna]<BR><BR>
Important Notes:<BR>
[replacetext(R.medical.notes, "\n", "<BR>")]<BR><BR>
<CENTER><B>Comments/Log</B></CENTER><BR>
"}
				for(var/comment in R.medical.comments)
					info += "[comment]<BR>"
				info += "</TT>"
				var/pname = "Medical Record ([R.name])"
				P.set_content_unsafe(pname, info)
			virgin = 0	//tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/medical/attack_hand()
	populate()
	..()

/obj/structure/filingcabinet/medical/do_simple_ranged_interaction(var/mob/user)
	populate()
	..()
