/mob/living/simple_animal/hostile/retaliate
	var/list/enemies = list()

/mob/living/simple_animal/hostile/retaliate/Destroy()
	enemies = null
	return ..()

/mob/living/simple_animal/hostile/retaliate/Found(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat)
			change_stance(HOSTILE_STANCE_ATTACK)
			return L
		else
			enemies -= L

/mob/living/simple_animal/hostile/retaliate/ListTargets()
	if(!length(enemies))
		return list()
	var/list/see = ..()
	see &= enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/hostile/retaliate/handle_attack_by(mob/M)
	enemies |= M
	targets |= M

	for(var/mob/living/simple_animal/hostile/retaliate/H in view(world.view, get_turf(src)))
		if(H.faction == faction)
			H.enemies |= M

/mob/living/simple_animal/proc/name_species()
	set name = "Name Alien Species"
	set category = "Object"
	set src in view()

	if(!current_map.use_overmap)
		return

	if(use_check_and_message(usr))
		return

	for(var/obj/effect/overmap/visitable/sector/exoplanet/E in SSshuttle.initialized_sectors)
		if(src in E.animals)
			var/newname = input("What do you want to name this species?", "Species naming", E.get_random_species_name()) as text|null
			newname = sanitizeName(newname, allow_numbers = TRUE)
			if(newname && !use_check_and_message(usr))
				if(E.rename_species(type, newname))
					to_chat(usr,"<span class='notice'>This species will be known from now on as '[newname]'.</span>")
				else
					to_chat(usr,"<span class='warning'>This species has already been named!</span>")
			return
