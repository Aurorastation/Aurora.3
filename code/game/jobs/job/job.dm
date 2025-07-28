/datum/job
	/// The name of the job.
	var/title = "NOPE"

	/// Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	/// Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/minimal_access = list()
	/// Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/list/access = list()

	/// Bitflags for the job.
	var/flag = 0
	/// Used to tell which set of job bitflags to use to determine the actual job (since there are too many jobs to fit in a single bit flag)
	var/department_flag = 0
	/// Players will be allowed to spawn in as jobs that are set to "Station".
	var/faction = "None"

	/// How many players can be this job.
	var/total_positions = 0
	/// How many players can spawn in as this job.
	var/spawn_positions = 0
	/// How many players have this job.
	var/current_positions = 0

	/// Prefix for the introduction ("As [intro prefix] [title], you answer to...")
	var/intro_prefix = "a"
	/// Supervisors, who this person answers to directly.
	var/supervisors = null
	/// Selection screen color
	var/selection_color = "#5d6a67"
	/// List of departments this job is a part of. Keys are departments, values are a bit field that indicate special roles of that job within the department (like whether they are a head/supervisor of that department).
	var/list/departments = list()
	/// List of alternate titles, if any.
	var/list/alt_titles
	/// An assoc list of title -> list of accesses to add if the person has this title.
	var/list/title_accesses
	/// If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimal_player_age = 0
	/// Age restriction, assoc list of species define -> age; if species isn't found, defaults to SPECIES_HUMAN entry.
	var/list/minimum_character_age = list(
		SPECIES_HUMAN = 17,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)
	/// Assoc list of alt titles to minimum character ages assoc lists (see above -- yes this is slightly awful)
	var/list/alt_ages = null
	/// Assoc list of alt titles (as strings) to a list of faction titles (as strings). Defines what alt title can belong to what faction. Remains Null if no restrictions in use.
	var/list/alt_factions = null

	/// If this job should use roundstart spawnpoints for latejoin (offstation jobs etc)
	var/latejoin_at_spawnpoints = FALSE

	/// Does this job type come with a station account?
	var/account_allowed = TRUE
	/// Does this account appear on account terminals?
	var/public_account = TRUE
	/// If set to anything else, the initial account balance will be set to this instead.
	var/initial_funds_override = 0
	/// With how much does this job modify the initial account amount?
	var/economic_modifier = 2
	/// Do we announce/make records for people who spawn on this job?
	var/create_record = TRUE

	/// The outfit of the job.
	var/obj/outfit/outfit = null
	/// A list of special outfits for the alt titles list("alttitle" = /obj/outfit)
	var/list/alt_outfits = null
	/// A blacklist of species that can't be this job.
	var/list/blacklisted_species = null
	/// A blacklist of citizenships that can't be this job.
	var/list/blacklisted_citizenship = list()

	/// The job name of the aide and bodyguard slots. Used for consulars and representatives.
	var/aide_job
	var/bodyguard_job

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
		var/datum/species/human_species = GLOB.all_species[SPECIES_HUMAN]
		species_modifier = human_species.economic_modifier

	var/money_amount = initial_funds_override ? initial_funds_override : (rand(5,10) + rand(5, 10)) * econ_status * economic_modifier * species_modifier + (rand(0,99) / 100)
	var/datum/money_account/account = SSeconomy.create_and_assign_account(H, null, money_amount, public_account)
	to_chat(H, SPAN_BOLD(SPAN_NOTICE("Your account number is: [account.account_number], your account pin is: [account.remote_access_pin]")))

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/del()
/datum/job/proc/equip_preview(mob/living/carbon/human/H, datum/preferences/prefs, var/alt_title, var/faction_override)
	if(faction_override)
		var/faction = SSjobs.name_factions[faction_override]
		if(faction)
			var/datum/faction/F = faction
			if(!F.is_default)
				var/new_outfit = F.titles_to_loadout[title]
				if(ispath(new_outfit))
					var/obj/outfit/O = new new_outfit
					O.pre_equip(H, TRUE)
					O.equip(H, TRUE)
					return

	var/pre_hat_ref = H.head ? REF(H.head) : null
	var/pre_uniform_ref = H.w_uniform ? REF(H.w_uniform) : null
	var/pre_suit_ref = H.wear_suit ? REF(H.wear_suit) : null

	pre_equip(H, TRUE)
	. = equip(H, TRUE, FALSE, alt_title=alt_title)

	// slightly hacky, but effectively what we're doing here is checking whether we want this preview mob to actually have the uniform we're putting onto it
	// if not, we drop it from the inventory into nullspace, and then deleting it
	// i don't THINK this'll make performance that much worse, considering how much we already do to equip the mob in the first place
	// the reasoning for the ref checks is that we don't want to delete loadout uniforms, just the job ones, so we need to confirm the before and after

	var/equip_preview_mob = prefs.equip_preview_mob

	if(!(equip_preview_mob & EQUIP_PREVIEW_JOB_HAT) && H.head && REF(H.head) != pre_hat_ref)
		H.drop_from_inventory(H.head)
		qdel(H.head)

	if(!(equip_preview_mob & EQUIP_PREVIEW_JOB_UNIFORM) && H.w_uniform && REF(H.w_uniform) != pre_uniform_ref)
		H.drop_from_inventory(H.w_uniform)
		qdel(H.w_uniform)

	if(!(equip_preview_mob & EQUIP_PREVIEW_JOB_SUIT) && H.wear_suit && REF(H.wear_suit) != pre_suit_ref)
		H.drop_from_inventory(H.wear_suit)
		qdel(H.wear_suit)

/datum/job/proc/get_access(selected_title)
	SHOULD_NOT_SLEEP(TRUE)

	if(!GLOB.config || GLOB.config.jobs_have_minimal_access)
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

/datum/job/proc/fetch_age_restriction()
	if (!GLOB.config.age_restrictions_from_file)
		return

	if (GLOB.config.age_restrictions[lowertext(title)])
		minimal_player_age = GLOB.config.age_restrictions[lowertext(title)]
	else
		minimal_player_age = 0

/datum/job/proc/has_alt_title(var/mob/H, var/supplied_title, var/desired_title)
	return (supplied_title == desired_title) || (H.mind && H.mind.role_alt_title == desired_title)

/**
 * This is the proc responsible for actually opening the aide slot.
 * The `aide_job` on the job datum must be a valid, existing job. Blame the fact that we don't have job defines. Or singletons.
 */
/datum/job/proc/open_aide_slot(mob/living/carbon/human/representative)
	if(!aide_job)
		log_debug("Generic Open Aide Slot called without an aide job.")
		return FALSE

	if(!representative)
		log_debug("Generic Open Aide Slot called without a mob.")
		return FALSE

	var/confirm = tgui_alert(representative, "Are you sure you want to open an assistant slot? This can only be used once.", "Open Aide Slot", list("Yes", "No"))
	if(confirm != "Yes")
		return FALSE
	var/datum/job/J = SSjobs.GetJob(aide_job)

	// At this point, we add the relevant blacklists in the proc below.
	post_open_aide_slot(representative, J)

	// Now that the blacklists are applied, open the job.
	J.total_positions++
	to_chat(representative, SPAN_NOTICE("A slot for a [aide_job] has been opened."))
	return TRUE

/**
 * This proc is called when a job opens an aide slot. It MUST be called manually.
 * It is responsible for adding any relevant blacklists to the aide job datum.
 */
/datum/job/proc/post_open_aide_slot(mob/living/carbon/human/representative, datum/job/aide)
	return

/**
 * This proc is called when an aide slot is closed (cryoing or leaving the game).
 * It is responsible for cleaning up existing slots and wiping any applied blacklists to the aide's job datum.
 */
/datum/job/proc/close_aide_slot(mob/living/carbon/human/representative, datum/job/aide)
	return

/**
 * This is the verb you should give to a mob to allow it to summon an aide.
 */
/mob/living/carbon/human/proc/summon_aide()
	set name = "Open Aide Slot"
	set desc = "Allows an aide to join you as an assistant or companion."
	set category = "IC"

	var/datum/job/J = SSjobs.GetJob(job)
	if(J.open_aide_slot(src))
		remove_verb(src, /mob/living/carbon/human/proc/summon_aide)

/**
 * This is the proc responsible for actually opening the bodyguard slot.
 * The `bodyguard_job` on the job datum must be a valid, existing job. Blame the fact that we don't have job defines. Or singletons.
 */
/datum/job/proc/open_bodyguard_slot(mob/living/carbon/human/representative)
	if(!bodyguard_job)
		log_debug("Generic Open Bodyguard Slot called without an bodyguard job.")
		return FALSE

	if(!representative)
		log_debug("Generic Open Bodyguard Slot called without a mob.")
		return FALSE

	var/confirm = tgui_alert(representative, "Are you sure you want to open a bodyguard slot? This can only be used once.", "Open Bodyguard Slot", list("Yes", "No"))
	if(confirm != "Yes")
		return FALSE
	var/datum/job/J = SSjobs.GetJob(bodyguard_job)

	// At this point, we add the relevant blacklists in the proc below.
	post_open_bodyguard_slot(representative, J)

	// Now that the blacklists are applied, open the job.
	J.total_positions++
	to_chat(representative, SPAN_NOTICE("A slot for a [bodyguard_job] has been opened."))
	return TRUE

/**
 * This proc is called when a job opens a bodyguard slot. It MUST be called manually.
 * It is responsible for adding any relevant blacklists to the bodyguard job datum.
 */
/datum/job/proc/post_open_bodyguard_slot(mob/living/carbon/human/representative, datum/job/bodyguard)
	return

/**
 * This proc is called when a bodyguard slot is closed (cryoing or leaving the game).
 * It is responsible for cleaning up existing slots and wiping any applied blacklists to the bodyguard's job datum.
 */
/datum/job/proc/close_bodyguard_slot(mob/living/carbon/human/representative, datum/job/bodyguard)
	return

/**
 * This is the verb you should give to a mob to allow it to summon an bodyguard.
 */
/mob/living/carbon/human/proc/summon_bodyguard()
	set name = "Open Bodyguard Slot"
	set desc = "Allows a bodyguard to join you to help protect you."
	set category = "IC"

	var/datum/job/J = SSjobs.GetJob(job)
	if(J.open_bodyguard_slot(src))
		remove_verb(src, /mob/living/carbon/human/proc/summon_bodyguard)


/obj/outfit/job
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
	clipon_radio = /obj/item/device/radio/headset/wrist/clip

	tab_pda = /obj/item/modular_computer/handheld/pda/civilian
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/civilian
	tablet = /obj/item/modular_computer/handheld/preset/civilian

	var/box = /obj/item/storage/box/survival

/obj/outfit/job/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	back = null //Nulling the backpack here, since we already equipped the backpack in pre_equip
	if(box)
		var/spawnbox = box
		backpack_contents.Insert(1, spawnbox) // Box always takes a first slot in backpack
		backpack_contents[spawnbox] = 1
	. = ..()

/obj/outfit/job/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

/obj/outfit/job/get_id_access(mob/living/carbon/human/H)
	var/datum/job/J = SSjobs.GetJobType(jobtype)
	if(!J)
		J = SSjobs.GetJob(H.job)
	return J.get_access(get_id_assignment(H, TRUE))

/obj/outfit/job/get_id_rank(mob/living/carbon/human/H)
	var/datum/job/J = SSjobs.GetJobType(jobtype)
	if(!J)
		J = SSjobs.GetJob(H.job)
	return J.title
