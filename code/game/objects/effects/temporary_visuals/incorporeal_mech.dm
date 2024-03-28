/obj/effect/temp_visual/incorporeal_mech
	layer = LYING_HUMAN_LAYER
	randomdir = FALSE

/obj/effect/temp_visual/incorporeal_mech/Initialize(mapload, new_dir, var/mob/living/heavy_vehicle/HV)
	. = ..()
	appearance = HV.appearance
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	opacity = FALSE
	animate(src, time = duration, alpha = 0)
