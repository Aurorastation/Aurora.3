#ifdef ENABLE_SUNLIGHT

/var/datum/controller/subsystem/sunlight/SSsunlight

/datum/controller/subsystem/sunlight
	name = "Sunlight"
	flags = SS_NO_FIRE
	init_order = SS_INIT_SUNLIGHT

	var/list/light_points = list()
	var/config.sun_target_z = 7

	var/list/presets

/datum/controller/subsystem/sunlight/New()
	NEW_SS_GLOBAL(SSsunlight)

/datum/controller/subsystem/sunlight/stat_entry()
	..("A:[config.sun_accuracy] LP:[light_points.len] Z:[config.sun_target_z]")

/datum/controller/subsystem/sunlight/Initialize()

	presets = list()
	for (var/thing in subtypesof(/datum/sun_state))
		presets += new thing

	if (config.fastboot)
		log_debug("sunlight: fastboot detected, skipping setup.")
		..()
		return

	var/thing
	var/turf/T
	for (thing in Z_ALL_TURFS(config.sun_target_z))
		T = thing
		if (!(T.x % config.sun_accuracy) && !(T.y % config.sun_accuracy))
			light_points += new /atom/movable/sunobj(thing)

		CHECK_TICK

	log_debug("sunlight: [light_points.len] sun emitters.")
	..()

/datum/controller/subsystem/sunlight/proc/set_overall_light(...)
	. = 0
	for (var/thing in light_points)
		var/atom/movable/AM = thing
		AM.set_light(arglist(args))
		.++
		CHECK_TICK

/datum/controller/subsystem/sunlight/proc/apply_sun_state(datum/sun_state/S)
	log_debug("sunlight: Applying preset [S].")
	set_overall_light(config.sun_accuracy * 1.2, 1, S.color)

/atom/movable/sunobj
	name = "sunlight emitter"
	desc = "Weren't you told to never look directly at the sun? (but seriously, you shouldn't see this)"
	light_novis = TRUE
	light_range = 16
	simulated = FALSE
	mouse_opacity = FALSE

/atom/movable/sunobj/Destroy(force = FALSE)
	if (!force)
		crash_with("Something attempted to delete a sunobj!")
		return QDEL_HINT_LETMELIVE

	SSsunlight.light_points -= src
	return ..()

/atom/movable/sunobj/Initialize()
	light_range = Ceiling(config.sun_accuracy * 1.2)
	return ..()

/atom/movable/sunobj/can_fall()
	. = FALSE

/datum/sun_state
	var/color = "#FFFFFF"
	var/name = "INVALID"

/datum/sun_state/default
	name = "Default"

/datum/sun_state/sensual
	name = "Sensual"
	color = LIGHT_COLOR_PINK

/datum/sun_state/red
	name = "Nar-Sie"
	color = "#FF0000"

/datum/sun_state/less_red
	name = "Red"
	color = LIGHT_COLOR_RED

/datum/sun_state/blue
	name = "Blue"
	color = LIGHT_COLOR_BLUE

#endif
