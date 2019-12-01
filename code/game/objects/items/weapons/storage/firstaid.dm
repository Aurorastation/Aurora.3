/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	center_of_mass = list("x" = 13,"y" = 10)
	throw_speed = 2
	throw_range = 8
	var/empty = 0
	drop_sound = 'sound/items/drop/box.ogg'

/obj/item/storage/firstaid/fill()
	if (empty) return
	. = ..()

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"
	starts_with = list(
		/obj/item/reagent_containers/pill/kelotane = 3,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 1
	)

/obj/item/storage/firstaid/fire/fill()
	. = ..()
	icon_state = pick("ointment","firefirstaid")

/obj/item/storage/firstaid/regular
	icon_state = "firstaid"
	starts_with = list(
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 1
	)

/obj/item/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"
	starts_with = list(
		/obj/item/reagent_containers/syringe/antitoxin = 3,
		/obj/item/reagent_containers/pill/antitox = 3,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/toxin/fill()
	. = ..()
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation kit"
	desc = "A box full of oxygen related goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"
	starts_with = list(
		/obj/item/reagent_containers/inhaler/dexalin = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 2,
		/obj/item/device/breath_analyzer = 1
	)

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"
	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint = 1
	)

/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"
	starts_with = list(
		/obj/item/storage/pill_bottle/bicaridine = 1,
		/obj/item/storage/pill_bottle/dermaline = 1,
		/obj/item/storage/pill_bottle/dexalin_plus = 1,
		/obj/item/storage/pill_bottle/dylovene = 1,
		/obj/item/storage/pill_bottle/tramadol = 1,
		/obj/item/reagent_containers/inhaler/hyperzine = 1,
		/obj/item/stack/medical/splint = 1
	)

/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport."
	icon_state = "purplefirstaid"
	item_state = "firstaid-advanced"
	use_sound = 'sound/items/storage/briefcase.ogg'
	starts_with = list(
		/obj/item/bonesetter = 1,
		/obj/item/cautery = 1,
		/obj/item/circular_saw = 1,
		/obj/item/hemostat = 1,
		/obj/item/retractor = 1,
		/obj/item/scalpel = 1,
		/obj/item/surgicaldrill = 1,
		/obj/item/bonegel = 1,
		/obj/item/FixOVein = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/reagent_containers/inhaler/soporific = 2
	)

/obj/item/storage/firstaid/surgery/fill()
	..()
	if (!empty)
		make_exact_fit()

/obj/item/storage/firstaid/brute
	name = "brute aid kit"
	desc = "A NanoTrasen care package for moderately injured miners."
	icon_state = "brute"
	starts_with = list(
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/advanced/bruise_pack = 2
	)

/*
 * Pill Bottles
 */
/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	center_of_mass = list("x" = 16,"y" = 12)
	w_class = 2.0
	can_hold = list(/obj/item/reagent_containers/pill,/obj/item/dice,/obj/item/paper)
	allow_quick_gather = 1
	use_to_pickup = 1
	use_sound = 'sound/items/storage/pillbottle.ogg'
	drop_sound = 'sound/items/drop/pillbottle.ogg'
	max_storage_space = 16

/obj/item/storage/pill_bottle/attack_self(mob/living/user)
	if(user.get_inactive_hand())
		to_chat(user, span("notice","You need an empty hand to take something out."))
		return
	if(contents.len)
		var/obj/item/I = contents[1]
		if(!remove_from_storage(I,user))
			return
		if(user.put_in_inactive_hand(I))
			to_chat(user, span("notice","You take \the [I] out of \the [src]."))
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.swap_hand()
		else
			I.dropInto(loc)
			to_chat(user, span("notice","You fumble around with \the [src] and drop \the [I] on the floor."))
	else
		to_chat(user, span("warning","\The [src] is empty."))


/obj/item/storage/pill_bottle/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."
	starts_with = list(/obj/item/reagent_containers/pill/antitox = 7)

/obj/item/storage/pill_bottle/bicaridine
	name = "bottle of Bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."
	starts_with = list(/obj/item/reagent_containers/pill/bicaridine = 7)

/obj/item/storage/pill_bottle/dexalin_plus
	name = "bottle of Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."
	starts_with = list(/obj/item/reagent_containers/pill/dexalin_plus = 7)

/obj/item/storage/pill_bottle/dermaline
	name = "bottle of Dermaline pills"
	desc = "Contains pills used to treat burn wounds."
	starts_with = list(/obj/item/reagent_containers/pill/dermaline = 7)

/obj/item/storage/pill_bottle/dylovene
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to treat toxic substances in the blood."
	starts_with = list(/obj/item/reagent_containers/pill/dylovene = 7)

/obj/item/storage/pill_bottle/inaprovaline
	name = "bottle of Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."
	starts_with = list(/obj/item/reagent_containers/pill/inaprovaline = 7)

/obj/item/storage/pill_bottle/kelotane
	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."
	starts_with = list(/obj/item/reagent_containers/pill/kelotane = 7)

/obj/item/storage/pill_bottle/antihistamine
	name = "bottle of diphenhydramine pills"
	desc = "Diphenhydramine, a common antihistamine used to reduce symptoms of allergies. Helps with sneezing."
	starts_with = list(/obj/item/reagent_containers/pill/antihistamine = 7)

/obj/item/storage/pill_bottle/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."
	starts_with = list(/obj/item/reagent_containers/pill/tramadol = 7)

/obj/item/storage/pill_bottle/paracetamol
	name = "bottle of paracetamol pills"
	desc = "Contains pills used to relieve pain and reduce fevers."
	starts_with = list(/obj/item/reagent_containers/pill/paracetamol = 7)

/obj/item/storage/pill_bottle/escitalopram
	name = "bottle of Escitalopram pills"
	desc = "Contains pills used to stabilize a patient's mood."
	starts_with = list(/obj/item/reagent_containers/pill/escitalopram = 7)

/obj/item/storage/pill_bottle/rmt
	name = "bottle of RMT pills"
	desc = "Contains pills used to remedy the effects of prolonged zero-gravity adaptations."
	starts_with = list(/obj/item/reagent_containers/pill/rmt = 7)
