//
// Areas
//

#define VOLUME_AMBIENCE 30
#define VOLUME_AMBIENT_HUM 18
#define VOLUME_MUSIC 30

/// This list of names is here to make sure we don't state the area blurb to a mob more than once.
GLOBAL_LIST_INIT(area_blurb_stated_to, list())

/area
	var/global/global_uid = 0
	var/uid
	///Bitflag (Any of `AREA_FLAG_*`). See `code\__DEFINES\misc.dm`.
	var/area_flags
	var/holomap_color // Color of this area on the holomap. Must be a hex color (as string) or null.

	///Do we have an active fire alarm?
	var/fire = FALSE

	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	var/radiation_active = null
	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = AREA_LAYER
	luminosity = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_LIGHTING

	var/obj/machinery/power/apc/apc = null
	var/turf/base_turf // The base turf type of the area, which can be used to override the z-level's base turf.

	var/lightswitch = FALSE

	var/eject = null

	var/requires_power = 1
	var/always_unpowered = 0	//this gets overridden to 1 for space in area/New()

	var/power_equip = 1 // Status vars
	var/power_light = 1
	var/power_environ = 1
	var/used_equip = 0 // Continuous drain; don't touch these directly.
	var/used_light = 0
	var/used_environ = 0
	var/oneoff_equip 	= 0 // Used once and cleared each tick.
	var/oneoff_light 	= 0
	var/oneoff_environ 	= 0

	///Boolean, if this area has gravity
	var/has_gravity = TRUE

	///Boolean, if this area always has gravity
	var/alwaysgravity = FALSE

	///Boolean, if this area never has gravity
	var/nevergravity = FALSE

	var/list/all_doors = list() //Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/air_doors_activated = FALSE

	var/list/ambience = list()
	var/list/forced_ambience = null
	var/list/music = list()

	///Used to decide what kind of reverb the area makes sound have
	var/sound_environment = SOUND_AREA_STANDARD_STATION

	var/no_light_control = FALSE // If TRUE, lights in area cannot be toggled with light controller.
	var/allow_nightmode = FALSE // If TRUE, lights in area will be darkened by the night mode controller.
	var/emergency_lights = FALSE

	/**
	 * Boolean, if the area is part of the station (aka main map)
	 *
	 * This includes any non-space area, including maintenance; it doesn't include space or shuttles (as they could be outside the station)
	 */
	var/station_area = FALSE
	/// Only used for the Horizon, and mostly for mapping checks/naming. All except horizon_deck (integer) use '_DEFINES\ship_locations.dm' constants
	var/horizon_deck = null
	var/department = null
	var/subdepartment = null
	// 'amidships' belongs to location_ew
	var/location_ew = null
	var/location_ns = null

	var/centcomm_area = FALSE

	/// A text-based description of the area, can be used for sounds, notable things in the room, etc.
	var/area_blurb
	/// Used to filter description showing across subareas.
	var/area_blurb_category

	var/tmp/is_outside = OUTSIDE_NO

/**
 * Don't move this to Initialize(). Things in here need to run before SSatoms does.
 */
/area/New()
	// DMMS hook - Required for areas to work properly.
	if (!GLOB.areas_by_type[type])
		GLOB.areas_by_type[type] = src
	GLOB.areas += src
	// Atmos code needs this, so we need to make sure this is done by the time they initialize.
	uid = ++global_uid
	if(isnull(area_blurb_category))
		area_blurb_category = type
	. = ..()

/area/Initialize(mapload)
	icon_state = "white"
	color = null

	blend_mode = BLEND_MULTIPLY

	if(!requires_power)
		power_light = 0
		power_equip = 0
		power_environ = 0

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	if(centcomm_area)
		GLOB.centcom_areas[src] = TRUE
		alwaysgravity = 1

	if(station_area)
		GLOB.the_station_areas[src] = TRUE

	if(!requires_power || !apc)
		power_light = 0
		power_equip = 0
		power_environ = 0

	if (!mapload)
		power_change()		// All machines set to current power level.

	. = ..()

	if(dynamic_lighting)
		luminosity = FALSE

	if (mapload && turf_initializer)
		for(var/turf/T in src)
			turf_initializer.initialize(T)

/area/Destroy()
	if(GLOB.areas_by_type[type] == src)
		GLOB.areas_by_type[type] = null
	//this is not initialized until get_sorted_areas() is called so we have to do a null check
	if(!isnull(GLOB.sortedAreas))
		GLOB.sortedAreas -= src
	//just for sanity sake cause why not
	if(!isnull(GLOB.areas))
		GLOB.areas -= src

	GLOB.centcom_areas -= src
	GLOB.the_station_areas -= src

	//parent cleanup
	return ..()

/area/proc/is_prison()
	return area_flags & AREA_FLAG_PRISON

/area/proc/is_no_crew_expected()
	return area_flags & AREA_FLAG_NO_CREW_EXPECTED

/**
 * Set lights in area.
 *
 * * state - TRUE for on, FALSE for off, NULL for initial state
 *
 * Returns `TRUE`
 */
/area/proc/set_lightswitch(var/state)
	if(isnull(state))
		state = initial(lightswitch)

	lightswitch = state
	var/obj/machinery/light_switch/L = locate() in src
	if(L)
		L.on = state
		L.sync_lights()

/area/proc/get_cameras()
	. = list()
	for (var/thing in SSmachinery.all_cameras)
		var/obj/machinery/camera/C = thing
		if (!isturf(C.loc))
			continue

		if (C.loc.loc == src) // What the fuck is this?
			. += C

/area/proc/atmosalert(danger_level, var/alarm_source)
	if (danger_level == 0)
		GLOB.atmosphere_alarm.clearAlarm(src, alarm_source)
	else
		GLOB.atmosphere_alarm.triggerAlarm(src, alarm_source, severity = danger_level)

	//Check all the alarms before lowering atmosalm. Raising is perfectly fine.
	for (var/obj/machinery/alarm/AA in src)
		if (!(AA.stat & (NOPOWER|BROKEN)) && !AA.shorted && AA.report_danger_level)
			danger_level = max(danger_level, AA.danger_level)

	if(danger_level != atmosalm)
		if (danger_level < 1 && atmosalm >= 1)
			//closing the doors on red and opening on green provides a bit of hysteresis that will hopefully prevent fire doors from opening and closing repeatedly due to noise
			air_doors_open()
		else if (danger_level >= 2 && atmosalm < 2)
			air_doors_close()

		atmosalm = danger_level
		for (var/obj/machinery/alarm/AA in src)
			AA.update_icon()

		return 1
	return 0

/area/proc/air_doors_close()
	if(!air_doors_activated)
		air_doors_activated = 1
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_CLOSED
				else if(!E.density)
					INVOKE_ASYNC(E, TYPE_PROC_REF(/obj/machinery/door, close))

/area/proc/air_doors_open()
	if(air_doors_activated)
		air_doors_activated = 0
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_OPEN
				else if(E.density)
					INVOKE_ASYNC(E, TYPE_PROC_REF(/obj/machinery/door, open))

/area/proc/fire_alert()
	if(!fire)
		fire = 1	//used for firedoor checks
		update_icon()
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		for(var/obj/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_CLOSED
				else if(!D.density)
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, close))

/area/proc/fire_reset()
	if (fire)
		fire = 0	//used for firedoor checks
		update_icon()
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		for(var/obj/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_OPEN
				else if(D.density)
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, open))

/area/proc/readyalert()
	if(!eject)
		eject = 1
		update_icon()

/area/proc/readyreset()
	if(eject)
		eject = 0
		update_icon()

/area/proc/partyalert()
	if (!party)
		party = 1
		update_icon()
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/area/proc/partyreset()
	if (party)
		party = 0
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		update_icon()
		for(var/obj/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_OPEN
				else if(D.density)
					INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, open))

#define DO_PARTY(COLOR) animate(color = COLOR, time = 0.5 SECONDS, easing = QUAD_EASING)

/area/update_icon()
	// If it doesn't require power, can still activate this proc.
	if ((fire || eject || party || radiation_active) && (!requires_power||power_environ) && !istype(src, /area/space))
		if(radiation_active)
			color = "#30e63f"
			animate(src)	// stop any current animations.
			animate(src, color = "#2ea138", time = 1 SECOND, loop = -1, easing = SINE_EASING)
			animate(color ="#30e63f", time = 1 SECOND, easing = SINE_EASING)
		else if(fire && !eject && !party)		// FIRE
			color = "#ff9292"
			animate(src)
			animate(src, color = "#ffa5b2", time = 1 SECOND, loop = -1, easing = SINE_EASING)
			animate(color = "#ff9292", time = 1 SECOND, easing = SINE_EASING)
		else if(!fire && eject && !party)		// EJECT
			color = "#ff9292"
			animate(src)
			animate(src, color = "#bc8a81", time = 1 SECOND, loop = -1, easing = EASE_IN|CUBIC_EASING)
			animate(color = "#ff9292", time = 0.5 SECOND, easing = EASE_OUT|CUBIC_EASING)
		else if(party && !fire && !eject)		// PARTY
			color = "#ff728e"
			animate(src)
			animate(src, color = "#7272ff", time = 0.5 SECONDS, loop = -1, easing = QUAD_EASING)
			DO_PARTY("#72aaff")
			DO_PARTY("#ffc68e")
			DO_PARTY("#72c6ff")
			DO_PARTY("#ff72e2")
			DO_PARTY("#72ff8e")
			DO_PARTY("#ffff8e")
			DO_PARTY("#ff728e")
		else
			color = "#ffb2b2"
			animate(src)
			animate(src, color = "#B3DFFF", time = 0.5 SECOND, loop = -1, easing = SINE_EASING)
			animate(color = "#ffb2b2", time = 0.5 SECOND, loop = -1, easing = SINE_EASING)
	else
		animate(src, color = "#FFFFFF", time = 0.5 SECONDS, easing = QUAD_EASING)	// Stop the animation.

#undef DO_PARTY

/**
 * Call back when an atom enters an area
 *
 * Sends signals COMSIG_AREA_ENTERED and COMSIG_ENTER_AREA (to a list of atoms)
 *
 * If the area has ambience, then it plays some ambience music to the ambience channel
 */
/area/Entered(atom/movable/arrived, area/old_area)
	SEND_SIGNAL(src, COMSIG_AREA_ENTERED, arrived, old_area)

	if(!arrived.important_recursive_contents?[RECURSIVE_CONTENTS_AREA_SENSITIVE])
		return
	for(var/atom/movable/recipient as anything in arrived.important_recursive_contents[RECURSIVE_CONTENTS_AREA_SENSITIVE])
		SEND_SIGNAL(recipient, COMSIG_ENTER_AREA, src)

	/* START aurora snowflake code */
	if(!istype(arrived, /mob/living) || !ROUND_IS_STARTED)
		return

	var/mob/living/L = arrived

	if(!L.ckey)	return

	if(!L.lastarea)
		L.lastarea = get_area(L.loc)
	var/area/newarea = get_area(L.loc)
	var/area/oldarea = L.lastarea
	if((oldarea.has_gravity() == FALSE) && (newarea.has_gravity() == TRUE) && (L.m_intent == M_RUN)) // Being ready when you change areas gives you a chance to avoid falling all together.
		thunk(L)
		L.update_floating()

	L.lastarea = newarea

	// Start playing ambience.
	if(src.ambience.len && L && L.client && (L.client.prefs.sfx_toggles & ASFX_AMBIENCE) && !L.ear_deaf)
		play_ambience(L)
	else
		stop_ambience(L)

	// The dreaded ship ambience hum.
	// Explanation for the "if" clause: If the area has ambience, the mob exists, has a client, the client has the hum ASFX toggled on, the area the mob is in is a station area,
	// the mob isn't deaf, and the client doesn't already have the ambient hum playing, then start playing the ambient hum.
	if(L && L.client && (L.client.prefs.sfx_toggles & ASFX_HUM) && newarea.station_area && !L.ear_deaf)
		if(!L.client.ambient_hum_playing)
			L.client.ambient_hum_playing = TRUE
			L << sound('sound/ambience/shipambience.ogg', repeat = 1, volume = VOLUME_AMBIENT_HUM, channel = 3)
	// Otherwise, stop playing the ambient hum.
	else
		L << sound(null, channel = 3)
		if(L.client)
			L.client.ambient_hum_playing = FALSE

	// Start playing music, if it exists.
	if(src.music.len && L && L.client && (L.client.prefs.sfx_toggles & ASFX_MUSIC))
		play_music(L)
	// Stop playing music.
	else
		stop_music(L)
	do_area_blurb(L)

	/* END aurora snowflake code */

/**
 * Called when an atom exits an area
 *
 * Sends signals COMSIG_AREA_EXITED and COMSIG_EXIT_AREA (to a list of atoms)
 */
/area/Exited(atom/movable/gone, direction)
	SEND_SIGNAL(src, COMSIG_AREA_EXITED, gone, direction)
	SEND_SIGNAL(gone, COMSIG_MOVABLE_EXITED_AREA, src, direction)
	if(!gone.important_recursive_contents?[RECURSIVE_CONTENTS_AREA_SENSITIVE])
		return
	for(var/atom/movable/recipient as anything in gone.important_recursive_contents[RECURSIVE_CONTENTS_AREA_SENSITIVE])
		SEND_SIGNAL(recipient, COMSIG_EXIT_AREA, src)

/**
 * Plays ambiance for the provided mob.
 *
 * * mob/living/L - Affected mob.
 */
/area/proc/play_ambience(var/mob/living/L)
	if((world.time >= L.client.ambience_last_played_time + 5 MINUTES) && prob(20))
		var/picked_ambience = pick(ambience)
		L << sound(picked_ambience, volume = VOLUME_AMBIENCE, channel = CHANNEL_AMBIENCE)
		L.client.ambience_last_played_time = world.time

/**
 * Stops ambiance for the provided mob.
 *
 * * mob/living/L - Affected mob.
 */
/area/proc/stop_ambience(var/mob/living/L)
	L << sound(null, channel = 2)

/**
 * Plays music for the provided mob.
 *
 * * mob/living/L - Affected mob.
 */
/area/proc/play_music(var/mob/living/L)
	if(src.music.len)
		var/picked_music = pick(music)
		L << sound(picked_music, volume = VOLUME_MUSIC, channel = 4)

/**
 * Stops music for the provided mob.
 *
 * * mob/living/L - Affected mob.
 */
/area/proc/stop_music(var/mob/living/L)
	L << sound(null, channel = 4)

/area/proc/gravitychange(var/gravitystate = 0)
	has_gravity = gravitystate

	for(var/mob/M in src)
		if(has_gravity())
			thunk(M)
		else
			to_chat(M, SPAN_NOTICE("The sudden lack of gravity makes you feel weightless and float cluelessly."))
		M.update_floating()

/area/proc/thunk(mob)
	if(istype(get_turf(mob), /turf/space)) // Can't fall onto nothing.
		return

	if(istype(mob,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = mob
		if(H.Check_Shoegrip(FALSE))
			return

		if(H.m_intent == M_RUN)
			H.AdjustStunned(2)
			H.AdjustWeakened(2)
		else
			H.AdjustStunned(1)
			H.AdjustWeakened(1)
		to_chat(mob, SPAN_WARNING("The sudden appearance of gravity makes you fall to the floor!"))

/area/proc/prison_break()
	for(var/obj/machinery/power/apc/temp_apc in src)
		temp_apc.overload_lighting(70)
	for(var/obj/machinery/door/airlock/temp_airlock in src)
		temp_airlock.prison_open()
	for(var/obj/machinery/door/window/temp_windoor in src)
		temp_windoor.open()

/area/has_gravity(turf/gravity_turf)
	if(alwaysgravity)
		return TRUE
	if(nevergravity)
		return FALSE
	return has_gravity

/**
 * Useful proc for events.
 * This returns a random area of the station which is meaningful. Ie, a room somewhere
 *
 * * filter_players - Default FALSE. If TRUE, skips areas without any players in them.
 *
 * Returns /area/
 */
/proc/random_station_area(var/filter_players = FALSE)
	var/list/possible = list()
	for(var/Y in GLOB.the_station_areas)
		if(!Y)
			continue
		var/area/A = Y
		if (!is_station_level(A.z))
			continue
		if (istype(A, /area/shuttle) || findtext(A.name, "Docked") || findtext(A.name, "Shuttle"))
			continue
		if (istype(A, /area/solar) || findtext(A.name, "solar"))
			continue
		if (istype(A, /area/constructionsite))
			continue
		if (istype(A, /area/horizon/rnd/xenobiology))
			continue
		if (istype(A, /area/horizon/maintenance/substation))
			continue
		if (istype(A, /area/turbolift))
			continue
		if (istype(A, /area/mine))
			continue
		if (istype(A, /area/horizon/exterior))
			continue

		//Although hostile mobs instadying to turrets is fun
		//If there's no AI they'll just be hit with stunbeams all day and spam the attack logs.
		if (istype(A, /area/turret_protected) || LAZYLEN(A.turret_controls))
			continue

		if(filter_players)
			var/should_continue = FALSE
			for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
				if(!H.client)
					continue
				if(A == get_area(H))
					should_continue = TRUE
					break

			if(should_continue)
				continue

		possible += A

	return pick(possible)

/area/proc/random_space()
	var/list/turfs = list()
	for(var/turf/simulated/floor/F in src.contents)
		if(turf_clear(F))
			turfs += F
	if (turfs.len)
		return pick(turfs)
	else return null

/**
* Displays an area blurb on a mob's screen.
*
* Areas with blurbs set [/area/var/area_blurb] will display their blurb. Otherwise no blurb will be shown. Contains checks to avoid duplicate blurbs, pass the `override` variable to bypass this. If passed when an area has no blurb, will show a generic "no blurb" message.
*
* * `target_mob` - The mob to show an area blurb.
* * `override` - Pass `TRUE` to override duplicate checks, for usage with verbs, etc.
*/
/area/proc/do_area_blurb(mob/living/target_mob, override)
	if(isnull(area_blurb))
		if(override)
			to_chat(target_mob, EXAMINE_BLOCK_GREY("There's nothing particularly noteworthy about this area."))
		return

	if(!(target_mob.ckey in GLOB.area_blurb_stated_to[area_blurb_category]) || override)
		LAZYADD(GLOB.area_blurb_stated_to[area_blurb_category], target_mob.ckey)
		to_chat(target_mob, EXAMINE_BLOCK_GREY(area_blurb))

/// A verb to view an area's blurb on demand. Overrides the check for if you have seen the blurb before so you can always see it when used.
/mob/living/verb/show_area_blurb()
	set name = "Show Area Blurb"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT))
		var/area/blurb_verb = get_area(src)
		if(blurb_verb)
			blurb_verb.do_area_blurb(src, TRUE)

/// A ghost version of the view area blurb verb so you can view it while observing.
/mob/abstract/ghost/observer/verb/ghost_show_area_blurb()
	set name = "Show Area Blurb"
	set category = "IC"

	var/area/blurb_verb = get_area(src)
	if(blurb_verb)
		blurb_verb.do_area_blurb(src, TRUE)

#undef VOLUME_AMBIENCE
#undef VOLUME_AMBIENT_HUM
#undef VOLUME_MUSIC
