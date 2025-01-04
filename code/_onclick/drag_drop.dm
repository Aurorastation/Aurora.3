/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	receiving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/
/atom/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!usr || !over)
		return

	var/proximity_check = usr.client.check_drag_proximity(src, over, src_location, over_location, src_control, over_control, params)
	if(proximity_check)
		return proximity_check

	base_mouse_drop_handler(over, src_location, over_location, params)

/**
 * Called when all sanity checks for mouse dropping have passed. Handles adjacency & other sanity checks before delegating the event
 * down to lower level handlers. Do not override unless you are trying to create hud & screen elements which do not require proximity
 * or other checks
 */
/atom/proc/base_mouse_drop_handler(atom/over, src_location, over_location, params)
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/mob/user = usr

	if(SEND_SIGNAL(src, COMSIG_MOUSEDROP_ONTO, over, user) & COMPONENT_CANCEL_MOUSEDROP_ONTO)
		return

	if(SEND_SIGNAL(over, COMSIG_MOUSEDROPPED_ONTO, src, user, params) & COMPONENT_CANCEL_MOUSEDROPPED_ONTO)
		return

	// only if both dragged object & receiver agree to do checks do we proceed
	var/combined_atom_flags = interaction_flags_atom | over.interaction_flags_atom
	if(!(combined_atom_flags & INTERACT_ATOM_MOUSEDROP_IGNORE_CHECKS))
		//Check for adjacency
		// In TG it's `if(!(combined_atom_flags & INTERACT_ATOM_MOUSEDROP_IGNORE_ADJACENT) && (!CanReach(user) || !over.CanReach(user)))` but i'm not recreating those procs now
		if(!(combined_atom_flags & INTERACT_ATOM_MOUSEDROP_IGNORE_ADJACENT) && (!Adjacent(user) || !over.Adjacent(user)))
			return // should stop you from dragging through windows

		// NOT IMPLEMENTED IN AURORA
		// if(!(combined_atom_flags & INTERACT_ATOM_MOUSEDROP_IGNORE_USABILITY))
		// 	//Bypass adjacency cause we already checked for it above
		// 	if(!user.can_perform_action(src, interaction_flags_mouse_drop | over.interaction_flags_mouse_drop | BYPASS_ADJACENCY))
		// 		return // is the mob not able to drag the object with both sides conditions applied

	mouse_drop_dragged(over, user, src_location, over_location, params)

	over.mouse_drop_receive(src, user, params)

/// The proc that should be overridden by subtypes to handle mouse drop. Called on the atom being dragged
/atom/proc/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	PROTECTED_PROC(TRUE)

	return

/// The proc that should be overridden by subtypes to handle mouse drop. Called on the atom receiving a dragged object
/atom/proc/mouse_drop_receive(atom/dropped, mob/user, params)
	PROTECTED_PROC(TRUE)

	return

/// Handles treating drags as clicks if they're within some conditions
/// Does some other stuff adjacent to trying to figure out what the user actually "wanted" to click
/// Returns TRUE if it caused a click, FALSE otherwise
/client/proc/check_drag_proximity(atom/dragging, atom/over, src_location, over_location, src_control, over_control, params)
	// We will swap which thing we're trying to check for clickability based off the type
	// Assertion is if you drag a turf to anything else, you really just wanted to click the anything else
	// And slightly misseed. I'm not interested in making this game pixel percise, so if it fits our other requirements
	// Lets just let that through yeah?
	var/atom/attempt_click = dragging
	var/atom/click_from = over
	var/location_to_use = src_location
	var/control_to_use = src_control
	if(isturf(attempt_click) && !isturf(over))
		// swapppp
		attempt_click = over
		click_from = dragging
		location_to_use = over_location
		control_to_use = over_control

	if(is_drag_clickable(attempt_click, click_from, params))
		Click(attempt_click, location_to_use, control_to_use, params)
		return TRUE
	return FALSE

/// Distance in pixels that we consider "acceptable" from the initial click to the release
/// Note: this does not account for the position of the object, just where it is on the screen
#define LENIENCY_DISTANCE 16
/// Accepted time in seconds between the initial click and drag release
/// Go higher then this and we just don't care anymore
#define LENIENCY_TIME (0.1 SECONDS)

/// Does the logic for checking if a drag counts as a click or not
/// Returns true if it does, false otherwise
/client/proc/is_drag_clickable(atom/dragging, atom/over, params)
	if(dragging == over)
		return TRUE
	if(world.time - drag_start > LENIENCY_TIME) // Time's up bestie
		return FALSE
	if(!get_turf(dragging)) // If it isn't in the world, drop it. This is for things that can move, and we assume hud elements will not have this problem
		return FALSE
	// Basically, are you trying to buckle someone down, or drag them onto you?
	// If so, we know you must be right about what you want
	if(ismovable(over))
		var/atom/movable/over_movable = over
		// The buckle bit will cover most mobs, for stupid reasons. still useful here tho
		if(over_movable.can_be_buckled || over_movable == eye)
			return FALSE

	var/list/modifiers = params2list(params)
	var/list/old_offsets = screen_loc_to_offset(LAZYACCESS(drag_details, SCREEN_LOC), view)
	var/list/new_offsets = screen_loc_to_offset(LAZYACCESS(modifiers, SCREEN_LOC), view)

	var/distance = sqrt(((old_offsets[1] - new_offsets[1]) ** 2) + ((old_offsets[2] - new_offsets[2]) ** 2))
	if(distance > LENIENCY_DISTANCE)
		return FALSE

	return TRUE


/*
	MOUSE UP AND MOUSE DOWN AREN'T HERE BUT IN code\modules\client\client_procs.dm
*/
