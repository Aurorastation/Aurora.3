
/**
 * @brief Returns a list of "icon-x" and "icon-y" from mouse parameters, which
 * are safely clamped to 0-32 for icon operations.
 */
/proc/mouse_safe_xy(params, lim_x = 32, lim_y = 32)
	if (!params)
		return list("icon-x" = 0, "icon-y" = 0)

	. = params2list(params)

	return list("icon-x" = clamp(text2num(.["icon-x"]), 0, lim_x),
				"icon-y" = clamp(text2num(.["icon-y"]), 0, lim_y))
