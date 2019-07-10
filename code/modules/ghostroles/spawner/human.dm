/datum/ghostspawner/human
	short_name = null
	name = null
	desc = null

	respawn_flag = CREW //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)

	//Vars regarding the mob to use
	spawn_mob = /mob/living/carbon/human //The mob that should be spawned
	variables = list() //Variables of that mob

	//Vars related to human mobs
	var/datum/outfit/outfit = null //Outfit to equip
	var/possible_species = list("Human")
	var/possible_genders = list(MALE,FEMALE)
	var/allow_appearence_change = FALSE

	mob_name = null //The name of that mob; promots for placeholders such as %lastname
	

//Proc executed before someone is spawned in
/datum/ghostspawner/human/pre_spawn(mob/user) 
	. = ..()

//The proc to actually spawn in the user
/datum/ghostspawner/human/spawn_mob(mob/user)
	//Select a spawnpoint (if available)

	//Inform the spawnpoint that a mob has spawned (so it can update the sprite)

	//Actually spawn the mob

//Proc executed after someone is spawned in
/datum/ghostspawner/human/post_spawn(mob/user) 
	. = ..()
