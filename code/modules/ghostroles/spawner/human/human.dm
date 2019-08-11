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
	var/allow_appearance_change = FALSE

	var/assigned_role = null
	var/special_role = null
	var/faction = null

	mob_name = null
	

//Proc executed before someone is spawned in
/datum/ghostspawner/human/pre_spawn(mob/user)
	. = ..()

/datum/ghostspawner/human/proc/get_mob_name(mob/user)
	var/mname = mob_name
	if(isnull(mname))
		var/pick_message = "Pick a name."
		if(mob_name_prefix)
			pick_message = "[pick_message] Automatic Prefix: \"[mob_name_prefix]\" "
		if(mob_name_suffix)
			pick_message = "[pick_message] Automatic Suffix: \"[mob_name_suffix]\" "
		mname = sanitizeSafe(input(user, pick_message, "Name (without prefix/suffix"))
	
	if(mob_name_prefix)
		mname = "[mob_name_prefix][mname]"
	if(mob_name_suffix)
		mname = "[mname][mob_name_suffix]"
	return mname

//The proc to actually spawn in the user
/datum/ghostspawner/human/spawn_mob(mob/user)
	//Select a spawnpoint (if available)
	var/turf/T = select_spawnpoint()
	if(!T)
		log_debug("GhostSpawner: Unable to select spawnpoint for [short_name]")
		return FALSE

	//Get the name / age from them first
	var/mname = get_mob_name(user)
	var/age = input(user, "Enter your characters age:","Num") as num

	//Spawn in the mob
	var/mob/living/carbon/human/M = new spawn_mob(null)
	
	M.change_gender(pick(possible_genders))
	M.set_species(pick(possible_species))

	//Prepare the mob
	M.check_dna(M)
	M.dna.ready_dna(M)

	//Move the mob inside and initialize the mind
	M.key = user.ckey //!! After that USER is invalid, so we have to use M

	M.mind_initialize()
	
	if(assigned_role)
		M.mind.assigned_role = assigned_role
	if(special_role)
		M.mind.special_role = special_role
	if(faction)
		M.faction = faction
	
	//Move the mob
	M.forceMove(T)
	M.lastarea = get_area(M.loc) //So gravity doesnt fuck them.
	M.megavend = TRUE //So the autodrobe ignores them

	//Setup the appearance
	if(allow_appearance_change)
		M.change_appearance(APPEARANCE_ALL, M.loc, check_species_whitelist = 1)
	else //otherwise randomize
		M.client.prefs.randomize_appearance_for(M, FALSE)
	
	//Setup the mob age and name
	if(!mname)
		mname = random_name(M.gender, M.species.name)
	
	M.fully_replace_character_name(M.real_name, mname)

	if(!age)
		age = rand(35, 50)
	M.age = Clamp(age, 21, 65) 

	//Setup the outfit
	if(outfit)
		M.preEquipOutfit(outfit, FALSE)
		M.equipOutfit(outfit, FALSE)

	M.force_update_limbs()
	M.update_eyes()
	M.regenerate_icons()

	return M

//Proc executed after someone is spawned in
/datum/ghostspawner/human/post_spawn(mob/user) 
	. = ..()
