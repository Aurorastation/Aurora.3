/// Logging for tool usage
/proc/log_tool(text, mob/initiator)
	logger?.Log(LOG_CATEGORY_TOOL, "TOOL: [text]", list("initiator" = initiator))
