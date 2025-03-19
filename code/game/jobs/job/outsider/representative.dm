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
	alt_factions = list(
		"Corporate Reporter" = list("NanoTrasen", "Idris Incorporated", "Hephaestus Industries", "Orion Express", "Zavodskoi Interstellar", "Zeng-Hu Pharmaceuticals", "Private Military Contracting Group", "Stellar Corporate Conglomerate"),
		"Freelance Journalist" = list("Independent")
	)
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

	aide_job = "Corporate Aide"

/datum/job/representative/after_spawn(mob/living/carbon/human/H)
	var/datum/faction/faction = SSjobs.GetFaction(H)
	LAZYREMOVE(faction.allowed_role_types, REPRESENTATIVE_ROLE)
	add_verb(H, /mob/living/carbon/human/proc/summon_aide)

/datum/job/representative/on_despawn(mob/living/carbon/human/H)
	var/datum/faction/faction = SSjobs.GetFaction(H)
	LAZYDISTINCTADD(faction.allowed_role_types, REPRESENTATIVE_ROLE)

	// Handle the removal of aide blacklists and the slot.
	var/datum/job/J = SSjobs.GetJob(aide_job)
	close_aide_slot(H, J)

/datum/job/representative/post_open_aide_slot(mob/living/carbon/human/representative, datum/job/aide)
	var/datum/faction/rep_faction = SSjobs.name_factions[representative.employer_faction]

	// This is some unfortunately necessary mega snowflake code, because job and faction species blacklists aren't mirrored.
	// Factions utilize a datum-based whitelist, whereas jobs utilise a define-based blacklist...
	for(var/species_name in ALL_SPECIES)
		var/datum/species/species = GLOB.all_species[species_name]
		if(species.type in rep_faction.allowed_species_types)
			continue
		LAZYDISTINCTADD(aide.blacklisted_species, species.name)
	LAZYDISTINCTADD(rep_faction.allowed_role_types, aide.type)

/datum/job/representative/close_aide_slot(mob/living/carbon/human/representative, datum/job/aide)
	aide.blacklisted_species = null
	if(aide.total_positions > 0)
		aide.total_positions--

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
	faxtext += "<b><font face='Courier New'>Attention [name], the following directives are to be fulfilled during your stay on the [station_name()]:</font></b><br><ul>"

	faxtext += "<li>[get_objectives(H, REPRESENTATIVE_MISSION_LOW)].</li>"

	if(prob(50))
		faxtext += "<li>[get_objectives(H, REPRESENTATIVE_MISSION_MEDIUM)].</li>"

	if(prob(25))
		faxtext += "<li>[get_objectives(H, REPRESENTATIVE_MISSION_HIGH)].</li>"

	for (var/obj/machinery/photocopier/faxmachine/F in GLOB.allfaxes)
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

	aide_job = "Diplomatic Aide"

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
	add_verb(H, /mob/living/carbon/human/proc/summon_aide)

/datum/job/consular/on_despawn(mob/living/carbon/human/H)
	var/datum/citizenship/citizenship = SSrecords.citizenships[H.citizenship]
	LAZYREMOVE(blacklisted_citizenship, citizenship.name)

	// Handle the removal of aide blacklists and the slot.
	var/datum/job/J = SSjobs.GetJob(aide_job)
	close_aide_slot(H, J)

/datum/job/consular/post_open_aide_slot(mob/living/carbon/human/representative, datum/job/aide)
	var/datum/citizenship/citizenship = SSrecords.citizenships[representative.citizenship]
	if(citizenship.linked_citizenship) //if there's a secondary citizenship that this one should allow - e.g zo'ra and biesel
		LAZYREMOVE(aide.blacklisted_citizenship, citizenship.linked_citizenship)
	else
		LAZYREMOVE(aide.blacklisted_citizenship, representative.citizenship)

/datum/job/consular/close_aide_slot(mob/living/carbon/human/representative, datum/job/aide)
	var/datum/citizenship/citizenship = SSrecords.citizenships[representative.citizenship]
	if(citizenship.linked_citizenship)
		LAZYDISTINCTADD(aide.blacklisted_citizenship, citizenship.linked_citizenship)
	else
		LAZYDISTINCTADD(aide.blacklisted_citizenship, representative.citizenship)

	if(aide.total_positions > 0)
		aide.total_positions--

/datum/job/diplomatic_aide
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
	outfit = /obj/outfit/job/diplomatic_aide
	blacklisted_citizenship = ALL_CITIZENSHIPS //removed based on consular citizensihp

/datum/job/diplomatic_aide/get_outfit(mob/living/carbon/human/H, alt_title = null)
	var/datum/citizenship/citizenship = SSrecords.citizenships[H.citizenship]
	if(citizenship)
		return citizenship.assistant_outfit

/obj/outfit/job/diplomatic_aide
	name = "Diplomatic Aide"
	jobtype = /datum/job/diplomatic_aide

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

/datum/job/diplomatic_aide/after_spawn(mob/living/carbon/human/H)
	LAZYDISTINCTADD(blacklisted_citizenship, H.citizenship)

/datum/job/corporate_aide
	title = "Corporate Aide"
	flag = DIPLOMAT_AIDE
	departments = SIMPLEDEPT(DEPARTMENT_COMMAND_SUPPORT)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 0 //manually opened by representative
	spawn_positions = 0
	supervisors = "the Corporate Representative"
	selection_color = "#6186cf"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(ACCESS_LAWYER, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_LAWYER)
	outfit = /obj/outfit/job/diplomatic_aide

/datum/job/corporate_aide/get_outfit(mob/living/carbon/human/H, alt_title = null)
	var/datum/faction/aide_faction = SSjobs.name_factions[H.employer_faction]
	if(aide_faction)
		return aide_faction.titles_to_loadout["Off-Duty Crew Member"]

/obj/outfit/job/corporate_aide
	name = "Corporate Aide"
	jobtype = /datum/job/corporate_aide

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
