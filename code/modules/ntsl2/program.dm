/datum/ntsl_program
	var/id = -1
	var/name = "NTSL Program"

	var/obj/machinery/telecomms/server/S = null

	New(var/my_id)
		id = my_id

		// Failsafe, kill any obsolete programs.
		for(var/datum/ntsl_program/P in ntsl2.programs)
			if(P.id == id)
				P.kill()
		..()

	proc/cycle(var/amount)
		if(ntsl2.connected)
			ntsl2.send(list(action = "execute", id = id, cycles = amount))

	proc/get_terminal()
		return ntsl2.send(list(action = "get_buffered", id = id))

	proc/topic(var/message)
		if(ntsl2.connected)
			ntsl2.send(list(action = "topic", id = id, topic = message))

	proc/kill()
		if(ntsl2.connected)
			ntsl2.send(list(action = "remove", id = id))
			ntsl2.programs -= src
			qdel(src)

	proc/tc_message(var/datum/signal/signal)
		if(ntsl2.connected)
			ntsl2.send(list(action = "message", id = id, sig_ref = "\ref[signal]", signal = list2params(list(
				content = html_decode(signal.data["message"]),
				source = html_decode(signal.data["name"]),
				job = html_decode(signal.data["job"]),
				freq = signal.frequency,
				pass = !(signal.data["reject"]),
				language = signal.data["language"].name,
				verb = signal.data["verb"]
			))))
