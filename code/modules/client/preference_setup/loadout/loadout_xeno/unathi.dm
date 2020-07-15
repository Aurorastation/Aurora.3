/datum/gear/suit/unathi_mantle
	display_name = "hide mantle"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/suit/unathi_robe
	display_name = "roughspun robe"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/suit/robe_coat
	display_name = "tzirzi robe"
	path = /obj/item/clothing/suit/unathi/robe/robe_coat
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/gloves/unathi
	display_name = "unathi gloves selection"
	description = "A selection of unathi colored gloves."
	path = /obj/item/clothing/gloves/black/unathi
	whitelisted = list("Unathi")
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
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/augment/autakh_engineering
	display_name = "engineering grasper"
	description = "An Aut'akh augment limb, this one is outfitted with a limited toolkit."
	path = /obj/item/organ/external/hand/right/autakh/tool
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Station Engineer", "Chief Engineer", "Atmospheric Technician", "Engineering Apprentice", "Roboticist")
	flags = GEAR_NO_SELECTION

/datum/gear/augment/autakh_mining
	display_name = "mining grasper"
	description = "An Aut'akh augment limb, this one is outfitted with a mining drill."
	path = /obj/item/organ/external/hand/right/autakh/tool/mining
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Shaft Miner")
	flags = GEAR_NO_SELECTION

/datum/gear/augment/autakh_medical
	display_name = "medical grasper"
	description = "An Aut'akh augment limb, this one is outfitted with a health scanner."
	path = /obj/item/organ/external/hand/right/autakh/medical
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Emergency Medical Technician", "Medical Resident", "Psychiatrist", "Chemist")
	flags = GEAR_NO_SELECTION

/datum/gear/augment/autakh_security
	display_name = "security grasper"
	description = "An Aut'akh augment limb, this one is outfitted with an electroshock weapon."
	path = /obj/item/organ/external/hand/right/autakh/security
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Security Officer", "Head of Security", "Warden")
	flags = GEAR_NO_SELECTION

/datum/gear/uniform/unathi/jizixi
	display_name = "jizixi dress"
	path = /obj/item/clothing/under/unathi/jizixi
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/sashes
	display_name = "gyzao sashes"
	path = /obj/item/clothing/under/unathi/sashes
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/mogazali
	display_name = "mogazali attire"
	path = /obj/item/clothing/under/unathi/mogazali
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/zazali
	display_name = "zazali garb"
	path = /obj/item/clothing/under/unathi/zazali
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/huytai
	display_name = "huytai outfit"
	path = /obj/item/clothing/under/unathi/huytai
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/zozo
	display_name = "zozo top"
	path = /obj/item/clothing/under/unathi/zozo
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/suit/unathi/wrapping_head
	display_name = "thakh shaman head wrappings"
	description = "Head wrappings with a breath mask. Only very traditional Th'akh Shamans would wear these."
	path = /obj/item/clothing/mask/gas/wrapping
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/unathi/wrapping_body
	display_name = "thakh shaman body wrappings"
	description = "Closed body wrappings. Only very traditional Th'akh Shamans would wear these."
	path = /obj/item/clothing/suit/unathi/mantle/wrapping
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/augment/autakh
	display_name = "soul anchor"
	description = "A rune inscribed mirror or piece of glass placed behind the eyes. Believed to be the 'Window to the Soul' and house the concentrated spirit of an individual."
	path = /obj/item/organ/internal/anchor
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear - Unathi"

/datum/gear/augment/autakh/calf_override
	display_name = "calf overdrive"
	description = "An Aut'akh augment that allows the user to run at high speeds without the cost of stamina, causes damage to the lower body when used."
	path = /obj/item/organ/internal/augment/calf_override

/datum/gear/augment/autakh/protein_valve
	display_name = "protein breakdown valve"
	description = "An aut'akh valve on the chest that releases a dangerous chemical into the stomach, forcing rapid digestion for immediate adrenal stimulation. Causes long-term damage."
	path = /obj/item/organ/internal/augment/protein_valve

/datum/gear/augment/autakh/venomous_rest
	display_name = "venomous rest implant"
	description = "An aut'akh compartment connected to the blood system that administers a traditional Unathi healing agent."
	path = /obj/item/organ/internal/augment/venomous_rest

/datum/gear/augment/autakh/eyes
	display_name = "eye augment selection"
	description = "A selection of au'takh eye augments."
	path = /obj/item/organ/internal/augment/farseer_eye

/datum/gear/augment/autakh/eyes/New()
	..()
	var/augs = list()
	augs["farseer eye"] = /obj/item/organ/internal/augment/farseer_eye
	augs["eye flashlight"] = /obj/item/organ/internal/augment/eye_flashlight
	gear_tweaks += new /datum/gear_tweak/path(augs)