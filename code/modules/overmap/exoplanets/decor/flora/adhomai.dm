//tree

/obj/structure/flora/tree/adhomai
	icon = 'icons/obj/flora/adhomai_trees.dmi'
	icon_state = "tree1"
	pixel_x = -32
	stumptype = /obj/structure/flora/stump/adhomai

/obj/structure/flora/tree/adhomai/Initialize(mapload)
	. = ..()
	icon_state = "tree[rand(1, 12)]"

/obj/structure/flora/stump/adhomai
	icon = 'icons/obj/flora/adhomai_trees.dmi'
	icon_state = "stump"
	pixel_x = -32


//bushes
/obj/structure/flora/bush/adhomai
	icon = 'icons/obj/flora/adhomai_flora.dmi'
	icon_state = "bush1"
	anchored = 1

/obj/structure/flora/bush/adhomai/Initialize(mapload)
	. = ..()
	icon_state = "bush[rand(1, 7)]"

//grass

/obj/structure/flora/grass/adhomai
	icon = 'icons/obj/flora/adhomai_flora.dmi'
	icon_state = "grass1"

/obj/structure/flora/grass/adhomai/Initialize(mapload)
	. = ..()
	icon_state = "grass[rand(1, 4)]"

//rock

/obj/structure/flora/rock/adhomai
	icon = 'icons/obj/flora/adhomai_flora.dmi'
	icon_state = "rock1"

/obj/structure/flora/rock/adhomai/Initialize(mapload)
	. = ..()
	icon_state = "rock[rand(1, 5)]"
