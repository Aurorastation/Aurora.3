/obj/effect/overmap/visitable/sector/exoplanet/proc/adapt_animal(mob/living/simple_animal/A)
	if(species[A.type])
		A.name = species[A.type]
		A.real_name = species[A.type]
	else
		A.name = "alien creature"
		A.real_name = "alien creature"
		add_verb(A, /mob/living/simple_animal/proc/name_species)
		if(istype(A, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/AH = A
			AH.tolerated_types = mobs_to_tolerate.Copy()

		A.minbodytemp = atmosphere.temperature - 20
		A.maxbodytemp = atmosphere.temperature + 30
		A.bodytemperature = (A.maxbodytemp+A.minbodytemp)/2

/obj/effect/overmap/visitable/sector/exoplanet/proc/remove_animal(mob/M)
	animals -= M
	UnregisterSignal(M, COMSIG_QDELETING)
	repopulate_types |= M.type

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_random_species_name()
	return pick("nol","shan","can","fel","xor")+pick("a","e","o","t","ar")+pick("ian","oid","ac","ese","inian","rd")

/obj/effect/overmap/visitable/sector/exoplanet/proc/rename_species(species_type, newname, force = FALSE)
	if(species[species_type] && !force)
		return FALSE

	species[species_type] = newname
	log_and_message_admins("renamed [species_type] to [newname]")
	for(var/mob/living/simple_animal/A in animals)
		if(istype(A,species_type))
			A.name = newname
			A.real_name = newname
			remove_verb(A, /mob/living/simple_animal/proc/name_species)
	return TRUE

/obj/effect/landmark/exoplanet_spawn
	name = "spawn exoplanet animal"

/obj/effect/landmark/exoplanet_spawn/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/exoplanet_spawn/LateInitialize(mapload)
	var/obj/effect/overmap/visitable/sector/exoplanet/E = GLOB.map_sectors["[z]"]
	if (istype(E))
		do_spawn(E)

/obj/effect/landmark/exoplanet_spawn/proc/do_spawn(obj/effect/overmap/visitable/sector/exoplanet/planet)
	return
