/*
Single Use Emergency Pouches
 */

/obj/item/storage/box/fancy/med_pouch
	name = "emergency medical pouch"
	desc = "For use in emergency situations only."
	desc_info = "\
	1) Tear open the emergency medical pack using the easy open tab at the top.<br>\
	2) Carefully remove all items from the pouch and discard the pouch.<br>\
	3) Apply all autoinjectors to the injured party.<br>\
	4) Use bandages to stop bleeding if required.<br>\
	5) Force the injured party to swallow all pills.<br>\
	6) Use ointment on any burns if required<br>\
	7) Contact the medical team with your location.<br>\
	8) Stay in place once they respond."
	icon = 'icons/obj/storage/firstaid.dmi'
	storage_slots = 7
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_SMALL
	icon_state = "pack"
	build_from_parts = TRUE
	worn_overlay = "cross"
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	use_sound = 'sound/items/storage/wrapper.ogg'
	open_sound = 'sound/items/rip1.ogg'
	icon_overlays = FALSE
	closable = FALSE
	var/injury_type = "generic"

/obj/item/storage/box/fancy/med_pouch/Initialize()
	..()
	name = "emergency [injury_type] pouch"
	make_exact_fit()
	for(var/obj/item/reagent_containers/pill/P in contents)
		P.color = color

/obj/item/storage/box/fancy/med_pouch/trauma
	name = "trauma pouch"
	desc_info = "\
	1) Tear open the emergency medical pack using the easy open tab at the top.<br>\
	2) Carefully remove all items from the pouch and discard the pouch.<br>\
	3) Apply all autoinjectors to the injured party.<br>\
	4) Use bandages to stop bleeding if required.<br>\
	5) Force the injured party to swallow all pills.<br>\
	6) Contact the medical team with your location.<br>\
	7) Stay in place once they respond."
	injury_type = "trauma"
	color = COLOR_RED

	starts_with = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 1,
	/obj/item/reagent_containers/pill/pouch_pill/inaprovaline = 1,
	/obj/item/reagent_containers/pill/pouch_pill/perconol = 1,
	/obj/item/stack/medical/bruise_pack = 2
	)

/obj/item/storage/box/fancy/med_pouch/burn
	name = "burn pouch"
	injury_type = "burn"
	color = COLOR_SEDONA

	starts_with = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 1,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/mortaphenyl = 1,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline = 1,
	/obj/item/reagent_containers/pill/pouch_pill/perconol = 1,
	/obj/item/stack/medical/ointment = 2
	)
	desc_info = "\
	1) Tear open the emergency medical pack using the easy open tab at the top.<br>\
	2) Carefully remove all items from the pouch and discard the pouch.<br>\
	3) Apply the emergency mortaphenyl autoinjector to the injured party.<br>\
	4) Apply all remaining autoinjectors to the injured party.<br>\
	5) Force the injured party to swallow all pills.<br>\
	6) Use ointment on any burns if required<br>\
	7) Contact the medical team with your location.<br>\
	8) Stay in place once they respond."

/obj/item/storage/box/fancy/med_pouch/oxyloss
	name = "low oxygen pouch"
	injury_type = "low oxygen"
	color = COLOR_BLUE

	starts_with = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 1,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin = 1,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline = 1,
	/obj/item/reagent_containers/pill/pouch_pill/inaprovaline = 1,
	/obj/item/reagent_containers/pill/pouch_pill/dexalin = 1
	)
	desc_info = "\
	1) Tear open the emergency medical pack using the easy open tab at the top.<br>\
	2) Carefully remove all items from the pouch and discard the pouch.<br>\
	3) Apply all autoinjectors to the injured party.<br>\
	4) Force the injured party to swallow all pills.<br>\
	5) Contact the medical team with your location.<br>\
	6) Find a source of oxygen if possible.<br>\
	7) Update the medical team with your new location.<br>\
	8) Stay in place once they respond."

/obj/item/storage/box/fancy/med_pouch/toxin
	name = "toxin pouch"
	injury_type = "toxin"
	color = COLOR_GREEN

	starts_with = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene = 1,
	/obj/item/reagent_containers/pill/pouch_pill/dylovene = 1
	)
	desc_info = "\
	1) Tear open the emergency medical pack using the easy open tab at the top.<br>\
	2) Carefully remove all items from the pouch and discard the pouch.<br>\
	3) Apply all autoinjectors to the injured party.<br>\
	4) Force the injured party to swallow all pills.<br>\
	5) Contact the medical team with your location.<br>\
	6) Stay in place once they respond."

/obj/item/storage/box/fancy/med_pouch/radiation
	name = "radiation pouch"
	injury_type = "radiation"
	color = COLOR_WHEAT

	starts_with = list(
	/obj/item/reagent_containers/hypospray/autoinjector/hyronalin = 1,
	/obj/item/reagent_containers/pill/pouch_pill/dylovene = 1
	)
	desc_info = "\
	1) Tear open the emergency medical pack using the easy open tab at the top.<br>\
	2) Carefully remove all items from the pouch and discard the pouch.<br>\
	3) Apply all autoinjectors to the injured party.<br>\
	4) Force the injured party to swallow all pills.<br>\
	5) Contact the medical team with your location.<br>\
	6) Stay in place once they respond."

/obj/item/reagent_containers/pill/pouch_pill
	name = "emergency pill"
	desc = "An emergency pill from an emergency medical pouch."
	icon_state = "pill18"
	var/singleton/reagent/chem_type
	var/chem_amount = 15

/obj/item/reagent_containers/pill/pouch_pill/inaprovaline
	chem_type = /singleton/reagent/inaprovaline

/obj/item/reagent_containers/pill/pouch_pill/dylovene
	chem_type = /singleton/reagent/dylovene

/obj/item/reagent_containers/pill/pouch_pill/dexalin
	chem_type = /singleton/reagent/dexalin

/obj/item/reagent_containers/pill/pouch_pill/perconol
	chem_type = /singleton/reagent/perconol

/obj/item/reagent_containers/pill/pouch_pill/New()
	..()
	reagents.add_reagent(chem_type, chem_amount)
	name = "emergency [reagents.get_primary_reagent_name()] pill ([reagents.total_volume]u)"
	color = reagents.get_color()

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto
	name = "emergency autoinjector"
	desc = "An emergency autoinjector from an emergency medical pouch."

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline
	name = "emergency inaprovaline autoinjector"
	reagents_to_add = list(/singleton/reagent/inaprovaline = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/mortaphenyl
	name = "emergency mortaphenyl autoinjector"
	reagents_to_add = list(/singleton/reagent/mortaphenyl = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene
	name = "emergency dylovene autoinjector"
	reagents_to_add = list(/singleton/reagent/dylovene = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin
	name = "emergency dexalin autoinjector"
	reagents_to_add = list(/singleton/reagent/dexalin = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline
	name = "emergency adrenaline autoinjector"
	amount_per_transfer_from_this = 8
	reagents_to_add = list(/singleton/reagent/adrenaline = 8)
