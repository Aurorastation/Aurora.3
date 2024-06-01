/datum/citizenship/pra
	name = CITIZENSHIP_PRA
	description = "Lead by President Njadrasanukii Hadii, the People's Republic of Adhomai are considered the 'loyalist' faction on Adhomai and enjoy galactic recognition as the \
	government of Adhomai. It claims to be the true keeper of Al'mari's legacy. However, the PRA can be described as a Hadiist branch of Al'mari's revolutionary ideology - that means \
	putting the State at the top of a hierarchy of power. The PRA is a very centralized state, but in recent years has slowly been able to start making true its promises to bring \
	revolution to the masses. With land reform, enfranchisement of women and peasantry, literacy initiatives, and the collectivization of farms and the means of production, the PRA is \
	struggling to hold true to its radical ideals while an entrenched upper party stubbornly tries to hold onto power."
	consular_outfit = /obj/outfit/job/representative/consular/pra
	assistant_outfit = /obj/outfit/job/consular_assistant/pra

	job_species_blacklist = list(
		"Consular Officer" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_DIONA,
			SPECIES_DIONA_COEUS,
			SPECIES_SKRELL,
			SPECIES_SKRELL_AXIORI,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER,
			SPECIES_TAJARA_ZHAN,
			SPECIES_TAJARA_MSAI
		),
		"Diplomatic Aide" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_DIONA,
			SPECIES_DIONA_COEUS,
			SPECIES_SKRELL,
			SPECIES_SKRELL_AXIORI,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER,
			SPECIES_TAJARA_ZHAN
		)
	)

/datum/citizenship/pra/get_objectives(mission_level, var/mob/living/carbon/human/H)
	switch(mission_level)
		if(REPRESENTATIVE_MISSION_LOW)
			return "Ensure the loyalty of PRA Citizen to the Party and President Hadii. You must also promote the relationship between the [SSatlas.current_map.boss_name] and the People's Republic through diplomacy."

/obj/outfit/job/representative/consular/pra
	name = "PRA Consular Officer"

	glasses = null
	uniform = /obj/item/clothing/under/tajaran/consular
	head = /obj/item/clothing/head/tajaran/consular
	backpack_contents = list(
		/obj/item/storage/box/hadii_card = 1,
		/obj/item/storage/box/hadii_manifesto = 1,
		/obj/item/gun/projectile/pistol/adhomai = 1,
		/obj/item/storage/field_ration = 1,
		/obj/item/clothing/accessory/badge/hadii_card/member = 1,
		/obj/item/storage/box/syndie_kit/spy/hidden = 1
	)
	accessory = /obj/item/clothing/accessory/hadii_pin

/obj/outfit/job/consular_assistant/pra
	glasses = null
	uniform = /obj/item/clothing/under/tajaran/smart
	backpack_contents = list(
		/obj/item/storage/box/hadii_card = 1,
		/obj/item/storage/box/hadii_manifesto = 1,
		/obj/item/clothing/accessory/badge/hadii_card/member = 1,
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
	consular_outfit = /obj/outfit/job/representative/consular/dpra
	assistant_outfit = /obj/outfit/job/consular_assistant/dpra

	job_species_blacklist = list(
		"Consular Officer" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_DIONA,
			SPECIES_DIONA_COEUS,
			SPECIES_SKRELL,
			SPECIES_SKRELL_AXIORI,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER,
			SPECIES_TAJARA_ZHAN,
			SPECIES_TAJARA_MSAI
		),
		"Diplomatic Aide" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_DIONA,
			SPECIES_DIONA_COEUS,
			SPECIES_SKRELL,
			SPECIES_SKRELL_AXIORI,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER,
			SPECIES_TAJARA_ZHAN
		)
	)

/datum/citizenship/dpra/get_objectives(mission_level, var/mob/living/carbon/human/H)
	switch(mission_level)
		if(REPRESENTATIVE_MISSION_LOW)
			return "Ensure that DPRA citizens are following the principles of Al'mariism. Defend the rights of the Tajara through diplomacy."

/obj/outfit/job/representative/consular/dpra
	name = "DPRA Consular Officer"

	glasses = null
	uniform = /obj/item/clothing/under/tajaran/consular/dpra
	head = /obj/item/clothing/head/tajaran/consular/dpra
	backpack_contents = list(
		/obj/item/gun/projectile/silenced = 1,
		/obj/item/storage/box/dpra_manifesto = 1,
		/obj/item/storage/field_ration/dpra = 1,
		/obj/item/storage/box/syndie_kit/spy/hidden = 1
	)
	accessory = /obj/item/clothing/accessory/dpra_pin

/obj/outfit/job/consular_assistant/dpra
	glasses = null
	uniform = /obj/item/clothing/under/tajaran/smart
	backpack_contents = list(
		/obj/item/storage/box/dpra_manifesto = 1,
		/obj/item/storage/field_ration/dpra = 1
	)
	accessory = /obj/item/clothing/accessory/dpra_pin

/datum/citizenship/nka
	name = CITIZENSHIP_NKA
	description = "The last major faction is the rebellious New Kingdom of Adhomai, which seceded and declared itself a nation in 2450. The New Kingdom is ruled by a Njarir'Akhran noble \
	line that survived the previous Revolution by remaining in hiding, owing to the efforts of their supporters. Founded by King Vahzirthaamro Azunja specifically, he denounces both other \
	factions in the civil war as illegitimate and himself as the only legitimate ruler of Adhomai. Supporters of the New Kingdom tend to be rare outside lands it controls. However, \
	they believe strongly that the current republic on Adhomai was founded on genocide and unspeakable slaughters. The New Kingdom puts forth the ideology that Republicanism is \
	bloodshed. The only way to return Adhomai to peace and prosperity is to learn from the mistakes of the ancient nobles and Republicans, and create a new noble dynasty. They believe \
	this dynasty should rule as a constitutional monarchy in order to prevent abuses of power. In reality, this has proven very difficult, especially with the realities of war. \
	The lofty titles of the nobles disguise the fact that most of the nobility of this new kingdom remain in squalor only marginally better than the peasants. Life is difficult, and \
	the Azunja dynasty finds itself struggling to function with their limited constitutional powers and factional in-fighting between the military and the civilian government."
	consular_outfit = /obj/outfit/job/representative/consular/nka
	assistant_outfit = /obj/outfit/job/consular_assistant/nka

	job_species_blacklist = list(
		"Consular Officer" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_DIONA,
			SPECIES_DIONA_COEUS,
			SPECIES_SKRELL,
			SPECIES_SKRELL_AXIORI,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER,
			SPECIES_TAJARA_ZHAN,
			SPECIES_TAJARA_MSAI
		),
		"Diplomatic Aide" = list(
			SPECIES_HUMAN,
			SPECIES_HUMAN_OFFWORLD,
			SPECIES_IPC,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_SHELL,
			SPECIES_IPC_UNBRANDED,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_DIONA,
			SPECIES_DIONA_COEUS,
			SPECIES_SKRELL,
			SPECIES_SKRELL_AXIORI,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER,
			SPECIES_TAJARA_ZHAN
		)
	)

/datum/citizenship/nka/get_objectives(mission_level, var/mob/living/carbon/human/H)
	switch(mission_level)
		if(REPRESENTATIVE_MISSION_LOW)
			return "Ensure that NKA citizens are loyal to the Crown. You must also promote the relationship between the [SSatlas.current_map.boss_name] and the New Kingdom through diplomacy."

/obj/outfit/job/representative/consular/nka
	name = "NKA Consular Officer"

	glasses = null
	uniform = /obj/item/clothing/under/tajaran/consular/nka
	head = /obj/item/clothing/head/tajaran/consular/nka
	backpack_contents = list(
		/obj/item/folder/blue/nka = 1,
		/obj/item/gun/projectile/revolver/adhomian = 1,
		/obj/item/storage/box/nka_manifesto = 1,
		/obj/item/storage/field_ration/nka = 1,
		/obj/item/storage/box/syndie_kit/spy/hidden = 1
	)
	accessory = /obj/item/clothing/accessory/nka_pin

/obj/outfit/job/consular_assistant/nka
	glasses = null
	uniform = /obj/item/clothing/under/tajaran/fancy
	backpack_contents = list(
		/obj/item/folder/blue/nka = 1,
		/obj/item/storage/box/nka_manifesto = 1,
		/obj/item/storage/field_ration/nka = 1
	)
	accessory = /obj/item/clothing/accessory/nka_pin

/datum/citizenship/free_council
	name = CITIZENSHIP_FREE_COUNCIL
	description = "The Free Tajaran Council is the largest Tajaran community in Himeo. Its origins can be traced back to the First Revolution-era revolutionaries that fled Adhomai. Built upon \
	radical principles of equality and communal democracy, the Free Tajaran Council remained relatively isolated from the rest of the Tajaran community until the start of the Adhomian Cold War. \
	Its population was granted a temporary citizenship status as part of an agreement between the Tajaran nations. While the council struggles to decide its future, some of its members travel \
	the galaxy in search of aid and new allies for their ultimate masterplan."

	job_species_blacklist = list(
		"Consular Officer" = ALL_SPECIES
	)
