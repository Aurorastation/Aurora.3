/mob/living/simple_animal/hostile/spawner
	name = "monster nest"
	icon = 'icons/mob/cavern.dmi'
	health = 100
	maxHealth = 100
	gender = NEUTER
	var/list/spawned_mobs = list()
	var/max_mobs = 5
	var/spawn_delay = 0
	var/spawn_time = 30
	var/mob_type = /mob/living/simple_animal/hostile/carp
	var/spawn_text = "emerges from"
	status_flags = 0
	anchored = 1
	a_intent = I_HURT
	stop_automated_movement = 1
	wander = 0
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	layer = 2.1
	see_in_dark = 8

/mob/living/simple_animal/hostile/spawner/Move()
	return

/mob/living/simple_animal/hostile/spawner/Destroy()
	for(var/mob/living/simple_animal/L in spawned_mobs)
		if(L.nest == src)
			L.nest = null
	spawned_mobs = null
	return ..()

/mob/living/simple_animal/hostile/spawner/FoundTarget()
	if(target_mob.faction != "syndicate")
		spawn_mob()
	LoseTarget()
	return

/mob/living/simple_animal/hostile/spawner/proc/spawn_mob()
	for(var/mob/living/simple_animal/L in spawned_mobs) //mobs on different z-levels are dead to us! dead!
		if(L.z != z)
			L.nest = null
			spawned_mobs -= L
	if(spawned_mobs.len >= max_mobs)
		return 0
	if(spawn_delay > world.time)
		return 0
	spawn_delay = world.time + spawn_time
	var/mob/living/simple_animal/L = new mob_type(src.loc)
	spawned_mobs += L
	L.nest = src
	L.faction = src.faction
	visible_message("<span class='danger'>[L] [spawn_text] [src].</span>")

/mob/living/simple_animal/hostile/spawner/caverndweller
	name = "dark cavern"
	desc = "The cavernous nest of the ...electrifying... cavern dweller. Proceed with caution."
	icon_state = "alien_nest1"
	spawn_time = 60
	mob_type = /mob/living/simple_animal/hostile/retaliate/cavern_dweller
	faction = "cavern"

/mob/living/simple_animal/hostile/spawner/baneslug
	name = "baneslug brood hatchery"
	desc = "The sickly looking eggs of the baneslug reek of acid and blood."
	icon_state = "alien_nest2"
	spawn_text = "hatches from"
	spawn_time = 15
	max_mobs = 10
	health = 50
	maxHealth = 50
	mob_type = /mob/living/simple_animal/hostile/baneling
	faction = "cavern"

/mob/living/simple_animal/hostile/spawner/mouse
	name = "alien carcass"
	desc = "Some sort of alien carcass. It's already swarming with ravenous mice picking its bones clean."
	icon_state = "alien_nest3"
	spawn_text = "emerges from the bones of"
	spawn_time = 10
	max_mobs = 5
	health = 30
	maxHealth = 30
	mob_type = /mob/living/simple_animal/mouse/host
	faction = "evil"

/mob/living/simple_animal/hostile/spawner/malfdrone
	name = "sentry pad"
	desc = "This dusty looking device seems to be a proximity triggered sentry pad..."
	icon_state = "sol_nest3"
	spawn_text = "warps in at"
	spawn_time = 60
	max_mobs = 3
	health = 25
	maxHealth = 25
	mob_type = /mob/living/simple_animal/hostile/retaliate/malf_drone/sol
	faction = "sol"

/mob/living/simple_animal/hostile/spawner/viscerator
	name = "viscerator lathe"
	desc = "This strangely placed autolathe buzzes like a hornet's nest..."
	icon_state = "sol_nest2"
	spawn_text = "is built from"
	spawn_time = 10
	max_mobs = 5
	health = 30
	maxHealth = 30
	mob_type = /mob/living/simple_animal/hostile/viscerator
	faction = "sol"

/mob/living/simple_animal/hostile/spawner/minedrone
	name = "mining drone computer"
	desc = "This trashed looking computer almost barely resembles some sort of drone control terminal..."
	icon_state = "sol_nest1"
	spawn_text = "is recalled to"
	spawn_time = 60
	max_mobs = 2
	health = 45
	maxHealth = 45
	mob_type = /mob/living/simple_animal/hostile/retaliate/minedrone
	faction = "sol"

/mob/living/simple_animal/hostile/spawner/darkportal
	name = "dark portal"
	desc = "This menacing portal oozes a suffocating darkness. Every synapse in your body urges you to flee!"
	icon_state = "outsider_nest"
	spawn_text = "escapes from"
	spawn_time = 30
	max_mobs = 5
	health = 100
	maxHealth = 100
	mob_type = /mob/living/simple_animal/hostile/shadow
	faction = "outsider"

	light_range = 5
	light_power = -5
	light_color = "#FFFFFF"
