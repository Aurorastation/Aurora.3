/obj/item/modular_computer/handheld/pda
	name = "Personal Data Assistant"
	desc = "The latest in portable microcomputer solutions from Thinktronic Systems, LTD."
	var/icon_add // this is the "bar" part in "pda-bar"
	enrolled = DEVICE_PRIVATE

/obj/item/modular_computer/handheld/pda/Initialize()
	. = ..()
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	if(icon_add)
		icon_state += "-[icon_add]"
	icon_state_unpowered = icon_state
	icon_state_broken = icon_state