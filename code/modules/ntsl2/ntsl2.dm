/datum/NTSL_interpreter
	var/connected = 0
	var/list/programs = list()

/datum/NTSL_interpreter/proc/attempt_connect()
	var/res = send(list(action="clear"))
	if(!res)
		log_debug("NTSL2+ Daemon could not be connected to. Functionality will not be enabled.")
	else
		connected = 1
		log_debug("NTSL2+ Daemon connected successfully.")

/datum/NTSL_interpreter/proc/disconnect()
	connected = 0
	send(list(action="clear"))
	for(var/datum/ntsl_program/P in programs)
		P.kill()

/datum/NTSL_interpreter/proc/new_program(var/code, var/computer, var/mob/user)
	if(!connected)
		return 0

	log_ntsl("[user.name]/[user.key] uploaded script to [computer] : [code]", istype(computer, /datum/TCS_Compiler/) ? SEVERITY_ALERT : SEVERITY_NOTICE, user.ckey)
	var/program_id = send(list(action="new_program", code=code, ref = "\ref[computer]"))
	if(connected) // Because both new program and error can send 0.
		var/datum/ntsl_program/P = new(program_id)
		programs += P
		return P
	return 0

/*
	Sends a command to the Daemon. This is an internal function, and should be avoided when used externally.
*/
/datum/NTSL_interpreter/proc/send(var/list/commands)
	if(config.ntsl_hostname && config.ntsl_port) // Requires config to be set.
		var/http[] = world.Export("http://[config.ntsl_hostname]:[config.ntsl_port]/[list2params(commands)]")
		if(http)
			return file2text(http["CONTENT"])
	return 0

var/datum/NTSL_interpreter/ntsl2 = new()

/hook/startup/proc/init_ntsl2()
	ntsl2.attempt_connect()
	return 1