

/datum/controller/subsystem/processing/ntsl2/proc/new_program_computer(var/buffer_callback)
	var/datum/ntsl2_program/computer/P = new()
	var/res = send_task("new_program", list(type = "Computer"), program = P)
	if(res)
		programs += P
		START_PROCESSING(SSntsl2, P)
		P.buffer_update_callback = buffer_callback
		return P
	qdel(P)
	return FALSE

/datum/controller/subsystem/processing/ntsl2/proc/new_program_tcomm(var/server)
	var/datum/ntsl2_program/tcomm/P = new(server)
	var/res = send_task("new_program", list(type = "TCom"), program = P)
	if(res)
		programs += P
		START_PROCESSING(SSntsl2, P)
		return P
	qdel(P)
	return FALSE

// Modular computer interpreter
/datum/ntsl2_program/computer
	name = "NTSL2++ interpreter"
	var/buffer = ""
	var/last_buffer_task = 0
	var/datum/callback/buffer_update_callback

/datum/ntsl2_program/computer/proc/handle_topic(var/topic)
	if(!is_ready())
		return FALSE // We are not ready to run code
	if(copytext(topic, 1, 2) == "?")
		var/data = input("", "Enter Data")
		if(!data)
			data = ""
		SSntsl2.send_task("computer/topic", list(id = id, topic = copytext(topic, 2), data = data))
	else
		SSntsl2.send_task("computer/topic", list(id = id, topic = topic))

/datum/ntsl2_program/computer/process()
	if(SSntsl2.is_complete(last_buffer_task) && is_ready())
		last_buffer_task = SSntsl2.send_task("computer/get_buffer", list(id = id), program = src)

// Currently unused
// Telecommunications program
/datum/ntsl2_program/tcomm
	name = "NTSL2++ comm program"
	var/obj/machinery/telecomms/server/server


/datum/ntsl2_program/tcomm/New(var/server)
	. = ..()
	src.server = server

/datum/ntsl2_program/tcomm/proc/process_message(var/datum/signal/subspace/vocal/signal, var/callback = null)
	var/datum/language/signal_language = signal.data["language"]
	SSntsl2.send_task("tcom/process", list(
		id = id,
		signal = list(
			content = html_decode(signal.data["message"]),
			freq = signal.frequency,
			source = html_decode(signal.data["name"]),
			job = html_decode(signal.data["job"]),
			pass = !(signal.data["reject"]),
			verb = signal.data["say_verb"],
			language = signal_language.name,
			reference = ref(signal)
		)
	), RUSTG_HTTP_METHOD_POST, callback = callback)
	/* [
  {
	"content": "AAAAA",
	"freq": "1459",
	"source": "Telecomms Broadcaster",
	"job": "Machine",
	"pass": true,
	"verb": "says",
	"language": "Ceti Basic",
	"reference": null
  }
]*/

/datum/ntsl2_program/tcomm/proc/retrieve_messages(callback = null)
	SSntsl2.send_task("tcom/get", callback = CALLBACK(src, .proc/_finish_retrieve_messages, callback))

/datum/ntsl2_program/tcomm/proc/_finish_retrieve_messages(callback = null, data)
	if(data)
		var/list/signals = json_decode(data)
		for(var/sl in signals)
			var/list/S = sl
			var/datum/signal/subspace/vocal/sig = locate(S["reference"])
			if(!istype(sig))
				continue

			var/datum/language/L = all_languages[S["language"]]
			if(!L || !(L.flags & TCOMSSIM))
				L = all_languages[LANGUAGE_TCB]

			sig.frequency = S["freq"] || PUB_FREQ

			sig.data["name"] = html_encode(S["source"])
			sig.data["job"] = html_encode(S["job"])
			sig.data["message"] = S["content"]
			sig.data["language"] = L
			sig.data["say_verb"] = html_encode(S["verb"])
			sig.data["reject"] = !S["pass"]

	var/datum/callback/cb = callback
	if(istype(cb))
		cb.InvokeAsync()
