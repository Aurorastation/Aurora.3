// A wrapper that allows the computer to contain an intellicard.
/obj/item/computer_hardware/ai_slot
	name = "intellicard slot"
	desc = "An IIS interlink with connection uplinks that allow the device to interface with most common intellicard models. Too large to fit into tablets. Uses a lot of power when active."
	icon_state = "aislot"
	hw_type = MC_AI
	hardware_size = HW_STANDARD
	critical = 0
	power_usage = 100
	origin_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	var/obj/item/aicard/stored_ai
	var/obj/item/device/paicard/stored_pai
	var/power_usage_idle = 100
	var/power_usage_occupied = 2 KILOWATTS

/obj/item/computer_hardware/ai_slot/proc/update_power_usage()
	if(!stored_ai?.carded_ai)
		power_usage = power_usage_idle
		return
	power_usage = power_usage_occupied

/obj/item/computer_hardware/ai_slot/update_verbs()
	if(computer && stored_ai)
		computer.verbs += /obj/item/modular_computer/proc/eject_ai
	if(computer && stored_pai)
		computer.verbs += /obj/item/modular_computer/proc/eject_personal_ai

/obj/item/computer_hardware/ai_slot/attackby(obj/item/W, mob/user)
	if(..())
		return TRUE
	if(istype(W, /obj/item/aicard))
		if(stored_ai)
			to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
			return
		user.drop_from_inventory(W, src)
		stored_ai = W
		update_power_usage()
	if(istype(W, /obj/item/device/paicard))
		if(stored_pai)
			to_chat(user, SPAN_WARNING("\The [src] is already occupied."))
			return
		user.drop_from_inventory(W, src)
		stored_pai = W
	if(W.isscrewdriver())
		to_chat(user, SPAN_NOTICE("You manually remove \the [stored_ai] from \the [src]."))
		stored_ai.forceMove(get_turf(src))
		stored_ai = null
		update_power_usage()

/obj/item/computer_hardware/ai_slot/Destroy()
	var/obj/item/computer_hardware/ai_slot/A = computer?.hardware_by_slot(MC_AI)
	if(A == src)
		computer.remove_component(src)
	if(stored_ai)
		stored_ai.forceMove(get_turf(computer))
	if(stored_pai)
		stored_pai.forceMove(get_turf(computer))
	computer = null
	return ..()
