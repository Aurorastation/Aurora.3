/obj/structure/flora/tree/mushroom
	name = "fungal tree"
	desc = "Some sort of woody fungal growth, grown to extreme proportions."
	icon = 'icons/obj/flora/fungaltrees.dmi'
	icon_state = "shroom"

/obj/structure/flora/tree/mushroom/Initialize(mapload)
	. = ..()
	icon_state = "shroom[rand(1,2)]"
	if(prob(5))
		icon_state = "shroom3"
		desc += " This one appears to have split wide open."

/obj/structure/flora/bush/mushroom
	name = "mushroom"
	desc = "A rather large variety of fungus."
	icon = 'icons/obj/flora/fungalflora.dmi'
	icon_state = "fungus_bush"

/obj/structure/flora/bush/mushroom/Initialize()
	. = ..()
	icon_state = "fungus_bush[rand(1,3)]"

/obj/effect/floor_decal/fungus
	name = "fungal growth"
	icon = 'icons/obj/flora/fungalflora.dmi'
	icon_state = "fungus"

/obj/effect/floor_decal/fungus/random/Initialize(mapload, newdir, newcolour, bypass, set_icon_state)
	icon_state = "fungus[rand(1,9)]"
	. = ..()
