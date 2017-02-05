/obj/machinery/crusher_piston
	name = "Trash compactor piston"
	desc = "A colossal piston used for crushing garbage."
	icon = 'icons/obj/doors/Doorhatchmaint2.dmi' //Placeholder, aswell
	icon_state = "door_open" //Placeholder
	density = 0
	anchored = 1

	var/disabled = 0
	var/datum/computer_file/program/crushercontrol/linked_program

/obj/machinery/crusher_piston/proc/start_crush()
	log_debug("Crush started for [src]")
