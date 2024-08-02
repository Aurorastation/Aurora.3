#define THREAT_LEVEL_NIGHTLIGHT_TEMPORARY_DISABLE_TRESHOLD 3

SUBSYSTEM_DEF(security_level)
	name = "Security Level"
	can_fire = FALSE // We will control when we fire in this subsystem
	init_order = INIT_ORDER_SECURITY_LEVEL
	/// Currently set security level
	var/datum/security_level/current_security_level
	/// A list of initialised security level datums.
	var/list/available_levels = list()

/datum/controller/subsystem/security_level/Initialize()
	var/lowest_threat_level_numerical = -INFINITY

	for(var/iterating_security_level_type in subtypesof(/datum/security_level))
		if(is_abstract(iterating_security_level_type))
			continue

		var/datum/security_level/new_security_level = new iterating_security_level_type
		available_levels[new_security_level.name] = new_security_level

		//If it's the lowest threat level (numerically, the highest number), set it as the current security level
		if(new_security_level.threat_level_numerical > lowest_threat_level_numerical)
			current_security_level = new_security_level

	return SS_INIT_SUCCESS

/**
 * Sets a new security level as our current level
 *
 * This is how everything should change the security level.
 *
 * Arguments:
 * * new_level - The new security level that will become our current level - can also be a name, number or path
 * * announce - Play the announcement, set FALSE if you're doing your own custom announcement to prevent duplicates
 */
/datum/controller/subsystem/security_level/proc/set_level(datum/security_level/new_level, announce = TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!istype(new_level))

		if(istext(new_level))
			new_level = available_levels[new_level]

		else if(isnum(new_level))
			new_level = available_levels[number_level_to_text(new_level)]

	if(ispath(new_level))
		new_level = new new_level()

	//If you fucked up this badly, runtime
	if(!istype(new_level))
		CRASH("Invalid security level trying to be set: [new_level]")

	//Don't do anything if the level is the same
	if(new_level == current_security_level)
		return

	//If the new level is above THREAT_LEVEL_NIGHTLIGHT_TEMPORARY_DISABLE_TRESHOLD, disable night lights
	if(new_level.threat_level_numerical >= THREAT_LEVEL_NIGHTLIGHT_TEMPORARY_DISABLE_TRESHOLD && current_security_level.threat_level_numerical < THREAT_LEVEL_NIGHTLIGHT_TEMPORARY_DISABLE_TRESHOLD)
		SSnightlight.temp_disable()
	else
		SSnightlight.end_temp_disable()

	//Trigger the announcement
	new_level.announce()

	current_security_level = new_level

	SEND_SIGNAL(src, COMSIG_SECURITY_LEVEL_CHANGED, new_level)

/**
 * Returns the current security level as a number
 */
/datum/controller/subsystem/security_level/proc/get_current_level_as_number()
	return ((!initialized || !current_security_level) ? 5 : current_security_level.threat_level_numerical) //Send the default security level in case the subsystem hasn't finished initializing yet

/**
 * Returns the current security level as text
 */
/datum/controller/subsystem/security_level/proc/get_current_level_as_text()
	return ((!initialized || !current_security_level) ? "Condition Five" : current_security_level.name)

/**
 * Converts a text security level to a number
 *
 * Arguments:
 * * level - The text security level to convert
 */
/datum/controller/subsystem/security_level/proc/text_level_to_number(text_level)
	var/datum/security_level/selected_level = available_levels[text_level]
	return selected_level?.threat_level_numerical

/**
 * Converts a number security level to a text
 *
 * Arguments:
 * * level - The number security level to convert
 */
/datum/controller/subsystem/security_level/proc/number_level_to_text(number_level)
	for(var/iterating_level_text in available_levels)
		var/datum/security_level/iterating_security_level = available_levels[iterating_level_text]
		if(iterating_security_level.threat_level_numerical == number_level)
			return iterating_security_level.name

#undef THREAT_LEVEL_NIGHTLIGHT_TEMPORARY_DISABLE_TRESHOLD
