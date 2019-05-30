/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'

/obj/structure/shuttle/announcement
	name = "Shuttle announcement System"
	icon = 'icons/obj/radio.dmi'
	icon_state = "itercom-fancy"

/obj/structure/shuttle/window
	name = "shuttle window"
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "1"
	density = 1
	opacity = 0
	anchored = 1
	atmos_canpass = CANPASS_NEVER

/obj/structure/shuttle/window/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!height || air_group) return 0
	else return ..()

/obj/structure/shuttle/engine
	name = "engine"
	density = 1
	anchored = 1.0
	atmos_canpass = CANPASS_NEVER

/obj/structure/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"

/obj/structure/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/structure/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = 1
	var/health = 100

/obj/structure/shuttle/engine/propulsion/proc/update_damage()
	return

/obj/structure/shuttle/engine/propulsion/burst
	name = "burst"

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "left"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "right"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "router"
	icon_state = "router"

/obj/structure/shuttle/engine/big
	name = "big engine"
	icon_state = "nozzle"

/obj/structure/shuttle/engine/propulsion/temp
	name = "emergency engine"
	desc = "An Einstein Engines emergency booster engine, intended to be fit onto shuttles which have damaged their propulsion systems. It acts as a band-aid solution to provide an otherwise stranded ship the necessary delta-v to get to a repair dock."
	icon_state = "EE_Booster"
	var/list/component_parts = list()

/obj/structure/shuttle/engine/propulsion/temp/update_damage()
	health -= 25
	if(health <= 0)
		qdel(src)

/obj/structure/shuttle/engine/propulsion/temp/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	src.set_dir(turn(src.dir, 90))
	return 1