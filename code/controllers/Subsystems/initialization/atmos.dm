var/datum/subsystem/atmos/SSatmos

/datum/subsystem/atmos
	name = "Atmospherics Machinery"
	init_order = SS_INIT_ATMOS
	flags = SS_NO_FIRE

/datum/subsystem/atmos/New()
	NEW_SS_GLOBAL(SSatmos)

/datum/subsystem/atmos/Initialize(timeofday)
	for(var/obj/machinery/atmospherics/unary/U in machines)
	if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
		var/obj/machinery/atmospherics/unary/vent_pump/T = U
		T.broadcast_status()
	else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
		var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
		T.broadcast_status()
	..()
