var/obj/nano_module/crew_monitor/crew_monitor

/mob/living/silicon/ai/proc/nano_crew_monitor()
	set category = "AI Commands"
	set name = "Crew Monitor"
	if (!crew_monitor)
		init_subsystems()
	crew_monitor.ui_interact(usr)
