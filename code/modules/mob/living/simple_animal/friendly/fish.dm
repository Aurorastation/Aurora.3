/mob/living/simple_animal/fish
	name = "fish"
	desc = "It's a fishy. No touchy fishy."
	icon = 'icons/mob/fish.dmi'
	item_state = "fish"

	mob_size = MOB_SMALL

	holder_type = /obj/item/holder/fish

	meat_type = /obj/item/reagent_containers/food/snacks/fish/fishfillet

	// By default they can be in any water turf.  Subtypes might restrict to deep/shallow etc
	var/global/list/suitable_turf_types = list(
		/turf/simulated/floor/beach/water,
		/turf/simulated/floor/beach/coastline,
		/turf/simulated/floor/holofloor/beach/water,
		/turf/simulated/floor/holofloor/beach/coastline,
		/turf/simulated/floor/exoplanet/water
	)

// Makes the AI unable to willingly go on land.
/mob/living/simple_animal/fish/Move(newloc)
	if(is_type_in_list(newloc, suitable_turf_types))
		return ..() // Proceed as normal.
	return 0 // Don't leave the water!

// Take damage if we are not in water
/mob/living/simple_animal/fish/handle_breathing()
	var/turf/T = get_turf(src)
	if(T && !is_type_in_list(T, suitable_turf_types))
		if(prob(50))
			say(pick("Blub", "Glub", "Burble"))
		adjustBruteLoss(unsuitable_atoms_damage)

// Subtypes.
/mob/living/simple_animal/fish/bass
	name = "bass"
	desc = "A common European freshwater perch."
	icon_state = "bass-swim"

/mob/living/simple_animal/fish/trout
	name = "trout"
	desc = "A chiefly freshwater fish of the salmon family."
	icon_state = "trout-swim"

/mob/living/simple_animal/fish/salmon
	name = "salmon"
	desc = "A large edible fish that is a popular game fish, much prized for its pink flesh."
	icon_state = "salmon-swim"

/mob/living/simple_animal/fish/perch
	name = "perch"
	desc = "An edible freshwater fish with a high spiny dorsal fin, dark vertical bars on the body, and orange lower fins."
	icon_state = "perch-swim"

/mob/living/simple_animal/fish/pike
	name = "pike"
	desc = "A long-bodied predatory freshwater fish with a pointed snout and large teeth."
	icon_state = "pike-swim"

/mob/living/simple_animal/fish/koi
	name = "koi"
	desc = "A common carp of a large ornamental variety."
	icon_state = "koi-swim"
