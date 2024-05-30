/datum/proc/can_vv_get(var_name)
	return TRUE

/// Called when a var is edited with the new value to change to
/datum/proc/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, vars))
		return FALSE
	if(!can_vv_get(var_name)) //This if block does not exist in tgstation code
		return FALSE
	vars[var_name] = var_value
	datum_flags |= DF_VAR_EDITED
	return TRUE

/**
 * Gets all the dropdown options in the vv menu.
 * When overriding, make sure to call . = ..() first and appent to the result, that way parent items are always at the top and child items are further down.
 * Add seperators by doing VV_DROPDOWN_OPTION("", "---")
 */
/datum/proc/vv_get_dropdown()
	SHOULD_CALL_PARENT(TRUE)

	. = list()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_HK_CALLPROC, "Call Proc")
	VV_DROPDOWN_OPTION(VV_HK_MARK, "Mark Object")

/datum/proc/vv_get_header()
	. = list()
	if(("name" in vars) && !isatom(src))
		. += "<b>[vars["name"]]</b><br>"
