/var/global/sent_spiders_to_station = 0

/datum/event/spider_infestation
	announceWhen	= 90
	var/spawncount = 1
	ic_name = "unidentified lifesigns"
	var/list/possible_spiders

/datum/event/spider_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 60)
	spawncount = rand(4 * severity, 6 * severity)	//spiderlings only have a 50% chance to grow big and strong
	sent_spiders_to_station = 0
	possible_spiders = typesof(/mob/living/simple_animal/hostile/giant_spider)

/datum/event/spider_infestation/announce()
	command_announcement.Announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')

/datum/event/spider_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in SSmachinery.processing_machines)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in current_map.station_levels)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent

	while(spawncount && vents.len)
		var/obj/vent = pick(vents)
		new /obj/effect/spider/spiderling(vent.loc, null, 1, possible_spiders)
		vents -= vent
		spawncount--

// Moderate event cannot spawn nurses, ergo, they only terrorize but do not replicate.
/datum/event/spider_infestation/moderate/setup()
	..()
	possible_spiders -= /mob/living/simple_animal/hostile/giant_spider/nurse
