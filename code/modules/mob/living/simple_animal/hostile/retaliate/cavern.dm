//asteroid cavern creatures
/mob/living/simple_animal/hostile/retaliate/cavern_dweller
	name = "cavern dweller"
	desc = "An alien creature that dwells in the tunnels of the asteroid, commonly found in the Romanovich Cloud."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "dweller" //icons from europa station
	icon_living = "dweller"
	icon_dead = "dweller_dead"
	ranged = 1
	turns_per_move = 3
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/dwellermeat
	mob_size = 12

	health = 60
	maxHealth = 60
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "chomped"
	attack_sound = 'sound/weapons/bite.ogg'
	speed = 4
	projectiletype = /obj/item/projectile/beam/cavern
	projectilesound = 'sound/magic/lightningbolt.ogg'
	destroy_surroundings = 1

	emote_see = list("stares","hovers ominously","blinks")
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "cavern"

	flying = TRUE

/mob/living/simple_animal/hostile/retaliate/cavern_dweller/Allow_Spacemove(var/check_drift = 0)
	return 1

/obj/item/projectile/beam/cavern
	name = "electrical discharge"
	icon_state = "stun"
	damage_type = BURN
	check_armour = "energy"
	damage = 5

	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/obj/item/projectile/beam/cavern/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		var/shock_damage = rand(10,20)
		M.electrocute_act(shock_damage)
