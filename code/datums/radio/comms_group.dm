/**
 * Used to store data about comms frequencies of away sites.
 * These are created by `/obj/effect/overmap/visitable/proc/create_comms_groups()`, don't make subtypes of this datum for the sake of simplicity.
 * For an example usecase, see: `/obj/effect/overmap/visitable/sector/nikal_sahira/create_comms_groups()`
 */
/datum/comms_group
	/// Gets applied to relevant comms devices' names.
	/// For example a shortwave radio will be "[comms_name] shortwave radio", intercom as "intercom ([comms_name])", etc.
	var/comms_name
	/// The name that players will see in chat. Will default to sector name if not set.
	var/freq_name

/datum/comms_group/New(comms_name = "shipboard", freq_name)
	. = ..()
	src.comms_name = comms_name
	src.freq_name = freq_name

