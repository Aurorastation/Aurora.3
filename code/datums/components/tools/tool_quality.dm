
/datum/component/tool_quality_container
	/**
	 * The set of all tool qualities stored on a datum. Associative list of tool type to tool level.
	 * Formatted like alist(TOOL_CROWBAR = 3, TOOL_CHISEL = 1).
	 * Access tool qualities directly with GET_TOOL_LEVEL(target, TOOL_CROWBAR)
	 * or fetch the entire associative list via GET_TOOL_QUALITIES(target)
	 */
	var/alist/tool_qualities = alist()
