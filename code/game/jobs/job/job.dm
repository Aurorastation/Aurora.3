/datum/job
	var/title = "NOPE"                    //The name of the job
	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()      // Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()              // Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	var/flag = 0                          // Bitflags for the job
	var/department_flag = 0               // Used to tell which set of job bitflags to use to determine the actual job (since there are too many jobs to fit in a single bit flag)
	var/faction = "None"	              // Players will be allowed to spawn in as jobs that are set to "Station"

	var/total_positions = 0               // How many players can be this job
	var/spawn_positions = 0               // How many players can spawn in as this job
	var/current_positions = 0             // How many players have this job

	var/intro_prefix = "a"
	var/supervisors = null                // Supervisors, who this person answers to directly
	var/selection_color = "#5d6a67"     // Selection screen color
	var/list/departments = list()         // List of departments this job is a part of. Keys are departments, values are a bit field that indicate special roles of that job within the department (like whether they are a head/supervisor of that department).
	var/list/alt_titles                   // List of alternate titles, if any
	var/list/title_accesses               // A map of title -> list of accesses to add if the person has this title.
	var/minimal_player_age = 0            // If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/list/minimum_character_age = list(// Age restriction, assoc list of species define -> age; if species isn't found, defaults to SPECIES_HUMAN entry
		SPECIES_HUMAN = 17,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	var/list/alt_ages = null              // assoc list of alt titles to minimum character ages assoc lists (see above -- yes this is slightly awful)
	var/list/ideal_character_age = list(  // Ideal character ages (for heads), assoc list of species define -> age, see above
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 100,
		SPECIES_SKRELL_AXIORI = 100
	)

	var/latejoin_at_spawnpoints = FALSE   //If this job should use roundstart spawnpoints for latejoin (offstation jobs etc)

	var/account_allowed = TRUE            // Does this job type come with a station account?
	var/public_account = TRUE             // does this account appear on account terminals?
	var/initial_funds_override = 0        // if set to anything else, the initial account balance will be set to this instead
	var/economic_modifier = 2             // With how much does this job modify the initial account amount?
	var/create_record = TRUE              // Do we announce/make records for people who spawn on this job?

	var/datum/outfit/outfit = null
	var/list/alt_outfits = null           // A list of special outfits for the alt titles list("alttitle" = /datum/outfit)
	var/list/blacklisted_species = null   // A blacklist of species that can't be this job
	var/list/blacklisted_citizenship = list() //A blacklist of citizenships that can't be this job

//Only override this proc
/datum/job/proc/pre_spawn(mob/abstract/new_player/player)
	return

/datum/job/proc/after_spawn(mob/living/carbon/human/H)

/datum/job/proc/on_despawn(mob/living/carbon/human/H)
	return

/datum/job/proc/announce(mob/living/carbon/human/H)

/datum/job/proc/get_outfit(mob/living/carbon/human/H, alt_title=null)
	//Check if we have a speical outfit for that alt title
	alt_title = H?.mind?.role_alt_title || alt_title

	if (H?.mind?.selected_faction?.titles_to_loadout)
		if (alt_title && H.mind.selected_faction.titles_to_loadout[alt_title])
			return H.mind.selected_faction.titles_to_loadout[alt_title]
		else if (H.mind.selected_faction.titles_to_loadout[H.job])
			return H.mind.selected_faction.titles_to_loadout[H.job]

	if (alt_title && LAZYACCESS(alt_outfits, alt_title))
		return alt_outfits[alt_title]

	if (alt_outfits && alt_outfits[H.job])
		return alt_outfits[H.job]
	else if (outfit)
		return outfit

/datum/job/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE, alt_title = null)
	if(!H)
		return 0

	H.species.before_equip(H, visualsOnly, src)
	H.preEquipOutfit(get_outfit(H, alt_title), visualsOnly)

/datum/job/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, alt_title = null)
	if(!H)
		return 0
	H.equipOutfit(get_outfit(H, alt_title), visualsOnly)

	H.species.after_equip(H, visualsOnly, src)

	if(!visualsOnly && announce)
		announce(H)

/datum/job/proc/setup_account(var/mob/living/carbon/human/H)
	if(!account_allowed || (H.mind && H.mind.initial_account))
		return

	var/econ_status = 1
	if(H.client)
		switch(H.client.prefs.economic_status)
			if(ECONOMICALLY_WEALTHY)		econ_status = 1.30
			if(ECONOMICALLY_WELLOFF)		econ_status = 1.15
			if(ECONOMICALLY_AVERAGE)		econ_status = 1
			if(ECONOMICALLY_UNDERPAID)		econ_status = 0.75
			if(ECONOMICALLY_POOR)			econ_status = 0.50
			if(ECONOMICALLY_DESTITUTE)		econ_status = 0.25
			if(ECONOMICALLY_RUINED)			econ_status = 0.01

	//give them an account in the station database
	var/species_modifier = (H.species ? H.species.economic_modifier : null)
	if (!species_modifier)
		var/datum/species/human_species = global.all_species[SPECIES_HUMAN]
		species_modifier = human_species.economic_modifier

	var/money_amount = initial_funds_override ? initial_funds_override : (rand(5,50) + rand(5, 50)) * econ_status * economic_modifier * species_modifier
	var/datum/money_account/M = SSeconomy.create_account(H.real_name, money_amount, null, public_account)
	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> [M.money]电<br>"

		if(M.transactions.len)
			var/datum/transaction/T = M.transactions[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	to_chat(H, "<span class='notice'><b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b></span>")

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/del()
/datum/job/proc/equip_preview(mob/living/carbon/human/H, var/alt_title, var/faction_override)
	if(faction_override)
		var/faction = SSjobs.name_factions[faction_override]
		if(faction)
			var/datum/faction/F = faction
			if(!F.is_default)
				var/new_outfit = F.titles_to_loadout[title]
				if(ispath(new_outfit))
					var/datum/outfit/O = new new_outfit
					O.pre_equip(H, TRUE)
					O.equip(H, TRUE)
					return
	pre_equip(H, TRUE)
	. = equip(H, TRUE, FALSE, alt_title=alt_title)

/datum/job/proc/get_access(selected_title)
	if(!config || config.jobs_have_minimal_access)
		. = minimal_access.Copy()
	else
		. = access.Copy()

	if (LAZYLEN(title_accesses) && title_accesses[selected_title])
		. += title_accesses[selected_title]

/datum/job/proc/get_total_positions()
	return total_positions

/datum/job/proc/get_spawn_positions()
	return spawn_positions

/datum/job/proc/is_position_available()
	var/total = get_total_positions()
	return (current_positions < total) || (total == -1)

/datum/job/proc/get_minimum_character_age(var/species)
	if(!species || !(species in minimum_character_age))
		species = SPECIES_HUMAN
	return minimum_character_age[species]

/datum/job/proc/get_alt_character_age(var/species, var/title)
	// call this w/o title to get the most minimum of alt ages, used in occupation.dm:/datum/category_item/player_setup_item/occupation/content
	if(!species)
		species = SPECIES_HUMAN
	var/min_alt_age
	if(!title)
		for(var/t in alt_ages)
			if(species in alt_ages[t])
				min_alt_age = min(min_alt_age, alt_ages[t][species])
			else
				min_alt_age = min(min_alt_age, alt_ages[t][SPECIES_HUMAN])
		return min_alt_age
	else if(title in alt_ages)
		return (species in alt_ages[title]) ? alt_ages[title][species] : alt_ages[title][SPECIES_HUMAN]

/datum/job/proc/get_ideal_character_age(var/species)
	if(!species)
		species = SPECIES_HUMAN
	else if(!(species in ideal_character_age))
		// try to see if there's a min age set -- ideally this shouldn't happen, but better to take a min age than fall back to human just yet
		if(species in minimum_character_age) // if there is one, just add 20 and send it
			return minimum_character_age[species] + 20
		species = SPECIES_HUMAN // no such luck
	return ideal_character_age[species]

/datum/job/proc/fetch_age_restriction()
	if (!config.age_restrictions_from_file)
		return

	if (config.age_restrictions[lowertext(title)])
		minimal_player_age = config.age_restrictions[lowertext(title)]
	else
		minimal_player_age = 0

/datum/job/proc/has_alt_title(var/mob/H, var/supplied_title, var/desired_title)
	return (supplied_title == desired_title) || (H.mind && H.mind.role_alt_title == desired_title)

/datum/outfit/job
	name = "Standard Gear"
	var/base_name = null
	collect_not_del = FALSE

	var/allow_loadout = TRUE
	allow_backbag_choice = TRUE
	allow_pda_choice = TRUE
	allow_headset_choice = TRUE
	var/jobtype = null

	uniform = /obj/item/clothing/under/color/grey
	id = /obj/item/card/id
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/sneakers/black

	headset = /obj/item/device/radio/headset
	bowman = /obj/item/device/radio/headset/alt
	double_headset = /obj/item/device/radio/headset/alt/double
	wrist_radio = /obj/item/device/radio/headset/wrist

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian
	tablet = /obj/item/modular_computer/handheld/preset/civilian

	var/box = /obj/item/storage/box/survival

/datum/outfit/job/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	back = null //Nulling the backpack here, since we already equipped the backpack in pre_equip
	if(box)
		var/spawnbox = box
		backpack_contents.Insert(1, spawnbox) // Box always takes a first slot in backpack
		backpack_contents[spawnbox] = 1
	. = ..()

/datum/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

/datum/outfit/job/get_id_access(mob/living/carbon/human/H)
	var/datum/job/J = SSjobs.GetJobType(jobtype)
	if(!J)
		J = SSjobs.GetJob(H.job)
	return J.get_access(get_id_assignment(H, TRUE))

/datum/outfit/job/get_id_rank(mob/living/carbon/human/H)
	var/datum/job/J = SSjobs.GetJobType(jobtype)
	if(!J)
		J = SSjobs.GetJob(H.job)
	return J.title
