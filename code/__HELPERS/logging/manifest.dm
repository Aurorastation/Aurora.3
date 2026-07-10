/// Logging for player manifest (ckey, name, job, special role, roundstart/latejoin)
/proc/log_manifest(ckey, datum/mind/mind, mob/body, latejoin = FALSE)
	logger?.Log(LOG_CATEGORY_MANIFEST, "[ckey] \\ [body.real_name] \\ [mind.assigned_role] \\ [mind.special_role ? mind.special_role : "NONE"] \\ [latejoin ? "LATEJOIN":"ROUNDSTART"]", list(
		"ckey" = ckey,
		"mind" = mind,
		"body" = body,
		"latejoin" = latejoin,
	))
