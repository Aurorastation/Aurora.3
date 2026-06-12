SUBSYSTEM_DEF(hallucinations)
	name = "Hallucinations"
	flags = SS_NO_FIRE

	var/list/hallucinated_phrases = list()
	var/list/hallucinated_actions = list()
	var/list/hallucinated_thoughts = list()

	// These lists are only initialized/used when in the Lemurian Sea.
	var/list/adpi_general = list()
	var/list/adpi_departments = list()
	var/list/adpi_department_anti = list()
	var/list/adpi_jobs = list()
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

	if(is_lemurian_sea())
		load_adpi_lists()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/hallucinations/proc/get_hallucination(var/mob/living/carbon/C)
	var/list/candidates = list()
	for(var/T in all_hallucinations)
		var/datum/hallucination/H = new T
		if(H.can_affect(C))
			candidates += H
	if(candidates.len)
		var/datum/hallucination/D = pick(candidates)
		return D

/datum/controller/subsystem/hallucinations/proc/is_lemurian_sea()
	return SSatlas.current_sector?.name in list(SECTOR_LEMURIAN_SEA, SECTOR_LEMURIAN_SEA_FAR)

/datum/controller/subsystem/hallucinations/proc/read_adpi_file(var/file_name)
	var/list/loaded_file = file2list("config/hallucinations/lemurian_sea/[file_name]")
	if(!loaded_file)
		loaded_file = list()
	return loaded_file

/datum/controller/subsystem/hallucinations/proc/load_adpi_lists()
	adpi_general = read_adpi_file("adpi_general.txt")
	adpi_departments = list()
	adpi_department_anti = list()
	adpi_jobs = list()

	for(var/department in adpi_department_files)
		adpi_departments[department] = read_adpi_file(adpi_department_files[department])

	for(var/department in adpi_department_anti_files)
		adpi_department_anti[department] = read_adpi_file(adpi_department_anti_files[department])

	for(var/job_title in adpi_job_files)
		adpi_jobs[job_title] = read_adpi_file(adpi_job_files[job_title])

/datum/controller/subsystem/hallucinations/proc/can_receive_adpi(var/mob/living/carbon/human/H)
	if(!is_lemurian_sea())
		return FALSE
	if(!H || !H.client || H.stat)
		return FALSE
	if(!is_station_level(H.z))
		return FALSE
	if(H.isMonkey())
		return FALSE
	return TRUE

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

/datum/controller/subsystem/hallucinations/proc/get_adpi_message_pools(var/mob/living/carbon/human/H, var/include_anti = TRUE)
	var/list/message_pools = list()
	if(!can_receive_adpi(H))
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
