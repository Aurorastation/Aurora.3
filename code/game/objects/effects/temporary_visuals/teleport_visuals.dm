/obj/effect/temp_visual/phase
	icon = 'icons/mob/mob.dmi'
	icon_state = "phasein"
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = 15

/obj/effect/temp_visual/phase/out
	icon_state = "phaseout"

/obj/effect/temp_visual/phase/rift
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "rift"
	layer = BELOW_MOB_LAYER
	alpha = 125

/obj/effect/temp_visual/phase/rift/Initialize(mapload, dir)
	. = ..()
	SpinAnimation()
