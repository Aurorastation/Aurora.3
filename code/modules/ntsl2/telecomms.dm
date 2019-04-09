/datum/TCS_Compiler/ntsl2
	var/datum/ntsl_program/running_code = null

/datum/TCS_Compiler/ntsl2/Compile(code)
	var/list/errors = list()

	if(istype(running_code))
		running_code.kill()

	running_code = ntsl2.new_program(code, src, usr.ckey)
	if(!istype(running_code))
		errors += "The code failed to compile."
	return errors

/datum/TCS_Compiler/ntsl2/Run(var/datum/signal/signal)
	if(istype(running_code))
		running_code.tc_message(signal)
		running_code.cycle(10000)
		update_code()


/datum/TCS_Compiler/ntsl2/proc/update_code()
	if(istype(running_code))
		running_code.cycle(10000)
		var/list/dat = json_decode(ntsl2.send(list(action="get_signals",id=running_code.id)))
		if(istype(dat) && "content" in dat)
			var/datum/signal/sig = null
			if(dat["reference"])
				sig = locate(dat["reference"])
				if(istype(sig))
					var/datum/language/L = all_languages[dat["language"]]
					if(!L || !(L.flags & TCOMSSIM))
						L = all_languages[LANGUAGE_TCB]
					sig.data["message"] = html_encode(dat["content"])
					sig.frequency = text2num(dat["freq"]) || PUB_FREQ
					sig.data["name"] = html_encode(dat["source"])
					sig.data["realname"] = html_encode(dat["source"])
					sig.data["job"] = html_encode(dat["job"])
					sig.data["reject"] = !dat["pass"]
					sig.data["verb"] = html_encode(dat["verb"])
					sig.data["language"] = L
					sig.data["vmessage"] = html_encode(dat["content"])
					sig.data["vname"] = html_encode(dat["source"])
					sig.data["vmask"] = 0
			else
				sig = new()
				sig.data["server"] = running_code.S
				sig.tcombroadcast(html_encode(dat["content"]), dat["freq"], html_encode(dat["source"]), html_encode(dat["job"]), html_encode(dat["verb"]), dat["language"])