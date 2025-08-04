/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = INVISIBILITY_ABSTRACT
	layer = ABOVE_HUMAN_LAYER

INITIALIZE_IMMEDIATE(/obj/effect/landmark)
/obj/effect/landmark/Initialize(mapload)
	. = ..()
	tag = "landmark*[name]"
	GLOB.landmarks_list += src

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	tag = null
	. = ..()

/*#######################
	LATEJOIN LANDMARKS
#######################*/

/**
 * # Latejoin marker
 *
 * Used to indicate where players spawn if they are latejoining
 */
/obj/effect/landmark/latejoin
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/latejoin/Initialize()
	..()
	GLOB.latejoin += get_turf(src)
	return INITIALIZE_HINT_QDEL

/**
 * # Latejoin cyborg marker
 *
 * Used to indicate where players spawn if they are latejoining
 */
/obj/effect/landmark/latejoincyborg
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/latejoincyborg/Initialize()
	..()
	GLOB.latejoin_cyborg += get_turf(src)
	return INITIALIZE_HINT_QDEL

/**
 * # Latejoin cryo marker
 */
/obj/effect/landmark/latejoincryo
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/latejoincryo/Initialize()
	..()
	GLOB.latejoin_cryo += get_turf(src)
	return INITIALIZE_HINT_QDEL

/**
 * # Latejoin lift marker
 */
/obj/effect/landmark/latejoinlift
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/latejoinlift/Initialize()
	. = ..()
	GLOB.latejoin_living_quarters_lift += get_turf(src)
	return INITIALIZE_HINT_QDEL

/**
 * # Latejoin medbay marker
 */

/obj/effect/landmark/latejoinmedbayrecovery
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/latejoinmedbayrecovery/Initialize()
	. = ..()
	GLOB.latejoin_medbay_recovery += get_turf(src)
	return INITIALIZE_HINT_QDEL

/**
 * # Start marker
 *
 * The position at which the player mob is moved after the spawn sync happened, based on the job/role
 *
 * The match is done based on the `name` property, *you must set the name*
 */
/obj/effect/landmark/start
	name = "start (rename me to match the job title)" //This is checked in the maplint `tools\maplint\lints\startmarker_unset.yml` file, if you change the name here, do there too
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x"

/obj/effect/landmark/start/Initialize(mapload)
	. = ..()
	tag = "start*[name]"

///Used for spawn sync, all mobs at roundstart are moved to this as they are equipped, before being sent to their final position
/obj/effect/landmark/newplayer_start
	name = "newplayer start"

/obj/effect/landmark/newplayer_start/Initialize(mapload)
	..()
	if(GLOB.newplayer_start)
		stack_trace("There must be one, and only one, /obj/effect/landmark/newplayer_start effect in any single server session!")
	else
		GLOB.newplayer_start = get_turf(src)

	return INITIALIZE_HINT_QDEL

/**
 * # Lobby mob location marker
 *
 * Where the mobs that are seeing the lobby screen are located, only one is allowed to exist at a time
 */
/obj/effect/landmark/lobby_mobs_location
	name = "lobby_mobs_location"
	anchored = TRUE
	invisibility = 101

INITIALIZE_IMMEDIATE(/obj/effect/landmark/lobby_mobs_location)

/obj/effect/landmark/lobby_mobs_location/Initialize()
	..()

	if(GLOB.lobby_mobs_location)
		crash_with("There must be one, and only one, /obj/effect/landmark/lobby_mobs_location effect in any single server session!")

	else
		GLOB.lobby_mobs_location = get_turf(src)
		ASSERT(istype(GLOB.lobby_mobs_location, /turf))

	return INITIALIZE_HINT_QDEL

/**
 * # Force spawnpoint
 *
 * A spawnpoint that is forced to be used at spawn (join AND latejoin), *overriding everything else*, depending on the `job_tag` var
 *
 * If the `job_tag` is set to "Anyone", the spawnpoint will be used for all jobs
 */
/obj/effect/landmark/force_spawnpoint
	name = "force spawnpoint"
	var/job_tag = "Anyone"

/obj/effect/landmark/force_spawnpoint/Initialize()
	. = ..()
	LAZYADD(GLOB.force_spawnpoints[job_tag], get_turf(src))

/obj/effect/landmark/force_spawnpoint/Destroy()
	LAZYREMOVE(GLOB.force_spawnpoints[job_tag], get_turf(src))
	. = ..()

/**
 * # Skrell SROM (dreaming) marker
 *
 * Used to indicate where the SROM is located
 */
/obj/effect/landmark/skrell_srom
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/skrell_srom/Initialize()
	..()
	GLOB.dream_entries |= get_turf(src)
	return INITIALIZE_HINT_QDEL

/**
 * # Virtual reality spawn marker
 *
 * Used to indicate where the VR spawn is located
 */
/obj/effect/landmark/virtual_reality_spawn
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/virtual_reality_spawn/Initialize()
	..()
	GLOB.virtual_reality_spawn += get_turf(src)
	return INITIALIZE_HINT_QDEL

/*##########################
	THUNDERDOME LANDMARKS
##########################*/
/obj/effect/landmark/thunderdome1
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/thunderdome1/Initialize()
	..()
	GLOB.tdome1 += get_turf(src)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdome2
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/thunderdome2/Initialize()
	..()
	GLOB.tdome2 += get_turf(src)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdomeadmin
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/thunderdomeadmin/Initialize()
	..()
	GLOB.tdomeadmin += get_turf(src)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/thunderdomeobserve
	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/landmark/thunderdomeobserve/Initialize()
	..()
	GLOB.tdomeobserve += get_turf(src)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/distress_team_equipment
	name = "distress equipment"

/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/New(loc, my_ruin_template)
	name = "ruin_[sequential_id(/obj/effect/landmark/ruin)]"
	..(loc)
	ruin_template = my_ruin_template
	GLOB.ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
	GLOB.ruin_landmarks -= src
	ruin_template = null
	. = ..()

/*#########################
	OVERMAP ENTRY POINTS
#########################*/
/**
 * # Entry point landmarks
 *
 * These landmarks are used to mark the entry points for ship weapons
 */
/obj/effect/landmark/entry_point
	name = "entry point landmark"
	icon_state = "dir_arrow"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/landmark/entry_point/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/entry_point/LateInitialize()
	if(SSatlas.current_map.use_overmap)
		SSshuttle.entry_points_to_initialize += src
	name += " [x], [y]"

/obj/effect/landmark/entry_point/Destroy()
	..()
	return QDEL_HINT_LETMELIVE

/obj/effect/landmark/entry_point/proc/get_candidate()
	var/obj/effect/overmap/visitable/sector = GLOB.map_sectors["[z]"]
	if(!sector)
		return
	return attempt_hook_up_recursive(sector)

/obj/effect/landmark/entry_point/proc/attempt_hook_up_recursive(var/obj/effect/overmap/visitable/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/effect/overmap/visitable/ship/candidate in sector)
		if((. = .(candidate)))
			return

/obj/effect/landmark/entry_point/proc/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	if(!istype(sector))
		return FALSE
	if(sector.check_ownership(src))
		return TRUE
	return FALSE

//The four entry point landmarks below are named assuming that fore is facing DOWNWARDS.
/obj/effect/landmark/entry_point/aft
	name = "aft"

/obj/effect/landmark/entry_point/starboard
	name = "starboard"
	dir = 4

/obj/effect/landmark/entry_point/port
	name = "port"
	dir = 8

/obj/effect/landmark/entry_point/fore
	name = "fore"
	dir = 1

/obj/effect/landmark/entry_point/south
	name = "south"

/obj/effect/landmark/entry_point/east
	name = "east"
	dir = 4

/obj/effect/landmark/entry_point/west
	name = "west"
	dir = 8

/obj/effect/landmark/entry_point/north
	name = "north"
	dir = 1
