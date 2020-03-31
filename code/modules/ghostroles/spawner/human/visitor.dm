/datum/ghostspawner/human/visitor
	short_name = "visitor"
	name = "Visitor"
	desc = "You are a random visitor that boarded the NSS Aurora, visiting for any reason you can think of. You do not have any records, as you are not a Nanotrasen employee."
	tags = list("External")

	enabled = FALSE
	landmark_name = "JoinLate"
	req_perms = null
	max_count = 1

	//Vars related to human mobs
	outfit = /datum/outfit/admin/random/visitor
	possible_species = list("Human", "Skrell", "Tajara", "Unathi")
	possible_genders = list(MALE, FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Visitor"
	special_role = "Visitor"
	respawn_flag = null

	mob_name = null

	enable_chance = 10

/datum/ghostspawner/human/visitor/select_spawnpoint(var/use = TRUE)
	return pick(latejoin)
