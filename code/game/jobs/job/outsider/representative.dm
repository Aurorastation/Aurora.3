/datum/job/representative
	title = "Corporate Liaison"
	flag = LAWYER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials"
	selection_color = "#dddddd"
	economic_modifier = 7
	latejoin_at_spawnpoints = TRUE
	access = list(access_lawyer, access_maint_tunnels)
	minimal_access = list(access_lawyer)
	outfit = /datum/outfit/job/representative
	alt_titles = list("Tau Ceti Representative","Sol Consular Officer", "PRA Consular Officer")
	outfit = /datum/outfit/job/representative
	alt_outfits = list(
		"Tau Ceti Representative"=/datum/outfit/job/representative/ceti,
		"Sol Consular Officer"=/datum/outfit/job/representative/sol,
		"PRA Consular Officer"= /datum/outfit/job/representative/pra
		)

/datum/outfit/job/representative
	name = "Corporate Liaison"
	jobtype = /datum/job/representative

	head = /obj/item/clothing/head/beret/liaison
	uniform = /obj/item/clothing/under/rank/liaison
	suit = /obj/item/clothing/suit/storage/toggle/liaison
	pda = /obj/item/device/pda/lawyer
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_ear = /obj/item/device/radio/headset/representative
	l_hand =  /obj/item/weapon/storage/briefcase
	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/weapon/gun/energy/pistol = 1
	)

	implants = list(
		/obj/item/weapon/implant/loyalty
	)


/datum/outfit/job/representative/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H && !visualsOnly)
		addtimer(CALLBACK(src, .proc/send_representative_mission, H), 5 MINUTES)
	return TRUE

/datum/outfit/job/representative/proc/send_representative_mission(var/mob/living/carbon/human/H)
	var/faxtext = "<center><br><h2><br><b>Directives Report</h2></b></FONT size><HR></center>"
	faxtext += "<b><font face='Courier New'>Attention [name], the following directives are to be fulfilled during your stay in the station:</font></b><br><ul>"

	faxtext += "<li>[get_objectives(H, "low")].</li>"

	if(prob(50))
		faxtext += "<li>[get_objectives(H, "medium")].</li>"

	if(prob(25))
		faxtext += "<li>[get_objectives(H, "high")].</li>"

	for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if (F.department == "Representative's Office")
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(get_turf(F))
			P.name = "[name] - Directives"
			P.info = faxtext
			P.update_icon()
	return

/datum/outfit/job/representative/proc/get_objectives(var/mob/living/carbon/human/H, var/mission_level)
	var/rep_objectives

	for (var/datum/faction/faction in SSjobs.factions)
		if (faction.name == H.employer_faction)
			var/datum/faction/selected_faction = faction

			rep_objectives = selected_faction.get_corporate_objectives(mission_level)

	return rep_objectives

/datum/outfit/job/representative/ceti
	name = "Tau Ceti Representative"

	uniform = /obj/item/clothing/under/lawyer/blue
	head = null
	suit = null
	backpack_contents = list(
		/obj/item/clothing/accessory/tc_pin = 1,
		/obj/item/weapon/storage/box/ceti_visa = 1,
		/obj/item/weapon/gun/energy/pistol = 1
	)

	implants = null


/datum/outfit/job/representative/ceti/get_objectives(mob/living/carbon/human/H, mission_level)
	var/rep_objectives

	switch(mission_level)
		if("high")
			rep_objectives = pick("Compile and report and audit [rand(1,3)] suspicious indivduals who might be spies or otherwise act hostile against the Republic",
							"Have [rand(2,6)] crewmembers sign a pledge of loyalty to the Republic")

		if("medium")
			rep_objectives = pick("Sell [rand(2,5)] Tau Ceti residence visas to foreign employees, 2000 credits each.",
							"Convince [rand(3,6)] crewmembers of Tau Ceti superiority over the Sol Alliance")
		else
			rep_objectives = pick("Run a questionnaire on Tau Ceti citizens' views on synthetic citizenship",
							"Run a questionnaire on Tau Ceti citizens' views on vaurca citizenship")


	return rep_objectives

/datum/outfit/job/representative/sol
	name = "Sol Consular Officer"

	uniform = /obj/item/clothing/under/suit_jacket/navy
	head = null
	suit = null
	backpack_contents = list(
		/obj/item/clothing/accessory/sol_pin = 1,
		/obj/item/weapon/storage/box/sol_visa = 1,
		/obj/item/device/camera = 1,
		/obj/item/weapon/gun/projectile/pistol/sol = 1
	)

	implants = null

/datum/outfit/job/representative/sol/get_objectives(mob/living/carbon/human/H, mission_level)
	var/rep_objectives

	switch(mission_level)
		if("high")
			rep_objectives = pick("Collect evidence of NanoTrasen being unfair or oppressive against Solarian employees, to be used as leverage in future diplomatic talks",
							"Convince [rand(1,3)] solarian employees to apply for the solarian armed forces")

		if("medium")
			rep_objectives = pick("Have [rand(2,5)] amount of Sol citizens write down their grievances with the company, and present the report to station command",
							"Convince [rand(3,6)] human crewmembers to apply for solarian citizenship")
		else
			rep_objectives = pick("Collect [rand(3,7)] pictures of secure station areas",
							"Convince station command to turn a solarian crewmember's sentence into a fine.")

	return rep_objectives

/datum/outfit/job/representative/pra
	name = "PRA Consular Officer"

	uniform = /obj/item/clothing/under/suit_jacket/checkered
	head = /obj/item/clothing/head/fedora
	suit = null
	backpack_contents = list(
		/obj/item/clothing/accessory/hadii_pin = 1,
		/obj/item/weapon/storage/box/hadii_card = 1,
		/obj/item/weapon/storage/box/hadii_manifesto = 1,
		/obj/item/weapon/gun/projectile/pistol = 1
	)

	implants = null

/datum/outfit/job/representative/pra/get_objectives(mob/living/carbon/human/H, mission_level)
	var/rep_objectives

	switch(mission_level)
		if("high")
			rep_objectives = pick("Collect evidence of NanoTrasen being unfair or oppressive against Tajaran employees, to be used as leverage in future diplomatic talks",
							"Compile a report on suspicious PRA citizens to be forwarded to authorities")

		if("medium")
			rep_objectives = pick("Sell [rand(3,6)] Party Membership Cards, 1000 credits each",
							"Have [rand(2,5)] PRA citizens to write down their grievances with the company, and present the report to station command",
							"Sell [rand(3,6)] copies of Hadiist manifesto, 30 credits each")
		else
			rep_objectives = pick("Ensure party loyalty for Tajara in prestigious positions",
							"Ensure [rand(2,5)] PRA citizens are secure and follow party lines.")

	return rep_objectives