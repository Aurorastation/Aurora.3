/datum/job/representative
	title = "Corporate Liaison"
	flag = LAWYER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 0
	spawn_positions = 1
	supervisors = "company officials"
	selection_color = "#C0C0C0"
	economic_modifier = 7
	latejoin_at_spawnpoints = TRUE

	minimum_character_age = 30

	access = list(access_lawyer, access_maint_tunnels)
	minimal_access = list(access_lawyer)
	outfit = /datum/outfit/job/representative
	alt_titles = list("Consular Officer")

	blacklisted_species = list("M'sai Tajara", "Zhan-Khazan Tajara", "Aut'akh Unathi")

/datum/job/representative/get_outfit(mob/living/carbon/human/H, alt_title = null)
	if(H.mind?.role_alt_title == "Consular Officer" || alt_title == "Consular Officer")
		var/datum/citizenship/citizenship = SSrecords.citizenships[H.citizenship]
		if(citizenship)
			return citizenship.consular_outfit
	else
		. = ..()

/datum/outfit/job/representative
	name = "NanoTrasen Corporate Liaison"
	jobtype = /datum/job/representative

	head = /obj/item/clothing/head/beret/liaison
	uniform = /obj/item/clothing/under/rank/liaison
	suit = /obj/item/clothing/suit/storage/toggle/liaison
	pda = /obj/item/device/pda/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_ear = /obj/item/device/radio/headset/representative
	l_hand =  /obj/item/storage/briefcase
	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1
	)

	implants = list(
		/obj/item/implant/mindshield
	)


/datum/outfit/job/representative/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H && !visualsOnly)
		addtimer(CALLBACK(src, .proc/send_representative_mission, H), 5 MINUTES)
	return TRUE

/datum/outfit/job/representative/proc/send_representative_mission(var/mob/living/carbon/human/H)
	var/faxtext = "<center><br><h2><br><b>Directives Report</h2></b></FONT size><HR></center>"
	faxtext += "<b><font face='Courier New'>Attention [name], the following directives are to be fulfilled during your stay in the station:</font></b><br><ul>"

	faxtext += "<li>[get_objectives(H, REPRESENTATIVE_MISSION_LOW)].</li>"

	if(prob(50))
		faxtext += "<li>[get_objectives(H, REPRESENTATIVE_MISSION_MEDIUM)].</li>"

	if(prob(25))
		faxtext += "<li>[get_objectives(H, REPRESENTATIVE_MISSION_HIGH)].</li>"

	for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if (F.department == "Representative's Office")
			var/obj/item/paper/P = new /obj/item/paper(get_turf(F))
			P.name = "[name] - Directives"
			P.info = faxtext
			P.update_icon()
	return

/datum/outfit/job/representative/proc/get_objectives(var/mob/living/carbon/human/H, var/mission_level)
	var/rep_objectives

	for (var/datum/faction/faction in SSjobs.factions)
		if (faction.name == H.employer_faction)
			var/datum/faction/selected_faction = faction

			rep_objectives = selected_faction.get_corporate_objectives(mission_level, H)

	return rep_objectives

/datum/outfit/job/representative/consular
	name = "Consular Officer"

	uniform = /obj/item/clothing/under/suit_jacket/navy
	head = null
	suit = null
	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1
	)
	implants = null

/datum/outfit/job/representative/consular/get_objectives(var/mob/living/carbon/human/H, var/mission_level)
	var/rep_objectives
	var/datum/citizenship/citizenship = SSrecords.citizenships[H.citizenship]
	if(citizenship)
		rep_objectives = citizenship.get_objectives(mission_level, H)

	return rep_objectives