/// List of all clients.
GLOBAL_LIST_EMPTY(clients)
/// List of all clients who have any permissions.
GLOBAL_LIST_EMPTY(staff)
GLOBAL_PROTECT(staff)
/// List of all ckeys with associated client.
GLOBAL_LIST_EMPTY(directory)

/// List of all mobs **with clients attached**. Excludes /mob/abstract/new_player
GLOBAL_LIST_EMPTY(player_list)
/// List of all mobs, including clientless.
GLOBAL_LIST_EMPTY(mob_list)
/// List of all human mobs and sub-types, including clientless.
GLOBAL_LIST_EMPTY(human_mob_list)
/// List of all silicon mobs, including clientless.
GLOBAL_LIST_EMPTY(silicon_mob_list)
/// List of all alive mobs, including clientless. Excludes /mob/abstract/new_player.
GLOBAL_LIST_EMPTY(living_mob_list)
/// List of all dead mobs, including clientless. Excludes /mob/abstract/new_player.
GLOBAL_LIST_EMPTY(dead_mob_list)
/// List of all API commands (/datum/topic_command) available.
GLOBAL_LIST_EMPTY(topic_commands)
GLOBAL_PROTECT(topic_commands)
/// List of the names of all API commands (/datum/topic_command) available.
GLOBAL_LIST_EMPTY(topic_commands_names)
GLOBAL_PROTECT(topic_commands_names)

/// List of all landmarks.
GLOBAL_LIST_EMPTY(landmarks_list)
/// Assoc list of force spawnpoints for event maps.
GLOBAL_LIST_EMPTY(force_spawnpoints)
/// List of all jobstypes, minus borg, merchant and AI.
GLOBAL_LIST_EMPTY(joblist)
/// List of all brig secure_closets. Used by brig timers.
GLOBAL_LIST_EMPTY(brig_closets)

/// A list of areas where ghosts can teleport to, not turfs.
GLOBAL_LIST_EMPTY(ghostteleportlocs)
/// Central command areas.
GLOBAL_LIST_EMPTY(centcom_areas)
/// Keyed list of area object to boolean. An area is set here if it has station_area set to TRUE.
GLOBAL_LIST_EMPTY(the_station_areas)

/// List of all implants. Used for teleportation/tracking implants.
GLOBAL_LIST_EMPTY(implants)

/// Turf is added to this list if isStationLevel() passes when it's initialized.
GLOBAL_LIST_EMPTY(station_turfs)
/// List of all instanced areas by type.
GLOBAL_LIST_EMPTY(areas_by_type)
/// List of all instanced areas.
GLOBAL_LIST_EMPTY(all_areas)

/// Languages/species/whitelist.
GLOBAL_LIST_EMPTY_TYPED(all_species, /datum/species)
/// Short names of all species.
GLOBAL_LIST_EMPTY(all_species_short_names)
/// All language datums. String to instance.
GLOBAL_LIST_EMPTY(all_languages)
/// Table of say codes for all languages.
GLOBAL_LIST_EMPTY(language_keys)
/// Species that require a whitelist check.
GLOBAL_LIST_INIT(whitelisted_species, list(SPECIES_HUMAN))
/// A list of ALL playable species, whitelisted, latejoin or otherwise.
GLOBAL_LIST_EMPTY(playable_species)

/// Poster designs (/datum/poster).
GLOBAL_LIST_EMPTY(poster_designs)

/// All uplinks.
GLOBAL_LIST_EMPTY_TYPED(world_uplinks, /obj/item/device/uplink)

/// Preferences stuff below.
/// Stores /datum/sprite_accessory/hair indexed by name.
GLOBAL_LIST_EMPTY(hair_styles_list)
/// List of hair for the male gender. List of strings.
GLOBAL_LIST_EMPTY(hair_styles_male_list)
/// List of hair for the female gender. List of strings.
GLOBAL_LIST_EMPTY(hair_styles_female_list)
/// List of hair gradients. List of strings to /datum/sprite_accessory.
GLOBAL_LIST_EMPTY(hair_gradient_styles_list)
/// Stores /datum/sprite_accessory/facial_hair indexed by name.
GLOBAL_LIST_EMPTY(facial_hair_styles_list)
/// List of facial hair for the male gender. List of strings.
GLOBAL_LIST_EMPTY(facial_hair_styles_male_list)
/// List of facial hair for the female gender. List of strings.
GLOBAL_LIST_EMPTY(facial_hair_styles_female_list)
/// List of body markings. List of strings to /datum/sprite_accessory/marking.
GLOBAL_LIST_EMPTY(body_marking_styles_list)
/// List of valid disabilities in the loadout.
GLOBAL_LIST_EMPTY(chargen_disabilities_list)
/// List of valid player genders in the loadout.
GLOBAL_LIST_INIT(valid_player_genders, list(MALE, FEMALE, NEUTER, PLURAL))

/// List of possible backpack shapes for the loadout.
GLOBAL_LIST_INIT(backbaglist, list("Nothing", "Backpack", "Satchel", "Leather Satchel", "Duffel Bag", "Messenger Bag", "Rucksack", "Pocketbook"))
/// List of possible backpack styles for the loadout.
GLOBAL_LIST_INIT(backbagstyles, list("Job-specific", "Generic", "Faction-specific"))
/// List of possible backpack colors for the loadout.
GLOBAL_LIST_INIT(backbagcolors, list("None", "Blue", "Green", "Navy", "Tan", "Khaki", "Black", "Olive", "Auburn", "Brown"))
/// List of possible backpack straps for the loadout.
GLOBAL_LIST_INIT(backbagstrap, list("Hidden", "Thin", "Normal", "Thick"))
/// Jobs that are not "internal" to the game map.
GLOBAL_LIST_INIT(exclude_jobs, list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant))

/// PDA loadout choices.
GLOBAL_LIST_INIT(pdalist, list("Nothing", "Standard PDA", "Classic PDA", "Rugged PDA", "Slate PDA", "Smart PDA", "Tablet", "Wristbound"))

/// Headset loadout choices.
GLOBAL_LIST_INIT(headsetlist, list("Nothing", "Headset", "Bowman Headset", "Double Headset", "Wristbound Radio", "Sleek Wristbound Radio"))

/// Primary Radio Slot loadout choices.
GLOBAL_LIST_INIT(primary_radio_slot_choice, list("Left Ear", "Right Ear", "Wrist"))

/// Visual nets.
GLOBAL_LIST_EMPTY_TYPED(visual_nets, /datum/visualnet)
/// Camera visualnet.
GLOBAL_DATUM_INIT(cameranet, /datum/visualnet/camera, new)

/// Escape locations for Nar'Sie. Escape shuttles, generally.
GLOBAL_LIST_EMPTY(escape_list)
/// Escape exits for universe states.
GLOBAL_LIST_EMPTY(endgame_exits)
/// Safe spawns  for universe states.
GLOBAL_LIST_EMPTY(endgame_safespawns)

GLOBAL_LIST_INIT(syndicate_access, list(ACCESS_MAINT_TUNNELS, ACCESS_SYNDICATE, ACCESS_EXTERNAL_AIRLOCKS))

/// Cloaking devices.
GLOBAL_LIST_EMPTY(cloaking_devices)

/// Hearing sensitive listening in closely.
GLOBAL_LIST_EMPTY(intent_listener)

/// Cache for clothing species adaptability.
GLOBAL_LIST_EMPTY(contained_clothing_species_adaption_cache)

//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/makeDatumRefLists()
	var/list/paths

	//Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = subtypesof(/datum/sprite_accessory/hair)
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		GLOB.hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	GLOB.hair_styles_male_list += H.name
			if(FEMALE)	GLOB.hair_styles_female_list += H.name
			else
				GLOB.hair_styles_male_list += H.name
				GLOB.hair_styles_female_list += H.name

	sortTim(GLOB.hair_styles_list, GLOBAL_PROC_REF(cmp_text_asc))
	sortTim(GLOB.hair_styles_male_list, GLOBAL_PROC_REF(cmp_text_asc))
	sortTim(GLOB.hair_styles_female_list, GLOBAL_PROC_REF(cmp_text_asc))

	//Gradients - Initialise all /datum/sprite_accessory/hair_gradients into an list indexed by hairgradient-style name
	paths = subtypesof(/datum/sprite_accessory/hair_gradients)
	for(var/path in paths)
		var/datum/sprite_accessory/hair_gradients/H = new path()
		GLOB.hair_gradient_styles_list[H.name] = H

	sortTim(GLOB.hair_gradient_styles_list, GLOBAL_PROC_REF(cmp_text_asc))

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = subtypesof(/datum/sprite_accessory/facial_hair)
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		GLOB.facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	GLOB.facial_hair_styles_male_list += H.name
			if(FEMALE)	GLOB.facial_hair_styles_female_list += H.name
			else
				GLOB.facial_hair_styles_male_list += H.name
				GLOB.facial_hair_styles_female_list += H.name

	sortTim(GLOB.facial_hair_styles_list, GLOBAL_PROC_REF(cmp_text_asc))
	sortTim(GLOB.facial_hair_styles_male_list, GLOBAL_PROC_REF(cmp_text_asc))
	sortTim(GLOB.facial_hair_styles_female_list, GLOBAL_PROC_REF(cmp_text_asc))

	//Body markings
	paths = subtypesof(/datum/sprite_accessory/marking)
	for(var/path in paths)
		var/datum/sprite_accessory/marking/M = new path()
		GLOB.body_marking_styles_list[M.name] = M

	sortTim(GLOB.body_marking_styles_list, GLOBAL_PROC_REF(cmp_text_asc))

	//Disability datums
	paths = subtypesof(/datum/character_disabilities)
	for(var/path in paths)
		var/datum/character_disabilities/T = new path()
		GLOB.chargen_disabilities_list[T.name] = T

	sortTim(GLOB.chargen_disabilities_list, GLOBAL_PROC_REF(cmp_text_asc))

	//List of job. I can't believe this was calculated multiple times per tick!
	paths = subtypesof(/datum/job)
	paths -= GLOB.exclude_jobs
	for(var/T in paths)
		var/datum/job/J = new T
		GLOB.joblist[J.title] = J

	//Languages and species.
	paths = subtypesof(/datum/language)
	for(var/T in paths)
		var/datum/language/L = new T
		GLOB.all_languages[L.name] = L

	for (var/language_name in GLOB.all_languages)
		var/datum/language/L = GLOB.all_languages[language_name]
		if(!(L.flags & NONGLOBAL))
			GLOB.language_keys[lowertext(L.key)] = L

	var/rkey = 0
	paths = subtypesof(/datum/species)
	for(var/T in paths)
		rkey++
		var/datum/species/S = new T
		S.race_key = rkey //Used in mob icon caching.
		if(length(S.autohiss_basic_map) || length(S.autohiss_extra_map) || length(S.autohiss_basic_extend) || length(S.autohiss_extra_extend))
			S.has_autohiss = TRUE
		GLOB.all_species[S.name] = S
		GLOB.all_species_short_names |= S.short_name

	sortTim(GLOB.all_species, GLOBAL_PROC_REF(cmp_text_asc))

	// The other lists are generated *after* we sort the main one so they don't need sorting too.
	for (var/thing in GLOB.all_species)
		var/datum/species/S = GLOB.all_species[thing]

		if(!(S.spawn_flags & IS_RESTRICTED) && S.category_name)
			if(!length(GLOB.playable_species[S.category_name]))
				GLOB.playable_species[S.category_name] = list()
			GLOB.playable_species[S.category_name] += S.name
		if(S.spawn_flags & IS_WHITELISTED)
			GLOB.whitelisted_species += S.name

	//Posters
	paths = subtypesof(/datum/poster)
	for(var/T in paths)
		var/datum/poster/P = new T
		GLOB.poster_designs += P

	return 1

GLOBAL_LIST_INIT(correct_punctuation, list("!" = TRUE, "." = TRUE, "?" = TRUE, "-" = TRUE, "~" = TRUE, \
										"*" = TRUE, "/" = TRUE, ">" = TRUE, "\"" = TRUE, "'" = TRUE, \
										"," = TRUE, ":" = TRUE, ";" = TRUE, "\"" = TRUE))

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in SSchemistry.chemical_reactions)
		. += "SSchemistry.chemical_reactions\[\"[reaction]\"\] = \"[SSchemistry.chemical_reactions[reaction]]\"\n"
		if(islist(SSchemistry.chemical_reactions[reaction]))
			var/list/L = SSchemistry.chemical_reactions[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	world << .
*/

//*** params cache
/*
	Ported from bay12, this seems to be used to store and retrieve 2D vectors as strings, as well as
	decoding them into a number
*/
GLOBAL_LIST_EMPTY(paramslist_cache)

#define cached_key_number_decode(key_number_data) cached_params_decode(key_number_data, /proc/key_number_decode)
#define cached_number_list_decode(number_list_data) cached_params_decode(number_list_data, /proc/number_list_decode)

/proc/cached_params_decode(var/params_data, var/decode_proc)
	. = GLOB.paramslist_cache[params_data]
	if(!.)
		. = call(decode_proc)(params_data)
		GLOB.paramslist_cache[params_data] = .

/proc/key_number_decode(var/key_number_data)
	var/list/L = params2list(key_number_data)
	for(var/key in L)
		L[key] = text2num(L[key])
	return L

/proc/number_list_decode(var/number_list_data)
	var/list/L = params2list(number_list_data)
	for(var/i in 1 to L.len)
		L[i] = text2num(L[i])
	return L
