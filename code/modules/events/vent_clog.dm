
/datum/event/vent_clog
	announceWhen	= 1
	startWhen		= 5
	endWhen			= 35
	var/interval 	= 2
	var/list/vents  = list()
	var/list/gunk = list("water","carbon","flour","radium","toxin","cleaner","nutriment",\
	"condensedcapsaicin","mindbreaker","lube","plantbgone","banana","space_drugs",\
	"holywater","ethanol","hot_coco","sacid", "hyperzine", "ethanol")



/datum/event/vent_clog/setup()
	endWhen = rand(25, 100)
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/temp_vent in SSmachinery.processing_machines)
		if(!temp_vent)
			continue
		if(temp_vent.z in current_map.station_levels)//STATION ZLEVEL
			if(temp_vent.network && temp_vent.network.normal_members.len > 20)
				vents += temp_vent
	if(!vents.len)
		return kill()

/datum/event/vent_clog/tick()
	if(activeFor % interval == 0)
		var/obj/machinery/atmospherics/unary/vent_scrubber/vent = pick_n_take(vents)

		if(vent && vent.loc)

			var/datum/reagents/R = new/datum/reagents(50)
			R.my_atom = vent
			var/chem = pick(gunk)
			R.add_reagent(chem, 50)

			var/datum/effect/effect/system/smoke_spread/chem/smoke = new
			smoke.show_log = 0 // This displays a log on creation
			smoke.show_touch_log = 1 // This displays a log when a player is chemically affected
			smoke.set_up(R, 10, 0, vent, 120)
			playsound(vent.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
			smoke.start()
			qdel(R)


/datum/event/vent_clog/announce()
	command_announcement.Announce("The scrubbers network is experiencing a backpressure surge. Some ejection of contents may occur.", "Atmospherics alert", new_sound = 'sound/AI/scrubbers.ogg')

