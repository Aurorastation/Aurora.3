/datum/event/vent_clog
	announceWhen	= 1
	startWhen		= 5
	endWhen			= 35
	var/interval 	= 2
	var/list/vents  = list()
	var/list/gunk = list(
		/datum/reagent/water = 10,
		/datum/reagent/carbon = 5,
		/datum/reagent/nutriment/flour = 10,
		/datum/reagent/spacecleaner = 8,
		/datum/reagent/nutriment = 8,
		/datum/reagent/capsaicin/condensed = 2,
		/datum/reagent/mindbreaker = 0.5,
		/datum/reagent/lube = 4,
		/datum/reagent/paint = 3,
		/datum/reagent/drink/banana = 3,
		/datum/reagent/space_drugs = 3,
		/datum/reagent/water/holywater = 1,
		/datum/reagent/drink/hot_coco = 3,
		/datum/reagent/hyperzine = 0.75,
		/datum/reagent/luminol = 2,
		/datum/reagent/fuel = 3,
		/datum/reagent/blood = 2,
		/datum/reagent/sterilizine = 3,
		/datum/reagent/verunol = 3,
		/datum/reagent/toxin/fertilizer/monoammoniumphosphate = 1,
		/datum/reagent/saline = 2,
		/datum/reagent/mental/kokoreed = 0.5,
		/datum/reagent/mental/vaam = 0.5,
		/datum/reagent/toxin/tobacco = 3,
		/datum/reagent/stone_dust = 0.5,
		/datum/reagent/crayon_dust = 1,
		/datum/reagent/alcohol/butanol = 2,
		/datum/reagent/alcohol/ethanol = 2,
		/datum/reagent/sugar = 2,
		/datum/reagent/drink/coffee = 4,
		/datum/reagent/wulumunusha = 0.25,
		/datum/reagent/nutriment/virusfood = 2,
		/datum/reagent/sodiumchloride = 2,
		/datum/reagent/drink/zorasoda/venomgrass = 1,
		/datum/reagent/nutriment/protein/egg = 2,
		/datum/reagent/serotrotium = 1,
		/datum/reagent/psilocybin = 0.5,
		/datum/reagent/toxin/spectrocybin = 0.1
	)
	var/list/gunk_data = list(
		/datum/reagent/paint = list("#FE191A", "#FDFE7D", "#1242A8", "#6CDB38")
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
		return kill() // TODO: this doesn't get a TRUE until pipenets are fixed

/datum/event/vent_clog/tick()
	if(activeFor % interval == 0)
		var/obj/machinery/atmospherics/unary/vent_scrubber/vent = pick_n_take(vents)

		if(vent && vent.loc && !vent.is_welded())
			var/datum/reagent/chem = pickweight(gunk)
			var/reagent_amount = rand(3,6) * 5 //15 to 30 units
			if(chem.overdose && chem.overdose < reagent_amount) //Some have no OD set. Those that do, we limit to that so we don't have people dropping dead.
				reagent_amount = chem.overdose
			var/datum/reagents/R = new/datum/reagents(reagent_amount)
			R.my_atom = vent
			R.add_reagent(chem, reagent_amount, pick(gunk_data[chem]))

			var/datum/effect/effect/system/smoke_spread/chem/smoke = new
			smoke.show_log = 0 // This displays a log on creation
			smoke.show_touch_log = 1 // This displays a log when a player is chemically affected
			smoke.set_up(R, 10, 0, vent, 120)
			playsound(vent.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
			smoke.start()
			qdel(R)


/datum/event/vent_clog/announce()
	command_announcement.Announce("The scrubbers network is experiencing a backpressure surge. Some ejection of contents may occur.", "Atmospherics alert", new_sound = 'sound/AI/scrubbers.ogg')
