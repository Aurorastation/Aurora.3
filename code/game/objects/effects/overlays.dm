/obj/effect/overlay
	name = "overlay"
	unacidable = 1
	/// Added for possible image attachments to objects. For hallucinations and the like.
	var/i_attached
	/// Prevents janitorial cyborgs from cleaning this effect.
	var/no_clean = FALSE

/obj/effect/overlay/Destroy()
	i_attached = null
	return ..()

/obj/effect/overlay/beam//Not actually a projectile, just an effect.
	name="beam"
	icon='icons/effects/beam.dmi'
	icon_state="b_beam"
	blend_mode = BLEND_ADD
	layer = EFFECTS_ABOVE_LIGHTING_LAYER
	animate_movement = FALSE
	var/tmp/atom/BeamSource

/obj/effect/overlay/palmtree_r
	name = "palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm1"
	density = 1
	layer = ABOVE_HUMAN_LAYER
	anchored = 1


/obj/effect/overlay/palmtree_l
	name = "palm tree"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "palm2"
	density = 1
	layer = ABOVE_HUMAN_LAYER
	anchored = 1


/obj/effect/overlay/coconut
	name = "coconuts"
	icon = 'icons/misc/beach.dmi'
	icon_state = "coconuts"


/obj/effect/overlay/bluespacify
	name = "bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespacify"
	layer = SUPERMATTER_WALL_LAYER

/obj/effect/overlay/temp
	icon_state = "nothing"
	anchored = 1
	layer = 5
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/duration = 10 //in deciseconds
	var/randomdir = TRUE
	var/timerid

/obj/effect/overlay/temp/New()
	..()
	if(randomdir)
		dir = (pick(GLOB.cardinal))
	flick("[icon_state]", src)

	QDEL_IN(src, duration)

/obj/effect/overlay/temp/ex_act(var/severity = 2.0)
	return

/obj/effect/overlay/temp/dir_setting
	randomdir = FALSE

/obj/effect/overlay/temp/dir_setting/New(loc, set_dir)
	if(set_dir)
		dir = set_dir
	..()


/obj/effect/overlay/temp/kinetic_blast
	name = "kinetic explosion"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "kinetic_blast"
	layer = 5
	duration = 4

/obj/effect/overlay/temp/explosion
	name = "explosion"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	pixel_x = -32
	pixel_y = -32
	duration = 8

/obj/effect/overlay/temp/explosion/fast
	icon_state = "explosionfast"
	duration = 4

/obj/effect/overlay/closet_door
	anchored = TRUE
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER
	vis_flags = VIS_INHERIT_ID
	appearance_flags = KEEP_TOGETHER | LONG_GLIDE | PIXEL_SCALE

/obj/effect/overlay/teleport_pulse
	icon = 'icons/effects/effects.dmi'
	icon_state = "emppulse"
	mouse_opacity = FALSE
	anchored = TRUE

/obj/effect/overlay/teleport_pulse/Initialize(mapload, ...)
	. = ..()
	QDEL_IN(src, 8)
