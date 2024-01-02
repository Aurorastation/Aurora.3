/// Logging for traitor objectives
/proc/log_traitor(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("TRAITOR: [text]")
#else
	if (GLOB.config.logsettings["log_traitor"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "TRAITOR: [text]")
#endif

/// Logging for items purchased from a traitor uplink
/proc/log_uplink(text)
	if (GLOB.config.logsettings["log_uplink"])
		WRITE_LOG(GLOB.config.logfiles["world_uplink_log"], "UPLINK: [text]")

/// Logging for upgrades purchased by a malfunctioning (or combat upgraded) AI
/proc/log_malf_upgrades(text)
	if (GLOB.config.logsettings["log_uplink"])
		WRITE_LOG(GLOB.config.logfiles["world_uplink_log"], "MALF UPGRADE: [text]")

/// Logging for changeling powers purchased
/proc/log_changeling_power(text)
	if (GLOB.config.logsettings["log_uplink"])
		WRITE_LOG(GLOB.config.logfiles["world_uplink_log"], "CHANGELING: [text]")

/// Logging for heretic powers learned
/proc/log_heretic_knowledge(text)
	if (GLOB.config.logsettings["log_uplink"])
		WRITE_LOG(GLOB.config.logfiles["world_uplink_log"], "HERETIC RESEARCH: [text]")

/// Logging for wizard powers learned
/proc/log_spellbook(text)
	if (GLOB.config.logsettings["log_uplink"])
		WRITE_LOG(GLOB.config.logfiles["world_uplink_log"], "SPELLBOOK: [text]")
