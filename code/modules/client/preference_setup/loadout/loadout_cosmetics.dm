/datum/gear/cosmetic
	display_name = "purple comb"
	path = /obj/item/haircomb
	sort_category = "Cosmetics"

/datum/gear/cosmetic/lipstick
	display_name = "lipstick selection"
	path = /obj/item/lipstick

/datum/gear/cosmetic/lipstick/New()
	..()
	var/lipsticks = list()
	lipsticks["lipstick, red"] = /obj/item/lipstick
	lipsticks["lipstick, purple"] = /obj/item/lipstick/purple
	lipsticks["lipstick, jade"] = /obj/item/lipstick/jade
	lipsticks["lipstick, black"] = /obj/item/lipstick/black
	lipsticks["lipstick, pink"] = /obj/item/lipstick/pink
	gear_tweaks += new/datum/gear_tweak/path(lipsticks)

/datum/gear/cosmetic/mirror
	display_name = "handheld mirror"
	path = /obj/item/mirror
