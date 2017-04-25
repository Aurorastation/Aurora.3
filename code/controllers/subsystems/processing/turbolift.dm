/var/datum/controller/subsystem/processing/turbolift/SSturbolift

/datum/controller/subsystem/processing/turbolift
	name = "Lifts"
	wait = 1 SECOND
	flags = SS_NO_INIT | SS_KEEP_TIMING

	var/list/lifts

/datum/controller/subsystem/processing/turbolift/New()
	NEW_SS_GLOBAL(SSturbolift)
	LAZYINITLIST(lifts)

/datum/controller/subsystem/processing/turbolift/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processing.Copy()

	var/list/curr = currentrun
	
	while (curr.len)
		var/liftRef = curr[curr.len]

		if (!(world.time < curr[liftRef]))
			var/datum/turbolift/lift = locate(liftRef)

			if (!lift.busy)
				handle_lift_movement(lift, liftRef)

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/processing/turbolift/proc/handle_lift_movement(datum/turbolift/lift, ref)
	set waitfor = FALSE

	lift.busy = TRUE

	if (!lift.do_move())
		processing[ref] = null
		processing -= ref
		if (lift.target_floor)
			lift.target_floor.ext_panel.reset()
			lift.target_floor = null
	
	else
		lift_is_moving(lift)
	
	lift.busy = FALSE

/datum/controller/subsystem/processing/turbolift/proc/lift_is_moving(datum/turbolift/lift)
	processing["\ref[lift]"] = world.time + lift.move_delay
