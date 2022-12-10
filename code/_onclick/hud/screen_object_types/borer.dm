/obj/screen/borer
	icon = 'icons/mob/screen/borer.dmi'
	maptext_x = 5
	maptext_y = 16

/obj/screen/borer/chemicals
	name = "chemicals"
	icon_state = "chemicals"
	screen_loc = ui_alien_toxin

/obj/screen/borer/chemicals/Click(var/location, var/control, var/params)
	if(istype(usr, /mob/living/simple_animal/borer))
		var/mob/living/simple_animal/borer/B = usr
		to_chat(usr, SPAN_NOTICE("You have [B.chemicals]u of chemicals to use for your abilities."))