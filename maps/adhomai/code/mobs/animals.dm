/mob/living/simple_animal/ice_tunneler
	name = "ice tunneler"
	desc = "An egg producing beast from Adhomai. It is known for burrowing in ice and snow."
	icon = 'icons/adhomai/animals.dmi'
	icon_state = "tunneler"
	icon_living = "tunneler"
	icon_dead = "tunneler_dead"
	speak = list("Fiiiiiii!")
	speak_emote = list("whistles")
	emote_hear = list("whistles loudly")
	emote_see = list("whistles")
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/adhomai
	var/eggsleft = 0

/mob/living/simple_animal/ice_tunneler/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown)) //feedin' dem chickens
		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = O
		if(G.seed && G.seed.kitchen_tag == "nfrihi")
			if(!stat && eggsleft < 8)
				user.visible_message(
					span("notice", "\The [user] feeds \the [O] to \the [name]! It clucks happily."),
					span("notice", "You feed \the [O] to \the [name]! It clucks happily."),
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
		new /obj/item/weapon/reagent_containers/food/snacks/egg(get_turf(src))

/mob/living/simple_animal/cow/fatshouter
	name = "fatshouter"
	desc = "An adhomian animal known for its production of milk and wool."
	icon = 'icons/adhomai/animals.dmi'
	icon_state = "fatshouter"
	icon_living = "fatshouter"
	icon_dead = "fatshouter_dead"
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/adhomai

/mob/living/simple_animal/cow/fatshouter/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/obj/item/weapon/reagent_containers/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
		var/transfered = udder.trans_id_to(G, "fatshouter_milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, "<span class='warning'>The [O] is full.</span>")
		if(!transfered)
			to_chat(user, "<span class='warning'>The udder is dry. Wait a bit longer...</span>")
	else
		..()

/mob/living/simple_animal/cow/fatshouter/Life()
	. = ..()
	if(stat == CONSCIOUS)
		if(udder && prob(5))
			udder.add_reagent("fatshouter_milk", rand(5, 10))

/mob/living/simple_animal/hostile/retaliate/rafama
	name = "steed of Mata'ke"
	desc = "An animal native to Adhomai, known for its agressive behavior and mighty tusks."
	icon = 'icons/adhomai/animals.dmi'
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
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/adhomai

	maxHealth = 50
	health = 50

	harm_intent_damage = 3
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	butchering_products = list(/obj/item/stack/material/animalhide = 8)
	meat_amount = 10