/datum/ghostspawner/human/visitorerror
	short_name = "visitorerror"
	name = "Visitor"
	desc = "You are a Visitor, but noone told them."
	tags = list("External")

	enabled = FALSE
	landmark_name = "JoinLate"
	req_perms = null
	max_count = 1

	//Vars related to human mobs
	outfit = /datum/outfit/admin/random/visitor
	possible_species = list("Human","Skrell","Tajara","Unathi")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Visitor"
	special_role = "Visitor"
	respawn_flag = null

	mob_name = null

	enable_chance = 10

/datum/ghostspawner/human/visitorerror/select_spawnpoint(var/use=TRUE)
	return pick(latejoin)