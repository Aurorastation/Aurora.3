/NTSL_interpreter
	var/connected = 0
	var/list/programs = list()

	New()
		spawn(300)
			attempt_connect()
		return ..()

	proc/attempt_connect()
		var/res = send(list(action="clear"))
		if(!res)
			message_admins("NTSL2+ Daemon could not be connected to. Functionality will not be enabled.")
		else
			connected = 1

	proc/disconnect()
		connected = 0
		send(list(action="clear"))
		for(var/datum/ntsl_program/P in programs)
			P.kill()

	proc/new_program(var/code, var/computer)
		if(!connected)
			return 0

		var/program_id = send(list(action="new_program", code=code, ref = "\ref[computer]"))
		if(connected) // Because both new program and error can send 0.
			var/datum/ntsl_program/P = new(program_id)
			programs += P
			return P
		return 0

	/*
		Sends a command to the Daemon. This is an internal function, and should be avoided when used externally.
	*/
	proc/send(var/list/commands)
		var/http[] = world.Export("http://127.0.0.1:1945/[list2params(commands)]")
		if(http)
			return file2text(http["CONTENT"])
		return 0




var/NTSL_interpreter/ntsl2 = new/NTSL_interpreter()