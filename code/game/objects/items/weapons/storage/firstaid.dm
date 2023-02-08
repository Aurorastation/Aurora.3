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
		/obj/item/stack/medical/splint = 1,
		/obj/item/device/healthanalyzer = 1
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
		/obj/item/stack/medical/splint = 1,
		/obj/item/device/healthanalyzer = 1
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
		/obj/item/stack/medical/splint = 1,
		/obj/item/device/healthanalyzer = 1
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
		/obj/item/storage/box/fancy/med_pouch/radiation = 1,
		/obj/item/device/healthanalyzer = 1
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
		/obj/item/reagent_containers/hypospray/autoinjector/dylovene = 1,
		/obj/item/device/healthanalyzer = 1
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
