/****************
* Announcements *
*****************/
/datum/uplink_item/abstract/announcements
	category = /datum/uplink_category/services

/datum/uplink_item/abstract/announcements/buy(var/obj/item/device/uplink/U, var/mob/user)
	. = ..()
	if(.)
		log_and_message_admins("has triggered a falsified [src]", user)

/datum/uplink_item/abstract/announcements/fake_centcom/New()
	..()
	name = "[SSatlas.current_map.boss_name] Update Announcement"
	telecrystal_cost = 5
	bluecrystal_cost = 5
	desc = "Causes a falsified [SSatlas.current_map.boss_name] Update. Triggers immediately after supplying additional data."

/datum/uplink_item/abstract/announcements/fake_centcom/extra_args(var/mob/user)
	var/title = tgui_input_text(user, "Enter your announcement title.", "Announcement Title", encode = FALSE)
	if(!title)
		return
	var/message = tgui_input_text(user, "Enter your announcement message.", "Announcement Title", multiline = TRUE, encode = FALSE)
	if(!message)
		return
	return list("title" = strip_html_readd_newlines(title), "message" = strip_html_readd_newlines(message))

/datum/uplink_item/abstract/announcements/fake_centcom/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/user, var/list/arguments)
	command_announcement.Announce(arguments["message"], arguments["title"], do_newscast=1, do_print=1, msg_sanitized=TRUE)
	return TRUE

/datum/uplink_item/abstract/announcements/fake_crew_arrival
	name = "Crew Arrival Announcement/Records"
	desc = "Creates a fake crew arrival announcement as well as fake crew records, using your current appearance (including held items!) and worn id card. Trigger with care!"
	telecrystal_cost = 4
	bluecrystal_cost = 4

/datum/uplink_item/abstract/announcements/fake_crew_arrival/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/user, var/list/arguments)
	if(!user)
		return 0

	var/obj/item/card/id/I = user.GetIdCard()
	var/datum/record/general/random_record
	if(SSrecords.records.len)
		random_record = pick(SSrecords.records)
	else
		random_record = new(user)

	var/datum/record/general/record = random_record.Copy()

	if(I)
		record.age = I.age
		record.name = I.registered_name
		record.sex = I.sex
		record.employer = I.employer_faction
		var/datum/faction/id_faction = SSjobs.name_factions[I.employer_faction]
		var/faction_abbreviation = id_faction.title_suffix
		var/assignment = "[I.assignment][ faction_abbreviation ? " ([faction_abbreviation])" : ""]"
		record.rank = assignment
		record.real_rank = assignment
	else
		var/mob/living/carbon/human/H
		if(istype(user,/mob/living/carbon/human))
			H = user
			record.age = H.age
			record.employer = H.employer_faction
		else
			record.age = initial(H.age)
		var/assignment = GetAssignment(user)
		record.rank = assignment
		record.real_rank = assignment
		record.name = user.real_name
		record.sex = capitalize(user.gender)

	record.species = user.get_species()
	record.security = new(null, record.id)

	if(I)
		record.fingerprint = I.fingerprint_hash
		record.medical.blood_type = I.blood_type
		record.medical.blood_dna = I.dna_hash

	SSrecords.add_record(record)
	AnnounceArrivalSimple(record.name, record.rank)
	return 1

/datum/uplink_item/abstract/announcements/fake_ion_storm
	var/static/cooldown = FALSE

/datum/uplink_item/abstract/announcements/fake_ion_storm/New()
	..()
	name = "Ion Storm Announcement"
	desc = "Interferes with the [SSatlas.current_map.station_short]'s ion sensors. Triggers immediately upon investment."
	telecrystal_cost = 2
	var/static/cooldown = FALSE

/datum/uplink_item/abstract/announcements/fake_ion_storm/get_goods(var/obj/item/device/uplink/U, var/loc)
	if(cooldown != TRUE)
		ion_storm_announcement()
		cooldown = TRUE
		addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), 24 SECONDS)
		return TRUE
	else
		to_chat(loc, SPAN_DANGER("This service is on cooldown! Try again in a bit!"))
		return 0

/datum/uplink_item/abstract/announcements/fake_ion_storm/proc/reset_cooldown()
	cooldown = FALSE

/datum/uplink_item/abstract/announcements/fake_radiation
	var/static/cooldown = FALSE

/datum/uplink_item/abstract/announcements/fake_radiation/New()
	..()
	name = "Radiation Storm Announcement"
	desc = "Interferes with the [SSatlas.current_map.station_short]'s radiation sensors. Triggers immediately upon investment."
	telecrystal_cost = 3
	var/static/cooldown = 0

/datum/uplink_item/abstract/announcements/fake_radiation/get_goods(var/obj/item/device/uplink/U, var/loc)
	if(cooldown != TRUE)
		var/datum/event_meta/EM = new(EVENT_LEVEL_MUNDANE, "Fake Radiation Storm", add_to_queue = 0)
		new/datum/event/radiation_storm/syndicate(EM)
		cooldown = TRUE
		addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), 24 SECONDS)
		return 1
	else
		to_chat(loc, SPAN_DANGER("This service is on cooldown! Try again in a bit!"))
		return 0

/datum/uplink_item/abstract/announcements/fake_radiation/proc/reset_cooldown()
	cooldown = FALSE
