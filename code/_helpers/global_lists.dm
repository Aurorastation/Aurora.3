var/list/clients = list()							//list of all clients
var/list/staff = list()							//list of all clients who have any permissions
var/list/directory = list()							//list of all ckeys with associated client

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

var/global/list/player_list = list()				//List of all mobs **with clients attached**. Excludes /mob/abstract/new_player
var/global/list/mob_list = list()					//List of all mobs, including clientless
var/global/list/human_mob_list = list()				//List of all human mobs and sub-types, including clientless
var/global/list/silicon_mob_list = list()			//List of all silicon mobs, including clientless
var/global/list/living_mob_list = list()			//List of all alive mobs, including clientless. Excludes /mob/abstract/new_player
var/global/list/dead_mob_list = list()				//List of all dead mobs, including clientless. Excludes /mob/abstract/new_player
var/global/list/topic_commands = list()				//List of all API commands available
var/global/list/topic_commands_names = list()				//List of all API commands available

var/global/list/landmarks_list = list()				//list of all landmarks created
var/global/list/surgery_steps = list()				//list of all surgery steps  |BS12
var/global/list/side_effects = list()				//list of all medical sideeffects types by thier names |BS12
var/global/list/mechas_list = list()				//list of all mechs. Used by hostile mobs target tracking.
var/global/list/joblist = list()					//list of all jobstypes, minus borg and AI
var/global/list/brig_closets = list()				//list of all brig secure_closets. Used by brig timers. Probably should be converted to use SSwireless eventually.

var/global/list/teleportlocs = list()
var/global/list/ghostteleportlocs = list()
var/global/list/centcom_areas = list()
var/global/list/the_station_areas = list()

var/global/list/implants = list()

var/global/list/turfs = list()						//list of all turfs
var/global/list/areas_by_type = list()
var/global/list/all_areas = list()

//Languages/species/whitelist.
var/global/list/datum/species/all_species = list()
var/global/list/all_languages = list()
var/global/list/language_keys = list()					// Table of say codes for all languages
var/global/list/whitelisted_species = list("Human") // Species that require a whitelist check.
var/global/list/playable_species = list("Human")    // A list of ALL playable species, whitelisted, latejoin or otherwise.

// Posters
var/global/list/poster_designs = list()

// Uplinks
var/list/obj/item/device/uplink/world_uplinks = list()

//Preferences stuff
//Hairstyles
var/global/list/hair_styles_list = list()			//stores /datum/sprite_accessory/hair indexed by name
var/global/list/hair_styles_male_list = list()
var/global/list/hair_styles_female_list = list()
var/global/list/facial_hair_styles_list = list()	//stores /datum/sprite_accessory/facial_hair indexed by name
var/global/list/facial_hair_styles_male_list = list()
var/global/list/facial_hair_styles_female_list = list()
var/global/list/skin_styles_female_list = list()		//unused
var/global/list/body_marking_styles_list = list()
var/global/list/chargen_disabilities_list = list()
var/global/static/list/valid_player_genders = list(MALE, FEMALE, NEUTER)

//Backpacks
var/global/list/backbaglist = list("Nothing", "Backpack", "Satchel", "Satchel Alt", "Duffel Bag", "Messenger Bag")
var/global/list/backbagstyles = list("Job-specific", "Grey")
var/global/list/exclude_jobs = list(/datum/job/ai,/datum/job/cyborg, /datum/job/merchant)

// Visual nets
var/list/datum/visualnet/visual_nets = list()
var/datum/visualnet/camera/cameranet = new()

// Runes
var/global/list/rune_list = new()
var/global/list/escape_list = list()
var/global/list/endgame_exits = list()
var/global/list/endgame_safespawns = list()

var/global/list/syndicate_access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)

//Cloaking devices
var/global/list/cloaking_devices = list()

//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/makeDatumRefLists()
	var/list/paths

	//Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = subtypesof(/datum/sprite_accessory/hair)
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	hair_styles_male_list += H.name
			if(FEMALE)	hair_styles_female_list += H.name
			else
				hair_styles_male_list += H.name
				hair_styles_female_list += H.name

	sortTim(hair_styles_list, /proc/cmp_text_asc)
	sortTim(hair_styles_male_list, /proc/cmp_text_asc)
	sortTim(hair_styles_female_list, /proc/cmp_text_asc)

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = subtypesof(/datum/sprite_accessory/facial_hair)
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	facial_hair_styles_male_list += H.name
			if(FEMALE)	facial_hair_styles_female_list += H.name
			else
				facial_hair_styles_male_list += H.name
				facial_hair_styles_female_list += H.name

	sortTim(facial_hair_styles_list, /proc/cmp_text_asc)
	sortTim(facial_hair_styles_male_list, /proc/cmp_text_asc)
	sortTim(facial_hair_styles_female_list, /proc/cmp_text_asc)

	//Body markings
	paths = subtypesof(/datum/sprite_accessory/marking)
	for(var/path in paths)
		var/datum/sprite_accessory/marking/M = new path()
		body_marking_styles_list[M.name] = M

	sortTim(body_marking_styles_list, /proc/cmp_text_asc)

	//Disability datums
	paths = subtypesof(/datum/character_disabilities)
	for(var/path in paths)
		var/datum/character_disabilities/T = new path()
		chargen_disabilities_list[T.name] = T

	sortTim(chargen_disabilities_list, /proc/cmp_text_asc)

	//Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = subtypesof(/datum/surgery_step)
	for(var/T in paths)
		var/datum/surgery_step/S = new T
		surgery_steps += S

	sortTim(surgery_steps, /proc/cmp_surgery)

	//List of job. I can't believe this was calculated multiple times per tick!
	paths = subtypesof(/datum/job)
	paths -= exclude_jobs
	for(var/T in paths)
		var/datum/job/J = new T
		joblist[J.title] = J

	//Languages and species.
	paths = subtypesof(/datum/language)
	for(var/T in paths)
		var/datum/language/L = new T
		all_languages[L.name] = L

	for (var/language_name in all_languages)
		var/datum/language/L = all_languages[language_name]
		if(!(L.flags & NONGLOBAL))
			language_keys[lowertext(L.key)] = L

	var/rkey = 0
	paths = subtypesof(/datum/species)
	for(var/T in paths)
		rkey++
		var/datum/species/S = new T
		S.race_key = rkey //Used in mob icon caching.
		all_species[S.name] = S

	sortTim(all_species, /proc/cmp_text_asc)

	// The other lists are generated *after* we sort the main one so they don't need sorting too.
	for (var/thing in all_species)
		var/datum/species/S = all_species[thing]

		if (!(S.spawn_flags & IS_RESTRICTED))
			playable_species += S.name
		if(S.spawn_flags & IS_WHITELISTED)
			whitelisted_species += S.name

	//Posters
	paths = subtypesof(/datum/poster)
	for(var/T in paths)
		var/datum/poster/P = new T
		poster_designs += P

	return 1

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
