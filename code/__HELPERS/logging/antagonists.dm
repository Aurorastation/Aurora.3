/// Logging for traitor objectives
/proc/log_traitor(text, list/data)
	logger?.Log(LOG_CATEGORY_GAME_TRAITOR, "TRAITOR: [text]", data)

/// Logging for items purchased from a traitor uplink
/proc/log_uplink(text, list/data)
	logger?.Log(LOG_CATEGORY_UPLINK, "UPLINK: [text]", data)

/// Logging for upgrades purchased by a malfunctioning (or combat upgraded) AI
/proc/log_malf_upgrades(text, list/data)
	logger?.Log(LOG_CATEGORY_UPLINK_MALF, "MALF UPGRADE: [text]", data)

/// Logging for changeling powers purchased
/proc/log_changeling_power(text, list/data)
	logger?.Log(LOG_CATEGORY_UPLINK_CHANGELING, "CHANGELING: [text]", data)

/// Logging for heretic powers learned
/proc/log_heretic_knowledge(text, list/data)
	logger?.Log(LOG_CATEGORY_UPLINK_HERETIC, "HERETIC RESEARCH: [text]", data)

/// Logging for wizard powers learned
/proc/log_spellbook(text, list/data)
	logger?.Log(LOG_CATEGORY_UPLINK_SPELL, "SPELLBOOK: [text]", data)
