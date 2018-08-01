//unathi items

/datum/gear/suit/unathi_mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear"

/datum/gear/suit/unathi_robe
	display_name = "roughspun robe (Unathi)"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear"

/datum/gear/suit/robe_coat
	display_name = "tzirzi robe (Unathi)"
	path = /obj/item/clothing/suit/unathi/robe/robe_coat
	cost = 1
	whitelisted = list("Unathi")
	sort_category = "Xenowear"

/datum/gear/gloves/unathi
	display_name = "gloves selection (Unathi)"
	path = /obj/item/clothing/gloves/black/unathi
	whitelisted = list("Unathi")
	sort_category = "Xenowear"

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
	display_name = "sinta tunic (Unathi)"
	path = /obj/item/clothing/under/unathi
	whitelisted = list("Unathi")
	sort_category = "Xenowear"

/datum/gear/uniform/unathi/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

//skrell items

/datum/gear/ears/f_skrell
	display_name = "headtail-wear, female (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = list("Skrell")

/datum/gear/ears/f_skrell/New()
	..()
	var/f_chains = list()
	f_chains["headtail chains"] = /obj/item/clothing/ears/skrell/chain
	f_chains["headtail cloth"] = /obj/item/clothing/ears/skrell/cloth_female
	f_chains["red-jeweled chain"] = /obj/item/clothing/ears/skrell/redjewel_chain
	f_chains["ebony chain"] = /obj/item/clothing/ears/skrell/ebony_chain
	f_chains["blue-jeweled chain"] = /obj/item/clothing/ears/skrell/bluejeweled_chain
	f_chains["silver chain"] = /obj/item/clothing/ears/skrell/silver_chain
	f_chains["blue cloth"] = /obj/item/clothing/ears/skrell/blue_skrell_cloth_band_female
	gear_tweaks += new/datum/gear_tweak/path(f_chains)

/datum/gear/ears/m_skrell
	display_name = "headtail-wear, male (Skrell)"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear"
	whitelisted = list("Skrell")

/datum/gear/ears/m_skrell/New()
	..()
	var/m_chains = list()
	m_chains["headtail bands"] = /obj/item/clothing/ears/skrell/band
	m_chains["headtail cloth"] = /obj/item/clothing/ears/skrell/cloth_male
	m_chains["red-jeweled bands"] = /obj/item/clothing/ears/skrell/redjeweled_band
	m_chains["ebony bands"] = /obj/item/clothing/ears/skrell/ebony_band
	m_chains["blue-jeweled bands"] = /obj/item/clothing/ears/skrell/bluejeweled_band
	m_chains["silver bands"] = /obj/item/clothing/ears/skrell/silver_band
	m_chains["blue cloth"] = /obj/item/clothing/ears/skrell/blue_skrell_cloth_band_male
	m_chains["purple cloth"] = /obj/item/clothing/ears/skrell/purple_skrell_cloth_male
	gear_tweaks += new/datum/gear_tweak/path(m_chains)

//vaurca items

/datum/gear/eyes/blindfold
	display_name = "vaurca blindfold (Vaurca)"
	path = /obj/item/clothing/glasses/sunglasses/blinders
	cost = 2
	whitelisted = list("Vaurca Worker", "Vaurca Warrior")
	sort_category = "Xenowear"

/datum/gear/mask/vaurca
	display_name = "mandible garment (Vaurca)"
	path = /obj/item/clothing/mask/breath/vaurca
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior",)
	sort_category = "Xenowear"

/datum/gear/cape
	display_name = "tunnel cloak (Vaurca)"
	path = /obj/item/weapon/storage/backpack/cloak
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior",)
	sort_category = "Xenowear"

/datum/gear/vaurca_robe
	display_name = "hive cloak (Vaurca)"
	path = /obj/item/clothing/suit/vaurca
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior",)
	sort_category = "Xenowear"

/datum/gear/vaurca_robe/New()
	..()
	var/cloaks = list()
	cloaks["hive cloak, red and golden"] = /obj/item/clothing/suit/vaurca
	cloaks["hive cloak, red and silver"] = /obj/item/clothing/suit/vaurca/silver
	cloaks["hive cloak, brown and silver"] = /obj/item/clothing/suit/vaurca/brown
	cloaks["hive cloak, blue and golden"] = /obj/item/clothing/suit/vaurca/blue
	gear_tweaks += new/datum/gear_tweak/path(cloaks)

//tajara items

/datum/gear/gloves/tajara
	display_name = "gloves selection (Tajara)"
	path = /obj/item/clothing/gloves/black/tajara
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

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
	display_name = "tajara coat selection (Tajara)"
	path = /obj/item/clothing/suit/storage/tajaran
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

/datum/gear/suit/tajara_coat/New()
	..()
	var/coat = list()
	coat["tajaran naval coat"] = /obj/item/clothing/suit/storage/tajaran
	coat["commoner cloak"] = /obj/item/clothing/suit/storage/tajaran/cloak
	coat["royal cloak"] = /obj/item/clothing/suit/storage/tajaran/cloak/fancy
	coat["gruff cloak"] = /obj/item/clothing/suit/storage/hooded/tajaran
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/tajaran_labcoat
	display_name = "PRA medical coat (Tajara)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/tajaran
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	allowed_roles = list("Chief Medical Officer", "Medical Doctor", "Chemist", "Geneticist", "Paramedic", "Medical Resident")
	sort_category = "Xenowear"

/datum/gear/uniform/tajara
	display_name = "tajaran uniform selection (Tajara)"
	path = /obj/item/clothing/under/tajaran
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

/datum/gear/uniform/tajara/New()
	..()
	var/uniform = list()
	uniform["laborers clothes"] = /obj/item/clothing/under/tajaran
	uniform["fancy uniform"] = /obj/item/clothing/under/tajaran/fancy
	uniform["NanoTrasen overalls"] = /obj/item/clothing/under/tajaran/nt
	gear_tweaks += new/datum/gear_tweak/path(uniform)

/datum/gear/uniform/tajara_dress
	display_name = "tajaran dress selection (Tajara)"
	path = /obj/item/clothing/under/dress/tajaran
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

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
	display_name = "fur scarf (Tajara)"
	path = /obj/item/clothing/accessory/tajaran
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

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
	display_name = "dress circlet selection (Tajara)"
	path = /obj/item/clothing/head/tajaran/circlet
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

/datum/gear/head/tajara/New()
	..()
	var/circlet = list()
	circlet["golden dress circlet"] = /obj/item/clothing/head/tajaran/circlet
	circlet["silver dress circlet"] = /obj/item/clothing/head/tajaran/circlet/silver
	gear_tweaks += new/datum/gear_tweak/path(circlet)

/datum/gear/accessory/tajara_wrap
	display_name = "marriage wrap (Tajara)"
	path = /obj/item/clothing/accessory/tajaran_wrap
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

/datum/gear/accessory/tajara_wrap/New()
	..()
	var/wrap = list()
	wrap["marriage wrap, male"] = /obj/item/clothing/accessory/tajaran_wrap
	wrap["marriage wrap, female"] = /obj/item/clothing/accessory/tajaran_wrap/female
	gear_tweaks += new/datum/gear_tweak/path(wrap)

/datum/gear/accessory/tajara_pelt
	display_name = "ceremonial pelt (Tajara)"
	path = /obj/item/clothing/accessory/tajaran_pelt
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

//other things

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

/datum/gear/shoes/toeless
	display_name = "toe-less jackboots"
	path = /obj/item/clothing/shoes/jackboots/unathi
	sort_category = "Xenowear"
	whitelisted = list("Vaurca Worker", "Vaurca Warrior", "Unathi", "Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

/datum/gear/shoes/workboots_toeless
	display_name = "toeless workboots"
	path = /obj/item/clothing/shoes/workboots/toeless
	sort_category = "Xenowear"
	whitelisted = list("Vaurca Worker", "Vaurca Warrior", "Unathi", "Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
