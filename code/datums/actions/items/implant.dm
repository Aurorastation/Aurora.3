/datum/action/item_action/hands_free/implant
	name = "Activate Implant"
	button_icon = 'icons/obj/action_buttons/implants.dmi'
	desc = "Activate the implant. Can be used even when restrained or stunned."

/datum/action/item_action/hands_free/implant/explosive_implant
	check_flags = NONE
	name = "Activate Explosive Implant"
	desc = "Detonate the explosive implanted in you. Can be used even when unconcious, restrained, or stunned."
	button_icon_state = "explosive"

/datum/action/item_action/hands_free/implant/chemical_implant
	name = "Dispense Reagents from Chemical Implant"
	button_icon_state = "reagents"

/datum/action/item_action/hands_free/implant/compressed_implant
	name = "Retrieve Item from Compressed Implant"
	button_icon_state = "storage"

/datum/action/item_action/hands_free/implant/freedom_implant
	name = "Activate Freedom Implant"
	button_icon_state = "freedom"

/datum/action/item_Action/hands_free/implant/emp_implant
	name = "Activate EMP Implant"
	button_icon_state = "emp"

