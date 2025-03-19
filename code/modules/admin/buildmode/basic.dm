/datum/build_mode/basic
	the_default = TRUE
	name = "Basic"
	icon_state = "buildmode1"

/datum/build_mode/basic/Help()
	to_chat(user, SPAN_NOTICE("***********************************************************"))
	to_chat(user, SPAN_NOTICE("Left Click        = Construct / Upgrade"))
	to_chat(user, SPAN_NOTICE("Right Click       = Deconstruct / Delete / Downgrade"))
	to_chat(user, SPAN_NOTICE("Left Click + Ctrl = R-Window"))
	to_chat(user, SPAN_NOTICE("Left Click + Alt  = Airlock"))
	to_chat(user, "")
	to_chat(user, SPAN_NOTICE("Use the directional button in the upper left corner to"))
	to_chat(user, SPAN_NOTICE("change the direction of built objects."))
	to_chat(user, SPAN_NOTICE("***********************************************************"))

/datum/build_mode/basic/OnClick(var/atom/object, var/list/pa)
	if(istype(object,/turf) && pa["left"] && !pa["alt"] && !pa["ctrl"] )
		if(istype(object,/turf/space))
			var/turf/T = object
			Log("Upgraded - [log_info_line(object)]")
			T.ChangeTurf(/turf/simulated/floor)
			return
		else if(istype(object,/turf/simulated/floor))
			var/turf/T = object
			Log("Upgraded - [log_info_line(object)]")
			T.ChangeTurf(/turf/simulated/wall)
			return
		else if(istype(object,/turf/simulated/wall))
			var/turf/T = object
			Log("Upgraded - [log_info_line(object)]")
			T.ChangeTurf(/turf/simulated/wall/r_wall)
			return
	else if(pa["right"])
		if(istype(object,/turf/simulated/wall))
			var/turf/T = object
			Log("Downgraded - [log_info_line(object)]")
			T.ChangeTurf(/turf/simulated/floor)
			return
		else if(istype(object,/turf/simulated/floor))
			var/turf/T = object
			Log("Downgraded - [log_info_line(object)]")
			T.ChangeTurf(/turf/space)
			return
		else if(istype(object,/turf/simulated/wall/r_wall))
			var/turf/T = object
			Log("Downgraded - [log_info_line(object)]")
			T.ChangeTurf(/turf/simulated/wall)
			return
		else if(istype(object,/obj))
			Log("Deleted - [log_info_line(object)]")
			qdel(object)
			return
	else if(istype(object,/turf) && pa["alt"] && pa["left"])
		var/airlock = new/obj/machinery/door/airlock(get_turf(object))
		Log("Created - [log_info_line(airlock)]")
	else if(istype(object,/turf) && pa["ctrl"] && pa["left"])
		var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(get_turf(object))
		Log("Created - [log_info_line(object)]")
		switch(host.dir)
			if(NORTH)
				WIN.set_dir(NORTH)
			if(SOUTH)
				WIN.set_dir(SOUTH)
			if(EAST)
				WIN.set_dir(EAST)
			if(WEST)
				WIN.set_dir(WEST)
			if(NORTHWEST)
				WIN.set_dir(NORTHWEST)
