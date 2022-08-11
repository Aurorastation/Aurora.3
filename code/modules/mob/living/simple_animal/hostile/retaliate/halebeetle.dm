
/mob/living/simple_animal/hostile/retaliate/halebeetle
	name = "Hale Beetle"
	desc = "A beetle-like alien that stands tall, with two dripping scythe-like arms. Its eyes glow with an alluring dull light."
	icon_state = "halebeetle"
	icon_living = "halebeetle"
	icon_dead = "halebeetle_dead"
	move_to_delay = 5
	health = 90
	maxHealth = 90
	harm_intent_damage = 5
	ranged = 1
	smart_ranged = TRUE
	organ_names = list("chestplate", "lower abdomen", "left scythe", "right scythe", "right legs", "right legs", "head")
	blood_type = COLOR_OIL
	melee_damage_lower = 10
	melee_damage_upper = 18
	armor_penetration = 10
	attacktext = list("slashes", "cuts", "opens its mandibles and bites")
	a_intent = I_HURT
	speak_chance = 10
	turns_per_move = 10
	speak_emote = list(".../tktk/...", ".../tzz/...", "...zzmun...", "...hhel...")
	emote_hear = list("whispers","giggles quietly")
	emote_see = list("stares ominously", "", "reflects light in its vacant eyes", "opens its mandibles", "leaks an intoxicating odor")
	/obj/item/projectile/bullet/rifle/tranq
	destroy_surroundings = 1
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat
	meat_amount = 5
	butchering_products = list(/obj/item/device/flashlight/slime = 1)
	minbodytemp = 0
	light_range = 0.1
	light_wedge = LIGHT_WIDE
	see_in_dark = 1
	psi_pingable = FALSE