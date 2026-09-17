/obj/structure/moghes_ruin
	name = "giant pillar"
	desc = "A decrepit stone pillar."
	icon = 'icons/effects/props/holodeck/moghes/32x64.dmi'
	icon_state = "pillar1"
	layer = ABOVE_HUMAN_LAYER
	density = TRUE

/obj/structure/moghes_ruin/variant
	icon_state = "pillar2"

/obj/structure/moghes_ruin/torch
	icon_state = "pillar_torch"
	light_range = 6
	light_power = 1
	light_color = "#FA644B"

/obj/structure/moghes_ruin/flag
	name = "Karszekani Moghes flag"
	desc = "The proudly waving flag of the Izweski Nation."
	icon_state = "flag"
	density = FALSE

/obj/structure/moghes_ruin/giant
	name = "giant overgrown pillar"
	desc = "A vine-covered, decrepit stone pillar."
	icon = 'icons/effects/props/holodeck/moghes/64x128.dmi'
	icon_state = "arch_r"

/obj/structure/moghes_ruin/giant/l
	icon_state = "arch_l"

/obj/structure/moghes_ruin/giant/centre
	name = "The Faces of Sk'akh"
	desc = "A vine-covered shrine to the three faces of Sk'akh, a prominent faith in the Unathi people."
	icon_state = "arch_center"
	density = FALSE // It's up in the air!

/obj/structure/moghes_ruin/rubble
	name = "rubble"
	desc = "A few small, broken pieces of stone."
	icon = 'icons/effects/props/holodeck/moghes/32x32.dmi'
	icon_state = "rubble1"
	layer = ABOVE_TILE_LAYER
	density = FALSE

/obj/structure/moghes_ruin/rubble/variant
	icon_state = "rubble2"
