/obj/item/frame
	name = "frame"
	desc = "Used for building machines."
	icon = 'icons/obj/monitors.dmi'
	icon_state = ""
	obj_flags = OBJ_FLAG_CONDUCTABLE
	var/build_machine_type
	var/refund_amt = 2
	var/refund_type = /obj/item/stack/material/steel

/obj/item/frame/assembly_hints()
	. = list()
	. += ..()
	. += "It could be installed by using it on an adjacent <b>wall</b>."

/obj/item/frame/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.iswrench())
		new refund_type( get_turf(src.loc), refund_amt)
		qdel(src)
		return TRUE
	return ..()

/obj/item/frame/proc/try_build(turf/on_wall, mob/user)
	if(!build_machine_type)
		return

	if (get_dist(on_wall,usr)>1)
		return

	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in GLOB.cardinals))
		to_chat(user, SPAN_WARNING("You need to stand in front of the wall, directly, to build \the [src]!"))
		return

	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (!istype(loc, /turf/simulated/floor))
		to_chat(usr, SPAN_WARNING("\The [src] cannot be placed on this spot."))
		return
	if (istype(A, /area/space) || istype(A, /area/mine))
		to_chat(usr, SPAN_WARNING("\The [src] cannot be placed in this area."))
		return

	if(gotwallitem(loc, ndir))
		to_chat(usr, SPAN_WARNING("There's already an item on this wall!"))
		return

	var/obj/machinery/M = new build_machine_type(loc, ndir, 1)
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	user.remove_from_mob(src) //Prevents gripper duplication
	qdel(src)

/obj/item/frame/fire_alarm
	name = "fire alarm frame"
	desc = "Used for building fire alarms."
	icon_state = "firealarm"
	build_machine_type = /obj/machinery/firealarm

/obj/item/frame/air_alarm
	name = "air alarm frame"
	desc = "Used for building air alarms."
	icon_state = "alarm_bitem"
	build_machine_type = /obj/machinery/alarm

/obj/item/frame/light
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/machinery/light.dmi'
	icon_state = "tube-construct-item"
	build_machine_type = /obj/machinery/light_construct

/obj/item/frame/light/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	refund_amt = 1
	build_machine_type = /obj/machinery/light_construct/small

/obj/item/frame/light/spot
	name = "spotlight fixture frame"
	icon_state = "slight-construct-item"
	refund_amt = 3
	build_machine_type = /obj/machinery/light_construct/spot
