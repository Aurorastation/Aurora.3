/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	deny_time = 15
	req_access = list(access_medical_equip)
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/bottle/antitoxin, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/bottle/inaprovaline, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/bottle/perconol, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/bottle/toxin, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/bottle/coughsyrup, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/syringe, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/device/healthanalyzer, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/device/breath_analyzer, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/beaker, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/dropper, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/stack/medical/bruise_pack, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/stack/medical/ointment, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/stack/medical/advanced/bruise_pack, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/stack/medical/advanced/ointment, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/stack/medical/splint, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/pill/antitox, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/pill/cetahydramine, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/pill/perconol, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/medcup, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/pill_bottle, 4, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/inhaler/space_drugs, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/pill/tox, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/pill/stox, 4, FALSE)
		)
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	randomize_qty = FALSE
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN

/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	icon_state = "wallmed"
	deny_time = 15
	req_access = list(access_medical)
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/stack/medical/bruise_pack, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/stack/medical/ointment, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/device/healthanalyzer, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/device/breath_analyzer, 1, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/syringe/dylovene, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/pill/tox, 1, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/pill/mortaphenyl, 4, FALSE)
		)
	)
	randomize_qty = FALSE
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN


/obj/machinery/vending/wallmed2
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	icon_state = "wallmed"
	deny_time = 15
	req_access = list(access_medical)
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/syringe/dylovene, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/stack/medical/bruise_pack, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/stack/medical/ointment, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/device/healthanalyzer, 3, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/pill/tox, 3, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/pill/mortaphenyl, 4, FALSE)
		)
	)
	randomize_qty = FALSE
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN

/obj/item/vending_refill/meds
	name = "meds resupply canister"
	charges = 38
