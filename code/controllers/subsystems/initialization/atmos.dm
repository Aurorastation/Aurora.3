/datum/controller/subsystem/atmos
	name = "Atmospherics Machinery"
	init_order = SS_INIT_ATMOS
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/atmos/Initialize(timeofday)
	for(var/obj/machinery/atmospherics/unary/U in machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

	..(timeofday, TRUE)
