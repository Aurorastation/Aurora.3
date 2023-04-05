/// Logging for tool usage
/proc/log_tool(text, mob/initiator)
	if(config.logsettings["log_tools"])
		WRITE_LOG(config.world_tool_log, "TOOL: [text]")
