/datum/gear/cosmetic
	display_name = "purple comb"
	path = /obj/item/weapon/haircomb
	sort_category = "Cosmetics"

/datum/gear/cosmetic/lipstick
	display_name = "lipstick selection"
	path = /obj/item/weapon/lipstick

/datum/gear/cosmetic/lipstick/New()
	..()
	var/lipsticks = list()
	lipsticks["lipstick, red"] = /obj/item/weapon/lipstick
	lipsticks["lipstick, purple"] = /obj/item/weapon/lipstick/purple
	lipsticks["lipstick, jade"] = /obj/item/weapon/lipstick/jade
	lipsticks["lipstick, black"] = /obj/item/weapon/lipstick/black
	lipsticks["lipstick, pink"] = /obj/item/weapon/lipstick/pink
	gear_tweaks += new/datum/gear_tweak/path(lipsticks)

/datum/gear/cosmetic/mirror
	display_name = "handheld mirror"
	path = /obj/item/weapon/mirror
