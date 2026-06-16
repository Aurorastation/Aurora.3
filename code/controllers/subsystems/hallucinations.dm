SUBSYSTEM_DEF(hallucinations)
	name = "Hallucinations"
	wait = 1 MINUTE
	runlevels = RUNLEVELS_PLAYING

	var/list/hallucinated_phrases = list()
	var/list/hallucinated_actions = list()
	var/list/hallucinated_thoughts = list()

	// These lists are only initialized/used when in the Lemurian Sea.
	var/adpi_loaded = FALSE
	var/list/adpi_general = list()
	var/list/adpi_departments = list()
	var/list/adpi_department_anti = list()
	var/list/adpi_jobs = list()
	var/list/adpi_next_message = list()
	var/tmp/list/current_adpi_targets = list()
	var/static/list/adpi_sounds = list(
		'sound/ambience/ghostly/ghostly1.ogg',
		'sound/ambience/ghostly/ghostly2.ogg'
	)
	var/static/list/adpi_department_files = list(
		DEPARTMENT_COMMAND = "adpi_dept_command.txt",
		DEPARTMENT_ENGINEERING = "adpi_dept_engineering.txt",
		DEPARTMENT_MEDICAL = "adpi_dept_medical.txt",
		DEPARTMENT_CARGO = "adpi_dept_operations.txt",
		DEPARTMENT_SCIENCE = "adpi_dept_science.txt",
		DEPARTMENT_SECURITY = "adpi_dept_security.txt",
		DEPARTMENT_SERVICE = "adpi_dept_service.txt"
	)
	var/static/list/adpi_department_anti_files = list(
		DEPARTMENT_COMMAND = "adpi_dept_command_anti.txt",
		DEPARTMENT_ENGINEERING = "adpi_dept_engineering_anti.txt",
		DEPARTMENT_MEDICAL = "adpi_dept_medical_anti.txt",
		DEPARTMENT_CARGO = "adpi_dept_operations_anti.txt",
		DEPARTMENT_SCIENCE = "adpi_dept_science_anti.txt",
		DEPARTMENT_SECURITY = "adpi_dept_security_anti.txt",
		DEPARTMENT_SERVICE = "adpi_dept_service_anti.txt"
	)
	var/static/list/adpi_job_files = list(
		"Atmospheric Technician" = "adpi_job_atmostech.txt",
		"Environmental Systems Engineer" = "adpi_job_atmostech.txt",
		"Propulsion Engineer" = "adpi_job_atmostech.txt",
		"Damage Control Technician" = "adpi_job_atmostech.txt",
		"Chef" = "adpi_job_cook.txt",
		"Cook" = "adpi_job_cook.txt",
		"Hangar Technician" = "adpi_job_hangartech.txt",
		"Janitor" = "adpi_job_janitor.txt",
		"Machinist" = "adpi_job_machinist.txt",
		"Shaft Miner" = "adpi_job_mining.txt",
		"Paramedic" = "adpi_job_paramedic.txt",
		"Pharmacist" = "adpi_job_pharmacist.txt",
		"Physician" = "adpi_job_physician.txt",
		"Psychiatrist" = "adpi_job_psychiatrist.txt",
		"Psychologist" = "adpi_job_psychiatrist.txt",
		"Ship Engineer" = "adpi_job_shipengineer.txt",
		"Reactor Operator" = "adpi_job_shipengineer.txt",
		"Maintenance Technician" = "adpi_job_shipengineer.txt",
		"Systems Engineer" = "adpi_job_shipengineer.txt",
		"Surgeon" = "adpi_job_surgeon.txt"
	)

	var/static/list/hal_emote = list("mutters quietly.", "stares.", "grunts.", "looks around.", "twitches.", "shivers.", "swats at the air.", "wobbles.", "gasps!", "blinks rapidly.", "murmurs.",
				"dry heaves!", "twitches violently.", "giggles.", "drools.", "scratches all over.", "grinds their teeth.", "whispers something quietly.")
	var/static/list/message_sender = list("Mom", "Dad", "Captain", "Captain(as Captain)", "help", "Home", "MaxBet Online Casino", "IDrist Corp", "Dr. Maxman",
			"www.wetskrell.nt", "You are our lucky grand prize winner!",  "Matriarch Drone", "Ginny", "Human Resources",
			"what have you DONE?", "Miranda Trasen", "Central Command", "AI", "maintenance drone", "Unknown", "I don't want to die")
	var/list/all_hallucinations = list()

/datum/controller/subsystem/hallucinations/Initialize()
	for(var/T in subtypesof(/datum/hallucination))
		all_hallucinations += T
	// Generic hallucinations
	hallucinated_phrases = file2list("config/hallucinations/hallucinated_phrases.txt")
	hallucinated_actions = file2list("config/hallucinations/hallucinated_actions.txt")	//important note when adding to this file: "you" will always be replaced by the hallucinator's name
	hallucinated_thoughts = file2list("config/hallucinations/hallucinated_thoughts.txt")

	if(!length(hallucinated_phrases))
		hallucinated_phrases += "We are here."
	if(!length(hallucinated_actions))
		hallucinated_actions += "twitches."
	if(!length(hallucinated_thoughts))
		hallucinated_thoughts += "Something's buzzing in your ear."

	if(is_lemurian_sea())
		load_adpi_lists()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/hallucinations/Recover()
	adpi_loaded = SShallucinations.adpi_loaded
	adpi_general = SShallucinations.adpi_general
	adpi_departments = SShallucinations.adpi_departments
	adpi_department_anti = SShallucinations.adpi_department_anti
	adpi_jobs = SShallucinations.adpi_jobs
	adpi_next_message = SShallucinations.adpi_next_message

/datum/controller/subsystem/hallucinations/fire(resumed = FALSE)
	if(!is_lemurian_sea())
		adpi_next_message.Cut()
		return

	if(!adpi_loaded)
		ensure_adpi_lists_loaded()

	if(!resumed)
		prune_adpi_schedules()
		current_adpi_targets = GLOB.living_mob_list.Copy()

	while(length(current_adpi_targets))
		var/mob/living/target = current_adpi_targets[current_adpi_targets.len]
		current_adpi_targets.len--
		if(!istype(target) || QDELETED(target))
			continue

		process_adpi_target(target)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/hallucinations/proc/get_hallucination(var/mob/living/carbon/C)
	var/list/candidates = list()
	for(var/T in all_hallucinations)
		var/datum/hallucination/H = new T
		if(H.can_affect(C))
			candidates += H
	if(candidates.len)
		var/datum/hallucination/D = pick(candidates)
		return D


/////// HANDLES ALL ADPI MESSAGING ///////
/datum/controller/subsystem/hallucinations/proc/is_lemurian_sea()
	return is_lemurian_sea_sector()

/datum/controller/subsystem/hallucinations/proc/read_adpi_file(var/file_name)
	var/list/loaded_file = file2list("config/hallucinations/lemurian_sea/[file_name]")
	if(!loaded_file)
		loaded_file = list()
	return loaded_file

/datum/controller/subsystem/hallucinations/proc/load_adpi_lists()
	adpi_loaded = TRUE
	adpi_general = read_adpi_file("adpi_general.txt")
	adpi_departments = list()
	adpi_department_anti = list()
	adpi_jobs = list()

	if(!length(adpi_general))
		adpi_general += "Something vast and invisible is waiting for you to notice it."

	for(var/department in adpi_department_files)
		adpi_departments[department] = read_adpi_file(adpi_department_files[department])
		if(!length(adpi_departments[department]))
			adpi_departments[department] += "We're going to be the ones who let the ship down."

	for(var/department in adpi_department_anti_files)
		adpi_department_anti[department] = read_adpi_file(adpi_department_anti_files[department])
		if(!length(adpi_department_anti[department]))
			adpi_department_anti[department] += "This is all Central Command's fault."

	for(var/job_title in adpi_job_files)
		adpi_jobs[job_title] = read_adpi_file(adpi_job_files[job_title])
		if(!length(adpi_jobs[job_title]))
			adpi_jobs[job_title] += "We're all going to die out here."

/datum/controller/subsystem/hallucinations/proc/ensure_adpi_lists_loaded()
	if(!adpi_loaded)
		load_adpi_lists()

/datum/controller/subsystem/hallucinations/proc/prune_adpi_schedules()
	for(var/mob/living/target as anything in adpi_next_message.Copy())
		if(QDELETED(target) || !(target in GLOB.living_mob_list) || !target.client || target.stat == DEAD || is_adpi_excluded(target))
			adpi_next_message -= target

/datum/controller/subsystem/hallucinations/proc/is_adpi_excluded(var/mob/living/target)
	return !target || (!target.has_zona_bovinae() && !target.has_psi_aug())

/datum/controller/subsystem/hallucinations/proc/is_adpi_blocked(var/mob/living/target)
	return !target || target.is_psi_blocked(null, FALSE)

/datum/controller/subsystem/hallucinations/proc/can_receive_adpi(var/mob/living/target)
	return is_lemurian_sea() && target && target.client && target.mind && target.stat && is_station_level(target.z) && (target.has_zona_bovinae() || target.has_psi_aug())

/datum/controller/subsystem/hallucinations/proc/get_adpi_job(var/mob/living/carbon/human/H)
	if(!H)
		return

	var/assigned_role
	if(H.mind?.assigned_role)
		assigned_role = H.mind.assigned_role
	else
		assigned_role = H.job

	return SSjobs.GetJob(assigned_role)

/datum/controller/subsystem/hallucinations/proc/get_adpi_departments(var/mob/living/carbon/human/H)
	var/list/departments = list()
	var/datum/job/job = get_adpi_job(H)
	if(job)
		for(var/department in job.departments)
			departments |= department
	return departments

/datum/controller/subsystem/hallucinations/proc/get_adpi_job_messages(var/mob/living/carbon/human/H)
	var/list/job_titles = list()
	var/datum/job/job = get_adpi_job(H)

	if(H?.mind?.role_alt_title)
		job_titles |= H.mind.role_alt_title
	if(job?.title)
		job_titles |= job.title
	if(H?.job)
		job_titles |= H.job

	for(var/job_title in job_titles)
		var/list/job_messages = adpi_jobs[job_title]
		if(length(job_messages))
			return job_messages

	return list()

/datum/controller/subsystem/hallucinations/proc/get_adpi_message_pools(var/mob/living/carbon/human/H, var/include_anti = TRUE, var/check_receiver = TRUE)
	var/list/message_pools = list()
	if(check_receiver && !can_receive_adpi(H))
		return message_pools

	if(length(adpi_general))
		message_pools["general"] = adpi_general

	var/list/departments = get_adpi_departments(H)
	for(var/department in departments)
		var/list/department_messages = adpi_departments[department]
		if(length(department_messages))
			message_pools["department_[department]"] = department_messages

	var/list/job_messages = get_adpi_job_messages(H)
	if(length(job_messages))
		message_pools["job"] = job_messages

	if(include_anti)
		for(var/department in adpi_department_anti)
			if(department in departments)
				continue
			var/list/anti_messages = adpi_department_anti[department]
			if(length(anti_messages))
				message_pools["anti_[department]"] = anti_messages

	return message_pools

/datum/controller/subsystem/hallucinations/proc/has_adpi_messages(var/mob/living/target, var/check_receiver = TRUE)
	if(is_adpi_excluded(target))
		return FALSE

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		return length(get_adpi_message_pools(H, TRUE, FALSE)) > 0

	return length(adpi_general) > 0

/datum/controller/subsystem/hallucinations/proc/process_adpi_target(var/mob/living/target)
	if(!can_receive_adpi(target))
		adpi_next_message -= target
		return

	if(is_adpi_blocked(target))
		// ping their blocker an schedule another ping later.
		schedule_next_adpi_message(target)
		return

	if(!adpi_next_message[target])
		schedule_next_adpi_message(target, TRUE)
		return

	if(world.time < adpi_next_message[target])
		return

	if(send_adpi_message(target))
		schedule_next_adpi_message(target)
	else
		schedule_next_adpi_message(target, TRUE)

/datum/controller/subsystem/hallucinations/proc/schedule_next_adpi_message(var/mob/living/target, var/initial = FALSE)
	adpi_next_message[target] = world.time + get_adpi_delay(target, initial)

/datum/controller/subsystem/hallucinations/proc/get_adpi_delay(var/mob/living/target, var/initial = FALSE)
	var/base_delay = initial ? rand(8 MINUTES, 18 MINUTES) : rand(25 MINUTES, 40 MINUTES)
	return base_delay - (base_delay * ftanh(target.check_psi_sensitivity() / 3))

/datum/controller/subsystem/hallucinations/proc/get_adpi_pool_weight(var/pool_name)
	if(pool_name == "general")
		return 40
	if(pool_name == "job")
		return 35
	if(findtext(pool_name, "department_") == 1)
		return 30
	if(findtext(pool_name, "anti_") == 1)
		return 2
	return 1

/datum/controller/subsystem/hallucinations/proc/pick_adpi_message(var/mob/living/target, var/check_receiver = TRUE)
	if(!ishuman(target))
		return pick(adpi_general)

	var/mob/living/carbon/human/H = target
	var/list/message_pools = get_adpi_message_pools(H, TRUE, FALSE)
	if(!length(message_pools))
		return

	var/list/pool_weights = list()
	for(var/pool_name in message_pools)
		var/list/message_pool = message_pools[pool_name]
		if(length(message_pool))
			pool_weights[pool_name] = get_adpi_pool_weight(pool_name)
	if(!length(pool_weights))
		return

	var/selected_pool_name = pickweight(pool_weights)
	var/list/selected_pool = message_pools[selected_pool_name]
	return pick(selected_pool)

/datum/controller/subsystem/hallucinations/proc/send_adpi_message(var/mob/living/target, var/custom_message = null, var/check_receiver = TRUE)
	var/message = custom_message || pick_adpi_message(target, check_receiver)
	if(!message)
		return FALSE

	deliver_adpi_message(target, message)
	return TRUE

/datum/controller/subsystem/hallucinations/proc/send_admin_adpi_message(var/mob/living/target, var/custom_message = null)
	if(!target || !target.client || !target.mind || target.stat == DEAD || !target.is_psi_blocked(null, FALSE))
		return FALSE

	ensure_adpi_lists_loaded()

	var/message = custom_message
	if(!message)
		message = pick_adpi_message(target, FALSE)

	if(!message)
		return FALSE

	deliver_adpi_message(target, message)

	schedule_next_adpi_message(target)

	return TRUE

/datum/controller/subsystem/hallucinations/proc/deliver_adpi_message(var/mob/living/target, var/message)
	/// % chance to pick one of the general thematic ADPI messages. Enjoy, code peekers; this is all you get!
	if(prob(15))
		message = pick("The water is dripping dripping dripping all around you.","Water flowing over stone, but there is no stone.","The waterfall roars o'er the cliff's edge.","Water, water, water. You are drowning.","Water, water, water. You will be awake for it.","Drums, drums, drums, unrelenting.","The drumbeat draws e'er closer.","Tap, ta-tap, ta-tap, tap, ta-tap, ta-tap.","Tap, tap tap, ta-tap, tap-tap, ta-tap.","Ta-ta-tap, tap, ta-tap, tap, tap ta-tap.")
	target.play_screen_text("[message]", /atom/movable/screen/text/screen_text/adpi_message, COLOR_PURPLE)
	to_chat(target, SPAN_CULT(FONT_LARGE("[message]")))

	if(prob(33))
		sound_to(target, pick(adpi_sounds))

	if(isskrell(target))
		var/mob/living/carbon/human/H = target
		apply_skrell_adpi_pain(H)

/datum/controller/subsystem/hallucinations/proc/apply_skrell_adpi_pain(var/mob/living/carbon/human/H)
	H.adjustHalLoss(rand(5, 12))
	if(prob(35))
		to_chat(H, SPAN_WARNING("A sharp ache lances through your head as the thought passes."))
	if(prob(15))
		H.emote("shiver")
