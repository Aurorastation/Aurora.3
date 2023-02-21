/obj/item/device/radio/gloves
	name = "radio gloves"
	desc = "Gloves that you can talk into, if you're into that."
	slot_flags = SLOT_GLOVES
	gender = PLURAL
	w_class = ITEMSIZE_SMALL
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "fingerlessgloves"
	item_state = "fingerlessgloves"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/clothing/lefthand_gloves.dmi',
		slot_r_hand_str = 'icons/mob/items/clothing/righthand_gloves.dmi'
		)
	canhear_range = 0
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/device/radio/gloves/sign
	name = "sign-to-speech gloves"
	desc = "Designed by the SCCV Horizon's research department as an accessibility aid for speech-impaired colleagues, these fingerless gloves fit snugly over the hands and, \
	through a series of gyroscopic stabilizers and motion trackers, translate Sign Language into Tau Ceti Basic when toggled on. \
	There's an integrated radio to allow for usage with departmental communications."
	transign = 1
	action_button_name = "Toggle sign-to-speech"

/obj/item/device/radio/gloves/sign/verb/toggle_transign()
	if(transign)
		transign = 0
		to_chat(usr, "You disable the translation software on the gloves. They will no longer translate your sign language.")
	else
		transign = 1
		to_chat(usr, "You enable the translation software on the gloves. They will now translate your sign language.")

/obj/item/device/radio/gloves/sign/ui_action_click()
	if(src in usr)
		toggle_transign()
