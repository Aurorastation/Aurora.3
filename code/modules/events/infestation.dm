#define INFESTATION_MICE "mice"
#define INFESTATION_LIZARDS "lizards"
#define INFESTATION_SPACE_BATS "space bats"
#define INFESTATION_SPIDERLINGS "spiderlings"
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
	var/list/possible_mobs = list(
		INFESTATION_MICE = 1,
		INFESTATION_LIZARDS = 1
	)
	no_fake = 1

/datum/event/infestation/moderate
	possible_mobs = list(
		INFESTATION_SPACE_BATS = 1,
		INFESTATION_SPIDERLINGS = 1
	)
/datum/event/infestation/major
	possible_mobs = list(
		INFESTATION_HIVEBOTS = 1,
		INFESTATION_SLIMES = 1
	)

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
			chosen_mob_types += /mob/living/simple_animal/hostile/hivebotbeacon
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
	command_announcement.Announce("Bioscans indicate that [chosen_mob] [chosen_verb] [chosen_area]. Clear them out before this starts to affect productivity.", event_name, new_sound = 'sound/AI/vermin.ogg')
