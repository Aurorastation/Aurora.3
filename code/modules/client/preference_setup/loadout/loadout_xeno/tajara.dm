/datum/gear/gloves/tajara
	display_name = "gloves selection"
	path = /obj/item/clothing/gloves/black/tajara
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear - Tajara"

/datum/gear/gloves/tajara/New()
	..()
	var/taj_gloves = list()
	taj_gloves["black gloves"] = /obj/item/clothing/gloves/black/tajara
	taj_gloves["red gloves"] = /obj/item/clothing/gloves/red/tajara
	taj_gloves["blue gloves"] = /obj/item/clothing/gloves/blue/tajara
	taj_gloves["orange gloves"] = /obj/item/clothing/gloves/orange/tajara
	taj_gloves["purple gloves"] = /obj/item/clothing/gloves/purple/tajara
	taj_gloves["brown gloves"] = /obj/item/clothing/gloves/brown/tajara
	taj_gloves["green gloves"] = /obj/item/clothing/gloves/green/tajara
	taj_gloves["white gloves"] = /obj/item/clothing/gloves/white/tajara
	gear_tweaks += new/datum/gear_tweak/path(taj_gloves)

/datum/gear/suit/tajara_coat
	display_name = "tajara coat selection"
	path = /obj/item/clothing/suit/storage/tajaran
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear - Tajara"

/datum/gear/suit/tajara_coat/New()
	..()
	var/coat = list()
	coat["tajaran naval coat"] = /obj/item/clothing/suit/storage/tajaran
	coat["commoner cloak"] = /obj/item/clothing/suit/storage/tajaran/cloak
	coat["royal cloak"] = /obj/item/clothing/suit/storage/tajaran/cloak/fancy
	coat["gruff cloak"] = /obj/item/clothing/suit/storage/hooded/tajaran
	coat["adhomian wool coat"] = /obj/item/clothing/suit/storage/tajaran/nomad
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/tajara_priest
	display_name = "tajaran priest robe selection"
	path = /obj/item/clothing/suit/storage/hooded/tajaran/priest
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear - Tajara"

/datum/gear/suit/tajara_priest/New()
	..()
	var/robes = list()
	robes["sun priest robe"] = /obj/item/clothing/suit/storage/hooded/tajaran/priest
	robes["sun sister robe"] = /obj/item/clothing/suit/storage/tajaran/messa
	gear_tweaks += new/datum/gear_tweak/path(robes)

/datum/gear/suit/tajaran_labcoat
	display_name = "PRA medical coat)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/tajaran
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	allowed_roles = list("Chief Medical Officer", "Medical Doctor", "Chemist", "Geneticist", "Paramedic", "Medical Resident")
	sort_category = "Xenowear - Tajara"

/datum/gear/uniform/tajara
	display_name = "tajaran uniform selection"
	path = /obj/item/clothing/under/tajaran
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear - Tajara"

/datum/gear/uniform/tajara/New()
	..()
	var/uniform = list()
	uniform["laborers clothes"] = /obj/item/clothing/under/tajaran
	uniform["fancy uniform"] = /obj/item/clothing/under/tajaran/fancy
	uniform["NanoTrasen overalls"] = /obj/item/clothing/under/tajaran/nt
	gear_tweaks += new/datum/gear_tweak/path(uniform)

/datum/gear/uniform/tajara_dress
	display_name = "tajaran dress selection"
	path = /obj/item/clothing/under/dress/tajaran
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear - Tajara"

/datum/gear/uniform/tajara_dress/New()
	..()
	var/dress = list()
	dress["white fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran
	dress["blue fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran/blue
	dress["green fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran/green
	dress["red fancy adhomian dress"] = /obj/item/clothing/under/dress/tajaran/red
	dress["red noble adhomian dress"] = /obj/item/clothing/under/dress/tajaran/fancy
	dress["black noble adhomian dress"] = /obj/item/clothing/under/dress/tajaran/fancy/black
	gear_tweaks += new/datum/gear_tweak/path(dress)

/datum/gear/accessory/tajara
	display_name = "fur scarf"
	path = /obj/item/clothing/accessory/tajaran
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear - Tajara"

/datum/gear/accessory/tajara/New()
	..()
	var/scarf = list()
	scarf["brown fur scarf"] = /obj/item/clothing/accessory/tajaran
	scarf["light brown fur scarf"] = /obj/item/clothing/accessory/tajaran/lbrown
	scarf["cinnamon fur scarf"] = /obj/item/clothing/accessory/tajaran/cinnamon
	scarf["blue fur scarf"] = /obj/item/clothing/accessory/tajaran/blue
	scarf["silver fur scarf"] = /obj/item/clothing/accessory/tajaran/silver
	scarf["black fur scarf"] = /obj/item/clothing/accessory/tajaran/black
	scarf["ruddy fur scarf"] = /obj/item/clothing/accessory/tajaran/ruddy
	scarf["orange fur scarf"] = /obj/item/clothing/accessory/tajaran/orange
	scarf["cream fur scarf"] = /obj/item/clothing/accessory/tajaran/cream
	gear_tweaks += new/datum/gear_tweak/path(scarf)

/datum/gear/head/tajara
	display_name = "adhomian headgear selection"
	path = /obj/item/clothing/head/tajaran/circlet
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear - Tajara"

/datum/gear/head/tajara/New()
	..()
	var/circlet = list()
	circlet["golden dress circlet"] = /obj/item/clothing/head/tajaran/circlet
	circlet["silver dress circlet"] = /obj/item/clothing/head/tajaran/circlet/silver
	circlet["fur hat"] = /obj/item/clothing/head/tajaran/fur
	gear_tweaks += new/datum/gear_tweak/path(circlet)

/datum/gear/accessory/tajara_wrap
	display_name = "marriage wrap"
	path = /obj/item/clothing/accessory/tajaran_wrap
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear - Tajara"

/datum/gear/accessory/tajara_wrap/New()
	..()
	var/wrap = list()
	wrap["marriage wrap, male"] = /obj/item/clothing/accessory/tajaran_wrap
	wrap["marriage wrap, female"] = /obj/item/clothing/accessory/tajaran_wrap/female
	gear_tweaks += new/datum/gear_tweak/path(wrap)

/datum/gear/accessory/tajara_pelt
	display_name = "ceremonial pelt"
	path = /obj/item/clothing/accessory/tajaran_pelt
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear - Tajara"

/datum/gear/mask/tajara
	display_name = "sun sister veil"
	path = /obj/item/clothing/mask/tajara
	cost = 1
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear - Tajara"

/datum/gear/shoes/tajara
	display_name = "native tajaran foot-wear"
	path = /obj/item/clothing/shoes/tajara
	sort_category = "Xenowear - Tajara"
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
