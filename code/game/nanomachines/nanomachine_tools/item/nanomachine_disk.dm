/obj/item/nanomachine_disk
	name = "nanomachine programming disk"
	var/name_label
	desc = "A disk containing the programming required to make nanomachines function in a certain way."

	icon = 'icons/obj/cloning.dmi'
	icon_state = "harddisk"

	var/loaded_program

/obj/item/nanomachine_disk/Initialize(mapload, set_name_label, set_loaded_program)
	. = ..()

	if(set_loaded_program)
		loaded_program = set_loaded_program
	if(!loaded_program)
		return INITIALIZE_HINT_QDEL

	if(set_name_label)
		name_label = set_name_label
	if(name_label)
		name_unlabel = name
		name = "[name] ([name_label])"
		verbs += /atom/proc/remove_label