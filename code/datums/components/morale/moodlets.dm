/**
 * Container for a single moodlet to be associated with a Morale Component.
 * Only one of each type of moodlet is allowed to exist in a mood component at a time.
 * If you're making a new source of moodlets, add a new child of this type.
 */
ABSTRACT_TYPE(/moodlet)
	/**
	 * How much this moodlet modifies its owner's morale by.
	 * This is simple summed exactly once when the moodlet is created.
	 * If anything needs to Set the value of a moodlet, they have to do so by calling set_moodlet().
	 * You may only Get this value by calling get_morale_modifier().
	 *
	 * This is similar to { get; private set; }. Under no circumstances are outside functions ever allowed to directly change this var because other vars depend on it.
	 * But there are public procs available to interact with it which obey its own internal rules.
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
