/obj/item/computer_hardware/card_slot
	name = "RFID card slot"
	desc = "Slot that allows this computer to write data on RFID cards. Necessary for some programs to run properly."
	power_usage = 10 // W
	critical = FALSE
	icon_state = "cardreader"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 2)

	var/obj/item/card/id/stored_card

	// Storing Items
	var/list/allowed_items = list(
		/obj/item/pen,
		/obj/item/lipstick,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/mask/smokable/cigarette
	)
	var/obj/item/stored_item // Used for pen insertion and removal.

/obj/item/computer_hardware/card_slot/Destroy()
	if(parent_computer?.card_slot == src)
		parent_computer.card_slot = null
	if(stored_card)
		stored_card.forceMove(get_turf(parent_computer))
	parent_computer = null
	return ..()

/obj/item/computer_hardware/card_slot/proc/insert_id(var/obj/item/card/id/id)
	if(!istype(id))
		return

	id.forceMove(src)
	stored_card = id

	if(parent_computer)
		parent_computer.verbs += /obj/item/modular_computer/proc/eject_id
		parent_computer.initial_name = parent_computer.name
		parent_computer.name = "[parent_computer.name] - [id.registered_name], [id.assignment]"

/obj/item/computer_hardware/card_slot/proc/eject_id(mob/user)
	if(!stored_card)
		return
	if(ishuman(user))
		user.put_in_hands(stored_card)
	else
		stored_card.forceMove(get_turf(src))
	stored_card = null

	if(parent_computer)
		parent_computer.verbs -= /obj/item/modular_computer/proc/eject_id
		parent_computer.name = parent_computer.initial_name