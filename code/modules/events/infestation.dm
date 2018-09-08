/datum/event/infestation
	announceWhen = 10
	endWhen = 11
	var/area/chosen_area
	var/event_name = "Unregistered Teleportation"
	var/chosen_mob = "bluespace bears"
	var/chosen_verb = "have teleported to"
	var/list/chosen_mob_types = list()

/datum/event/infestation/start()
	choose_area()
	choose_mobs()
	spawn_mobs()

/datum/event/infestation/proc/choose_area()
	chosen_area = random_station_area(TRUE)

/datum/event/infestation/proc/choose_mobs()

	var/list/possible_mobs = list(
		"space bears" = 0,
		"hivebots" = 0,
		"space bats" = 0,
		"lizards" = 0,
		"mice" = 0,
		"baby slimes" = 0,
		"spiderling" = 0
	)

	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			possible_mobs["mice"] = 1
			possible_mobs["lizards"] = 1
		if(EVENT_LEVEL_MODERATE)
			possible_mobs["space bats"] = 1
			possible_mobs["spiderlings"] = 1
		if(EVENT_LEVEL_MAJOR)
			possible_mobs["bluespace bears"] = 1
			possible_mobs["hivebots"] = 1
			possible_mobs["baby slimes"] = 1

	chosen_mob = pickweight(possible_mobs)

	switch(chosen_mob)
		if("bluespace bears")
			event_name = "Bluespace Bear Teleportation"
			chosen_verb = "have teleported to"
			chosen_mob_types +=	/mob/living/simple_animal/hostile/bear/spatial
			chosen_mob_types +=	/mob/living/simple_animal/hostile/bear/spatial
		if("hivebots")
			event_name = "Minor Hivebot Invasion"
			chosen_verb = "have invaded"
			chosen_mob_types += /mob/living/simple_animal/hostile/hivebot/tele
		if("space bats")
			event_name = "Space Bat Nest"
			chosen_verb = "have been breeding in"
			for(var/i = 1, i < rand(3,5),i++)
				chosen_mob_types += /mob/living/simple_animal/hostile/scarybat
		if("lizards")
			event_name = "Lizard Nest"
			chosen_verb = "have been breeding in"
			for(var/i = 1, i < rand(6,8),i++)
				chosen_mob_types += /mob/living/simple_animal/lizard
		if("mice")
			event_name = "Mouse Nest"
			chosen_verb = "have been breeding in"
			var/list/rat_breeds = list(
				/mob/living/simple_animal/mouse/gray = 4,
				/mob/living/simple_animal/mouse/brown = 2,
				/mob/living/simple_animal/mouse/white = 1
			)
			for(var/i = 1, i < rand(6,12),i++)
				chosen_mob_types += pickweight(rat_breeds)
		if("baby slimes")
			event_name = "Slime Leak"
			chosen_verb = "have leaked into"
			for(var/i = 1, i < rand(2,4),i++)
				chosen_mob_types += /mob/living/carbon/slime/
		if("spiderlings")
			event_name = "Spiderling Infestation"
			chosen_verb = "have burrowed into"
			for(var/i = 1, i < rand(3,6),i++)
				chosen_mob_types += /obj/effect/spider/spiderling
			chosen_mob_types += /obj/effect/spider/eggcluster

/datum/event/infestation/proc/spawn_mobs()
	for(var/spawned_mob in chosen_mob_types)
		new spawned_mob(chosen_area.random_space())

/datum/event/infestation/announce()
	command_announcement.Announce("Bioscans indicate that [chosen_mob] [chosen_verb] [chosen_area.name]. Clear them out before this starts to affect productivity.", event_name, new_sound = 'sound/AI/vermin.ogg')