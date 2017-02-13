var/global/list/power_using_machines	= list()

/datum/subsystem/power
	name = "Power"
	wait = 2 SECONDS
	priority = SS_PRIORITY_MACHINERY
	flags = SS_NO_INIT
	display_order = SS_DISPLAY_POWER

	var/tmp/list/processing_power_users = list()
	var/tmp/list/processing_powersinks = list()

/datum/subsystem/power/fire(resumed = 0)
	if (!resumed)
		src.processing_power_users = power_using_machines.Copy()
		src.processing_powersinks = processing_power_items.Copy()

		// Let's assume that powernets is sane.
		for (var/powernet in powernets)
			powernet:reset()

	var/list/current_machinery = processing_power_users
	var/list/current_powersinks = processing_powersinks

	while (current_machinery.len)
		var/obj/machinery/M = current_machinery[current_machinery.len]
		current_machinery.len--

		if (NULL_OR_GC(M))
			remove_machine(M)
			continue

		if (M.use_power)
			M.auto_use_power()

		if (MC_TICK_CHECK)
			return

	while (current_powersinks.len)
		var/obj/item/I = current_powersinks[current_powersinks.len]
		current_powersinks.len--

		if (NULL_OR_GC(I) || !I.pwr_drain())
			processing_power_items -= I
		
		if (MC_TICK_CHECK)
			return

/datum/subsystem/power/stat_entry()
	..()
	stat(null, "[power_using_machines.len] power-using machines, [processing_power_users.len] queued")
	stat(null, "[processing_power_items.len] power items, [processing_powersinks.len] queued")
