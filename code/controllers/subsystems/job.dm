#define Debug(text) if (GLOB.Debug2) {job_debug += text}

SUBSYSTEM_DEF(jobs)
	// Subsystem stuff.
	name = "Jobs"
	flags = SS_NO_FIRE
	init_order = SS_INIT_JOBS

	// Vars.
	var/list/datum/job/occupations = list()
	var/list/datum/job/name_occupations = list()	//Dict of all jobs, keys are titles
	var/list/datum/job/type_occupations = list()	//Dict of all jobs, keys are types
	var/list/mob/abstract/new_player/unassigned = list()
	var/list/job_debug = list()
	var/list/bitflag_to_job = list()

	var/list/factions = list()
	var/list/name_factions = list()
	var/datum/faction/default_faction = null

	var/safe_to_sanitize = FALSE
	var/list/deferred_preference_sanitizations = list()

/datum/controller/subsystem/jobs/Initialize()

	SetupOccupations()
	LoadJobs("config/jobs.txt")
	InitializeFactions()

	ProcessSanitizationQueue()

	SSticker.setup_player_ready_list()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/jobs/Recover()
	occupations = SSjobs.occupations
	unassigned = SSjobs.unassigned
	job_debug = SSjobs.job_debug
	factions = SSjobs.factions
	if (islist(job_debug))
		job_debug += "NOTICE: Job system Recover() triggered."

/datum/controller/subsystem/jobs/proc/SetupOccupations(faction = "Station")
	occupations = list()
	var/list/all_jobs = current_map.allowed_jobs
	if(!all_jobs.len)
		to_world("<span class='warning'>Error setting up jobs, no job datums found!</span>")
		return FALSE

	for(var/J in all_jobs)
		var/datum/job/job = new J()
		if(!job || job.faction != faction)
			continue
		occupations += job
		name_occupations[job.title] = job
		type_occupations[J] = job
		if(!length(bitflag_to_job["[job.department_flag]"]))
			bitflag_to_job["[job.department_flag]"] = list()
		bitflag_to_job["[job.department_flag]"]["[job.flag]"] = job
		if (GLOB.config && GLOB.config.use_age_restriction_for_jobs)
			job.fetch_age_restriction()

	return TRUE

/datum/controller/subsystem/jobs/proc/GetJob(rank)
	if (!rank)
		return null

	return name_occupations[rank]

/datum/controller/subsystem/jobs/proc/GetJobType(jobtype)
	if(!jobtype)
		return null

	return type_occupations[jobtype]

/datum/controller/subsystem/jobs/proc/GetRandomJob()
	return pick(occupations)

/datum/controller/subsystem/jobs/proc/ShouldCreateRecords(var/datum/mind/mind)
	if(player_is_antag(mind, only_offstation_roles = 1))
		return 0
	if(!mind.assigned_role)
		return 0
	var/datum/job/job = GetJob(mind.assigned_role)
	if(!job) return 0
	return job.create_record

/datum/controller/subsystem/jobs/proc/GetPlayerAltTitle(mob/abstract/new_player/player, rank)
	. = player.client.prefs.GetPlayerAltTitle(GetJob(rank))

/datum/controller/subsystem/jobs/proc/AssignRole(mob/abstract/new_player/player, rank, latejoin = FALSE)
	Debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
	if(player && player.mind && rank)
		var/datum/job/job = GetJob(rank)
		if(!job)
			return FALSE
		if(jobban_isbanned(player, rank))
			return FALSE
		if(!player.IsJobAvailable(rank))
			return FALSE

		if(!(player.client.prefs.GetPlayerAltTitle(job) in player.client.prefs.GetValidTitles(job)))
			to_chat(player, "<span class='warning'>Your character is too young!</span>")
			return FALSE

		var/position_limit = job.get_total_positions()
		if(!latejoin)
			position_limit = job.get_spawn_positions()
		if((job.current_positions < position_limit) || position_limit == -1)
			Debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
			player.mind.assigned_role = rank
			player.mind.role_alt_title = GetPlayerAltTitle(player, rank)
			unassigned -= player
			job.current_positions++
			job.pre_spawn(player)
			return TRUE
	Debug("AR has failed, Player: [player], Rank: [rank]")
	return FALSE

/datum/controller/subsystem/jobs/proc/FreeRole(var/rank)
	var/datum/job/job = GetJob(rank)
	if(!istype(job))
		return
	job.current_positions--

/datum/controller/subsystem/jobs/proc/FindOccupationCandidates(datum/job/job, level, flag)
	Debug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
	. = list()
	for(var/mob/abstract/new_player/player in unassigned)
		if(jobban_isbanned(player, job.title))
			Debug("FOC isbanned failed, Player: [player]")
			continue
		if(flag && !(flag in player.client.prefs.be_special_role))
			Debug("FOC flag failed, Player: [player], Flag: [flag], ")
			continue
		if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
			Debug("FOC pass, Player: [player], Level:[level]")
			. += player

/datum/controller/subsystem/jobs/proc/ResetOccupations()
	for(var/mob/abstract/new_player/player in GLOB.player_list)
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

				var/min_job_age = job.get_minimum_character_age(V.get_species())
				var/ideal_job_age = job.get_ideal_character_age(V.get_species())

				if(age > (ideal_job_age + 20)) // Elderly for the position
					weightedCandidates[V] = 3
				else if(age > (ideal_job_age + 10)) // Good, but on the elderly side
					weightedCandidates[V] = 6
				else if(age > (ideal_job_age - 10)) // Perfect
					weightedCandidates[V] = 10
				else if(age > (min_job_age + 10)) // Good, but on the young side
					weightedCandidates[V] = 6
				else if(age >= min_job_age) // Too young
					weightedCandidates[V] = 3
				else
					if(candidates.len == 1) // There's only one option
						weightedCandidates[V] = 1

			var/mob/abstract/new_player/candidate = pickweight(weightedCandidates)
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
		var/mob/abstract/new_player/candidate = pick(candidates)
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
	for(var/mob/abstract/new_player/player in GLOB.player_list)
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
	for(var/mob/abstract/new_player/player in assistant_candidates)
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
		for(var/mob/abstract/new_player/player in unassigned)

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
					if((job.current_positions < job.get_spawn_positions()) || job.get_spawn_positions() == -1)
						Debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
						AssignRole(player, job.title)
						unassigned -= player
						break

	Debug("DO, Standard Check end")

	Debug("DO, Running AC2")

	// For those who wanted to be assistant if their preferences were filled, here you go.
	for(var/mob/abstract/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == BE_ASSISTANT)
			Debug("AC2 Assistant located, Player: [player]")
			AssignRole(player, "Assistant")

	//For ones returning to lobby
	for(var/mob/abstract/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = 0
			unassigned -= player
	return TRUE

/datum/controller/subsystem/jobs/proc/EquipRank(mob/living/carbon/human/H, rank, joined_late = FALSE, spawning_at)
	if(!H)
		return null

	Debug("ER/([H]): Entry, joined_late=[joined_late].")

	if(SSatlas.current_sector.description)
		to_chat(H, SSatlas.current_sector.get_chat_description())

	if("Arrivals Shuttle" in current_map.allowed_spawns && spawning_at == "Arrivals Shuttle")
		H.centcomm_despawn_timer = addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living, centcomm_timeout)), 10 MINUTES, TIMER_STOPPABLE)
		to_chat(H,SPAN_NOTICE("You have ten minutes to reach the station before you will be forced there."))

	var/datum/job/job = GetJob(rank)
	var/list/spawn_in_storage = list()

	if (H.mind)
		H.mind.selected_faction = GetFaction(H)

	H.job = rank

	if(job)
		var/list/custom_equip_slots = list() //If more than one item takes the same slot, all after the first one spawn in storage.
		var/list/custom_equip_leftovers = list()
		//Equip job items.
		Debug("ER/([H]): Equipping custom loadout.")
		job.pre_equip(H)
		job.setup_account(H)
		job.after_spawn(H)
		EquipCustom(H, job, H.client.prefs, custom_equip_leftovers, spawn_in_storage, custom_equip_slots)

		job.equip(H)
		UniformReturn(H, H.client.prefs, job)

		spawn_in_storage += EquipCustomDeferred(H, H.client.prefs, custom_equip_leftovers, custom_equip_slots)
	else
		to_chat(H,"Your job is [rank] and the game just can't handle it! Please report this bug to an administrator.")

	if(!joined_late || job.latejoin_at_spawnpoints)
		var/obj/S = get_roundstart_spawnpoint(rank)
		if(istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf))
			H.forceMove(S.loc)
			H.lastarea = get_area(H.loc)
			H.lastarea.set_lightswitch(TRUE)
		else
			LateSpawn(H, rank)

		// Moving wheelchair if they have one
		if(H.buckled_to && istype(H.buckled_to, /obj/structure/bed/stool/chair/office/wheelchair))
			H.buckled_to.forceMove(H.loc)
			H.buckled_to.set_dir(H.dir)

	if(H.mind)
		// If they're a department supervisor/head give them the account info for that department
		var/remembered_info = ""
		for(var/department in job.departments)
			if(job.departments[department] & JOBROLE_SUPERVISOR)
				var/datum/money_account/department_account = SSeconomy.get_department_account(department)
				if(department_account)
					remembered_info += "<b>[department] department's account number is:</b> #[department_account.account_number]<br>"
					remembered_info += "<b>[department] department's account pin is:</b> [department_account.remote_access_pin]<br>"
					remembered_info += "<b>[department] department's account funds are:</b> $[department_account.money]<br>"
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

		//Deferred item spawning.
		if(LAZYLEN(spawn_in_storage))
			EquipItemsStorage(H, H.client.prefs, spawn_in_storage)

	to_chat(H, "<B>You are [job.get_total_positions() == 1 ? "the" : "a"] [alt_title ? alt_title : rank].</B>")

	if(istype(H)) //give humans wheelchairs, if they need them.
		if(H.needs_wheelchair())
			H.equip_wheelchair()

	if(job.supervisors)
		to_chat(H, "<b>As [job.intro_prefix] [alt_title ? alt_title : rank] you answer directly to [job.supervisors]. Special circumstances may change this.</b>")

	//Gives glasses to the vision impaired
	if(H.disabilities & NEARSIGHTED)
		var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
		if(equipped != 1)
			var/obj/item/clothing/glasses/G = H.glasses
			G.prescription = 7

	if(H.species && !H.species_items_equipped)
		H.species.equip_later_gear(H)
		H.species_items_equipped = TRUE

	// So shoes aren't silent if people never change 'em.
	H.update_noise_level()

	BITSET(H.hud_updateflag, ID_HUD)
	BITSET(H.hud_updateflag, IMPLOYAL_HUD)
	BITSET(H.hud_updateflag, SPECIALROLE_HUD)

	var/obj/item/clothing/under/uniform = H.w_uniform
	if(istype(uniform) && uniform.has_sensor)
		uniform.sensor_mode = SUIT_SENSOR_MODES[H.client.prefs.sensor_setting]

	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(show_location_blurb), H.client, 10 SECONDS)

	if(spawning_at == "Arrivals Shuttle")
		to_chat(H, "<b>[current_map.command_spawn_message]</b>")

	if(joined_late)
		var/antag_count = 0
		for(var/antag_type in SSticker.mode.antag_tags)
			var/datum/antagonist/A = GLOB.all_antag_types[antag_type]
			antag_count += A.get_active_antag_count()
		for(var/antag_type in SSticker.mode.antag_tags)
			var/datum/antagonist/A = GLOB.all_antag_types[antag_type]
			A.update_current_antag_max()
			if((A.role_type in H.client.prefs.be_special_role) && !(A.flags & ANTAG_OVERRIDE_JOB) && antag_count < A.cur_max)
				A.add_antagonist(H.mind)
				break

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
		to_chat(src, "<span class='warning'>You come to the sudden realization that you never left the [current_map.station_name] at all! You were in cryo the whole time!</span>")
		src.forceMove(pick(spawnpos.turfs))
		GLOB.global_announcer.autosay("[real_name], [mind.role_alt_title], [spawnpos.msg].", "Cryogenic Oversight")
		var/rank= src.mind.assigned_role
		SSjobs.EquipRank(src, rank, 1)
	else
		SSjobs.centcomm_despawn_mob(src) //somehow they can't spawn at cryo, so this is the only recourse of action.

	return TRUE

/mob/living/silicon/robot/centcomm_timeout()
	. = ..()

	if (!.)
		return FALSE

	var/datum/spawnpoint/spawnpos = SSatlas.spawn_locations["Cyborg Storage"]
	if(spawnpos && istype(spawnpos))
		to_chat(src, "<span class='warning'>You come to the sudden realization that you never left the [current_map.station_name] at all! You were in robotic storage the whole time!</span>")
		src.forceMove(pick(spawnpos.turfs))
		GLOB.global_announcer.autosay("[real_name], [mind.role_alt_title], [spawnpos.msg].", "Robotic Oversight")
	else
		SSjobs.centcomm_despawn_mob(src)

	return TRUE

// Convenience wrapper.
/datum/controller/subsystem/jobs/proc/centcomm_despawn_mob(mob/living/H)
	if(ishuman(H))
		GLOB.global_announcer.autosay("[H.real_name], [H.mind.role_alt_title], has entered long-term storage.", "[current_map.dock_name] Cryogenic Oversight")
		H.visible_message("<span class='notice'>[H.name] makes their way to the [current_map.dock_short]'s cryostorage, and departs.</span>", "<span class='notice'>You make your way into [current_map.dock_short]'s cryostorage, and depart.</span>", range = 3)
		DespawnMob(H)
	else
		if(!isDrone(H))
			GLOB.global_announcer.autosay("[H.real_name], [H.mind.role_alt_title], has entered robotic storage.", "[current_map.dock_name] Robotic Oversight")
			H.visible_message("<span class='notice'>[H.name] makes their way to the [current_map.dock_short]'s robotic storage, and departs.</span>", "<span class='notice'>You make your way into [current_map.dock_short]'s robotic storage, and depart.</span>", range = 3)
		DespawnMob(H)

/datum/controller/subsystem/jobs/proc/LoadJobs(jobsfile)
	if (!GLOB.config.load_jobs_from_txt)
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
			if(!istype(J))
				continue
			J.total_positions = text2num(value)
			J.spawn_positions = text2num(value)

	return TRUE

/datum/controller/subsystem/jobs/proc/InitializeFactions()
	for (var/type in subtypesof(/datum/faction))
		var/datum/faction/faction = new type()

		factions += faction
		name_factions[faction.name] = faction

		if (faction.is_default)
			if (default_faction)
				crash_with("Two default factions detected in SSjobs.")
			else
				default_faction = faction

	if (!default_faction)
		crash_with("No default faction assigned to SSjobs.")

	if (!factions.len)
		crash_with("No factions located in SSjobs.")

/datum/controller/subsystem/jobs/proc/HandleFeedbackGathering()
	for(var/thing in occupations)
		var/datum/job/job = thing

		var/tmp_str = "|[job.title]|"

		var/level1 = 0 //high
		var/level2 = 0 //medium
		var/level3 = 0 //low
		var/level4 = 0 //never
		var/level5 = 0 //banned
		for(var/mob/abstract/new_player/player in GLOB.player_list)
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

	if(current_map.force_spawnpoint && LAZYLEN(GLOB.force_spawnpoints))
		if(GLOB.force_spawnpoints[rank])
			H.forceMove(pick(GLOB.force_spawnpoints[rank]))
		else
			H.forceMove(pick(GLOB.force_spawnpoints["Anyone"]))
	else
		if(job.latejoin_at_spawnpoints)
			for (var/thing in GLOB.landmarks_list)
				var/obj/effect/landmark/L = thing
				if(istype(L))
					if(L.name == "LateJoin[rank]")
						H.forceMove(L.loc)
						return

		var/datum/spawnpoint/spawnpos

		if(H.client.prefs.spawnpoint in SSatlas.spawn_locations)
			spawnpos = SSatlas.spawn_locations[H.client.prefs.spawnpoint]

		if(rank == "Cyborg")
			spawnpos = new/datum/spawnpoint/cyborg

		if(!spawnpos)
			spawnpos = SSatlas.spawn_locations[current_map.default_spawn]

		if(spawnpos && istype(spawnpos))
			if(spawnpos.check_job_spawning(rank))
				if(istype(spawnpos, /datum/spawnpoint/cryo) && (rank in command_positions))
					var/datum/spawnpoint/cryo/C = spawnpos
					if(length(C.command_turfs))
						H.forceMove(pick(C.command_turfs))
					else
						H.forceMove(pick(spawnpos.turfs))
				else
					H.forceMove(pick(spawnpos.turfs))
				. = spawnpos.msg
				spawnpos.after_join(H)
			else
				to_chat(H, "Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job. Spawning you at the Arrivals shuttle instead.")
				H.forceMove(pick(GLOB.latejoin))
				. = "is inbound from the [current_map.dock_name]"
		else
			H.forceMove(pick(GLOB.latejoin))
			. = "is inbound from the [current_map.dock_name]"

	H.mind.selected_faction = SSjobs.GetFaction(H)

	Debug("LS/([H]): Completed, spawning at area [H.loc.loc].")

/datum/controller/subsystem/jobs/proc/DespawnMob(mob/living/carbon/human/H)
	//Update any existing objectives involving this mob.
	for(var/datum/objective/O in GLOB.all_objectives)
		// We don't want revs to get objectives that aren't for heads of staff. Letting
		// them win or lose based on cryo is silly so we remove the objective.
		if(O.target == H.mind)
			if(O.owner && O.owner.current)
				to_chat(O.owner.current, "<span class='warning'>You get the feeling your target is no longer within your reach...</span>")
			qdel(O)

	//Handle job slot/tater cleanup.
	if (H.mind)
		var/role = H.mind.assigned_role
		var/datum/job/job = GetJob(H.mind.assigned_role)
		job.on_despawn(H)
		FreeRole(role)
		if(H.mind.objectives.len)
			qdel(H.mind.objectives)
			H.mind.special_role = null

	// Delete them from datacore.
	if(ishuman(H))
		SSrecords.remove_record_by_field("fingerprint", H.get_full_print())
		if(H.species)
			H.species.handle_despawn(H)
	SSrecords.remove_record_by_field("name", H.real_name)
	SSrecords.reset_manifest()

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
	log_loadout("EC/([H]): Entry.")
	if (!istype(H) || !job)
		log_loadout("EC/([H]): Abort: invalid arguments.")
		return FALSE

	switch (job.title)
		if ("AI", "Cyborg")
			log_loadout("EC/([H]): Abort: synthetic.")
			return FALSE

	for(var/thing in prefs.gear)
		var/datum/gear/G = gear_datums[thing]
		if(G)
			if(G.augment) //augments are handled somewhere else
				continue

			var/metadata
			var/list/gear_test = prefs.gear[G.display_name]
			if(gear_test?.len)
				metadata = gear_test
			else
				metadata = list()

			var/cant_spawn_reason = G.cant_spawn_item_reason(null, metadata, H, job, prefs)
			if(cant_spawn_reason)
				to_chat(H, SPAN_WARNING(cant_spawn_reason))
				continue

			// we want to handle spawning accessories after all the other clothing items have been spawned in
			var/list/spawn_data = G.get_spawn_item_data(H, metadata, H)
			if(ispath(spawn_data[1], /obj/item/clothing/accessory))
				leftovers += thing
				continue

			if(G.slot && !(G.slot in custom_equip_slots))
				// This is a miserable way to fix the loadout overwrite bug, but the alternative requires
				// adding an arg to a bunch of different procs. Will look into it after this merge. ~ Z
				var/obj/item/CI = G.spawn_item(null,metadata, H)
				if (H.equip_to_slot_or_del(CI, G.slot))
					to_chat(H, SPAN_NOTICE("Equipping you with [thing]!"))
					if(G.slot != slot_tie)
						custom_equip_slots += G.slot
					log_loadout("EC/([H]): Equipped [CI] successfully.")
				else if (leftovers)
					leftovers += thing
					log_loadout("EC/([H]): Unable to equip [thing]; sending to overflow.")
			else if (storage)
				storage += thing
				log_loadout("EC/([H]): Unable to equip [thing]; sending to storage.")

	log_loadout("EC/([H]): Complete.")
	return TRUE

// Attempts to equip custom items that failed to equip in EquipCustom.
// Returns a list of items that failed to equip & should be put in storage if possible.
// H and prefs must not be null.
/datum/controller/subsystem/jobs/proc/EquipCustomDeferred(mob/living/carbon/human/H, datum/preferences/prefs, list/items, list/used_slots)
	. = list()
	log_loadout("ECD/([H]): Entry.")
	for (var/thing in items)
		var/datum/gear/G = gear_datums[thing]

		if (G.slot in used_slots)
			. += thing
		else
			var/metadata
			var/list/gear_test = prefs.gear[G.display_name]
			if(gear_test?.len)
				metadata = gear_test
			else
				metadata = list()

			var/obj/item/CI = G.spawn_item(H, metadata, H)
			var/equip_slot = G.slot
			var/handled_accessory = FALSE

			if(isaccessory(CI))
				var/datum/gear_tweak/accessory_slot/accessory_slot = locate(/datum/gear_tweak/accessory_slot) in G.gear_tweaks
				if(accessory_slot && metadata["[accessory_slot]"])
					var/selected_slot = metadata["[accessory_slot]"]
					switch(selected_slot)
						if(GEAR_TWEAK_ACCESSORY_SLOT_UNDER)
							if(isclothing(H.w_uniform))
								var/obj/item/clothing/worn_uniform = H.w_uniform
								if(worn_uniform.can_attach_accessory(CI))
									to_chat(H, SPAN_NOTICE("Attaching \the [CI] to your uniform!"))
									worn_uniform.attach_accessory(H, CI)
									handled_accessory = TRUE
						if(GEAR_TWEAK_ACCESSORY_SLOT_SUIT)
							if(isclothing(H.wear_suit))
								var/obj/item/clothing/worn_suit = H.wear_suit
								if(worn_suit.can_attach_accessory(CI))
									to_chat(H, SPAN_NOTICE("Attaching \the [CI] to your suit!"))
									worn_suit.attach_accessory(H, CI)
									handled_accessory = TRUE
						if(GEAR_TWEAK_ACCESSORY_SLOT_SUIT_STANDALONE)
							equip_slot = slot_wear_suit

			if(!handled_accessory)
				if (H.equip_to_slot_or_del(CI, equip_slot))
					to_chat(H, SPAN_NOTICE("Equipping you with [thing]!"))
					used_slots += equip_slot
					log_loadout("ECD/([H]): Equipped [thing] successfully.")
				else
					. += thing
					log_loadout("ECD/([H]): Unable to equip [thing]; dumping into overflow.")

	log_loadout("ECD/([H]): Complete.")

// Attempts to place everything in items into a storage object located on H, deleting them if they're unable to be inserted.
// H and prefs must not be null.
// Returns nothing.
/datum/controller/subsystem/jobs/proc/EquipItemsStorage(mob/living/carbon/human/H, datum/preferences/prefs, list/items)
	log_loadout("EIS/([H]): Entry.")
	if (LAZYLEN(items))
		log_loadout("EIS/([H]): [items.len] items.")
		var/obj/item/storage/B = locate() in H
		if (B)
			for (var/thing in items)
				to_chat(H, "<span class='notice'>Placing \the [thing] in your [B.name]!</span>")
				var/datum/gear/G = gear_datums[thing]
				var/metadata
				var/list/gear_test = prefs.gear[G.display_name]
				if(gear_test?.len)
					metadata = gear_test
				else
					metadata = list()
				G.spawn_item(B, metadata, H)
				log_loadout("EIS/([H]): placed [thing] in [B].")

		else
			to_chat(H, "<span class='danger'>Failed to locate a storage object on your mob, either you spawned with no arms and no backpack or this is a bug.</span>")
			log_loadout("EIS/([H]): unable to equip; no storage.")

	log_loadout("EIS/([H]): Complete.")

/datum/controller/subsystem/jobs/proc/get_roundstart_spawnpoint(var/rank)
	var/list/loc_list = list()
	for(var/obj/effect/landmark/start/sloc in GLOB.landmarks_list)
		if(sloc.name != rank)	continue
		if(locate(/mob/living) in sloc.loc)	continue
		loc_list += sloc
	if(loc_list.len)
		return pick(loc_list)
	else
		return locate("start*[rank]") // use old stype

/datum/controller/subsystem/jobs/proc/GetFaction(mob/living/carbon/human/H)
	var/faction_name = H?.client?.prefs?.faction
	if (faction_name)
		return name_factions[faction_name]
	else
		return null

/datum/controller/subsystem/jobs/proc/ProcessSanitizationQueue()
	safe_to_sanitize = TRUE

	for (var/p in deferred_preference_sanitizations)
		var/datum/callback/CB = deferred_preference_sanitizations[p]
		CB.Invoke()

	deferred_preference_sanitizations.Cut()


/datum/controller/subsystem/jobs/proc/EquipAugments(mob/living/carbon/human/H, datum/preferences/prefs)
	log_loadout("EA/([H]): Entry.")
	if(!istype(H))
		log_loadout("EA/([H]): Abort: invalid arguments.")
		return FALSE

	var/datum/job/rank = GetJob(H.mind.assigned_role)

	switch (rank.title)
		if ("AI", "Cyborg")
			log_loadout("EA/([H]): Abort: synthetic.")
			return FALSE

	for(var/thing in prefs.gear)
		var/datum/gear/G = gear_datums[thing]
		if(G)
			if(!G.augment)
				continue

			var/metadata
			var/list/gear_test = prefs.gear[G.display_name]
			if(gear_test?.len)
				metadata = gear_test
			else
				metadata = list()

			var/cant_spawn_reason = G.cant_spawn_item_reason(null, metadata, H, rank, prefs)
			if(cant_spawn_reason)
				to_chat(H, SPAN_WARNING(cant_spawn_reason))
				continue

			var/obj/item/organ/A = G.spawn_item(H, metadata, H)
			if(!istype(A, /obj/item/organ/external))
				var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
				A.replaced(H, affected)
			H.update_body()

	log_loadout("EA/([H]): Complete.")
	return TRUE

/proc/show_location_blurb(client/C, duration)
	set waitfor = 0

	var/style = "font-family: 'Fixedsys'; -dm-text-outline: 1 black; font-size: 11px;"
	var/text = "[worlddate2text()], [worldtime2text()]\n[station_name()], [SSatlas.current_sector.name]"
	text = uppertext(text)

	var/obj/effect/overlay/T = new()
	T.icon_state = "nothing"
	T.maptext_height = 64
	T.maptext_width = 512
	T.layer = SCREEN_LAYER+1
	T.plane = FLOAT_PLANE
	T.screen_loc = "LEFT+1,BOTTOM+2"

	C.screen += T
	animate(T, alpha = 255, time = 10)
	for(var/i = 1 to length(text)+1)
		T.maptext = "<span style=\"[style]\">[copytext(text,1,i)] </span>"
		sleep(1)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_location_blurb), C, T), duration)

/proc/fade_location_blurb(client/C, obj/T)
	animate(T, alpha = 0, time = 5)
	sleep(5)
	if(C)
		C.screen -= T
	qdel(T)

/datum/controller/subsystem/jobs/proc/UniformReturn(mob/living/carbon/human/H, datum/preferences/prefs, datum/job/job)
	var/uniform = job.get_outfit(H)
	if(!uniform) // silicons don't have uniforms or gear
		return
	var/datum/outfit/U = new uniform
	var/spawned_uniform = FALSE
	var/spawned_suit = FALSE
	for(var/item in prefs.gear)
		var/datum/gear/L = gear_datums[item]
		if(L.slot == slot_w_uniform)
			if(U.uniform && !spawned_uniform && !istype(H.w_uniform, U.uniform))
				H.equip_or_collect(new U.uniform(H), H.back)
				spawned_uniform = TRUE
		if(L.slot == slot_wear_suit)
			if(U.suit && !spawned_suit && !istype(H.wear_suit, U.suit))
				H.equip_or_collect(new U.suit(H), H.back)
				spawned_suit = TRUE
#undef Debug
