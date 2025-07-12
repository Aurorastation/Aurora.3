/obj/item/floor_frame
	name = "frame"
	desc = "Used for building machines."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire_bitem"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	var/build_machine_type
	var/refund_amt = 2
	var/refund_type = /obj/item/stack/material/steel
	var/reverse = 0 //if resulting object faces opposite its dir (like light fixtures)

/obj/item/floor_frame/assembly_hints()
	. = list()
	. += ..()
	. += "It could be installed by using it on an adjacent <b>floor</b>."

/obj/item/floor_frame/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.iswrench())
		new refund_type(get_turf(src.loc), refund_amt)
		qdel(src)
		return TRUE
	return ..()

/obj/item/floor_frame/proc/try_build(turf/on_floor, mob/user)
	if(!build_machine_type)
		return

	if (get_dist(on_floor,usr)>1)
		return

	var/ndir
	if(reverse)
		ndir = get_dir(usr,on_floor)
	else
		ndir = get_dir(on_floor,usr)

	if (!(ndir in GLOB.cardinals))
		return

	var/turf/loc = get_turf(on_floor)
	var/area/A = loc.loc
	if (!istype(loc, /turf/simulated/floor))
		to_chat(usr, SPAN_WARNING("\The [src] cannot be placed on this spot."))
		return
	if (istype(A, /area/space) || istype(A, /area/mine))
		to_chat(usr, SPAN_WARNING("\The [src] cannot be placed in this area."))
		return

	var/obj/machinery/M = new build_machine_type(loc, ndir, 1)
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	user.remove_from_mob(src) //Prevents gripper duplication
	qdel(src)

/obj/item/floor_frame/light
	name = "floor light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/machinery/light.dmi'
	icon_state = "floortube-construct-stage1"
	build_machine_type = /obj/machinery/light_construct/floor
	reverse = 1

/obj/item/floor_frame/light/small
	name = "small floor light fixture frame"
	icon_state = "floor-construct-stage1"
	refund_amt = 1
	build_machine_type = /obj/machinery/light_construct/small/floor
