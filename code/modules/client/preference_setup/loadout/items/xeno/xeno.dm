/datum/gear/uniform/gearharness
	display_name = "gear harness"
	path = /obj/item/clothing/under/gearharness
	sort_category = "Xenowear"

	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_DIONA, SPECIES_DIONA_COEUS, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP)

/datum/gear/shoes/footwraps
	display_name = "cloth footwraps"
	path = /obj/item/clothing/shoes/footwraps
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_UNATHI, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/toeless
	display_name = "toe-less jackboots"
	path = /obj/item/clothing/shoes/jackboots/toeless
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_UNATHI, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)

/datum/gear/shoes/caligae
	display_name = "caligae selection"
	path = /obj/item/clothing/shoes/caligae
	whitelisted = list(SPECIES_UNATHI, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear"

/datum/gear/shoes/caligae/New()
	..()
	var/list/caligae = list()
	caligae["no sock"] = /obj/item/clothing/shoes/caligae
	caligae["black sock"] = /obj/item/clothing/shoes/caligae/black
	caligae["grey sock"] = /obj/item/clothing/shoes/caligae/grey
	caligae["white sock"] = /obj/item/clothing/shoes/caligae/white
	caligae["leather"] = /obj/item/clothing/shoes/caligae/armor
	gear_tweaks += new /datum/gear_tweak/path(caligae)

/datum/gear/shoes/toeless
	display_name = "toeless boot selection"
	path = /obj/item/clothing/shoes/jackboots/toeless
	whitelisted = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_UNATHI, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	sort_category = "Xenowear"

/datum/gear/shoes/toeless/New()
	..()
	var/list/shoes = list()
	shoes["brown toeless workboots"] = /obj/item/clothing/shoes/workboots/toeless
	shoes["grey toeless workboots"] = /obj/item/clothing/shoes/workboots/toeless/grey
	shoes["dark toeless workboots"] = /obj/item/clothing/shoes/workboots/toeless/dark
	shoes["toeless black boots, short"] = /obj/item/clothing/shoes/jackboots/toeless
	shoes["toeless black boots, knee"] = /obj/item/clothing/shoes/jackboots/toeless/knee
	shoes["toeless black boots, thigh"] = /obj/item/clothing/shoes/jackboots/toeless/thigh
	shoes["toeless winterboots"] = /obj/item/clothing/shoes/winter/toeless
	gear_tweaks += new /datum/gear_tweak/path(shoes)
