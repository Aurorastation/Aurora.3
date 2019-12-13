/obj/machinery/mineralconsole
	var/obj/machinery/mineral/machine = null

/obj/machinery/mineralconsole/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	else if(default_deconstruction_crowbar(user, I))
		return

/obj/machinery/mineralconsole/Initialize()
	pixel_x = -DIR2PIXEL_X(dir)
	pixel_y = -DIR2PIXEL_Y(dir)
	set_expansion(/datum/expansion/multitool, new/datum/expansion/multitool/mineral(src, list(/proc/is_operable)))
	. = ..()

/obj/machinery/mineralconsole/proc/LinkTo(obj/machinery/mineral/M)
	if(!istype(M))
		return
	Unlink()
	machine = M
	machine.console = src
	return 1

/obj/machinery/mineralconsole/proc/Unlink()
	if(!machine)
		return
	machine.console = null
	machine = null
	return 1