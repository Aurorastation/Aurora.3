/proc/Christmas_Game_Start()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		if(isNotStationLevel(xmas.z))	continue
		for(var/turf/simulated/floor/T in orange(1,xmas))
			for(var/i=1,i<=rand(1,5),i++)
				new /obj/item/a_gift(T)
	//for(var/mob/living/simple_animal/corgi/Ian/Ian in mob_list)
	//	Ian.place_on_head(new /obj/item/clothing/head/helmet/space/santahat(Ian))

/proc/ChristmasEvent()
	for(var/obj/structure/flora/tree/pine/xmas in world)
		var/mob/living/simple_animal/hostile/tree/evil_tree = new /mob/living/simple_animal/hostile/tree(xmas.loc)
		evil_tree.icon_state = xmas.icon_state
		evil_tree.icon_living = evil_tree.icon_state
		evil_tree.icon_dead = evil_tree.icon_state
		evil_tree.icon_gib = evil_tree.icon_state
		qdel(xmas)

