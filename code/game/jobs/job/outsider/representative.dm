/datum/job/representative
	title = "Corporate Liaison"
	flag = LAWYER
	departments = SIMPLEDEPT(DEPARTMENT_COMMAND_SUPPORT)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "company officials"
	selection_color = "#6186cf"
	economic_modifier = 15

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 80,
		SPECIES_SKRELL_AXIORI = 80
	)

	access = list(ACCESS_LAWYER, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_LAWYER)
	alt_titles = list(
		"Workplace Liaison",
		"Corporate Representative",
		"Corporate Executive"
		)
	outfit = /datum/outfit/job/representative
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/job/consular/pre_spawn(mob/abstract/new_player/player)
	var/datum/faction/faction = SSjobs.name_factions[player.client.prefs.faction]
	LAZYREMOVE(faction.allowed_role_types, REPRESENTATIVE_ROLE)

/datum/job/representative/after_spawn(mob/living/carbon/human/H)
	var/datum/faction/faction = SSjobs.GetFaction(H)
	LAZYREMOVE(faction.allowed_role_types, REPRESENTATIVE_ROLE)

/datum/job/representative/on_despawn(mob/living/carbon/human/H)
	var/datum/faction/faction = SSjobs.GetFaction(H)
	LAZYDISTINCTADD(faction.allowed_role_types, REPRESENTATIVE_ROLE)

/datum/outfit/job/representative
	name = "NanoTrasen Corporate Liaison"
	var/fax_department = "Representative's Office"
	jobtype = /datum/job/representative

	head = /obj/item/clothing/head/beret/corporate
	uniform = /obj/item/clothing/under/rank/liaison
	suit = /obj/item/clothing/suit/storage/liaison
	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/lawyer
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/lawyer
	tablet = /obj/item/modular_computer/handheld/preset/civilian/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	headset = /obj/item/device/radio/headset/representative
	bowman = /obj/item/device/radio/headset/representative/alt
	double_headset = /obj/item/device/radio/headset/alt/double/command/representative
	wrist_radio = /obj/item/device/radio/headset/wrist/command/representative
	accessory = /obj/item/clothing/accessory/tie/corporate
	suit_accessory = /obj/item/clothing/accessory/pin/corporate

	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1
	)

/datum/outfit/job/representative/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H && !visualsOnly)
		addtimer(CALLBACK(src, PROC_REF(send_representative_mission), H), 5 MINUTES)
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
		if (F.department == fax_department)
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

/datum/job/consular
	title = "Consular Officer"
	flag = CONSULAR
	departments = SIMPLEDEPT(DEPARTMENT_COMMAND_SUPPORT)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "your embassy"
	selection_color = "#6186cf"
	economic_modifier = 15

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 150,
		SPECIES_SKRELL_AXIORI = 150
	)

	ideal_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 170,
		SPECIES_SKRELL_AXIORI = 170
	)

	access = list(ACCESS_CONSULAR, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_CONSULAR)
	outfit = /datum/outfit/job/representative/consular
	blacklisted_species = list(SPECIES_VAURCA_BULWARK)
	blacklisted_citizenship = list(CITIZENSHIP_SOL, CITIZENSHIP_ERIDANI, CITIZENSHIP_ELYRA_NCP, CITIZENSHIP_NONE, CITIZENSHIP_FREE_COUNCIL)

/datum/job/consular/get_outfit(mob/living/carbon/human/H, alt_title = null)
	var/datum/citizenship/citizenship = SSrecords.citizenships[H.citizenship]
	if(citizenship)
		return citizenship.consular_outfit

/datum/outfit/job/representative/consular
	name = "Consular Officer"
	fax_department = "Consular's Office"
	jobtype = /datum/job/consular

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

/datum/job/consular/pre_spawn(mob/abstract/new_player/player)
	var/datum/citizenship/citizenship = SSrecords.citizenships[player.client.prefs.citizenship]
	LAZYDISTINCTADD(blacklisted_citizenship, citizenship.name)

/datum/job/consular/after_spawn(mob/living/carbon/human/H)
	var/datum/citizenship/citizenship = SSrecords.citizenships[H.citizenship]
	LAZYDISTINCTADD(blacklisted_citizenship, citizenship.name)

/datum/job/consular/on_despawn(mob/living/carbon/human/H)
	var/datum/citizenship/citizenship = SSrecords.citizenships[H.citizenship]
	LAZYREMOVE(blacklisted_citizenship, citizenship.name)
