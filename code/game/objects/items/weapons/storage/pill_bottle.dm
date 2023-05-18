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

/obj/item/storage/pill_bottle/butazoline
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
	name = "bottle of assorted pills"
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
	name = "bottle of 15u Antidexafen pills"
	desc = "All-in-one cold medicine. 15u dose per pill. Safe for babies like you!"
	starts_with = list(/obj/item/reagent_containers/pill/antidexafen = 21)

/obj/item/storage/pill_bottle/antiparasitic
	name = "bottle of 5u Helmizole pills"
	desc = "Contains pills used to treat parasitic infections caused by worms."
	starts_with = list(/obj/item/reagent_containers/pill/antiparasitic = 8)

/obj/item/storage/pill_bottle/asinodryl
	name = "bottle of 10u Asinodryl pills"
	desc = "Contains pills used to treat nausea and vomiting."
	starts_with = list(/obj/item/reagent_containers/pill/asinodryl = 8)

/obj/item/storage/pill_bottle/steramycin
	name = "bottle of 5u Steramycin pills"
	desc = "Contains prophylactic antibiotic pills."
	starts_with = list(/obj/item/reagent_containers/pill/steramycin = 3)
