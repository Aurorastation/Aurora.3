/datum/hud/proc/syndeye_hud()
	other = list()

	adding = list(
		new /obj/screen/syndeye/return_to_console,
		new /obj/screen/syndeye/move_up,
		new /obj/screen/syndeye/move_down
	)

	mymob.client.screen += adding + other

/mob/living/carbon/human/instantiate_hud(var/datum/hud/HUD, var/ui_style, var/ui_color, var/ui_alpha)
	// haha this is awful
	if(istype(eyeobj, /mob/abstract/eye/syndnet))
		HUD.syndeye_hud()
	else
		..()

/obj/screen/syndeye
	icon = 'icons/mob/screen/ai.dmi'
	layer = 21

/obj/screen/syndeye/move_up
	name = "Move Up"
	icon_state = "move_up"
	screen_loc = ui_ai_move_up

/obj/screen/syndeye/move_up/Click()
	usr.up()

/obj/screen/syndeye/move_down
	name = "Move Down"
	icon_state = "move_down"
	screen_loc = ui_ai_move_down

/obj/screen/syndeye/move_down/Click()
	usr.down()

/obj/screen/syndeye/return_to_console
	name = "Exit Camera Uplink"
	icon_state = "call_shuttle"
	screen_loc = ui_ai_core

/obj/screen/syndeye/return_to_console/Click()
	if (ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/mob/abstract/eye/syndnet/E = H.eyeobj
		if (istype(E))
			E.toggle_eye(H)
			H.rebuild_hud()