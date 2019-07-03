/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/weapon/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	var/empty = 0
	drop_sound = 'sound/items/drop/box.ogg'


/obj/item/weapon/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

	fill()
		..()
		if (empty) return
		icon_state = pick("ointment","firefirstaid")
		new /obj/item/weapon/reagent_containers/pill/kelotane( src )
		new /obj/item/weapon/reagent_containers/pill/kelotane( src )
		new /obj/item/weapon/reagent_containers/pill/kelotane( src )
		new /obj/item/stack/medical/ointment( src )
		new /obj/item/stack/medical/ointment( src )
		new /obj/item/device/healthanalyzer( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/inaprovaline( src )
		return


/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"

	fill()
		..()
		if (empty) return
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/device/healthanalyzer(src)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/inaprovaline( src )
		return

/obj/item/weapon/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

	fill()
		..()
		if (empty) return
		icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/device/healthanalyzer( src )
		return

/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation kit"
	desc = "A box full of oxygen related goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

	fill()
		..()
		if (empty) return
		new /obj/item/weapon/reagent_containers/inhaler/dexalin( src )
		new /obj/item/weapon/reagent_containers/inhaler/dexalin( src )
		new /obj/item/weapon/reagent_containers/inhaler/dexalin( src )
		new /obj/item/weapon/reagent_containers/inhaler/dexalin( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/inaprovaline( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/inaprovaline( src )
		new /obj/item/device/breath_analyzer( src )
		return

/obj/item/weapon/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"

/obj/item/weapon/storage/firstaid/adv/fill()
	..()
	if (empty) return
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/inaprovaline( src )
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	return

/obj/item/weapon/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

/obj/item/weapon/storage/firstaid/combat/fill()
	..()
	if (empty) return
	new /obj/item/weapon/storage/pill_bottle/prefilled/bicaridine(src)
	new /obj/item/weapon/storage/pill_bottle/prefilled/dermaline(src)
	new /obj/item/weapon/storage/pill_bottle/prefilled/dexalin_plus(src)
	new /obj/item/weapon/storage/pill_bottle/prefilled/dylovene(src)
	new /obj/item/weapon/storage/pill_bottle/prefilled/tramadol(src)
	new /obj/item/weapon/reagent_containers/inhaler/hyperzine(src)
	new /obj/item/stack/medical/splint(src)
	return

/obj/item/weapon/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport."
	icon_state = "purplefirstaid"
	item_state = "firstaid-advanced"
	use_sound = 'sound/items/storage/briefcase.ogg'

/obj/item/weapon/storage/firstaid/surgery/fill()
	..()
	if (empty) return
	new /obj/item/weapon/bonesetter(src)
	new /obj/item/weapon/cautery(src)
	new /obj/item/weapon/circular_saw(src)
	new /obj/item/weapon/hemostat(src)
	new /obj/item/weapon/retractor(src)
	new /obj/item/weapon/scalpel(src)
	new /obj/item/weapon/surgicaldrill(src)
	new /obj/item/weapon/bonegel(src)
	new /obj/item/weapon/FixOVein(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/weapon/reagent_containers/inhaler/soporific(src)
	new /obj/item/weapon/reagent_containers/inhaler/soporific(src)
	make_exact_fit()

/obj/item/weapon/storage/firstaid/brute
	name = "brute aid kit"
	desc = "A NanoTrasen care package for moderately injured miners."
	icon_state = "brute"

/obj/item/weapon/storage/firstaid/brute/fill()
		..()
		if (empty) return
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/advanced/bruise_pack(src)
		new /obj/item/stack/medical/advanced/bruise_pack(src)
		return

/*
 * Pill Bottles
 */
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = 2.0
	can_hold = list(/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/dice,/obj/item/weapon/paper)
	allow_quick_gather = 1
	use_to_pickup = 1
	use_sound = 'sound/items/storage/pillbottle.ogg'
	drop_sound = 'sound/items/drop/pillbottle.ogg'
	max_storage_space = 16

/obj/item/weapon/storage/pill_bottle/prefilled
	var/default_amount = 7
	var/pill_type

/obj/item/weapon/storage/pill_bottle/prefilled/fill()
	..()
	for(var/i=0, i < 7)
		new pill_type(src)

/obj/item/weapon/storage/pill_bottle/prefilled/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."
	pill_type = /obj/item/weapon/reagent_containers/pill/antitox

/obj/item/weapon/storage/pill_bottle/prefilled/bicaridine
	name = "bottle of Bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."
	pill_type = /obj/item/weapon/reagent_containers/pill/bicaridine

/obj/item/weapon/storage/pill_bottle/prefilled/dexalin_plus
	name = "bottle of Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."
	pill_type = /obj/item/weapon/reagent_containers/pill/dexalin_plus

/obj/item/weapon/storage/pill_bottle/prefilled/dermaline
	name = "bottle of Dermaline pills"
	desc = "Contains pills used to treat burn wounds."
	pill_type = /obj/item/weapon/reagent_containers/pill/dermaline

/obj/item/weapon/storage/pill_bottle/prefilled/dylovene
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to treat toxic substances in the blood."
	pill_type = /obj/item/weapon/reagent_containers/pill/dylovene

/obj/item/weapon/storage/pill_bottle/prefilled/inaprovaline
	name = "bottle of Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."
	pill_type = /obj/item/weapon/reagent_containers/pill/inaprovaline

/obj/item/weapon/storage/pill_bottle/prefilled/kelotane
	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."
	pill_type = /obj/item/weapon/reagent_containers/pill/kelotane

/obj/item/weapon/storage/pill_bottle/prefilled/antihistamine
	name = "bottle of diphenhydramine pills"
	desc = "Diphenhydramine, a common antihistamine used to reduce symptoms of allergies. Helps with sneezing."
	pill_type = /obj/item/weapon/reagent_containers/pill/antihistamine

/obj/item/weapon/storage/pill_bottle/prefilled/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."
	pill_type = /obj/item/weapon/reagent_containers/pill/tramadol

/obj/item/weapon/storage/pill_bottle/prefilled/paracetamol
	name = "bottle of paracetamol pills"
	desc = "Contains pills used to relieve pain and reduce fevers."
	pill_type = /obj/item/weapon/reagent_containers/pill/paracetamol

/obj/item/weapon/storage/pill_bottle/prefilled/escitalopram
	name = "bottle of Escitalopram pills"
	desc = "Contains pills used to stabilize a patient's mood."
	pill_type = /obj/item/weapon/reagent_containers/pill/escitalopram

/obj/item/weapon/storage/pill_bottle/prefilled/rmt
	name = "bottle of RMT pills"
	desc = "Contains pills used to remedy the effects of prolonged zero-gravity adaptations."
	pill_type = /obj/item/weapon/reagent_containers/pill/rmt