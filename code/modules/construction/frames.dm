/*
** FRAME BASE TYPE
*/
/obj/item/frame
	name = "frame"
	desc = "Used for building machines."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire_bitem"
	flags = CONDUCT
	var/build_machine_type
	var/refund_amt = 2
	var/refund_type = /obj/item/stack/material/steel
	var/reverse = 0 //if resulting object faces opposite its dir (like light fixtures)

/*
** FRAME BASE PROCS
*/

/obj/item/frame/attackby(obj/item/W, mob/user)
	if (W.iswrench())
		new refund_type(get_turf(src.loc), refund_amt)
		qdel(src)
		return
	..()

/obj/item/frame/proc/check_can_build(var/turf/on_wall, var/mob/user)
	if (get_dist(on_wall,user)>1)
		return FALSE
	var/ndir
	if(reverse)
		ndir = get_dir(user,on_wall)
	else
		ndir = get_dir(on_wall,user)
	if (!(ndir in cardinal))
		return FALSE
	var/turf/loc = get_turf(user)

	if(gotwallitem(loc, ndir))
		to_chat(user, "<span class='danger'>There's already an item on this wall!</span>")
		return FALSE
	return ndir

/obj/item/frame/proc/do_special_build(var/obj/machinery/M)
	return

/obj/item/frame/proc/try_build(turf/on_wall)
	if(!build_machine_type)
		return
	
	var/ndir = check_can_build(on_wall)
	if(!ndir)
		return

	var/obj/machinery/M = new build_machine_type(loc, ndir, 1)
	do_special_build(M)
	M.fingerprints = src.fingerprints
	M.fingerprintshidden = src.fingerprintshidden
	M.fingerprintslast = src.fingerprintslast
	qdel(src)

/*
** FRAME SUBTYPES
*/

/obj/item/frame/alarm/check_can_build(var/turf/on_wall, var/mob/user)
	. = ..()
	var/area/A = loc.loc
	if (!istype(loc, /turf/simulated/floor))
		to_chat(user, "<span class='danger'>\The [src] cannot be placed on this spot.</span>")
		return FALSE
	if (A.requires_power == 0 || A.name == "Space")
		to_chat(user, "<span class='danger'>\The [src] cannot be placed in this area.</span>")
		return FALSE

/obj/item/frame/alarm/fire
	name = "fire alarm frame"
	desc = "Used for building fire alarms."
	build_machine_type = /obj/machinery/firealarm
	reverse = 1

/obj/item/frame/alarm/air
	name = "air alarm frame"
	desc = "Used for building air alarms."
	icon_state = "alarm_bitem"
	build_machine_type = /obj/machinery/alarm

/obj/item/frame/light
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	build_machine_type = /obj/machinery/light_construct
	reverse = 1

/obj/item/frame/light/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	refund_amt = 1
	build_machine_type = /obj/machinery/light_construct/small
