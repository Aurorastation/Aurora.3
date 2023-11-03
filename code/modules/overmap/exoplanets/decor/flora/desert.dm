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
	icon = 'icons/obj/flora/desertflora.dmi'
	icon_state = "desert_grass"

/obj/structure/flora/grass/desert/Initialize()
	. = ..()
	icon_state = "desert_grass[rand(1,3)]"

/obj/structure/flora/grass/desert/bush/Initialize()
	. = ..()
	icon_state = "desert_grass_bush[rand(1,4)]"

/obj/structure/flora/rock/desert
	desc = "A sand-swept rock."
	icon = 'icons/obj/flora/desertflora.dmi'
	icon_state = "desert_rock"

/obj/structure/flora/rock/desert/Initialize()
	. = ..()
	icon_state = "desert_rock[rand(1,4)]"

/obj/structure/flora/rock/desert/scrub/Initialize()
	. = ..()
	icon_state = "desert_rock[rand(5,8)]"

/obj/effect/floor_decal/dune
	name = "sand dune"
	icon = 'icons/turf/decals/sand64x32.dmi'
	icon_state = "drift"

/obj/effect/floor_decal/dune/random/Initialize(mapload, newdir, newcolour, bypass, set_icon_state)
	supplied_dir = pick(cardinal)
	. = ..()
