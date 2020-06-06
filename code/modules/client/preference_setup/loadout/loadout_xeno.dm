/datum/gear/uniform/gearharness
	display_name = "gear harness"
	path = /obj/item/clothing/under/gearharness
	sort_category = "Xenowear"
	whitelisted = list("Vaurca Worker", "Vaurca Warrior", "Diona", "Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame")

/datum/gear/shoes/footwraps
	display_name = "cloth footwraps"
	path = /obj/item/clothing/shoes/footwraps
	sort_category = "Xenowear"
	whitelisted = list("Vaurca Worker", "Vaurca Warrior", "Unathi", "Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/toeless
	display_name = "toe-less jackboots"
	path = /obj/item/clothing/shoes/jackboots/toeless
	sort_category = "Xenowear"
	whitelisted = list("Vaurca Worker", "Vaurca Warrior", "Unathi", "Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

/datum/gear/shoes/workboots_toeless
	display_name = "toeless workboots selection"
	path = /obj/item/clothing/shoes/workboots/toeless
	sort_category = "Xenowear"
	whitelisted = list("Vaurca Worker", "Vaurca Warrior", "Unathi", "Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

/datum/gear/shoes/workboots_toeless/New()
	..()
	var/shoes = list()
	shoes["brown toeless workboots"] = /obj/item/clothing/shoes/workboots/toeless
	shoes["grey toeless workboots"] = /obj/item/clothing/shoes/workboots/toeless/grey
	shoes["dark toeless workboots"] = /obj/item/clothing/shoes/workboots/toeless/dark
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/caligae
	display_name = "caligae selection"
	path = /obj/item/clothing/shoes/caligae
	whitelisted = list("Unathi", "Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

/datum/gear/shoes/caligae/New()
	..()
	var/caligae = list()
	caligae["no sock"] = /obj/item/clothing/shoes/caligae
	caligae["black sock"] = /obj/item/clothing/shoes/caligae/black
	caligae["grey sock"] = /obj/item/clothing/shoes/caligae/grey
	caligae["white sock"] = /obj/item/clothing/shoes/caligae/white
	caligae["leather"] = /obj/item/clothing/shoes/caligae/armor
	gear_tweaks += new/datum/gear_tweak/path(caligae)
