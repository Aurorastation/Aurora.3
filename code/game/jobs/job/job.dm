/datum/job

	//The name of the job
	var/title = "NOPE"
	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()         // Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()                 // Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)

	var/total_positions = 0                  // How many players can be this job
	var/spawn_positions = 0                  // How many players can spawn in as this job
	var/current_positions = 0                // How many players have this job

	var/supervisors = null                   // Supervisors, who this person answers to directly
	var/selection_color = "#ffffff"          // Selection screen color
	var/department = null                    // Does this position have a department tag?
	var/head_position = FALSE                // Is this position Command?

	var/minimal_player_age = 0               // If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/minimum_character_age = 17
	var/ideal_character_age = 30

	var/latejoin_at_spawnpoints = FALSE          //If this job should use roundstart spawnpoints for latejoin (offstation jobs etc)

	var/account_allowed = TRUE             // Does this job type come with a station account?
	var/economic_modifier = 2              // With how much does this job modify the initial account amount?
	var/create_record = TRUE               // Do we announce/make records for people who spawn on this job?

	var/list/factions = null               // List of faction datums that can join as the role. Fill with a list of type paths to all factions that have access to this job.
	var/list/alternative_jobs = null       // A lazylist of job datums which act as alt titles for this one. Populated automatically from SSjobs.
	var/datum/job/master_job  = null       // If this job acts as an alt title, set this to the master job. Fill this in when making an alt title with the path to the master.

	var/datum/outfit/outfit = null

/datum/job/New()
	if (!factions)
		factions = list(current_map.default_faction_type)

//Only override this proc
/datum/job/proc/after_spawn(mob/living/carbon/human/H)

/datum/job/proc/announce(mob/living/carbon/human/H)

/datum/job/proc/get_outfit(mob/living/carbon/human/H)
	return outfit

/datum/job/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return 0

	H.species.before_equip(H, visualsOnly, src)
	H.preEquipOutfit(get_outfit(H), visualsOnly)

/datum/job/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE)
	if(!H)
		return 0
	H.equipOutfit(get_outfit(H), visualsOnly)

	H.species.after_equip(H, visualsOnly, src)

	if(!visualsOnly && announce)
		announce(H)

/datum/job/proc/setup_account(var/mob/living/carbon/human/H)
	if(!account_allowed || (H.mind && H.mind.initial_account))
		return

	var/loyalty = 1
	if(H.client)
		switch(H.client.prefs.nanotrasen_relation)
			if(COMPANY_LOYAL)        loyalty = 1.30
			if(COMPANY_SUPPORTATIVE) loyalty = 1.15
			if(COMPANY_NEUTRAL)      loyalty = 1
			if(COMPANY_SKEPTICAL)    loyalty = 0.85
			if(COMPANY_OPPOSED)      loyalty = 0.70

	//give them an account in the station database
	var/species_modifier = H?.species.economic_modifier
	if (!species_modifier)
		var/datum/species/human_species = global.all_species["Human"]
		species_modifier = human_species.economic_modifier
		PROCLOG_WEIRD("species [H.species || "NULL"] did not have a set economic_modifier!")

	var/money_amount = (rand(5,50) + rand(5, 50)) * loyalty * economic_modifier * species_modifier
	var/datum/money_account/M = SSeconomy.create_account(H.real_name, money_amount, null)
	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> $[M.money]<br>"

		if(M.transactions.len)
			var/datum/transaction/T = M.transactions[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	to_chat(H, "<span class='notice'><b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b></span>")

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/del()
/datum/job/proc/equip_preview(mob/living/carbon/human/H)
	pre_equip(H, TRUE)
	. = equip(H, TRUE, FALSE)

/datum/job/proc/get_access()
	if(!config || config.jobs_have_minimal_access)
		. = minimal_access.Copy()
	else
		. = access.Copy()

/**
 * Checks if the job has open positions.
 *
 * Positions are both alternate title specific AND master job specific.
 * This is to say, you can limit 4 Engineers + Engineer sub titles, and you can
 * also limit to only have 1 Engine Technician.
 *
 * This is accomplished by having this proc recursively call up to the master_job's
 * definition of it. And the master_job's definition will sum all of its sub jobs.
 *
 * This will be infinitely recursive if there's a master_job loop somewhere.
 *
 * Returns TRUE if the job in question has joinable slots, FALSE otherwise.
 */
/datum/job/proc/has_open_slots()
	. = FALSE

	var/position_limit = total_positions

	var/occupied_slots = current_positions

	if (!master_job && LAZYLEN(alternative_jobs))
		for (var/datum/job/J in alternative_jobs)
			occupied_slots += J.current_positions

	if(!latejoin)
		position_limit = spawn_positions

	if((occupied_slots < position_limit) || position_limit == -1)
		. = TRUE

	if (master_job)
		. = . && master_job.has_open_slots()

/**
 * Increases
 */
/datum/job/proc/increase_total_positions()
	total_positions++

	if (master_job)
		master_job.total_positions++

/datum/job/proc/iterate_current_positions()
	current_positions++

/datum/job/proc/fetch_age_restriction()
	if (!config.age_restrictions_from_file)
		return

	if (config.age_restrictions[lowertext(title)])
		minimal_player_age = config.age_restrictions[lowertext(title)]
	else
		minimal_player_age = 0

/datum/job/proc/late_equip(var/mob/living/carbon/human/H)
	if(!H)
		return 0

	H.species.before_equip(H, FALSE, src)

	var/loyalty = 1
	if(H.client)
		switch(H.client.prefs.nanotrasen_relation)
			if(COMPANY_LOYAL)        loyalty = 3
			if(COMPANY_SUPPORTATIVE) loyalty = 2
			if(COMPANY_NEUTRAL)      loyalty = 1
			if(COMPANY_SKEPTICAL)    loyalty = -2
			if(COMPANY_OPPOSED)      loyalty = -3

	//give them an account in the station database
	var/species_modifier = min((H.species ? H.species.economic_modifier : 0) - 9, 0)

	var/wealth = (loyalty + economic_modifier + species_modifier)

	switch(wealth)
		if(-INFINITY to 2)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		if(3 to 6)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/grey(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		if(7 to 9)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/sl_suit(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/red(H), slot_tie)
		if(10 to 14)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/really_black(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/briefcase(H), slot_l_hand)
		if(15 to INFINITY)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/sl_suit(H), slot_w_uniform)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/red(H), slot_tie)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket(H), slot_wear_suit)
			H.equip_to_slot_or_del(new /obj/item/clothing/accessory/locket(H), slot_tie)

/datum/outfit/job
	name = "Standard Gear"
	var/base_name = null
	collect_not_del = FALSE

	var/allow_loadout = TRUE
	var/allow_backbag_choice = TRUE
	var/jobtype = null

	uniform = /obj/item/clothing/under/color/grey
	id = /obj/item/weapon/card/id
	l_ear = /obj/item/device/radio/headset
	back = /obj/item/weapon/storage/backpack
	shoes = /obj/item/clothing/shoes/black
	pda = /obj/item/device/pda

	var/backpack = /obj/item/weapon/storage/backpack
	var/satchel = /obj/item/weapon/storage/backpack/satchel_norm
	var/satchel_alt = /obj/item/weapon/storage/backpack/satchel
	var/dufflebag = /obj/item/weapon/storage/backpack/duffel
	var/messengerbag = /obj/item/weapon/storage/backpack/messenger
	var/box = /obj/item/weapon/storage/box/survival

/datum/outfit/job/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(allow_backbag_choice)
		var/use_job_specific = H.backbag_style == 1
		switch(H.backbag)
			if (1)
				back = null
			if (2)
				back = use_job_specific ? backpack : /obj/item/weapon/storage/backpack
			if (3)
				back = use_job_specific ? satchel : /obj/item/weapon/storage/backpack/satchel_norm
			if (4)
				back = use_job_specific ? satchel_alt : /obj/item/weapon/storage/backpack/satchel
			if (5)
				back = use_job_specific ? dufflebag : /obj/item/weapon/storage/backpack/duffel
			if (6)
				back = use_job_specific ? messengerbag : /obj/item/weapon/storage/backpack/messenger
			else
				back = backpack //Department backpack
	if(back)
		equip_item(H, back, slot_back)

	if(istype(H.back,/obj/item/weapon/storage/backpack))
		var/obj/item/weapon/storage/backpack/B = H.back
		B.autodrobe_no_remove = TRUE

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
	return J.get_access(get_id_assignment(H))

/datum/outfit/job/get_id_rank(mob/living/carbon/human/H)
	var/datum/job/J = SSjobs.GetJobType(jobtype)
	if(!J)
		J = SSjobs.GetJob(H.job)
	return J.title
