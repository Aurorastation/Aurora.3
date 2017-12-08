/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	var/empty = 0


	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

	fill()
		..()
		if (empty) return

		icon_state = pick("ointment","firefirstaid")

		new /obj/item/device/healthanalyzer( src )
		new /obj/item/stack/medical/ointment( src )
		new /obj/item/stack/medical/ointment( src )
		return


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
		return

	name = "toxin first aid"
	desc = "Used to treat when you have a high amoutn of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

	fill()
		..()
		if (empty) return

		icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

		new /obj/item/device/healthanalyzer( src )
		return

	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

	fill()
		..()
		if (empty) return
		new /obj/item/device/healthanalyzer( src )
		return

	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"

	..()
	if (empty) return
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	return

	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

	..()
	if (empty) return
	new /obj/item/stack/medical/splint(src)
	return

	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport."
	icon_state = "purplefirstaid"
	item_state = "firstaid-advanced"

	..()
	if (empty) return
	new /obj/item/stack/medical/advanced/bruise_pack(src)

	make_exact_fit()

	name = "brute aid kit"
	desc = "A NanoTrasen care package for moderately injured miners."
	icon_state = "brute"

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
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state = "contsolid"
	w_class = 2.0
	allow_quick_gather = 1
	use_to_pickup = 1
	use_sound = null
	max_storage_space = 16

	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."

	fill()
		..()

	name = "bottle of Bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."

    ..()

	name = "bottle of Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."

    ..()

	name = "bottle of Dermaline pills"
	desc = "Contains pills used to treat burn wounds."

    ..()

	name = "bottle of Dylovene pills"
	desc = "Contains pills used to treat toxic substances in the blood."

    ..()

	name = "bottle of Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."

	fill()
		..()

	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."

	fill()
		..()

	name = "bottle of Spaceacillin pills"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."

    ..()

	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."

	fill()
		..()

	name = "bottle of Citalopram pills"
	desc = "Contains pills used to stabilize a patient's mood."

	fill()
		..()
