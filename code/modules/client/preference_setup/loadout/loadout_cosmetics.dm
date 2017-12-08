/datum/gear/cosmetic
	display_name = "purple comb"
	sort_category = "Cosmetics"

/datum/gear/cosmetic/lipstick
	display_name = "lipstick selection"

/datum/gear/cosmetic/lipstick/New()
	..()
	var/lipsticks = list()
	gear_tweaks += new/datum/gear_tweak/path(lipsticks)

/datum/gear/cosmetic/mirror
	display_name = "handheld mirror"
