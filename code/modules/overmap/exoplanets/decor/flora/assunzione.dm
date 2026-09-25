/obj/structure/flora/assunzione
	name = "native Assunzionii flora"
	desc = "One of the species of local plantlife originally native to Assunzione, preserved now only in domes after the Dimming all but flattened the biosphere."
	icon = 'icons/obj/flora/assunzione/grass.dmi'
	icon_state = "stalks"
	layer = BASE_ABOVE_OBJ_LAYER
	anchored = TRUE
	density = FALSE

/obj/structure/flora/assunzione/grass
	name = "grass stalks"
	desc = "Thin and tall stalks of native Assunzionii grasses, soft though slightly rubbery to the touch."

/obj/structure/flora/assunzione/grass/Initialize(mapload)
	. = ..()
	icon_state = "stalks[rand(1, 5)]"

/obj/structure/flora/assunzione/grass/alt
	icon_state = "stalks_alt"

/obj/structure/flora/assunzione/grass/alt/Initialize(mapload)
	. = ..()
	icon_state = "stalks_alt[rand(1, 5)]"

/obj/structure/flora/assunzione/grass/alt
	icon_state = "stalks_alt"

/obj/structure/flora/assunzione/grass/sparse
	icon_state = "sparsegrass_1"

/obj/structure/flora/assunzione/grass/sparse/New()
	..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/assunzione/grass/full
	icon_state = "fullgrass_1"

/obj/structure/flora/assunzione/grass/full/New()
	..()
	icon_state = "fullgrass_[rand(1, 3)]"

/obj/structure/flora/assunzione/flowers
	icon = 'icons/obj/flora/assunzione/flowers.dmi'
	layer = BASE_ABOVE_OBJ_LAYER

/obj/structure/flora/assunzione/flowers/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/assunzione/flowers/lavendergrass/New()
	..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/assunzione/flowers/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/assunzione/flowers/ywflowers/New()
	..()
	icon_state = "ywflowers_[rand(1, 4)]"

/obj/structure/flora/assunzione/flowers/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/assunzione/flowers/brflowers/New()
	..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/assunzione/flowers/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/assunzione/flowers/ppflowers/New()
	..()
	icon_state = "ppflowers_[rand(1, 3)]"

/obj/structure/flora/assunzione/bush
	icon = 'icons/obj/flora/assunzione/bush.dmi'

/obj/structure/flora/assunzione/bush/pale
	icon_state = "palebush_1"

/obj/structure/flora/assunzione/bush/pale/New()
	..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/assunzione/bush/ferny
	icon_state = "fernybush_1"

/obj/structure/flora/assunzione/bush/ferny/New()
	..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/assunzione/bush/lucevine
	name = "luce vine cluster"
	desc = "The namesake plant for Luceism, the light-centric religion of Assunzione, the Luce Vine is a fruiting vine noted for its astounding resilience to cold following the Dimming. \
			The plant and its bioluminscent fruit, called 'luce bulbs', are considered evidence of miracle to devout Assunzioni."
	icon_state = "lvcluster_1"
	light_range = 1.4
	light_power = 1
	light_color = COLOR_CYAN
	layer = BASE_ABOVE_OBJ_LAYER

/obj/structure/flora/assunzione/bush/lucevine/New()
	..()
	icon_state = "lvcluster_[rand(1, 3)]"

/obj/structure/flora/assunzione/bush/lucevine/Initialize(mapload)
	..()
	AddOverlays(emissive_appearance(icon, "[icon_state]-em", src, alpha = src.alpha))
	set_light_range_power_color(light_range, light_power, light_color)
	set_light_on(TRUE)
	return INITIALIZE_HINT_NORMAL
