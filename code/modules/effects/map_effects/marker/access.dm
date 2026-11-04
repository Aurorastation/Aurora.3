/// Access marker that, when placed above objects, adds its access requirements to them.
/// Adds, not replaces. So multiple access markers can be placed on the same object.
///
/// Intended use is to define a subtype in code, for example:
/// ```
/// /obj/effect/map_effect/marker/access/security
/// 	req_one_access = list(/datum/access/security::id)
/// ```
/// and then map that over doors, lockers, buttons, etc, instead of var-editing raw numeric access onto them.
///
/// Only objects that are of a type in `types_whitelist` will be modified.
/// This is the abstract type; define subtypes with the access set.
ABSTRACT_TYPE(/obj/effect/map_effect/marker/access)
	name = "access marker"
	desc = "See comments/documentation in code."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "door_helper_access_req"

	/// Access requirements added to objects under this marker. All of these are required.
	/// Rarely used, prefer `req_one_access`.
	req_access = null

	/// Access requirements added to objects under this marker. Any one of these is required.
	req_one_access = null

	/// If true, all existing access requirements are removed from the objects before adding this marker's own.
	/// Since markers run in no particular order, do not stack a clearing marker with other access markers.
	var/clear_access = FALSE

	/// Types (and their subtypes) this marker is allowed to add access requirements to.
	/// Anything else is left untouched.
	var/list/types_whitelist = list(
		/obj/structure/machinery/door/airlock,
		/obj/structure/machinery/door/window,
		/obj/structure/machinery/button,
		/obj/structure/machinery/computer,
		/obj/structure/machinery/vending,
		/obj/structure/machinery/alarm,
		/obj/structure/machinery/power/apc,
		/obj/structure/machinery/turretid,
		/obj/structure/closet/secure_closet,
		/obj/structure/closet/crate/secure,
	)

/obj/effect/map_effect/marker/access/Initialize(mapload, ...)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/access/LateInitialize()
	if(!isnull(req_access) && !islist(req_access))
		req_access = list(req_access)
	if(!isnull(req_one_access) && !islist(req_one_access))
		req_one_access = list(req_one_access)
	if(!isnull(types_whitelist) && !islist(types_whitelist))
		types_whitelist = list(types_whitelist)

	dbg_assert(clear_access || length(req_access) || length(req_one_access),
		"Access marker [type] at [x] [y] [z] has no access requirements set.")
	dbg_assert(length(types_whitelist),
		"Access marker [type] at [x] [y] [z] has an empty types whitelist.")

	for(var/obj/thing in loc)
		if(!is_type_in_list(thing, types_whitelist))
			continue
		if(clear_access)
			thing.req_access = null
			thing.req_one_access = null
		// `|` makes new lists, so the marker's lists are never shared with or mutated through the object
		if(length(req_access))
			thing.req_access = (thing.req_access || list()) | req_access
		if(length(req_one_access))
			thing.req_one_access = (thing.req_one_access || list()) | req_one_access

	qdel(src)

// ----------------------------------- common subtypes

/// Removes all access requirements from the objects under it, making them usable by anyone.
/obj/effect/map_effect/marker/access/none
	name = "access marker (no access)"
	clear_access = TRUE
