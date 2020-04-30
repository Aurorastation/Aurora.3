
/datum/event/vent_clog
	announceWhen	= 1
	startWhen		= 5
	endWhen			= 35
	var/interval 	= 2
	var/list/vents  = list()
	var/list/gunk = list(
		"water",
		"carbon",
		"flour",
		"cleaner",
		"nutriment",
		"condensedcapsaicin",
		"mindbreaker",
		"lube",
		"red_paint",
		"yellow_paint",
		"banana",
		"space_drugs",
		"holywater",
		"hot_coco",
		"hyperzine",
		"paint",
		"luminol",
		"fuel",
		"blood",
		"sterilizine",
		"ipecac",
		"monoammoniumphosphate"
	)



/datum/event/vent_clog/setup()
	endWhen = rand(25, 100)
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/temp_vent in SSmachinery.processing_machines)
		if(!temp_vent)
			continue
		if(isStationLevel(temp_vent.z))
			if(temp_vent.network && temp_vent.network.normal_members.len > 20)
				vents += temp_vent
	if(!vents.len)
		return kill()

/datum/event/vent_clog/tick()
	if(activeFor % interval == 0)
		var/obj/machinery/atmospherics/unary/vent_scrubber/vent = pick_n_take(vents)

		if(vent && vent.loc && !vent.is_welded())

			var/datum/reagents/R = new/datum/reagents(35)
			R.my_atom = vent
			var/chem = pick(gunk)
			R.add_reagent(chem, 35)

			var/datum/effect/effect/system/smoke_spread/chem/smoke = new
			smoke.show_log = 0 // This displays a log on creation
			smoke.show_touch_log = 1 // This displays a log when a player is chemically affected
			smoke.set_up(R, 10, 0, vent, 120)
			playsound(vent.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
			smoke.start()
			qdel(R)


/datum/event/vent_clog/announce()
	command_announcement.Announce("The scrubbers network is experiencing a backpressure surge. Some ejection of contents may occur.", "Atmospherics alert", new_sound = 'sound/AI/scrubbers.ogg')
