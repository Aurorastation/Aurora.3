/**
 * A component that will delete itself after a certain amount of time has passed.
 * This is useful for things like temporary buffs, or temporary objects that should be cleaned up after a while.
 *
 * As an abstract type, this component is not meant to be used directly. Instead, other components should extend this one and set the lifetime variable to the desired amount of time.
 * For example, a component that gives a temporary speed boost might set lifetime to 30 seconds.
 */
ABSTRACT_TYPE(/datum/component/timed_life)
	/**
	 * The amount of time, in seconds, that this component will last before it deletes itself.
	 * This is set during initialization, or by calling set_lifetime() on the component.
	 * This is a final variable because it should really only be set during initialization, and not by any external code. The component will handle updating this variable as needed.
	 */
	VAR_FINAL/lifetime = 0

	/**
	 * The target time in real life seconds that the component will delete itself.
	 * This is calculated as REALTIMEOFDAY + lifetime when the component is initialized, and can be refreshed by calling refresh() on it.
	 * This is a final variable because it should only be set by the component itself, and not by any external code. The component will handle updating this variable as needed.
	 */
	VAR_FINAL/time_to_die = 0

/datum/component/timed_life/Initialize(lifetime_seconds = 5 MINUTES)
	. = ..()
	if (!parent)
		return

	lifetime = lifetime_seconds
	time_to_die = REALTIMEOFDAY + lifetime
	START_PROCESSING(SSprocessing, src)

/datum/component/timed_life/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/timed_life/proc/refresh()
	time_to_die = REALTIMEOFDAY + lifetime

/datum/component/timed_life/proc/set_lifetime(new_lifetime)
	lifetime = new_lifetime
	refresh()

/datum/component/timed_life/process(seconds_per_tick)
	if (REALTIMEOFDAY >= time_to_die)
		qdel(src)
