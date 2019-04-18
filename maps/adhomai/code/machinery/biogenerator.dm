/obj/machinery/biogenerator/adhomai
	name = "biogenerator"
	desc = "A commercial biogenerator. Lower powered but produces the basic array of needed gardening tools and equipment."
	biorecipies = list(
		"ez" = list(
			name = "E-Z-Nutrient (60u)",
			class = "Fertilizer",
			object = /obj/item/weapon/reagent_containers/glass/fertilizer/ez,
			cost = 25,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"plant bag" = list(
			name = "Plant Bag",
			class = "Items",
			object = /obj/item/weapon/storage/bag/plants,
			cost = 50,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"bruise_pack" = list(
			name = "Bruise Pack",
			class = "Items",
			object = /obj/item/stack/medical/bruise_pack/adhomai,
			cost = 200,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"ointment" = list(
			name = "Burn Ointment",
			class = "Items",
			object = /obj/item/stack/medical/ointment/adhomai,
			cost = 200,
			amount = list(1,2,3,4,5),
			emag = 0
		),
		"cardboard" = list(
			name = "Cardboard",
			class = "Construction",
			object = /obj/item/stack/material/cardboard,
			cost = 50,
			amount = list(1,5,10,25,50),
			emag = 0
		)

	)