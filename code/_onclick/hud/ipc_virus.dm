/atom/movable/screen/virus
	icon = 'icons/mob/screen/ipc_virus.dmi'
	icon_state = "norinori"
	screen_loc = "CENTER"
	var/list/static/virus_messages = list("Get PWNED!", "LOLOLOLOLOL", "BAZINGA (This is a reference!)")

/atom/movable/screen/virus/Click()
	var/obj/living/carbon/human/ipc = usr
	to_chat(ipc, SPAN_BAD(pick(virus_messages)))
