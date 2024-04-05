/obj/structure/flora/tree/crystal
	name = "crystalline tree"
	desc = "An exotic growth that appears to be a tree-like form, though grown entirely out of crystal."
	pixel_x = -32
	icon = 'icons/obj/flora/crystal_trees.dmi'
	icon_state = "gem"

/obj/structure/flora/tree/crystal/Initialize(mapload)
	. = ..()
	icon_state = "gem[rand(1,2)]"

/obj/structure/flora/tree/crystal/attackby(obj/item/attacking_item, mob/user)
	return TRUE // could probably make this mineable but I'm lazy

/obj/structure/flora/rock/spire
	name = "crystal spire"
	desc = "A crystalline structure suspended in mid-air."
	icon = 'icons/obj/flora/crystal_trees.dmi'
	icon_state = "spire"
	pixel_x = -32
	layer = ABOVE_HUMAN_LAYER // this is basically a tree

/obj/structure/flora/rock/spire/Initialize(mapload)
	. = ..()
	icon_state = "spire[rand(1,3)]"

/obj/effect/floor_decal/crystal
	name = "crystals"
	icon = 'icons/turf/crystal.dmi'
	icon_state = "crystal_gen"

/obj/effect/floor_decal/crystal/random/Initialize(mapload, newdir, newcolour, bypass, set_icon_state)
	icon_state = "crystal_gen[rand(1,3)]"
	. = ..()

/obj/effect/floor_decal/crystal/random/dark
	color = "#666666"
