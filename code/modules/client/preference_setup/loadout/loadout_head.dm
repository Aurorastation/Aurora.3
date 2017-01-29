/datum/gear/head
	display_name = "hat, boatsman"
	path = /obj/item/clothing/head/boaterhat
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/bandana
	display_name = "bandana selection"
	path = /obj/item/clothing/head/bandana

/datum/gear/head/bandana/New()
	..()
	var/bandanas = list()
	bandanas["green bandana"] = /obj/item/clothing/head/greenbandana
	bandanas["orange bandana"] = /obj/item/clothing/head/orangebandana
	bandanas["pirate bandana"] = /obj/item/clothing/head/bandana
	gear_tweaks += new/datum/gear_tweak/path(bandanas)

/datum/gear/head/cap
	display_name = "cap selection"
	path = /obj/item/clothing/head/soft/blue

/datum/gear/head/cap/New()
	..()
	var/caps = list()
	caps["blue cap"] = /obj/item/clothing/head/soft/blue
	caps["flat cap"] = /obj/item/clothing/head/flatcap
	caps["green cap"] = /obj/item/clothing/head/soft/green
	caps["grey cap"] = /obj/item/clothing/head/soft/grey
	caps["mailman cap"] = /obj/item/clothing/head/mailman
	caps["orange cap"] = /obj/item/clothing/head/soft/orange
	caps["purple cap"] = /obj/item/clothing/head/soft/purple
	caps["rainbow cap"] = /obj/item/clothing/head/soft/rainbow
	caps["red cap"] = /obj/item/clothing/head/soft/red
	caps["white cap"] = /obj/item/clothing/head/soft/mime
	caps["yellow cap"] = /obj/item/clothing/head/soft/yellow
	gear_tweaks += new/datum/gear_tweak/path(caps)

/datum/gear/head/beret
	display_name = "beret, red"
	path = /obj/item/clothing/head/beret

/datum/gear/head/beret/eng
	display_name = "beret, engie-orange"
	path = /obj/item/clothing/head/beret/engineering
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice")

/datum/gear/head/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/head/beret/sec
	display_name = "beret,security"
	path = /obj/item/clothing/head/beret/sec
	allowed_roles = list("Security Officer","Head of Security","Warden","Security Cadet","Detective")

/datum/gear/head/beret/warden
	display_name = "beret,security (warden)"
	path = /obj/item/clothing/head/beret/sec/warden
	allowed_roles = list("Head of Security","Warden")

/datum/gear/head/beret/hos
	display_name = "beret,security (head of security)"
	path = /obj/item/clothing/head/beret/sec/hos
	allowed_roles = list("Head of Security")

/datum/gear/head/cap/corp
	display_name = "cap, corporate (security)"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = list("Security Officer","Head of Security","Warden","Security Cadet","Detective")

/datum/gear/head/cap/sec
	display_name = "cap, security"
	path = /obj/item/clothing/head/soft/sec
	allowed_roles = list("Security Officer","Head of Security","Warden","Security Cadet","Detective")

/datum/gear/head/hardhat
	display_name = "hardhat, yellow"
	path = /obj/item/clothing/head/hardhat
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice")

/datum/gear/head/hardhat/New()
	..()
	var/hardhat = list()
	hardhat["hardhat, yellow"] = /obj/item/clothing/head/hardhat
	hardhat["hardhat, blue"] = /obj/item/clothing/head/hardhat/dblue
	hardhat["hardhat, orange"] = /obj/item/clothing/head/hardhat/orange
	hardhat["hardhat, red"] = /obj/item/clothing/head/hardhat/red
	gear_tweaks += new/datum/gear_tweak/path(hardhat)

/datum/gear/head/hairflower
	display_name = "hair flower pin, red"
	path = /obj/item/clothing/head/hairflower

/datum/gear/head/bowler
	display_name = "hat, bowler"
	path = /obj/item/clothing/head/bowler

/datum/gear/head/fez
	display_name = "hat, fez"
	path = /obj/item/clothing/head/fez

/datum/gear/head/tophat
	display_name = "hat, tophat"
	path = /obj/item/clothing/head/that

/datum/gear/head/philosopher_wig
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig

/datum/gear/head/ushanka
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka
