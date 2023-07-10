//For things that swim and don't do much else, but also bite!
/mob/living/simple_animal/hostile/retaliate/aquatic
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

/mob/living/simple_animal/hostile/retaliate/aquatic/Move(newloc)
	if(is_type_in_list(newloc, suitable_turf_types))
		alpha = 95//Becomes transparent because it's underwater
		icon_state = "[icon_state]"
		return ..()//Proceed as normal.

/mob/living/simple_animal/hostile/retaliate/aquatic/Life()
	var/turf/T = get_turf(src)
	if (!(is_type_in_list(T,suitable_turf_types)))
		alpha = 255//Becomes a solid color because it is revealed
		icon_state = "[icon_state]_rest"
		..()

/mob/living/simple_animal/hostile/retaliate/aquatic/thresher
	name = "carnivorous aquatic creature"
	desc = "A threatening-looking aquatic creature with a mouth full of densely-packed, razor sharp teeth."
	emote_see = list("swishes around elegantly", "floats threateningly")
	see_in_dark = 6
	mob_size = MOB_LARGE
	icon_state = "thresher"
	icon_living = "thresher"
	icon_dead = "thresher_dead"
	icon_rest = "thresher_rest"
	health = 230
	maxHealth = 230
	melee_damage_lower = 40
	melee_damage_upper = 70
	armor_penetration = 80

/mob/living/simple_animal/hostile/retaliate/aquatic/thresher/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/melee/baton))
		user.gib()
		user.visible_message(SPAN_DANGER("[user] was torn to shreds by a shark while attempting to attack with \the [O]!"))
		return 1

/mob/living/simple_animal/hostile/retaliate/aquatic/thresher/deep_water
	name = "large toothed aquatic creature"
	desc = "A threatening-looking aquatic creature with a mouth full of densely-packed, razor sharp teeth. This one has grown to a substantial size."
	health = 370
	maxHealth = 370
	melee_damage_lower = 50
	melee_damage_upper = 90
	armor_penetration = 100
