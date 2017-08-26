//Infestation event now has two modes.
//Mundane event spawns some creatures in a place, and tells you which and where.
//Moderate event spawns twice the amount of two types of creatures, in two places. And tells you where but not what spawns


#define LOC_KITCHEN 0
#define LOC_ATMOS 1
#define LOC_INCIN 2
#define LOC_CHAPEL 3
#define LOC_LIBRARY 4
#define LOC_HYDRO 5
#define LOC_VAULT 6
#define LOC_CONSTR 7
#define LOC_TECH 8
#define LOC_ARMORY 9
#define LOC_DORMS 10
#define LOC_FITNESS 11
#define LOC_HOLODECK 12
#define LOC_DISPOSAL 13
#define LOC_CARGO 14
#define LOC_MEETING 15
#define LOC_LOCKER 16
#define LOC_XENO 17


#define VERM_MICE 0
#define VERM_LIZARDS 1
#define VERM_SPIDERS 2
#define VERM_DIYAAB 3
#define VERM_BATS 4
#define VERM_YITHIAN 5
#define VERM_TINDALOS 6

/datum/event/infestation
	announceWhen = 10
	endWhen = 11
	var/location
	var/numlocs = 0
	var/list/locstrings = list()
	var/vermin
	var/vermstring
	var/spawn_area_type
	var/list/turf/simulated/floor/turfs
	no_fake = 1

/datum/event/infestation/start()
	locstrings = new/list(2)
	choose_location()
	spawn_creatures()
	if (severity == EVENT_LEVEL_MODERATE)
		choose_location()
		spawn_creatures()





/datum/event/infestation/proc/choose_location()

	location = rand(0,17)
	turfs = list()
	numlocs++
	switch(location)
		if(LOC_KITCHEN)
			spawn_area_type = /area/crew_quarters/kitchen
			locstrings[numlocs] = "the kitchen"
		if(LOC_ATMOS)
			spawn_area_type = /area/engineering/atmos
			locstrings[numlocs] = "atmospherics"
		if(LOC_INCIN)
			spawn_area_type = /area/maintenance/disposal
			locstrings[numlocs] = "waste disposal"
		if(LOC_CHAPEL)
			spawn_area_type = /area/chapel/main
			locstrings[numlocs] = "the chapel"
		if(LOC_LIBRARY)
			spawn_area_type = /area/library
			locstrings[numlocs] = "the library"
		if(LOC_HYDRO)
			spawn_area_type = /area/hydroponics
			locstrings[numlocs] = "hydroponics"
		if(LOC_VAULT)
			spawn_area_type = /area/security/nuke_storage
			locstrings[numlocs] = "the vault"
		if(LOC_CONSTR)
			spawn_area_type = /area/construction
			locstrings[numlocs] = "the construction area"
		if(LOC_TECH)
			spawn_area_type = /area/storage/tech
			locstrings[numlocs] = "technical storage"
		if(LOC_ARMORY)
			spawn_area_type = /area/security/armoury
			locstrings[numlocs] = "the armoury"
		if(LOC_DORMS)
			spawn_area_type = /area/crew_quarters/sleep
			locstrings[numlocs] = "the dormitories"
		if(LOC_FITNESS)
			spawn_area_type = /area/crew_quarters/fitness
			locstrings[numlocs] = "the fitness room"
		if(LOC_HOLODECK)
			spawn_area_type = /area/holodeck/alphadeck
			locstrings[numlocs] = "the holodeck"
		if(LOC_DISPOSAL)
			spawn_area_type = /area/quartermaster/office
			locstrings[numlocs] = "the cargo disposals office"
		if(LOC_CARGO)
			spawn_area_type = /area/quartermaster/loading
			locstrings[numlocs] = "the cargo bay"
		if(LOC_MEETING)
			spawn_area_type = /area/bridge/meeting_room
			locstrings[numlocs] = "the command meeting room"
		if(LOC_LOCKER)
			spawn_area_type = /area/crew_quarters/locker
			locstrings[numlocs] = "the locker room"
		if(LOC_XENO)
			spawn_area_type = /area/rnd/xenobiology
			locstrings[numlocs] = "xenobiology"


	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/turf/simulated/floor/F in A.contents)
			if(turf_clear(F))
				turfs += F


/datum/event/infestation/proc/spawn_creatures()
	var/list/spawn_types = list()
	var/max_number
	vermin = rand(0,6)
	switch(vermin)
		if(VERM_MICE)
			spawn_types = list(/mob/living/simple_animal/mouse/gray, /mob/living/simple_animal/mouse/brown, /mob/living/simple_animal/mouse/white)
			max_number = 16
			//Large quantities of mice aren't a potential lag issue since they decompose to
			//inert skeletons now
			vermstring = "mice"
		if(VERM_LIZARDS)
			spawn_types = list(/mob/living/simple_animal/lizard)
			max_number = 12
			vermstring = "lizards"
		if(VERM_SPIDERS)
			spawn_types = list(/obj/effect/spider/spiderling)
			max_number = 5
			vermstring = "spiders"
		if (VERM_DIYAAB)
			spawn_types = list(/mob/living/simple_animal/hostile/diyaab)
			max_number = 4
			vermstring = "strange creatures"
		if (VERM_BATS)
			spawn_types = list(/mob/living/simple_animal/hostile/scarybat)
			max_number = 4
			vermstring = "space bats"
		if (VERM_YITHIAN)
			spawn_types = list(/mob/living/simple_animal/yithian)
			max_number = 7
			vermstring = "strange creatures"
		if (VERM_TINDALOS)
			spawn_types = list(/mob/living/simple_animal/tindalos)
			max_number = 7
			vermstring = "strange creatures"


	if (severity == EVENT_LEVEL_MODERATE)
		max_number *= 2
	var/num = rand(2,max_number)

	while(turfs.len > 0 && num > 0)
		var/turf/simulated/floor/T = pick(turfs)

		turfs.Remove(T)
		num--

		if(vermin == VERM_SPIDERS)
			var/obj/effect/spider/spiderling/S = new /obj/effect/spider/spiderling(T)
			S.amount_grown = 1
			S.growth_rate = (rand(50,300)/1000)//At most, they grow at 30% the usual rate. As low as 1/20th
			if (severity == EVENT_LEVEL_MODERATE)
				S.growth_rate *= 2//They grow faster on the higher severity event
		else
			var/spawn_type = pick(spawn_types)
			new spawn_type(T)

/datum/event/infestation/announce()
	if (severity == EVENT_LEVEL_MODERATE)
		command_announcement.Announce("Bioscans indicate that large numbers of lifeforms have been breeding in [locstrings[1]] and [locstrings[2]]. Clear them out, before this starts to affect productivity.", "Vermin infestation", new_sound = 'sound/AI/vermin.ogg')
	else
		command_announcement.Announce("Bioscans indicate that [vermstring] have been breeding in [locstrings[1]]. Clear them out, before this starts to affect productivity.", "Vermin infestation", new_sound = 'sound/AI/vermin.ogg')


#undef LOC_KITCHEN
#undef LOC_ATMOS
#undef LOC_INCIN
#undef LOC_CHAPEL
#undef LOC_LIBRARY
#undef LOC_HYDRO
#undef LOC_VAULT
#undef LOC_CONSTR
#undef LOC_TECH
#undef LOC_ARMORY
#undef LOC_DORMS
#undef LOC_FITNESS
#undef LOC_HOLODECK
#undef LOC_DISPOSAL
#undef LOC_CARGO
#undef LOC_MEETING
#undef LOC_LOCKER
#undef LOC_XENO

#undef VERM_MICE
#undef VERM_LIZARDS
#undef VERM_SPIDERS
#undef VERM_DIYAAB
#undef VERM_BATS
#undef VERM_YITHIAN
#undef VERM_TINDALOS
