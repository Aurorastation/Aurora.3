proc/create_new_xenomorph(var/alien_caste,var/target)

	target = get_turf(target)
	if(!target || !alien_caste) return

	var/mob/living/carbon/human/new_alien = new(target)
	new_alien.set_species("Xenomorph [alien_caste]")
	return new_alien

/mob/living/carbon/human/xdrone/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, "Xenomorph Drone")
	src.see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING

/mob/living/carbon/human/xsentinel/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, "Xenomorph Sentinel")
	src.see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING

/mob/living/carbon/human/xhunter/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, "Xenomorph Hunter")
	src.see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING

/mob/living/carbon/human/xqueen/New(var/new_loc)
	h_style = "Bald"
	..(new_loc, "Xenomorph Queen")
	src.see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING