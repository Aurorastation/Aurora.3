ABSTRACT_TYPE(/mob/living/simple_animal/hostile/retaliate)
	ai_holder_type = /datum/ai_holder/simple_animal/retaliate

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
