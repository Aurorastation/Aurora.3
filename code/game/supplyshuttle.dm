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
	station_area = 1
	flags = SPAWN_ROOF | HIDE_FROM_HOLOMAP

/area/supply/dock
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	requires_power = 0
	centcomm_area = 1


/*
/obj/effect/marker/supplymarker
	icon_state = "X"
	icon = 'icons/misc/mark.dmi'
	name = "X"
	invisibility = 101
	anchored = 1
	opacity = 0
*/

/datum/supply_order
	var/ordernum
	var/datum/supply_packs/object = null
	var/orderedby = null
	var/comment = null
