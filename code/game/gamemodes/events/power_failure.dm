
/proc/power_failure(var/announce = 1, var/severity = 2)
	if(announce)
		command_announcement.Announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", "Critical Power Failure", new_sound = 'sound/AI/poweroff.ogg')

	for(var/obj/machinery/power/smes/buildable/S in SSpower.smes_units)
		S.energy_fail(rand(20 * severity,75 * severity))

	for(var/obj/machinery/power/apc/C in SSmachinery.processing_machines)
		if(!C.is_critical)
			C.energy_fail(rand(40 * severity,150 * severity))

/proc/power_restore(var/announce = 1)
	if(announce)
		command_announcement.Announce("Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal", new_sound = 'sound/AI/poweron.ogg')

	for(var/obj/machinery/power/smes/buildable/S in SSpower.smes_units)
		S.energy_restore()

	for(var/obj/machinery/power/apc/C in SSmachinery.processing_machines)
		if(!C.is_critical)
			C.energy_restore()
