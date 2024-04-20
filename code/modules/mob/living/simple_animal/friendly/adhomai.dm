/mob/living/simple_animal/ice_tunneler
	name = "ice tunneler"
	desc = "An egg producing beast from Adhomai. It is known for burrowing in ice and snow."
	icon = 'icons/mob/npc/adhomai.dmi'
	icon_state = "tunneler_f"
	icon_living = "tunneler_f"
	icon_dead = "tunneler_f_dead"
	speak = list("Fiiiiiii!")
	speak_emote = list("whistles")
	emote_hear = list("whistles loudly")
	emote_see = list("whistles")
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 2
	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")
	hunger_enabled = FALSE
	canbrush = TRUE
	faction = "Adhomai"
	gender = FEMALE
	maxHealth = 50
	health = 50
	mob_size = 5
	var/eggsleft = 0

/mob/living/simple_animal/ice_tunneler/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/grown)) //feedin' dem chickens
		var/obj/item/reagent_containers/food/snacks/grown/G = attacking_item
		if(G.seed && G.seed.kitchen_tag == "nfrihi")
			if(!stat && eggsleft < 8)
				user.visible_message(
					SPAN_NOTICE("\The [user] feeds \the [attacking_item] to \the [name]! It whistles happily."),
					SPAN_NOTICE("You feed \the [attacking_item] to \the [name]! It whistles happily."),
					"You hear a cluck.")
				user.drop_from_inventory(attacking_item,get_turf(src))
				qdel(attacking_item)
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
	if(!stat && prob(3) && eggsleft > 0 && (gender = FEMALE))
		visible_message("[src] lays an egg.")
		eggsleft--
		new /obj/item/reagent_containers/food/snacks/egg/ice_tunnelers(get_turf(src))

/mob/living/simple_animal/ice_tunneler/male
	icon_state = "tunneler_m"
	icon_living = "tunneler_m"
	icon_dead = "tunneler_m_dead"
	gender = MALE

/mob/living/simple_animal/ice_tunneler/baby
	name = "ice tunneler chick"
	icon_state = "tunneler_baby"
	icon_living = "tunneler_baby"
	icon_dead = "tunneler_baby_dead"
	maxHealth = 10
	health = 10
	mob_size = 2
	meat_amount = 1

/mob/living/simple_animal/fatshouter
	name = "fatshouter"
	desc = "An adhomian animal known for its production of milk and wool."
	icon = 'icons/mob/npc/adhomai.dmi'
	icon_state = "fatshouter_f"
	icon_living = "fatshouter_f"
	icon_dead = "fatshouter_f_dead"
	speak_emote = list("brays")
	emote_hear = list("brays")
	emote_see = list("shakes its head")
	speak_chance = 1
	turns_per_move = 5
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
	milk_type = /singleton/reagent/drink/milk/adhomai

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	butchering_products = list(/obj/item/stack/material/animalhide = 5, /obj/item/reagent_containers/food/snacks/spreads/lard = 5)
	faction = "Adhomai"

	gender = FEMALE

/mob/living/simple_animal/fatshouter/male
	icon_state = "fatshouter_m"
	icon_living = "fatshouter_m"
	icon_dead = "fatshouter_m_dead"
	gender = MALE
	has_udder = FALSE

/mob/living/simple_animal/hostile/retaliate/rafama
	name = "steed of Mata'ke"
	desc = "An animal native to Adhomai, known for its agressive behavior and mighty tusks."
	icon = 'icons/mob/npc/adhomai.dmi'
	icon_state = "rafama_f"
	icon_living = "rafama_f"
	icon_dead = "rafama_f_dead"
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
	faction = "Adhomai"
	gender = FEMALE

/mob/living/simple_animal/hostile/retaliate/rafama/male
	icon_state = "rafama_m"
	icon_living = "rafama_m"
	icon_dead = "rafama_m_dead"
	gender = MALE

/mob/living/simple_animal/hostile/retaliate/rafama/baby
	icon_state = "rafama_baby"
	icon_living = "rafama_baby"
	icon_dead = "rafama_baby_dead"
	gender = MALE
	maxHealth = 30
	health = 30
	mob_size = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	meat_amount = 2

/mob/living/simple_animal/scavenger
	name = "scavenger"
	desc = "Segmented, keratinous creatures that feed on the Hma'trra Zivr carcasses found on the pole's surface."
	icon = 'icons/mob/npc/adhomai.dmi'
	icon_state = "scavenger"
	icon_living = "scavenger"
	icon_dead = "scavenger_dead"
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 1
	organ_names = list("thorax", "legs", "head")
	faction = "Adhomai"
	maxHealth = 20
	health = 20
	mob_size = 3

	speak_emote = list("chitters")
	emote_hear = list("chitters")
	emote_see = list("scutters around", "digs the ground")

	blood_type = "#281C2D"

/mob/living/simple_animal/ice_catcher
	name = "ice catcher"
	desc = "An animal often mistaken for a rock due its shell. Its main body is made up of large tentacles."
	icon = 'icons/mob/npc/adhomai_48.dmi'
	icon_state = "catcher"
	icon_living = "catcher"
	icon_dead = "catcher_dead"

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 10
	organ_names = list("shell", "tentacles")
	faction = "Adhomai"

	maxHealth = 50
	health = 50
	mob_size = 3
	pixel_x = -8
	blood_type = "#281C2D"
	var/burrowed = FALSE
	var/chosen_icon

/mob/living/simple_animal/ice_catcher/Initialize()
	. = ..()
	chosen_icon = pick("catcher", "catcher1", "catcher2")
	icon_state = chosen_icon
	icon_living = chosen_icon
	icon_dead = "[chosen_icon]_dead"
	burrow()

/mob/living/simple_animal/ice_catcher/proc/burrow()
	burrowed = TRUE
	icon_state = "[chosen_icon]-h"
	icon_living = "[chosen_icon]-h"
	anchored = TRUE
	name = "rock"
	desc = "A rock."
	visible_message(SPAN_NOTICE("\The [src] burrows into the ground!"))

/mob/living/simple_animal/ice_catcher/Move()
	if(burrowed)
		return
	else
		..()

/mob/living/simple_animal/ice_catcher/proc/unburrow()
	burrowed = FALSE
	icon_state = "[chosen_icon]"
	icon_living = "[chosen_icon]"
	anchored = FALSE
	name = "ice catcher"
	desc = "An animal often mistaken for a rock due its shell. Its main body is made up of large tentacles."
	visible_message(SPAN_NOTICE("\The [src] emerges from the ground!"))

/mob/living/simple_animal/ice_catcher/attack_hand(mob/living/carbon/human/M as mob)
	if(burrowed && (stat != DEAD))
		unburrow()
	..()

/mob/living/simple_animal/ice_catcher/attackby(obj/item/attacking_item, mob/user)
	if(burrowed && (stat != DEAD))
		unburrow()
	..()

/mob/living/simple_animal/ice_catcher/bullet_act(obj/item/projectile/P, def_zone)
	if(burrowed && (stat != DEAD))
		unburrow()
	..()

/mob/living/simple_animal/ice_catcher/death(gibbed)
	..()
	if(burrowed)
		unburrow()

/mob/living/simple_animal/climber
	name = "climber"
	desc = "A rideable beast of burden, large enough for one adult rider only but perfectly adapted for the rough terrain on Adhomai."
	icon = 'icons/mob/npc/adhomai_48.dmi'
	icon_state = "climber"
	icon_living = "climber"
	icon_dead = "climber_dead"
	speak_emote = list("chuffs")
	emote_hear = list("chuffs")
	emote_see = list("shakes its head", "stomps its feet")
	speak_chance = 1
	turns_per_move = 5

	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai

	faction = "Adhomai"

	maxHealth = 100
	health = 100
	mob_size = 12
	pixel_x = -8

	canbrush = TRUE

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 4
	faction = "Adhomai"
	vehicle_version = /obj/vehicle/animal/climber
	natural_armor = list(
		melee = ARMOR_MELEE_MEDIUM,
		bullet = ARMOR_BALLISTIC_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)

/mob/living/simple_animal/climber/saddle
	desc = "A rideable beast of burden, large enough for one adult rider only but perfectly adapted for the rough terrain on Adhomai. This one has a saddle mounted on it"
	icon_state = "climber_s"
	icon_living = "climber_s"
	icon_dead = "climber_s_dead"

/mob/living/simple_animal/snow_strider
	name = "snow strider"
	desc = "An animal hunted and farmed by the Tajara for its meat and fur."
	icon = 'icons/mob/npc/adhomai_48.dmi'
	icon_state = "snow_strider"
	icon_living = "snow_strider"
	icon_dead = "snow_strider_dead"

	turns_per_move = 3
	speak_emote = list("chuffs")
	emote_hear = list("yelps")
	emote_see = list("shakes its head", "stamps a foot", "glares around")

	stop_automated_movement_when_pulled = 0
	mob_size = 12

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")

	maxHealth = 150
	health = 150

	butchering_products = list(/obj/item/stack/material/animalhide = 10)
	meat_amount = 20
	faction = "Adhomai"
	pixel_x = -8

/mob/living/simple_animal/nosehorn
	name = "nose-horn"
	desc = "A domesticated beast of burden used for hitching and dragging. "
	icon = 'icons/mob/npc/adhomai_96.dmi'
	icon_state = "nosehorn"
	icon_living = "nosehorn"
	icon_dead = "nosehorn_dead"
	speak_emote = list("chuffs")
	emote_hear = list("brays")
	emote_see = list("shakes its head")
	speak_chance = 1
	turns_per_move = 5
	meat_amount = 50
	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	health = 450
	maxHealth = 452
	mob_size = 30

	pixel_x = -32

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	butchering_products = list(/obj/item/stack/material/animalhide = 15, /obj/item/reagent_containers/food/snacks/spreads/lard = 20)
	faction = "Adhomai"
