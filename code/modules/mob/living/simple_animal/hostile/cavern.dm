/mob/living/simple_animal/hostile/petran_male
	name = "male petran"
	desc = "A crab-like spare faring creature commonly found scavaging for edible junk on asteriods."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "gut_shank"
	icon_living = "gut_shank"
	icon_dead = "gut_shank_dead"
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"
	attacktext = "bit"
	stop_automated_movement_when_pulled = 0
	speed = -3
	maxHealth = 50
	health = 50
	melee_damage_lower = 6
	melee_damage_upper = 8
	faction = "petran"
	pass_flags = PASSTABLE
	move_to_delay = 12
	mob_size = 6

/mob/living/simple_animal/hostile/petran_male/on_timed_spawn()
	var/turf/simulated/floor/asteroid/T = get_turf(src.loc)
	if(istype(T))
		if(T.dug < 5)
			T.dug = 5
		T.gets_dug()
		playsound(src,'sound/species/petran/dig.ogg', 50, 1)
		visible_message("<span class='warning'>A very angry [name] digs up from under the [T.name]!</span>")
	else
		qdel(src)
	return ..()

/mob/living/simple_animal/hostile/petran_male/on_timed_despawn()
	var/turf/simulated/floor/asteroid/T = get_turf(src.loc)
	if(istype(T))
		if(T.dug < 5)
			T.dug = 5
		T.gets_dug()
		playsound(src,'sound/species/petran/dig.ogg', 50, 1)
		visible_message("<span class='warning'>The [name] digs into the [T.name] and tunnels away!</span>")
		return ..()
	else
		return 0

