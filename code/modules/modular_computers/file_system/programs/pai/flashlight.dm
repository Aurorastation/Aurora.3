/datum/computer_file/program/pai_flashlight
	filename = "flashlight"
	filedesc = "pAI Flashlight"
	extended_desc = "This service toggles the integrated flashlight systems."
	size = 0
	program_type = PROGRAM_SERVICE
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_SILICON_PAI

/datum/computer_file/program/pai_flashlight/service_activate()
	. = ..()

	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return

	var/mob/living/silicon/pai/host = true_computer.computer_host
	host.toggle_flashlight()

/datum/computer_file/program/pai_flashlight/service_deactivate()
	. = ..()

	if(!istype(computer, /obj/item/modular_computer/silicon))
		return

	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return

	var/mob/living/silicon/pai/host = true_computer.computer_host
	host.toggle_flashlight()