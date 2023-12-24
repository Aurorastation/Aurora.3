/// Logging for tool usage
/proc/log_tool(text, mob/initiator)
	if(GLOB.config.logsettings["log_tools"])
		WRITE_LOG(config.logfiles["world_tool_log"], "TOOL: [text]")
