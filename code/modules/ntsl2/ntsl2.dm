/datum/NTSL_interpreter
	var/connected = 0
	var/locked = 0 // Due to the psudo-threaded nature of Byond, two messages could be sent at the same time. This is a measure against that.
	var/list/programs = list()

/datum/NTSL_interpreter/proc/attempt_connect()
	locked = 0
	var/res = send(list(action="clear"))
	if(!res)
		log_debug("NTSL2+ Daemon could not be connected to. Functionality will not be enabled.")
	else
		START_PROCESSING(SSfast_process, src)
		connected = 1
		log_debug("NTSL2+ Daemon connected successfully.")

/datum/NTSL_interpreter/proc/disconnect()
	connected = 0
	send(list(action="clear"))
	STOP_PROCESSING(SSfast_process, src)
	for(var/datum/ntsl_program/P in programs)
		P.kill()

/datum/NTSL_interpreter/process()
	if(connected)
		var/received_message = send(list(action="subspace_transmit"))
		if(received_message && received_message!="0")
			var/messages = splittext(received_message, "\n")
			for(var/individual_message in messages)
				var/list/message_info = params2list(individual_message);
				var/channel = "[WP_ELECTRONICS][message_info["channel"]]"
				var/message_type = message_info["type"]
				var/message_body = message_info["data"]

				var/message = 0
				if(message_type == "num")
					message = text2num(message_body)
				else if(message_type == "text")
					message = html_encode(message_body)
				else if(message_type == "ref")
					message = locate(message_body)
				for (var/thing in GET_LISTENERS(channel))
					var/listener/L = thing
					var/obj/item/integrated_circuit/transfer/wireless/W = L.target
					if (W != src)
						W.receive(message)
			

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

/datum/NTSL_interpreter/proc/receive_subspace(var/channel, var/data)
	if(istext(data))
		ntsl2.send(list(action="subspace_receive", channel=copytext(channel, length(WP_ELECTRONICS)+1), type="text", data=html_decode(data)))
	else if(isnum(data))
		ntsl2.send(list(action="subspace_receive", channel=copytext(channel, length(WP_ELECTRONICS)+1), type="num", data="[data]"))
	else // Probably an object or something, just get a ref to it.
		ntsl2.send(list(action="subspace_receive", channel=copytext(channel, length(WP_ELECTRONICS)+1), type="ref", data="\ref[data]"))

/*
	Sends a command to the Daemon. This is an internal function, and should be avoided when used externally.
*/
/datum/NTSL_interpreter/proc/send(var/list/commands)
	while(locked) // Prevent multiple requests being sent simultaneously and thus collisions.
		sleep(1)
	if(config.ntsl_hostname && config.ntsl_port) // Requires config to be set.
		locked = 1
		var/http[] = world.Export("http://[config.ntsl_hostname]:[config.ntsl_port]/[list2params(commands)]")
		locked = 0
		if(http)
			return file2text(http["CONTENT"])
	return 0

var/datum/NTSL_interpreter/ntsl2 = new()

/hook/startup/proc/init_ntsl2()
	ntsl2.attempt_connect()
	return 1