/// Access marker that, when placed above objects, adds its access requirements to them.
/// Adds, not replaces. So multiple access markers can be placed on the same object.
///
/// Intended use is to define a subtype in code, for example:
/// ```
/// /obj/effect/map_effect/marker/access/security
/// 	req_one_access = list(/datum/access/security::id)
/// ```
/// And then map that over doors, lockers, buttons, etc, instead of var-editing raw numeric access onto them.
///
/// Only objects that are of a type in `types_whitelist` will be modified.
/// This is the abstract type; define subtypes with the actual access set.
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
		// doors
		/obj/structure/machinery/door/airlock,
		/obj/structure/machinery/door/window,
		/obj/structure/machinery/door/firedoor,
		/obj/structure/machinery/door/urban,

		// buttons, controllers, panels
		/obj/structure/machinery/button,
		/obj/structure/machinery/access_button,
		/obj/structure/machinery/embedded_controller,
		/obj/structure/machinery/turretid,
		/obj/structure/machinery/ringer,
		/obj/structure/machinery/alarm,
		/obj/structure/machinery/power/apc,

		// computers and vendors
		/obj/structure/machinery/computer,
		/obj/structure/machinery/vending,
		/obj/structure/machinery/smartfridge/secure,
		/obj/structure/machinery/seed_storage,
		/obj/structure/machinery/chemical_dispenser,

		// lockers, crates, racks
		/obj/structure/closet/secure_closet,
		/obj/structure/closet/crate/secure,
		/obj/structure/closet/walllocker,
		/obj/structure/weapons_rack,
		/obj/item/storage/secure,

		// lockable machinery
		/obj/structure/machinery/porta_turret,
		/obj/structure/machinery/suit_cycler,
		/obj/structure/machinery/power/emitter,
		/obj/structure/machinery/shieldgen,
		/obj/structure/machinery/stasis_cage,

		// spawners and markers that pass their access on to what they spawn
		// note that init order between spawners and the access marker is not guaranteed
		// but it should not matter in practice
		// if marker runs first, spawner gets the access added, and adds it to what it spawns
		// if spawner runs first, then marker adds access to whatever was spawned
		/obj/effect/map_effect/window_spawner,
		/obj/effect/map_effect/marker/airlock,

		// misc
		/obj/structure/machinery/r_n_d/fabricator/mecha_part_fabricator,
		/obj/structure/machinery/photocopier/faxmachine,
		/obj/structure/sign/double/barsign,
		/obj/item/quikpay,
		/obj/item/holomenu,
		/obj/item/rig,
	)

	/// Types (and their subtypes) this marker never touches, even if they match `types_whitelist`.
	/// For exceptions to a whitelisted parent type.
	var/list/types_blacklist = list(
		// intentionally has no access requirements, so anyone can manually open it during a lockdown
		/obj/structure/machinery/door/firedoor/noid,
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
	if(!isnull(types_blacklist) && !islist(types_blacklist))
		types_blacklist = list(types_blacklist)

	dbg_assert(clear_access || length(req_access) || length(req_one_access),
		"Access marker [type] at [x] [y] [z] has no access requirements set.")
	dbg_assert(length(types_whitelist),
		"Access marker [type] at [x] [y] [z] has an empty types whitelist.")

	for(var/obj/thing in loc)
		if(!is_type_in_list(thing, types_whitelist))
			continue
		if(is_type_in_list(thing, types_blacklist))
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
	icon_state = "door_helper_access_req_none"
	clear_access = TRUE
