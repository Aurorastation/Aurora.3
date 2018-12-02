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

//skrell

/datum/gear/ears/skrell/chains	//Chains
	display_name = "headtail chain selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = list("Skrell")

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(chaintypes))

/datum/gear/ears/skrell/bands
	display_name = "headtail band selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear"
	whitelisted = list("Skrell")

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandtypes))

/datum/gear/ears/skrell/cloth/short
	display_name = "short headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_short/black
	sort_category = "Xenowear"
	whitelisted = list("Skrell")

/datum/gear/ears/skrell/cloth/short/New()
	..()
	var/list/shorttypes = list()
	for(var/short_style in typesof(/obj/item/clothing/ears/skrell/cloth_short))
		var/obj/item/clothing/ears/skrell/cloth_short/short = short_style
		shorttypes[initial(short.name)] = short
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorttypes))

/datum/gear/ears/skrell/cloth/average
	display_name = "average headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_average/black
	sort_category = "Xenowear"
	whitelisted = list("Skrell")

/datum/gear/ears/skrell/cloth/average/New()
	..()
	var/list/averagetypes = list()
	for(var/average_style in typesof(/obj/item/clothing/ears/skrell/cloth_average))
		var/obj/item/clothing/ears/skrell/cloth_average/average = average_style
		averagetypes[initial(average.name)] = average
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(averagetypes))

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

/datum/gear/mask/vaurca_expression
	display_name = "human expression mask (Vaurca)"
	path = /obj/item/clothing/mask/breath/vaurca/expression
	cost = 1
	whitelisted = list("Vaurca Worker", "Vaurca Warrior",)
	sort_category = "Xenowear"

/datum/gear/mask/vaurca_expression/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/mask/vaurca_expression/skrell
	display_name = "skrell expression mask (Vaurca)"
	path = /obj/item/clothing/mask/breath/vaurca/expression/skrell

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
	coat["adhomian wool coat"] = /obj/item/clothing/suit/storage/tajaran/nomad
	gear_tweaks += new/datum/gear_tweak/path(coat)

/datum/gear/suit/tajara_priest
	display_name = "tajara priest robe selection (Tajara)"
	path = /obj/item/clothing/suit/storage/hooded/tajaran/priest
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

/datum/gear/suit/tajara_priest/New()
	..()
	var/robes = list()
	robes["sun priest robe"] = /obj/item/clothing/suit/storage/hooded/tajaran/priest
	robes["sun sister robe"] = /obj/item/clothing/suit/storage/tajaran/messa
	gear_tweaks += new/datum/gear_tweak/path(robes)

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
	display_name = "adhomian headgear selection (Tajara)"
	path = /obj/item/clothing/head/tajaran/circlet
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

/datum/gear/head/tajara/New()
	..()
	var/circlet = list()
	circlet["golden dress circlet"] = /obj/item/clothing/head/tajaran/circlet
	circlet["silver dress circlet"] = /obj/item/clothing/head/tajaran/circlet/silver
	circlet["fur hat"] = /obj/item/clothing/head/tajaran/fur
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

/datum/gear/mask/tajara
	display_name = "sun sister veil (Tajara)"
	path = /obj/item/clothing/mask/tajara
	cost = 1
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")
	sort_category = "Xenowear"

/datum/gear/shoes/tajara
	display_name = "native tajaran foot-wear"
	path = /obj/item/clothing/shoes/tajara
	sort_category = "Xenowear"
	whitelisted = list("Tajara", "Zhan-Khazan Tajara", "M'sai Tajara")

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

/datum/gear/head/goldenchains
	display_name = "golden deep headchains (Machine)"
	path = /obj/item/clothing/head/headchain
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear"

/datum/gear/head/goldenchains/New()
	..()
	var/headchains = list()
	headchains["head chains, cobalt"] = /obj/item/clothing/head/headchain
	headchains["head chains, emerald"] = /obj/item/clothing/head/headchain/emerald
	headchains["head chains, ruby"] = /obj/item/clothing/head/headchain/ruby
	gear_tweaks += new/datum/gear_tweak/path(headchains)

/datum/gear/head/goldencrests
	display_name = "golden deep crests (Machine)"
	path = /obj/item/clothing/head/crest
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear"

/datum/gear/head/goldencrests/New()
	..()
	var/crest = list()
	crest["crest, cobalt"] = /obj/item/clothing/head/crest
	crest["crest, emerald"] = /obj/item/clothing/head/crest/emerald
	crest["crest, ruby"] = /obj/item/clothing/head/crest/ruby
	gear_tweaks += new/datum/gear_tweak/path(crest)

/datum/gear/gloves/armchains
	display_name = "golden deep armchains (Machine)"
	path = /obj/item/clothing/gloves/armchain
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear"

/datum/gear/gloves/armchains/New()
	..()
	var/armchains = list()
	armchains["arm chains, cobalt"] = /obj/item/clothing/gloves/armchain
	armchains["arm chains, emerald"] = /obj/item/clothing/gloves/armchain/emerald
	armchains["arm chains, ruby"] = /obj/item/clothing/gloves/armchain/ruby
	gear_tweaks += new/datum/gear_tweak/path(armchains)

/datum/gear/gloves/bracers
	display_name = "golden deep bracers (Machine)"
	path = /obj/item/clothing/gloves/goldbracer
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear"

/datum/gear/gloves/bracers/New()
	..()
	var/bracers = list()
	bracers["arm chains, cobalt"] = /obj/item/clothing/gloves/goldbracer
	bracers["arm chains, emerald"] = /obj/item/clothing/gloves/goldbracer/emerald
	bracers["arm chains, ruby"] = /obj/item/clothing/gloves/goldbracer/ruby
	gear_tweaks += new/datum/gear_tweak/path(bracers)

/datum/gear/under/goldtron
	display_name = "golden deep jumpsuit"
	path = /obj/item/clothing/under/golden_suit
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear"

/datum/gear/shoes/goldtron_shoes
	display_name = "golden deep boots"
	path = /obj/item/clothing/shoes/golden_shoes
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear"

/datum/gear/ears/antennae
	display_name = "antennae (Machine)"
	path = /obj/item/clothing/head/antenna
	cost = 1
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear"

/datum/gear/ears/antennae/New()
	..()
	var/antenna = list()
	antenna["antenna, curved"] = /obj/item/clothing/head/antenna
	antenna["antenna, straight"] = /obj/item/clothing/head/antenna/straight
	antenna["antenna, spiked"] = /obj/item/clothing/head/antenna/spiked
	antenna["antenna, side"] = /obj/item/clothing/head/antenna/side
	antenna["antenna, dish"] = /obj/item/clothing/head/antenna/dish
	gear_tweaks += new/datum/gear_tweak/path(antenna)

/datum/gear/ears/headlights
	display_name = "headlights (Machine_"
	path = /obj/item/device/flashlight/headlights
	cost = 2
	whitelisted = list("Baseline Frame", "Hephaestus G1 Industrial Frame", "Hephaestus G2 Industrial Frame", "Xion Industrial Frame", "Zeng-Hu Mobility Frame", "Bishop Accessory Frame", "Shell Frame")
	sort_category = "Xenowear"