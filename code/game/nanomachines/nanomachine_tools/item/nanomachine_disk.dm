/obj/item/nanomachine_disk
	name = "nanomachine programming disk"
	var/name_label
	desc = "An electronic disk produced by Zeng-Hu Pharmaceuticals for upgrading nanomachine equipment. Keep this safe -- it's probably worth more than you make in a month."

	icon = 'icons/obj/contained_items/tools/nanomachine_disk.dmi'
	icon_state = "disk"

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