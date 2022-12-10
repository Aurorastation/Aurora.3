/mob/living/captive_brain/instantiate_hud(var/datum/hud/HUD)
	HUD.captive_brain_hud()

/datum/hud/proc/captive_brain_hud()
	src.adding = list()

	var/obj/screen/resist = new /obj/screen()
	resist.name = "resist"
	resist.icon = 'icons/mob/screen/captive_brain.dmi'
	resist.icon_state = "resist"
	resist.screen_loc = "EAST-8,BOTTOM:8"
	resist.layer = SCREEN_LAYER
	adding += resist

	mymob.client.screen += src.adding