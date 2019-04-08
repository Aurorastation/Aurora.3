/obj/item/modular_computer/tablet
	name = "tablet computer"
	desc = "A portable device for your needs on the go."
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tablet"
	icon_state_unpowered = "tablet"
	icon_state_menu = "menu"
	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 1
	w_class = 2
	light_strength = 2					// Same as PDAs

/obj/item/modular_computer/tablet/Initialize()
	. = ..()
	icon_state += pick("", "-blue", "-green", "-red", "-brown")
