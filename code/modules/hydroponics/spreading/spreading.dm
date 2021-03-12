#define DEFAULT_SEED "glowshroom"
#define VINE_GROWTH_STAGES 5

/proc/spacevine_infestation(var/potency_min=70, var/potency_max=100, var/maturation_min=5, var/maturation_max=15)
	set waitfor = FALSE

	var/turf/T = pick_subarea_turf(/area/hallway, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
	if(T)
		var/datum/seed/seed = SSplants.create_random_seed(1)
		seed.set_trait(TRAIT_SPREAD,2)             // So it will function properly as vines.
		seed.set_trait(TRAIT_POTENCY,rand(potency_min, potency_max)) // 70-100 potency will help guarantee a wide spread and powerful effects.
		seed.set_trait(TRAIT_MATURATION,rand(maturation_min, maturation_max))

		//make vine zero start off fully matured
		var/obj/effect/plant/vine = new(T,seed)
		vine.health = vine.max_health
		vine.mature_time = 0
		vine.process()

		log_and_message_admins("Spacevines spawned at \the [get_area(T)]", location = T)
		return

	log_and_message_admins("<span class='notice'>Event: Spacevines failed to find a viable turf.</span>")

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
	icon_state = "bush4-1"
	layer = 3
	pass_flags = PASSTABLE
	mouse_opacity = 2

	var/health = 10
	var/max_health = 100
	var/growth_threshold = 0
	var/growth_type = 0
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
		to_world("<span class='danger'>Plant controller does not exist and [src] requires it. Aborting.</span>")
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
	if(seed.get_trait(TRAIT_SPREAD)==2)
		max_growth = VINE_GROWTH_STAGES
		growth_threshold = max_health/VINE_GROWTH_STAGES
		icon = 'icons/obj/hydroponics_vines.dmi'
		growth_type = 2 // Vines by default.
		if(seed.get_trait(TRAIT_CARNIVOROUS) == 2)
			growth_type = 1 // WOOOORMS.
		else if(!(seed.seed_noun in list(SEED_NOUN_SEEDS,SEED_NOUN_PITS)))
			if(seed.seed_noun == SEED_NOUN_NODES)
				growth_type = 3 // Biomass
			else
				growth_type = 4 // Mold
	else
		max_growth = seed.growth_stages
		growth_threshold = max_health/seed.growth_stages

	if(max_growth > 2 && prob(50))
		max_growth-- //Ensure some variation in final sprite, makes the carpet of crap look less wonky.

	can_buckle = list(/mob/living)

	mature_time = world.time + seed.get_trait(TRAIT_MATURATION) + 15 //prevent vines from maturing until at least a few seconds after they've been created.
	spread_chance = seed.get_trait(TRAIT_POTENCY)
	spread_distance = ((growth_type > 0) ? round(spread_chance * 0.6) : round(spread_chance * 0.3))
	update_icon()
	addtimer(CALLBACK(src, .proc/post_initialize), 1)

// Plants will sometimes be spawned in the turf adjacent to the one they need to end up in, for the sake of correct dir/etc being set.
/obj/effect/plant/proc/post_initialize()
	set_dir(calc_dir())
	update_icon()
	SSplants.add_plant(src)
	// Some plants eat through plating.
	if(islist(seed.chems) && !isnull(seed.chems[/decl/reagent/acid/polyacid]))
		var/turf/T = get_turf(src)
		T.ex_act(prob(80) ? 3 : 2)

/obj/effect/plant/update_icon()
	//TODO: should really be caching this.
	refresh_icon()
	if(growth_type == 0 && !floor)
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
	if(!growth_threshold)
		growth_threshold = max_health/seed.growth_stages
	var/growth = min(max_growth,round(health/growth_threshold))
	var/at_fringe = get_dist(src,parent)
	if(spread_distance > 5)
		if(at_fringe >= (spread_distance-3))
			max_growth--
		if(at_fringe >= (spread_distance-2))
			max_growth--
	max_growth = max(1,max_growth)
	if(growth_type > 0)
		switch(growth_type)
			if(1)
				icon_state = "worms"
			if(2)
				icon_state = "vines-[growth]"
			if(3)
				icon_state = "mass-[growth]"
			if(4)
				icon_state = "mold-[growth]"
	else
		icon_state = "[seed.get_trait(TRAIT_PLANT_ICON)]-[growth]"

	if(growth>2 && growth == max_growth)
		layer = (seed && seed.force_layer) ? seed.force_layer : 5
		opacity = 1
		if(islist(seed.chems) && !isnull(seed.chems[/decl/reagent/woodpulp]))
			density = 1
	else
		layer = (seed && seed.force_layer) ? seed.force_layer : 5
		density = 0

/obj/effect/plant/proc/calc_dir()
	set background = 1
	var/turf/T = get_turf(src)
	if(!istype(T)) return

	var/direction = 16

	for(var/wallDir in cardinal)
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

/obj/effect/plant/attackby(var/obj/item/W, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	SSplants.add_plant(src)

	if(W.iswirecutter() || istype(W, /obj/item/surgery/scalpel))
		if(sampled)
			to_chat(user, "<span class='warning'>\The [src] has already been sampled recently.</span>")
			return
		if(!is_mature())
			to_chat(user, "<span class='warning'>\The [src] is not mature enough to yield a sample yet.</span>")
			return
		if(!seed)
			to_chat(user, "<span class='warning'>There is nothing to take a sample from.</span>")
			return
		if(sampled)
			to_chat(user, "<span class='danger'>You cannot take another sample from \the [src].</span>")
			return
		if(prob(70))
			sampled = 1
		seed.harvest(user,0,1)
		health -= (rand(3,5)*5)
		sampled = 1
	else
		playsound(loc, /decl/sound_category/wood_break_sound, 50, TRUE)
		var/damage = W.force ? W.force : 1 //always do at least a little damage
		if(W.edge || W.sharp)
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
		else
	return

/obj/effect/plant/proc/check_health()
	if(health <= 0)
		die_off()

/obj/effect/plant/proc/is_mature()
	return (health >= (max_health/3) && world.time > mature_time)
