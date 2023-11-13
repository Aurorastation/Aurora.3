/mob/living/carbon/slime/examine(mob/user)
	. = ..()
	var/msg = ""
	if(src.stat == DEAD)
		msg += span("deadsay", "It is limp and unresponsive.\n")
	else
		if(src.getBruteLoss())
			if(src.getBruteLoss() < 40)
				msg += SPAN_WARNING("It has some punctures in its flesh!\n")
			else
				msg += SPAN_DANGER("It has severe punctures and tears in its flesh!\n")

		switch(powerlevel)
			if(2 to 3)
				msg += SPAN_NOTICE("It is flickering gently with a little electrical activity.\n")
			if(4 to 5)
				msg += SPAN_NOTICE("It is glowing gently with moderate levels of electrical activity.\n")
			if(6 to 9)
				msg += SPAN_WARNING("It is glowing brightly with high levels of electrical activity.\n")
			if(10)
				msg += SPAN_DANGER("It is radiating with massive levels of electrical activity!\n")

	msg += "*---------*"
	to_chat(user, msg)
	return
