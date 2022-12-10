/datum/ghostspawner/human/ert
	tags = list("Response Teams")

	enabled = FALSE
	req_perms = null
	max_count = 5

	spawnpoints = list("ERTSpawn")

	//Vars related to human mobs
	possible_species = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_UNATHI, SPECIES_IPC)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Emergency Responder"
	special_role = "Emergency Responder"
	respawn_flag = null

	mob_name_pick_message = "Pick a callsign or last-name."

	mob_name = null

/datum/ghostspawner/human/ert/post_spawn(mob/user)
	if(name)
		to_chat(user, "<span class='danger'><font size=3>You are [max_count > 1 ? "a" : "the"] [name]!</font></span>")
	return ..()