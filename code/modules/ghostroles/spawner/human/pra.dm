/datum/ghostspawner/human/pra_cosmonaut
	short_name = "pra_cosmonaut"
	name = "Kosmostrelki"
	desc = "Protect the People's Republic of Adhomai's possessions on space."
	tags = list("External")

	enabled = TRUE
	spawnpoints = list("pra_cosmonaut")
	req_perms = null
	max_count = 3

	outfit = /datum/outfit/admin/pra_cosmonaut
	possible_species = list("Tajara","M'sai Tajara", "Zhan-Khazan Tajara")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Kosmostrelki"
	special_role = "Kosmostrelki"
	respawn_flag = null
	extra_languages = list(LANGUAGE_SIIK_MAAS)


/datum/ghostspawner/human/pra_cosmonaut/commissar
	short_name = "pra_commissar"
	name = "Kosmostrelki Party Commissar"
	desc = "Protect the People's Republic of Adhomai's possessions on space, and ensure that the Kosmostrelki follow the principles of Hadiism."

	max_count = 1

	assigned_role = "Party Commissar"
	special_role = "Party Commissar"

	req_species_whitelist = "Tajara"

	outfit = /datum/outfit/admin/pra_cosmonaut/commissar
	possible_species = list("Tajara","M'sai Tajara")