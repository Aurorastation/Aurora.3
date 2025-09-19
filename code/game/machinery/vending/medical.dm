/**
 *	NanoMed Plus
 *		Low Supply
 *	NanoMed
 *		Low Supply
 *	NanoMed Mini
 *		Low Supply
 *	NanoPharm Mini
 *		Low Supply
 */

/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_vend = "med-vend"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(ACCESS_MEDICAL_EQUIP)
	vend_id = "meds"
	products = list(
		/obj/item/reagent_containers/glass/bottle/antitoxin = 4,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 4,
		/obj/item/reagent_containers/glass/bottle/perconol = 3,
		/obj/item/reagent_containers/glass/bottle/toxin = 1,
		/obj/item/reagent_containers/glass/bottle/coagzolug = 2,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 2,
		/obj/item/reagent_containers/syringe = 12,
		/obj/item/device/healthanalyzer = 5,
		/obj/item/device/breath_analyzer = 2,
		/obj/item/reagent_containers/glass/beaker = 4,
		/obj/item/reagent_containers/dropper = 2,
		/obj/item/stack/medical/bruise_pack = 5,
		/obj/item/stack/medical/ointment = 5,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 3,
		/obj/item/stack/medical/splint = 2,
		/obj/item/reagent_containers/pill/antitox = 6,
		/obj/item/reagent_containers/pill/cetahydramine = 6,
		/obj/item/reagent_containers/pill/perconol = 6,
		/obj/item/reagent_containers/glass/beaker/medcup = 4,
		/obj/item/storage/pill_bottle = 4,
		/obj/item/reagent_containers/spray/sterilizine = 2
	)
	contraband = list(
		/obj/item/reagent_containers/inhaler/space_drugs = 2,
		/obj/item/reagent_containers/pill/tox = 3,
		/obj/item/reagent_containers/pill/stox = 4
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	random_itemcount = 0
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN
	manufacturer = "zenghu"

/obj/machinery/vending/medical/low_supply
	products = list(
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1,
		/obj/item/reagent_containers/glass/bottle/toxin = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/reagent_containers/syringe = 8,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/stack/medical/splint = 1,
		/obj/item/reagent_containers/pill/antitox = 2,
		/obj/item/reagent_containers/pill/cetahydramine = 1,
		/obj/item/reagent_containers/pill/perconol = 1,
		/obj/item/reagent_containers/glass/beaker/medcup = 4,
		/obj/item/storage/pill_bottle = 2,
		/obj/item/reagent_containers/spray/sterilizine = 1
	)

/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	req_access = list(ACCESS_MEDICAL)
	density = FALSE //It is wall-mounted, and thus, not dense. --Superxpdude
	vend_id = "meds"
	products = list(
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 3,
		/obj/item/reagent_containers/pill/perconol = 4,
		/obj/item/storage/box/fancy/med_pouch/trauma = 1,
		/obj/item/storage/box/fancy/med_pouch/burn = 1,
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 1,
		/obj/item/storage/box/fancy/med_pouch/toxin = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/device/breath_analyzer  = 1
	)
	contraband = list(
		/obj/item/reagent_containers/syringe/dylovene = 4,
		/obj/item/reagent_containers/pill/tox = 1
	)
	premium = list(
		/obj/item/reagent_containers/pill/mortaphenyl = 4
	)
	random_itemcount = FALSE
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	manufacturer = "zenghu"

/obj/machinery/vending/wallmed1/low_supply
	products = list(
		/obj/item/stack/medical/bruise_pack = 1,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/reagent_containers/pill/perconol = 2,
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 1,
		/obj/item/storage/box/fancy/med_pouch/toxin = 1
	)

/obj/machinery/vending/wallmed2
	name = "NanoMed Mini"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	icon_state = "wallmed"
	req_access = list(ACCESS_MEDICAL)
	density = FALSE //It is wall-mounted, and thus, not dense. --Superxpdude
	vend_id = "meds"
	products = list(
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 5,
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
		/obj/item/storage/box/fancy/med_pouch/trauma = 1,
		/obj/item/storage/box/fancy/med_pouch/burn = 1,
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 1,
		/obj/item/storage/box/fancy/med_pouch/toxin = 1,
		/obj/item/storage/box/fancy/med_pouch/radiation = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/device/breath_analyzer = 1
	)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 3
	)
	premium = list(
		/obj/item/reagent_containers/pill/mortaphenyl = 4
	)
	random_itemcount = FALSE
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	manufacturer = "zenghu"

/obj/machinery/vending/wallmed2/low_supply
	products = list(
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 1,
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/box/fancy/med_pouch/radiation = 1
	)

/obj/item/device/vending_refill/meds
	name = "meds resupply canister"
	vend_id = "meds"
	charges = 38


/obj/machinery/vending/wallpharm
	name = "NanoPharm Mini"
	desc = "A wall-mounted pharmaceuticals vending machine packed with over-the-counter bottles. For the sick salaried worker in you."
	icon_state = "wallpharm"
	density = FALSE
	products = list(
		/obj/item/stack/medical/bruise_pack = 5,
		/obj/item/stack/medical/ointment = 5,
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 2,
		/obj/item/storage/pill_bottle/antidexafen = 4,
		/obj/item/storage/pill_bottle/dexalin = 4,
		/obj/item/storage/pill_bottle/dylovene = 4,
		/obj/item/storage/pill_bottle/vitamin = 5,
		/obj/item/storage/pill_bottle/cetahydramine  = 4,
		/obj/item/storage/pill_bottle/caffeine = 3,
		/obj/item/storage/pill_bottle/nicotine  = 4,
		/obj/item/storage/pill_bottle/rmt = 2
	)
	prices = list(
		/obj/item/storage/pill_bottle/antidexafen = 7.00,
		/obj/item/storage/pill_bottle/dexalin = 25.00,
		/obj/item/storage/pill_bottle/dylovene = 12.00,
		/obj/item/storage/pill_bottle/vitamin = 8.00,
		/obj/item/storage/pill_bottle/cetahydramine = 10.00,
		/obj/item/storage/pill_bottle/caffeine = 9.00,
		/obj/item/storage/pill_bottle/nicotine = 15.00,
		/obj/item/storage/pill_bottle/rmt = 55.00
	)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 3,
		/obj/item/storage/pill_bottle/perconol = 3
	)
	random_itemcount = FALSE
	temperature_setting = -1
	light_color = COLOR_GOLD
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	manufacturer = "nanotrasen"

/obj/machinery/vending/wallpharm/low_supply
	products = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/pill_bottle/antidexafen = 1,
		/obj/item/storage/pill_bottle/dexalin = 1,
		/obj/item/storage/pill_bottle/dylovene = 2,
		/obj/item/storage/pill_bottle/vitamin = 2,
		/obj/item/storage/pill_bottle/cetahydramine  = 1,
		/obj/item/storage/pill_bottle/rmt = 1
	)
