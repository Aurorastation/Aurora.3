
#ifdef UNIT_TEST

/// Validates that the icon file and icon_state match a valid entry in the DMI.
/// `context` is an optional description (e.g. an atom type) prepended to failure messages.
/// Does nothing outside of tests.
/proc/validate_icon(icon, icon_state, context)

	// Cached icon states for each icon file
	// So we don't have to re-read the DMI every time
	var/static/list/cached_icon_states = list()

	if (!icon && !icon_state)
		return

	var/prefix = context ? "[context]" : "Icon check"
	dbg_assert(icon, "[prefix]: icon_state '[icon_state]' set, but no icon file.")
	dbg_assert(icon_state, "[prefix]: icon file set ('[icon]'), but no icon_state.")

	var/list/states = cached_icon_states[icon]
	if (!states)
		states = icon_states(icon)
		cached_icon_states[icon] = states

	dbg_assert(icon_state in states, "[prefix]: invalid icon_state '[icon_state]' in icon '[icon]'.")

/// Icon check.
/// Validates that an atom's icon and icon_state match valid entries in the DMI.
/// Both the current values and the initial (map editor) values are checked.
/// Does nothing outside of tests.
/proc/validate_atom_icon(atom/target)

	// Atom types already checked
	// var/static/list/checked_atom_types = list()

	// Only these types (and their subtypes) are checked
	var/static/list/whitelisted_check_types = list(
		// Ideally this would just be `/atom`, but it would require fixing a million icons in a single PR
		// Ideally anyone adding new stuff or fixing old stuff should add paths here so they are checked in the future
	)

	// These types (and their subtypes) are ignored
	var/static/list/ignored_check_types = list(
	)

	// 0. Proc begins here proper
	dbg_assert(istype(target), "[target] is not a valid atom.")

	if (is_abstract(target))
		return FALSE

	var/atom_type = target.type

	// 1. Check if type was already validated
	// if (checked_atom_types[atom_type])
	// 	return TRUE
	// checked_atom_types[atom_type] = TRUE

	// 2. Whitelist filter: must match at least one allowed root path
	var/whitelisted = FALSE
	for (var/allowed_path in whitelisted_check_types)
		if (istype(target, allowed_path))
			whitelisted = TRUE
			break
	if (!whitelisted)
		return FALSE

	// 3. Blacklist filter: skip if it matches any ignored path
	for (var/ignored_path in ignored_check_types)
		if (istype(target, ignored_path))
			return FALSE

	// 4. Icon validation, for the current values
	validate_icon(target.icon, target.icon_state, "[atom_type]")

	// 5. Icon validation, for the initial values (as shown in the map editor)
	if (initial(target.icon) != target.icon || initial(target.icon_state) != target.icon_state)
		validate_icon(initial(target.icon), initial(target.icon_state), "[atom_type] (initial values)")

	return TRUE

#else

/// Validates that the icon file and icon_state match a valid entry in the DMI.
/// `context` is an optional description (e.g. an atom type) prepended to failure messages.
/// Does nothing outside of tests.
#define validate_icon(icon, icon_state, context)

/// Icon check.
/// Validates that an atom's icon and icon_state match valid entries in the DMI.
/// Does nothing outside of tests.
#define validate_atom_icon(target)

#endif
