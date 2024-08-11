//temporary visual effects
/obj/effect/temp_visual
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/duration = 10 //in deciseconds
	var/randomdir = TRUE

/obj/effect/temp_visual/Initialize(mapload, var/new_dir)
	. = ..()

	if(new_dir)
		set_dir(new_dir)
	else if(randomdir)
		set_dir(pick(GLOB.cardinal))

	QDEL_IN(src, duration)

/obj/effect/temp_visual/singularity_act()
	return

/obj/effect/temp_visual/singularity_pull()
	return

/obj/effect/temp_visual/ex_act(var/severity = 2.0)
	return

/obj/effect/temp_visual/dir_setting
	randomdir = FALSE

/obj/effect/temp_visual/dir_setting/Initialize(mapload, set_dir)
	if(set_dir)
		set_dir(set_dir)
	. = ..()
