#define INFESTATION_MICE "mice"
#define INFESTATION_LIZARDS "lizards"
#define INFESTATION_SPACE_BATS "space bats"
#define INFESTATION_SPIDERLINGS "spiderlings"
#define INFESTATION_HIVEBOTS "hivebots"
#define INFESTATION_SLIMES "slimes"

/datum/event/infestation
	announceWhen = 10
	endWhen = 11
	var/area/chosen_area
	var/event_name = "Slime Leak"
	var/chosen_mob = INFESTATION_SLIMES
	var/chosen_verb = "have leaked into"
	var/list/chosen_mob_types = list()

/datum/event/infestation/start()
	choose_area()
	choose_mobs()
	spawn_mobs()

/datum/event/infestation/proc/choose_area()
	chosen_area = random_station_area(TRUE)

/datum/event/infestation/proc/choose_mobs()

	var/list/possible_mobs = list(
		INFESTATION_MICE = (severity = EVENT_LEVEL_MUNDANE),
		INFESTATION_LIZARDS = (severity = EVENT_LEVEL_MUNDANE),
		INFESTATION_SPACE_BATS = (severity = EVENT_LEVEL_MODERATE),
		INFESTATION_SPIDERLINGS = (severity = EVENT_LEVEL_MODERATE),
		INFESTATION_HIVEBOTS = (severity = EVENT_LEVEL_MAJOR),
		INFESTATION_SLIMES = (severity = EVENT_LEVEL_MAJOR)
	)

	chosen_mob = pickweight(possible_mobs)

	switch(chosen_mob)
		if(INFESTATION_HIVEBOTS)
			event_name = "Minor Hivebot Invasion"
			chosen_verb = "have invaded"
			chosen_mob_types += /mob/living/simple_animal/hostile/hivebot/tele
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
		if(INFESTATION_MICE)
			event_name = "Mouse Nest"
			chosen_verb = "have been breeding in"
			var/list/rat_breeds = list(
				/mob/living/simple_animal/mouse/gray = 4,
				/mob/living/simple_animal/mouse/brown = 2,
				/mob/living/simple_animal/mouse/white = 1
			)
			for(var/i = 1, i < rand(6,12),i++)
				chosen_mob_types += pickweight(rat_breeds)
		if(INFESTATION_SLIMES)
			event_name = "Slime Leak"
			chosen_verb = "have leaked into"
			for(var/i = 1, i < rand(2,4),i++)
				chosen_mob_types += /mob/living/carbon/slime/
		if(INFESTATION_SPIDERLINGS)
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