/*
#define AREA_USAGE_EQUIP 1
#define AREA_USAGE_LIGHT 2
#define AREA_USAGE_ENVIRON 3
*/

/area/proc/powered(var/chan)		// return true if the area has power to given channel

	if(!requires_power)
		return TRUE
	if(always_unpowered)
		return FALSE
	switch(chan)
		if(AREA_USAGE_EQUIP)
			return power_equip
		if(AREA_USAGE_LIGHT)
			return power_light
		if(AREA_USAGE_ENVIRON)
			return power_environ

	return FALSE

/**
 * Called when area power status changes.
 */
/area/proc/power_change()
	SEND_SIGNAL(src, COMSIG_AREA_POWER_CHANGE)

	//One day, this will only use the signal, but that day is not today
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change()			// reverify power status (to update icons etc.)
	if (fire || eject || party)
		update_icon()

/area/proc/usage(var/chan)
	switch(chan)
		if(AREA_USAGE_LIGHT)
			return used_light + oneoff_light
		if(AREA_USAGE_EQUIP)
			return used_equip + oneoff_equip
		if(AREA_USAGE_ENVIRON)
			return used_environ + oneoff_environ
		if(AREA_USAGE_TOTAL)
			return .(AREA_USAGE_LIGHT) + .(AREA_USAGE_EQUIP) + .(AREA_USAGE_ENVIRON)

/area/proc/clear_usage()
	oneoff_equip = 0
	oneoff_light = 0
	oneoff_environ = 0

/**
 * Don't call this unless you know what you're doing
 *
 * See use_power_oneoff below
 */
/area/proc/use_power(var/amount, var/chan)
	switch(chan)
		if(AREA_USAGE_EQUIP)
			used_equip += amount
		if(AREA_USAGE_LIGHT)
			used_light += amount
		if(AREA_USAGE_ENVIRON)
			used_environ += amount

/**
 * Used by machines to update the area of power changes.
 */
/area/proc/power_use_change(old_amount, new_amount, chan)
	use_power(new_amount - old_amount, chan)

/**
 * Use this for one-time power draws from the area, usually for non-machines.
 */
/area/proc/use_power_oneoff(var/amount, var/chan)
	switch(chan)
		if(AREA_USAGE_EQUIP)
			oneoff_equip += amount
		if(AREA_USAGE_LIGHT)
			oneoff_light += amount
		if(AREA_USAGE_ENVIRON)
			oneoff_environ += amount

/**
 * This recomputes continued power usage; used for testing or error recovery.
 */
/area/proc/retally_power()
	used_equip = 0
	used_light = 0
	used_environ = 0

	for(var/obj/machinery/M in src)
		switch(M.power_channel)
			if(AREA_USAGE_EQUIP)
				used_equip += M.get_power_usage()
			if(AREA_USAGE_LIGHT)
				used_light += M.get_power_usage()
			if(AREA_USAGE_ENVIRON)
				used_environ += M.get_power_usage()
