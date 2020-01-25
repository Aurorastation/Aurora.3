/datum/gear/suit/unathi_mantle
	display_name = "hide mantle"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/suit/unathi_robe
	display_name = "roughspun robe"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/suit/robe_coat
	display_name = "tzirzi robe"
	path = /obj/item/clothing/suit/unathi/robe/robe_coat
	cost = 1
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/gloves/unathi
	display_name = "unathi gloves selection"
	description = "A selection of unathi colored gloves."
	path = /obj/item/clothing/gloves/black/unathi
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/gloves/unathi/New()
	..()
	var/un_gloves = list()
	un_gloves["black gloves"] = /obj/item/clothing/gloves/black/unathi
	un_gloves["red gloves"] = /obj/item/clothing/gloves/red/unathi
	un_gloves["blue gloves"] = /obj/item/clothing/gloves/blue/unathi
	un_gloves["orange gloves"] = /obj/item/clothing/gloves/orange/unathi
	un_gloves["purple gloves"] = /obj/item/clothing/gloves/purple/unathi
	un_gloves["brown gloves"] = /obj/item/clothing/gloves/brown/unathi
	un_gloves["green gloves"] = /obj/item/clothing/gloves/green/unathi
	un_gloves["white gloves"] = /obj/item/clothing/gloves/white/unathi
	gear_tweaks += new/datum/gear_tweak/path(un_gloves)

/datum/gear/uniform/unathi
	display_name = "sinta tunic"
	path = /obj/item/clothing/under/unathi
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/autakh_engineering
	display_name = "engineering grasper"
	description = "An Aut'akh augment limb, this one is outfitted with a limited toolkit."
	path = /obj/item/organ/external/hand/right/autakh/tool
	whitelisted = list("Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Station Engineer", "Chief Engineer", "Atmospheric Technician", "Engineering Apprentice", "Roboticist")

/datum/gear/autakh_mining
	display_name = "mining grasper"
	description = "An Aut'akh augment limb, this one is outfitted with a mining drill."
	path = /obj/item/organ/external/hand/right/autakh/tool/mining
	whitelisted = list("Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Shaft Miner")

/datum/gear/autakh_medical
	display_name = "medical grasper"
	description = "An Aut'akh augment limb, this one is outfitted with a health scanner."
	path = /obj/item/organ/external/hand/right/autakh/medical
	whitelisted = list("Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Paramedic", "Medical Resident", "Psychiatrist", "Chemist")

/datum/gear/autakh_security
	display_name = "security grasper"
	description = "An Aut'akh augment limb, this one is outfitted with an electroshock weapon."
	path = /obj/item/organ/external/hand/right/autakh/security
	whitelisted = list("Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Security Officer", "Head of Security", "Warden")

/datum/gear/uniform/unathi/jizixi
	display_name = "jizixi dress"
	path = /obj/item/clothing/under/unathi/jizixi
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/sashes
	display_name = "gyzao sashes"
	path = /obj/item/clothing/under/unathi/sashes
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/mogazali
	display_name = "mogazali attire"
	path = /obj/item/clothing/under/unathi/mogazali
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/zazali
	display_name = "zazali garb"
	path = /obj/item/clothing/under/unathi/zazali
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/huytai
	display_name = "huytai outfit"
	path = /obj/item/clothing/under/unathi/huytai
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/zozo
	display_name = "zozo top"
	path = /obj/item/clothing/under/unathi/zozo
	whitelisted = list("Unathi", "Aut'akh Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/suit/unathi/wrapping_head
	display_name = "thakh shaman head wrappings"
	description = "Head wrappings with a breath mask. Only very traditional Th'akh Shamans would wear these."
	path = /obj/item/clothing/mask/gas/wrapping
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/suit/unathi/wrapping_body
	display_name = "thakh shaman body wrappings"
	description = "Closed body wrappings. Only very traditional Th'akh Shamans would wear these."
	path = /obj/item/clothing/suit/unathi/mantle/wrapping
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"