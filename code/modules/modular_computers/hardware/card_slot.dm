/obj/item/computer_hardware/card_slot
	name = "RFID card slot"
	desc = "Slot that allows this computer to write data on RFID cards. Necessary for some programs to run properly."
	power_usage = 10 //W
	critical = FALSE
	icon_state = "cardreader"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 2)

	var/obj/item/card/id/stored_card

/obj/item/computer_hardware/card_slot/Destroy()
	if(parent_computer?.card_slot == src)
		parent_computer.card_slot = null
	if(stored_card)
		stored_card.forceMove(get_turf(parent_computer))
	parent_computer = null
	return ..()