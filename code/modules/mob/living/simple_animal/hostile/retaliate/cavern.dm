//asteroid cavern creatures
/mob/living/simple_animal/hostile/retaliate/cavern_dweller
	name = "cavern dweller"
	desc = "An alien creature that dwells in the tunnels of the asteroid, commonly found in the Romanovich Cloud."
	icon = 'icons/mob/npc/cavern.dmi'
	icon_state = "dweller" //icons from europa station
	icon_living = "dweller"
	icon_dead = "dweller_dead"
	ranged = 1
	smart = TRUE
	turns_per_move = 3
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	meat_type = /obj/item/reagent_containers/food/snacks/dwellermeat
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

/mob/living/simple_animal/hostile/retaliate/minedrone
	name = "mining rover"
	desc = "A dilapidated mining rover, with the faded colors of the Sol Alliance. It looks more than a little lost."
	icon = 'icons/mob/npc/cavern.dmi'
	icon_state = "sadrone"
	icon_living = "sadrone"
	icon_dead = "sadrone_dead"
	move_to_delay = 5
	health = 60
	maxHealth = 60
	harm_intent_damage = 5
	ranged = 1
	smart = TRUE
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "barrels into"
	attack_sound = 'sound/weapons/punch1.ogg'
	a_intent = I_HURT
	speak_emote = list("chirps","buzzes","whirrs")
	emote_hear = list("chirps cheerfully","buzzes","whirrs","hums placidly","chirps","hums")
	projectiletype = /obj/item/projectile/beam/plasmacutter
	projectilesound = 'sound/weapons/plasma_cutter.ogg'
	destroy_surroundings = 1
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
	light_wedge = LIGHT_WIDE
	see_in_dark = 8

	faction = "sol"

	var/list/loot = list()
	var/ore_message = 0
	var/target_ore
	var/ore_count = 0

/mob/living/simple_animal/hostile/retaliate/minedrone/Initialize()
	. = ..()
	var/i = rand(1,6)
	while(i)
		loot += pick(/obj/item/ore/silver, /obj/item/ore/gold, /obj/item/ore/uranium, /obj/item/ore/diamond)
		i--

/mob/living/simple_animal/hostile/retaliate/minedrone/death()
	..(null,"is smashed into pieces!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 3, alldirs)
	for(var/obj/item/ore/O in loot)
		O.forceMove(src.loc)
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/minedrone/Life()
	..()
	if(ore_count<20)
		FindOre()

/mob/living/simple_animal/hostile/retaliate/minedrone/proc/FindOre()
	if(!enemies.len)
		setClickCooldown(attack_delay)
		if(!target_ore in ListTargets(10))
			target_ore = null
		for(var/obj/item/ore/O in oview(1,src))
			O.forceMove(src)
			loot += O
			ore_count ++
			if(target_ore == O)
				target_ore = null
			if(!ore_message)
				ore_message = 1
		if(ore_message)
			visible_message("<span class='notice'>\The [src] collects the ore into a metallic hopper.</span>")
			ore_message = 0
		for(var/obj/item/ore/O in oview(7,src))
			target_ore = O
			break
		if(target_ore)
			walk_to(src, target_ore, 1, move_to_delay)
		else
			for(var/turf/simulated/mineral/M in orange(7,src))
				if(M.mineral)
					rapid = 1
					OpenFire(M)
					rapid = 0
					break

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustToxLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustOxyLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustCloneLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustHalLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/fall_impact()
	visible_message("<span class='danger'>\The [src] bounces harmlessly on its inflated wheels.</span>")
	return FALSE

/mob/living/simple_animal/hostile/retaliate/minedrone/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL
