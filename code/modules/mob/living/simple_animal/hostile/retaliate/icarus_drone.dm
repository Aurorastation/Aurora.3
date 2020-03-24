// friendly icarus combat drones
/mob/living/simple_animal/hostile/retaliate/icarus_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon_state = "drone3"
	icon_living = "drone3"
	icon_dead = "drone_dead"
	ranged = TRUE
	rapid = TRUE
	speak_chance = 5
	turns_per_move = 3
	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	speak = list("ALERT, Icarus Drone active and patrolling!", "Hostile entities in the area!", "Threat parameters nominal.", "Subsystems stable at combat level theta.")
	emote_see = list("beeps menacingly", "whirrs threateningly", "scans its immediate vicinity")
	a_intent = I_HURT
	stop_automated_movement_when_pulled = FALSE
	health = 300
	maxHealth = 300
	speed = 8
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'
	destroy_surroundings = FALSE
	var/datum/effect_system/ion_trail/ion_trail

	var/turf/patrol_target
	var/explode_chance = 1
	var/disabled = FALSE
	var/exploding = FALSE

	//Drones aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	var/has_loot = TRUE
	faction = "neutral"

	tameable = FALSE

	flying = TRUE
	smart = TRUE

/mob/living/simple_animal/hostile/retaliate/icarus_drone/Initialize()
	. = ..()
	if(prob(5))
		projectiletype = /obj/item/projectile/beam/pulse/drone
		projectilesound = 'sound/weapons/pulse2.ogg'
	ion_trail = new(src)
	ion_trail.start()
	visible_message(SPAN_WARNING("\The [src] appears out of thin air!"))
	spark(src, 3, alldirs)
	addtimer(CALLBACK(src, .proc/beam_out), 5 MINUTES)

/mob/living/simple_animal/hostile/retaliate/icarus_drone/proc/beam_out()
	visible_message(SPAN_WARNING("\The [src] disappears into thin air!"))
	spark(src, 3, alldirs)
	has_loot = FALSE
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/icarus_drone/Allow_Spacemove(var/check_drift = 0)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/icarus_drone/ListTargets()
	return view(src, 10)

/mob/living/simple_animal/hostile/retaliate/icarus_drone/isSynthetic()
	return TRUE

//self repair systems have a chance to bring the drone back to life
/mob/living/simple_animal/hostile/retaliate/icarus_drone/Life()
	//emps and lots of damage can temporarily shut us down
	if(disabled > 0)
		stat = UNCONSCIOUS
		icon_state = "drone_dead"
		disabled--
		wander = 0
		speak_chance = 0
		if(disabled <= 0)
			stat = CONSCIOUS
			icon_state = "drone0"
			wander = 1
			speak_chance = 5

	//repair a bit of damage
	if(prob(1))
		src.visible_message(span("alert", "\The [src] shudders and shakes as some of its damaged systems come back online."))
		spark(src, 3, alldirs)
		health += rand(25,100)

	if(health / maxHealth > 0.9)
		icon_state = "drone3"
		explode_chance = 0
	else if(health / maxHealth > 0.7)
		icon_state = "drone2"
		explode_chance = 0
	else if(health / maxHealth > 0.5)
		icon_state = "drone1"
		explode_chance = 0.5
	else if(health / maxHealth > 0.3)
		icon_state = "drone0"
		explode_chance = 5
	else if(health > 0)
		//if health gets too low, shut down
		icon_state = "drone_dead"
		exploding = FALSE
		if(!disabled)
			visible_message(pick(SPAN_NOTICE("\The [src] suddenly shuts down!"), SPAN_NOTICE("\The [src] suddenly lies still and quiet.")))
			disabled = rand(150, 600)
			walk(src, 0)

	if(exploding && prob(20))
		visible_message(pick(SPAN_WARNING("\The [src] begins to spark and shake violently!"), SPAN_WARNING("\The [src] sparks and shakes like it's about to explode!")))
		spark(src, 3, alldirs)

	if(!exploding && !disabled && prob(explode_chance))
		exploding = TRUE
		stat = UNCONSCIOUS
		wander = 1
		walk(src,0)
		spawn(rand(50, 150))
			if(!disabled && exploding)
				explosion(get_turf(src), 0, 1, 4, 7)
	..()

//ion rifle!
/mob/living/simple_animal/hostile/retaliate/icarus_drone/emp_act(severity)
	health -= rand(3,15) * (severity + 1)
	disabled = rand(150, 600)
	walk(src,0)

/mob/living/simple_animal/hostile/retaliate/icarus_drone/death()
	..(null, "suddenly breaks apart.")
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/icarus_drone/Destroy()
	QDEL_NULL(ion_trail)
	//some random debris left behind
	if(has_loot)
		spark(src, 3, alldirs)
		var/obj/O

		//shards
		O = new /obj/item/material/shard(get_turf(src))
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/material/shard(get_turf(src))
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/material/shard(get_turf(src))
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/material/shard(get_turf(src))
			step_to(O, get_turf(pick(view(7, src))))

		//rods
		O = new /obj/item/stack/rods(get_turf(src))
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/stack/rods(get_turf(src))
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/stack/rods(get_turf(src))
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/stack/rods(get_turf(src))
			step_to(O, get_turf(pick(view(7, src))))

		//plasteel
		O = new /obj/item/stack/material/plasteel(get_turf(src))
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/stack/material/plasteel(get_turf(src))
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/stack/material/plasteel(get_turf(src))
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/stack/material/plasteel(get_turf(src))
			step_to(O, get_turf(pick(view(7, src))))

		//also drop dummy circuit boards deconstructable for research (loot)
		var/obj/item/circuitboard/C

		//spawn 1-4 boards of a random type
		var/spawnees = 0
		var/num_boards = rand(1, 4)
		var/list/options = list(1, 2, 4, 8, 16, 32, 64, 128, 256)
		for(var/i = 0, i < num_boards, i++)
			var/chosen = pick(options)
			options.Remove(options.Find(chosen))
			spawnees |= chosen

		if(spawnees & 1)
			C = new(get_turf(src))
			C.name = "drone CPU motherboard"
			C.origin_tech = list(TECH_DATA = rand(3, 6))

		if(spawnees & 2)
			C = new(get_turf(src))
			C.name = "drone neural interface"
			C.origin_tech = list(TECH_BIO = rand(3, 6))

		if(spawnees & 4)
			C = new(get_turf(src))
			C.name = "drone suspension processor"
			C.origin_tech = list(TECH_MAGNET = rand(3, 6))

		if(spawnees & 8)
			C = new(get_turf(src))
			C.name = "drone shielding controller"
			C.origin_tech = list(TECH_BLUESPACE = rand(3, 6))

		if(spawnees & 16)
			C = new(get_turf(src))
			C.name = "drone power capacitor"
			C.origin_tech = list(TECH_POWER = rand(3, 6))

		if(spawnees & 32)
			C = new(get_turf(src))
			C.name = "drone hull reinforcer"
			C.origin_tech = list(TECH_MATERIAL = rand(3, 6))

		if(spawnees & 64)
			C = new(get_turf(src))
			C.name = "drone auto-repair system"
			C.origin_tech = list(TECH_ENGINEERING = rand(3, 6))

		if(spawnees & 128)
			C = new(get_turf(src))
			C.name = "drone phoron overcharge counter"
			C.origin_tech = list(TECH_PHORON = rand(3, 6))

		if(spawnees & 256)
			C = new(get_turf(src))
			C.name = "drone targetting circuitboard"
			C.origin_tech = list(TECH_COMBAT = rand(3, 6))

	return ..()

/mob/living/simple_animal/hostile/retaliate/icarus_drone/validator_living(var/mob/living/L, var/atom/current)
	if(L.health <= 0)
		return FALSE
	if(istype(L, /mob/living/simple_animal/hostile/hivebot))
		return TRUE
	if(istype(L, /mob/living/simple_animal/hostile/carp))
		return TRUE
	if(istype(L, /mob/living/simple_animal/hostile/retaliate/cavern_dweller))
		return TRUE
	if(istype(L, /mob/living/simple_animal/hostile/giant_spider))
		return TRUE
	if(istype(L, /mob/living/simple_animal/hostile/spider_queen))
		return TRUE
	if(istype(L, /mob/living/simple_animal/hostile/retaliate/malf_drone))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/retaliate/icarus_drone/validator_bot(var/obj/machinery/bot/B, var/atom/current)
	return FALSE

/mob/living/simple_animal/hostile/retaliate/icarus_drone/validator_turret(var/obj/machinery/porta_turret/T, var/atom/current)
	return FALSE

/mob/living/simple_animal/hostile/retaliate/icarus_drone/validator_e_field(var/obj/effect/energy_field/E, var/atom/current)
	return FALSE