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
	hunger_enabled = FALSE
	canbrush = TRUE
	var/eggsleft = 0

/mob/living/simple_animal/ice_tunneler/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food/snacks/grown)) //feedin' dem chickens
		var/obj/item/reagent_containers/food/snacks/grown/G = O
		if(G.seed && G.seed.kitchen_tag == "nfrihi")
			if(!stat && eggsleft < 8)
				user.visible_message(
					span("notice", "\The [user] feeds \the [O] to \the [name]! It whistles happily."),
					span("notice", "You feed \the [O] to \the [name]! It whistles happily."),
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
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	health = 200
	maxHealth = 200
	mob_size = 15

	canbrush = TRUE
	has_udder = TRUE
	milk_type = "fatshouter_milk"

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	butchering_products = list(/obj/item/stack/material/animalhide = 5)


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

	maxHealth = 150
	health = 150

	harm_intent_damage = 3
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	butchering_products = list(/obj/item/stack/material/animalhide = 5)
	meat_amount = 8

/mob/living/simple_animal/schlorrgo
	name = "schlorrgo"
	desc = "A fat creature native to the world of Hro'zamal."
	icon = 'icons/mob/npc/livestock.dmi'
	icon_state = "schlorgo"
	icon_living = "schlorgo"
	icon_dead = "schlorgo_dead"
	speak = list("Ough!")
	speak_emote = list("moans", "moans raucously")
	emote_hear = list("moans", "moans raucously")
	emote_see = list("rolls around")

	emote_sounds = list('sound/effects/creatures/ough.ogg')

	meat_amount = 3
	hunger_enabled = TRUE
	canbrush = TRUE

	maxHealth = 50
	health = 50

	has_udder = TRUE
	milk_type = "milk"

	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken
	butchering_products = list(/obj/item/reagent_containers/food/snacks/spreads/lard = 5)

	holder_type = /obj/item/holder/schlorrgo

/mob/living/simple_animal/schlorrgo/unarmed_harm_attack(mob/living/carbon/human/user)
	var/obj/item/organ/external/left_leg = user.get_organ(BP_L_LEG)
	var/obj/item/organ/external/right_leg = user.get_organ(BP_R_LEG)

	if(left_leg?.is_usable() && right_leg?.is_usable())
		user.visible_message(SPAN_WARNING("[user] punts \the [src]!"))
		user.do_attack_animation(src)
		make_noise()
		throw_at(get_edge_target_turf(user, get_dir(user, src)), 4, 1)
		poke(TRUE)
	else
		..()

/mob/living/simple_animal/schlorrgo/turf_collision(var/turf/T, var/speed = THROWFORCE_SPEED_DIVISOR)
	visible_message(SPAN_WARNING("[src] harmlessly bounces off \the [T]!"))
	playsound(T, 'sound/effects/bangtaper.ogg', 50, 1, 1)
	make_noise()
