#define DEFAULT_SEED "glowshroom"
#define VINE_GROWTH_STAGES 5

/proc/spacevine_infestation(var/potency_min=85, var/potency_max=100, var/maturation_min=1, var/maturation_max=3)
	/// List of areas to affect.
	var/list/area/areaList = list()
	/// Area types to include.
	var/list/areaType = list(
		/area/horizon/hallway,
		/area/horizon/security/hallway,
		/area/horizon/engineering/hallway,
		/area/horizon/medical/hallway,
		/area/horizon/operations/lobby,
		/area/horizon/rnd/hallway,
		/area/horizon/security/hallway,
		/area/horizon/security/investigations_hallway,
		/area/horizon/service/cafeteria,
		/area/horizon/hangar
		)
	for(var/area/area in GLOB.the_station_areas)
		if(is_type_in_list(area, areaType))
			areaList += area

	var/turf/T = pick_subarea_turf(pick(areaList), list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
	if(T)
		var/datum/seed/seed = SSplants.create_random_seed(TRUE, SEED_NOUN_PITS)
		seed.set_trait(TRAIT_SPREAD,2)             // So it will function properly as vines.
		seed.growth_stages = VINE_GROWTH_STAGES
		seed.set_trait(TRAIT_POTENCY,rand(potency_min, potency_max)) // 85-100 potency will help guarantee a wide spread and powerful effects.
		seed.set_trait(TRAIT_MATURATION,rand(maturation_min, maturation_max))

		//make vine zero start off fully matured
		var/obj/effect/plant/vine = new(T,seed)
		vine.health = vine.max_health
		vine.mature_time = 0
		vine.process()
		var/area_display_name = get_area_display_name(get_area(T))

		log_and_message_admins("Spacevines spawned at \the [area_display_name]", location = T)
		return

	log_and_message_admins(SPAN_NOTICE("Event: Spacevines failed to find a viable turf."))

/obj/effect/dead_plant
	anchored = 1
	opacity = 0
	density = 0
	color = DEAD_PLANT_COLOUR

/obj/effect/dead_plant/attack_hand()
	qdel(src)

/obj/effect/dead_plant/attackby()
	..()
	for(var/obj/effect/plant/neighbor in range(1))
		neighbor.update_neighbors()
	qdel(src)

/obj/effect/plant
	name = "plant"
	anchored = 1
	opacity = 0
	density = 0
	icon = 'icons/obj/hydroponics_growing.dmi'
	icon_state = ""
	layer = 3
	movable_flags = MOVABLE_FLAG_PROXMOVE
	pass_flags = PASSTABLE
	mouse_opacity = MOUSE_OPACITY_OPAQUE

	var/health = 10
	var/max_health = 100
	var/growth_threshold = 0
	var/growth_type = 0

	///The maximum growth of this plant effect, aka the maximum stage
	var/max_growth = 0
	var/list/neighbors = list()
	var/obj/effect/plant/parent
	var/datum/seed/seed
	var/sampled = 0
	var/floor = 0
	var/spread_chance = 40
	var/spread_distance = 3
	var/evolve_chance = 2
	var/mature_time		//minimum maturation time
	var/last_tick = 0
	var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/plant
	var/last_biolum = null

/obj/effect/plant/Destroy()
	SSplants.remove_plant(src)
	for(var/obj/effect/plant/neighbor in range(1,src))
		if (!QDELETED(neighbor))
			SSplants.add_plant(neighbor)
	return ..()

/obj/effect/plant/single
	spread_chance = 0

/obj/effect/plant/Initialize(mapload, datum/seed/newseed, obj/effect/plant/newparent)
	. = ..()

	if(!newparent)
		parent = src
	else
		parent = newparent

	if(!SSplants)
		to_world(SPAN_DANGER("Plant controller does not exist and [src] requires it. Aborting."))
		qdel(src)
		return

	if(!istype(newseed))
		newseed = SSplants.seeds[DEFAULT_SEED]
	seed = newseed
	if(!seed)
		qdel(src)
		return

	name = seed.display_name
	max_health = round(seed.get_trait(TRAIT_ENDURANCE)/2)
	if(seed.get_trait(TRAIT_SPREAD) == 2)
		mouse_opacity = 2
		max_growth = VINE_GROWTH_STAGES
		growth_threshold = max_health/VINE_GROWTH_STAGES
		growth_type = seed.get_growth_type()
	else
		max_growth = seed.growth_stages
		growth_threshold = max_health/seed.growth_stages

	if(max_growth > 2 && prob(50))
		max_growth-- //Ensure some variation in final sprite, makes the carpet of crap look less wonky.

	can_buckle = list(/mob/living)

	mature_time = world.time + seed.get_trait(TRAIT_MATURATION) + 15 //prevent vines from maturing until at least a few seconds after they've been created.
	spread_chance = seed.get_trait(TRAIT_POTENCY)
	spread_distance = (growth_type ? round(spread_chance * 0.6) : round(spread_chance * 0.3))
	update_icon()
	return INITIALIZE_HINT_LATELOAD

// Plants will sometimes be spawned in the turf adjacent to the one they need to end up in, for the sake of correct dir/etc being set.
/obj/effect/plant/LateInitialize()
	. = ..()
	set_dir(calc_dir())
	update_icon()
	SSplants.add_plant(src)
	// Some plants eat through plating.
	if(islist(seed.chems) && !isnull(seed.chems[/singleton/reagent/acid/polyacid]))
		var/turf/T = get_turf(src)
		T.ex_act(prob(80) ? 3 : 2)

/obj/effect/plant/update_icon()
	//TODO: should really be caching this.
	refresh_icon()
	if(!growth_type && !floor)
		src.transform = null
		var/matrix/M = matrix()
		// should make the plant flush against the wall it's meant to be growing from.
		M.Translate(0,-(rand(12,14)))
		switch(dir)
			if(WEST)
				M.Turn(90)
			if(NORTH)
				M.Turn(180)
			if(EAST)
				M.Turn(270)
		src.transform = M
	var/icon_colour = seed.get_trait(TRAIT_PLANT_COLOUR)
	if(icon_colour)
		color = icon_colour
	// Apply colour and light from seed datum.
	if(seed.get_trait(TRAIT_BIOLUM))
		var/clr
		if(seed.get_trait(TRAIT_BIOLUM_COLOUR))
			clr = seed.get_trait(TRAIT_BIOLUM_COLOUR)
		var/val = 1+round(seed.get_trait(TRAIT_POTENCY)/20)
		if (val != last_biolum)
			last_biolum = val
			set_light(val, l_color = clr)
		return
	else
		if (last_biolum)
			set_light(0)
			last_biolum = null

/obj/effect/plant/proc/refresh_icon()
	SHOULD_NOT_SLEEP(TRUE)

	overlays.Cut()
	var/growth = 0
	if(growth_threshold)
		growth = min(max_growth, round(health/growth_threshold))
	var/at_fringe = get_dist(src,parent)
	if(spread_distance > 5)
		if(at_fringe >= (spread_distance-3))
			max_growth--
		if(at_fringe >= (spread_distance-2))
			max_growth--

	var/image/our_icon = seed.get_icon(growth)

	if(!istype(our_icon))
		crash_with("The plant didn't return an icon!")

	AddOverlays(our_icon)

	if(growth>2 && growth == max_growth)
		layer = (seed && seed.force_layer) ? seed.force_layer : 5
		if(growth_type in list(GROWTH_VINES,GROWTH_BIOMASS))
			opacity = 1
		if(islist(seed.chems) && !isnull(seed.chems[/singleton/reagent/woodpulp]))
			opacity = 1
			density = 1
	if(seed.get_trait(TRAIT_LARGE))
		density = 1
		opacity = 1
	else
		layer = (seed && seed.force_layer) ? seed.force_layer : 5
		density = 0

/obj/effect/plant/proc/calc_dir()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	var/direction = 16

	for(var/wallDir in GLOB.cardinals)
		var/turf/newTurf = get_step(T,wallDir)
		if(newTurf.density)
			direction |= wallDir

	for(var/obj/effect/plant/shroom in T.contents)
		if(shroom == src)
			continue
		if(shroom.floor) //special
			direction &= ~16
		else
			direction &= ~shroom.dir

	var/list/dirList = list()

	for(var/i=1,i<=16,i <<= 1)
		if(direction & i)
			dirList += i

	if(dirList.len)
		var/newDir = pick(dirList)
		if(newDir == 16)
			floor = 1
			newDir = 1
		return newDir

	floor = 1
	return 1

/obj/effect/plant/attackby(obj/item/attacking_item, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	SSplants.add_plant(src)

	if(attacking_item.iswirecutter() || istype(attacking_item, /obj/item/surgery/scalpel))
		if(sampled)
			to_chat(user, SPAN_WARNING("\The [src] has already been sampled recently."))
			return
		if(!is_mature())
			to_chat(user, SPAN_WARNING("\The [src] is not mature enough to yield a sample yet."))
			return
		if(!seed)
			to_chat(user, SPAN_WARNING("There is nothing to take a sample from."))
			return
		if(sampled)
			to_chat(user, SPAN_DANGER("You cannot take another sample from \the [src]."))
			return
		if(prob(70))
			sampled = 1
		seed.harvest(user,0,1)
		health -= (rand(3,5)*5)
		sampled = 1
	else
		playsound(loc, /singleton/sound_category/wood_break_sound, 50, TRUE)
		var/damage = attacking_item.force ? attacking_item.force : 1 //always do at least a little damage
		if(attacking_item.edge || attacking_item.sharp)
			damage *= 2
		health -= damage
	check_health()

/obj/effect/plant/attack_hand(user)
	if(!ishuman(user))
		return FALSE

	manual_unbuckle(user)

	var/mob/living/carbon/human/H = user
	playsound(loc, /singleton/sound_category/wood_break_sound, 50, TRUE)
	var/damage = H.default_attack.get_unarmed_damage(H, src) ? H.default_attack.get_unarmed_damage(H, src) : 1
	if(H.default_attack.edge || H.default_attack.sharp)
		damage *= 2
	health -= damage
	check_health()

/obj/effect/plant/ex_act(severity)
	switch(severity)
		if(1.0)
			die_off()
			return
		if(2.0)
			if (prob(50))
				die_off()
				return
		if(3.0)
			if (prob(5))
				die_off()
				return

	return

/obj/effect/plant/proc/check_health()
	if(health <= 0)
		die_off()

/obj/effect/plant/proc/is_mature()
	return (health >= (max_health/3) && world.time > mature_time)


#undef DEFAULT_SEED
#undef VINE_GROWTH_STAGES
