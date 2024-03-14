/// Logging for player manifest (ckey, name, job, special role, roundstart/latejoin)
/proc/log_manifest(ckey, datum/mind/mind, mob/body, latejoin = FALSE)
	if (GLOB.config.logsettings["log_manifest"])
		WRITE_LOG(GLOB.config.logfiles["world_manifest_log"], "[ckey] \\ [body.real_name] \\ [mind.assigned_role] \\ [mind.special_role ? mind.special_role : "NONE"] \\ [latejoin ? "LATEJOIN":"ROUNDSTART"]")
