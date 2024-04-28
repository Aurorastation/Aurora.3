/obj/random/medical
	name = "random medical item"
	desc = "This is a random medical item."
	icon = 'icons/obj/item/stacks/medical.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 25
	problist = list(
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
		/obj/item/stack/medical/advanced/bruise_pack = 2,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint = 1,
		/obj/item/bodybag = 2,
		/obj/item/bodybag/cryobag = 1,
		/obj/item/auto_cpr = 1,
		/obj/item/storage/pill_bottle/kelotane = 3,
		/obj/item/storage/pill_bottle/bicaridine = 3,
		/obj/item/storage/pill_bottle/antitox = 3,
		/obj/item/storage/pill_bottle/mortaphenyl = 2,
		/obj/item/storage/pill_bottle/antiparasitic = 1,
		/obj/item/storage/pill_bottle/asinodryl = 1,
		/obj/item/storage/pill_bottle/steramycin =1,
		/obj/item/reagent_containers/syringe/dylovene = 3,
		/obj/item/reagent_containers/syringe/inaprovaline = 3,
		/obj/item/reagent_containers/syringe/antiparasitic = 1,
		/obj/item/reagent_containers/syringe/antibiotic = 2,
		/obj/item/reagent_containers/syringe/fluvectionem = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/coagzolug = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/hyronalin = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/sideeffectbgone = 1,
		/obj/item/reagent_containers/inhaler/pneumalin = 1,
		/obj/item/reagent_containers/inhaler/peridaxon = 1,
		/obj/item/stack/nanopaste = 1
	)

/obj/random/firstaid
	name = "random first aid kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage/firstaid.dmi'
	icon_state = "firstaid"
	problist = list(
		/obj/item/storage/firstaid/regular = 4,
		/obj/item/storage/firstaid/trauma = 3,
		/obj/item/storage/firstaid/toxin = 3,
		/obj/item/storage/firstaid/o2 = 3,
		/obj/item/storage/firstaid/fire = 3,
		/obj/item/storage/firstaid/radiation = 3,
		/obj/item/storage/firstaid/stab = 2,
		/obj/item/storage/firstaid/adv = 2,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/empty = 2
	)
