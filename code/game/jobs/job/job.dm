/datum/job

	//The name of the job
	var/title = "NOPE"
	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()      // Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()              // Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/flag = 0 	                      // Bitflags for the job
	var/department_flag = 0
	var/faction = "None"	              // Players will be allowed to spawn in as jobs that are set to "Station"
	var/total_positions = 0               // How many players can be this job
	var/spawn_positions = 0               // How many players can spawn in as this job
	var/current_positions = 0             // How many players have this job
	var/supervisors = null                // Supervisors, who this person answers to directly
	var/selection_color = "#ffffff"       // Selection screen color
	var/idtype = /obj/item/weapon/card/id // The type of the ID the player will have
	var/list/alt_titles                   // List of alternate titles, if any
	var/req_admin_notify                  // If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/minimal_player_age = 0            // If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/department = null                 // Does this position have a department tag?
	var/head_position = 0                 // Is this position Command?
	var/minimum_character_age = 17
	var/ideal_character_age = 30

	var/latejoin_at_spawnpoints = FALSE          //If this job should use roundstart spawnpoints for latejoin (offstation jobs etc)

	var/account_allowed = 1				  // Does this job type come with a station account?
	var/economic_modifier = 2			  // With how much does this job modify the initial account amount?
	var/create_record = 1                 // Do we announce/make records for people who spawn on this job?

	var/bag_type = /obj/item/weapon/storage/backpack
	var/satchel_type = /obj/item/weapon/storage/backpack/satchel_norm
	var/alt_satchel_type = /obj/item/weapon/storage/backpack/satchel
	var/duffel_type = /obj/item/weapon/storage/backpack/duffel
	var/messenger_bag_type = /obj/item/weapon/storage/backpack/messenger

/datum/job/proc/equip(var/mob/living/carbon/human/H)
	return 1

/datum/job/proc/equip_backpack(var/mob/living/carbon/human/H)
	var/type_to_spawn
	var/use_job_specific = H.backbag_style == 1
	switch (H.backbag)
		//if (1)	// No bag selected.
		// Hard-coding bagtype for now since there's only two options.
		if (2)
			type_to_spawn = use_job_specific ? bag_type : /obj/item/weapon/storage/backpack
		if (3)
			type_to_spawn = use_job_specific ? satchel_type : /obj/item/weapon/storage/backpack/satchel_norm
		if (4)
			type_to_spawn = use_job_specific ? alt_satchel_type : /obj/item/weapon/storage/backpack/satchel
		if (5)
			type_to_spawn = use_job_specific ? duffel_type : /obj/item/weapon/storage/backpack/duffel
		if (6)
			type_to_spawn = use_job_specific ? messenger_bag_type : /obj/item/weapon/storage/backpack/messenger

	if (type_to_spawn)
		var/obj/item/bag = new type_to_spawn
		if (H.equip_to_slot_or_del(bag, slot_back))
			bag.autodrobe_no_remove = TRUE

/datum/job/proc/equip_survival(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.species.equip_survival_gear(H,0)
	return 1

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
	var/species_modifier = (H.species ? H.species.economic_modifier : null)
	if (!species_modifier)
		var/datum/species/human_species = global.all_species["Human"]
		species_modifier = human_species.economic_modifier
		PROCLOG_WEIRD("species [H.species || "NULL"] did not have a set economic_modifier!")
	
	var/wage_gap
	switch(H.gender)
		if(MALE)
			wage_gap = 1
		if(FEMALE)
			wage_gap = 0.8
		if(NEUTER)
			wage_gap = 0.7
		else
			wage_gap = 1

	var/money_amount = ((rand(5,50) + rand(5, 50)) * loyalty * economic_modifier * species_modifier) * wage_gap
	var/datum/money_account/M = create_account(H.real_name, money_amount, null)
	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> $[M.money]<br>"

		if(M.transaction_log.len)
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	H << "<span class='notice'><b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b></span>"

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/del()
/datum/job/proc/equip_preview(mob/living/carbon/human/H, var/alt_title)
	. = equip(H, alt_title)

/datum/job/proc/get_access()
	if(!config || config.jobs_have_minimal_access)
		return src.minimal_access.Copy()
	else
		return src.access.Copy()

/datum/job/proc/apply_fingerprints(var/mob/living/carbon/human/target)
	if(!istype(target))
		return 0
	for(var/obj/item/item in target.contents)
		apply_fingerprints_to_item(target, item)
	return 1

/datum/job/proc/apply_fingerprints_to_item(var/mob/living/carbon/human/holder, var/obj/item/item)
	item.add_fingerprint(holder,1)
	if(item.contents.len)
		for(var/obj/item/sub_item in item.contents)
			apply_fingerprints_to_item(holder, sub_item)

/datum/job/proc/is_position_available()
	return (current_positions < total_positions) || (total_positions == -1)

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
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/hoodie(H), slot_wear_suit)
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

/datum/job/proc/has_alt_title(var/mob/H, var/supplied_title, var/desired_title)
	return (supplied_title == desired_title) || (H.mind && H.mind.role_alt_title == desired_title)
