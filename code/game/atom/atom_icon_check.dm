
#ifdef UNIT_TEST

// Global state caches and type filters
var/global/list/checked_atom_types = list()
var/global/list/cached_icon_states = list()

var/global/list/whitelisted_check_types = list(
	// /atom
	/turf/simulated,
	/obj/random,
	// /obj/item,
)

var/global/list/ignored_check_types = list(
	// e.g. /atom/movable/lighting_overlay
)

/// Icon check.
/// Validates that an atom's icon and icon_state match valid entries in the DMI.
/// Does nothing outside of tests.
/proc/validate_atom_icon(atom/target)
	dbg_assert(istype(target), "[target] is not a valid atom.")

	if (is_abstract(target))
		return FALSE

	var/atom_type = target.type

	// 0. Check if type was already validated
	if (checked_atom_types[atom_type])
		return TRUE
	checked_atom_types[atom_type] = TRUE

	// 1. Whitelist filter: must match at least one allowed root path
	var/whitelisted = FALSE
	for (var/allowed_path in whitelisted_check_types)
		if (istype(target, allowed_path))
			whitelisted = TRUE
			break
	if (!whitelisted)
		return FALSE

	// 2. Blacklist filter: skip if it matches any ignored path
	for (var/ignored_path in ignored_check_types)
		if (istype(target, ignored_path))
			return FALSE

	// 3. Icon validation
	// Kept as (icon && icon_state) per current scoping
	if (target.icon && target.icon_state)
		dbg_assert(target.icon, "[atom_type] has icon_state '[target.icon_state]' set, but no icon file.")
		dbg_assert(target.icon_state, "[atom_type] has an icon file set ('[target.icon]'), but no icon_state.")

		var/list/states = cached_icon_states[target.icon]
		if (!states)
			states = icon_states(target.icon)
			cached_icon_states[target.icon] = states

		dbg_assert(target.icon_state in states, "[atom_type] has invalid icon_state '[target.icon_state]' in icon '[target.icon]'.")

	return TRUE

#else

/// Icon check.
/// Validates that an atom's icon and icon_state match valid entries in the DMI.
/// Does nothing outside of tests.
#define validate_atom_icon(target)

#endif
