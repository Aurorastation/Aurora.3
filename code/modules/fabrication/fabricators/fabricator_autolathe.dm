/obj/structure/machinery/fabricator/autolathe
	name = "autolathe"
	desc = "A large device loaded with various item schematics. It produces common day to day items from a variety of materials."
	icon = 'icons/obj/machinery/fabricators/autolathe.dmi'
	icon_state = "autolathe"

/obj/structure/machinery/fabricator/autolathe/mechanics_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += "Alt-click with a rapid part exchange device or open circuit assembly in your active hand to recycle its compatible contents."

/obj/structure/machinery/fabricator/autolathe/AltClick(mob/user)
	. = ..()
	if(use_check_and_message(user))
		return


	if(fab_status_flags & FAB_BUSY)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for the completion of the previous operation."))
		return

	if(stat || !is_functioning())
		to_chat(user, SPAN_WARNING("\The [src] cannot accept materials in its current state."))
		return

	var/obj/item/electronic_assembly/recyclable_container = user.get_active_hand()
	if(istype(recyclable_container, /obj/item/electronic_assembly))
		var/obj/item/electronic_assembly/recyclable_circuit_assembly = recyclable_container
		if(recyclable_circuit_assembly.opened)
			recycle_item_contents(recyclable_container, user)
			return
		else
			to_chat(user, SPAN_WARNING("\The [recyclable_circuit_assembly] must be open before it's contents can be recycled."))

	if(istype(recyclable_container, /obj/item/storage/part_replacer))
		recycle_item_contents(recyclable_container, user)
		return

/obj/structure/machinery/fabricator/autolathe/mounted
	name = "\improper mounted autolathe"
	density = FALSE
	anchored = FALSE
	idle_power_usage = 0
	active_power_usage = 0
	interact_offline = TRUE
	does_flick = FALSE

/obj/structure/machinery/fabricator/mounted/ui_state(mob/user)
	return GLOB.heavy_vehicle_state
