/mob/living/simple_animal/ice_tunneler
	name = "ice tunneler"
	desc = "An egg producing beast from Adhomai. It is known for burrowing in ice and snow."
	icon = 'icons/mob/npc/livestock.dmi'
	icon_state = "tunneler"
	icon_living = "tunneler"
	icon_dead = "tunneler_dead"
	speak = list("Fiiiiiii!")
	speak_emote = list("whistles")
	emote_hear = list("whistles loudly")
	emote_see = list("whistles")
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 2
	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")
	hunger_enabled = FALSE
	canbrush = TRUE
	var/eggsleft = 0

/mob/living/simple_animal/ice_tunneler/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food/snacks/grown)) //feedin' dem chickens
		var/obj/item/reagent_containers/food/snacks/grown/G = O
		if(G.seed && G.seed.kitchen_tag == "nfrihi")
			if(!stat && eggsleft < 8)
				user.visible_message(
					SPAN_NOTICE("\The [user] feeds \the [O] to \the [name]! It whistles happily."),
					SPAN_NOTICE("You feed \the [O] to \the [name]! It whistles happily."),
					"You hear a cluck.")
				user.drop_from_inventory(O,get_turf(src))
				qdel(O)
				eggsleft += rand(1, 4)
			else
				to_chat(user, "\The [name] doesn't seem hungry!")
		else
			to_chat(user, "\The [name] doesn't seem interested in that.")
	else
		..()

/mob/living/simple_animal/ice_tunneler/Life()
	. =..()
	if(!.)
		return
	if(!stat && prob(3) && eggsleft > 0)
		visible_message("[src] lays an egg.")
		eggsleft--
		new /obj/item/reagent_containers/food/snacks/egg(get_turf(src))

/mob/living/simple_animal/fatshouter
	name = "fatshouter"
	desc = "An adhomian animal known for its production of milk and wool."
	icon = 'icons/mob/npc/livestock.dmi'
	icon_state = "fatshouter"
	icon_living = "fatshouter"
	icon_dead = "fatshouter_dead"
	speak_emote = list("brays")
	emote_hear = list("brays")
	emote_see = list("shakes its head")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_amount = 30
	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	health = 200
	maxHealth = 200
	mob_size = 15

	canbrush = TRUE
	has_udder = TRUE
	milk_type = /decl/reagent/drink/milk/adhomai

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	butchering_products = list(/obj/item/stack/material/animalhide = 5, /obj/item/reagent_containers/food/snacks/spreads/lard = 5)


/mob/living/simple_animal/hostile/retaliate/rafama
	name = "steed of Mata'ke"
	desc = "An animal native to Adhomai, known for its agressive behavior and mighty tusks."
	icon = 'icons/mob/npc/livestock.dmi'
	icon_state = "rafama"
	icon_living = "rafama"
	icon_dead = "rafama_dead"
	turns_per_move = 3
	speak_emote = list("chuffs")
	emote_hear = list("growls")
	emote_see = list("shakes its head", "stamps a foot", "glares around")
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	mob_size = 12
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")

	maxHealth = 150
	health = 150

	melee_damage_lower = 15
	melee_damage_upper = 15
	armor_penetration = 20
	attacktext = "gored"
	attack_sound = 'sound/weapons/bite.ogg'

	hostile_nameable = TRUE

	butchering_products = list(/obj/item/stack/material/animalhide = 5)
	meat_amount = 8
