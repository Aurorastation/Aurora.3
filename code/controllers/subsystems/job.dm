/var/datum/controller/subsystem/jobs/SSjobs

#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

#define Debug(text) if (Debug2) {job_debug += text}

/datum/controller/subsystem/jobs
	// Subsystem stuff.
	name = "Jobs"
	flags = SS_NO_FIRE
	init_order = SS_INIT_JOBS

	// Vars.
	var/list/occupations = list()
	var/list/unassigned = list()
	var/list/job_debug = list()

/datum/controller/subsystem/jobs/New()
	NEW_SS_GLOBAL(SSjobs)

/datum/controller/subsystem/jobs/Initialize()
	SetupOccupations()
	LoadJobs("config/jobs.txt")
	..()

/datum/controller/subsystem/jobs/Recover()
	occupations = SSjobs.occupations
	unassigned = SSjobs.unassigned
	job_debug = SSjobs.job_debug
	if (islist(job_debug))
		job_debug += "NOTICE: Job system Recover() triggered."

/datum/controller/subsystem/jobs/proc/SetupOccupations(faction = "Station")
	occupations = list()
	var/list/all_jobs = current_map.allowed_jobs
	if(!all_jobs.len)
		world << "<span class='warning'>Error setting up jobs, no job datums found!</span>"
		return FALSE

	for(var/J in all_jobs)
		var/datum/job/job = new J()
		if(!job || job.faction != faction)
			continue
		occupations += job
		if (config && config.use_age_restriction_for_jobs)
			job.fetch_age_restriction()

	return TRUE

/datum/controller/subsystem/jobs/proc/GetJob(rank)
	if (!rank)
		return null

	for (var/thing in occupations)
		var/datum/job/J = thing
		if (!J)
			continue

		if (J.title == rank)
			return J

/datum/controller/subsystem/jobs/proc/ShouldCreateRecords(var/rank)
	if(!rank) return 0
	var/datum/job/job = GetJob(rank)
	if(!job) return 0
	return job.create_record

/datum/controller/subsystem/jobs/proc/GetPlayerAltTitle(mob/new_player/player, rank)
	. = player.client.prefs.GetPlayerAltTitle(GetJob(rank))

/datum/controller/subsystem/jobs/proc/AssignRole(mob/new_player/player, rank, latejoin = FALSE)
	Debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
	if(player && player.mind && rank)
		var/datum/job/job = GetJob(rank)
		if(!job)
			return FALSE
		if(jobban_isbanned(player, rank))
			return FALSE

		var/position_limit = job.total_positions
		if(!latejoin)
			position_limit = job.spawn_positions
		if((job.current_positions < position_limit) || position_limit == -1)
			Debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
			player.mind.assigned_role = rank
			player.mind.role_alt_title = GetPlayerAltTitle(player, rank)
			unassigned -= player
			job.current_positions++
			return TRUE
	Debug("AR has failed, Player: [player], Rank: [rank]")
	return FALSE

/datum/controller/subsystem/jobs/proc/FreeRole(rank)
	var/datum/job/job = GetJob(rank)

	if (job && job.current_positions >= job.total_positions && job.total_positions != -1)
		job.total_positions++
		return TRUE

	return FALSE

/datum/controller/subsystem/jobs/proc/FindOccupationCandidates(datum/job/job, level, flag)
	Debug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
	. = list()
	for(var/mob/new_player/player in unassigned)
		if(jobban_isbanned(player, job.title))
			Debug("FOC isbanned failed, Player: [player]")
			continue
		if(flag && !(flag in player.client.prefs.be_special_role))
			Debug("FOC flag failed, Player: [player], Flag: [flag], ")
			continue
		if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
			Debug("FOC pass, Player: [player], Level:[level]")
			. += player

/datum/controller/subsystem/jobs/proc/GiveRandomJob(mob/new_player/player)
	Debug("GRJ Giving random job, Player: [player]")
	for(var/thing in shuffle(occupations))
		var/datum/job/job = thing
		if(!job)
			continue

		if(istype(job, GetJob("Assistant"))) // We don't want to give him assistant, that's boring!
			continue

		if(job in command_positions) //If you want a command position, select it!
			continue

		if(jobban_isbanned(player, job.title))
			Debug("GRJ isbanned failed, Player: [player], Job: [job.title]")
			continue

		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			Debug("GRJ Random job given, Player: [player], Job: [job]")
			AssignRole(player, job.title)
			unassigned -= player
			break

/datum/controller/subsystem/jobs/proc/ResetOccupations()
	for(var/mob/new_player/player in player_list)
		if((player) && (player.mind))
			player.mind.assigned_role = null
			player.mind.special_role = null
	SetupOccupations()
	unassigned = list()

///This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
/datum/controller/subsystem/jobs/proc/FillHeadPosition()
	for(var/level = 1 to 3)
		for(var/command_position in command_positions)
			var/datum/job/job = GetJob(command_position)
			if(!job)
				continue

			var/list/candidates = FindOccupationCandidates(job, level)
			if(!candidates.len)
				continue

			// Build a weighted list, weight by age.
			var/list/weightedCandidates = list()
			for(var/mob/V in candidates)
				// Log-out during round-start? What a bad boy, no head position for you!
				if(!V.client)
					continue

				var/age = V.client.prefs.age

				switch(age)
					if(job.minimum_character_age to (job.minimum_character_age+10))
						weightedCandidates[V] = 3 // Still a bit young.
					if((job.minimum_character_age+10) to (job.ideal_character_age-10))
						weightedCandidates[V] = 6 // Better.
					if((job.ideal_character_age-10) to (job.ideal_character_age+10))
						weightedCandidates[V] = 10 // Great.
					if((job.ideal_character_age+10) to (job.ideal_character_age+20))
						weightedCandidates[V] = 6 // Still good.
					if((job.ideal_character_age+20) to INFINITY)
						weightedCandidates[V] = 3 // Geezer.
					else
						// If there's ABSOLUTELY NOBODY ELSE
						if(candidates.len == 1) weightedCandidates[V] = 1

			var/mob/new_player/candidate = pickweight(weightedCandidates)
			if(AssignRole(candidate, command_position))
				return TRUE
	return FALSE


///This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
/datum/controller/subsystem/jobs/proc/CheckHeadPositions(level)
	for(var/command_position in command_positions)
		var/datum/job/job = GetJob(command_position)
		if(!job)	continue
		var/list/candidates = FindOccupationCandidates(job, level)
		if(!candidates.len)	continue
		var/mob/new_player/candidate = pick(candidates)
		AssignRole(candidate, command_position)


/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/subsystem/jobs/proc/DivideOccupations()
	//Setup new player list and get the jobs list
	Debug("Running DO")
	SetupOccupations()

	//Holder for Triumvirate is stored in the ticker, this just processes it
	if(SSticker.triai)
		for(var/datum/job/A in occupations)
			if(A.title == "AI")
				A.spawn_positions = 3
				break

	//Get the players who are ready
	for(var/mob/new_player/player in player_list)
		if(player.ready && player.mind && !player.mind.assigned_role)
			unassigned += player

	Debug("DO, Len: [unassigned.len]")
	if(unassigned.len == 0)
		return FALSE

	//Shuffle players and jobs
	unassigned = shuffle(unassigned)

	HandleFeedbackGathering()

	//People who wants to be assistants, sure, go on.
	Debug("DO, Running Assistant Check 1")
	var/datum/job/assist = new DEFAULT_JOB_TYPE ()
	var/list/assistant_candidates = FindOccupationCandidates(assist, 3)
	Debug("AC1, Candidates: [assistant_candidates.len]")
	for(var/mob/new_player/player in assistant_candidates)
		Debug("AC1 pass, Player: [player]")
		AssignRole(player, "Assistant")
		assistant_candidates -= player
	Debug("DO, AC1 end")

	//Select one head
	Debug("DO, Running Head Check")
	FillHeadPosition()
	Debug("DO, Head Check end")

	//Other jobs are now checked
	Debug("DO, Running Standard Check")


	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(occupations)
	// var/list/disabled_jobs = ticker.mode.disabled_jobs  // So we can use .Find down below without a colon.
	for(var/level = 1 to 3)
		//Check the head jobs first each level
		CheckHeadPositions(level)

		// Loop through all unassigned players
		for(var/mob/new_player/player in unassigned)

			// Loop through all jobs
			for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
				if(!job || (job.title in SSticker.mode.disabled_jobs) ) //11/2/16
					continue

				if(jobban_isbanned(player, job.title))
					Debug("DO isbanned failed, Player: [player], Job:[job.title]")
					continue

				// If the player wants that job on this level, then try give it to him.
				if(player.client.prefs.GetJobDepartment(job, level) & job.flag)

					// If the job isn't filled
					if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
						Debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
						AssignRole(player, job.title)
						unassigned -= player
						break

	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
			GiveRandomJob(player)

	Debug("DO, Standard Check end")

	Debug("DO, Running AC2")

	// For those who wanted to be assistant if their preferences were filled, here you go.
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == BE_ASSISTANT)
			Debug("AC2 Assistant located, Player: [player]")
			AssignRole(player, "Assistant")

	//For ones returning to lobby
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = 0
			player.new_player_panel_proc()
			unassigned -= player
	return TRUE

/datum/controller/subsystem/jobs/proc/EquipRank(mob/living/carbon/human/H, rank, joined_late = FALSE, megavend = FALSE)
	if(!H)
		return null

	Debug("ER/([H]): Entry, joined_late=[joined_late],megavend=[megavend].")

	var/datum/job/job = GetJob(rank)
	var/list/spawn_in_storage = list()

	if(job)
		var/list/custom_equip_slots = list() //If more than one item takes the same slot, all after the first one spawn in storage.
		var/list/custom_equip_leftovers = list()
		//Equip job items.
		if(!megavend)	//Equip custom gear loadout.
			Debug("ER/([H]): Equipping custom loadout.")
			job.equip_backpack(H)
			job.setup_account(H)

			EquipCustom(H, job, H.client.prefs, custom_equip_leftovers, spawn_in_storage, custom_equip_slots)

			// This goes after custom loadout it doesn't prevent custom loadout stuff from being equipped.
			job.equip_survival(H)

		job.equip(H)
		job.apply_fingerprints(H)

		// Randomize nutrition. Defines are in __defines/mobs.dm
		H.nutrition = (rand(CREW_MINIMUM_NUTRITION, CREW_MAXIMUM_NUTRITION) * 0.01) * H.max_nutrition

		if (!megavend)
			spawn_in_storage += EquipCustomDeferred(H, H.client.prefs, custom_equip_leftovers, custom_equip_slots)
	else
		H << "Your job is [rank] and the game just can't handle it! Please report this bug to an administrator."

	H.job = rank

	if(!joined_late || job.latejoin_at_spawnpoints)
		var/obj/S = get_roundstart_spawnpoint(rank)
		if(istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf))
			H.loc = S.loc
		else
			LateSpawn(H, rank)

		// Moving wheelchair if they have one
		if(H.buckled && istype(H.buckled, /obj/structure/bed/chair/wheelchair))
			H.buckled.loc = H.loc
			H.buckled.set_dir(H.dir)

	// If they're head, give them the account info for their department
	if(H.mind && job.head_position)
		var/remembered_info = ""
		var/datum/money_account/department_account = department_accounts[job.department]

		if(department_account)
			remembered_info += "<b>Your department's account number is:</b> #[department_account.account_number]<br>"
			remembered_info += "<b>Your department's account pin is:</b> [department_account.remote_access_pin]<br>"
			remembered_info += "<b>Your department's account funds are:</b> $[department_account.money]<br>"

		H.mind.store_memory(remembered_info)

	var/alt_title = null
	if(H.mind)
		H.mind.assigned_role = rank
		alt_title = H.mind.role_alt_title

		switch(rank)
			if("Cyborg")
				Debug("ER/([H]): Job is Cyborg, returning early.")
				return H.Robotize()
			if("AI")
				Debug("ER/([H]): Job is AI, returning early.")
				return H
			if("Captain")
				var/sound/announce_sound = (SSticker.current_state <= GAME_STATE_SETTING_UP)? null : sound('sound/misc/boatswain.ogg', volume=20)
				captain_announcement.Announce("All hands, Captain [H.real_name] on deck!", new_sound=announce_sound)

		//Deferred item spawning.
		if(!megavend && LAZYLEN(spawn_in_storage))
			EquipItemsStorage(H, H.client.prefs, spawn_in_storage)

	if(istype(H) && !megavend) //give humans wheelchairs, if they need them.
		var/obj/item/organ/external/l_foot = H.get_organ("l_foot")
		var/obj/item/organ/external/r_foot = H.get_organ("r_foot")
		if(!l_foot || !r_foot)
			var/obj/structure/bed/chair/wheelchair/W = new /obj/structure/bed/chair/wheelchair(H.loc)
			H.buckled = W
			H.update_canmove()
			W.set_dir(H.dir)
			W.buckled_mob = H
			W.add_fingerprint(H)

	H << "<B>You are [job.total_positions == 1 ? "the" : "a"] [alt_title ? alt_title : rank].</B>"

	if(job.supervisors)
		H << "<b>As the [alt_title ? alt_title : rank] you answer directly to [job.supervisors]. Special circumstances may change this.</b>"

	if(job.idtype)
		spawnId(H, rank, alt_title)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_l_ear)
		H << "<b>To speak on your department's radio channel use :h. For the use of other channels, examine your headset.</b>"

	if(job.req_admin_notify)
		H << "<b>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b>"

	//Gives glasses to the vision impaired
	if(H.disabilities & NEARSIGHTED && !megavend)
		var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
		if(equipped != 1)
			var/obj/item/clothing/glasses/G = H.glasses
			G.prescription = TRUE

	BITSET(H.hud_updateflag, ID_HUD)
	BITSET(H.hud_updateflag, IMPLOYAL_HUD)
	BITSET(H.hud_updateflag, SPECIALROLE_HUD)

	Debug("ER/([H]): Completed.")

	return H

/mob/living/carbon/human
	var/tmp/centcomm_despawn_timer

/mob/living/proc/centcomm_timeout()
	if (!istype(get_area(src), /area/centcom/spawning))
		return FALSE

	if (!client)
		SSjobs.centcomm_despawn_mob(src)
		return FALSE

	return TRUE

/mob/living/carbon/human/centcomm_timeout()
	. = ..()

	if (!.)
		return FALSE

	var/datum/spawnpoint/spawnpos = SSatlas.spawn_locations["Cryogenic Storage"]
	if(spawnpos && istype(spawnpos))
		src << "<span class='warning'>You come to the sudden realization that you never left the Aurora at all! You were in cryo the whole time!</span>"
		src.forceMove(pick(spawnpos.turfs))
		global_announcer.autosay("[real_name], [mind.role_alt_title], [spawnpos.msg].", "Cryogenic Oversight")
		if(!src.megavend)
			var/rank= src.mind.assigned_role
			SSjobs.EquipRank(src, rank, 1)
			src.megavend = TRUE
	else
		SSjobs.centcomm_despawn_mob(src) //somehow they can't spawn at cryo, so this is the only recourse of action.

	return TRUE

/mob/living/silicon/robot/centcomm_timeout()
	. = ..()

	if (!.)
		return FALSE

	var/datum/spawnpoint/spawnpos = SSatlas.spawn_locations["Cyborg Storage"]
	if(spawnpos && istype(spawnpos))
		src << "<span class='warning'>You come to the sudden realization that you never left the Aurora at all! You were in robotic storage the whole time!</span>"
		src.forceMove(pick(spawnpos.turfs))
		global_announcer.autosay("[real_name], [mind.role_alt_title], [spawnpos.msg].", "Robotic Oversight")
	else
		SSjobs.centcomm_despawn_mob(src)

	return TRUE

// Convenience wrapper.
/datum/controller/subsystem/jobs/proc/centcomm_despawn_mob(mob/living/H)
	if(ishuman(H))
		global_announcer.autosay("[H.real_name], [H.mind.role_alt_title], has entered long-term storage.", "[current_map.dock_name] Cryogenic Oversight")
		H.visible_message("<span class='notice'>[H.name] makes their way to the [current_map.dock_short]'s cryostorage, and departs.</span>", 3)
		DespawnMob(H)
	else
		global_announcer.autosay("[H.real_name], [H.mind.role_alt_title], has entered robotic storage.", "[current_map.dock_name] Robotic Oversight")
		H.visible_message("<span class='notice'>[H.name] makes their way to the [current_map.dock_short]'s robotic storage, and departs.</span>", 3)
		DespawnMob(H)

/datum/controller/subsystem/jobs/proc/EquipPersonal(mob/living/carbon/human/H, rank, joined_late = FALSE, spawning_at)
	Debug("EP/([H]): Entry.")
	if(!H)
		Debug("EP/([H]): Abort, H is null.")
		return null

	switch(rank)
		if("Cyborg")
			Debug("EP/([H]): Abort, H is borg..")
			return EquipRank(H, rank, 1)
		if("AI")
			Debug("EP/([H]): Abort, H is AI.")
			return EquipRank(H, rank, 1)

	if(!current_map.command_spawn_enabled || spawning_at != "Arrivals Shuttle")
		return EquipRank(H, rank, 1)

	H.centcomm_despawn_timer = addtimer(CALLBACK(H, /mob/living/.proc/centcomm_timeout), 10 MINUTES, TIMER_STOPPABLE)

	var/datum/job/job = GetJob(rank)

	if(spawning_at != "Arrivals Shuttle" || job.latejoin_at_spawnpoints)
		return EquipRank(H, rank, 1)

	var/list/spawn_in_storage = list()
	H <<"<span class='notice'>You have ten minutes to reach the station before you will be forced there.</span>"

	if(job)
		//Equip custom gear loadout.
		var/list/custom_equip_slots = list() //If more than one item takes the same slot, all after the first one spawn in storage.
		var/list/custom_equip_leftovers = list()

		EquipCustom(H, job, H.client.prefs, custom_equip_leftovers, spawn_in_storage, custom_equip_slots)

		//Equip job items.
		job.late_equip(H)
		job.equip_backpack(H)
		job.equip_survival(H)
		job.setup_account(H)

		spawn_in_storage += EquipCustomDeferred(H, H.client.prefs, custom_equip_leftovers, custom_equip_slots)

		job.apply_fingerprints(H)
	else
		H << "Your job is [rank] and the game just can't handle it! Please report this bug to an administrator."

	H.job = rank

	if(LAZYLEN(spawn_in_storage))
		EquipItemsStorage(H, H.client.prefs, spawn_in_storage)

	if(istype(H)) //give humans wheelchairs, if they need them.
		var/obj/item/organ/external/l_foot = H.get_organ("l_foot")
		var/obj/item/organ/external/r_foot = H.get_organ("r_foot")
		if(!l_foot || !r_foot)
			var/obj/structure/bed/chair/wheelchair/W = new /obj/structure/bed/chair/wheelchair(H.loc)
			H.buckled = W
			H.update_canmove()
			W.set_dir(H.dir)
			W.buckled_mob = H
			W.add_fingerprint(H)

	//Gives glasses to the vision impaired
	if(H.disabilities & NEARSIGHTED)
		var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
		if(equipped != 1)
			var/obj/item/clothing/glasses/G = H.glasses
			G.prescription = TRUE
			G.autodrobe_no_remove = TRUE

	// So shoes aren't silent if people never change 'em.
	H.update_noise_level()

	BITSET(H.hud_updateflag, ID_HUD)
	BITSET(H.hud_updateflag, IMPLOYAL_HUD)
	BITSET(H.hud_updateflag, SPECIALROLE_HUD)

	to_chat(H, "<b>[current_map.command_spawn_message]</b>")

	Debug("EP/([H]): Completed.")

	return H

/datum/controller/subsystem/jobs/proc/spawnId(mob/living/carbon/human/H, rank, title)
	if (!H)
		return FALSE

	Debug("SI/([H]): Entry; rank=[rank],title=[title].")

	var/obj/item/weapon/card/id/C = null

	var/datum/job/job = GetJob(rank)

	if(job)
		if(job.title == "Cyborg")
			Debug("SI/([H]): Abort; job is cyborg.")
			return
		else
			C = new job.idtype(H)
			C.access = job.get_access()
	else
		C = new /obj/item/weapon/card/id(H)
	if(C)
		C.rank = rank
		C.assignment = title ? title : rank
		addtimer(CALLBACK(H, /mob/.proc/set_id_info, C), 1 SECOND)	// Delay a moment to allow an icon update to happen.

		//put the player's account number onto the ID
		if(H.mind && H.mind.initial_account)
			C.associated_account_number = H.mind.initial_account.account_number

		H.equip_to_slot_or_del(C, slot_wear_id)

	H.equip_to_slot_or_del(new /obj/item/device/pda(H), slot_belt)
	if(locate(/obj/item/device/pda,H))
		var/obj/item/device/pda/pda = locate(/obj/item/device/pda,H)
		pda.owner = H.real_name
		pda.ownjob = C.assignment
		pda.ownrank = C.rank
		pda.name = "PDA-[H.real_name] ([pda.ownjob])"

	Debug("SI/([H]): Completed.")
	return TRUE

/datum/controller/subsystem/jobs/proc/LoadJobs(jobsfile)
	if (!config.load_jobs_from_txt)
		return FALSE

	var/list/jobEntries = file2list(jobsfile)

	for(var/job in jobEntries)
		if(!job)
			continue

		job = trim(job)
		if (!length(job))
			continue

		var/pos = findtext(job, "=")
		var/name = null
		var/value = null

		if(pos)
			name = copytext(job, 1, pos)
			value = copytext(job, pos + 1)
		else
			continue

		if(name && value)
			var/datum/job/J = GetJob(name)
			if(!J)	continue
			J.total_positions = text2num(value)
			J.spawn_positions = text2num(value)
			if(name == "AI" || name == "Cyborg")//I dont like this here but it will do for now    // 6 years later and it's still not changed. Hue.
				J.total_positions = 0

	return TRUE

/datum/controller/subsystem/jobs/proc/HandleFeedbackGathering()
	for(var/thing in occupations)
		var/datum/job/job = thing

		var/tmp_str = "|[job.title]|"

		var/level1 = 0 //high
		var/level2 = 0 //medium
		var/level3 = 0 //low
		var/level4 = 0 //never
		var/level5 = 0 //banned
		for(var/mob/new_player/player in player_list)
			if(!(player.ready && player.mind && !player.mind.assigned_role))
				continue //This player is not ready
			if(jobban_isbanned(player, job.title))
				level5++
				continue
			if(player.client.prefs.GetJobDepartment(job, 1) & job.flag)
				level1++
			else if(player.client.prefs.GetJobDepartment(job, 2) & job.flag)
				level2++
			else if(player.client.prefs.GetJobDepartment(job, 3) & job.flag)
				level3++
			else level4++ //not selected

		tmp_str += "HIGH=[level1]|MEDIUM=[level2]|LOW=[level3]|NEVER=[level4]|BANNED=[level5]|-"
		feedback_add_details("job_preferences",tmp_str)

/datum/controller/subsystem/jobs/proc/LateSpawn(mob/living/carbon/human/H, rank)
	//spawn at one of the latespawn locations
	Debug("LS/([H]): Entry; rank=[rank]")

	var/datum/job/job = GetJob(rank)

	H.job = rank

	if(job.latejoin_at_spawnpoints)
		for (var/thing in landmarks_list)
			var/obj/effect/landmark/L = thing
			if(istype(L))
				if(L.name == "LateJoin[rank]")
					H.forceMove(L.loc)
					return

	var/datum/spawnpoint/spawnpos

	if(H.client.prefs.spawnpoint)
		spawnpos = SSatlas.spawn_locations[H.client.prefs.spawnpoint]

	if(spawnpos && istype(spawnpos))
		if(spawnpos.check_job_spawning(rank))
			H.loc = pick(spawnpos.turfs)
			. = spawnpos.msg
		else
			H << "Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job. Spawning you at the Arrivals shuttle instead."
			H.loc = pick(latejoin)
			. = "is inbound from the [current_map.dock_name]"
	else
		H.loc = pick(latejoin)
		. = "is inbound from the [current_map.dock_name]"

	Debug("LS/([H]): Completed, spawning at area [H.loc.loc].")

/datum/controller/subsystem/jobs/proc/DespawnMob(mob/living/carbon/human/H)
	//Update any existing objectives involving this mob.
	for(var/datum/objective/O in all_objectives)
		// We don't want revs to get objectives that aren't for heads of staff. Letting
		// them win or lose based on cryo is silly so we remove the objective.
		if(O.target == H.mind)
			if(O.owner && O.owner.current)
				O.owner.current << "<span class='warning'>You get the feeling your target is no longer within your reach...</span>"
			qdel(O)

	//Handle job slot/tater cleanup.
	if (H.mind)
		var/job = H.mind.assigned_role

		FreeRole(job)

		if(H.mind.objectives.len)
			qdel(H.mind.objectives)
			H.mind.special_role = null

	// Delete them from datacore.

	if(PDA_Manifest.len)
		PDA_Manifest.Cut()
	for(var/datum/data/record/R in data_core.medical)
		if ((R.fields["name"] == H.real_name))
			qdel(R)
	for(var/datum/data/record/T in data_core.security)
		if ((T.fields["name"] == H.real_name))
			qdel(T)
	for(var/datum/data/record/G in data_core.general)
		if ((G.fields["name"] == H.real_name))
			qdel(G)

	log_and_message_admins("([H.mind.role_alt_title]) entered cryostorage.", user = H)

	//This should guarantee that ghosts don't spawn.
	H.ckey = null

	// Delete the mob.
	qdel(H)

// Equips a human-type with their custom loadout crap.
// Returns TRUE on success, FALSE otherwise.
// H, job, and prefs MUST be supplied and not null.
// leftovers, storage, custom_equip_slots can be passed if their return values are required (proc mutates passed list), or ignored if not required.
/datum/controller/subsystem/jobs/proc/EquipCustom(mob/living/carbon/human/H, datum/job/job, datum/preferences/prefs, list/leftovers = null, list/storage = null, list/custom_equip_slots = list())
	Debug("EC/([H]): Entry.")
	if (!istype(H) || !job)
		Debug("EC/([H]): Abort: invalid arguments.")
		return FALSE

	switch (job.title)
		if ("AI", "Cyborg")
			Debug("EC/([H]): Abort: synthetic.")
			return FALSE

	for(var/thing in prefs.gear)
		var/datum/gear/G = gear_datums[thing]
		if(G)
			var/permitted
			if(G.allowed_roles)
				for(var/job_name in G.allowed_roles)
					if(job.title == job_name)
						permitted = TRUE
						break
			else
				permitted = TRUE

			if(G.whitelisted && (!(H.species.name in G.whitelisted)))
				permitted = 0

			if(!permitted)
				H << "<span class='warning'>Your current job or whitelist status does not permit you to spawn with [thing]!</span>"
				continue

			if(G.slot && !(G.slot in custom_equip_slots))
				// This is a miserable way to fix the loadout overwrite bug, but the alternative requires
				// adding an arg to a bunch of different procs. Will look into it after this merge. ~ Z
				var/metadata = prefs.gear[G.display_name]
				var/obj/item/CI = G.spawn_item(H,metadata)
				if (G.slot == slot_wear_mask || G.slot == slot_wear_suit || G.slot == slot_head)
					if (leftovers)
						leftovers += thing
					Debug("EC/([H]): [thing] failed mask/suit/head check; leftovers=[!!leftovers]")
				else if (H.equip_to_slot_or_del(CI, G.slot))
					CI.autodrobe_no_remove = TRUE
					H << "<span class='notice'>Equipping you with \a [thing]!</span>"
					custom_equip_slots += G.slot
					Debug("EC/([H]): Equipped [CI] successfully.")
				else if (leftovers)
					leftovers += thing
					Debug("EC/([H]): Unable to equip [thing]; sending to overflow.")
			else if (storage)
				storage += thing
				Debug("EC/([H]): Unable to equip [thing]; sending to storage.")

	Debug("EC/([H]): Complete.")
	return TRUE

// Attempts to equip custom items that failed to equip in EquipCustom.
// Returns a list of items that failed to equip & should be put in storage if possible.
// H and prefs must not be null.
/datum/controller/subsystem/jobs/proc/EquipCustomDeferred(mob/living/carbon/human/H, datum/preferences/prefs, list/items, list/used_slots)
	. = list()
	Debug("ECD/([H]): Entry.")
	for (var/thing in items)
		var/datum/gear/G = gear_datums[thing]

		if (G.slot in used_slots)
			. += thing
		else
			var/metadata = prefs.gear[G.display_name]
			var/obj/item/CI = G.spawn_item(H, metadata)
			if (H.equip_to_slot_or_del(CI, G.slot))
				to_chat(H, "<span class='notice'>Equipping you with \a [thing]!</span>")
				used_slots += G.slot
				CI.autodrobe_no_remove = TRUE
				Debug("ECD/([H]): Equipped [thing] successfully.")

			else
				. += thing
				Debug("ECD/([H]): Unable to equip [thing]; dumping into overflow.")

	Debug("ECD/([H]): Complete.")

// Attempts to place everything in items into a storage object located on H, deleting them if they're unable to be inserted.
// H and prefs must not be null.
// Returns nothing.
/datum/controller/subsystem/jobs/proc/EquipItemsStorage(mob/living/carbon/human/H, datum/preferences/prefs, list/items)
	Debug("EIS/([H]): Entry.")
	if (LAZYLEN(items))
		Debug("EIS/([H]): [items.len] items.")
		var/obj/item/weapon/storage/B = locate() in H
		if (B)
			for (var/thing in items)
				to_chat(H, "<span class='notice'>Placing \the [thing] in your [B.name]!</span>")
				var/datum/gear/G = gear_datums[thing]
				var/metadata = prefs.gear[G.display_name]
				G.spawn_item(B, metadata)
				Debug("EIS/([H]): placed [thing] in [B].")

		else
			to_chat(H, "<span class='danger'>Failed to locate a storage object on your mob, either you spawned with no arms and no backpack or this is a bug.</span>")
			Debug("EIS/([H]): unable to equip; no storage.")

	Debug("EIS/([H]): Complete.")

/datum/controller/subsystem/jobs/proc/get_roundstart_spawnpoint(var/rank)
	var/list/loc_list = list()
	for(var/obj/effect/landmark/start/sloc in landmarks_list)
		if(sloc.name != rank)	continue
		if(locate(/mob/living) in sloc.loc)	continue
		loc_list += sloc
	if(loc_list.len)
		return pick(loc_list)
	else
		return locate("start*[rank]") // use old stype

#undef Debug
