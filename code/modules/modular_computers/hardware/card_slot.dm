/obj/item/computer_hardware/card_slot
	name = "RFID card slot"
	desc = "Slot that allows this computer to write data on RFID cards. Necessary for some programs to run properly."
	hw_type = MC_CARD
	power_usage = 10 //W
	critical = FALSE
	icon_state = "cardreader"
	hardware_size = HW_MICRO
	origin_tech = list(TECH_DATA = 2)

	var/obj/item/card/id/stored_card

	// Storing items (We PDAs now boys)
	var/list/allowed_items = list(/obj/item/pen,
								   /obj/item/lipstick,
								   /obj/item/device/flashlight/pen,
								   /obj/item/clothing/mask/smokable/cigarette
								   )
	var/obj/item/stored_item //Used for pen, crayon, and lipstick insertion/removal

/obj/item/computer_hardware/card_slot/Destroy()
	var/obj/item/computer_hardware/card_slot/C = computer?.hardware_by_slot(MC_CARD)
	if(C == src)
		computer.remove_component(src)
	if(stored_card)
		stored_card.forceMove(get_turf(computer))
	if(stored_item)
		stored_item.forceMove(get_turf(computer))
	computer = null
	return ..()

/obj/item/computer_hardware/card_slot/update_verbs()
	if(computer && stored_card)
		computer.verbs += /obj/item/modular_computer/proc/eject_id
	if(computer && stored_item)
		computer.verbs += /obj/item/modular_computer/proc/eject_item

/obj/item/computer_hardware/card_slot/proc/insert_id(var/obj/item/card/id/id)
	if(!istype(id))
		return

	id.forceMove(src)
	stored_card = id

	if(computer)
		update_verbs()
		computer.initial_name = computer.name
		computer.name = "[computer.name] ([id.registered_name] ([id.assignment]))"

/obj/item/computer_hardware/card_slot/proc/eject_id(mob/user)
	if(!stored_card)
		return
	if(ishuman(user))
		user.put_in_hands(stored_card)
	else
		stored_card.forceMove(get_turf(src))
	stored_card = null

	if(computer)
		update_verbs()
		computer.name = computer.initial_name
