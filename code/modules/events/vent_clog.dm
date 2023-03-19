/datum/event/vent_clog
	announceWhen	= 1
	startWhen		= 5
	endWhen			= 35
	var/interval 	= 2
	var/list/vents  = list()
	var/list/gunk = list(
		/singleton/reagent/water = 10,
		/singleton/reagent/carbon = 5,
		/singleton/reagent/nutriment/flour = 8,
		/singleton/reagent/spacecleaner = 6,
		/singleton/reagent/nutriment = 6,
		/singleton/reagent/capsaicin/condensed = 2,
		/singleton/reagent/mindbreaker = 0.5,
		/singleton/reagent/lube = 4,
		/singleton/reagent/drink/banana = 3,
		/singleton/reagent/space_drugs = 3,
		/singleton/reagent/water/holywater = 1,
		/singleton/reagent/drink/hot_coco = 3,
		/singleton/reagent/hyperzine = 0.75,
		/singleton/reagent/luminol = 2,
		/singleton/reagent/fuel = 3,
		/singleton/reagent/blood = 2,
		/singleton/reagent/sterilizine = 3,
		/singleton/reagent/verunol = 3,
		/singleton/reagent/toxin/fertilizer/monoammoniumphosphate = 1,
		/singleton/reagent/saline = 2,
		/singleton/reagent/mental/kokoreed = 0.5,
		/singleton/reagent/toxin/tobacco = 3,
		/singleton/reagent/stone_dust = 0.5,
		/singleton/reagent/crayon_dust = 1,
		/singleton/reagent/alcohol/butanol = 2,
		/singleton/reagent/alcohol = 2,
		/singleton/reagent/sugar = 2,
		/singleton/reagent/drink/coffee = 4,
		/singleton/reagent/wulumunusha = 0.25,
		/singleton/reagent/nutriment/virusfood = 2,
		/singleton/reagent/sodiumchloride = 2,
		/singleton/reagent/drink/zorasoda/venomgrass = 1,
		/singleton/reagent/nutriment/protein/egg = 2,
		/singleton/reagent/serotrotium = 1,
		/singleton/reagent/psilocybin = 0.5,
		/singleton/reagent/toxin/spectrocybin = 0.1,
		/singleton/reagent/ambrosia_extract = 0.3,
		/singleton/reagent/skrell_nootropic = 0.5,
		/singleton/reagent/xuxigas = 2
	)

/datum/event/vent_clog/setup()
	endWhen = rand(25, 100)
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/temp_vent in SSmachinery.processing)
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
			var/singleton/reagent/chem = pickweight(gunk)
			var/reagent_amount = rand(2,5) * 5 //10 to 25 units
			var/datum/reagents/R = new/datum/reagents(reagent_amount)
			R.my_atom = vent
			R.add_reagent(chem, reagent_amount)

			var/datum/effect/effect/system/smoke_spread/chem/smoke = new
			smoke.show_log = 0 // This displays a log on creation
			smoke.show_touch_log = 1 // This displays a log when a player is chemically affected
			smoke.set_up(R, 10, 0, vent, 120)
			playsound(vent.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
			smoke.start()
			qdel(R)

/datum/event/vent_clog/announce()
	command_announcement.Announce("The scrubbers network is experiencing a backpressure surge. Some ejection of contents may occur.", "Atmospherics alert", new_sound = 'sound/AI/scrubbers.ogg', zlevels = affecting_z)
