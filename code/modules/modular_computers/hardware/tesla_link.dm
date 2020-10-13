/obj/item/computer_hardware/tesla_link
	name = "tesla link"
	desc = "An advanced tesla link that wirelessly recharges connected device from nearby area power controller."
	critical = FALSE
	icon_state = "teslalink"
	hardware_size = 3
	origin_tech = "{'programming':2,'powerstorage':3,'engineering':2}"
	var/passive_charging_rate = 250 // W

/obj/item/computer_hardware/tesla_link/Destroy()
	if(parent_computer?.tesla_link == src)
		parent_computer.tesla_link = null
	return ..()