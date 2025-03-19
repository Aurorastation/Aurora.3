/obj/item/device/pipe_painter
	name = "pipe painter"
	icon = 'icons/obj/item/device/pipe_painter.dmi'
	icon_state = "pipe_painter"
	item_state = "pipe_painter"
	var/list/modes
	var/mode

/obj/item/device/pipe_painter/New()
	..()
	modes = new()
	for(var/C in GLOB.pipe_colors)
		modes += "[C]"
	mode = pick(modes)

/obj/item/device/pipe_painter/afterattack(var/atom/A, var/mob/user, proximity)
	if(!proximity)
		return
	if(!in_range(user, A))
		return
	else if(is_type_in_list(A, list(/obj/machinery/atmospherics/pipe/tank, /obj/machinery/atmospherics/pipe/simple/heat_exchanging)))
		return
	else if(istype(A,/obj/machinery/atmospherics/pipe))
		var/obj/machinery/atmospherics/pipe/P = A
		P.change_color(GLOB.pipe_colors[mode])
	else if(istype(A, /obj/item/pipe) && pipe_color_check(GLOB.pipe_colors[mode]))
		var/obj/item/pipe/P = A
		P.color = GLOB.pipe_colors[mode]

/obj/item/device/pipe_painter/attack_self(var/mob/user)
	mode = tgui_input_list(user, "Which colour do you want to use?", "Pipe Painter", modes, mode)

/obj/item/device/pipe_painter/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. +=  "It is in [mode] mode."
