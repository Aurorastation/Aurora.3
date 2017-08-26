var/datum/controller/subsystem/sun/sun

/datum/controller/subsystem/sun
	name = "Sun"
	flags = SS_NO_INIT | SS_POST_FIRE_TIMING | SS_BACKGROUND
	wait = 1 MINUTE
	priority = SS_PRIORITY_SUN

	var/angle
	var/dx
	var/dy
	var/rate
	var/list/solars			// for debugging purposes, references solars_list at the constructor
	var/tmp/list/updating_solars
	var/solar_next_update	// last time the sun position was checked and adjusted

/datum/controller/subsystem/sun/New()
	NEW_SS_GLOBAL(sun)
	LAZYINITLIST(solars)

	rate = rand(50,200)/100			// 50% - 200% of standard rotation
	if(prob(50))					// same chance to rotate clockwise than counter-clockwise
		rate = -rate
	solar_next_update = world.time	// init the timer
	angle = rand (0,360)

/datum/controller/subsystem/sun/stat_entry()
	..("A:[angle] R:[rate] S:[LAZYLEN(solars)]")

/datum/controller/subsystem/sun/fire(resumed = 0)
	if (!resumed)
		angle = (360 + angle + rate * 6) % 360	 // increase/decrease the angle to the sun, adjusted by the rate

		// now calculate and cache the (dx,dy) increments for line drawing

		var/s = sin(angle)
		var/c = cos(angle)

		// Either "abs(s) < abs(c)" or "abs(s) >= abs(c)"
		// In both cases, the greater is greater than 0, so, no "if 0" check is needed for the divisions

		if( abs(s) < abs(c))

			dx = s / abs(c)
			dy = c / abs(c)

		else
			dx = s / abs(s)
			dy = c / abs(s)

		updating_solars = solars.Copy()

	//now tell the solar control computers to update their status and linked devices
	while (updating_solars.len)
		var/obj/machinery/power/solar_control/SC = updating_solars[updating_solars.len]
		updating_solars.len--

		if (QDELETED(SC) || !SC.powernet)
			solars -= SC
			continue

		SC.update()

		if (MC_TICK_CHECK)
			return
