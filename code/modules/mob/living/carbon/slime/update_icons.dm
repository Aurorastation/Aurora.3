/mob/living/carbon/slime/regenerate_icons()
	if(stat == DEAD)
		icon_state = "[slime_color] baby slime dead"
	else
		icon_state = "[slime_color] [is_adult ? "adult" : "baby"] slime[victim ? "" : " eat"]"
	cut_overlays()
	if(mood)
		add_overlay("aslime-[mood]")
	..()
