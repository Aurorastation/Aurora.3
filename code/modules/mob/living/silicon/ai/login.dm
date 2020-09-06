/mob/living/silicon/ai/LateLogin()	//ThisIsDumb(TM) TODO: tidy this up ¬_¬ ~Carn // It's still dumb and not really tidied up. Enjoy!
	..()
	regenerate_icons()
	flash = new /obj/screen()
	flash.icon_state = "blank"
	flash.name = "flash"
	flash.screen_loc = ui_entire_screen
	flash.layer = 17
	flash.mouse_opacity = 0
	blind = new /obj/screen()
	blind.icon_state = "black"
	blind.name = " "
	blind.screen_loc = ui_entire_screen
	blind.invisibility = 101
	client.screen.Add( blind, flash )

	for(var/image/obfuscation_image in SSai_obfuscation.get_obfuscation_images())
		client.images += obfuscation_image

	if(stat != DEAD)
		for(var/obj/machinery/ai_status_display/O in SSmachinery.all_status_displays) //change status
			O.mode = 1
			O.emotion = "Neutral"
