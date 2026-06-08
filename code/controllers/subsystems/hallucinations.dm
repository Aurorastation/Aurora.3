SUBSYSTEM_DEF(hallucinations)
	name = "Hallucinations"
	flags = SS_NO_FIRE

	var/list/hallucinated_phrases = list()
	var/list/hallucinated_actions = list()
	var/list/hallucinated_thoughts = list()

	// These lists are only initialized/used when in the Lemurian Sea.
	var/list/adpi_general = list()
	var/list/adpi_dept_command = list()
	var/list/adpi_dept_engineering = list()
	var/list/adpi_dept_medical = list()
	var/list/adpi_dept_operations = list()
	var/list/adpi_dept_science = list()
	var/list/adpi_dept_security = list()
	var/list/adpi_dept_service = list()
	var/list/adpi_job_atmostech = list()
	var/list/adpi_job_cook = list()
	var/list/adpi_job_hangartech = list()
	var/list/adpi_job_mining = list()
	var/list/adpi_job_shipengineer = list()

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

	// Lemurian Sea-only hallucinations
	if(SSatlas.current_sector)
		var/datum/space_sector/current_sector = SSatlas.current_sector
		LOG_DEBUG("<b>Detected sector: [current_sector]</b>")
		if(current_sector == SECTOR_LEMURIAN_SEA || current_sector == SECTOR_LEMURIAN_SEA_FAR)
			adpi_general			= file2list("config/hallucinations/lemurian_sea/adpi_general.txt")
			adpi_dept_command		= file2list("config/hallucinations/lemurian_sea/adpi_dept_command.txt")
			adpi_dept_engineering	= file2list("config/hallucinations/lemurian_sea/adpi_dept_engineering.txt")
			adpi_dept_medical		= file2list("config/hallucinations/lemurian_sea/adpi_dept_medical.txt")
			adpi_dept_operations	= file2list("config/hallucinations/lemurian_sea/adpi_dept_operations.txt")
			adpi_dept_science		= file2list("config/hallucinations/lemurian_sea/adpi_dept_science.txt")
			adpi_dept_security		= file2list("config/hallucinations/lemurian_sea/adpi_dept_security.txt")
			adpi_dept_service		= file2list("config/hallucinations/lemurian_sea/adpi_dept_service.txt")
			adpi_job_atmostech		= file2list("config/hallucinations/lemurian_sea/adpi_job_atmostech.txt")
			adpi_job_cook			= file2list("config/hallucinations/lemurian_sea/adpi_job_cook.txt")
			adpi_job_hangartech		= file2list("config/hallucinations/lemurian_sea/adpi_job_hangartech.txt")
			adpi_job_mining			= file2list("config/hallucinations/lemurian_sea/adpi_job_mining.txt")
			adpi_job_shipengineer	= file2list("config/hallucinations/lemurian_sea/adpi_job_shipengineer.txt")

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
