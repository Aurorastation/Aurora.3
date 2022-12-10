/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/modular_console.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1.0
	idle_power_usage = 300
	active_power_usage = 300
	clicksound = /decl/sound_category/keyboard_sound

	var/circuit = null //The path to the circuit board type. If circuit==null, the computer can't be disassembled.
	var/processing = 0

	var/icon_screen = "computer_generic"
	var/icon_scanline
	var/icon_keyboard = "green_key"
	var/light_range_on = 2
	var/light_power_on = 1.3
	var/overlay_layer
	var/is_holographic = TRUE
	var/icon_broken = "broken"

/obj/machinery/computer/Initialize()
	. = ..()
	overlay_layer = layer
	power_change()
	update_icon()

/obj/machinery/computer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	if(inoperable() || isNotStationLevel(z) || user.stat)
		user.unset_machine()
		return

/obj/machinery/computer/emp_act(severity)
	if(prob(20/severity)) set_broken()
	..()


/obj/machinery/computer/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(25))
				qdel(src)
				return
			if (prob(50))
				for(var/x in verbs)
					verbs -= x
				set_broken()
		if(3.0)
			if (prob(25))
				for(var/x in verbs)
					verbs -= x
				set_broken()
		else
	return

/obj/machinery/computer/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.get_structure_damage()))
		set_broken()
	..()

/obj/machinery/computer/update_icon()
	switch(dir)
		if(NORTH)
			layer = ABOVE_MOB_LAYER
		if(SOUTH)
			layer = initial(layer)
		if(EAST)
			layer = ABOVE_MOB_LAYER
		if(WEST)
			layer = ABOVE_MOB_LAYER
	cut_overlays()
	if(stat & NOPOWER)
		set_light(0)
		return
	else
		set_light(light_range_on, light_power_on, light_color)

	icon_state = initial(icon_state)

	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		if (overlay_layer != layer)
			add_overlay(image(icon, icon_broken, overlay_layer))
		else
			add_overlay(icon_broken)
	else if (icon_screen)
		if (is_holographic)
			holographic_overlay(src, src.icon, icon_screen)
		if (icon_scanline)
			add_overlay(icon_scanline)
		if (icon_keyboard)
			add_overlay(icon_keyboard)
		else if (overlay_layer != layer)
			add_overlay(image(icon, icon_screen, overlay_layer))
		else
			add_overlay(icon_screen)

/obj/machinery/computer/power_change()
	..()
	update_icon()
	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(light_range_on, light_power_on, light_color)


/obj/machinery/computer/proc/set_broken()
	stat |= BROKEN
	update_icon()

/obj/machinery/computer/proc/decode(text)
	// Adds line breaks
	text = replacetext(text, "\n", "<BR>")
	return text

/obj/machinery/computer/attackby(var/obj/item/W as obj, user as mob)
	if(W.isscrewdriver() && circuit)
		if(W.use_tool(src, user, 20, volume = 50))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
			var/obj/item/circuitboard/M = new circuit( A )
			A.circuit = M
			A.anchored = 1
			for (var/obj/C in src)
				C.forceMove(src.loc)
			if (src.stat & BROKEN)
				to_chat(user, "<span class='notice'>The broken glass falls out.</span>")
				new /obj/item/material/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				to_chat(user, "<span class='notice'>You disconnect the glass keyboard panel.</span>")
				A.state = 4
				A.icon_state = "4"
			M.deconstruct(src)
			qdel(src)
		return TRUE
	else
		return ..()

/obj/machinery/computer/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (!mover)
		return 1
	if(istype(mover,/obj/item/projectile) && density)
		if (prob(80))
//Holoscreens are non solid, and the frames of the computers are thin. So projectiles will usually
//pass through
			return 1
		else
			return 0
	else if(mover.checkpass(PASSTABLE))
//Animals can run under them, lots of empty space
		return 1
	return ..()

// screens have a layer above, so we can't attach here
/obj/machinery/computer/can_attach_sticker(var/mob/user, var/obj/item/sticker/S)
	to_chat(user, SPAN_WARNING("\The [src]'s non-stick surface prevents you from attaching a sticker to it!"))
	return FALSE
