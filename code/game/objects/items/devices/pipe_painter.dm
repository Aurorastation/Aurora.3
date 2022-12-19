/obj/item/device/pipe_painter
	name = "pipe painter"
	icon = 'icons/obj/item/tools/pipe_painter.dmi'
	icon_state = "pipe_painter"
	item_state = "pipe_painter"
	contained_sprite = TRUE
	var/list/modes
	var/mode

/obj/item/device/pipe_painter/New()
	..()
	modes = new()
	for(var/C in pipe_colors)
		modes += "[C]"
	mode = pick(modes)

/obj/item/device/pipe_painter/afterattack(var/atom/A, var/mob/user, proximity)
	if(!proximity)
		return
	if(!in_range(user, A))
		return
	else if(is_type_in_list(A, list(/obj/machinery/atmospherics/pipe/tank, /obj/machinery/atmospherics/pipe/vent, /obj/machinery/atmospherics/pipe/simple/heat_exchanging, /obj/machinery/atmospherics/pipe/simple/insulated)))
		return
	else if(istype(A,/obj/machinery/atmospherics/pipe))
		var/obj/machinery/atmospherics/pipe/P = A
		P.change_color(pipe_colors[mode])
	else if(istype(A, /obj/item/pipe) && pipe_color_check(pipe_colors[mode]))
		var/obj/item/pipe/P = A
		P.color = pipe_colors[mode]

/obj/item/device/pipe_painter/attack_self(var/mob/user)
	mode = input("Which colour do you want to use?", "Pipe painter", mode) in modes

/obj/item/device/pipe_painter/examine(var/mob/user)
	..(user)
	to_chat(user, "It is in [mode] mode.")
