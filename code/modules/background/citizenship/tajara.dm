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
			rep_objectives = pick("Sell [rand(3,6)] Party Membership Cards, 1000 credits each",
							"Have [rand(2,5)] PRA citizens to write down their grievances with the company, and present the report to station command",
							"Sell [rand(3,6)] copies of Hadiist manifesto, 30 credits each")
		else
			rep_objectives = pick("Ensure Party loyalty for Tajara in prestigious positions",
							"Ensure [rand(2,5)] PRA citizens are secure and follow Party guidelines")

	return rep_objectives

/datum/outfit/job/representative/consular/pra
	name = "PRA Consular Officer"

	uniform = /obj/item/clothing/under/suit_jacket/checkered
	head = /obj/item/clothing/head/fedora
	backpack_contents = list(
		/obj/item/storage/box/hadii_card = 1,
		/obj/item/storage/box/hadii_manifesto = 1,
		/obj/item/gun/projectile/pistol/adhomai = 1
	)
	accessory = /obj/item/clothing/accessory/hadii_pin
