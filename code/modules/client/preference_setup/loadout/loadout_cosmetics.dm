/datum/gear/cosmetic
	display_name = "handheld mirror"
	path = /obj/item/mirror
	sort_category = "Cosmetics"

/datum/gear/cosmetic/lipstick
	display_name = "lipstick (selection)"
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

/datum/gear/cosmetic/comb
	display_name = "plastic comb"
	path = /obj/item/haircomb
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION