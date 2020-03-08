/datum/gear/gloves
	display_name = "fingerless gloves"
	path = /obj/item/clothing/gloves/fingerless
	cost = 1
	slot = slot_gloves
	sort_category = "Gloves and Handwear"

/datum/gear/gloves/color
	display_name = "gloves selection"
	path = /obj/item/clothing/gloves/black

/datum/gear/gloves/color/New()
	..()
	var/gloves = list()
	gloves["black gloves"] = /obj/item/clothing/gloves/black
	gloves["red gloves"] = /obj/item/clothing/gloves/red
	gloves["blue gloves"] = /obj/item/clothing/gloves/blue
	gloves["orange gloves"] = /obj/item/clothing/gloves/orange
	gloves["purple gloves"] = /obj/item/clothing/gloves/purple
	gloves["brown gloves"] = /obj/item/clothing/gloves/brown
	gloves["light-brown gloves"] = /obj/item/clothing/gloves/light_brown
	gloves["white gloves"] = /obj/item/clothing/gloves/white
	gloves["green gloves"] = /obj/item/clothing/gloves/green
	gloves["grey gloves"] = /obj/item/clothing/gloves/grey
	gloves["rainbow gloves"] = /obj/item/clothing/gloves/rainbow
	gloves["black leather gloves"] = /obj/item/clothing/gloves/black_leather
	gloves["lyodsuit gloves"] = /obj/item/clothing/gloves/lyodsuit
	gear_tweaks += new/datum/gear_tweak/path(gloves)

/datum/gear/gloves/evening
	display_name = "evening gloves"
	path = /obj/item/clothing/gloves/evening

/datum/gear/gloves/evening/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/gloves/ring
	display_name = "ring selection"
	description = "A selection of rings."
	path = /obj/item/clothing/ring/engagement

/datum/gear/gloves/ring/New()
	..()
	var/ringtype = list()
	ringtype["engagement ring"] = /obj/item/clothing/ring/engagement
	ringtype["signet ring"] = /obj/item/clothing/ring/seal/signet
	ringtype["ring, steel"] = /obj/item/clothing/ring/material/steel
	ringtype["ring, iron"] = /obj/item/clothing/ring/material/iron
	ringtype["ring, bronze"] = /obj/item/clothing/ring/material/bronze
	ringtype["ring, silver"] = /obj/item/clothing/ring/material/silver
	ringtype["ring, gold"] = /obj/item/clothing/ring/material/gold
	ringtype["ring, platinum"] = /obj/item/clothing/ring/material/platinum
	ringtype["ring, glass"] = /obj/item/clothing/ring/material/glass
	ringtype["ring, wood"] = /obj/item/clothing/ring/material/wood
	ringtype["ring, plastic"] = /obj/item/clothing/ring/material/plastic
	gear_tweaks += new/datum/gear_tweak/path(ringtype)

/datum/gear/gloves/watch
	display_name = "watch selection"
	description = "A selection of watches."
	path = /obj/item/clothing/gloves/watch

/datum/gear/gloves/watch/New()
	..()
	var/watchtype = list()
	watchtype["watch"] = /obj/item/clothing/gloves/watch
	watchtype["silver watch"] = /obj/item/clothing/gloves/watch/silver
	watchtype["gold watch"] = /obj/item/clothing/gloves/watch/gold
	watchtype["spy watch"] = /obj/item/clothing/gloves/watch/spy
	watchtype["pocketwatch"] = /obj/item/pocketwatch
	gear_tweaks += new/datum/gear_tweak/path(watchtype)

/datum/gear/gloves/circuitry
	display_name = "gloves, circuitry (empty)"
	path = /obj/item/clothing/gloves/circuitry