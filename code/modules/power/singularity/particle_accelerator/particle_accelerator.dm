//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/*Composed of 7 parts
3 Particle emitters
proc
emit_particle()

1 power box
the only part of this thing that uses power, can hack to mess with the pa/make it better.
Lies, only the control computer draws power.

1 fuel chamber
contains procs for mixing gas and whatever other fuel it uses
mix_gas()

1 gas holder WIP
acts like a tank valve on the ground that you wrench gas tanks onto
proc
extract_gas()
return_gas()
attach_tank()
remove_tank()
get_available_mix()

1 End Cap

1 Control computer
interface for the pa, acts like a computer with an html menu for diff parts and a status report
all other parts contain only a ref to this
a /machine/, tells the others to do work
contains ref for all parts
proc
process()
check_build()

Setup map
  |EC|
CC|FC|
  |PB|
PE|PE|PE


Icon Addemdum
Icon system is much more robust, and the icons are all variable based.
Each part has a reference string, powered, strength, and contruction values.
Using this the update_icon() proc is simplified a bit (using for absolutely was problematic with naming),
so the icon_state comes out be:
"[reference][strength]", with a switch controlling construction_states and ensuring that it doesn't
power on while being contructed, and all these variables are set by the computer through it's scan list
Essential order of the icons:
Standard - [reference]
Wrenched - [reference]
Wired    - [reference]w
Closed   - [reference]c
Powered  - [reference]p[strength]
Strength being set by the computer and a null strength (Computer is powered off or inactive) returns a 'null', counting as empty
So, hopefully this is helpful if any more icons are to be added/changed/wondering what the hell is going on here

*/

/obj/structure/particle_accelerator
	name = "Particle Accelerator"
	desc = "Part of a Particle Accelerator."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	anchored = FALSE
	density = TRUE
	obj_flags = OBJ_FLAG_ROTATABLE
	var/obj/machinery/particle_accelerator/control_box/master
	var/construction_state = 0
	var/reference
	var/powered = 0
	var/strength

/obj/structure/particle_accelerator/Destroy()
	construction_state = 0
	if(master)
		master.part_scan()
	return ..()

/obj/structure/particle_accelerator/end_cap
	name = "Alpha Particle Generation Array"
	desc = "This is where Alpha particles are generated from \[REDACTED\]."
	icon_state = "end_cap"
	reference = "end_cap"

/obj/structure/particle_accelerator/examine(mob/user)
	switch(construction_state)
		if(0)
			desc = "[initial(desc)] Looks like it's not attached to the flooring."
		if(1)
			desc = "[initial(desc)] It's missing some cables."
		if(2)
			desc = "[initial(desc)] The panel is open."
		if(3)
			desc = "[initial(desc)] It seems completely assembled."
			if(powered)
				desc = initial(desc)
	..()
	return

/obj/structure/particle_accelerator/attackby(obj/item/W, mob/user)
	if(istool(W))
		if(process_tool_hit(W, user))
			return
	..()
	return


/obj/structure/particle_accelerator/Move()
	..()
	if(master && master.active)
		master.toggle_power()
		investigate_log("was moved whilst active; it <font color='red'>powered down</font>.","singulo")

/obj/structure/particle_accelerator/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				qdel(src)
				return
		else
	return

/obj/structure/particle_accelerator/update_icon()
	switch(construction_state)
		if(0, 1)
			icon_state="[reference]"
		if(2)
			icon_state="[reference]w"
		if(3)
			if(powered)
				icon_state="[reference]p[strength]"
			else
				icon_state="[reference]c"
	return

/obj/structure/particle_accelerator/proc/update_state()
	if(master)
		master.update_state()
		return FALSE


/obj/structure/particle_accelerator/proc/report_ready(var/obj/O)
	if(O && (O == master))
		if(construction_state >= 3)
			return TRUE
	return FALSE


/obj/structure/particle_accelerator/proc/report_master()
	if(master)
		return master
	return FALSE


/obj/structure/particle_accelerator/proc/connect_master(var/obj/O)
	if(istype(O, /obj/machinery/particle_accelerator/control_box))
		if(O.dir == src.dir)
			master = O
			return TRUE
	return FALSE


/obj/structure/particle_accelerator/proc/process_tool_hit(var/obj/O, var/mob/user)
	if(!O || !user)
		return FALSE
	if(!ismob(user) || !isobj(O))
		return FALSE
	var/temp_state = construction_state

	switch(construction_state)//TODO:Might be more interesting to have it need several parts rather than a single list of steps
		if(0)
			if(O.iswrench())
				playsound(get_turf(src), O.usesound, 75, TRUE)
				anchored = TRUE
				user.visible_message(SPAN_NOTICE("\The [user] secures \the [src] to the floor."), \
					SPAN_NOTICE("You secure the external bolts."))
				temp_state++
		if(1)
			if(O.iswrench())
				playsound(get_turf(src), O.usesound, 75, TRUE)
				anchored = FALSE
				user.visible_message(SPAN_NOTICE("\The [user] detaches \the [src] from the floor."), \
					SPAN_NOTICE("You remove the external bolts."))
				temp_state--
			else if(O.iscoil())
				var/obj/item/stack/cable_coil/C = O
				if(C.use(1))
					user.visible_message(SPAN_NOTICE("\The [user] adds wires to \the [src]."), \
						SPAN_NOTICE("You add some wires."))
					temp_state++
		if(2)
			if(O.iswirecutter())//TODO:Shock user if its on?
				user.visible_message(SPAN_NOTICE("\The [user] removes some wires from \the [src]."), \
					SPAN_NOTICE("You remove some wires."))
				temp_state--
			else if(O.isscrewdriver())
				user.visible_message(SPAN_NOTICE("\The [user] closes \the [src]'s access panel."), \
					SPAN_NOTICE("You close the access panel."))
				temp_state++
		if(3)
			if(O.isscrewdriver())
				user.visible_message(SPAN_NOTICE("\The [user] opens \the [src]'s access panel."), \
					SPAN_NOTICE("You open the access panel."))
				temp_state--
	if(temp_state == construction_state)//Nothing changed
		return FALSE
	else
		construction_state = temp_state
		if(construction_state < 3)//Was taken apart, update state
			update_state()
		update_icon()
		return TRUE
	return FALSE


/obj/machinery/particle_accelerator
	name = "Particle Accelerator"
	desc = "Part of a Particle Accelerator."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	anchored = FALSE
	density = TRUE
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	var/construction_state = 0
	var/active = FALSE
	var/reference
	var/powered
	var/strength = 0

/obj/machinery/particle_accelerator/update_icon()
	return

/obj/machinery/particle_accelerator/examine(mob/user)
	switch(construction_state)
		if(0)
			desc = "[initial(desc)] Looks like it's not attached to the flooring."
		if(1)
			desc = "[initial(desc)] It's missing some cables."
		if(2)
			desc = "[initial(desc)] The panel is open."
		if(3)
			desc = "[initial(desc)] It seems completely assembled."
			if(powered)
				desc = initial(desc)
	..()
	return


/obj/machinery/particle_accelerator/attackby(obj/item/W, mob/user)
	if(istool(W))
		if(process_tool_hit(W,user))
			return
	..()
	return

/obj/machinery/particle_accelerator/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				qdel(src)
			return
		else
	return

/obj/machinery/particle_accelerator/proc/update_state()
	return FALSE

/obj/machinery/particle_accelerator/proc/process_tool_hit(var/obj/O, var/mob/user)
	if(!O || !user)
		return FALSE
	if(!ismob(user) || !isobj(O))
		return FALSE
	var/temp_state = construction_state
	switch(construction_state)//TODO:Might be more interesting to have it need several parts rather than a single list of steps
		if(0)
			if(O.iswrench())
				playsound(get_turf(src), O.usesound, 75, TRUE)
				anchored = TRUE
				user.visible_message(SPAN_NOTICE("\The [user] secures \the [src] to the floor."), \
					SPAN_NOTICE("You secure the external bolts."))
				temp_state++
		if(1)
			if(O.iswrench())
				playsound(get_turf(src), O.usesound, 75, TRUE)
				anchored = FALSE
				user.visible_message(SPAN_NOTICE("\The [user] detaches \the [src] from the floor."), \
					SPAN_NOTICE("You remove the external bolts."))
				temp_state--
			else if(O.iscoil())
				var/obj/item/stack/cable_coil/C = O
				if(C.use(1))
					user.visible_message(SPAN_NOTICE("\The [user] removes some wires from \the [src]."), \
						SPAN_NOTICE("You remove some wires."))
					temp_state++
		if(2)
			if(O.iswirecutter())//TODO:Shock user if its on?
				user.visible_message(SPAN_NOTICE("\The [user] removes some wires from \the [src]."), \
					SPAN_NOTICE("You remove some wires."))
				temp_state--
			else if(O.isscrewdriver())
				user.visible_message(SPAN_NOTICE("\The [user] closes \the [src]'s access panel."), \
					SPAN_NOTICE("You close the access panel."))
				temp_state++
		if(3)
			if(O.isscrewdriver())
				user.visible_message(SPAN_NOTICE("\The [user] opens \the [src]'s access panel."), \
					SPAN_NOTICE("You open the access panel."))
				temp_state--
				active = FALSE
	if(temp_state == construction_state)//Nothing changed
		return FALSE
	else
		if(construction_state < 3)//Was taken apart, update state
			update_state()
			if(use_power)
				use_power = 0
		construction_state = temp_state
		if(construction_state >= 3)
			use_power = 1
		update_icon()
		return TRUE
	return FALSE