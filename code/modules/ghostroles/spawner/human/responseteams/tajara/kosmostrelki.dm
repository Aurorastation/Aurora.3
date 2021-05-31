/datum/ghostspawner/human/ert/pra_cosmonaut
	short_name = "exp_pra_cosmonaut"
	name = "Kosmostrelki"
	desc = "A Kosmostrelki under the service of the People's Republic of Adhomai Orbital Fleet."
	max_count = 3
	uses_species_whitelist = FALSE

	welcome_message = "You are part of the People's Republic of Adhomai Kosmostrelki. Listen to the commander, but do not ignore the Commissar as they are the Party's eyes."

	outfit = /datum/outfit/admin/ert/pra_cosmonaut
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)

	extra_languages = list(LANGUAGE_SIIK_MAAS)


/datum/ghostspawner/human/ert/pra_cosmonaut/commissar
	short_name = "exp_pra_commissar"
	name = "Expeditionary Kosmostrelki Party Commissar"
	desc = "A Party Commissar attached to the Kosmostrelki team."
	welcome_message = "You are a Party Commissar attached to the Kosmostrelki. Make sure that all Kosmostrelki are following the principles of Hadiism."

	max_count = 1

	outfit = /datum/outfit/admin/ert/pra_cosmonaut/commissar
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)
	req_species_whitelist = SPECIES_TAJARA


/datum/ghostspawner/human/ert/pra_cosmonaut/leader
	short_name = "exp_pra_leader"
	name = "Kosmostrelki Commander"
	desc = "The commander of the Kosmostrelki team."
	welcome_message = "You are part of the People's Republic of Adhomai Kosmostrelki. Guide the Kosmostrelki under your command to victory, but do not ignore the Commissar as they are the Party's eyes."
	max_count = 1

	outfit = /datum/outfit/admin/ert/pra_cosmonaut/commander
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)

/datum/ghostspawner/human/ert/pra_cosmonaut/tesla
	short_name = "exp_pra_tesla"
	name = "Expeditionary Tesla Trooper"
	desc = "A Tesla Trooper attached to the People's Republic of Adhomai Orbital Fleet."

	max_count = 1

	outfit = /datum/outfit/admin/ert/pra_cosmonaut/tesla
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)

/datum/ghostspawner/human/ert/pra_cosmonaut/medic
	short_name = "exp_pra_medic"
	name = "Expeditionary Kosmostrelki Combat Medic"
	desc = "A Kosmostrelki comba medic under the service of the People's Republic of Adhomai Orbital Fleet."

	max_count = 1

	outfit = /datum/outfit/admin/ert/pra_cosmonaut/medic
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)