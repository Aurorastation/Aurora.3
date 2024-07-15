/**
 * The base type for nearly all physical objects in SS13

 * Lots and lots of functionality lives here, although in general we are striving to move
 * as much as possible to the components/elements system
 */

/atom

	/// pass_flags that we are. If any of this matches a pass_flag on a moving thing, by default, we let them through.
	var/pass_flags_self = NONE

	///First atom flags var
	var/flags_1 = NONE

	var/update_icon_on_init	= FALSE // Default to 'no'.

	layer = TURF_LAYER
	appearance_flags = DEFAULT_APPEARANCE_FLAGS

	var/level = 2
	var/atom_flags = 0
	var/init_flags = 0
	var/list/fingerprints
	var/list/fingerprintshidden
	var/fingerprintslast = null
	var/list/blood_DNA
	var/list/other_DNA
	var/other_DNA_type = null
	var/was_bloodied
	var/blood_color
	var/last_bumped = 0
	var/pass_flags = 0
	var/throwpass = 0
	var/germ_level = GERM_LEVEL_AMBIENT // The higher the germ level, the more germ on the atom.
	var/simulated = 1 // Filter for actions. Used by lighting overlays.
	var/fluorescent // Shows up under a UV light.

	/// Chemistry.
	var/datum/reagents/reagents = null
	var/list/reagents_to_add
	var/list/reagent_data

	var/gfi_layer_rotation = GFI_ROTATION_DEFAULT

	// Extra descriptions.
	var/desc_extended = null // Regular text about the atom's extended description, if any exists.
	var/desc_info = null // Blue text (SPAN_NOTICE()), informing the user about how to use the item or about game controls.
	var/desc_antag = null // Red text (SPAN_ALERT()), informing the user about how they can use an object to antagonize.

	/* SSicon_update VARS */

	///When was the last time (in `world.time`) that the icon of this atom was updated via `SSicon_update`
	var/tmp/last_icon_update = null

	///If the atom is currently queued to have it's icon updated in `SSicon_update`
	var/tmp/icon_update_queued = FALSE

	///Delay to apply before updating the icon in `SSicon_update`
	var/icon_update_delay = null

	/// How this atom should react to having its astar blocking checked
	var/can_astar_pass = CANASTARPASS_DENSITY

	/// This atom's cache of non-protected overlays, used for normal icon additions. Do not manipulate directly- See SSoverlays.
	var/list/atom_overlay_cache

	/// This atom's cache of overlays that can only be removed explicitly, like C4. Do not manipulate directly- See SSoverlays.
	var/list/atom_protected_overlay_cache

/atom/Destroy(force)
	if(opacity)
		updateVisibility(src)

	if(reagents)
		QDEL_NULL(reagents)

	// Checking length(overlays) before cutting has significant speed benefits
	if(length(overlays))
		overlays.Cut()

	if(light)
		QDEL_NULL(light)

	if(length(light_sources))
		light_sources.Cut()

	if(smoothing_flags & SMOOTH_QUEUED)
		SSicon_smooth.remove_from_queues(src)

	//We're being destroyed, no need to update the icon
	if(icon_update_queued)
		SSicon_update.remove_from_queue(src)

	if(length(atom_overlay_cache))
		LAZYCLEARLIST(atom_overlay_cache)

	if(length(atom_protected_overlay_cache))
		LAZYCLEARLIST(atom_protected_overlay_cache)

	if(orbiters)
		for(var/thing in orbiters)
			var/datum/orbit/O = thing
			if(O.orbiter)
				O.orbiter.stop_orbit()
	orbiters = null

	. = ..()


///Purpose: Determines if the object (or airflow) can pass this atom.
///Called by: Movement, airflow.
///Inputs: The moving atom (optional), target turf, "height" and air group
///Outputs: Boolean if can pass.
///**Please stop using this proc, use the `pass_flags_self` flags to determine what can pass unless you literally have no other choice**
/atom/proc/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	//I have condensed TG's `CanAllowThrough()` into this proc
	if(mover) //Because some procs send null as a mover
		if(mover.pass_flags & pass_flags_self)
			return TRUE
		if(mover.throwing && (pass_flags_self & LETPASSTHROW))
			return TRUE

	return (!density || !height || air_group)

/**
 * An atom we are buckled or is contained within us has tried to move
 */
/atom/proc/relaymove(mob/living/user, direction)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	if(SEND_SIGNAL(src, COMSIG_ATOM_RELAYMOVE, user, direction) & COMSIG_BLOCK_RELAYMOVE)
		return
	return


/**
 * An atom has entered this atom's contents
 *
 * Default behaviour is to send the [COMSIG_ATOM_ENTERED]
 *
 * Aurora note: old_locs is not populated currently, and will always be null
 */
/atom/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SEND_SIGNAL(src, COMSIG_ATOM_ENTERED, arrived, old_loc, old_locs)
	SEND_SIGNAL(arrived, COMSIG_ATOM_ENTERING, src, old_loc, old_locs)

	//Observables event, Aurora snowflake code
	GLOB.entered_event.raise_event(src, arrived, old_loc)
	GLOB.moved_event.raise_event(arrived, old_loc, arrived.loc)

/**
 * An atom is attempting to exit this atom's contents
 *
 * Default behaviour is to send the [COMSIG_ATOM_EXIT]
 */
/atom/Exit(atom/movable/leaving, direction)
	// Don't call `..()` here, otherwise `Uncross()` gets called.
	// See the doc comment on `Uncross()` to learn why this is bad.

	if(SEND_SIGNAL(src, COMSIG_ATOM_EXIT, leaving, direction) & COMPONENT_ATOM_BLOCK_EXIT)
		return FALSE

	//Observables event, Aurora snowflake code
	GLOB.exited_event.raise_event(src, leaving, get_step_towards(src, direction))

	return TRUE

/**
 * An atom has exited this atom's contents
 *
 * Default behaviour is to send the [COMSIG_ATOM_EXITED]
 */
/atom/Exited(atom/movable/gone, direction)
	SEND_SIGNAL(src, COMSIG_ATOM_EXITED, gone, direction)

/**
 * Returns true if this atom has gravity for the passed in turf
 *
 * Sends signals [COMSIG_ATOM_HAS_GRAVITY] and [COMSIG_TURF_HAS_GRAVITY], both can force gravity with
 * the forced gravity var.
 *
 * micro-optimized to hell because this proc is very hot, being called several times per movement every movement.
 *
 * This is slightly different from TG's version due to Aurora reasons.
 */
/atom/proc/has_gravity(turf/gravity_turf)
	if(!isturf(gravity_turf))
		gravity_turf = get_turf(src)

		if(!gravity_turf)//no gravity in nullspace
			return FALSE

	var/list/forced_gravity = list()
	SEND_SIGNAL(src, COMSIG_ATOM_HAS_GRAVITY, gravity_turf, forced_gravity)
	SEND_SIGNAL(gravity_turf, COMSIG_TURF_HAS_GRAVITY, src, forced_gravity)
	if(length(forced_gravity))
		var/positive_grav = max(forced_gravity)
		var/negative_grav = min(min(forced_gravity), 0) //negative grav needs to be below or equal to 0

		//our gravity is sum of the most massive positive and negative numbers returned by the signal
		//so that adding two forced_gravity elements with an effect size of 1 each doesnt add to 2 gravity
		//but negative force gravity effects can cancel out positive ones

		return (positive_grav + negative_grav)

	var/area/turf_area = gravity_turf.loc

	return turf_area.has_gravity()

/**
 * This proc is used for telling whether something can pass by this atom in a given direction, for use by the pathfinding system.
 *
 * Trying to generate one long path across the station will call this proc on every single object on every single tile that we're seeing if we can move through, likely
 * multiple times per tile since we're likely checking if we can access said tile from multiple directions, so keep these as lightweight as possible.
 *
 * For turfs this will only be used if pathing_pass_method is TURF_PATHING_PASS_PROC
 *
 * Arguments:
 * * to_dir - What direction we're trying to move in, relevant for things like directional windows that only block movement in certain directions
 * * pass_info - Datum that stores info about the thing that's trying to pass us
 *
 * IMPORTANT NOTE: /turf/proc/LinkBlockedWithAccess assumes that overrides of CanAStarPass will always return true if density is FALSE
 * If this is NOT you, ensure you edit your can_astar_pass variable. Check __DEFINES/path.dm
 **/
/atom/proc/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(pass_info.pass_flags & pass_flags_self)
		return TRUE
	. = !density
