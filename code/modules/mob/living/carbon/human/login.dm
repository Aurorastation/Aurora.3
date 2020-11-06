/mob/living/carbon/human/LateLogin()
	..()
	update_hud()
	if(species)
		species.handle_login_special(src)
	if(mind.vampire && !(mind.vampire.status & VAMP_ISTHRALL))
		mind.vampire.blood_hud = new /obj/screen/vampire/blood()
		mind.vampire.frenzy_hud = new /obj/screen/vampire/frenzy()
		client.screen += mind.vampire.blood_hud
		client.screen += mind.vampire.frenzy_hud