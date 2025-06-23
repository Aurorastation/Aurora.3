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
	max_w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/firstaid/empty
	desc = "It's a first-aid kit. Comes with nothing, so feel free to put your own stuff in it."
	max_storage_space = DEFAULT_BOX_STORAGE // So empty first-aid kits don't start with less space than filled ones.

/obj/item/storage/firstaid/regular
	starts_with = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/stack/medical/splint = 1,
		/obj/item/storage/pill_bottle/inaprovaline = 1,
		/obj/item/storage/pill_bottle/perconol = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/emergency = 1
	)

/obj/item/storage/firstaid/large
	name = "large first-aid kit"
	desc = "A large first-aid kit containing plenty of the basics for wound treatment."
	icon_state = "firstaid_large"
	item_state = "firstaid"
	w_class = WEIGHT_CLASS_BULKY
	throw_range = 6
	starts_with = list(
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
		/obj/item/storage/pill_bottle/inaprovaline = 1,
		/obj/item/storage/pill_bottle/perconol = 1,
		/obj/item/stack/medical/splint = 2,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "An emergency medical kit for treating burn-related injuries, whether they be from fires, chemicals, lasers, cigarettes - you name it. Warranty void if used on synthetics."
	icon_state = "firefirstaid"
	item_state = "firefirstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/burn = 4
	)

/obj/item/storage/firstaid/large/fire
	name = "large fire first-aid kit"
	desc = "A large emergency medical kit for treating a lot of burn-related injuries. Perhaps multiple people stood in the way of an emitter, or bathed in acid. In any case, this kit is there to treat it all."
	icon_state = "firefirstaid_large"
	item_state = "firefirstaid"
	starts_with = list(
		/obj/item/stack/medical/advanced/ointment = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dermaline = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/mortaphenyl = 4,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/toxin
	name = "toxin first-aid"
	desc = "An emergency medical kit for treating exposure to harmful toxins. Useful for phoron leaks, poisonings, or that one guy who accidentally ate k'ois."
	icon_state = "antitoxfirstaid"
	item_state = "antitoxfirstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/toxin = 4
	)

/obj/item/storage/firstaid/large/toxin
	name = "large toxin first-aid kit"
	desc = "A large emergency medical kit for treating severe toxin exposure cases. <b>This kit contains advanced medications to purge toxins and may result in side-effects to those they are administered to.</b>"
	icon_state = "antitoxfirstaid_large"
	item_state = "antitoxfirstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/toxin = 8,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/fluvectionem = 2,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation kit"
	desc = "An emergency medical kit for treating oxygen deprivation. There's a label on the box that says to make sure to only apply the kit <i>after</i> you have left the oxygen-deprived area."
	icon_state = "o2firstaid"
	item_state = "o2firstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 4
	)

/obj/item/storage/firstaid/large/o2
	name = "large oxygen deprivation kit"
	desc = "A large emergency medical kit for treating really bad cases of oxygen deprivation. Contains medication intended to restore breathing as well as oxygenation."
	icon_state = "o2firstaid_large"
	item_state = "o2firstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 8,
		/obj/item/reagent_containers/inhaler/pneumalin = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin_plus = 2,
	)

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "An advanced medical kit full of advanced medical things. The kits inside are more effective at treating injuries than your standard gauze-and-ointment."
	icon_state = "advfirstaid"
	item_state = "advfirstaid"
	starts_with = list(
		/obj/item/storage/pill_bottle/assorted = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint = 1,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/large/adv
	name = "large advanced first-aid kit"
	desc = "A large advanced medical kit full of many advanced medical kits. This one comes packed with advanced stabilization treatments."
	icon_state = "advfirstaid_large"
	item_state = "advfirstaid"
	starts_with = list(
		/obj/item/storage/pill_bottle/assorted = 2,
		/obj/item/stack/medical/advanced/bruise_pack = 5,
		/obj/item/stack/medical/advanced/ointment = 4,
		/obj/item/stack/medical/splint = 2,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "A military-grade combat medical kit containing rapidly-deliverable treatments for triage on the dangerous front line of a battle. Warranty void if used in a danger-free environment."
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

/obj/item/storage/firstaid/large/combat
	name = "advanced combat medical kit"
	desc = "A bulky, advanced military-grade combat medical kit containing rapidly-deliverable treatments for triage on the dangerous front line of a battle. Warranty void if used in a danger-free environment."
	icon_state = "bezerk_large"
	item_state = "bezerk"
	starts_with = list(
		/obj/item/reagent_containers/hypospray/combat/empty = 1,
		/obj/item/reagent_containers/glass/bottle/butazoline = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/mortaphenyl = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/sideeffectbgone = 1,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/fluvectionem = 1,
		/obj/item/stack/medical/splint = 1,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "A sterile medical kit containing tools for surgery on-the-go. Even comes with a foam lining so your delicate instruments don't break in transit. How considerate."
	icon_state = "purplefirstaid"
	item_state = "purplefirstaid"
	max_w_class = WEIGHT_CLASS_NORMAL	/// Saws are medium sized.
	can_hold = list(
		/obj/item/surgery,
		/obj/item/stack/medical,
		/obj/item/reagent_containers/inhaler,
		/obj/item/reagent_containers/syringe
	)
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
	make_exact_fit = TRUE

/obj/item/storage/firstaid/trauma
	name = "trauma first-aid kit"
	desc = "An emergency medical kit for treating trauma-related injuries. Useful for injuries stemming from sharp sticks, blunt sticks, and toolboxes."
	icon_state = "traumafirstaid"
	item_state = "traumafirstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/trauma = 4
	)

/obj/item/storage/firstaid/large/trauma
	name = "large trauma first-aid kit"
	desc = "An advanced trauma kit for treating serious injuries. This one is particularly specialized for trauma treatment and comes with advanced medication."
	icon_state = "traumafirstaid_large"
	item_state = "traumafirstaid"
	starts_with = list(
		/obj/item/stack/medical/advanced/bruise_pack = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/butazoline = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/mortaphenyl = 4,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/radiation
	name = "radiation first-aid kit"
	desc = "An emergency medical kit for treating radiation exposure. Useful for people who say their mouth tastes like iron before vomiting blood, or for people who are too 'hardcore' to wear a radiation suit next to a supermatter reactor."
	icon_state = "radfirstaid"
	item_state = "radfirstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/radiation = 4
	)

/obj/item/storage/firstaid/large/radiation
	name = "large radiation first-aid kit"
	desc = "An emergency medical kit for treating radiation exposure. Useful for people who say their mouth tastes like iron before vomiting blood, or for people who are too 'hardcore' to wear a radiation suit next to a supermatter reactor."
	icon_state = "radfirstaid_large"
	item_state = "radfirstaid"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/radiation = 6,
		/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dermaline = 1,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/stab // Generic first aid kit for mappers that covers all bases.
	name = "stabilization first-aid"
	desc = "A jack-of-all-trades medical kit containing a sampler platter of medical treatments. Useful for when someone is screwed up in more ways than you can count."
	icon_state = "firstaid_multi"
	item_state = "firstaid_multi"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/trauma = 1,
		/obj/item/storage/box/fancy/med_pouch/burn = 1,
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 1,
		/obj/item/storage/box/fancy/med_pouch/toxin = 1,
		/obj/item/storage/box/fancy/med_pouch/radiation = 1,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/large/stab // Generic first aid kit for mappers that covers all bases.
	name = "large stabilization first-aid"
	desc = "A big jack-of-all-trades medical kit containing a sizeable sampler platter of medical treatments. Useful for when someone is screwed up in more ways than you can count."
	icon_state = "firstaid_multi_large"
	item_state = "firstaid_multi"
	starts_with = list(
		/obj/item/storage/box/fancy/med_pouch/trauma = 2,
		/obj/item/storage/box/fancy/med_pouch/burn = 2,
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 2,
		/obj/item/storage/box/fancy/med_pouch/toxin = 2,
		/obj/item/storage/box/fancy/med_pouch/radiation = 2,
		/obj/item/device/healthanalyzer = 1
	)

/obj/item/storage/firstaid/sleekstab
	name = "slimline stabilization kit"
	desc = "A sleek and expensive looking medical kit containing a plethora of colorful autoinjectors. Read the labels!"
	icon_state = "firstaid_multi"
	item_state = "firstaid_multi"
	w_class = WEIGHT_CLASS_SMALL
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
	desc = "It's a small emergency medical kit for when you have small emergency medical needs."
	icon_state = "fak-light"
	item_state = "advfirstaid"
	storage_slots = 5
	w_class = WEIGHT_CLASS_SMALL
	max_w_class = WEIGHT_CLASS_SMALL
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
