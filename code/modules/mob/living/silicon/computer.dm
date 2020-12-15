/mob/living/silicon
	var/computer_path

/mob/living/silicon/pai
	computer_path = /obj/item/modular_computer/silicon/pai

/mob/living/silicon/robot
	computer_path = /obj/item/modular_computer/silicon/robot

/mob/living/silicon/robot/drone
	computer_path = /obj/item/modular_computer/silicon/robot/drone

/mob/living/silicon/ai
	var/datum/nano_module/computer_ntnetmonitor/ntnet_monitor
	computer_path = /obj/item/modular_computer/silicon/ai

/mob/living/silicon/ai
	silicon_subsystems = list(
		/mob/living/silicon/proc/subsystem_alarm_monitor,
		/mob/living/silicon/proc/subsystem_law_manager,
		/mob/living/silicon/ai/proc/subsystem_ntnet_monitor,
		/mob/living/silicon/proc/computer_interact,
		/mob/living/silicon/proc/silicon_mimic_accent
	)

/mob/living/silicon/robot/syndicate
	register_alarms = 0
	silicon_subsystems = list(
		/mob/living/silicon/proc/subsystem_law_manager,
		/mob/living/silicon/proc/silicon_mimic_accent
	)

/mob/living/silicon/ai/Destroy()
	QDEL_NULL(ntnet_monitor)
	return ..()

/mob/living/silicon/proc/init_subsystems()
	alarm_monitor 	= new(src)
	law_manager 	= new(src)
	rcon 			= new(src)

	if(!register_alarms)
		return

	for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
		AH.register_alarm(src, /mob/living/silicon/proc/receive_alarm)
		queued_alarms[AH] = list()	// Makes sure alarms remain listed in consistent order

	if(computer_path)
		computer = new computer_path(src)

/mob/living/silicon/ai/init_subsystems()
	..()
	ntnet_monitor = new(src)

/****************
*	Computer	*
*****************/
/mob/living/silicon/proc/computer_interact()
	set name = "Open Computer Interface"
	set category = "Subsystems"

	computer.attack_self(src)

/mob/living/silicon/pai/proc/personal_computer_interact()
	set name = "Access Local Computer"
	set category = "Subsystems"

	parent_computer.attack_self(src)

/********************
*	Alarm Monitor	*
********************/
/mob/living/silicon/proc/subsystem_alarm_monitor()
	set name = "Alarm Monitor"
	set category = "Subsystems"

	alarm_monitor.ui_interact(usr, state = self_state)

/****************
*	Law Manager	*
****************/
/mob/living/silicon/proc/subsystem_law_manager()
	set name = "Law Manager"
	set category = "Subsystems"

	law_manager.ui_interact(usr, state = conscious_state)

/********************
*	NTNet Monitor	*
********************/
/mob/living/silicon/ai/proc/subsystem_ntnet_monitor()
	set name = "NTNet Monitoring"
	set category = "Subsystems"

	ntnet_monitor.ui_interact(usr, state = conscious_state)