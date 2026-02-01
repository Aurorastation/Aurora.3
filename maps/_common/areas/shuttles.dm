////////////
//SHUTTLES//
////////////
/area/shuttle
	name = "Shuttle"
	icon_state = "shuttle"
	requires_power = 0
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	no_light_control = 1
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF
	centcomm_area = 1
	default_gravity = STANDARD_GRAVITY

/area/shuttle/place_on_top_react(list/new_baseturfs, turf/added_layer, flags)
	. = ..()
	if(ispath(added_layer, /turf/simulated/floor/plating))
		new_baseturfs.Add(/turf/baseturf_skipover/shuttle)
		. |= CHANGETURF_GENERATE_SHUTTLE_CEILING
	else if(ispath(new_baseturfs[1], /turf/simulated/floor/plating))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)
		. |= CHANGETURF_GENERATE_SHUTTLE_CEILING

/area/shuttle/transit
	name = "Transit Space"
	ambience = list('sound/ambience/shipambience.ogg')
	dynamic_lighting = 0
	// base_lighting_alpha = 255

/area/shuttle/arrival
	name = "Arrival Shuttle"
	ambience = AMBIENCE_ARRIVALS

/area/shuttle/arrival/Entered(atom/movable/Obj, atom/oldLoc)
	. = ..()
	if (!istype(Obj, /mob/living) || !SSarrivals)
		return

	SSarrivals.on_hotzone_enter(Obj)

/area/shuttle/arrival/Exited(atom/movable/Obj, atom/newLoc)
	. = ..()
	if (!istype(Obj, /mob/living) || !SSarrivals)
		return

	SSarrivals.on_hotzone_exit(Obj)

/area/shuttle/escape
	name = "Transfer Shuttle"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/shuttle/transport1
	icon_state = "shuttle"
	name = "Transport Shuttle"

/area/shuttle/specops
	name = "Special Ops Shuttle"
	ambience = AMBIENCE_HIGHSEC

/area/shuttle/burglar
	name = "Unidentified Transport"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF | AREA_FLAG_NO_CREW_EXPECTED

/area/shuttle/skipjack
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF | AREA_FLAG_NO_CREW_EXPECTED

/area/shuttle/mercenary
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF | AREA_FLAG_NO_CREW_EXPECTED

/area/shuttle/syndicate_elite
	name = "Naval Transport Shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF | AREA_FLAG_NO_CREW_EXPECTED

/area/shuttle/hapt
	name = "Unidentified Corvette"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/shuttle/research
	name = "Research Shuttle"

/area/shuttle/legion
	name = "Foreign Legion Shuttle"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF | AREA_FLAG_NO_CREW_EXPECTED

/area/shuttle/distress
	name = "Unidentified Shuttle"

/area/shuttle/merchant
	name = "Merchant Ship"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF | AREA_FLAG_NO_CREW_EXPECTED
