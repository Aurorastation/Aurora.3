/obj/item/modular_computer/handheld
	name = "tablet computer"
	lexical_name = "tablet"
	desc = "A portable device for your needs on the go."
	desc_info = "To deploy the charging cable on this device, either drag and drop it over a nearby APC, or click on the APC with the computer in hand."
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tablet"
	icon_state_unpowered = "tablet"
	icon_state_menu = "menu"
	overlay_state = "electronic"
	slot_flags = SLOT_ID | SLOT_BELT
	can_reset = TRUE
	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 1
	w_class = ITEMSIZE_SMALL
	is_portable = TRUE

/obj/item/modular_computer/handheld/Initialize()
	. = ..()
	set_icon()

/obj/item/modular_computer/handheld/proc/set_icon()
	icon_state_unpowered = icon_state
	icon_state_broken = icon_state