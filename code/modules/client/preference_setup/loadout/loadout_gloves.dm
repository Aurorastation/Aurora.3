// Gloves
/datum/gear/gloves
	display_name = "watch"
	path = /obj/item/clothing/gloves/watch
	cost = 2
	slot = slot_gloves
	sort_category = "Gloves and Handwear"

/datum/gear/gloves/color
	display_name = "gloves selection"
	path = /obj/item/clothing/gloves/black

/datum/gear/gloves/color/New()
	..()
	var/gloves = list()
	gloves["black gloves"] = /obj/item/clothing/gloves
	gloves["red gloves"] = /obj/item/clothing/gloves/red
	gloves["blue gloves"] = /obj/item/clothing/gloves/blue
	gloves["orange gloves"] = /obj/item/clothing/gloves/orange
	gloves["purple gloves"] = /obj/item/clothing/gloves/purple
	gloves["brown gloves"] = /obj/item/clothing/gloves/brown
	gloves["light-brown gloves"] = /obj/item/clothing/gloves/light_brown
	gloves["white gloves"] = /obj/item/clothing/gloves/green
	gloves["grey gloves"] = /obj/item/clothing/gloves/grey
	gloves["rainbow gloves"] = /obj/item/clothing/gloves/rainbow
	gear_tweaks += new/datum/gear_tweak/path(gloves)
