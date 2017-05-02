//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end= world.system_type == UNIX ? ascii2text(13) : ""


/proc/error(msg)
	world.log << "## ERROR: [msg][log_end]"

#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg][log_end]"

//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg][log_end]"

/proc/game_log(category, text)
	diary << "\[[time_stamp()]] [game_id] [category]: [text][log_end]"

/proc/log_admin(text,level=5,ckey="",admin_key="",ckey_target="")
	admin_log.Add(text)
	if (config.log_admin)
		game_log("ADMIN", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="ADMIN",additional_data=list("_ckey"=html_encode(ckey),"_admin_key"=html_encode(admin_key),"_ckey_target"=html_encode(ckey_target)))

/proc/log_debug(text,level=5)
	if (config.log_debug)
		game_log("DEBUG", text)

	for(var/client/C in admins)
		if(!C.prefs) //This is to avoid null.toggles runtime error while still initialyzing players preferences
			return
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			C << "DEBUG: [text]"
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="DEBUG")

/proc/log_game(text,level=5,ckey="",admin_key="",ckey_target="")
	if (config.log_game)
		game_log("GAME", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="GAME",additional_data=list("_ckey"=html_encode(ckey),"_admin_key"=html_encode(admin_key),"_target"=html_encode(target)))

/proc/log_vote(text)
	if (config.log_vote)
		game_log("VOTE", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=5,category="VOTE")

/proc/log_access(text,level=5,ckey="")
	if (config.log_access)
		game_log("ACCESS", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="ACCESS",additional_data=list("_ckey"=html_encode(ckey)))

/proc/log_say(text,level=5,ckey="")
	if (config.log_say)
		game_log("SAY", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="SAY",additional_data=list("_ckey"=html_encode(ckey)))

/proc/log_ooc(text,level=5,ckey="")
	if (config.log_ooc)
		game_log("OOC", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="OOC",additional_data=list("_ckey"=html_encode(ckey)))

/proc/log_whisper(text,level=5,ckey="")
	if (config.log_whisper) 
		game_log("WHISPER", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="WHISPER",additional_data=list("_ckey"=html_encode(ckey)))

/proc/log_emote(text,level=5,ckey="")
	if (config.log_emote)
		game_log("EMOTE", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="EMOTE",additional_data=list("_ckey"=html_encode(ckey)))

/proc/log_attack(text,level=5,ckey="",ckey_target="")
	if (config.log_attack)
		game_log("ATTACK", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=5,category="ATTACK",additional_data=list("_ckey"=html_encode(ckey),"_ckey_target"=html_encode(ckey_target)))

/proc/log_adminsay(text)
	if (config.log_adminchat)
		game_log("ADMINSAY", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=5,category="ADMINSAY")

/proc/log_pda(text,level=5,ckey="",ckey_target="")
	if (config.log_pda)
		game_log("PDA", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="PDA",additional_data=list("_ckey"=html_encode(ckey),"_ckey_target"=html_encode(ckey_target)))

/proc/log_ntirc(text,level=5,ckey="",conversation="")
	if (config.log_pda)
		game_log("NTIRC", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=level,category="NTIRC",additional_data=list("_ckey"=html_encode(ckey),"_ntirc_conversation"=html_encode(conversation)))

/proc/log_to_dd(text)
	world.log << text //this comes before the config check because it can't possibly runtime
	if(config.log_world_output)
		game_log("DD_OUTPUT", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=5,category="DD_OUTPUT")

/proc/log_misc(text)
	game_log("MISC", text)
	send_gelf_log(short_message=text, long_message="[time_stamp()]: [text]",level=5,category="MISC")

/proc/log_unit_test(text)
	world.log << "## UNIT_TEST ##: [text]"

// Procs for logging into diary_runtime
/proc/log_hard_delete(atom/A)
	if (config.log_runtime)
		diary_runtime << "hard delete:[log_end]"
		diary_runtime << "[A.type][log_end]"
		send_gelf_log(short_message="hard delete: [A.type]",level=5,category="HARDDEL")

/proc/log_exception(exception/e)
	if (config.log_runtime)
		if (config.log_runtime == 2)
			log_debug("RUNTIME ERROR:\n[e.name]")

		diary_runtime << "runtime error:[e.name][log_end]"
		diary_runtime << "[e.desc]"
		send_gelf_log(short_message="runtime error:[e.name]",long_message="[e.desc]",level=5,category="HARDDEL")

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
/proc/key_name(var/whom, var/include_link = null, var/include_name = 1, var/highlight_special_characters = 1)
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
			. += "<a href='?priv_msg=\ref[C]'>"

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


		if(include_link && is_special_character(M) && highlight_special_characters)
			. += "/(<font color='#FFA500'>[name]</font>)" //Orange
		else
			. += "/([name])"

	return .

/proc/key_name_admin(var/whom, var/include_name = 1)
	return key_name(whom, 1, include_name)
