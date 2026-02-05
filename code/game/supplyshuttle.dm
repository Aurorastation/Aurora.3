//Config stuff
//Supply packs are in /code/defines/obj/supplypacks.dm
//Computers are in /code/game/machinery/computer/supply.dm

/obj/item/paper/manifest
	name = "supply manifest"
	var/is_copy = 1

/area/supply/station
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	requires_power = 0
	station_area = TRUE
	area_flags = AREA_FLAG_SPAWN_ROOF | AREA_FLAG_HIDE_FROM_HOLOMAP

/area/supply/dock
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	requires_power = 0
	centcomm_area = 1
