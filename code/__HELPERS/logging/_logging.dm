//print an error message to world.log

// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end = world.system_type == UNIX ? ascii2text(13) : ""

// logging.dm
/proc/log_startup()
	var/static/already_logged = FALSE
	if (!already_logged)
		log_world(GLOB.diary, "[log_end]\n[log_end]\nStarting up. (ID: [GLOB.round_id]) [log_end]\n---------------------[log_end]")
		already_logged = TRUE
	else
		crash_with("log_startup() was called more then once")

/proc/log_topic(T, addr, master, key, var/list/queryparams)
	_log_topic("[GLOB.round_id] TOPIC: \"[T]\", from:[addr], master:[master], key:[key], auth:[queryparams["auth"] ? queryparams["auth"] : "null"] [log_end]")

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

GLOBAL_LIST_INIT(testing_global_profiler, list("_PROFILE_NAME" = "Global"))
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

#define testing_profile_global_start(NAME) testing_profile_start(NAME,GLOB.testing_global_profiler)
#define testing_profile_global_current(NAME) testing_profile_current(NAME, GLOB.testing_global_profiler)
#define testing_profile_global_output(NAME) testing_profile_output(NAME, GLOB.testing_global_profiler)
#define testing_profile_global_output_all testing_profile_output_all(GLOB.testing_global_profiler)

#define testing_profile_local_init(PROFILE_NAME) var/list/_timer_system = list( "_PROFILE_NAME" = PROFILE_NAME, "_start_of_proc" = world.timeofday )
#define testing_profile_local_start(NAME) testing_profile_start(NAME, _timer_system)
#define testing_profile_local_current(NAME) testing_profile_current(NAME, _timer_system)
#define testing_profile_local_output(NAME) testing_profile_output(NAME, _timer_system)
#define testing_profile_local_output_all testing_profile_output_all(_timer_system)

/proc/game_log(category, text)
	WRITE_LOG(GLOB.diary, "[GLOB.round_id] [category]: [text][log_end]")

/proc/log_signal(var/text)
	if(length(GLOB.signal_log) >= 100)
		GLOB.signal_log.Cut(1, 2)
	GLOB.signal_log.Add("|[time_stamp()]| [text]")
	_log_signal(text)

/proc/log_ntirc(text, level = SEVERITY_NOTICE, ckey = "", conversation = "")
	log_chat(text)

/proc/log_misc(text)
	log_world("MISC", text)

/proc/log_tgs(text, severity = SEVERITY_INFO)
	log_world("TGS[SEVERITY_INFO]: [text]")

/proc/log_ntsl(text, severity = SEVERITY_NOTICE, ckey = "")
	log_world("NTSL: [text]")

/proc/log_exception(exception/e)
	if (isnull(GLOB.config) || GLOB.config.logsettings["log_runtime"])
		log_runtime("RUNTIME ERROR:\n[e.name] - [e.desc] @@@ [e.file]")

		for(var/k in e.vars)
			if(k != "vars")
				log_runtime("VAR [k] = [e.vars[k]]")

		log_runtime("========= END OF RUNTIME DUMP =========")


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
			. += "<a href='byond://?priv_msg=[REF(C)];ticket=[REF(ticket)]'>"

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
	return "[src] ([type]) ([REF(src)])"

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
			var/v = isnum(e) ? null : d.vars[e]
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

/proc/loc_name(atom/A)
	if(!istype(A))
		return "(INVALID LOCATION)"

	var/turf/T = A
	if (!istype(T))
		T = get_turf(A)

	if(istype(T))
		return "([AREACOORD(T)])"
	else if(A.loc)
		return "(UNKNOWN (?, ?, ?))"
