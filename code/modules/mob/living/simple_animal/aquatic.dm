//For things that swim and don't do much else.
/mob/living/simple_animal/aquatic
	name = "aquatic animal"
	desc = "You shouldn't be seeing this."
	icon = 'icons/mob/npc/fish.dmi'
	icon_state = "fish"
	item_state = "fish"
	icon_living = "fish"
	icon_dead = "fish_dead"
	icon_rest = "fish_rest"
	meat_type = /obj/item/reagent_containers/food/snacks/fish/fishfillet
	organ_names = list("snout", "body", "tail fin", "left pectoral fin", "right pectoral fin", "dorsal fin")
	response_help = "brushes"
	response_disarm = "attempts to push"
	response_harm = "injures"

	var/global/list/suitable_turf_types = list(
		/turf/simulated/floor/beach/water,
		/turf/simulated/floor/beach/coastline,
		/turf/simulated/floor/holofloor/beach/water,
		/turf/simulated/floor/holofloor/beach/coastline,
		/turf/simulated/floor/exoplanet/water
	)

/mob/living/simple_animal/aquatic/Move(newloc)
	if(is_type_in_list(newloc, suitable_turf_types))
		alpha = 95//Becomes transparent because it's underwater
		icon_state = "[icon_state]"
		return ..()//Proceed as normal.

/mob/living/simple_animal/aquatic/Life()
	var/turf/T = get_turf(src)
	if (!(is_type_in_list(T,suitable_turf_types)))
		alpha = 255//Becomes a solid color because it is revealed
		icon_state = "[icon_state]_rest"
		..()

