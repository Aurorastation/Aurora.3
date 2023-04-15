#define INFESTATION_RATS "rats"
#define INFESTATION_LIZARDS "lizards"
#define INFESTATION_SPACE_BATS "space bats"
#define INFESTATION_SPIDERLINGS "greimorian larva"
#define INFESTATION_HIVEBOTS "hivebots"
#define INFESTATION_SLIMES "slimes"

/datum/event/infestation
	startWhen = 1
	announceWhen = 10
	endWhen = 11
	no_fake = 1
	var/area/chosen_area
	var/event_name = "Slime Leak"
	var/chosen_mob = INFESTATION_SLIMES
	var/chosen_verb = "have leaked into"
	var/list/chosen_mob_types = list()
	var/chosen_scan_type = "Bioscans"
	var/list/possible_mobs = list(
		INFESTATION_RATS = 1,
		INFESTATION_LIZARDS = 1
	)

/datum/event/infestation/moderate
	possible_mobs = list(
		INFESTATION_SPACE_BATS = 1,
		INFESTATION_SPIDERLINGS = 1
	)

/datum/event/infestation/major/setup()
	var/player_count = 0
	for(var/mob/living/carbon/human/H in living_mob_list)
		if(H.stat == CONSCIOUS && H.client)
			player_count++
	if(player_count >= 15)
		possible_mobs = list(
			INFESTATION_HIVEBOTS = 1,
			INFESTATION_SLIMES = 1
		)
	else
		possible_mobs = list(
			INFESTATION_SLIMES = 1
		)
	..()

/datum/event/infestation/setup()
	choose_area()
	choose_mobs()

/datum/event/infestation/start()
	spawn_mobs()

/datum/event/infestation/proc/choose_area()
	chosen_area = random_station_area(TRUE)

/datum/event/infestation/proc/choose_mobs()

	chosen_mob = pickweight(possible_mobs)

	switch(chosen_mob)
		if(INFESTATION_HIVEBOTS)
			event_name = "Hivebot Invasion"
			chosen_verb = "have invaded"
			chosen_scan_type = "Bluespace readings"
			var/list/beacon_types = list(
				/mob/living/simple_animal/hostile/hivebotbeacon = 1,
				/mob/living/simple_animal/hostile/hivebotbeacon/incendiary = 1
			)
			chosen_mob_types += pickweight(beacon_types)

		if(INFESTATION_SPACE_BATS)
			event_name = "Space Bat Nest"
			chosen_verb = "have been breeding in"
			for(var/i = 1, i < rand(3,5),i++)
				chosen_mob_types += /mob/living/simple_animal/hostile/scarybat

		if(INFESTATION_LIZARDS)
			event_name = "Lizard Nest"
			chosen_verb = "have been breeding in"
			for(var/i = 1, i < rand(6,8),i++)
				chosen_mob_types += /mob/living/simple_animal/lizard

		if(INFESTATION_RATS)
			event_name = "Rat Nest"
			chosen_verb = "have been breeding in"
			var/list/rat_breeds = list(
				/mob/living/simple_animal/rat/gray = 4,
				/mob/living/simple_animal/rat/brown = 2,
				/mob/living/simple_animal/rat/white = 3,
				/mob/living/simple_animal/rat/hooded = 1,
				/mob/living/simple_animal/rat/irish = 2,
			)
			for(var/i = 1, i < rand(8,24),i++)
				chosen_mob_types += pickweight(rat_breeds)

		if(INFESTATION_SLIMES)
			event_name = "Xenobiology Containment Breach"
			chosen_verb = "have leaked into"
			var/list/slime_types = list(
				/mob/living/carbon/slime,
				/mob/living/carbon/slime/purple,
				/mob/living/carbon/slime/metal,
				/mob/living/carbon/slime/orange,
				/mob/living/carbon/slime/blue,
				/mob/living/carbon/slime/dark_blue,
				/mob/living/carbon/slime/dark_purple,
				/mob/living/carbon/slime/yellow,
				/mob/living/carbon/slime/silver,
				/mob/living/carbon/slime/pink,
				/mob/living/carbon/slime/red,
				/mob/living/carbon/slime/green,
				/mob/living/carbon/slime/oil
			)
			var/chosen_slime_type = pick(slime_types)
			for(var/i = 1, i < rand(5,8),i++)
				chosen_mob_types += chosen_slime_type

		if(INFESTATION_SPIDERLINGS)
			event_name = "Greimorian Infestation"
			chosen_verb = "have burrowed into"
			for(var/i = 1, i < rand(3,6),i++)
				chosen_mob_types += /obj/effect/spider/spiderling
			chosen_mob_types += /obj/effect/spider/eggcluster

/datum/event/infestation/proc/spawn_mobs()
	for(var/spawned_mob in chosen_mob_types)
		new spawned_mob(chosen_area.random_space())

/datum/event/infestation/announce()
	command_announcement.Announce("[chosen_scan_type] indicate that [chosen_mob] [chosen_verb] [chosen_area]. Clear them out before this starts to affect productivity.", event_name, new_sound = 'sound/AI/vermin.ogg', zlevels = affecting_z)
