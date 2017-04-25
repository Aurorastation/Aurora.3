var/datum/controller/process/turbolift/turbolift_controller

/datum/controller/process/turbolift
	var/list/moving_lifts = list()
	var/list/processing_lifts = list()

/datum/controller/process/turbolift/New()
	..()
	turbolift_controller = src

/datum/controller/process/turbolift/setup()
	name = "turbolift controller"
	schedule_interval = 10

/datum/controller/process/turbolift/doWork()
	if(!processing_lifts.len)
		processing_lifts = moving_lifts.Copy()

	while(processing_lifts.len)
		var/liftRef = processing_lifts[processing_lifts.len]
		processing_lifts.len--

		if(!(world.time < moving_lifts[liftRef]))
			var/datum/turbolift/lift = locate(liftRef)
			if(!lift.busy)

				spawn(0)
					lift.busy = 1
					if(!lift.do_move())
						moving_lifts[liftRef] = null
						moving_lifts -= liftRef
						if(lift.target_floor)
							lift.target_floor.ext_panel.reset()
							lift.target_floor = null

					else
						lift_is_moving(lift)

					lift.busy = 0

		F_SCHECK

//Dis is being called all the time, rather use a timer to call it when needed or speed through the lifts?
/datum/controller/process/turbolift/proc/lift_is_moving(var/datum/turbolift/lift)
	moving_lifts["\ref[lift]"] = world.time + lift.move_delay
