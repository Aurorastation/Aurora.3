/**
 * The base type for nearly all physical objects in SS13

 * Lots and lots of functionality lives here, although in general we are striving to move
 * as much as possible to the components/elements system
 */

/atom
	///First atom flags var
	var/flags_1 = NONE

	var/update_icon_on_init	= FALSE // Default to 'no'.

	layer = 2
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

	if(length(our_overlays))
		LAZYCLEARLIST(our_overlays)

	if(length(priority_overlays))
		LAZYCLEARLIST(priority_overlays)

	if(orbiters)
		for(var/thing in orbiters)
			var/datum/orbit/O = thing
			if(O.orbiter)
				O.orbiter.stop_orbit()
	orbiters = null

	. = ..()

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
