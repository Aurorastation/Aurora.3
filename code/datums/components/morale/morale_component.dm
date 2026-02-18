/**
 * Having a Morale Component allows a character to receive and benefit from Moodlets, providing a variety of buffs(or debuffs) depending on the total morale points.
 * This component acts as both proof a mob can be affected by morale, as well as a method of tracking the effects of morale on each system.
 */
/datum/component/morale

	/**
	 * The set of all moodlets associated with this Morale Component. These are also tightly controlled in their initialization, and thus are private.
	 * load_moodlet() is your best bet for "Add or Get" a moodlet, and is 100% of the time what you want to use if you're trying to make sure someone has a moodlet.
	 */
	VAR_PRIVATE/list/moodlet/moodlets = list()

	/**
	 * The current sum total of morale_points. This var is intentionally private because it is self-managed by the component, and should never be set directly.
	 * If you need the contents of this var outside of the component, you MUST use get_morale_points().
	 */
	VAR_PRIVATE/morale_points = 0.0 // Positive and negative floating points are allowed.

	/**
	 * The current "Morale Ratio" calculated in advance as the Hyperbolic Tangent of morale_points. This var is self-managed by the component and should never be set directly.
	 * This gets updated whenever morale_points are changed, and is used by the Morale Component to handle fast calculations of its various effects.
	 * If you need the contents of this var outside of the component, you MUST use get_morale_ratio().
	 *
	 * morale_ratio is NEVER to be set by anything outside of the component.
	 */
	VAR_PRIVATE/morale_ratio = 0.0 // Positive and negative floating points are allowed.

/datum/component/morale/proc/get_morale_ratio()
	return morale_ratio

/datum/component/morale/proc/get_morale_points()
	return morale_points

/datum/component/morale/proc/add_morale_points(input)
	morale_points += input
	morale_ratio = ftanh(morale_points)

/**
 * Your one-stop-shop for making moodlets. This proc returns the pre-existing moodlet of a given type.
 * If it doesn't already exist, then one will be created.
 */
/datum/component/morale/proc/load_moodlet(moodlet/moodlet_type, set_points)
	RETURN_TYPE(moodlet_type)
	var/loaded_moodlet = moodlets[moodlet_type]
	if (!loaded_moodlet)
		loaded_moodlet = new moodlet_type(src, set_points)
		moodlets.Add(loaded_moodlet)
		return loaded_moodlet

	if (set_points) loaded_moodlet.set_moodlet(set_points)
	return loaded_moodlet

/datum/component/morale/Initialize()
	. = ..()
	//Wall of RegisterSignal() goes here.

/datum/component/morale/Destroy()
	// Wall of UnregisterSignal() goes here.
	QDEL_NULL_LIST_FORCE(moodlets)
	return ..()

/datum/component/morale/process(seconds_per_tick)
	var/current_time = REALTIMEOFDAY
	var/list_trimmed = FALSE
	for (var/moodlet/moodlet as anything in moodlets)
		if (moodlet.time_to_die < current_time || QDELING(moodlet))
			continue

		morale_points -= moodlet.get_morale_modifier()
		qdel(moodlet, TRUE)
		moodlets.Remove(moodlet)
		list_trimmed = TRUE

	if (!list_trimmed)
		return

	morale_ratio = ftanh(morale_points)
