/obj/item/modular_computer/handheld/pda
	name = "PDA"
	desc = "The latest in portable microcomputer solutions from Thinktronic Systems, LTD."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	icon_state_screensaver = "off"
	icon_state_unpowered = "pda"
	var/icon_add // this is the "bar" part in "pda-bar"
	enrolled = DEVICE_PRIVATE

/obj/item/modular_computer/handheld/pda/set_icon()
	if(icon_add)
		icon_state += "-[icon_add]"
	icon_state_unpowered = icon_state
	icon_state_broken = icon_state

/obj/item/modular_computer/handheld/pda/old
	icon = 'icons/obj/pda_old.dmi'

/obj/item/modular_computer/handheld/pda/rugged
	icon = 'icons/obj/pda_rugged.dmi'

/obj/item/modular_computer/handheld/pda/slate
	icon = 'icons/obj/pda_slate.dmi'

/obj/item/modular_computer/handheld/pda/smart
	icon = 'icons/obj/pda_smart.dmi'