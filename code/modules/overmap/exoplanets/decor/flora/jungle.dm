/obj/structure/flora/grass/junglegrass
	name = "jungle grass"
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "grassb"
	density = FALSE

/obj/structure/flora/grass/junglegrass/random/Initialize(mapload, newdir, newcolour, bypass, set_icon_state)
	icon_state = "grassb[rand(1,5)]"
	. = ..()

/obj/structure/flora/grass/junglegrass/dense
	icon_state = "grassa"

/obj/structure/flora/grass/junglegrass/dense/random/Initialize(mapload, newdir, newcolour, bypass, set_icon_state)
	icon_state = "grassa[rand(1,5)]"
	. = ..()

/obj/structure/flora/grass/junglegrass/rocky
	icon_state = "rock"

/obj/structure/flora/grass/junglegrass/rocky/random/Initialize(mapload, newdir, newcolour, bypass, set_icon_state)
	icon_state = "rock[rand(1,5)]"
	. = ..()

/obj/structure/flora/bush/jungle
	name = "jungle fern"
	desc = "A leafy, squat plant, accustomed to the forest floor."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "busha"

/obj/structure/flora/bush/jungle/large
	name = "large jungle fern"
	desc = "A lush and oversized plant, clearly thriving in the jungle."
	icon = 'icons/obj/flora/largejungleflora.dmi'
	icon_state = "bush"
	pixel_x = -16
	pixel_y = -16
	layer = ABOVE_HUMAN_LAYER

/obj/structure/flora/bush/jungle/large/random/Initialize()
	. = ..()
	icon_state = "bush[rand(1,3)]"

/obj/structure/flora/bush/jungle/b
	icon_state = "bushb"

/obj/structure/flora/bush/jungle/c
	icon_state = "bushc"

/obj/structure/flora/bush/jungle/random/Initialize()
	. = ..()
	icon_state = "busha[rand(1,3)]"

/obj/structure/flora/bush/jungle/b/random/Initialize()
	. = ..()
	icon_state = "bushb[rand(1,3)]"

/obj/structure/flora/bush/jungle/c/random/Initialize()
	. = ..()
	icon_state = "bushc[rand(1,3)]"

//Jungle grass
/obj/structure/flora/grass/jungle
	name = "jungle grass"
	desc = "Thick alien flora."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "grassa"

/obj/structure/flora/grass/jungle/b
	icon_state = "grassb"

/obj/structure/flora/tree/jungle
	name = "tree"
	icon_state = "tree"
	desc = "A lush and healthy tree."
	icon = 'icons/obj/flora/jungletrees.dmi'
	pixel_x = -48
	pixel_y = -20

/obj/structure/flora/tree/jungle/random/Initialize(mapload)
	. = ..()
	icon_state = "tree[rand(1,6)]"

/obj/structure/flora/tree/jungle/small
	pixel_y = 0
	pixel_x = -32
	icon = 'icons/obj/flora/jungletreesmall.dmi'

/obj/structure/flora/tree/jungle/small/random/Initialize(mapload)
	. = ..()
	icon_state = "tree[rand(1,6)]"

/obj/structure/flora/tree/jungle/small/patience
	name = "Patience"
	desc = "A lush and healthy tree. A small golden plaque at its base reads its name, in plain text, Patience."
	icon_state = "patiencebottom"
	density = FALSE
	layer = 3

/obj/structure/flora/tree/jungle/small/patience_top
	name = "Patience"
	desc = "A lush and healthy tree. A small golden plaque at its base reads its name, in plain text, Patience."
	icon_state = "patiencetop"
	density = TRUE
	pixel_y = -32

/obj/structure/flora/tree/jungle/small/patience/Initialize()
	. = ..()
	var/turf/T = get_step(src, NORTH)
	if(T)
		new /obj/structure/flora/tree/jungle/small/patience_top(T)
