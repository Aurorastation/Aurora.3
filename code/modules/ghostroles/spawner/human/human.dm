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
	var/list/species_outfits = list() //Outfit overwrite for the species
	var/uses_species_whitelist = TRUE //Do you need the whitelist to play the species?
	var/possible_species = list(SPECIES_HUMAN)
	var/allow_appearance_change = APPEARANCE_PLASTICSURGERY
	var/list/extra_languages = list() //Which languages are added to this mob

	var/assigned_role = null
	var/special_role = null
	var/faction = null

	/// Culture restrictions for this spawner. Use types. Make sure that there is at least one culture per allowed species!
	var/list/culture_restriction = list()
	/// Origin restrictions for this spawner. Use types. Not required if culture restriction is set. Make sure that there is at least one origin per allowed species!
	var/list/origin_restriction = list()

	mob_name = null

//Return a error message if the user CANT spawn. Otherwise FALSE
/datum/ghostspawner/human/cant_spawn(mob/user)
	//If whitelist is required, check if user can spawn in ANY of the possible species
	if(uses_species_whitelist)
		var/can_spawn_as_any = FALSE
		for (var/S in possible_species)
			if(is_alien_whitelisted(user, S))
				can_spawn_as_any = TRUE
				break
		if(!can_spawn_as_any)
			return "This spawner requires whitelists for its spawnable species, and you do not have any such."
	. = ..()

//Proc executed before someone is spawned in
/datum/ghostspawner/human/pre_spawn(mob/user)
	. = ..()

/datum/ghostspawner/human/proc/get_mob_name(mob/user, var/species, var/gender)
	var/mname = mob_name
	if(isnull(mname))
		var/pick_message = "[mob_name_pick_message] ([species])"
		if(mob_name_prefix)
			pick_message = "[pick_message] Auto Prefix: \"[mob_name_prefix]\" "
		if(mob_name_suffix)
			pick_message = "[pick_message] Auto Suffix: \"[mob_name_suffix]\" "
		mname = sanitizeName(sanitize_readd_odd_symbols(sanitizeSafe(input(user, pick_message, "Name for a [species] (without prefix/suffix)"))))

	if(!length(mname))
		if(mob_name_prefix || mob_name_suffix)
			mname = capitalize(pick(last_names))
		else
			mname = random_name(gender,species)

	if(mob_name_prefix)
		mname = replacetext(mname,mob_name_prefix,"") //Remove the prefix if it exists in the string
		mname = "[mob_name_prefix][mname]"
	if(mob_name_suffix)
		mname = replacetext(mname,mob_name_suffix,"") //Remove the suffix if it exists in the string
		mname = "[mname][mob_name_suffix]"
	return mname

//The proc to actually spawn in the user
/datum/ghostspawner/human/spawn_mob(mob/user)
	//Select a spawnpoint (if available)
	var/turf/T = select_spawnlocation()
	if(!T)
		LOG_DEBUG("GhostSpawner: Unable to select spawnpoint for [short_name]")
		return FALSE

	//Pick a species
	var/list/species_selection = list()
	for (var/S in possible_species)
		if(!uses_species_whitelist)
			species_selection += S
		else if(is_alien_whitelisted(user, S))
			species_selection += S

	var/picked_species = tgui_input_list(user, "Select your species.", "Species Selection", species_selection)
	if(!picked_species)
		picked_species = possible_species[1]

	var/datum/species/S = GLOB.all_species[picked_species]
	var/assigned_gender = pick(S.default_genders)

	//Get the name / age from them first
	var/mname = get_mob_name(user, picked_species, assigned_gender)
	var/age = tgui_input_number(user, "Enter your character's age.", "Age", 25, 1000, 0)

	//Spawn in the mob
	var/mob/living/carbon/human/M = new spawn_mob(GLOB.newplayer_start)

	M.change_gender(assigned_gender)

	M.set_species(picked_species)

	//Prepare the mob
	M.check_dna(M)
	M.dna.ready_dna(M)

	//Move the mob inside and initialize the mind
	M.key = user.ckey //!! After that USER is invalid, so we have to use M

	M.mind_initialize()

	if(assigned_role)
		M.mind.assigned_role = assigned_role
		M.mind.role_alt_title = assigned_role
	if(special_role)
		M.mind.special_role = special_role
	if(faction)
		M.faction = faction

	//Move the mob
	M.forceMove(T)
	M.lastarea = get_area(M.loc) //So gravity doesnt fuck them.

	//Setup the mob age and name
	if(!mname)
		mname = random_name(M.gender, M.species.name)

	M.fully_replace_character_name(M.real_name, mname)

	M.mind.signature = mname
	M.mind.signfont = pick("Verdana", "Times New Roman", "Courier New")

	if(!age)
		age = rand(35, 50)
	M.age = Clamp(age, 21, 65)

	//Setup the Outfit
	if(picked_species in species_outfits)
		var/datum/outfit/species_outfit = species_outfits[picked_species]
		M.preEquipOutfit(species_outfit, FALSE)
		M.equipOutfit(species_outfit, FALSE)
	else if(outfit)
		M.preEquipOutfit(outfit, FALSE)
		M.equipOutfit(outfit, FALSE)

	//Setup the appearance
	if(allow_appearance_change)
		M.change_appearance(allow_appearance_change, M, culture_restriction = src.culture_restriction, origin_restriction = src.origin_restriction, update_id = TRUE)
	else //otherwise randomize
		M.client.prefs.randomize_appearance_for(M, FALSE, culture_restriction, origin_restriction)

	if(length(culture_restriction))
		for(var/culture in culture_restriction)
			var/singleton/origin_item/culture/CL = GET_SINGLETON(culture)
			if(CL.type in M.species.possible_cultures)
				M.set_culture(CL)
				break
		for(var/origin in M.culture.possible_origins)
			var/singleton/origin_item/origin/OI = GET_SINGLETON(origin)
			if(length(origin_restriction))
				if(!(OI.type in origin_restriction))
					continue
			M.set_origin(OI)
			M.accent = pick(OI.possible_accents)
			break

	for(var/language in extra_languages)
		M.add_language(language)

	M.force_update_limbs()
	M.update_eyes()
	M.regenerate_icons()
	M.ghost_spawner = WEAKREF(src)

	return M

/// Used for cryo to free up a slot when a ghost cryos.
/mob/living/carbon/human
	var/datum/weakref/ghost_spawner

/mob/living/carbon/human/Destroy()
	ghost_spawner = null
	return ..()
