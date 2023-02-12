/obj/item/modular_computer/handheld/pda
	name = "PDA"
	lexical_name = "tablet"
	desc = "The latest in portable microcomputer solutions from Thinktronic Systems, LTD."
	icon = 'icons/obj/pda.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/device/lefthand_device.dmi',
		slot_r_hand_str = 'icons/mob/items/device/righthand_device.dmi',
		)
	icon_state = "pda"
	item_state = "electronic"
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
