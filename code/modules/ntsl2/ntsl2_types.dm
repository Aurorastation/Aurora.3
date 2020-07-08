

/datum/controller/subsystem/ntsl2/proc/new_program_computer(var/computer)
	var/res = send("new_program", list(ref = "\ref[computer]", type = "Computer"))
	if(res)
		var/datum/ntsl2_program/computer/P = new(res)
		programs += P
		return P
	return FALSE

/datum/controller/subsystem/ntsl2/proc/new_program_tcomm(var/server)
	var/res = send("new_program", list(type = "TCom"))
	if(res)
		var/datum/ntsl2_program/tcomm/P = new(res, server)
		programs += P
		return P
	return FALSE

// Modular computer interpreter
/datum/ntsl2_program/computer
	name = "NTSL2++ interpreter"

/datum/ntsl2_program/computer/proc/get_buffer()
	return SSntsl2.send("computer/get_buffer", list(id = id))

/datum/ntsl2_program/computer/proc/handle_topic(var/topic)
	if(copytext(topic, 1, 2) == "?")
		var/data = input("", "Enter Data")
		SSntsl2.send("computer/topic", list(id = id, topic = copytext(topic, 2), data = data))
	else
		SSntsl2.send("computer/topic", list(id = id, topic = topic))


// Telecommunications program
/datum/ntsl2_program/tcomm
	name = "NTSL2++ comm program"
	var/obj/machinery/telecomms/server/server


/datum/ntsl2_program/tcomm/New(var/id, var/server)
	. = ..(id)
	src.server = server

/datum/ntsl2_program/tcomm/proc/process_message(var/datum/signal/signal)
	var/datum/language/signal_language = signal.data["language"]
	SSntsl2.send("tcom/process", list(
		id = id,
		signal = list(
			content = html_decode(signal.data["message"]),
			freq = signal.frequency,
			source = html_decode(signal.data["name"]),
			job = html_decode(signal.data["job"]),
			pass = !(signal.data["reject"]),
			verb = signal.data["verb"],
			language = signal_language.name,
			reference = ref(signal)
		)
	), RUSTG_HTTP_METHOD_POST)
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

/datum/ntsl2_program/tcomm/proc/retrieve_messages()
	var/data = SSntsl2.send("tcom/get")
	if(data)
		var/list/signals = json_decode(data)
		for(var/sl in signals)
			var/list/S = sl
			var/datum/signal/sig = null
			if(S["reference"])
				sig = locate(S["reference"])
				if(istype(sig))
					var/datum/language/L = all_languages[S["language"]]
					if(!L || !(L.flags & TCOMSSIM))
						L = all_languages[LANGUAGE_TCB]
					sig.data["message"] = S["content"]
					sig.frequency = S["freq"] || PUB_FREQ
					sig.data["name"] = html_encode(S["source"])
					sig.data["realname"] = html_encode(S["source"])
					sig.data["job"] = html_encode(S["job"])
					sig.data["reject"] = !S["pass"]
					sig.data["verb"] = html_encode(S["verb"])
					sig.data["language"] = L
					sig.data["vmessage"] = html_encode(S["content"]) 
					sig.data["vname"] = html_encode(S["source"])
					sig.data["vmask"] = 0
			else
				sig = new()
				sig.data["server"] = server
				sig.tcombroadcast(html_encode(S["content"]), S["freq"], html_encode(S["source"]), html_encode(S["job"]), html_encode(S["verb"]), S["language"])