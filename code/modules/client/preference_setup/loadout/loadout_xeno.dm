/datum/gear/uniform/gearharness
	display_name = "gear harness"
	path = /obj/item/clothing/under/gearharness
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_DIONA, SPECIES_IPC, SPECIES_HEPHAESTUS_G1_IPC, SPECIES_HEPHAESTUS_G2_IPC, SPECIES_XION_IPC, SPECIES_ZENGHU_IPC, SPECIES_BISHOP_IPC)

/datum/gear/shoes/footwraps
	display_name = "cloth footwraps"
	path = /obj/item/clothing/shoes/footwraps
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_UNATHI, SPECIES_AUTAKH_UNATHI, SPECIES_TAJARA, SPECIES_ZHAN_KHAZAN_TAJARA
, SPECIES_MSAI_TJARA)

/datum/gear/shoes/footwraps/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/toeless
	display_name = "toe-less jackboots"
	path = /obj/item/clothing/shoes/jackboots/toeless
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_UNATHI, SPECIES_AUTAKH_UNATHI, SPECIES_TAJARA, SPECIES_ZHAN_KHAZAN_TAJARA
, SPECIES_MSAI_TJARA)

/datum/gear/shoes/workboots_toeless
	display_name = "toeless workboots selection"
	path = /obj/item/clothing/shoes/workboots/toeless
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_UNATHI, SPECIES_AUTAKH_UNATHI, SPECIES_TAJARA, SPECIES_ZHAN_KHAZAN_TAJARA
, SPECIES_MSAI_TJARA)

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
	whitelisted = list(SPECIES_UNATHI, SPECIES_AUTAKH_UNATHI, SPECIES_TAJARA, SPECIES_ZHAN_KHAZAN_TAJARA
, SPECIES_MSAI_TJARA)
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
