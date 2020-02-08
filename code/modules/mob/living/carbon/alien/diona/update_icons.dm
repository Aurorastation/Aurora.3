/mob/living/carbon/alien/diona/update_icons()
	if(stat == DEAD)
		icon_state = "[initial(icon_state)]_dead"
	else if(lying || resting || stunned)
		icon_state = "[initial(icon_state)]_sleep"
	else
		icon_state = "[initial(icon_state)]"

	cut_overlays()

	if(flower_color)
		add_overlay("flower_back")
		if(!flower_image)
			flower_image = image(icon = 'icons/mob/diona.dmi', icon_state = "flower_fore")
			flower_image.color = flower_color
		add_overlay(flower_image)

	if(hat)
		add_overlay(get_hat_icon(hat, 0, -8))