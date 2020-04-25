
////////////
//SHUTTLES//
////////////
//shuttle areas must contain at least two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles should now be under shuttle since we have smooth-wall code.

/area/shuttle
	requires_power = 0
	sound_env = SMALL_ENCLOSED
	no_light_control = 1
	flags = SPAWN_ROOF

/area/shuttle/arrival
	name = "Arrival Shuttle"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/arrival/centcom
	icon_state = "shuttle2"
	base_turf = /turf/unsimulated/floor/plating
	centcomm_area = 1

/area/shuttle/arrival/centcom/Entered(atom/movable/Obj, atom/oldLoc)
	. = ..()
	if (!istype(Obj, /mob/living) || !SSarrivals)
		return

	SSarrivals.on_hotzone_enter(Obj)

/area/shuttle/arrival/centcom/Exited(atom/movable/Obj, atom/newLoc)
	. = ..()
	if (!istype(Obj, /mob/living) || !SSarrivals)
		return

	SSarrivals.on_hotzone_exit(Obj)

/area/shuttle/arrival/transit
	icon_state = "shuttle2"
	base_turf = /turf/space/transit/east
	centcomm_area = 1

/area/shuttle/arrival/station
	icon_state = "shuttle"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/escape
	name = "Emergency Shuttle"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/escape/station
	name = "Emergency Shuttle Station"
	icon_state = "shuttle2"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/escape/centcom
	name = "Emergency Shuttle Centcom"
	icon_state = "shuttle"
	base_turf = /turf/unsimulated/floor/plating
	centcomm_area = 1

/area/shuttle/escape/transit // the area to pass through for 3 minute transit
	name = "Emergency Shuttle Transit"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north
	centcomm_area = 1

/area/shuttle/escape_pod1
	name = "Escape Pod One"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/escape_pod1/station
	icon_state = "shuttle2"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/escape_pod1/centcom
	icon_state = "shuttle"
	base_turf = /turf/space
	centcomm_area = 1

/area/shuttle/escape_pod1/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north
	centcomm_area = 1

/area/shuttle/escape_pod2
	name = "Escape Pod Two"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/escape_pod2/station
	icon_state = "shuttle2"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/escape_pod2/centcom
	icon_state = "shuttle"
	base_turf = /turf/space
	centcomm_area = 1

/area/shuttle/escape_pod2/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north
	centcomm_area = 1

/area/shuttle/escape_pod3
	name = "Escape Pod Three"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/escape_pod3/station
	icon_state = "shuttle2"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/escape_pod3/centcom
	icon_state = "shuttle"
	base_turf = /turf/space
	centcomm_area = 1

/area/shuttle/escape_pod3/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north
	centcomm_area = 1

/area/shuttle/escape_pod5 //Pod 4 was lost to meteors
	name = "Escape Pod Five"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/escape_pod5/station
	icon_state = "shuttle2"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/escape_pod5/centcom
	icon_state = "shuttle"
	base_turf = /turf/space
	centcomm_area = 1

/area/shuttle/escape_pod5/transit
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north
	centcomm_area = 1

/area/shuttle/mining
	name = "Mining Shuttle"

/area/shuttle/mining/station
	icon_state = "shuttle2"
	station_area = 1

/area/shuttle/mining/outpost
	icon_state = "shuttle"
	station_area = 1

/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "Transport Shuttle Centcom"
	base_turf = /turf/unsimulated/floor/plating
	centcomm_area = 1

/area/shuttle/transport1/station
	icon_state = "shuttle"
	name = "Transport Shuttle"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/specops/centcom
	name = "Special Ops Shuttle"
	flags = RAD_SHIELDED | SPAWN_ROOF
	base_turf = /turf/unsimulated/floor/plating
	icon_state = "shuttlered"
	centcomm_area = 1

/area/shuttle/specops/station
	icon_state = "shuttlered2"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/syndicate_elite
	name = "Merc Elite Shuttle"
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/syndicate_elite/mothership
	icon_state = "shuttlered"
	centcomm_area = 1

/area/shuttle/syndicate_elite/station
	icon_state = "shuttlered2"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/administration
	flags = RAD_SHIELDED | SPAWN_ROOF

/area/shuttle/administration/centcom
	name = "Administration Shuttle Centcom"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor/plating
	centcomm_area = 1

/area/shuttle/administration/station
	name = "Administration Shuttle"
	icon_state = "shuttlered2"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/research
	name = "Research Shuttle"

/area/shuttle/research/station
	icon_state = "shuttle2"
	flags = RAD_SHIELDED | SPAWN_ROOF
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/research/outpost
	icon_state = "shuttle"
	base_turf = /turf/space

/area/shuttle/research/away
	icon_state = "shuttle"
	station_area = 0
	base_turf = /turf/simulated/floor/reinforced

/area/shuttle/research/transit
	name = "Hyperspace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/north

/area/shuttle/legion
	name = "Foreign Legion Shuttle"
	flags = RAD_SHIELDED | SPAWN_ROOF
	base_turf = /turf/simulated/floor/tiled/dark
	icon_state = "shuttlegrn"
	centcomm_area = 1

/area/shuttle/legion/centcom
	base_turf = /turf/unsimulated/floor/plating

/area/shuttle/legion/station
	name = "Surface Escape Pods - Docking Port"
	icon_state = "shuttlegrn2"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1

/area/shuttle/legion/transit
	name = "Hyperspace"
	icon_state = "shuttle"
	base_turf = /turf/space/transit/east

/area/shuttle/distress/centcom
	name = "Unidentified Shuttle"
	flags = RAD_SHIELDED | SPAWN_ROOF
	base_turf = /turf/space
	icon_state = "shuttlegrn"
	centcomm_area = 1

/area/shuttle/distress/station
	name = "Blue Dock Exterior"
	flags = RAD_SHIELDED | SPAWN_ROOF
	base_turf = /turf/unsimulated/floor/asteroid/ash
	icon_state = "shuttle"
	station_area = 1

/area/shuttle/distress/transit
	name = "Unidentified Shuttle"
	base_turf = /turf/space/transit/east
	icon_state = "shuttle"
	centcomm_area = 1

/area/shuttle/merchant
	name = "Merchant Ship"
	flags = RAD_SHIELDED | SPAWN_ROOF
	base_turf = /turf/space
	icon_state = "yellow"
	sound_env = LARGE_ENCLOSED

/area/shuttle/merchant/start
	centcomm_area = 1

/area/shuttle/merchant/transit
	name = "Hyperspace"
	centcomm_area = 1
	base_turf = /turf/space/transit/east

/area/shuttle/merchant/station
	name = "Merchant Docking Port"
	base_turf = /turf/unsimulated/floor/asteroid/ash
	station_area = 1
