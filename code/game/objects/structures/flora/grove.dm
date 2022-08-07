//tree

/obj/structure/flora/tree/grove
	icon = 'icons/obj/flora/grove_trees.dmi'
	icon_state = "grove_tree1"

/obj/structure/flora/tree/grove/New()
	..()
	icon_state = "grove_tree[rand(1, 6)]"

//bushes
/obj/structure/flora/bush/grove
	icon = 'icons/obj/flora/groveflora.dmi'
	icon_state = "grove_bush1"
	anchored = 1

/obj/structure/flora/bush/grove/New()
	..()
	icon_state = "grove_bush[rand(1, 4)]"

//clutter
/obj/structure/flora/clutter
	name = "clutter"
	icon = 'icons/obj/flora/groveflora.dmi'
	icon_state = "grove_clutter1"
	anchored = 1

/obj/structure/flora/clutter/New()
	..()
	icon_state = "grove_clutter[rand(1, 9)]"

//stalks
/obj/structure/flora/stalks
	name = "stalks"
	icon = 'icons/obj/flora/groveflora.dmi'
	icon_state = "grove_stalks"
	anchored = 1

/obj/structure/flora/stalks/New()
	..()
	icon_state = "grove_stalks[rand(1, 2)]"

//bamboo
/obj/structure/flora/bamboo
	name = "bamboo stalks"
	icon = 'icons/obj/flora/groveflora.dmi'
	icon_state = "grove_bamboo"
	anchored = 1

/obj/structure/flora/stalks/New()
	..()
	icon_state = "grove_bamboo[rand(1, 3)]"
