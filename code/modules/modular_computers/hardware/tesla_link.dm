/obj/item/computer_hardware/tesla_link
	name = "tesla link"
	desc = "An advanced tesla link that wirelessly recharges connected device from nearby area power controllers."
	critical = FALSE
	icon_state = "teslalink"
	hardware_size = 3
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	var/passive_charging_rate = 250 // W

/obj/item/computer_hardware/tesla_link/Destroy()
	if(parent_computer?.tesla_link == src)
		parent_computer.tesla_link = null
	return ..()

/obj/item/computer_hardware/tesla_link/small
	name = "small tesla link"
	desc = "A miniaturized advanced tesla link that wirelessly recharges connected device from nearby area power controllers."
	icon_state = "teslalink"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	passive_charging_rate = 75
