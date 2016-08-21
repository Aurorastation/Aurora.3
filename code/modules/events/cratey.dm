//Oneshot event that turns a random crate on the station into cratey.
//Provides a painful surprise for maintenance-crawling assistants
//Has a chance to have a couple of rare materials, nowhere near enough to remove the need for mining,
//but sufficient for a shiny trinket or two

/datum/event/cratey
	var/list/crates

/datum/event/cratey/start()
	crates = list()
	for(var/obj/structure/closet/crate/crate in world)
		if(crate.z in config.station_levels)
			var/seen = 0
			for(var/mob/living/carbon/human/H in oview(crate,7))
				seen = 1//Don't spawn cratey near people so he doesn't gank them

			if (!seen)
				crates.Add(crate)


	//Random loot inside cratey!
	var/obj/structure/closet/crate/cratey_candidate = pick(crates)
	if (prob(20))
		new /obj/item/stack/material/diamond(cratey_candidate, 2)
	if (prob(20))
		new /obj/item/stack/material/gold(cratey_candidate, 2)
	if (prob(20))
		new /obj/item/stack/material/uranium(cratey_candidate, 2)
	if (prob(20))
		new /obj/item/stack/material/silver(cratey_candidate, 4)
	if (prob(20))
		new /obj/item/stack/material/plasteel(cratey_candidate, 4)

	var/mob/living/simple_animal/hostile/mimic/copy/cratey = new /mob/living/simple_animal/hostile/mimic/copy(cratey_candidate.loc, cratey_candidate, null)
	//Cratey is kinda tough but slow, easy to run away from
	cratey.name = "Cratey"
	cratey.health = 150
	cratey.maxHealth = 150
	cratey.melee_damage_lower = 7
	cratey.melee_damage_upper = 18
	cratey.knockdown_people = 1
	cratey.move_to_delay = 12

	msg_admin_attack("Cratey spawned coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[cratey.x];Y=[cratey.y];Z=[cratey.z]'>JMP</a>)")
