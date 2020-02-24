/mob/living/carbon/slime/examine(mob/user)
	..(user)
	var/msg = ""
	if(src.stat == DEAD)
		msg += span("deadsay", "It is limp and unresponsive.\n")
	else
		if(src.getBruteLoss())
			if(src.getBruteLoss() < 40)
				msg += span("warning", "It has some punctures in its flesh!\n")
			else
				msg += span("danger", "It has severe punctures and tears in its flesh!\n")

		switch(powerlevel)
			if(2 to 3)
				msg += span("notice", "It is flickering gently with a little electrical activity.\n")
			if(4 to 5)
				msg += span("notice", "It is glowing gently with moderate levels of electrical activity.\n")
			if(6 to 9)
				msg += span("warning", "It is glowing brightly with high levels of electrical activity.\n")
			if(10)
				msg += span("danger", "It is radiating with massive levels of electrical activity!\n")

	msg += "*---------*"
	to_chat(user, msg)
	return