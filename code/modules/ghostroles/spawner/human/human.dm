/datum/ghostspawner/human
	short_name = null
	name = null
	desc = null

	respawn_flag = CREW
	disable_and_hide_if_full = FALSE

	//Vars regarding the mob to use
	spawn_mob = /mob/living/carbon/human //The mob that should be spawned
	variables = list() //Variables of that mob

	//Vars related to human mobs

	/// Outfit to equip
	/// Should either be a subtype of `/obj/outfit`, and then it is that specific outfit
	/// Or a list of subtypes, where it randomly picks one outfit from that list
	var/outfit = null
	/// Outfit overwrite for the species
	var/list/species_outfits = list()

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

	/// Character factions allowed to select this role as a roundstart offship slot.
	/// Null prevents the role from being selected at roundstart.
	var/list/roundstart_factions = list("Independent")
	/// Persistent occupation-list group. Null excludes non-ship and special ghost roles from roundstart selection.
	var/roundstart_ship_name

	mob_name = null

	/// Determines whether the mob will have an Idris banking account when they spawn in
	var/has_idris_account = TRUE

	/// Determines whether the Idris banking account will be visible on the station's account terminal
	var/is_idris_account_public = FALSE

	/// The minimum amount of money the account can spawn with
	var/idris_account_min = 100

	/// The maximum amount of money the account can spawn with
	var/idris_account_max = 500

//Return a error message if the user CANT spawn. Otherwise FALSE
/datum/ghostspawner/human/cant_spawn(mob/user, roundstart = FALSE)
	//If whitelist is required, check if user can spawn in ANY of the possible species
	if(uses_species_whitelist)
		var/can_spawn_as_any = FALSE
		for (var/S in possible_species)
			if(is_alien_whitelisted(user, S))
				can_spawn_as_any = TRUE
				break
		if(!can_spawn_as_any)
			return "This spawner requires whitelists for its spawnable species, and you do not have any such."
	. = ..(user, roundstart)

//Proc executed before someone is spawned in
/datum/ghostspawner/human/pre_spawn(mob/user)
	. = ..()

/// Returns the full-sized overmap ship containing this spawner, if it has one.
/datum/ghostspawner/human/proc/get_roundstart_ship()
	RETURN_TYPE(/obj/effect/overmap/visitable/ship)

	if(loc_type != GS_LOC_POS)
		return null
	var/atom/spawn_location = select_spawnlocation(FALSE)
	if(!spawn_location)
		return null
	var/obj/effect/overmap/visitable/ship/ship = GLOB.map_sectors["[spawn_location.z]"]
	if(!istype(ship) || ship.static_vessel || istype(ship, /obj/effect/overmap/visitable/ship/landable))
		return null
	return ship

/// Whether this role should appear in the roundstart occupation offship list.
/datum/ghostspawner/human/proc/is_roundstart_offship_role()
	if(!roundstart_ship_name || !show_on_job_select || !length(roundstart_factions) || ("Antagonist" in tags))
		return FALSE
	if(req_perms)
		return FALSE
	return TRUE

/// Returns why a character slot cannot select this role, or null when it can.
/datum/ghostspawner/human/proc/get_roundstart_selection_error(mob/user, datum/preferences/prefs)
	if(!is_roundstart_offship_role())
		return "Role unavailable"
	if(!(prefs.faction in roundstart_factions))
		return "Requires one of these factions:\n[bulleted_list(roundstart_factions)]"
	if(!(prefs.species in possible_species))
		return "Requires one of these species:\n[bulleted_list(possible_species)]"
	if(uses_species_whitelist && !is_alien_whitelisted(user, prefs.species))
		return "Species whitelist required"
	return null

/datum/ghostspawner/human/proc/get_mob_name(mob/user, var/species, var/gender)
	var/mname = mob_name
	if(isnull(mname))
		var/pick_message = "[mob_name_pick_message] ([species])"
		if(mob_name_prefix)
			pick_message = "[pick_message] Auto Prefix: \"[mob_name_prefix]\" "
		if(mob_name_suffix)
			pick_message = "[pick_message] Auto Suffix: \"[mob_name_suffix]\" "
		mname = sanitizeName(tgui_input_text(user, pick_message, "Name for a [species] (without prefix/suffix)"))

	if(!length(mname))
		if(mob_name_prefix || mob_name_suffix)
			mname = capitalize(pick(GLOB.last_names))
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
	M.age = clamp(age, 21, 65)

	finish_spawn(M, picked_species)
	return M

/// Spawns a roundstart offship using the selected character slot's appearance and identity.
/datum/ghostspawner/human/proc/spawn_mob_from_preferences(mob/abstract/new_player/user)
	var/turf/T = select_spawnlocation()
	if(!T)
		LOG_DEBUG("GhostSpawner: Unable to select spawnpoint for roundstart role [short_name]")
		return null

	var/picked_species = user.client.prefs.species
	var/mob/living/carbon/human/M = user.create_character()
	if(!M)
		return null

	M.forceMove(T)
	M.lastarea = get_area(M.loc)
	finish_spawn(M, picked_species, TRUE)
	return M

/// Resolves the outfit this role uses for a species without mutating the spawner's configured outfit.
/datum/ghostspawner/human/proc/get_outfit_for_species(picked_species)
	if(picked_species in species_outfits)
		return species_outfits[picked_species]
	if(islist(outfit))
		return pick(outfit)
	return outfit

/// Dresses a character-setup mannequin in this role's visible equipment.
/datum/ghostspawner/human/proc/equip_preview(mob/living/carbon/human/mannequin, picked_species, datum/preferences/prefs)
	var/role_outfit = get_outfit_for_species(picked_species)
	if(!role_outfit)
		return FALSE
	mannequin.preEquipOutfit(role_outfit, TRUE)
	mannequin.equipOutfit(role_outfit, TRUE)
	prefs.filter_job_preview_equipment(mannequin)
	return TRUE

/// Applies the role, outfit, account, and ghost-role customization shared by both spawn paths.
/datum/ghostspawner/human/proc/finish_spawn(mob/living/carbon/human/M, picked_species, preserve_appearance = FALSE)
	if(!istype(M))
		return FALSE

	if(assigned_role)
		M.mind.assigned_role = assigned_role
		M.mind.role_alt_title = assigned_role
	if(special_role)
		M.mind.special_role = special_role
	if(faction)
		M.faction = faction

	if(has_idris_account)
		SSeconomy.create_and_assign_account(M, null, rand(idris_account_min, idris_account_max), is_idris_account_public)

	//Setup the Outfit
	var/role_outfit = get_outfit_for_species(picked_species)
	if(role_outfit)
		M.preEquipOutfit(role_outfit, FALSE)
		M.equipOutfit(role_outfit, FALSE)

	// Roundstart offships use the selected character slot exactly as configured.
	// Ordinary ghost-menu joins retain the role's appearance changer/randomization behavior.
	if(!preserve_appearance)
		if(allow_appearance_change)
			M.change_appearance(allow_appearance_change, M, culture_restriction = src.culture_restriction, origin_restriction = src.origin_restriction, update_id = TRUE)
		else
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
	return TRUE
