/obj/machinery/pipedispenser
	name = "pipe dispenser"
	desc = "A large piece of machinery used to dispense pipes that transport and manipulate gasses."
	desc_info = "This can be moved by using a wrench.  You will need to wrench it again when you want to use it.  You can put \
	excess (atmospheric) pipes into the dispenser, as well.  It needs electricity to function."
	icon = 'icons/obj/pipe_dispenser.dmi'
	icon_state = "pipe_dispenser"
	density = TRUE
	anchored = TRUE

	var/window_id = "pipedispenser"
	var/pipe_cooldown = 0

/obj/machinery/pipedispenser/attack_hand(mob/user)
	if(..())
		return

	var/dat = {"
		<b>Regular pipes:</b><BR>
		<A href='?src=\ref[src];make=0;dir=1'>Pipe</A><BR>
		<A href='?src=\ref[src];make=1;dir=5'>Bent Pipe</A><BR>
		<A href='?src=\ref[src];make=5;dir=1'>Manifold</A><BR>
		<A href='?src=\ref[src];make=8;dir=1'>Manual Valve</A><BR>
		<A href='?src=\ref[src];make=20;dir=1'>Pipe Cap</A><BR>
		<A href='?src=\ref[src];make=19;dir=1'>4-Way Manifold</A><BR>
		<A href='?src=\ref[src];make=18;dir=1'>Manual T-Valve</A><BR>
		<A href='?src=\ref[src];make=43;dir=1'>Manual T-Valve - Mirrored</A><BR>
		<A href='?src=\ref[src];make=21;dir=1'>Upward Pipe</A><BR>
		<A href='?src=\ref[src];make=22;dir=1'>Downward Pipe</A><BR>
		<b>Supply pipes:</b><BR>
		<A href='?src=\ref[src];make=29;dir=1'>Pipe</A><BR>
		<A href='?src=\ref[src];make=30;dir=5'>Bent Pipe</A><BR>
		<A href='?src=\ref[src];make=33;dir=1'>Manifold</A><BR>
		<A href='?src=\ref[src];make=41;dir=1'>Pipe Cap</A><BR>
		<A href='?src=\ref[src];make=35;dir=1'>4-Way Manifold</A><BR>
		<A href='?src=\ref[src];make=37;dir=1'>Upward Pipe</A><BR>
		<A href='?src=\ref[src];make=39;dir=1'>Downward Pipe</A><BR>
		<b>Scrubbers pipes:</b><BR>
		<A href='?src=\ref[src];make=31;dir=1'>Pipe</A><BR>
		<A href='?src=\ref[src];make=32;dir=5'>Bent Pipe</A><BR>
		<A href='?src=\ref[src];make=34;dir=1'>Manifold</A><BR>
		<A href='?src=\ref[src];make=42;dir=1'>Pipe Cap</A><BR>
		<A href='?src=\ref[src];make=36;dir=1'>4-Way Manifold</A><BR>
		<A href='?src=\ref[src];make=38;dir=1'>Upward Pipe</A><BR>
		<A href='?src=\ref[src];make=40;dir=1'>Downward Pipe</A><BR>
		<b>Devices:</b><BR>
		<A href='?src=\ref[src];make=28;dir=1'>Universal pipe adapter</A><BR>
		<A href='?src=\ref[src];make=4;dir=1'>Connector</A><BR>
		<A href='?src=\ref[src];make=7;dir=1'>Unary Vent</A><BR>
		<A href='?src=\ref[src];make=9;dir=1'>Gas Pump</A><BR>
		<A href='?src=\ref[src];make=15;dir=1'>Pressure Regulator</A><BR>
		<A href='?src=\ref[src];make=44;dir=1'>Scrubbers Pressure Regulator</A><BR>
		<A href='?src=\ref[src];make=45;dir=1'>Supply Pressure Regulator</A><BR>
		<A href='?src=\ref[src];make=16;dir=1'>High Power Gas Pump</A><BR>
		<A href='?src=\ref[src];make=10;dir=1'>Scrubber</A><BR>
		<A href='?src=\ref[src];makemeter=1'>Meter</A><BR>
		<A href='?src=\ref[src];make=13;dir=1'>Gas Filter</A><BR>
		<A href='?src=\ref[src];make=23;dir=1'>Gas Filter - Mirrored</A><BR>
		<A href='?src=\ref[src];make=14;dir=1'>Gas Mixer</A><BR>
		<A href='?src=\ref[src];make=25;dir=1'>Gas Mixer - Mirrored</A><BR>
		<A href='?src=\ref[src];make=24;dir=1'>Gas Mixer - T</A><BR>
		<A href='?src=\ref[src];make=26;dir=1'>Omni Gas Mixer</A><BR>
		<A href='?src=\ref[src];make=27;dir=1'>Omni Gas Filter</A><BR>
		<b>Heat exchange:</b><BR>
		<A href='?src=\ref[src];make=2;dir=1'>Pipe</A><BR>
		<A href='?src=\ref[src];make=3;dir=5'>Bent Pipe</A><BR>
		<A href='?src=\ref[src];make=6;dir=1'>Junction</A><BR>
		<A href='?src=\ref[src];make=17;dir=1'>Heat Exchanger</A><BR>
		<b>Insulated pipes:</b><BR>
		<A href='?src=\ref[src];make=11;dir=1'>Pipe</A><BR>
		<A href='?src=\ref[src];make=12;dir=5'>Bent Pipe</A><BR>
	"}
	//What number the make points to is in the define # at the top of construction.dm in same folder

	var/datum/browser/pipedispenser_win = new(user, window_id, capitalize_first_letters(name), 220, 500)
	pipedispenser_win.set_content(dat)
	pipedispenser_win.open()

/obj/machinery/pipedispenser/Topic(href, href_list)
	if(..())
		return

	if(!anchored || use_check_and_message(usr))
		usr << browse(null, "window=[window_id]")
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(pipe_cooldown > world.time)
		return

	if(href_list["make"])
		var/obj/item/pipe/P = new(loc, text2num(href_list["make"]), text2num(href_list["dir"]))
		P.update()
		P.add_fingerprint(usr)
		pipe_cooldown = world.time + 1 SECOND

	if(href_list["makemeter"])
		new /obj/item/pipe_meter(loc)
		pipe_cooldown = world.time + 1.5 SECONDS

/obj/machinery/pipedispenser/attackby(obj/item/I, mob/user)
	if(!istype(I, /obj/item/forensics))
		add_fingerprint(user)
	if(istype(I, /obj/item/pipe) || istype(I, /obj/item/pipe_meter))
		to_chat(usr, SPAN_NOTICE("You put \the [I] back into \the [src]."))
		user.remove_from_mob(I) //Catches robot gripper duplication
		qdel(I)
		return
	else if(I.iswrench())
		playsound(get_turf(user), I.usesound, 50, 1)
		if(anchored)
			to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src] from the floor..."))
			if(do_after(user, 40 / I.toolspeed))
				user.visible_message("<b>[user]</b> unfastens \the [src].", SPAN_NOTICE("You have unfastened \the [src]. Now it can be pulled somewhere else."), SPAN_NOTICE("You hear ratcheting noise."))
				anchored = FALSE
				stat |= MAINT
				if(usr.machine == src)
					usr << browse(null, "window=[window_id]")
		else
			to_chat(user, SPAN_NOTICE("You begin to fasten \the [src] to the floor..."))
			if(do_after(user, 20 / I.toolspeed))
				user.visible_message("<b>[user]</b> fastens \the [src].", SPAN_NOTICE("You have fastened \the [src]. Now it can dispense pipes."), SPAN_NOTICE("You hear ratcheting noise."))
				anchored = TRUE
				stat &= ~MAINT
				power_change()
	else
		return ..()

/obj/machinery/pipedispenser/disposal
	name = "disposal pipe dispenser"
	desc = "A large piece of machinery used to dispense pipes that transport and manipulate objects."
	desc_info = "This can be moved by using a wrench.  You will need to wrench it again when you want to use it.  You can put \
	excess disposal pipes into the dispenser by dragging them onto it.  It needs electricity to function."
	icon_state = "disposal_dispenser"
	window_id = "disposaldispenser"

//Allow you to drag-drop disposal pipes into it
/obj/machinery/pipedispenser/disposal/MouseDrop_T(obj/structure/disposalconstruct/pipe, mob/user)
	if(!istype(pipe) || pipe.anchored || use_check_and_message(user))
		return

	qdel(pipe)

/obj/machinery/pipedispenser/disposal/attack_hand(mob/user)
	if(..())
		return

	var/dat = {"<b>Disposal Pipes</b><br><br>
		<A href='?src=\ref[src];dmake=0'>Pipe</A><BR>
		<A href='?src=\ref[src];dmake=1'>Bent Pipe</A><BR>
		<A href='?src=\ref[src];dmake=2'>Junction</A><BR>
		<A href='?src=\ref[src];dmake=3'>Y-Junction</A><BR>
		<A href='?src=\ref[src];dmake=4'>Trunk</A><BR>
		<A href='?src=\ref[src];dmake=5'>Bin</A><BR>
		<A href='?src=\ref[src];dmake=13'>Bin (Small)</A><BR>
		<A href='?src=\ref[src];dmake=6'>Outlet</A><BR>
		<A href='?src=\ref[src];dmake=7'>Chute</A><BR>
		<A href='?src=\ref[src];dmake=21'>Upwards</A><BR>
		<A href='?src=\ref[src];dmake=22'>Downwards</A><BR>
		<A href='?src=\ref[src];dmake=8'>Sorting</A><BR>
		<A href='?src=\ref[src];dmake=9'>Sorting (Wildcard)</A><BR>
		<A href='?src=\ref[src];dmake=10'>Sorting (Untagged)</A><BR>
		<A href='?src=\ref[src];dmake=11'>Tagger</A><BR>
		<A href='?src=\ref[src];dmake=12'>Tagger (Partial)</A><BR>
	"}

	var/datum/browser/disposaldispenser_win = new(user, window_id, capitalize_first_letters(name), 220, 500)
	disposaldispenser_win.set_content(dat)
	disposaldispenser_win.open()

// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/machinery/pipedispenser/disposal/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(!anchored || use_check_and_message(usr))
		usr << browse(null, "window=[window_id]")
		return

	if(pipe_cooldown > world.time)
		return

	if(href_list["dmake"])
		var/p_type = text2num(href_list["dmake"])
		var/obj/structure/disposalconstruct/C = new(loc)
		switch(p_type)
			if(0)
				C.ptype = 0
			if(1)
				C.ptype = 1
			if(2)
				C.ptype = 2
			if(3)
				C.ptype = 4
			if(4)
				C.ptype = 5
			if(5)
				C.ptype = 6
				C.density = 1
			if(6)
				C.ptype = 7
				C.density = 1
			if(7)
				C.ptype = 8
				C.density = 1
			if(8)
				C.ptype = 9
				C.subtype = 0
			if(9)
				C.ptype = 9
				C.subtype = 1
			if(10)
				C.ptype = 9
				C.subtype = 2
			if(11)
				C.ptype = 13
			if(12)
				C.ptype = 14
			if(13)
				C.ptype = 15
			if(21)
				C.ptype = 11
			if(22)
				C.ptype = 12
		C.add_fingerprint(usr)
		C.update()
		pipe_cooldown = world.time + 1.5 SECONDS

// adding a pipe dispensers that spawn unhooked from the ground
/obj/machinery/pipedispenser/orderable
	anchored = FALSE

/obj/machinery/pipedispenser/disposal/orderable
	anchored = FALSE