/obj/effect/elevator
	name = "\proper empty space"
	desc = "There seems to be an awful lot of machinery down below..."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "supply_elevator_lowered"
	unacidable = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = DECAL_LAYER
	appearance_flags = KEEP_TOGETHER

/obj/effect/elevator/ex_act(severity)
	return

/obj/effect/elevator/animation_overlay
	icon_state = null
	blend_mode = BLEND_INSET_OVERLAY
	appearance_flags = KEEP_TOGETHER
