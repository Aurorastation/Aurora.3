/datum/signal
	var/obj/source

	var/transmission_method = TRANSMISSION_WIRE

	var/list/data = list()
	var/encryption

	var/frequency = 0

/datum/signal/proc/copy_from(datum/signal/model)
	source = model.source
	transmission_method = model.transmission_method
	data = model.data
	encryption = model.encryption
	frequency = model.frequency

/datum/signal/proc/debug_print()
	if (source)
		. = "signal = {source = '[source]' ([source:x],[source:y],[source:z])\n"
	else
		. = "signal = {source = '[source]' ()\n"
	for (var/i in data)
		. += "data\[\"[i]\"\] = \"[data[i]]\"\n"
		if(islist(data[i]))
			var/list/L = data[i]
			for(var/t in L)
				. += "data\[\"[i]\"\] list has: [t]"

/datum/signal/Destroy()
	..()
	return QDEL_HINT_IWILLGC

/datum/signal/proc/tcombroadcast(var/message, var/freq, var/source, var/job, var/verb, var/language)

	var/datum/signal/newsign = new
	var/obj/machinery/telecomms/server/S = data["server"]

	if((!message || message == "") && message != 0)
		message = "*beep*"
	if(!source)
		source = "[html_encode(uppertext(S.id))]"
	if(!freq)
		freq = PUB_FREQ
	if(findtext(num2text(freq), ".")) // if the frequency has been set as a decimal
		freq *= 10 // shift the decimal one place

	if(!job)
		job = "?"

	if(!language || language == "")
		language = LANGUAGE_TCB

	var/datum/language/L = all_languages[language]
	if(!L || !(L.flags & TCOMSSIM))
		L = all_languages[LANGUAGE_TCB]

	newsign.data["mob"] = null
	newsign.data["mobtype"] = /mob/living/carbon/human
	newsign.data["name"] = source
	newsign.data["realname"] = newsign.data["name"]
	newsign.data["job"] = job
	newsign.data["compression"] = 0
	newsign.data["message"] = message
	newsign.data["language"] = L
	newsign.data["type"] = 2 // artificial broadcast
	if(!isnum(freq))
		freq = text2num(freq)
	newsign.frequency = freq

	var/datum/radio_frequency/connection = SSradio.return_frequency(freq)
	newsign.data["connection"] = connection


	newsign.data["vmessage"] = message
	newsign.data["vname"] = source
	newsign.data["vmask"] = 0
	newsign.data["level"] = list()
	newsign.data["verb"] = verb

	var/pass = S.relay_information(newsign, "/obj/machinery/telecomms/hub")
	if(!pass)
		S.relay_information(newsign, "/obj/machinery/telecomms/broadcaster") // send this simple message to broadcasters
