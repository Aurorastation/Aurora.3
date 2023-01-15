/datum/gear/suit/unathi_mantle
	display_name = "peasant hide mantle selection"
	description = "A selection of hide mantles, one for each of the desert, and mountainous \
	regions of Moghes. The forest mantle is exclusively for nobility these days."
	path = /obj/item/clothing/accessory/poncho/unathimantle
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/unathi_mantle/New()
	..()
	var/list/mantles = list()
	mantles["hide mantle, desert"] = /obj/item/clothing/accessory/poncho/unathimantle
	mantles["hide mantle, mountain"] = /obj/item/clothing/accessory/poncho/unathimantle/mountain
	gear_tweaks += new /datum/gear_tweak/path(mantles)

/datum/gear/suit/unathi_mantle_noble
	display_name = "forest mantle"
	description = "A forest hide mantle, reserved exclusively for nobility."
	path = /obj/item/clothing/accessory/poncho/unathimantle/forest
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	origin_restriction = list(/singleton/origin_item/origin/izweski_upper, /singleton/origin_item/origin/trad_nobles)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/unathi_robe
	display_name = "roughspun robe"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/unathi_robe/kilt
	display_name = "wasteland kilt"
	origin_restriction = list(/singleton/origin_item/origin/wastelander)
	path = /obj/item/clothing/suit/unathi/robe/kilt

/datum/gear/suit/robe_coat
	display_name = "tzirzi robe"
	path = /obj/item/clothing/suit/unathi/robe/robe_coat
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"

/datum/gear/gloves/unathi
	display_name = "unathi gloves selection"
	description = "A selection of unathi colored gloves."
	path = /obj/item/clothing/gloves/black/unathi
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"

/datum/gear/gloves/unathi/New()
	..()
	var/list/un_gloves = list()
	un_gloves["black gloves"] = /obj/item/clothing/gloves/black/unathi
	un_gloves["red gloves"] = /obj/item/clothing/gloves/red/unathi
	un_gloves["blue gloves"] = /obj/item/clothing/gloves/blue/unathi
	un_gloves["orange gloves"] = /obj/item/clothing/gloves/orange/unathi
	un_gloves["purple gloves"] = /obj/item/clothing/gloves/purple/unathi
	un_gloves["brown gloves"] = /obj/item/clothing/gloves/brown/unathi
	un_gloves["light brown gloves"] = /obj/item/clothing/gloves/light_brown/unathi
	un_gloves["green gloves"] = /obj/item/clothing/gloves/green/unathi
	un_gloves["grey gloves"] = /obj/item/clothing/gloves/grey/unathi
	un_gloves["white gloves"] = /obj/item/clothing/gloves/white/unathi
	un_gloves["rainbow gloves"] = /obj/item/clothing/gloves/rainbow/unathi
	un_gloves["black leather gloves"] = /obj/item/clothing/gloves/black_leather/unathi
	gear_tweaks += new /datum/gear_tweak/path(un_gloves)

/datum/gear/gloves/unathi_handwraps
	display_name = "cloth handwraps"
	path = /obj/item/clothing/gloves/unathi
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/unathi
	display_name = "sinta tunic"
	path = /obj/item/clothing/under/unathi
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/unathi/himation
	display_name = "himation cloak"
	path = /obj/item/clothing/under/unathi/himation
	cost = 1
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ADDITIONAL_COLOR_SELECTION

/datum/gear/head/sinta_ronin
	display_name = "straw hat"
	path = /obj/item/clothing/head/unathi
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"

/datum/gear/eyes/wasteland_goggles
	display_name = "wasteland goggles"
	path = /obj/item/clothing/glasses/safety/goggles/wasteland
	whitelisted = list(SPECIES_UNATHI)
	origin_restriction = list(/singleton/origin_item/origin/wastelander)
	sort_category = "Xenowear - Unathi"

/datum/gear/accessory/sinta_hood
	display_name = "clan hood"
	slot = slot_head
	path = /obj/item/clothing/accessory/sinta_hood
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/augment/autakh_engineering
	display_name = "engineering grasper"
	description = "An Aut'akh augment limb, this one is outfitted with a limited toolkit."
	path = /obj/item/organ/external/hand/right/autakh/tool
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Engineer", "Chief Engineer", "Atmospheric Technician", "Engineering Apprentice", "Machinist")
	flags = GEAR_NO_SELECTION

/datum/gear/augment/autakh_mining
	display_name = "mining grasper"
	description = "An Aut'akh augment limb, this one is outfitted with a mining drill."
	path = /obj/item/organ/external/hand/right/autakh/tool/mining
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Shaft Miner")
	flags = GEAR_NO_SELECTION

/datum/gear/augment/autakh_medical
	display_name = "medical grasper"
	description = "An Aut'akh augment limb, this one is outfitted with a health scanner."
	path = /obj/item/organ/external/hand/right/autakh/medical
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "First Responder", "Medical Intern", "Psychiatrist", "Chemist")
	flags = GEAR_NO_SELECTION

/datum/gear/augment/autakh_security
	display_name = "security grasper"
	description = "An Aut'akh augment limb, this one is outfitted with an electroshock weapon."
	path = /obj/item/organ/external/hand/right/autakh/security
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	cost = 3
	allowed_roles = list("Security Officer", "Head of Security", "Warden")
	flags = GEAR_NO_SELECTION

/datum/gear/uniform/unathi/jizixi
	display_name = "jizixi dress"
	path = /obj/item/clothing/under/unathi/jizixi
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/sashes
	display_name = "gyzao sashes"
	path = /obj/item/clothing/under/unathi/sashes
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/mogazali
	display_name = "mogazali attire"
	path = /obj/item/clothing/under/unathi/mogazali
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/uniform/unathi/zazali
	display_name = "zazali garb"
	path = /obj/item/clothing/under/unathi/zazali
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ADDITIONAL_COLOR_SELECTION

/datum/gear/uniform/unathi/huytai
	display_name = "huytai outfit"
	path = /obj/item/clothing/under/unathi/huytai
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"

/datum/gear/uniform/unathi/zozo
	display_name = "zozo top"
	path = /obj/item/clothing/under/unathi/zozo
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"

/datum/gear/suit/unathi/wrapping_head
	display_name = "Thakhist head wrappings"
	path = /obj/item/clothing/mask/gas/unathi
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	allowed_roles = list("Chaplain", "Machinist")
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/unathi/wrapping_body
	display_name = "Thakhist body wrappings"
	path = /obj/item/clothing/suit/unathi/wrapping
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	allowed_roles = list("Chaplain", "Machinist")
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/augment/autakh
	display_name = "soul anchor"
	description = "A rune inscribed mirror or piece of glass placed behind the eyes. Believed to \
	be the 'Window to the Soul' and house the concentrated spirit of an individual."
	path = /obj/item/organ/internal/anchor
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"

/datum/gear/augment/autakh/calf_override
	display_name = "calf overdrive"
	description = "An Aut'akh augment that allows the user to run at high speeds without the cost \
	of stamina, causes damage to the lower body when used."
	path = /obj/item/organ/internal/augment/calf_override

/datum/gear/augment/autakh/protein_valve
	display_name = "protein breakdown valve"
	description = "An aut'akh valve on the chest that releases a dangerous chemical into the \
	stomach, forcing rapid digestion for immediate adrenal stimulation. Causes long-term damage."
	path = /obj/item/organ/internal/augment/protein_valve

/datum/gear/augment/autakh/venomous_rest
	display_name = "venomous rest implant"
	description = "An aut'akh compartment connected to the blood system that administers a \
	traditional Unathi healing agent."
	path = /obj/item/organ/internal/augment/venomous_rest

/datum/gear/augment/autakh/eyes
	display_name = "eye augment selection"
	description = "A selection of au'takh eye augments."
	path = /obj/item/organ/internal/augment/farseer_eye

/datum/gear/augment/autakh/eyes/New()
	..()
	var/list/augs = list()
	augs["farseer eye"] = /obj/item/organ/internal/augment/farseer_eye
	augs["eye flashlight"] = /obj/item/organ/internal/augment/eye_flashlight
	gear_tweaks += new /datum/gear_tweak/path(augs)

/datum/gear/religion/shaman_staff
	display_name = "shaman staff"
	path = /obj/item/cane/shaman
	sort_category = "Xenowear - Unathi"
	origin_restriction = list(/singleton/origin_item/origin/izweski_upper, /singleton/origin_item/origin/trad_nobles)
	whitelisted = list(SPECIES_UNATHI)

/datum/gear/suit/maxtlatl
	display_name = "Thakhist maxtlatl"
	path = /obj/item/clothing/accessory/poncho/maxtlatl
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	allowed_roles = list("Chaplain")
	origin_restriction = list(/singleton/origin_item/origin/izweski_upper, /singleton/origin_item/origin/trad_nobles)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/wrists/maxtlatl
	display_name = "Thakhist wristguards"
	path = /obj/item/clothing/wrists/unathi/maxtlatl
	whitelisted = list(SPECIES_UNATHI)
	origin_restriction = list(/singleton/origin_item/origin/izweski_upper, /singleton/origin_item/origin/trad_nobles)
	allowed_roles = list("Chaplain")
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/head/maxtlatl
	display_name = "Thakhist headgear"
	path = /obj/item/clothing/head/unathi/maxtlatl
	whitelisted = list(SPECIES_UNATHI)
	origin_restriction = list(/singleton/origin_item/origin/izweski_upper, /singleton/origin_item/origin/trad_nobles)
	allowed_roles = list("Chaplain")
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/suit/rockstone
	display_name = "rockstone cape"
	path = /obj/item/clothing/accessory/poncho/rockstone
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	origin_restriction = list(/singleton/origin_item/origin/izweski_upper, /singleton/origin_item/origin/trad_nobles)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ADDITIONAL_COLOR_SELECTION

/datum/gear/wrists/noble_bracers
	display_name = "jeweled bracers"
	path = /obj/item/clothing/wrists/unathi/jeweled
	whitelisted = list(SPECIES_UNATHI)
	origin_restriction = list(/singleton/origin_item/origin/izweski_upper, /singleton/origin_item/origin/trad_nobles)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/sash
	display_name = "gyazo belt"
	path = /obj/item/clothing/accessory/unathi
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/noble_vest
	display_name = "jokfar vest"
	path = /obj/item/clothing/suit/unathi/jokfar
	cost = 1
	whitelisted = list(SPECIES_UNATHI)
	origin_restriction = list(/singleton/origin_item/origin/izweski_upper, /singleton/origin_item/origin/trad_nobles)
	sort_category = "Xenowear - Unathi"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
