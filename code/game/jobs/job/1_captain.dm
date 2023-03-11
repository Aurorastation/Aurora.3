var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	departments = list(DEPARTMENT_COMMAND = JOBROLE_SUPERVISOR)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#334E6D"
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	minimum_character_age = list(
		SPECIES_HUMAN = 35,
		SPECIES_SKRELL = 100,
		SPECIES_SKRELL_AXIORI = 100
	)

	ideal_character_age = list(
		SPECIES_HUMAN = 70,
		SPECIES_SKRELL = 120,
		SPECIES_SKRELL_AXIORI = 120
	) // Old geezer captains ftw

	outfit = /datum/outfit/job/captain

	blacklisted_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_DIONA, SPECIES_DIONA_COEUS)

/datum/outfit/job/captain
	name = "Captain"
	jobtype = /datum/job/captain

	uniform = /obj/item/clothing/under/scc_captain
	shoes = /obj/item/clothing/shoes/laceup/brown
	head = /obj/item/clothing/head/caphat/scc
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id/gold

	headset = /obj/item/device/radio/headset/heads/captain
	bowman = /obj/item/device/radio/headset/heads/captain/alt
	double_headset = /obj/item/device/radio/headset/alt/double/captain
	wrist_radio = /obj/item/device/radio/headset/wrist/captain

	tab_pda = /obj/item/modular_computer/handheld/pda/command/captain
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/command/captain
	tablet = /obj/item/modular_computer/handheld/preset/command/captain

	backpack_contents = list(
		/obj/item/storage/box/ids = 1
	)

	implants = list(
		/obj/item/implant/mindshield
	)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	dufflebag = /obj/item/storage/backpack/duffel/cap
	messengerbag = /obj/item/storage/backpack/messenger/com

/datum/outfit/job/captain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H && H.w_uniform)
		var/obj/item/clothing/under/U = H.w_uniform
		var/obj/item/clothing/accessory/medal/gold/captain/medal = new()
		U.attach_accessory(null, medal)

	return TRUE

/datum/job/captain/get_access()
	return get_all_station_access()

/datum/job/captain/announce(mob/living/carbon/human/H)
	. = ..()
	captain_announcement.Announce("All hands, Captain [H.real_name] on deck!")
	callHook("captain_spawned", list(H))

/datum/job/bridge_crew
	title = "Bridge Crew"
	flag = BRIDGE_CREW
	departments = SIMPLEDEPT(DEPARTMENT_COMMAND_SUPPORT)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	intro_prefix = "the"
	supervisors = "the executive officer and the captain"
	selection_color = "#29405A"
	minimal_player_age = 20
	economic_modifier = 5
	ideal_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 75,
		SPECIES_SKRELL_AXIORI = 75
	)

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)

	outfit = /datum/outfit/job/bridge_crew

	access = list(access_eva, access_heads, access_maint_tunnels, access_weapons, access_bridge_crew, access_intrepid, access_teleporter)
	minimal_access = list(access_heads, access_eva, access_gateway, access_weapons, access_bridge_crew, access_intrepid, access_teleporter)

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/bridge_crew
	name = "Bridge Crew"
	jobtype = /datum/job/bridge_crew

	head = /obj/item/clothing/head/caphat/bridge_crew
	uniform = /obj/item/clothing/under/rank/bridge_crew
	shoes = /obj/item/clothing/shoes/laceup

	headset = /obj/item/device/radio/headset/headset_com
	bowman = /obj/item/device/radio/headset/headset_com/alt
	double_headset = /obj/item/device/radio/headset/alt/double/command
	wrist_radio = /obj/item/device/radio/headset/wrist/command
	messengerbag = /obj/item/storage/backpack/messenger/com

/datum/job/hra
	title = "Human Resources"
	faction = "Station"
	flag = HRA
	departments = SIMPLEDEPT(DEPARTMENT_COMMAND_SUPPORT)
	department_flag = ENGSEC
	total_positions = 2
	spawn_positions = 0
	supervisors = "SCC and the Internal Affairs department"
	minimal_player_age = 10
	economic_modifier = 10
	ideal_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	selection_color = "#29405A"

	access = list(access_sec_doors, access_medical, access_engine, access_eva, access_heads, access_maint_tunnels,
			            access_construction, access_research, access_gateway, access_weapons, access_bridge_crew, access_intrepid, access_cent_ccia)
	minimal_access = list(access_sec_doors, access_medical, access_engine, access_eva, access_heads, access_maint_tunnels,
			            access_construction, access_research, access_gateway, access_weapons, access_bridge_crew, access_intrepid, access_cent_ccia)

	outfit = /datum/outfit/job/hra
	blacklisted_species = list(SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_DIONA, SPECIES_DIONA_COEUS)


/datum/outfit/job/hra
	name = "Human Resources"
	jobtype = /datum/job/hra

	uniform = /obj/item/clothing/under/rank/scc2
	suit = /obj/item/clothing/suit/storage/toggle/armor/vest/scc
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/white
	accessory = /obj/item/clothing/accessory/tie/corporate/scc
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	head = /obj/item/clothing/head/beret/scc

	headset = /obj/item/device/radio/headset/representative
	bowman = /obj/item/device/radio/headset/representative/alt
	double_headset = /obj/item/device/radio/headset/alt/double/command/representative
	wrist_radio = /obj/item/device/radio/headset/wrist/command/representative

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian/lawyer
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/lawyer
	tablet = /obj/item/modular_computer/handheld/preset/civilian/lawyer

	l_pocket = /obj/item/reagent_containers/spray/pepper
	r_pocket = /obj/item/device/taperecorder/cciaa
	l_hand = /obj/item/storage/lockbox/cciaa
	id = /obj/item/card/id/gold


/datum/job/representative
	title = "Corporate Liaison"
	flag = LAWYER
	departments = SIMPLEDEPT(DEPARTMENT_COMMAND_SUPPORT)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials"
	selection_color = "#29405A"
	economic_modifier = 15

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 80,
		SPECIES_SKRELL_AXIORI = 80
	)

	access = list(access_lawyer, access_maint_tunnels)
	minimal_access = list(access_lawyer)
	alt_titles = list(
		"Workplace Liaison",
		"Corporate Representative",
		"Corporate Executive"
		)
	outfit = /datum/outfit/job/representative
	blacklisted_species = list(SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

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
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your embassy"
	selection_color = "#29405A"
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

	access = list(access_consular, access_maint_tunnels)
	minimal_access = list(access_consular)
	outfit = /datum/outfit/job/representative/consular
	blacklisted_species = list(SPECIES_VAURCA_BULWARK)

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
