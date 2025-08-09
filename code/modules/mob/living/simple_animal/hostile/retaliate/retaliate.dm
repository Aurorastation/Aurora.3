ABSTRACT_TYPE(/mob/living/simple_animal/hostile/retaliate)
	var/list/enemies = list()

/mob/living/simple_animal/hostile/retaliate/Destroy()
	enemies = null
	return ..()

/mob/living/simple_animal/hostile/retaliate/get_targets()
	if(!length(enemies))
		return list()
	var/list/see = ..()
	see &= enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/hostile/retaliate/handle_attack_by(mob/M)
	//For some ungodly reason, this can get called after Destroy(), so to avoid exceptions we have to
	//check if the lists weren't nulled already
	if(islist(enemies))
		enemies |= M
	if(islist(targets))
		targets |= M

	for(var/mob/living/simple_animal/hostile/retaliate/H in view(world.view, get_turf(src)))
		if(islist(H.enemies) && H.faction == faction)
			H.enemies |= M

/mob/living/simple_animal/proc/name_species()
	set name = "Name Alien Species"
	set category = "IC.Critters"
	set src in view()

	if(!SSatlas.current_map.use_overmap)
		return

	if(use_check_and_message(usr))
		return

	for(var/obj/effect/overmap/visitable/sector/exoplanet/E in SSshuttle.initialized_sectors)
		if(src in E.animals)
			var/newname = tgui_input_text(usr, "What do you want to name this species?", "Species naming", E.get_random_species_name(), MAX_NAME_LEN)
			newname = sanitizeName(newname, allow_numbers = TRUE)
			if(newname && !use_check_and_message(usr))
				if(E.rename_species(type, newname))
					to_chat(usr,SPAN_NOTICE("This species will be known from now on as '[newname]'."))
				else
					to_chat(usr,SPAN_WARNING("This species has already been named!"))
			return
