/obj/structure/flora/tree/desert
	name = "cactus tree"
	icon = 'icons/obj/flora/desert_cactus_trees.dmi'
	icon_state = "desert_tree"
	desc = "A prickly cactus with a woody trunk."

/obj/structure/flora/tree/desert/Initialize(mapload)
	. = ..()
	icon_state = "desert_tree[rand(1,2)]"

/obj/structure/flora/tree/desert/small/Initialize(mapload)
	. = ..()
	icon_state = "desert_tree[rand(3,4)]"

/obj/structure/flora/tree/desert/tiny/Initialize(mapload)
	. = ..()
	icon_state = "desert_tree[rand(5,6)]"

/obj/structure/flora/grass/desert
	name = "desert grass"
	desc = "Alien scrubland."
	icon = 'icons/turf/desert_color_tweak.dmi'
	icon_state = "desert_grass"

/obj/structure/flora/grass/desert/Initialize()
	. = ..()
	icon_state = "desert_grass[rand(1,3)]"

/obj/structure/flora/grass/desert/bush/Initialize()
	. = ..()
	icon_state = "desert_grass_bush[rand(1,4)]"

/obj/structure/flora/rock/desert
	desc = "A sand-swept rock."
	icon = 'icons/turf/desert_color_tweak.dmi'
	icon_state = "desert_rock"

/obj/structure/flora/rock/desert/Initialize()
	. = ..()
	icon_state = "desert_rock[rand(1,4)]"

/obj/structure/flora/rock/desert/scrub/Initialize()
	. = ..()
	icon_state = "desert_rock[rand(5,8)]"
