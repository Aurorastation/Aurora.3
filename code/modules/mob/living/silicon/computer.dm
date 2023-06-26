/mob/living/silicon
	var/computer_path

/mob/living/silicon/pai
	computer_path = /obj/item/modular_computer/silicon/pai

/mob/living/silicon/robot
	computer_path = /obj/item/modular_computer/silicon/robot

/mob/living/silicon/robot/drone
	computer_path = /obj/item/modular_computer/silicon/robot/drone

/mob/living/silicon/ai
	computer_path = /obj/item/modular_computer/silicon/ai

/mob/living/silicon/ai
	silicon_subsystems = list(
		/mob/living/silicon/proc/silicon_mimic_accent
	)

/mob/living/silicon/robot/combat
	register_alarms = 0
	silicon_subsystems = list(
		/mob/living/silicon/proc/silicon_mimic_accent
	)

/mob/living/silicon/proc/init_subsystems()
	if(computer_path)
		computer = new computer_path(src)

	if(!register_alarms)
		return

	for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
		AH.register_alarm(src, /mob/living/silicon/proc/receive_alarm)
		queued_alarms[AH] = list()	// Makes sure alarms remain listed in consistent order

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

	if(!parent_computer)
		to_chat(usr, SPAN_WARNING("You don't have a local computer to interface with!"))
		return
	parent_computer.attack_self(src)

