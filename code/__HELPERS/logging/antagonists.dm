/// Logging for traitor objectives
/proc/log_traitor(text, list/data)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("TRAITOR: [text]")
#else
	if (GLOB.config.logsettings["log_traitor"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "TRAITOR: [text]")
#endif
	logger?.Log(LOG_CATEGORY_GAME_TRAITOR, "TRAITOR: [text]", data)

/// Logging for items purchased from a traitor uplink
/proc/log_uplink(text, list/data)
	if (GLOB.config.logsettings["log_uplink"])
		WRITE_LOG(GLOB.config.logfiles["world_uplink_log"], "UPLINK: [text]")
	logger?.Log(LOG_CATEGORY_UPLINK, "UPLINK: [text]", data)

/// Logging for upgrades purchased by a malfunctioning (or combat upgraded) AI
/proc/log_malf_upgrades(text, list/data)
	if (GLOB.config.logsettings["log_uplink"])
		WRITE_LOG(GLOB.config.logfiles["world_uplink_log"], "MALF UPGRADE: [text]")
	logger?.Log(LOG_CATEGORY_UPLINK, "MALF UPGRADE: [text]", data)

/// Logging for changeling powers purchased
/proc/log_changeling_power(text, list/data)
	if (GLOB.config.logsettings["log_uplink"])
		WRITE_LOG(GLOB.config.logfiles["world_uplink_log"], "CHANGELING: [text]")
	logger?.Log(LOG_CATEGORY_UPLINK_CHANGELING, "CHANGELING: [text]", data)

/// Logging for wizard powers learned
/proc/log_spellbook(text, list/data)
	if (GLOB.config.logsettings["log_uplink"])
		WRITE_LOG(GLOB.config.logfiles["world_uplink_log"], "SPELLBOOK: [text]")
	logger?.Log(LOG_CATEGORY_UPLINK_SPELL, "SPELLBOOK: [text]", data)
