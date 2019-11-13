//I will need to recode parts of this but I am way too tired atm
/obj/effect/blob
	name = "blob"
	icon = 'icons/mob/npc/blob.dmi'
	icon_state = "blob"
	light_range = 3
	light_color = "#b5ff5b"
	desc = "Some blob creature thingy"
	density = 1
	opacity = 0
	anchored = 1
	mouse_opacity = 2
	layer = 4

	var/maxHealth = 30
	var/health
	var/regen_rate = 4
	var/brute_resist = 4
	var/laser_resist = 4 // Special resist for laser based weapons - Emitters or handheld energy weaponry. Damage is divided by this and THEN by fire_resist.
	var/fire_resist = 1
	var/secondary_core_growth_chance = 10.0 //% chance to grow a secondary blob core instead of whatever was suposed to grown. Secondary cores are considerably weaker, but still nasty.
	var/expandType = /obj/effect/blob
	var/obj/effect/blob/core/parent_core = null
	var/blob_may_process = 1
	var/hangry = 0 //if the blob will attack or not.
	var/blob_cost = 1 //point cost of the blob tile

/obj/effect/blob/New(loc)
	START_PROCESSING(SScalamity, src)
	health = maxHealth
	var/matrix/M = matrix()
	M.Turn(90 * pick(0,1,2,3))
	src.transform = M
	update_icon()
	return ..(loc)

/obj/effect/blob/Destroy()
	// Sanity time.
	if (parent_core)
		parent_core.blob_count -= blob_cost
		parent_core = null

	STOP_PROCESSING(SScalamity, src)

	return ..()

/obj/effect/blob/process()
	if(!parent_core)
		src.take_damage(5)
		src.regen_rate = -5
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		return

	// Make deleting the parent more responsive.
	if(QDELING(parent_core))
		parent_core = null
		return

	for(var/mob/living/L in src.loc)
		if(L.stat == DEAD)
			if(prob(10))
				if(istype(L, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = L
					H.ChangeToHusk()
					if(!(HUSK in H.mutations))
						if(health < maxHealth)
							health += rand(10,30)
							if(health > maxHealth)
								health = maxHealth
				else if(istype(L, /mob/living/silicon))
					continue
				else
					L.gib()
					if(health < maxHealth)
						health += rand(10,30)
						if(health > maxHealth)
							health = maxHealth
			continue
		L.visible_message("<span class='danger'>The blob absorbs \the [L]!</span>", "<span class='danger'>The blob absorbs you!</span>")
		playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
		L.take_organ_damage(rand(5, 10))
		if(health < maxHealth)
			health += rand(1,10)
			if(health > maxHealth)
				health = maxHealth
		hangry += 8

	for(var/mob/living/L in range(src,"3x3"))
		var/obj/effect/blob/B = locate() in get_turf(L)
		if(!B)
			if(!hangry)
				if(L.stat == DEAD)
					continue
				if(prob(40))
					L.visible_message("<span class='danger'>The blob sucks \the [L] into itself!</span>", "<span class='danger'>The blob sucks you in!</span>")
					playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
					L.take_organ_damage(rand(5, 10))
					L.forceMove(src.loc)
				else
					L.visible_message("<span class='danger'>The blob glomps \the [L]!</span>", "<span class='danger'>The blob glomps you!</span>")
					playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
					L.take_organ_damage(rand(5, 20))
					if(health < maxHealth)
						health += rand(1,10)
						if(health > maxHealth)
							health = maxHealth
				hangry += 2

	for(var/obj/fire/F in range(src,"3x3")) //very snowflake, but much better than actually coding complex thermodynamics for these fuckers
		if(prob(50))
			src.visible_message("<span class='danger'>The blob melts away under the heat of the flames!</span>")
		F = locate() in get_turf(src)
		if(F)
			src.take_damage(rand(5, 20) / fire_resist)
		else
			src.take_damage(rand(1, 10) / fire_resist)

	for(var/obj/mecha/M in range(src,"3x3"))
		M.visible_message("<span class='danger'>The blob attacks \the [M]!</span>")
		M.take_damage(rand(20,40))

	hangry -= 1
	if(hangry < 0)
		hangry = 0

/obj/effect/blob/CanPass(var/atom/movable/mover, vra/turf/target, var/height = 0, var/air_group = 0)
	if(air_group || height == 0)
		return 1
	return 0

/obj/effect/blob/ex_act(var/severity)
	switch(severity)
		if(1)
			take_damage(rand(100, 120) / brute_resist)
		if(2)
			take_damage(rand(60, 100) / brute_resist)
		if(3)
			take_damage(rand(20, 60) / brute_resist)

/obj/effect/blob/update_icon()
	if(health > maxHealth / 2)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/proc/take_damage(var/damage)
	health -= damage
	if(health < 0)
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
	else
		update_icon()

/obj/effect/blob/proc/regen()
	health = min(health + regen_rate, maxHealth)
	update_icon()

/obj/effect/blob/proc/expand(var/turf/T)
	//Dont epxand over unsimulated unless its astroid trufs
	if(istype(T, /turf/unsimulated/) && !istype(T, /turf/unsimulated/floor/asteroid/))
		return

	//Dont expand over space or holes, unless there´s a lattice
	if((istype(T, /turf/simulated/open) || istype(T, /turf/space)) && !(locate(/obj/structure/lattice) in T))
		return

	//If its rock, mine it
	if(istype(T,/turf/simulated/mineral))
		var/turf/simulated/mineral/M = T
		M.kinetic_hit(8,get_dir(src,M)) //8 so its destroyed in 2 or 3 hits (mineral health is randomized between 10 and 20)
		return

	//If its a wall, destroy it
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/SW = T
		SW.ex_act(2)
		return

	for(var/obj/O in T)
		if(O.density)
			O.ex_act(2)
			return

	// Above things, we destroy completely and thus can use locate. Mobs are different.
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		if(prob(30))
			L.visible_message("<span class='danger'>The blob sucks \the [L] into itself!</span>", "<span class='danger'>The blob sucks you in!</span>")
			playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
			L.take_organ_damage(rand(5, 10))
			L.forceMove(src.loc)
		else
			L.visible_message("<span class='danger'>The blob pulverizes \the [L]!</span>", "<span class='danger'>The blob pulverizes you!</span>")
			playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
			L.take_organ_damage(rand(30, 40))
			if(health < maxHealth)
				health += rand(1,10)
				if(health > maxHealth)
					health = maxHealth
		return

	//If its a astroid turf, ignore it with a 50% chance (so the expansion mostly focuses on the station)
	if(istype(T,/turf/unsimulated/floor/asteroid/) && prob(50))
		return

	if(parent_core)
		if(parent_core.blob_count < parent_core.blob_limit)
			if(!(locate(/obj/effect/blob/core/) in range(T, 2)) && prob(secondary_core_growth_chance) && (parent_core.core_count < parent_core.core_limit))
				var/obj/effect/blob/core/secondary/S = new /obj/effect/blob/core/secondary(T)
				S.parent_core = src.parent_core
				src.parent_core.core_count += blob_cost
			else
				var/obj/effect/blob/C = new expandType(T)
				C.parent_core = src.parent_core
			parent_core.blob_count += blob_cost

/obj/effect/blob/proc/pulse(var/forceLeft, var/list/dirs)
	regen()
	sleep(4)
	var/pushDir = pick(dirs)
	var/turf/T = get_step(src, pushDir)
	var/obj/effect/blob/B = (locate() in T)
	if(!B)
		if(prob(health+45))
			expand(T)
		return
	if(forceLeft)
		B.pulse(forceLeft - 1, dirs)

/obj/effect/blob/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return

	switch(Proj.damage_type)
		if(BRUTE)
			take_damage(Proj.damage / brute_resist)
		if(BURN)
			take_damage((Proj.damage / laser_resist) / fire_resist)
	return 0

/obj/effect/blob/attackby(var/obj/item/W, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	visible_message("<span class='danger'>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]</span>")
	var/damage = 0
	switch(W.damtype)
		if("fire")
			damage = (W.force / fire_resist)
			if(W.iswelder())
				playsound(loc, 'sound/items/Welder.ogg', 100, 1)
		if("brute")
			if(prob(30) && !issilicon(user))
				visible_message("<span class='danger'>\The [W] gets caught in the gelatinous folds of \the [src]</span>")
				user.drop_from_inventory(W,get_turf(src))
				return
			damage = (W.force / brute_resist)

	take_damage(damage)
	return

/obj/effect/blob/core
	name = "blob core"
	icon_state = "blob_core"
	light_range = 1
	light_power = 2
	light_color = "#F3D203"
	maxHealth = 200
	brute_resist = 2
	laser_resist = 7
	regen_rate = 2
	fire_resist = 2
	var/core_count //amount of secondary cores
	var/core_limit = 4 //for if a badmin ever wants the station to die, they can set this higher
	var/blob_count = 1 //amount of actual blob pieces
	var/blob_limit = 150 //9x4+100 + a bit, maximum amount of blobs allowed.

	expandType = /obj/effect/blob/shield


/obj/effect/blob/core/New()
	if(!parent_core)
		parent_core = src
	..()

/obj/effect/blob/core/update_icon()
	var/health_percent = (health / maxHealth) * 100
	switch(health_percent)
		if(66 to INFINITY)
			icon_state = "blob_core"
		if(33 to 66)
			icon_state = "blob_node"
		if(-INFINITY to 33)
			icon_state = "blob_factory"

/obj/effect/blob/core/process()
	set waitfor = 0
	..()
	if(!blob_may_process)
		return
	blob_may_process = 0
	sleep(0)
	pulse(20, list(NORTH, EAST))
	pulse(20, list(NORTH, WEST))
	pulse(20, list(SOUTH, EAST))
	pulse(20, list(SOUTH, WEST))
	blob_may_process = 1

// Half the stats of a normal core. Blob has a very small probability of growing these when spreading. These will spread the blob further.
/obj/effect/blob/core/secondary
	name = "small blob core"
	icon_state = "blob_core"
	maxHealth = 100
	brute_resist = 1
	fire_resist = 1
	laser_resist = 4
	regen_rate = 1
	expandType = /obj/effect/blob

/obj/effect/blob/core/secondary/New()
	health = maxHealth
	update_icon()
	return ..(loc)

/obj/effect/blob/core/secondary/Destroy()
	if(parent_core)
		parent_core.core_count -= 1
	return ..()

/obj/effect/blob/shield
	name = "strong blob"
	icon_state = "blob_idle"
	maxHealth = 60
	brute_resist = 1
	fire_resist = 2
	laser_resist = 4
	blob_cost = 0 //so that the core can regrow its shields when they break

/obj/effect/blob/shield/New()
	update_nearby_tiles()
	..()

/obj/effect/blob/shield/Destroy()
	density = 0
	update_nearby_tiles()
	return ..()

/obj/effect/blob/shield/update_icon()
	if(health > maxHealth * 2 / 3)
		icon_state = "blob_idle"
	else if(health > maxHealth / 3)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/shield/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	return !density
