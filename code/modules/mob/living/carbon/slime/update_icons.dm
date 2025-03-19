/mob/living/carbon/slime/regenerate_icons()
	if(stat == DEAD)
		icon_state = "[colour] baby slime dead"
	else
		icon_state = "[colour] [is_adult ? "adult" : "baby"] slime[victim ? "" : " eat"]"
	ClearOverlays()
	if(mood)
		AddOverlays("aslime-[mood]")
	..()
