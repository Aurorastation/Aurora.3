var/datum/controller/subsystem/ntsl2/SSntsl2

/*
NTSL2 deamon management subsystem, responsible for handling events from deamon and it's connection state.
*/
/datum/controller/subsystem/ntsl2
	name = "NTSL2"
	flags = 0
	init_order = SS_INIT_MISC
	// priority = SS_PRIORITY_PROCESSING
	var/connected = FALSE
	var/list/programs = list()

/datum/controller/subsystem/ntsl2/New()
	NEW_SS_GLOBAL(SSntsl2)

/datum/controller/subsystem/ntsl2/Initialize(timeofday)
	attempt_connect()
	..()

/*
	Sends a command to the Daemon. This is an internal function, and should be avoided when used externally.
*/
/datum/controller/subsystem/ntsl2/proc/i_send(var/command, var/list/arguments)
	if(!istext(command))
		CRASH("Expected command to be a text. Maybe outdated use of send?")
	if(config.ntsl_hostname && config.ntsl_port) // Requires config to be set.
		var/query = ""
		if(arguments)
			query = "?" + list2params(arguments)
		var/http[] = world.Export("http://[config.ntsl_hostname]:[config.ntsl_port]/[command][query]")
		if(http)
			return file2text(http["CONTENT"])
	return FALSE

/datum/controller/subsystem/ntsl2/proc/send(var/command, var/list/arguments)
	if(!connected)
		return FALSE
	i_send(command, arguments)
	
/datum/controller/subsystem/ntsl2/proc/attempt_connect()
	var/res = i_send("clear")
	if(!res)
		log_debug("NTSL2++ Daemon could not be connected to. Functionality will not be enabled.")
		return FALSE
	else
		connected = TRUE
		log_debug("NTSL2++ Daemon connected successfully.")
		return TRUE

/datum/controller/subsystem/ntsl2/proc/disconnect()
	connected = FALSE
	i_send("clear")
	// TODO: Kill programs
	for(var/p in programs)
		var/datum/ntsl2_program/Prog = p
		Prog.kill()

// INTERNAL. DO NOT USE
/datum/controller/subsystem/ntsl2/proc/handle_termination(var/program)
	programs -= program


/datum/controller/subsystem/ntsl2/fire(resumed)
	. = ..()
	