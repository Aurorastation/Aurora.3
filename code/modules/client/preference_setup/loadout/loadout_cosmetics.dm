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
	lipsticks["lipstick, amberred"] = /obj/item/lipstick/amberred
	lipsticks["lipstick, cherry"] = /obj/item/lipstick/cherry
	lipsticks["lipstick, orange"] = /obj/item/lipstick/orange
	lipsticks["lipstick, gold"] = /obj/item/lipstick/gold
	lipsticks["lipstick, deepred"] = /obj/item/lipstick/deepred
	lipsticks["lipstick, rosepink"] = /obj/item/lipstick/rosepink
	lipsticks["lipstick, nude"] = /obj/item/lipstick/nude
	lipsticks["lipstick, wine"] = /obj/item/lipstick/wine
	lipsticks["lipstick, peach"] = /obj/item/lipstick/peach
	lipsticks["lipstick, forestgreen"] = /obj/item/lipstick/forestgreen
	lipsticks["lipstick, skyblue"] = /obj/item/lipstick/skyblue
	lipsticks["lipstick, teal"] = /obj/item/lipstick/teal

	gear_tweaks += new/datum/gear_tweak/path(lipsticks)

/datum/gear/cosmetic/mirror
	display_name = "handheld mirror"
	path = /obj/item/mirror
