//An event that is totally not a star trek reference.
//An APC violently explodes, damaging and EMPing the surrounding area.
//This will likely be harmful but not fatal for anyone nearby
//The selection of APC is weighted by power throughput. Those supplying a lot of power to machines are more likely to be picked
/datum/event/powerconduit
	startWhen	= 1
	announceWhen = 6
	ic_name = "ruptured power conduit"
	var/obj/machinery/power/apc/target
	var/area/targetloc

/datum/event/powerconduit/announce()
	command_announcement.Announce("Ruptured power conduit detected in [targetloc]. Please dispatch engineering team to conduct repair.", "Station Powernet Integrity Alert")

/datum/event/powerconduit/start()
	var/list/apcs = list()
	for (var/obj/machinery/power/apc/a in world)
		if (!a.loc || !(a.z in config.station_levels))
			continue

		if (a.is_critical)
			continue

		apcs[a] = a.lastused_total

	target = pickweight(apcs)
	targetloc = get_area(target)

	target.rupture()
