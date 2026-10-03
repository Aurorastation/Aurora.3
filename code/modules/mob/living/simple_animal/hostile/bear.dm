#define BEARMODE_INDOORS 1
#define BEARMODE_SPACE 2

/datum/ai_holder/simple_animal/bear
	var/stance_step = 0
	var/turns_since_hit = 0
	var/health_last_check = 0
	var/bearmode_ticks = 0
	var/resting_from_chase = FALSE

/datum/ai_holder/simple_animal/bear/attune_to_holder()
	. = ..()
	var/mob/living/simple_animal/hostile/bear/bear = holder
	health_last_check = bear.health

/datum/ai_holder/simple_animal/bear/should_threaten(atom/the_target = target)
	var/mob/living/simple_animal/hostile/bear/bear = holder
	return !bear.anger && ..()

/datum/ai_holder/simple_animal/bear/give_target(atom/new_target, urgent = FALSE)
	var/changed_target = target != new_target
	. = ..()
	if(. && changed_target)
		turns_since_hit = 0
		stance_step = 0
		var/mob/living/simple_animal/hostile/bear/bear = holder
		bear.custom_emote(VISIBLE_MESSAGE, "stares alertly at [new_target]")
		bear.speak_audio()

/datum/ai_holder/simple_animal/bear/handle_special_strategical()
	var/mob/living/simple_animal/hostile/bear/bear = holder
	bearmode_ticks++
	if(bearmode_ticks % 5 == 0)
		bear.update_bearmode()
	if(bear.health < health_last_check && !resting_from_chase)
		bear.anger++
		enrage()
	health_last_check = bear.health
	if(bearmode_ticks % 30 == 0)
		bear.anger = max(0, bear.anger - 1)

/datum/ai_holder/simple_animal/bear/handle_special_tactic()
	var/mob/living/simple_animal/hostile/bear/bear = holder
	if(resting_from_chase)
		stance_step++
		if(stance_step >= 15)
			resting_from_chase = FALSE
			stance_step = 0
			if(target && can_attack(target))
				set_stance(within_range(target) ? AI_STANCE_FIGHT : AI_STANCE_APPROACH)
			else
				remove_target(FALSE)
		return

	if(stance == AI_STANCE_ALERT && target && can_attack(target))
		stance_step++
		bear.face_atom(target)
		if(stance_step in list(1, 4, 7))
			bear.custom_emote(VISIBLE_MESSAGE, pick("growls at [target]", "stares angrily at [target]", "prepares to attack [target]", "closely watches [target]"))
			bear.speak_audio()
		if(bear.anger)
			enrage(target)
		else if(stance_step >= 12)
			bear.anger += 3
			bear.growl_loud()
			set_stance(within_range(target) ? AI_STANCE_FIGHT : AI_STANCE_APPROACH)
		return

	if(stance in AI_STANCES_COMBAT)
		stance_step++
		turns_since_hit++
		if(stance_step >= (16 + (bear.anger * 2)) * max(bear.bearmode, 1))
			tire_out()
			return
		if(target && !bear.Adjacent(target) && turns_since_hit > 3)
			remove_target()

/datum/ai_holder/simple_animal/bear/post_melee_attack(atom/the_target)
	. = ..()
	turns_since_hit = 0
	var/mob/living/simple_animal/hostile/bear/bear = holder
	bear.AIBearAttackEffect(the_target)

/datum/ai_holder/simple_animal/bear/proc/enrage(atom/forced_target)
	var/mob/living/simple_animal/hostile/bear/bear = holder
	if(forced_target && can_attack(forced_target, FALSE))
		give_target(forced_target, TRUE)
	else if(!target)
		find_target()
	if(!target)
		return
	bear.growl_loud()
	set_stance(within_range(target) ? AI_STANCE_FIGHT : AI_STANCE_APPROACH)
	if(within_range(target))
		engage_target()

/datum/ai_holder/simple_animal/bear/proc/tire_out()
	var/mob/living/simple_animal/hostile/bear/bear = holder
	resting_from_chase = TRUE
	stance_step = 0
	forget_path()
	set_stance(AI_STANCE_SPECIAL)
	bear.AIBearTired()

/datum/ai_holder/simple_animal/bear/spatial
	var/idletime = 0
	var/focus_time = 0

/datum/ai_holder/simple_animal/bear/spatial/give_target(atom/new_target, urgent = FALSE)
	. = ..()
	if(.)
		focus_time = 0

/datum/ai_holder/simple_animal/bear/spatial/handle_special_tactic()
	. = ..()
	if(resting_from_chase)
		return
	var/mob/living/simple_animal/hostile/bear/spatial/bear = holder
	if((stance in AI_STANCES_COMBAT) && target)
		focus_time++
		if(focus_time % bear.tactical_delay == 0)
			tactical_teleport(target)

/datum/ai_holder/simple_animal/bear/spatial/handle_special_strategical()
	. = ..()
	var/mob/living/simple_animal/hostile/bear/spatial/bear = holder
	var/should_teleport = FALSE
	if(stance == AI_STANCE_IDLE)
		idletime++
		if(idletime >= bear.teleport_delay)
			should_teleport = TRUE
	else
		idletime = 0
	for(var/mob/living/simple_animal/hostile/bear/other_bear in view(world.view, get_turf(bear)))
		if(other_bear != bear && other_bear.stat != DEAD)
			should_teleport = TRUE
			break
	if(should_teleport)
		idletime = 0
		remove_target(FALSE)
		strategic_teleport()
		bear.growl_soft()

/datum/ai_holder/simple_animal/bear/spatial/tire_out()
	. = ..()
	strategic_teleport()

/datum/ai_holder/simple_animal/bear/spatial/proc/strategic_teleport()
	var/mob/living/simple_animal/hostile/bear/spatial/bear = holder
	if(bear.stat != CONSCIOUS)
		return FALSE
	var/area/destination_area = random_station_area(TRUE)
	var/turf/destination = destination_area?.random_space()
	if(destination)
		bear.teleport_to(destination)
		return TRUE
	return FALSE

/datum/ai_holder/simple_animal/bear/spatial/proc/tactical_teleport(atom/the_target = target)
	var/mob/living/simple_animal/hostile/bear/spatial/bear = holder
	if(bear.stat != CONSCIOUS || !the_target)
		return FALSE
	var/area/destination_area = get_area(the_target)
	var/turf/destination = destination_area?.random_space()
	if(destination)
		bear.teleport_to(destination)
		return TRUE
	return FALSE

//Space bears!
/mob/living/simple_animal/hostile/bear
	ai_holder_type = /datum/ai_holder/simple_animal/bear
	name = "space bear"
	desc = "You should walk away, quickly!"
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	icon_gib = "bear_gib"
	//speak = list("RAWR!","Rawr!","GRR!","Growl!") Bears don't talk.
	speak_emote = list("growls", "roars")
	emote_hear = list("grumbles","grawls")
	emote_see = list("stares ferociously", "stomps")
	speak_chance = 10
	turns_per_move = 10
	meat_type = /obj/item/reagent_containers/food/snacks/bearmeat
	meat_amount = 5
	organ_names = list("chest", "lower body", "left arm", "right arm", "left leg", "right leg", "head")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
	stop_automated_movement_when_pulled = 0
	maxhealth = 80
	melee_damage_lower = 10
	melee_damage_upper = 18
	armor_penetration = 30 //Standard armor probably doesn't help against a bear, does it?
	attack_flags = DAMAGE_FLAG_EDGE|DAMAGE_FLAG_SHARP
	resist_mod = 4
	break_stuff_probability = 80
	mob_size = 17
	butchering_products = list(/obj/item/clothing/head/bearpelt = 1)

	attacktext = null//This allows custom attacking emotes
	attack_vis_effect = ATTACK_EFFECT_CLAW

	var/quiet_sounds = list('sound/effects/creatures/bear_quiet_1.ogg',
	'sound/effects/creatures/bear_quiet_2.ogg',
	'sound/effects/creatures/bear_quiet_3.ogg',
	'sound/effects/creatures/bear_quiet_4.ogg',
	'sound/effects/creatures/bear_quiet_5.ogg',
	'sound/effects/creatures/bear_quiet_6.ogg')
	var/loud_sounds = list('sound/effects/creatures/bear_loud_1.ogg',
	'sound/effects/creatures/bear_loud_2.ogg',
	'sound/effects/creatures/bear_loud_3.ogg',
	'sound/effects/creatures/bear_loud_4.ogg')
	var/bearmode
	//Bears in space, or other low-pressure environments are stronger. Higher health, faster movement, longer aggression before being tired

	var/anger
	//An angry bear will immediately attack anyone it sees without warning
	//Anger decreases at 1 point per minute
	//Any amount of anger causes instant aggro, quantity of it is only a duration


	//Space bears aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "russian"

	var/always_space_mode = FALSE	// If true, bear will always be in BEARMODE_SPACE, regardless of surroundings.


//SPACE BEARS! SQUEEEEEEEE~     OW! FUCK! IT BIT MY HAND OFF!!
/mob/living/simple_animal/hostile/bear/Hudson
	name = "Hudson"
	desc = ""
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"

/mob/living/simple_animal/hostile/bear/Initialize()
	. = ..()
	emote_sounds = quiet_sounds
	update_bearmode()
	ADD_TRAIT(src, TRAIT_MC_SPACE_FAUNA, TRAIT_SOURCE_MOB_CATEGORY)



//Causes the bear to find and start attacking the nearest target.
//This will overwrite any existing target if a different one is closer
//If there are no other suitable targets, targeting will not be changed



/mob/living/simple_animal/hostile/bear/proc/AIBearTired()
	custom_emote(VISIBLE_MESSAGE, "is worn out and needs to rest." )
	speak_audio()
	GLOB.move_manager.stop_looping(src) //This stops the bear's walking

/mob/living/simple_animal/hostile/bear/attackby(obj/item/attacking_item, mob/user)
	var/healthbefore = health
	..()
	if (health < healthbefore)//Hurting the bear makes it mad
		anger++
		instant_aggro(user)


/mob/living/simple_animal/hostile/bear/attack_hand(mob/living/carbon/human/M as mob)
	var/healthbefore = health
	..()
	if(health < healthbefore)//Hurting the bear makes it mad
		anger++
		instant_aggro(M)

//Teleport around when shot, so its harder to burst it down with a carbine
/mob/living/simple_animal/hostile/bear/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	var/healthbefore = health

	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	if (health < healthbefore)
		instant_aggro()

/mob/living/simple_animal/hostile/bear/ex_act(var/severity = 2.0)
	var/healthbefore = health
	..()
	if (health < healthbefore)
		instant_aggro()


/mob/living/simple_animal/hostile/bear/Allow_Spacemove(var/check_drift = 0)
	inertia_dir = 0
	return 1	//No drifting in space for space bears!
	//Fixed this, it wasnt working



/mob/living/simple_animal/hostile/bear/proc/AIBearAttackEffect(atom/attack_target)
	custom_emote(VISIBLE_MESSAGE, pick("crushes [attack_target] in its arms", "slashes at [attack_target]", "bites [attack_target]", "mauls [attack_target]", "tears into [attack_target]", "rends [attack_target]"))
	if(prob(15))
		growl_loud()
	else if(prob(10))
		growl_soft()


/mob/living/simple_animal/hostile/bear/proc/update_bearmode()
	turns_per_move = initial(turns_per_move)
	if (anger >= 3)
		turns_per_move -= 1


	var/former = bearmode
	bearmode = BEARMODE_INDOORS
	if(always_space_mode || loc && istype(loc,/turf/space))
		bearmode = BEARMODE_SPACE
	else
		if(istype(loc,/turf))
			var/turf/T = loc
			var/datum/gas_mixture/environment = T.return_air()
			if (XGM_PRESSURE(environment) <= 80)
				bearmode = BEARMODE_SPACE

	if (bearmode != former)
		var/healthpercent
		if (bearmode == BEARMODE_SPACE)
			custom_emote(VISIBLE_MESSAGE, "looks bright, energised and aggressive!" )
			healthpercent = health / maxhealth
			maxhealth = initial(maxhealth) * 1.5
			health = maxhealth * healthpercent
			melee_damage_lower = initial(melee_damage_lower)*1.2
			melee_damage_upper = initial(melee_damage_upper)*1.2
			turns_per_move -= 2
			growl_loud()
		else
			custom_emote(VISIBLE_MESSAGE, "looks darker and more subdued." )
			healthpercent = health / maxhealth
			maxhealth = initial(maxhealth)
			health = maxhealth * healthpercent
			melee_damage_lower = initial(melee_damage_lower)
			melee_damage_upper = initial(melee_damage_upper)
			growl_soft()

	update_icon()


/mob/living/simple_animal/hostile/bear/update_icon()
	if (stat == DEAD)
		icon_state = "bear_dead"
	else if (bearmode == BEARMODE_INDOORS)
		icon_state = "bearfloor"
	else
		icon_state = "bear"


/mob/living/simple_animal/hostile/bear/speak_audio()
	if (anger > 5 || (anger && prob(25)))
		growl_loud()
	else
		growl_soft()


//Plays a random selection of six sounds, at a low volume
//This is triggered randomly periodically by the bear
/mob/living/simple_animal/hostile/bear/proc/growl_soft()
	var/sound = pick(quiet_sounds)
	playsound(src, sound, 50, 1,3, pressure_affected = 0)


//Plays a loud sound from a selection of four
//Played when bear is attacking or dies
/mob/living/simple_animal/hostile/bear/proc/growl_loud()
	var/sound = pick(loud_sounds)
	playsound(src, sound, 85, 1, 5, pressure_affected = 0)

//A special bear subclass which is more powerful and has the ability to teleport around to seek out prey.
//It dislikes other bears and refuses to cooperate with them. If two of them see each other, one or both will teleport away
//Therefore the crew never has to fight more than one at a time
/mob/living/simple_animal/hostile/bear/spatial
	ai_holder_type = /datum/ai_holder/simple_animal/bear/spatial
	name = "bluespace bear"
	desc = "*bzzt*..Rawr!!"
	maxhealth = 130
	turns_per_move = 7
	break_stuff_probability = 100//Constantly smashing everything nearby
	speak_chance = 15
	var/teleport_delay = 60
	var/tactical_delay = 3//Procs between shortrange teleports
	var/datum/effect_system/sparks/spark_system
	always_space_mode = TRUE

/mob/living/simple_animal/hostile/bear/spatial/Initialize()
	. = ..()
	spark_system = bind_spark(src, 5)

/mob/living/simple_animal/hostile/bear/spatial/Destroy()
	QDEL_NULL(spark_system)
	return ..()

//Called when we want to bypass ticks and attack immediately. For example in response to being shot
//This calls several procs and some duplicated code from the parent class to immediately put us in an assault state and lash out
/mob/living/simple_animal/hostile/bear/proc/instant_aggro(atom/forced_target)
	var/datum/ai_holder/simple_animal/bear/bear_ai = ai_holder
	bear_ai?.enrage(forced_target)


//Used to move to a new part of the station when it sees another bear, or it hasnt found any prey
//Used, with some luck, to reposition near the target. Hiding behind glass is a bad idea
//Picks a random tile in the target's area and teleports there. Might be closer, might be farther away
//Who knows, it's unpredictable. But definitely dangerous.
//This allows the target to escape as often as it allows the bear to attack
/mob/living/simple_animal/hostile/bear/spatial/proc/teleport_to(var/turf/target)
	if (stat != CONSCIOUS)
		return

	spark(src.loc, 5)
	forceMove(target)
	spark_system.queue()

//Teleport around when shot, so its harder to burst it down with a carbine
/mob/living/simple_animal/hostile/bear/spatial/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	if (prob(hitting_projectile.damage*1.5))//Bear has a good chance of teleporting when shot, making it harder to burst down
		var/datum/ai_holder/simple_animal/bear/spatial/bear_ai = ai_holder
		bear_ai?.tactical_teleport()


#undef BEARMODE_INDOORS
#undef BEARMODE_SPACE
