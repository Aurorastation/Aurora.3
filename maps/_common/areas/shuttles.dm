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

/area/shuttle/arrival
	name = "Arrival Shuttle"
	base_turf = /turf/unsimulated/floor/plating
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
	base_turf = /turf/unsimulated/floor/plating
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/shuttle/transport1
	icon_state = "shuttle"
	name = "Transport Shuttle"
	base_turf = /turf/unsimulated/floor/plating

/area/shuttle/specops
	name = "Special Ops Shuttle"
	base_turf = /turf/unsimulated/floor/plating
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
	base_turf = /turf/unsimulated/floor/plating
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/shuttle/research
	name = "Research Shuttle"
	base_turf = /turf/simulated/floor/exoplanet/asteroid/ash

/area/shuttle/legion
	name = "Foreign Legion Shuttle"
	base_turf = /turf/unsimulated/floor/plating
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF | AREA_FLAG_NO_CREW_EXPECTED

/area/shuttle/distress
	name = "Unidentified Shuttle"
	base_turf = /turf/unsimulated/floor/plating

/area/shuttle/merchant
	name = "Merchant Ship"
	base_turf = /turf/space
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_SPAWN_ROOF | AREA_FLAG_NO_CREW_EXPECTED
