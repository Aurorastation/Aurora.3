// SYND EYE

/mob/abstract/eye/syndnet
	// Camera eye mob for syndicate networks.
	name = "Inactive Syndicate Eye"
	name_suffix = "Syndicate Eye"
	var/list/hud_elements

/mob/abstract/eye/syndnet/Initialize()
	. = ..()
	visualnet = syndnet
	LAZYINITLIST(hud_elements)
	instantiate_hud()

/mob/abstract/eye/syndnet/instantiate_hud()
	LAZYADD(hud_elements, new/obj/screen/syndeye/move_up(src))
	LAZYADD(hud_elements, new/obj/screen/syndeye/move_down(src))
	LAZYADD(hud_elements, new/obj/screen/syndeye/return_to_console(src))

/mob/abstract/eye/syndnet/proc/toggle_eye(mob/user)
	if (user.eyeobj == src)
		release(user)
		if(user.client)
			user.client.screen -= hud_elements
		return FALSE
	else
		if(user.client)
			user.client.screen |= hud_elements
		possess(user)
		return TRUE

/obj/screen/syndeye
	icon = 'icons/mob/screen/ai.dmi'
	layer = 21

/obj/screen/syndeye/move_up
	name = "Move Up"
	icon_state = "move_up"
	screen_loc = "WEST:6,SOUTH+6"

/obj/screen/syndeye/move_up/Click()
	usr.up()

/obj/screen/syndeye/move_down
	name = "Move Down"
	icon_state = "move_down"
	screen_loc = "WEST:6,SOUTH+5"

/obj/screen/syndeye/move_down/Click()
	usr.down()

/obj/screen/syndeye/return_to_console
	name = "Exit Camera Uplink"
	icon_state = "call_shuttle"
	screen_loc = "WEST:6,SOUTH+7"

/obj/screen/syndeye/return_to_console/Click()
	if (ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/mob/abstract/eye/syndnet/E = H.eyeobj
		if (istype(E))
			E.toggle_eye(H)