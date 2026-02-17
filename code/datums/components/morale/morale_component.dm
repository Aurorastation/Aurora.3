/**
 * Having a Morale Component allows a character to receive and benefit from Moodlets, providing a variety of buffs(or debuffs) depending on the total morale points.
 * This component acts as both proof a mob can be affected by morale, as well as a method of tracking the effects of morale on each system.
 */
/datum/component/morale

	/**
	 * The set of all moodlets associated with this Morale Component.
	 */
	var/list/moodlet/moodlets = list()

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

/datum/component/morale/proc/load_moodlet(moodlet/moodlet_type)
	RETURN_TYPE(moodlet_type)
	if (moodlets[moodlet_type])
		return moodlets[moodlet_type]

	var/new_moodlet = new moodlet_type(src)
	moodlets.Add(new_moodlet)
	return new_moodlet

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
		if (moodlet.time_to_die < current_time)
			continue

		morale_points -= moodlet.get_morale_modifier()
		qdel(moodlet, TRUE)
		moodlets.Remove(moodlet)
		list_trimmed = TRUE

	if (!list_trimmed)
		return

	morale_ratio = ftanh(morale_points)
