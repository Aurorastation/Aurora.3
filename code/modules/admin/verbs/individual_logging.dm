/proc/show_individual_logging_panel(mob/M, source = LOGSRC_CKEY, type = INDIVIDUAL_ATTACK_LOG)
	if(!M || !ismob(M))
		return
	if(!usr?.client?.holder || !check_rights(R_ADMIN, FALSE, usr))
		return

	// re: heavier type and source checking, really we need our fucky hrefs sorted out... eventually
	var/ntype = isnum(type) ? type : text2num(type)
	if(!ntype)
		ntype = INDIVIDUAL_ATTACK_LOG
	if(source != LOGSRC_CKEY && source != LOGSRC_MOB)
		source = LOGSRC_CKEY

	/// Add client links
	var/list/dat = list()

	// persistent clients and ckeys still fighting me during port, so more safety checks.
	var/datum/persistent_client/persistent = M.persistent_client
	if(!persistent && M.ckey && copytext(M.ckey, 1, 2) != "@")
		persistent = GLOB.persistent_clients_by_ckey[ckey(M.ckey)]

	if(M.ckey || persistent)
		dat += "<center><p>Ckey</p></center>"
		dat += "<center>"
		dat += individual_logging_panel_link(M, INDIVIDUAL_GAME_LOG, LOGSRC_CKEY, "Game Log", source, ntype)
		dat += " | "
		dat += individual_logging_panel_link(M, INDIVIDUAL_ATTACK_LOG, LOGSRC_CKEY, "Attack Log", source, ntype)
		dat += " | "
		dat += individual_logging_panel_link(M, INDIVIDUAL_SAY_LOG, LOGSRC_CKEY, "Say Log", source, ntype)
		dat += " | "
		dat += individual_logging_panel_link(M, INDIVIDUAL_EMOTE_LOG, LOGSRC_CKEY, "Emote Log", source, ntype)
		dat += " | "
		dat += individual_logging_panel_link(M, INDIVIDUAL_COMMS_LOG, LOGSRC_CKEY, "Comms Log", source, ntype)
		dat += " | "
		dat += individual_logging_panel_link(M, INDIVIDUAL_OOC_LOG, LOGSRC_CKEY, "OOC Log", source, ntype)
		dat += " | "
		dat += individual_logging_panel_link(M, INDIVIDUAL_SHOW_ALL_LOG, LOGSRC_CKEY, "Show All", source, ntype)
		dat += "</center>"
	else
		dat += "<p>No ckey attached to mob.</p>"

	dat += "<hr style='background:#000000; border:0; height:1px'>"
	dat += "<center><p>Mob</p></center>"
	// Add the links for the mob specific log
	dat += "<center>"
	dat += individual_logging_panel_link(M, INDIVIDUAL_GAME_LOG, LOGSRC_MOB, "Game Log", source, ntype)
	dat += " | "
	dat += individual_logging_panel_link(M, INDIVIDUAL_ATTACK_LOG, LOGSRC_MOB, "Attack Log", source, ntype)
	dat += " | "
	dat += individual_logging_panel_link(M, INDIVIDUAL_SAY_LOG, LOGSRC_MOB, "Say Log", source, ntype)
	dat += " | "
	dat += individual_logging_panel_link(M, INDIVIDUAL_EMOTE_LOG, LOGSRC_MOB, "Emote Log", source, ntype)
	dat += " | "
	dat += individual_logging_panel_link(M, INDIVIDUAL_COMMS_LOG, LOGSRC_MOB, "Comms Log", source, ntype)
	dat += " | "
	dat += individual_logging_panel_link(M, INDIVIDUAL_OOC_LOG, LOGSRC_MOB, "OOC Log", source, ntype)
	dat += " | "
	dat += individual_logging_panel_link(M, INDIVIDUAL_SHOW_ALL_LOG, LOGSRC_MOB, "Show All", source, ntype)
	dat += "</center>"
	dat += "<hr style='background:#000000; border:0; height:1px'>"

	var/list/log_source = M.logging
	if(source == LOGSRC_CKEY && persistent)
		log_source = persistent.logging

	// temporary, i fucking hope. LOGGING-TODO
	var/list/concatenated_logs = list()
	if(islist(log_source))
		for(var/log_type in log_source)
			var/nlog_type = text2num(log_type)
			if(nlog_type & ntype)
				var/list/entries = log_source[log_type]
				if(!islist(entries))
					continue
				for(var/entry in entries)
					concatenated_logs += "<b>[entry]</b><br>[entries[entry]]"

	if(length(concatenated_logs))
		sortTim(concatenated_logs, GLOBAL_PROC_REF(cmp_text_dsc)) // Sort by timestamp.
		dat += "<font size=2px>"
		dat += concatenated_logs.Join("<br>")
		dat += "</font>"
	else
		dat += "<center><i>No matching individual logs.</i></center>"

	var/datum/browser/popup = new(usr, "individual_logging_[REF(M)]", "Individual Logs", 700, 650)
	popup.set_content(dat.Join())
	popup.open()

/proc/individual_logging_panel_link(mob/M, log_type, log_src, label, selected_src, selected_type)
	var/slabel = label
	if(selected_type == log_type && selected_src == log_src)
		slabel = "<b>\[[label]\]</b>"

	// This is necessary because num2text drops digits and rounds on big numbers. If more defines get added in the future it could break again.
	log_type = num2text(log_type, MAX_BITFLAG_DIGITS)
	return "<a href='byond://?_src_=holder;individuallog=[REF(M)];log_type=[log_type];log_src=[log_src]'>[slabel]</a>"
