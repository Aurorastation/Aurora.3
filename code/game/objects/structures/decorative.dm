/obj/structure/ac_unit
	name = "AC unit"
	desc = "A bland air conditioning unit."
	icon = 'icons/obj/structure/miscellaneous.dmi'
	icon_state = "ac"
	layer = BELOW_OBJ_LAYER
	density = TRUE

/obj/structure/television
	name = "wide-screen television"
	desc = "A fancy wide-screen television with a wide selection of channels."
	icon = 'icons/obj/structure/miscellaneous.dmi'
	icon_state = "television"
	anchored = TRUE

/obj/structure/console
	name = "\improper Game-Box"
	desc = "A generic video-games console. For *Gamers*."
	icon = 'icons/obj/structure/miscellaneous.dmi'
	icon_state = "games_console"
	anchored = TRUE

/obj/structure/pylon
	name = "charging pylon"
	desc = "A charging pylon attached to a nearby port."
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_port"
	density = TRUE
	anchored = TRUE

/obj/structure/shelf
	name = "shelf"
	desc = "A nondescript decorative shelf."
	icon = 'icons/obj/structure/miscellaneous.dmi'
	icon_state = "shelf1"

/obj/structure/shelf/Initialize(mapload)
	. = ..()
	icon_state = "shelf[pick(1,2,3)]"

/obj/structure/outlet
	name = "power outlets"
	desc = "The *other* kind of power-point."
	icon = 'icons/obj/structure/miscellaneous.dmi'
	icon_state = "outlet"
	layer = LAYER_UNDER_TABLE

/obj/structure/vent
	name = "wall vent"
	desc = "A nondescript vent."
	icon = 'icons/obj/structure/miscellaneous.dmi'
	icon_state = "vent"
	layer = LAYER_UNDER_TABLE

/obj/structure/window
	name = "window"
	desc = "Lets the light in and keeps the bugs out."
	icon = 'icons/obj/structure/miscellaneous.dmi'
	icon_state = "window"

// 64x64 stuff

/obj/structure/beach_umbrella
	name = "overhead beach umbrella"
	desc = "A tightly secured beach umbrella which looks pretty elegant against the sun."
	icon = 'icons/obj/structure/64x64_misc.dmi'
	icon_state = "umbrella"
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/beach_umbrella/alt
	icon_state = "umbrella_alt"

/obj/structure/crane
	name = "overhead guiding crane"
	desc = "A towering crane for lifting industrial sized cargo."
	icon = 'icons/obj/structure/64x64_machinery.dmi'
	icon_state = "crane"
	anchored = TRUE
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/crane/body
	icon_state = "crane_body"
	density = FALSE

/obj/structure/crane/arm
	icon_state = "crane_arm"
	density = FALSE
