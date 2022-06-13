/*
Single Use Emergency Pouches
 */

/obj/item/storage/med_pouch
	name = "emergency medical pouch"
	desc = "For use in emergency situations only."
	icon = 'icons/obj/med_pouch.dmi'
	storage_slots = 7
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_SMALL
	icon_state = "pack0"
	var/opened = FALSE
	var/open_sound = 'sound/items/rip1.ogg'
	var/injury_type = "generic"
	var/static/image/cross_overlay
	build_from_parts = TRUE
	worn_overlay = "cross"

	desc_info = "INSTRUCTIONS: 1) Tear open the emergency medical pack using the easy open tab at the top.\
	2) Carefully remove all items from the pouch and discard the pouch \
	3) Apply all autoinjectors to the injured party \
	4) Use bandages to stop bleeding if required.\
	5) Force the injured party to swallow all pills. \
	6) Use ointment on any burns if required. \
	7) Contact the medical team with your location. \
	8) Stay in place once they respond."

/obj/item/storage/med_pouch/Initialize()
	. = ..()
	name = "emergency [injury_type] pouch"
	make_exact_fit()
	for(var/obj/item/reagent_containers/pill/P in contents)
		P.color = color
	for(var/obj/item/reagent_containers/hypospray/autoinjector/A in contents)
		A.update_icon()


/obj/item/storage/med_pouch/attack_self(mob/user)
	open(user)

/obj/item/storage/med_pouch/open(mob/user)
	if(!opened)
		opened = TRUE
		user.visible_message("<span class='notice'>\The [user] tears open [src], breaking the vacuum seal!</span>", "<span class='notice'>You tear open [src], breaking the vacuum seal!</span>")
		icon_state = "pack1"
		. = ..()

/obj/item/storage/med_pouch/trauma
	name = "trauma pouch"
	injury_type = "trauma"
	color = COLOR_RED

	starts_with = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 1,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/coagzolug = 1,
	/obj/item/reagent_containers/pill/pouch_pill/inaprovaline = 1,
	/obj/item/reagent_containers/pill/pouch_pill/perconol = 1,
	/obj/item/stack/medical/bruise_pack = 2
		)

	desc_info = "INSTRUCTIONS: 1) Tear open the emergency medical pack using the easy open tab at the top.\
	2) Carefully remove all items from the pouch and discard the pouch \
	3) Apply the inaprovaline autoinjector to the injured party \
	4) Apply the coagzolug autoinjector if the injured party is gushing blood.\
	4) Use bandages to stop bleeding if required.\
	5) Force the injured party to swallow all pills. \
	6) Contact the medical team with your location. \
	8) Stay in place once they respond."

/obj/item/storage/med_pouch/burn
	name = "burn pouch"
	injury_type = "burn"
	color = COLOR_SEDONA

	starts_with = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 1,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol = 1,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline = 1,
	/obj/item/reagent_containers/pill/pouch_pill/perconol = 1,
	/obj/item/stack/medical/ointment = 2
		)

	desc_info = "INSTRUCTIONS: 1) Tear open the emergency medical pack using the easy open tab at the top.\
	2) Carefully remove all items from the pouch and discard the pouch \
	3) Apply the emergency deletrathol autoinjector to the injured party. \
	4) Apply all remaining autoinjectors to the injured party \
	5) Force the injured party to swallow all pills if pain returns. \
	6) Use ointment on any burns if required.\
	7) Contact the medical team with your location. \
	8) Stay in place once they respond."

/obj/item/storage/med_pouch/oxyloss
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

	desc_info = "INSTRUCTIONS: 1) Tear open the emergency medical pack using the easy open tab at the top.\
	2) Carefully remove all items from the pouch and discard the pouch \
	3) Apply all autoinjectors to the injured party \
	4) Force the injured party to swallow all pills.\
	5) Contact the medical team with your location. \
	6) Find a source of oxygen if possible. \
	7) Update the medical team with your new location. \
	8) Stay in place once they respond."


/obj/item/storage/med_pouch/toxin
	name = "toxin pouch"
	injury_type = "toxin"
	color = COLOR_GREEN

	starts_with = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene = 1,
	/obj/item/reagent_containers/pill/pouch_pill/dylovene = 1
		)

	desc_info = "INSTRUCTIONS: 1) Tear open the emergency medical pack using the easy open tab at the top.\
	2) Carefully remove all items from the pouch and discard the pouch \
	3) Apply all autoinjectors to the injured party \
	4) Force the injured party to swallow all pills. \
	5) Contact the medical team with your location. \
	6) Stay in place once they respond."

/obj/item/storage/med_pouch/radiation
	name = "radiation pouch"
	injury_type = "radiation"
	color = COLOR_AMBER

	starts_with = list(
	/obj/item/reagent_containers/hypospray/autoinjector/hyronalin = 1,
	/obj/item/reagent_containers/pill/pouch_pill/dylovene = 1
		)

	desc_info = "INSTRUCTIONS: 1) Tear open the emergency medical pack using the easy open tab at the top.\
	2) Carefully remove all items from the pouch and discard the pouch \
	3) Apply all autoinjectors to the injured party \
	4) Force the injured party to swallow all pills. \
	5) Contact the medical team with your location. \
	6) Stay in place once they respond."

/obj/item/reagent_containers/pill/pouch_pill
	name = "emergency pill"
	desc = "An emergency pill from an emergency medical pouch."
	icon_state = "pill2"
	var/decl/reagent/chem_type
	var/chem_amount = 15

/obj/item/reagent_containers/pill/pouch_pill/inaprovaline
	chem_type = /decl/reagent/inaprovaline

/obj/item/reagent_containers/pill/pouch_pill/dylovene
	chem_type = /decl/reagent/dylovene

/obj/item/reagent_containers/pill/pouch_pill/dexalin
	chem_type = /decl/reagent/dexalin

/obj/item/reagent_containers/pill/pouch_pill/perconol
	chem_type = /decl/reagent/perconol

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
	reagents_to_add = list(/decl/reagent/inaprovaline = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol
	name = "emergency deletrathol autoinjector"
	reagents_to_add = list(/decl/reagent/deletrathol = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene
	name = "emergency dylovene autoinjector"
	reagents_to_add = list(/decl/reagent/dylovene = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin
	name = "emergency dexalin autoinjector"
	reagents_to_add = list(/decl/reagent/dexalin = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline
	name = "emergency adrenaline autoinjector"
	amount_per_transfer_from_this = 8
	reagents_to_add = list(/decl/reagent/adrenaline = 8)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/coagzolug
	name = "emergency coagzolug autoinjector"
	amount_per_transfer_from_this = 5
	reagents_to_add = list(/decl/reagent/coagzolug = 5)