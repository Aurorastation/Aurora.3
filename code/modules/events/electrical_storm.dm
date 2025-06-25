/datum/event/electrical_storm
	announceWhen = 0		// Warn them shortly before it begins.
	startWhen = 30
	endWhen = 60			// Set in start()
	ic_name = "an electrical storm"
	has_skybox_image = TRUE
	var/list/valid_apcs
	var/global/lightning_color
	var/storm_damage

/datum/event/electrical_storm/Destroy(force)
	valid_apcs = null
	. = ..()

/datum/event/electrical_storm/get_skybox_image()
	if(!lightning_color)
		lightning_color = pick("#ffd98c", "#ebc7ff", "#bdfcff", "#bdd2ff", "#b0ffca", "#ff8178", "#ad74cc")
	var/image/res = overlay_image('icons/skybox/electrobox.dmi', "lightning", lightning_color, RESET_COLOR)
	res.blend_mode = BLEND_ADD
	return res

/datum/event/electrical_storm/announce()
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			command_announcement.Announce("A minor electrical storm has been detected near the [location_name()]. Please watch out for possible electrical discharges.", "[location_name()] Sensor Array", new_sound = 'sound/AI/electrical_storm.ogg', zlevels = affecting_z)
		if(EVENT_LEVEL_MODERATE)
			command_announcement.Announce("The [location_name()] is about to pass through an electrical storm. Please secure sensitive electrical equipment until the storm passes.", "[location_name()] Sensor Array", new_sound = 'sound/AI/electrical_storm.ogg', zlevels = affecting_z)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("Alert. A catastrophic electrical storm has been detected in proximity of the [location_name()]. It is recommended to immediately secure sensitive electrical equipment until the storm passes.", "[location_name()] Sensor Array", new_sound = 'sound/AI/electrical_storm.ogg', zlevels = affecting_z)

/datum/event/electrical_storm/start()
	..()
	valid_apcs = list()
	for(var/obj/machinery/power/apc/valid_apc in SSmachinery.apc_units)
		if((valid_apc.z in affecting_z) && !valid_apc.is_critical)
			valid_apcs += valid_apc
	endWhen = (severity * 45) + startWhen

/datum/event/electrical_storm/end(faked)
	..()

	valid_apcs = null

/datum/event/electrical_storm/tick()
	..()

	/*
		While we want this event to keep Engineers on their toes and provide openings for people to break regs if they so wished,
		most of this should be theater: the biggest show should be lights flickering all over the place and a few APCs temporarily
		disabled (and able to be immediately re-enabled by anyone) rather than creating excessive work for Engineering/Janitors.

		The damage and effect will add up very quickly when multiple APCs are targeted though. While Mundane and Moderate events are mostly
		flavorful and will just give Engineers a few excuses to visit different departments and RP with people. Major events will be your
		'all hands on deck' affairs (as Major events are ought) and in very rare circumstances could even cascade into more serious issues
		(battery detonates somewhere that pokes a hole in the hull and enough rooms are depowered once to start venting a portion of the ship.)
	*/

	if(!length(valid_apcs))
		return

	var/list/picked_apcs = list()
	// Up to 2/4/6 APCs per tick depending on severity
	for(var/i = 0, i < ((severity + 1)), i++)
	for(var/i = 0, i < (severity * 2), i++)
		picked_apcs |= pick(valid_apcs)

	for(var/obj/machinery/power/apc/victim_apc in picked_apcs)
		// Determine what each APC does. Depending on how bad they roll, might be nothing or might blow out the entire thing.
		// Mundane storm:  0-55 nothing, 56+ lights flicker, 86+ damage (2 APC at a time)
		// Moderate storm: 0-30 nothing, 31+ lights flicker, 81+ damage (3 APCs at a time)
		// Severe storm:   0-5 nothing,  6+ lights flicker, 76+ damage (4 APCs at a time)
		// Once storm damage exceeds a threshold, there is a random chance of certain secondary effects.
		storm_damage = rand(0,100)

		// We don't want to obliterate small offships (lucky 7 APCs or fewer).
		if(LAZYLEN(valid_apcs) < 8)
			LAZYREMOVE(victim_apc, valid_apcs)

		// Main breaker is turned off, or we rolled lucky. Consider this APC protected.
		if(!victim_apc.operating || storm_damage <= (80 - (severity * 25)))
			continue

		// If the APC wasn't protected or we didn't roll lucky, flicker the lights for dramatic effect.
		victim_apc.flicker_all()

		// Now all the things that can happen if we roll high on damage.
		if(storm_damage > (90 - (severity * 5)))
			// Very tiny chance to completely break the APC. Has a check to ensure we don't break critical APCs such as the Engine room, or AI core. Does not occur on Mundane severity.
			if(prob((1 * severity) - 1))
				LOG_DEBUG("[victim_apc.name]: storm destroyed")
				victim_apc.set_broken()
				continue

			// Very high chance to shutdown the APC for a short time; this can be reversed immediately by interacting with it.
			if(prob(80 + (severity * 5)))
				victim_apc.energy_fail(4 * severity * rand(severity * 2, severity * 4))

			// Medium chance to overload lighting circuit.
			if(prob(15 * severity))
				victim_apc.overload_lighting((range(15 * severity, 100)))
				// Tiny chance to corrupt the cell (could potentially cause minor explosions!)
				if(!QDELETED(victim_apc.cell) && prob(8 * severity))
					victim_apc.cell.corrupt()

			// Small chance to emag the apc as apc_damage event does.
			if(prob(8 * severity))
				victim_apc.emagged = 1
				victim_apc.update_icon()

/datum/event/electrical_storm/announce_end()
	. = ..()
	if(.)
		command_announcement.Announce("The [location_name()] has cleared the electrical storm. Please repair any electrical overloads.", "Electrical Storm Alert", zlevels = affecting_z)
