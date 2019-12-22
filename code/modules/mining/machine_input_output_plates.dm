/obj/machinery/mineral
	var/obj/machinery/hopper/input/input = null
	var/obj/machinery/hopper/output/output = null
	var/obj/machinery/mineralconsole/console = null

/obj/machinery/mineral/Initialize()
	. = ..()
	set_expansion(/datum/expansion/multitool, new/datum/expansion/multitool/store(src))

/obj/machinery/mineral/proc/FindInOut()
	for (var/dir in cardinal)
		var/obj/machinery/hopper/input/I = locate(/obj/machinery/hopper/input, get_step(src, dir))
		if(I)
			I.LinkTo(src)
			break
	for (var/dir in cardinal)
		var/obj/machinery/hopper/output/O = locate(/obj/machinery/hopper/output, get_step(src, dir))
		if(O)
			O.LinkTo(src)
			break

/obj/machinery/mineral/Destroy()
	if(src.input)
		src.input.Unlink()
	if(src.output)
		src.output.Unlink()
	if(src.console)
		src.console.Unlink()
	return ..()

/**********************Input and output plates**************************/

/obj/machinery/hopper
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_frame_0_0"
	density = 0
	anchored = 1.0
	var/obj/machinery/mineral/linked = null
	var/io

/obj/machinery/hopper/Initialize()
	. = ..()
	if(linked || !io)
		return
	for (var/dir in cardinal)
		var/obj/machinery/mineral/MM = locate(/obj/machinery/mineral/, get_step(src, dir))
		if(MM && (io in MM.vars) && !MM.vars[io])
			LinkTo(MM)
			break

/obj/machinery/hopper/proc/LinkTo(obj/machinery/mineral/MM)
	linked = MM

/obj/machinery/hopper/proc/Unlink()
	if(linked && io && io in linked.vars)
		linked.vars[io] = null
	linked = null
	return ..()

/obj/machinery/hopper/dismantle()
	playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
	new /obj/item/stack/material/steel(src.loc, 5)
	qdel(src)
	return 1

/obj/machinery/hopper/attackby(obj/item/W, mob/user)
	if(iscrowbar(W))
		to_chat(user, span("notice", "You dismantle [src]."))
		dismantle()
		return 1
	. = ..()

/obj/machinery/hopper/Destroy()
	Unlink()
	return ..()

/**********************Input plates**************************/

/obj/machinery/hopper/input
	name = "input hopper"
	io = "output"

/**********************Output plates**************************/

/obj/machinery/hopper/output
	name = "output hopper"
	io = "output"