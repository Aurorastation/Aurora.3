/// Movespeed modifier applied by worn equipment.
/datum/movespeed_modifier/equipment_speedmod
	variable = TRUE
	blacklisted_movetypes = FLOATING

/// Movespeed modifier applied by immutably slow worn equipment. Should never be ignored, because that's the point.
/datum/movespeed_modifier/equipment_speedmod/immutable

/datum/movespeed_modifier/config_walk_run
	multiplicative_slowdown = 1
	id = MOVESPEED_ID_MOB_WALK_RUN
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/config_walk_run/proc/sync()

/datum/movespeed_modifier/config_walk_run/walk/sync()
	var/mod = GLOB.config.walk_speed //used to be CONFIG_GET(number/movedelay/walk_delay)
	multiplicative_slowdown = isnum(mod)? mod : initial(multiplicative_slowdown)

/datum/movespeed_modifier/config_walk_run/run/sync()
	var/mod = GLOB.config.walk_speed * GLOB.config.run_delay_multiplier//CONFIG_GET(number/movedelay/run_delay)
	multiplicative_slowdown = isnum(mod)? mod : initial(multiplicative_slowdown)

/datum/movespeed_modifier/mob_config_speedmod
	variable = TRUE
	flags = IGNORE_NOSLOW

/datum/movespeed_modifier/encumbered
	multiplicative_slowdown = 2
	id = "encumbered"

/datum/movespeed_modifier/zoomzoomkitty
	multiplicative_slowdown = -0.5
	id = "zoomzoomkitty"
