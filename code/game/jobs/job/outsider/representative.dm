/datum/job/journalist
	title = "Corporate Reporter"
	flag = JOURNALIST
	departments = SIMPLEDEPT(DEPARTMENT_CIVILIAN)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials"
	selection_color = "#6186cf"

	minimum_character_age = list(
		SPECIES_HUMAN = 20,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(ACCESS_JOURNALIST, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_JOURNALIST, ACCESS_MAINT_TUNNELS)
	alt_titles = list("Freelance Journalist")
	alt_outfits = list("Freelance Journalist" = /obj/outfit/job/journalistf)
	title_accesses = list("Corporate Reporter" = list(ACCESS_MEDICAL, ACCESS_SEC_DOORS, ACCESS_RESEARCH, ACCESS_ENGINE))
	outfit = /obj/outfit/job/journalist
	blacklisted_species = list(SPECIES_VAURCA_BREEDER)

/obj/outfit/job/journalist
	name = "Corporate Reporter"
	jobtype = /datum/job/journalist

	uniform = /obj/item/clothing/under/suit_jacket/red
	shoes = /obj/item/clothing/shoes/sneakers/black

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/librarian
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/librarian
	tablet = /obj/item/modular_computer/handheld/preset/civilian/librarian

	headset = /obj/item/device/radio/headset/headset_service
	bowman = /obj/item/device/radio/headset/headset_service/alt
	double_headset = /obj/item/device/radio/headset/alt/double/service
	wrist_radio = /obj/item/device/radio/headset/wrist/service

	backpack_faction = /obj/item/storage/backpack/nt
	satchel_faction = /obj/item/storage/backpack/satchel/nt
	dufflebag_faction = /obj/item/storage/backpack/duffel/nt
	messengerbag_faction = /obj/item/storage/backpack/messenger/nt

	backpack_contents = list(
		/obj/item/clothing/accessory/badge/press = 1,
		/obj/item/device/tvcamera = 1
	)

/obj/outfit/job/journalistf
	name = "Freelance Journalist"
	jobtype = /datum/job/journalist

	uniform = /obj/item/clothing/under/suit_jacket/red
	shoes = /obj/item/clothing/shoes/sneakers/black

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/librarian
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/librarian
	tablet = /obj/item/modular_computer/handheld/preset/civilian/librarian

	backpack_contents = list(
		/obj/item/clothing/accessory/badge/press/independent = 1,
		/obj/item/device/tvcamera = 1
	)

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
	outfit = /obj/outfit/job/representative
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

/obj/outfit/job/representative
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

/obj/outfit/job/representative/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H && !visualsOnly)
		addtimer(CALLBACK(src, PROC_REF(send_representative_mission), H), 5 MINUTES)
	return TRUE

/obj/outfit/job/representative/proc/send_representative_mission(var/mob/living/carbon/human/H)
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

/obj/outfit/job/representative/proc/get_objectives(var/mob/living/carbon/human/H, var/mission_level)
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

	access = list(ACCESS_CONSULAR, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_CONSULAR)
	outfit = /obj/outfit/job/representative/consular
	blacklisted_species = list(SPECIES_VAURCA_BULWARK)
	blacklisted_citizenship = list(CITIZENSHIP_SOL, CITIZENSHIP_ERIDANI, CITIZENSHIP_ELYRA_NCP, CITIZENSHIP_NONE, CITIZENSHIP_FREE_COUNCIL)

/datum/job/consular/get_outfit(mob/living/carbon/human/H, alt_title = null)
	var/datum/citizenship/citizenship = SSrecords.citizenships[H.citizenship]
	if(citizenship)
		return citizenship.consular_outfit

/obj/outfit/job/representative/consular
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

/obj/outfit/job/representative/consular/get_objectives(var/mob/living/carbon/human/H, var/mission_level)
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
	add_verb(H, /mob/living/carbon/human/proc/summon_goon)

/datum/job/consular/on_despawn(mob/living/carbon/human/H)
	var/datum/citizenship/citizenship = SSrecords.citizenships[H.citizenship]
	LAZYREMOVE(blacklisted_citizenship, citizenship.name)
	var/datum/job/J = SSjobs.GetJob("Diplomatic Aide")
	if(citizenship.linked_citizenship)
		LAZYDISTINCTADD(J.blacklisted_citizenship, citizenship.linked_citizenship)
	else
		LAZYDISTINCTADD(J.blacklisted_citizenship, H.citizenship)
	if(J.total_positions > 0)
		J.total_positions--

/mob/living/carbon/human/proc/summon_goon()
	set name = "Open Aide Slot"
	set desc = "Allows a diplomatic aide to join you as an assistant, companion, or bodyguard."
	set category = "Consular"

	if(alert(src, "Are you sure you want to open an assistant slot? This can only be used once", "Open Aide Slot", "No", "Yes") != "Yes")
		return
	var/datum/job/J = SSjobs.GetJob("Diplomatic Aide")
	var/datum/citizenship/citizenship = SSrecords.citizenships[src.citizenship]
	if(citizenship.linked_citizenship) //if there's a secondary citizenship that this one should allow - e.g zo'ra and biesel
		LAZYREMOVE(J.blacklisted_citizenship, citizenship.linked_citizenship)
	else
		LAZYREMOVE(J.blacklisted_citizenship, src.citizenship)
	J.total_positions++
	to_chat(src, SPAN_NOTICE("A slot for a diplomatic aide has been opened."))
	remove_verb(src, /mob/living/carbon/human/proc/summon_goon)

/datum/job/consular_assistant
	title = "Diplomatic Aide"
	flag = CONSULAR_ASST
	departments = SIMPLEDEPT(DEPARTMENT_COMMAND_SUPPORT)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 0 //manually opened by consular
	spawn_positions = 0
	supervisors = "the Consular Officer"
	selection_color = "#6186cf"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(ACCESS_CONSULAR, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_CONSULAR)
	outfit = /obj/outfit/job/consular_assistant
	blacklisted_citizenship = ALL_CITIZENSHIPS //removed based on consular citizensihp

/datum/job/consular_assistant/get_outfit(mob/living/carbon/human/H, alt_title = null)
	var/datum/citizenship/citizenship = SSrecords.citizenships[H.citizenship]
	if(citizenship)
		return citizenship.assistant_outfit

/obj/outfit/job/consular_assistant
	name = "Diplomatic Aide"
	jobtype = /datum/job/consular_assistant

	uniform = /obj/item/clothing/under/suit_jacket/navy
	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/lawyer
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/lawyer
	tablet = /obj/item/modular_computer/handheld/preset/civilian/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	headset = /obj/item/device/radio/headset/representative
	bowman = /obj/item/device/radio/headset/representative/alt
	double_headset = /obj/item/device/radio/headset/alt/double/command/representative
	wrist_radio = /obj/item/device/radio/headset/wrist/command/representative

/datum/job/consular_assistant/after_spawn(mob/living/carbon/human/H)
	LAZYDISTINCTADD(blacklisted_citizenship, H.citizenship)
