/datum/citizenship/pra
	name = CITIZENSHIP_PRA
	description = "Lead by President Njadrasanukii Hadii, the People's Republic of Adhomai are considered the 'loyalist' faction on Adhomai and enjoy galactic recognition as the \
	government of Adhomai. It claims to be the true keeper of Al'marii's legacy. However, the PRA can be described as a Hadiist branch of Al'marii's revolutionary ideology - that means \
	putting the State at the top of a hierarchy of power. The PRA is a very centralized state, but in recent years has slowly been able to start making true its promises to bring \
	revolution to the masses. With land reform, enfranchisement of women and peasantry, literacy initiatives, and the collectivization of farms and the means of production, the PRA is \
	struggling to hold true to its radical ideals while an entrenched upper party stubbornly tries to hold onto power."
	consular_outfit = /datum/outfit/job/representative/consular/pra

/datum/citizenship/pra/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of NanoTrasen being unfair or oppressive against Tajaran employees, to be used as leverage in future diplomatic talks",
							"Compile a report on suspicious PRA citizens to be forwarded to authorities")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Sell [rand(3,6)] Party Membership Cards, 300 credits each",
							"Have [rand(2,5)] PRA citizens to write down their grievances with the company, and present the report to station command",
							"Sell [rand(3,6)] copies of Hadiist manifesto, 30 credits each")
		else
			rep_objectives = pick("Ensure Party loyalty for Tajara in prestigious positions",
							"Ensure [rand(2,5)] PRA citizens are secure and follow Party guidelines")

	return rep_objectives

/datum/outfit/job/representative/consular/pra
	name = "PRA Consular Officer"

	glasses = null
	uniform = /obj/item/clothing/under/tajaran/consular
	head = /obj/item/clothing/head/tajaran/consular
	backpack_contents = list(
		/obj/item/storage/box/hadii_card = 1,
		/obj/item/storage/box/hadii_manifesto = 1,
		/obj/item/gun/projectile/pistol/adhomai = 1,
		/obj/item/storage/field_ration = 1
	)
	accessory = /obj/item/clothing/accessory/hadii_pin

/datum/citizenship/dpra
	name = CITIZENSHIP_DPRA
	description = "The most pervasive and successful rebellion came from a group calling themselves the Adhomai Liberation Army, a group made up of Tajara from almost every walk of life. \
	Opposing corporate claims on Tajaran soil and citing mismatched development and governmental negligence as the fault of humanity, they aim \
	to \"free Tajara from the new shackles imposed upon them by the corporate overlords and return Adhomai to a free, prosperous planet like our ancestors dreamed of.\" They named the \
	nation they were fighting for the Democratic People's Republic of Adhomai. The DPRA is now lead by Purrjar Almrah Harrlala who is struggling to transition what was once a militant \
	insurgency movement, then an organized military, into a modern, democratic nation. With the help of Nated as a government minister going out to negotiate with ruling Juntas to \
	voluntarily turn over power to civilian governments, the DPRA's future faces many fundamental changes."
	consular_outfit = /datum/outfit/job/representative/consular/dpra

/datum/citizenship/dpra/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of NanoTrasen being unfair or oppressive against Tajaran employees, to be used as leverage in future diplomatic talks",
							"Convince [rand(1,3)] republican citizen(s) to adopt Democratic People's Republic's citizenship")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Have [rand(2,5)] DPRA citizens to write down their grievances with the company, and present the report to station command",
							"Collect [rand(3,7)] pictures of secure station areas")
		else
			rep_objectives = pick("Ensure that DPRA citizens are following the principles of Al'mariism")

	return rep_objectives

/datum/outfit/job/representative/consular/dpra
	name = "DPRA Consular Officer"

	glasses = null
	uniform = /obj/item/clothing/under/tajaran/consular/dpra
	head = /obj/item/clothing/head/tajaran/consular/dpra
	backpack_contents = list(
		/obj/item/gun/projectile/silenced = 1,
		/obj/item/storage/field_ration = 1
	)
	accessory = /obj/item/clothing/accessory/dpra_pin

/datum/citizenship/nka
	name = CITIZENSHIP_NKA
	description = "The last major faction is the rebellious New Kingdom of Adhomai, which seceded and declared itself a nation in 2450. The New Kingdom is ruled by a Njarir'Akhran noble \
	line that survived the previous Revolution by remaining in hiding, owing to the efforts of their supporters. Ruled by King Vahzirthaamro Azunja specifically, he denounces both other \
	factions in the civil war as illegitimate and himself as the only legitimate ruler of Adhomai. Supporters of the New Kingdom tend to be rare outside lands it controls. However, \
	they believe strongly that the current republic on Adhomai was founded on genocide and unspeakable slaughters. The New Kingdom puts forth the ideology that Republicanism is \
	bloodshed. The only way to return Adhomai to peace and prosperity is to learn from the mistakes of the ancient nobles and Republicans, and create a new noble dynasty. They believe \
	this dynasty should rule as a constitutional monarchy in order to prevent abuses of power. In reality, this has proven very difficult, especially with the realities of war. \
	The lofty titles of the nobles disguise the fact that most of the nobility of this new kingdom remain in squalor only marginally better than the peasants. Life is difficult, and \
	the Azunja dynasty finds itself struggling to function with their limited constitutional powers and factional in-fighting between the military and the civilian government."
	consular_outfit = /datum/outfit/job/representative/consular/nka

/datum/citizenship/nka/get_objectives(mission_level, var/mob/living/carbon/human/H)
	var/rep_objectives

	switch(mission_level)
		if(REPRESENTATIVE_MISSION_HIGH)
			rep_objectives = pick("Collect evidence of NanoTrasen being unfair or oppressive against Tajaran employees, to be used as leverage in future diplomatic talks",
							"Convince [rand(1,3)] republican citizen(s) to adopt New Kingdom's citizenship")

		if(REPRESENTATIVE_MISSION_MEDIUM)
			rep_objectives = pick("Convince [rand(1,3)] foreign citizen(s) to sign the imperial volunteer Alam'ardii corps pledge")
		else
			rep_objectives = pick("Have [rand(2,5)] NKA citizens to write down their grievances with the company, and present the report to station command")

	return rep_objectives

/datum/outfit/job/representative/consular/nka
	name = "NKA Consular Officer"

	glasses = null
	uniform = /obj/item/clothing/under/tajaran/consular/nka
	head = /obj/item/clothing/head/tajaran/consular/nka
	backpack_contents = list(
		/obj/item/folder/blue/nka = 1,
		/obj/item/gun/projectile/revolver/adhomian = 1,
		/obj/item/storage/field_ration/nka = 1
	)
	accessory = /obj/item/clothing/accessory/nka_pin
