//Returns 1 if the turf is dense, or if there's dense objects/mobs on it, unless told to ignore them.
/turf/proc/check_density(var/ignore_objs = FALSE, var/ignore_mobs = FALSE)
	if(density)
		return TRUE
	if(!ignore_objs || !ignore_mobs)
		for(var/atom/movable/stuff in contents)
			if(stuff.density)
				if(ignore_objs && isobj(stuff))
					continue
				else if(ignore_mobs && isliving(stuff)) // Ghosts aren't dense but keeping this limited to living type will probably save headaches in the future.
					continue
				else
					return TRUE
	return FALSE

// Used to distinguish friend from foe.
/obj/item/spell/proc/is_ally(var/mob/living/L)
	if(L == owner) // The best ally is ourselves.
		return 1
	if(L.mind && technomancers.is_technomancer(L.mind)) // This should be done better since we might want opposing technomancers later.
		return 1
	if(istype(L, /mob/living/simple_animal/hostile)) // Mind controlled simple mobs count as allies too.
		var/mob/living/simple_animal/hostile/SM = L
		if(owner in SM.friends)
			return 1
	return 0

/obj/item/spell/proc/allowed_to_teleport()
	if(owner)
		if(owner.z in current_map.admin_levels)
			return FALSE
	return TRUE

/obj/item/spell/proc/within_range(var/atom/target, var/max_range = 7) // Beyond 7 is off the screen.
	if(target in view(max_range, owner))
		return TRUE
	return FALSE

/obj/item/spell/proc/calculate_spell_power(var/amount)
	if(core)
		return round(amount * core.spell_power_modifier, 1)

// Returns a 'target' mob from a radius around T.
/obj/item/spell/proc/targeting_assist(var/turf/T, radius = 5)
	var/chosen_target = null
	var/potential_targets = view(T,radius)
	for(var/mob/living/L in potential_targets)
		if(is_ally(L)) // Don't shoot our friends.
			continue
		if(L.invisibility > owner.see_invisible) // Don't target ourselves or people we can't see.
			continue
		if(!(L in viewers(owner))) // So we don't shoot at walls if someone is hiding behind one.
			continue
		if(!L.stat) // Don't want to target dead people or SSDs.
			chosen_target = L
			break
	return chosen_target