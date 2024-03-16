
/// Raccoon City zombies
/datum/ghostspawner/human/zombie
	name = "Point Verdant Zombie"
	short_name = "kzombie"
	desc = "You are a Konyanger turned into a Zombie by the Outbreak. ADMIN NOTE: You MUST roleplay like a believable zombie. You're free to take your time and \
			be spooky without immediately killing people, but you must NOT do anything cheesy, powergamey, metagamey or unbelievable for a zombie."
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human/zombie
	possible_species = list(SPECIES_ZOMBIE)
	tags = list("Outbreak")
	respawn_flag = null
	enabled = FALSE
	show_on_job_select = FALSE
	allow_appearance_change = FALSE
	mob_name = FALSE
	spawnpoints = list("kzombie")

/datum/ghostspawner/human/zombie/admin
	name = "Admin Spawn Zombie"
	short_name = "aszombie"
	desc = "See the description for the Konyanger zombies, but Matt has decided to be spooky and spawn some non-special player zombies in a specific location."
	loc_type = GS_LOC_ATOM
	enabled = TRUE
	spawnpoints = list("aszombie")

/datum/ghostspawner/human/special_zombie
	name = "Special Zombie"
	short_name = "szombie"
	desc = "You are a special zombie - pick one between the Bull, Rhino, or Hunter. The Bull's specialty is smashing barricades and tanking damage. \
			The Rhino's specialty is charge attacks and the area grab leap maneuver. The Hunter's specialty is grabbing people with leap and generally being \
			a quick harasser through usage of the Consume verb."
	loc_type = GS_LOC_ATOM
	spawn_mob = /mob/living/carbon/human/hunter
	possible_species = list(SPECIES_ZOMBIE_HUNTER, SPECIES_ZOMBIE_RHINO, SPECIES_ZOMBIE_BULL)
	tags = list("Outbreak")
	respawn_flag = null
	allow_appearance_change = FALSE
	mob_name = FALSE
	atom_add_message = "A special zombie spawner is available!"

/datum/ghostspawner/human/special_zombie/spawn_mob(mob/user)
	var/atom/A = select_spawnatom()

	if(A)
		return A.assign_player(user)
	to_chat(user, SPAN_DANGER("There are no spawn atoms available to spawn at!"))
	return FALSE
/obj/effect/ghostspawpoint/zombie
	name = "igs - Generic Zombie"
	identifier = "kzombie"

/obj/effect/landmark/special_zombie
	name = "lnd - Special Zombie"
	var/ghost_role_id = "szombie"

/datum/ghostspawner/human/zombie/labs
	name = "Einstein Facility Zombie"
	short_name = "fazombie"
	desc = "You are a Zombie converging to the labs to kill the humans trying to cure the virus! ADMIN NOTE: You MUST roleplay like a believable zombie. \
			You are here specifically to kill all the humans curing the virus, but you must NOT do anything cheesy, powergamey, metagamey or unbelievable for a zombie."
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human/zombie
	tags = list("Outbreak")
	respawn_flag = null
	max_count = 50
	spawnpoints = list("fazombie")

/obj/effect/ghostspawpoint/umbrella_zombie
	name = "igs - Final Assault Zombie"
	identifier = "fazombie"
