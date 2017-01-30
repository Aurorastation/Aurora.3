/datum/event/bear_attack
	startWhen = 2
	announceWhen = 20

	var/list/possible_turfs = list()
	var/spawn_type
	var/spawn_number
	ic_name = "a dangerous bioweapon"

/datum/event/bear_attack/setup()
	for(var/areapath in typesof(/area/maintenance))
		var/area/A = locate(areapath)
		for(var/turf/simulated/floor/F in A.contents)
			if(turf_clear(F))
				possible_turfs |= F

	if (severity <= EVENT_LEVEL_MODERATE)//Moderate spacebear event disabled by head developer veto
		spawn_type = /mob/living/simple_animal/hostile/bear
		spawn_number = rand(8,16)
	else
		spawn_type = /mob/living/simple_animal/hostile/bear/spatial
		spawn_number = rand(4,6)


/datum/event/bear_attack/start()
	var/i
	for (i = 0,i < spawn_number, i++)
		new spawn_type(pick(possible_turfs))

/datum/event/bear_attack/announce()
	if (severity <= EVENT_LEVEL_MODERATE)
		command_announcement.Announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')
	else
		command_announcement.Announce("Highly dangerous bioweapons have escaped from a nearby research facility and boarded [station_name()]. Station security is advised to be on high alert.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')
