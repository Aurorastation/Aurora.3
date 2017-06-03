//contains:
//~shadow
//ancient one

////////////////////////////////////////
///////////////Shadowmancer/////////////
////////////////////////////////////////

/obj/item/projectile/energy/shadow
	name = "heavenly orb"
	icon_state = "magicm"
	check_armour = "energy"
	damage = 15
	damage_type = BURN
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	embed = 0
	incinerate = 5
	light_range = 1.4
	light_power = 2
	light_color = LIGHT_COLOR_FIRE
	light_wedge = LIGHT_OMNI

/mob/living/simple_animal/hostile/shadow
	name = "shadow wisp"
	desc = "This frail and otherworldy creature seems to consume light with a voracious appetite..."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "shadow"
	icon_living = "shadow"
	icon_dead = "shadow_dead"
	ranged = 1
	turns_per_move = 5
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	a_intent = I_HURT
	meat_amount = 3
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/shadowmeat
	stop_automated_movement_when_pulled = 0
	health = 30
	maxHealth = 30
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "tickles"
	attack_sound = 'sound/weapons/bite.ogg'
	speed = 3
	projectiletype = /obj/item/projectile/energy/shadow
	projectilesound = 'sound/effects/teleport.ogg'
	destroy_surroundings = 0
	emote_see = list("hovers ominously")

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	light_range = 10
	light_power = -10
	light_color = "#FFFFFF"
	light_wedge = LIGHT_OMNI

	faction = "outsider"

/mob/living/simple_animal/hostile/shadow/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/shadow/can_fall()
	return FALSE

/mob/living/simple_animal/hostile/shadow/can_ztravel()
	return TRUE

/mob/living/simple_animal/hostile/shadow/CanAvoidGravity()
	return TRUE

////////////////////////////////////////
///////////////Ancient One//////////////
////////////////////////////////////////