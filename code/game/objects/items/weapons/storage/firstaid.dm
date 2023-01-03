/* first-aid storage
 * Contains:
 *		first-aid Kits
 * 		Pill Bottles
 */

/*
 * first-aid Kits
 */
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon = 'icons/obj/storage/firstaid.dmi'
	icon_state = "firstaid"
	item_state = "firstaid"
	contained_sprite = TRUE
	center_of_mass = list("x" = 13,"y" = 10)
	throw_speed = 2
	throw_range = 8
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'
	use_sound = 'sound/items/storage/briefcase.ogg'

/obj/item/storage/firstaid/empty
	name = "empty first-aid kit"
	desc = "It's an emergency medical kit for people who like wish soup."

/obj/item/storage/firstaid/regular
	starts_with = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/pill_bottle/antidexafen = 1,
		/obj/item/storage/pill_bottle/perconol = 1,
		/obj/item/stack/medical/splint = 1
	)

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "firefirstaid"
	item_state = "firefirstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/burn = 4
	)

/obj/item/storage/firstaid/fire/fill()
	. = ..()
	icon_state = pick("firefirstaid","firefirstaid2","firefirstaid3")

/obj/item/storage/firstaid/toxin
	name = "toxin first-aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxinfirstaid"
	item_state = "antitoxinfirstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/toxin = 4
	)

/obj/item/storage/firstaid/toxin/fill()
	. = ..()
	icon_state = pick("antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation kit"
	desc = "A box full of oxygen related goodies."
	icon_state = "o2firstaid"
	item_state = "o2firstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 4
	)

/obj/item/storage/firstaid/o2/fill()
	. = ..()
	icon_state = pick("o2firstaid","o2firstaid2","o2firstaid3")

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "advfirstaid"
	starts_with = list(
		/obj/item/storage/pill_bottle/assorted = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint = 1
	)

/obj/item/storage/firstaid/adv/fill()
	. = ..()
	icon_state = pick("advfirstaid","advfirstaid2","advfirstaid3")

/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "bezerk"
	starts_with = list(
		/obj/item/storage/pill_bottle/butazoline = 1,
		/obj/item/storage/pill_bottle/dermaline = 1,
		/obj/item/storage/pill_bottle/dexalin_plus = 1,
		/obj/item/storage/pill_bottle/dylovene = 1,
		/obj/item/storage/pill_bottle/mortaphenyl = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/sideeffectbgone = 1,
		/obj/item/stack/medical/splint = 1
	)

/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport."
	icon_state = "purplefirstaid"
	item_state = "purplefirstaid"
	starts_with = list(
		/obj/item/surgery/bonesetter = 1,
		/obj/item/surgery/cautery = 1,
		/obj/item/surgery/circular_saw = 1,
		/obj/item/surgery/hemostat = 1,
		/obj/item/surgery/retractor = 1,
		/obj/item/surgery/scalpel = 1,
		/obj/item/surgery/surgicaldrill = 1,
		/obj/item/surgery/bone_gel = 1,
		/obj/item/surgery/fix_o_vein = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/reagent_containers/inhaler/soporific = 2
	)

/obj/item/storage/firstaid/surgery/fill()
	. = ..()
	make_exact_fit()
	icon_state = pick("purplefirstaid","purplefirstaid2","purplefirstaid3")

/obj/item/storage/firstaid/trauma
	name = "trauma first-aid kit"
	desc = "It's an emergency medical kit for when people brought ballistic weapons to a laser fight."
	icon_state = "traumafirstaid"
	item_state = "traumafirstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/trauma = 4
	)

/obj/item/storage/firstaid/trauma/fill()
	..()
	icon_state = pick("traumafirstaid","traumafirstaid2","traumafirstaid3")

/obj/item/storage/firstaid/radiation
	name = "radiation first-aid kit"
	desc = "It's an emergency medical kit for when you try to hug the reactor."
	icon_state = "radfirstaid"
	item_state = "radfirstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/radiation = 4
	)

/obj/item/storage/firstaid/radiation/Initialize()
	. = ..()
	icon_state = pick("radfirstaid","radfirstaid2","radfirstaid3")

/obj/item/storage/firstaid/stab // Generic first aid kit for mappers that covers all bases.
	name = "stabilisation first-aid"
	desc = "Stocked with medical pouches."
	icon_state = "firstaid_multi"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/trauma = 1,
		/obj/item/storage/box/fancy/med_pouch/burn = 1,
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 1,
		/obj/item/storage/box/fancy/med_pouch/toxin = 1,
		/obj/item/storage/box/fancy/med_pouch/radiation = 1
	)

/obj/item/storage/firstaid/sleekstab
	name = "Slimline stabilisation kit"
	desc = "A sleek and expensive looking medical kit."
	icon_state = "firstaid_multi"
	item_state = "firstaid_multi"
	w_class = ITEMSIZE_SMALL
	storage_slots = 7
	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector/coagzolug = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/pain = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/oxygen = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/dylovene = 1
	)


/obj/item/storage/firstaid/light // For pilot/expedition closets, which we don't have. Yet.
	name = "light first-aid kit"
	desc = "It's a small emergency medical kit."
	icon_state = "fak-light"
	item_state = "advfirstaid"
	storage_slots = 5
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_SMALL
	starts_with = list(
		/obj/item/clothing/gloves/latex/nitrile = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/mortaphenyl = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin = 1,
		/obj/item/stack/medical/bruise_pack = 1
	)
	can_hold = list(
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/bruise_pack
	)

/*
 * Pill Bottles
 */
/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medical.dmi',
		)
	item_state = "pill_canister"
	center_of_mass = list("x" = 16,"y" = 12)
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/reagent_containers/pill,/obj/item/stack/dice,/obj/item/paper)
	allow_quick_gather = 1
	use_to_pickup = 1
	use_sound = 'sound/items/storage/pillbottle.ogg'
	drop_sound = 'sound/items/drop/pillbottle.ogg'
	pickup_sound = 'sound/items/pickup/pillbottle.ogg'
	max_storage_space = 16

/obj/item/storage/pill_bottle/attack_self(mob/living/user)
	if(user.get_inactive_hand())
		to_chat(user, SPAN_NOTICE("You need an empty hand to take something out."))
		return
	if(contents.len)
		var/obj/item/I = contents[1]
		if(!remove_from_storage(I,user))
			return
		if(user.put_in_inactive_hand(I))
			to_chat(user, SPAN_NOTICE("You take \the [I] out of \the [src]."))
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.swap_hand()
		else
			I.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You fumble around with \the [src] and drop \the [I] on the floor."))
	else
		to_chat(user, SPAN_WARNING("\The [src] is empty."))


/obj/item/storage/pill_bottle/antitox
	name = "bottle of 10u Dylovene pills"
	desc = "Contains pills used to remove toxic substances from the blood."
	starts_with = list(/obj/item/reagent_containers/pill/antitox = 7)

/obj/item/storage/pill_bottle/bicaridine
	name = "bottle of 10u Bicaridine pills"
	desc = "Contains pills used to treat minor injuries and bleeding."
	starts_with = list(/obj/item/reagent_containers/pill/bicaridine = 7)

/obj/item/storage/pill_bottle/dexalin_plus
	name = "bottle of 15u Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."
	starts_with = list(/obj/item/reagent_containers/pill/dexalin_plus = 7)

/obj/item/storage/pill_bottle/dermaline
	name = "bottle of 10u Dermaline pills"
	desc = "Contains pills used to treat severe burn wounds."
	starts_with = list(/obj/item/reagent_containers/pill/dermaline = 7)

/obj/item/storage/pill_bottle/dylovene
	name = "bottle of 15u Dylovene pills"
	desc = "Contains pills used to remove toxic substances from the blood."
	starts_with = list(/obj/item/reagent_containers/pill/dylovene = 7)

/obj/item/storage/pill_bottle/inaprovaline
	name = "bottle of 10u Inaprovaline pills"
	desc = "Contains pills used to stabilize a patient's heart activity."
	starts_with = list(/obj/item/reagent_containers/pill/inaprovaline = 7)

/obj/item/storage/pill_bottle/kelotane
	name = "bottle of 10u Kelotane pills"
	desc = "Contains pills used to treat minor burns."
	starts_with = list(/obj/item/reagent_containers/pill/kelotane = 7)

obj/item/storage/pill_bottle/butazoline
	name = "bottle of 10u Butazoline pills"
	desc = "Contains pills used to severe injuries and bleeding."
	starts_with = list(/obj/item/reagent_containers/pill/butazoline = 7)

/obj/item/storage/pill_bottle/cetahydramine
	name = "bottle of 5u Cetahydramine pills"
	desc = "Contains pills used to treat coughing, sneezing and itching."
	starts_with = list(/obj/item/reagent_containers/pill/cetahydramine = 7)

/obj/item/storage/pill_bottle/mortaphenyl
	name = "bottle of 10u Mortaphenyl pills"
	desc = "Contains pills used to relieve severe pain in a trauma setting."
	starts_with = list(/obj/item/reagent_containers/pill/mortaphenyl = 7)

/obj/item/storage/pill_bottle/perconol
	name = "bottle of 10u Perconol pills"
	desc = "Contains pills used to relieve minor-moderate pain and reduce fevers."
	starts_with = list(/obj/item/reagent_containers/pill/perconol = 7)

/obj/item/storage/pill_bottle/minaphobin
	name = "bottle of 2u Minaphobin pills"
	desc = "Contains pills used to treat anxiety disorders and depression."
	starts_with = list(/obj/item/reagent_containers/pill/minaphobin = 7)

/obj/item/storage/pill_bottle/rmt
	name = "bottle of 15u RMT pills"
	desc = "Contains pills used to remedy the effects of prolonged zero-gravity adaptations. Do not exceed 30u dosage."
	starts_with = list(/obj/item/reagent_containers/pill/rmt = 10) // 10x 15u RMT pills will last 4 hours.

/obj/item/storage/pill_bottle/corophenidate
	name = "bottle of 2u Corophenidate pills"
	desc = "Contains pills used to improve the ability to concentrate."
	starts_with = list(/obj/item/reagent_containers/pill/corophenidate = 3)

/obj/item/storage/pill_bottle/emoxanyl
	name = "bottle of 2u Emoxanyl pills"
	desc = "Contains pills used to treat anxiety disorders, depression and epilepsy."
	starts_with = list(/obj/item/reagent_containers/pill/emoxanyl = 3)

/obj/item/storage/pill_bottle/minaphobin/small
	starts_with = list(/obj/item/reagent_containers/pill/minaphobin = 3)

/obj/item/storage/pill_bottle/nerospectan
	name = "bottle of 2u Nerospectan pills"
	desc = "Contains pills used to treat a large variety of disorders including tourette, depression, anxiety and psychoses."
	starts_with = list(/obj/item/reagent_containers/pill/nerospectan = 3)

/obj/item/storage/pill_bottle/neurapan
	name = "bottle of 2u Neurapan pills"
	desc = "Contains pills used to treat large variety of disorders including tourette, depression, anxiety and psychoses."
	starts_with = list(/obj/item/reagent_containers/pill/neurapan= 3)

/obj/item/storage/pill_bottle/neurostabin
	name = "bottle of 2u Neurostabin pills"
	desc = "Contains pills used to treat psychoses and muscle weakness."
	starts_with = list(/obj/item/reagent_containers/pill/neurostabin = 3)

/obj/item/storage/pill_bottle/orastabin
	name = "bottle of 2u Orastabin pills"
	desc = "Contains pills used to treat anxiety disorders and speech impediments."
	starts_with = list(/obj/item/reagent_containers/pill/orastabin = 3)

/obj/item/storage/pill_bottle/parvosil
	name = "bottle of 2u Parvosil pills"
	desc = "Contains pills used to treat anxiety disorders such as phobias and social anxiety."
	starts_with = list(/obj/item/reagent_containers/pill/parvosil = 3)

/obj/item/storage/pill_bottle/assorted
	name = "pill bottle (assorted)"
	desc = "Commonly found on paramedics, these assorted pill bottles contain all the basics."
	starts_with = list(
		/obj/item/reagent_containers/pill/inaprovaline = 6,
		/obj/item/reagent_containers/pill/dylovene = 6,
		/obj/item/reagent_containers/pill/sugariron = 2,
		/obj/item/reagent_containers/pill/mortaphenyl = 2,
		/obj/item/reagent_containers/pill/dexalin = 2,
		/obj/item/reagent_containers/pill/kelotane = 2,
		/obj/item/reagent_containers/pill/hyronalin = 1
	)

/obj/item/storage/pill_bottle/antidexafen
	name = "pill bottle (cold medicine)"
	desc = "All-in-one cold medicine. 15u dose per pill. Safe for babies like you!"
	starts_with = list(/obj/item/reagent_containers/pill/antidexafen = 21)
