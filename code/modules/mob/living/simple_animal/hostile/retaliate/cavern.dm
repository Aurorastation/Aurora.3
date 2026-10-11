//asteroid cavern creatures
/mob/living/simple_animal/hostile/retaliate/cavern_dweller
	name = "cavern dweller"
	desc = "An alien creature that dwells in the tunnels of the asteroid, commonly found in the Romanovich Cloud."
	icon = 'icons/mob/npc/cavern.dmi'
	icon_state = "dweller" //icons from europa station
	icon_living = "dweller"
	icon_dead = "dweller_dead"
	ranged = 1
	smart_ranged = TRUE
	turns_per_move = 3
	organ_names = list("head", "central segment", "tail")
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	meat_type = /obj/item/reagent_containers/food/snacks/dwellermeat
	mob_size = 12

	health = 60
	maxhealth = 60
	blood_type = "#006666"
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "chomps"
	attack_vis_effect = ATTACK_EFFECT_BITE
	attack_sound = 'sound/weapons/bite.ogg'
	speed = 4
	projectiletype = /obj/projectile/beam/cavern
	projectilesound = 'sound/magic/lightningbolt.ogg'
	break_stuff_probability = 2

	emote_see = list("stares","hovers ominously","blinks")

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
	lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE

/mob/living/simple_animal/hostile/retaliate/cavern_dweller/Allow_Spacemove(var/check_drift = 0)
	return 1

/obj/projectile/beam/cavern
	name = "electrical discharge"
	icon_state = "stun"
	damage_type = DAMAGE_BURN
	check_armor = ENERGY
	damage = 5

	muzzle_type = /obj/effect/projectile/muzzle/stun
	tracer_type = /obj/effect/projectile/tracer/stun
	impact_type = /obj/effect/projectile/impact/stun

/mob/living/simple_animal/hostile/retaliate/cavern_dweller/DestroySurroundings(var/bypass_prob = FALSE)
	if(stance != HOSTILE_STANCE_ATTACKING)
		return 0
	else
		..()

/obj/projectile/beam/cavern/on_hit(atom/target, blocked, def_zone)
	. = ..()

	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		var/shock_damage = rand(10,20)
		M.electrocute_act(shock_damage)

/datum/ai_holder/simple_animal/retaliate/minedrone
	pointblank = TRUE
	conserve_ammo = TRUE
	var/obj/item/ore/target_ore
	var/list/found_turfs = list()
	var/scan_timer = 0

/datum/ai_holder/simple_animal/retaliate/minedrone/handle_special_strategical()
	var/mob/living/simple_animal/hostile/retaliate/minedrone/drone = holder
	if(stance in AI_STANCES_COMBAT)
		return
	if(drone.ore_count >= 20)
		if(!scan_timer)
			drone.visible_message(SPAN_WARNING("\The [drone] pings, \"Mineral hopper full.\""))
			playsound(drone.loc, 'sound/machines/ping.ogg', 50, FALSE)
			scan_timer = rand(90, 150)
		else
			scan_timer--
		return

	if(target_ore && (QDELETED(target_ore) || get_dist(drone, target_ore) > 10))
		target_ore = null
	var/collected_ore = FALSE
	for(var/obj/item/ore/ore in oview(1, drone))
		ore.forceMove(drone)
		drone.loot += ore
		drone.ore_count++
		collected_ore = TRUE
		if(target_ore == ore)
			target_ore = null
	if(collected_ore)
		drone.visible_message(SPAN_NOTICE("\The [drone] collects the ore into a metallic hopper."))
	if(!target_ore)
		target_ore = locate() in oview(7, drone)
	if(target_ore)
		drone.AIMove(get_step_towards(drone, target_ore))
		return

	for(var/turf/simulated/mineral/mineral_turf in found_turfs)
		if(QDELETED(mineral_turf) || !mineral_turf.mineral)
			found_turfs -= mineral_turf
			continue
		drone.rapid = TRUE
		drone.OpenFire(mineral_turf)
		drone.rapid = FALSE
		return
	if(!length(found_turfs) && !scan_timer)
		for(var/turf/simulated/mineral/mineral_turf in oview(7, drone))
			if(mineral_turf.mineral)
				found_turfs |= mineral_turf
		if(!length(found_turfs))
			scan_timer = 30
	else if(scan_timer)
		scan_timer--

/mob/living/simple_animal/hostile/retaliate/minedrone
	ai_holder_type = /datum/ai_holder/simple_animal/retaliate/minedrone
	name = "mining rover"
	desc = "A dilapidated mining rover, with the faded colors of the Sol Alliance. It looks more than a little lost."
	icon = 'icons/mob/npc/cavern.dmi'
	icon_state = "sadrone"
	icon_living = "sadrone"
	icon_dead = "sadrone_dead"
	speed = 5
	health = 60
	maxhealth = 60
	harm_intent_damage = 5
	ranged = 1
	smart_ranged = TRUE
	organ_names = list("core", "right fore wheel", "left fore wheel", "right rear wheel", "left rear wheel")
	blood_type = COLOR_OIL
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "barrels into"
	attack_sound = SFX_PUNCH
	a_intent = I_HURT
	speak_emote = list("chirps","buzzes","whirrs")
	emote_hear = list("chirps cheerfully","buzzes","whirrs","hums placidly","chirps","hums")
	projectiletype = /obj/projectile/beam/plasmacutter
	projectilesound = 'sound/weapons/plasma_cutter.ogg'
	destroy_surroundings = FALSE
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
	psi_pingable = FALSE

	faction = "sol"

	var/list/loot = list()
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
	spark(T, 3, GLOB.alldirs)
	for(var/obj/item/ore/O in loot)
		O.forceMove(src.loc)
	qdel(src)


/mob/living/simple_animal/hostile/retaliate/minedrone/adjustToxLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustOxyLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustCloneLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustHalLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/fall_impact(levels_fallen, stopped_early = FALSE, var/damage_mod = 1)
	visible_message(SPAN_DANGER("\The [src] bounces harmlessly on its inflated wheels."))
	return FALSE

/mob/living/simple_animal/hostile/retaliate/minedrone/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL
