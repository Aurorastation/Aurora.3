/**
 * Container for a single moodlet to be associated with a Morale Component.
 * Only one of each type of moodlet is allowed to exist in a mood component at a time.
 * If you're making a new source of moodlets, add a new child of this type.
 */
ABSTRACT_TYPE(/moodlet)
	/**
	 * How much this moodlet modifies its owner's morale by.
	 * This is simple summed exactly once when the moodlet is created.
	 * If anything needs to change the value of a moodlet, they have to do so by calling set_moodlet().
	 * You may only Get this value by calling get_morale_modifier().
	 */
	VAR_PRIVATE/morale_modifier = 0.0 // Positive and negative floating points are allowed.

	/**
	 *
	 */
	var/moodlet_descriptor = "It's a moodlet!"

	/**
	 * How long this moodlet will last if not refreshed. For Aurora's purposes, moodlets are targeted as having "Small effect, extreme duration".
	 * This is by design to encourage players to "Visit the chef at least once a round to do a little RP", while avoiding having moodlet collection interrupt the flow of expeditions.
	 */
	var/duration = 2.0 HOURS

	/**
	 * The target time (in real life seconds) that the moodlet will self-terminate on.
	 * This is set automatically during the New() creation of moodlets.
	 * This can be updated by calling refresh_moodlet() to reset the time to die.
	 */
	var/time_to_die = 0.0

	/**
	 * Moodlets should always have an associated morale component, but the component owns the moodlets, not the other way around.
	 * For the convenience of refreshing individual moodlets, they hold a weakref to their owner.
	 * This is set to private here so that we can assert that it will always be a morale component.
	 */
	VAR_PRIVATE/datum/weakref/morale_component

/moodlet/New(datum/component/morale/_morale_component)
	time_to_die = duration + REALTIMEOFDAY
	morale_component = WEAKREF(_morale_component)
	_morale_component.add_morale_points(morale_modifier)

/moodlet/Destroy(force)
	if (force)
		// This will be forced when a Morale Component is deleted directly, as it QDEL_NULL_LIST's its own moodlets.
		return ..()

	// Else if the moodlet is deleted directly rather than its parent.
	var/datum/component/morale/parent = morale_component.resolve()
	if (!parent || !parent.moodlets[src])
		return ..()

	// Clean the effects of this moodlet from the parent.
	parent.moodlets -= src
	parent.add_morale_points(-morale_modifier)
	return ..()

/moodlet/proc/get_morale_modifier()
	return morale_modifier

/moodlet/proc/set_moodlet(new_modifier)
	// We can skip the istype() in this case since the held weakref is asserted by VAR_PRIVATE to always be a morale component.
	var/datum/component/morale/possible_morale = morale_component.resolve()
	if (!possible_morale)
		// Owner didn't exist, the moodlet has no need to exist either.
		qdel(src)
		return

	// Add the difference between the new modifier and the old morale points.
	// This should come out to no change if old and new are the same.
	possible_morale.add_morale_points(new_modifier - morale_modifier)

	// Then set the current morale points to the new ones.
	morale_modifier = new_modifier

/moodlet/proc/refresh_moodlet()
	time_to_die = REALTIMEOFDAY + duration

/**
 * Having a Morale Component allows a character to receive and benefit from Moodlets, providing a variety of buffs(or debuffs) depending on the total morale points.
 * This component acts as both proof a mob can be affected by morale, as well as a method of tracking the effects of morale on each system.
 */
#define MORALE_COMPONENT /datum/component/morale
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
