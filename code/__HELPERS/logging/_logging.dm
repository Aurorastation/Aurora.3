//print an error message to world.log

// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end = world.system_type == UNIX ? ascii2text(13) : ""

// logging.dm
/proc/log_startup()
	var/static/already_logged = FALSE
	if (!already_logged)
		log_world(GLOB.diary, "[log_end]\n[log_end]\nStarting up. (ID: [game_id]) [log_end]\n---------------------[log_end]")
		already_logged = TRUE
	else
		crash_with("log_startup() was called more then once")

/proc/log_topic(T, addr, master, key, var/list/queryparams)
	_log_topic("[game_id] TOPIC: \"[T]\", from:[addr], master:[master], key:[key], auth:[queryparams["auth"] ? queryparams["auth"] : "null"] [log_end]")

/proc/log_error(msg)
	world.log <<  "## ERROR: [msg][log_end]"
	log_world("ERROR", msg)

/proc/shutdown_logging()
	dll_call(RUST_G, "log_close_all")

//print a warning message to world.log
/proc/warning(msg)
	#if defined(UNIT_TEST)

	LOG_GITHUB_WARNING(msg)

	#else

	world.log <<  "## WARNING: [msg][log_end]"
	log_world("WARNING: [msg]")

	#endif

//print a testing-mode debug message to world.log and world
#ifdef TESTING
#define testing(msg) log_world("## TESTING: [msg]"); to_chat(world, "## TESTING: [msg]")

//When we port GLOB ...
//GLOBAL_LIST_INIT(testing_global_profiler, list("_PROFILE_NAME" = "Global"))

// we don't really check if a word or name is used twice, be aware of that
#define testing_profile_start(NAME, LIST) LIST[NAME] = world.timeofday
#define testing_profile_current(NAME, LIST) round((world.timeofday - LIST[NAME])/10,0.1)
#define testing_profile_output(NAME, LIST) testing("[LIST["_PROFILE_NAME"]] profile of [NAME] is [testing_profile_current(NAME,LIST)]s")
#define testing_profile_output_all(LIST) { for(var/_NAME in LIST) { testing_profile_current(,_NAME,LIST); }; };
#else
#define testing(msg)
#define testing_profile_start(NAME, LIST)
#define testing_profile_current(NAME, LIST)
#define testing_profile_output(NAME, LIST)
#define testing_profile_output_all(LIST)
#endif

/proc/game_log(category, text)
	WRITE_LOG(GLOB.diary, "[game_id] [category]: [text][log_end]")

/proc/log_admin(text,level=SEVERITY_NOTICE,ckey="",admin_key="",ckey_target="")
	_log_admin(text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="ADMIN",additional_data=list("_ckey"=html_encode(ckey),"_admin_key"=html_encode(admin_key),"_ckey_target"=html_encode(ckey_target)))

/proc/log_signal(var/text)
	if(length(GLOB.signal_log) >= 100)
		GLOB.signal_log.Cut(1, 2)
	GLOB.signal_log.Add("|[time_stamp()]| [text]")
	_log_signal(text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=SEVERITY_NOTICE,category="SIGNALER")

/proc/log_game(text, level = SEVERITY_NOTICE, ckey = "", admin_key = "", ckey_target = "")
	_log_game(text)
	send_gelf_log(short_message = text,	long_message = "[time_stamp()]: [text]", level = level,	category = "GAME", additional_data = list("_ckey" = html_encode(ckey), "_admin_key" = html_encode(admin_key), "_target" = html_encode(ckey_target)))

/proc/log_vote(text)
	_log_vote(text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=5,category="VOTE")

/proc/log_access(text, level = SEVERITY_NOTICE,ckey="")
	_log_access(text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="ACCESS",additional_data=list("_ckey"=html_encode(ckey)))

/proc/log_say(text, level = SEVERITY_NOTICE, ckey = "")
	_log_say(text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="SAY",additional_data=list("_ckey"=html_encode(ckey)))

/proc/log_ooc(text, level = SEVERITY_NOTICE, ckey = "")
	_log_ooc(text)
	send_gelf_log(short_message = text, long_message = "[time_stamp()]: [text]", level = level, category = "OOC", additional_data = list("_ckey" = html_encode(ckey)))

/proc/log_whisper(text, level = SEVERITY_NOTICE, ckey = "")
	_log_whisper(text)
	send_gelf_log(short_message = text, long_message = "[time_stamp()]: [text]", level = level, category = "WHISPER", additional_data = list("_ckey" = html_encode(ckey)))

/proc/log_emote(text, level = SEVERITY_NOTICE, ckey = "")
	_log_emote(text)
	send_gelf_log(short_message = text, long_message = "[time_stamp()]: [text]",level = level,category = "EMOTE", additional_data = list("_ckey" = html_encode(ckey)))

/proc/log_attack(text, level = SEVERITY_NOTICE, ckey = "", ckey_target = "")
	_log_attack(text)
	send_gelf_log(short_message = text,	long_message = "[time_stamp()]: [text]", level = level,	category="ATTACK",	additional_data = list("_ckey" = html_encode(ckey), "_ckey_target" = html_encode(ckey_target)))

/proc/log_adminsay(text)
	_log_adminsay(text)
/proc/log_ntirc(text, level = SEVERITY_NOTICE, ckey = "", conversation = "")
	log_chat(text)
	send_gelf_log(short_message = text,	long_message="[time_stamp()]: [text]",	level = level,	category = "NTIRC",	additional_data = list("_ckey" = html_encode(ckey), "_ntirc_conversation" = html_encode(conversation)))


/proc/log_to_dd(text)
	world.log <<  text //this comes before the config check because it can't possibly runtime
	if(GLOB.config.log_world_output)
		log_world("DD_OUTPUT", text)
	send_gelf_log(short_message = text, long_message = "[time_stamp()]: [text]", level = SEVERITY_NOTICE, category = "DD_OUTPUT")

/proc/log_misc(text)
	log_world("MISC", text)
	send_gelf_log(short_message = text, long_message = "[time_stamp()]: [text]", level = SEVERITY_NOTICE, category="MISC")

/proc/log_tgs(text, severity = SEVERITY_INFO)
	log_world("TGS[SEVERITY_INFO]: [text]")
	send_gelf_log(short_message = text,	long_message="[time_stamp()]: [text]",	level = severity, category = "TGS")

/proc/log_ntsl(text, severity = SEVERITY_NOTICE, ckey = "")
	log_world("NTSL: [text]")
	send_gelf_log(text, "[time_stamp()]: [text]", severity, "NTSL", additional_data = list("_ckey" = ckey))

/proc/log_exception(exception/e)
	if (isnull(GLOB.config) || GLOB.config.logsettings["log_runtime"])
		log_runtime("RUNTIME ERROR:\n[e.name] - [e.desc] @@@ [e.file]")

		for(var/k in e.vars)
			if(k != "vars")
				log_runtime("VAR [k] = [e.vars[k]]")

		log_runtime("========= END OF RUNTIME DUMP =========")
		send_gelf_log(short_message = "runtime error:[e.name]", long_message = "[e.desc]", level = SEVERITY_WARNING, category = "RUNTIME")

//pretty print a direction bitflag, can be useful for debugging.
/proc/print_dir(var/dir)
	var/list/comps = list()
	if(dir & NORTH) comps += "NORTH"
	if(dir & SOUTH) comps += "SOUTH"
	if(dir & EAST) comps += "EAST"
	if(dir & WEST) comps += "WEST"
	if(dir & UP) comps += "UP"
	if(dir & DOWN) comps += "DOWN"

	return english_list(comps, nothing_text="0", and_text="|", comma_text="|")

//more or less a logging utility
/proc/key_name(var/whom, var/include_link = null, var/include_name = 1, var/highlight_special = 0, var/datum/ticket/ticket = null)
	var/mob/M
	var/client/C
	var/key

	if(!whom)	return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
	else if(istype(whom, /datum/mind))
		var/datum/mind/D = whom
		key = D.key
		M = D.current
		if(D.current)
			C = D.current.client
	else if(istype(whom, /datum))
		var/datum/D = whom
		return "*invalid:[D.type]*"
	else
		return "*invalid*"

	. = ""

	if(key)
		if(include_link && C)
			. += "<a href='?priv_msg=\ref[C];ticket=\ref[ticket]'>"

		if(C && C.holder && C.holder.fakekey && !include_name)
			. += "Administrator"
		else
			. += key

		if(include_link)
			if(C)	. += "</a>"
			else	. += " (DC)"
	else
		. += "*no key*"

	if(include_name && M)
		var/name

		if(M.real_name)
			name = M.real_name
		else if(M.name)
			name = M.name


		if(is_special_character(M) && highlight_special)
			. += "/(<font color='#FFA500'>[name]</font>)" //Orange
		else
			. += "/([name])"

	return .

/proc/key_name_admin(var/whom, var/include_name = 1)
	return key_name(whom, 1, include_name, 1)

// Helper procs for building detailed log lines
/datum/proc/get_log_info_line()
	return "[src] ([type]) (\ref[src])"

/area/get_log_info_line()
	return "[..()] ([isnum(z) ? "[x],[y],[z]" : "0,0,0"])"

/turf/get_log_info_line()
	return "[..()] ([x],[y],[z]) ([loc ? loc.type : "NULL"])"

/atom/movable/get_log_info_line()
	var/turf/t = get_turf(src)
	return "[..()] ([t ? t : "NULL"]) ([t ? "[t.x],[t.y],[t.z]" : "0,0,0"]) ([t ? t.type : "NULL"])"

/mob/get_log_info_line()
	return ckey ? "[..()] ([ckey])" : ..()

/proc/log_info_line(var/datum/d)
	if(isnull(d))
		return "*null*"
	if(islist(d))
		var/list/L = list()
		for(var/e in d)
			// Indexing on numbers just gives us the same number again in the best case and causes an index out of bounds runtime in the worst
			var/v = isnum(e) ? null : d[e]
			L += "[log_info_line(e)][v ? " - [log_info_line(v)]" : ""]"
		return "\[[jointext(L, ", ")]\]" // We format the string ourselves, rather than use json_encode(), because it becomes difficult to read recursively escaped "
	if(!istype(d))
		return json_encode(d)
	return d.get_log_info_line()

/**
 * Appends a tgui-related log entry. All arguments are optional.
 */
/proc/log_tgui(user, message, context,
		datum/tgui_window/window,
		datum/src_object)
	if(GLOB.config.logsettings["log_subsystems_tgui"])
		var/entry = ""
		// Insert user info
		if(!user)
			entry += "<nobody>"
		else if(istype(user, /mob))
			var/mob/mob = user
			entry += "[mob.ckey] (as [mob] at [mob.x],[mob.y],[mob.z])"
		else if(istype(user, /client))
			var/client/client = user
			entry += "[client.ckey]"
		// Insert context
		if(context)
			entry += " in [context]"
		else if(window)
			entry += " in [window.id]"
		// Resolve src_object
		if(!src_object && window?.locked_by)
			src_object = window.locked_by.src_object
		// Insert src_object info
		if(src_object)
			entry += "\nUsing: [src_object.type] [text_ref(src_object)]"
		// Insert message
		if(message)
			entry += "\n[message]"
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_tgui"], "TGUI: [entry]")
