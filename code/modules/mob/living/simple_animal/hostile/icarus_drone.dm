/mob/living/simple_animal/hostile/icarus_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding. This one has the markings of the NDV Icarus on the side."
	desc_fluff = "Produced by NanoTrasen, these combat drones are often carried and deployed by NDV Drone Carriers to protect local assets."
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
	attack_emote = "shifts its targetting vanes towards"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = FALSE
	health = 300
	maxHealth = 300
	blood_type = "#000000"
	speed = 8
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'
	destroy_surroundings = 0
	var/datum/effect_system/ion_trail/ion_trail
	belongs_to_station = TRUE

	//the drone randomly switches between these states when it's malfunctioning
	var/hostile_drone = FALSE
	// FALSE - retaliate, only attack enemies that attack it
	// TRUE - hostile, attack everything that comes near

	var/turf/patrol_target
	var/explode_chance = 1
	var/malfunctioning = FALSE
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
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/mob/living/simple_animal/hostile/icarus_drone/Initialize()
	. = ..()
	if(prob(5))
		projectiletype = /obj/item/projectile/beam/pulse/drone
		projectilesound = 'sound/weapons/pulse2.ogg'
	ion_trail = new(src)
	ion_trail.start()
	if(!malfunctioning)
		addtimer(CALLBACK(src, .proc/beam_out), 15 MINUTES)

	// warp in effect
	var/matrix/M = matrix()
	M.Scale(0.1, 0.1)
	animate(src, transform = M, time = 0.1, easing = LINEAR_EASING)

	spark(src, 3, alldirs)

	var/matrix/N = matrix()
	N.Scale(1, 1)
	animate(src, transform = N, time = 2, easing = SINE_EASING)

/mob/living/simple_animal/hostile/icarus_drone/proc/beam_out()
	if(malfunctioning) // if we somehow start malfunctioning after init, don't beam out
		return
	visible_message(SPAN_WARNING("\The [src] warps into nothingness!"))

	spark(src, 3, alldirs)

	var/matrix/M = matrix()
	M.Scale(0.1, 0.1)
	animate(src, transform = M, time = 2, easing = LINEAR_EASING)

	has_loot = FALSE
	qdel(src)

/mob/living/simple_animal/hostile/icarus_drone/examine(mob/user)
	..()
	if(malfunctioning)
		if(hostile_drone)
			to_chat(user, SPAN_WARNING("It's completely lit up, and its targetting vanes are deployed."))
		else
			to_chat(user, SPAN_WARNING("Most of its lights are off, and its targetting vanes are retracted."))

/mob/living/simple_animal/hostile/icarus_drone/do_animate_chat(var/message, var/datum/language/language, var/small, var/list/show_to, var/duration, var/list/message_override)
	INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, message, language, small, show_to, duration)

/mob/living/simple_animal/hostile/icarus_drone/Allow_Spacemove(var/check_drift = 0)
	return TRUE

/mob/living/simple_animal/hostile/icarus_drone/validator_living(var/mob/living/L, var/atom/current)
	if(malfunctioning)
		return ..()
	if(L.stat == DEAD)
		return FALSE
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/card/id/ID = H.GetIdCard(TRUE)
		if(!ID) // can't identify, too risky, don't shoot
			return FALSE
		if(!H.handcuffed) // don't shoot cuffed people
			var/datum/record/general/R = SSrecords.find_record("name", ID.registered_name)
			if(istype(R) && istype(R.security) && R.security.criminal == "*Arrest*") // blast free criminals
				return TRUE
		return FALSE // generally, don't shoot humans
	if(istype(L, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/SA = L
		if(SA.belongs_to_station)
			return FALSE
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/icarus_drone/validator_bot(var/obj/machinery/bot/B, var/atom/current)
	if(malfunctioning)
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/icarus_drone/validator_turret(var/obj/machinery/porta_turret/T, var/atom/current)
	if(malfunctioning)
		return ..()
	if(is_station_area(get_area(T))) // any turrets not on station turf is probably hostile
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/icarus_drone/validator_e_field(var/obj/effect/energy_field/E, var/atom/current)
	if(malfunctioning)
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/icarus_drone/isSynthetic()
	return TRUE

//self repair systems have a chance to bring the drone back to life
/mob/living/simple_animal/hostile/icarus_drone/Life()
	//emps and lots of damage can temporarily shut us down
	if(disabled > 0)
		stat = UNCONSCIOUS
		icon_state = "drone_dead"
		disabled--
		wander = FALSE
		speak_chance = 0
	else
		stat = CONSCIOUS
		icon_state = "drone0"
		wander = TRUE
		speak_chance = 5

	//repair a bit of damage
	if(prob(1) && health < maxHealth)
		visible_message(SPAN_NOTICE("\The [src] shudders and shakes as some of its damaged systems come back online."))
		spark(src, 3, alldirs)
		health += rand(25, 100)

	//spark for no reason
	if(malfunctioning && prob(5))
		spark(src, 3, alldirs)

	//sometimes our targetting sensors malfunction, and we attack anyone nearby
	if(malfunctioning && prob(disabled ? 0 : 1))
		if(hostile_drone)
			src.visible_message(SPAN_NOTICE("\The [src] retracts several targetting vanes, and dulls its running lights."))
			hostile_drone = FALSE
		else
			src.visible_message(SPAN_ALERT("\The [src] suddenly lights up, and additional targetting vanes slide into place."))
			hostile_drone = TRUE

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
			if(prob(50))
				visible_message(SPAN_NOTICE("\The [src] suddenly shuts down!"))
			else
				visible_message(SPAN_NOTICE("\The [src] suddenly lies still and quiet."))
			disabled = rand(150, 600)
			walk(src, 0)

	if(exploding && prob(20))
		if(prob(50))
			visible_message(SPAN_ALERT("\The [src] begins to spark and shake violently!"))
		else
			visible_message(SPAN_ALERT("\The [src] sparks and shakes like it's about to explode!"))
		spark(src, 3, alldirs)

	if(!exploding && !disabled && prob(explode_chance))
		exploding = TRUE
		stat = UNCONSCIOUS
		wander = 1
		walk(src, 0)
		spawn(rand(50, 150))
			if(!disabled && exploding)
				explosion(get_turf(src), 0, 1, 4, 7)
	..()

//ion rifle!
/mob/living/simple_animal/hostile/icarus_drone/emp_act(severity)
	health -= rand(3, 15) * (severity + 1)
	disabled = rand(150, 600)
	hostile_drone = FALSE
	walk(src, 0)

/mob/living/simple_animal/hostile/icarus_drone/death()
	..(null, "suddenly breaks apart.")
	qdel(src)

/mob/living/simple_animal/hostile/icarus_drone/Destroy()
	QDEL_NULL(ion_trail)
	//some random debris left behind
	if(has_loot)
		spark(src, 3, alldirs)
		var/obj/O

		//shards
		O = new /obj/item/material/shard(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/material/shard(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/material/shard(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/material/shard(src.loc)
			step_to(O, get_turf(pick(view(7, src))))

		//rods
		O = new /obj/item/stack/rods(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/stack/rods(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/stack/rods(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/stack/rods(src.loc)
			step_to(O, get_turf(pick(view(7, src))))

		//plasteel
		O = new /obj/item/stack/material/plasteel(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/stack/material/plasteel(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/stack/material/plasteel(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/stack/material/plasteel(src.loc)
			step_to(O, get_turf(pick(view(7, src))))

		//also drop dummy circuit boards deconstructable for research (loot)
		var/obj/item/circuitboard/C

		//spawn 1-4 boards of a random type
		var/spawnees = 0
		var/num_boards = rand(1, 4)
		var/list/options = list(1, 2, 4, 8, 16, 32, 64, 128, 256)
		if(malfunctioning)
			options += 512
		for(var/i = 0, i < num_boards, i++)
			var/chosen = pick(options)
			options.Remove(options.Find(chosen))
			spawnees |= chosen

		if(spawnees & 1)
			C = new(src.loc)
			C.name = "drone CPU motherboard"
			C.origin_tech = list(TECH_DATA = rand(3, 6))

		if(spawnees & 2)
			C = new(src.loc)
			C.name = "drone neural interface"
			C.origin_tech = list(TECH_BIO = rand(3,6))

		if(spawnees & 4)
			C = new(src.loc)
			C.name = "drone suspension processor"
			C.origin_tech = list(TECH_MAGNET = rand(3,6))

		if(spawnees & 8)
			C = new(src.loc)
			C.name = "drone shielding controller"
			C.origin_tech = list(TECH_BLUESPACE = rand(3,6))

		if(spawnees & 16)
			C = new(src.loc)
			C.name = "drone power capacitor"
			C.origin_tech = list(TECH_POWER = rand(3,6))

		if(spawnees & 32)
			C = new(src.loc)
			C.name = "drone hull reinforcer"
			C.origin_tech = list(TECH_MATERIAL = rand(3,6))

		if(spawnees & 64)
			C = new(src.loc)
			C.name = "Drone auto-repair system"
			C.origin_tech = list(TECH_ENGINEERING = rand(3,6))

		if(spawnees & 128)
			C = new(src.loc)
			C.name = "drone phoron overcharge counter"
			C.origin_tech = list(TECH_PHORON = rand(3,6))

		if(spawnees & 256)
			C = new(src.loc)
			C.name = "drone targetting circuitboard"
			C.origin_tech = list(TECH_COMBAT = rand(3,6))

		if(spawnees & 512)
			C = new(src.loc)
			C.name = "corrupted drone morality core"
			C.origin_tech = list(TECH_ILLEGAL = rand(3,6))

	return ..()

/obj/item/projectile/beam/drone
	damage = 15

/obj/item/projectile/beam/pulse/drone
	damage = 10

/mob/living/simple_animal/hostile/icarus_drone/malf
	speak = list("ALERT.", "Hostile-ile-ile entities dee-twhoooo-wected.", "Threat parameterszzzz- szzet.", "Bring sub-sub-sub-systems uuuup to combat alert alpha-a-a.")
	emote_see = list("beeps menacingly", "whirrs threateningly", "scans its immediate vicinity")
	belongs_to_station = FALSE
	malfunctioning = TRUE
	faction = "malf_drone"