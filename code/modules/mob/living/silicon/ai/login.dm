/mob/living/silicon/ai/LateLogin()
	..()
	regenerate_icons()

	for(var/image/obfuscation_image in SSai_obfuscation.get_obfuscation_images())
		client.images += obfuscation_image

	if(stat != DEAD)
		for(var/obj/machinery/ai_status_display/O in SSmachinery.all_status_displays) //change status
			O.mode = 1
			O.emotion = "Neutral"
