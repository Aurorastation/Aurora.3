/*
Single Use Emergency Pouches
 */

/obj/item/storage/box/fancy/med_pouch
	name = "emergency medical pouch"
	desc = "For use in emergency situations only."
	icon = 'icons/obj/storage/firstaid.dmi'
	storage_slots = 7
	w_class = WEIGHT_CLASS_SMALL
	max_w_class = WEIGHT_CLASS_SMALL
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
	make_exact_fit = TRUE

// All the med pouches have custom instructions. Don't inherit this.
/obj/item/storage/box/fancy/med_pouch/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "1) Tear open the emergency medical pack using the easy open tab at the top."
	. += "2) Carefully remove all items from the pouch and discard the pouch."
	. += "3) Apply all autoinjectors to the injured party."
	. += "4) Use bandages to stop bleeding if required."
	. += "5) Force the injured party to swallow all pills."
	. += "6) Use ointment on any burns if required."
	. += "7) Contact the medical team with your location."
	. += "8) Stay in place once they respond."

/obj/item/storage/box/fancy/med_pouch/Initialize()
	. = ..()
	name = "emergency [injury_type] pouch"
	for(var/obj/item/reagent_containers/pill/P in contents)
		P.color = color

/obj/item/storage/box/fancy/med_pouch/trauma
	name = "trauma pouch"
	injury_type = "trauma"
	color = COLOR_RED

	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 1,
		/obj/item/reagent_containers/pill/pouch_pill/inaprovaline = 1,
		/obj/item/reagent_containers/pill/pouch_pill/perconol = 1,
		/obj/item/stack/medical/bruise_pack = 2
	)

/obj/item/storage/box/fancy/med_pouch/trauma/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
	// All the med pouches have custom instructions. Does not inherit.
	. += "1) Tear open the emergency medical pack using the easy open tab at the top."
	. += "2) Carefully remove all items from the pouch and discard the pouch."
	. += "3) Apply all autoinjectors to the injured party."
	. += "4) Use bandages to stop bleeding if required."
	. += "5) Force the injured party to swallow all pills."
	. += "6) Contact the medical team with your location."
	. += "7) Stay in place once they respond."

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

/obj/item/storage/box/fancy/med_pouch/burn/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
	// All the med pouches have custom instructions. Does not inherit.
	. += "1) Tear open the emergency medical pack using the easy open tab at the top."
	. += "2) Carefully remove all items from the pouch and discard the pouch."
	. += "3) Apply the emergency mortaphenyl autoinjector to the injured party."
	. += "4) Apply all remaining autoinjectors to the injured party."
	. += "5) Force the injured party to swallow all pills."
	. += "6) Use ointment on any burns if required."
	. += "7) Contact the medical team with your location."
	. += "8) Stay in place once they respond."

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

/obj/item/storage/box/fancy/med_pouch/oxyloss/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
	// All the med pouches have custom instructions. Does not inherit.
	. += "1) Tear open the emergency medical pack using the easy open tab at the top."
	. += "2) Carefully remove all items from the pouch and discard the pouch."
	. += "3) Apply all autoinjectors to the injured party."
	. += "4) Force the injured party to swallow all pills."
	. += "5) Contact the medical team with your location."
	. += "6) Find a source of oxygen if possible."
	. += "7) Update the medical team with your new location."
	. += "8) Stay in place once they respond."

/obj/item/storage/box/fancy/med_pouch/toxin
	name = "toxin pouch"
	injury_type = "toxin"
	color = COLOR_GREEN

	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene = 1,
		/obj/item/reagent_containers/pill/pouch_pill/dylovene = 1
	)

/obj/item/storage/box/fancy/med_pouch/toxin/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
	// All the med pouches have custom instructions. Does not inherit.
	. += "1) Tear open the emergency medical pack using the easy open tab at the top."
	. += "2) Carefully remove all items from the pouch and discard the pouch."
	. += "3) Apply all autoinjectors to the injured party."
	. += "4) Force the injured party to swallow all pills."
	. += "5) Contact the medical team with your location."
	. += "6) Stay in place once they respond."

/obj/item/storage/box/fancy/med_pouch/radiation
	name = "radiation pouch"
	injury_type = "radiation"
	color = COLOR_WHEAT

	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector/hyronalin = 1,
		/obj/item/reagent_containers/pill/pouch_pill/dylovene = 1
	)

/obj/item/storage/box/fancy/med_pouch/radiation/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
	// All the med pouches have custom instructions. Does not inherit.
	. += "1) Tear open the emergency medical pack using the easy open tab at the top."
	. += "2) Carefully remove all items from the pouch and discard the pouch."
	. += "3) Apply all autoinjectors to the injured party."
	. += "4) Force the injured party to swallow all pills."
	. += "5) Contact the medical team with your location."
	. += "6) Stay in place once they respond."

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
	desc = "An emergency autoinjector from an emergency medical pouch. Do not administer more than one of each type of autoinjector to a patient."

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline
	name = "emergency inaprovaline autoinjector"
	desc = "An emergency autoinjector containing inaprovaline, for stabilizing patients in or near critical condition."
	reagents_to_add = list(/singleton/reagent/inaprovaline = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/mortaphenyl
	name = "emergency mortaphenyl autoinjector"
	desc = "An emergency autoinjector containing mortaphenyl, a powerful painkiller for use in extreme injury. Side effects include confusion and impaired vision. <b>DO NOT APPLY TO ANYONE UNDER THE INFLUENCE OF ALCOHOL.</b>"
	reagents_to_add = list(/singleton/reagent/mortaphenyl = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene
	name = "emergency dylovene autoinjector"
	desc = "An emergency autoinjector containing dylovene, an effective anti-toxin medicine that protects the body from poisoning effects and neutralizes toxins."
	reagents_to_add = list(/singleton/reagent/dylovene = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin
	name = "emergency dexalin autoinjector"
	desc = "An emergency autoinjector containing dexalin, a medicine which delivers oxygen to patients who are deprived of it, such as with lung injuries or vacuum exposure. <b>DO NOT APPLY TO VAURCAE.</b>"
	reagents_to_add = list(/singleton/reagent/dexalin = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline
	name = "emergency adrenaline autoinjector"
	desc = "An emergency autoinjector containing adrenaline, or epinephrine. This autoinjector comes with a dosage meant to make rescusitation easier. Apply to those in critical condition only, and combine with CPR."
	amount_per_transfer_from_this = 8
	reagents_to_add = list(/singleton/reagent/adrenaline = 8)

//advanced autos

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/butazoline
	name = "emergency butazoline autoinjector"
	desc = "An emergency autoinjector containing butazoline for treating severe trauma. Side effects include dehydration and itchiness."
	reagents_to_add = list(/singleton/reagent/butazoline = 10)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dermaline
	name = "emergency dermaline autoinjector"
	desc = "An emergency autoinjector containing dermaline for treating severe burns. Side effects include dehydration and itchiness."
	reagents_to_add = list(/singleton/reagent/dermaline = 10)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin_plus
	name = "emergency dexalin plus autoinjector"
	desc = "An emergency autoinjector containing dexalin plus, a medicine which efficiently delivers oxygen to patients who are deprived of it, such as with lung injuries or vacuum exposure. <b>DO NOT APPLY TO VAURCAE.</b>"
	reagents_to_add = list(/singleton/reagent/dexalin/plus = 10)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/fluvectionem
	name = "emergency bloodstream purge autoinjector"
	desc = "An emergency anti-toxin autoinjector that, when injected into a person, purges their bloodstream of chemicals, including toxins and medicine alike. Useful in the event of severe poisonings. <b>PURGES MEDICINE. DO NOT APPLY IF ANY MEDICATION WAS ALREADY GIVEN.</b>"
	reagents_to_add = list(/singleton/reagent/fluvectionem = 5)
