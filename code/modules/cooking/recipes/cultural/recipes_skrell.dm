//Skrell foods
/decl/recipe/lortl
	appliance = OVEN
	fruit = list("q'lort slice" = 1)
	reagents = list(/decl/reagent/sodiumchloride = 1)
	result = /obj/item/reagent_containers/food/snacks/lortl
	reagent_mix = RECIPE_REAGENT_REPLACE

/decl/recipe/lortl_dry
	appliance = MIX
	fruit = list("dried q'lort slice" = 1)
	reagents = list(/decl/reagent/sodiumchloride = 1)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/lortl

/decl/recipe/xuqqil
	appliance = OVEN
	fruit = list("plumphelmet" = 1)
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/fish/mollusc
	)
	result = /obj/item/reagent_containers/food/snacks/xuqqil

/decl/recipe/zantiri
	appliance = SAUCEPAN | POT
	fruit = list("guami" = 2, "eki" = 1)
	reagents = list(/decl/reagent/water = 10)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/zantiri

/decl/recipe/qilvo
	appliance = SAUCEPAN | POT
	fruit = list("seaweed" = 2)
	reagents = list(/decl/reagent/water = 10, /decl/reagent/drink/milk/cream = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/fish/mollusc
	)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/soup/qilvo

//Neaera recipes.
/decl/recipe/neaerastew
	appliance = POT
	fruit = list("guami" = 2, "eki" = 2)
	reagents = list(/decl/reagent/drink/dynjuice = 10)
	items = list(/obj/item/reagent_containers/food/snacks/meat/neaera)
	result = /obj/item/reagent_containers/food/snacks/stew/neaera

/decl/recipe/neaerakabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/neaera,
		/obj/item/organ/internal/kidneys/skrell/neaera
	)
	result = /obj/item/reagent_containers/food/snacks/neaerakabob

/decl/recipe/neaeraloaf
	appliance = OVEN
	reagents = list(/decl/reagent/drink/milk/cream = 10)
	items = list(/obj/item/organ/internal/brain/skrell/neaera)
	result = /obj/item/reagent_containers/food/snacks/neaeraloaf

/decl/recipe/neaeracandy
	appliance = OVEN
	reagents = list(/decl/reagent/drink/milk/cream = 5)
	reagent_mix = RECIPE_REAGENT_REPLACE
	items = list(
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/organ/internal/eyes/skrell/neaera
	)
	result = /obj/item/reagent_containers/food/snacks/chipplate/neaeracandy

/decl/recipe/fjylozynboiled
	appliance = SAUCEPAN | POT
	fruit = list("fjylozyn" = 1)
	reagents = list(/decl/reagent/water = 5)
	result = /obj/item/reagent_containers/food/snacks/fjylozynboiled

/decl/recipe/gnaqmi
	appliance = FRYER
	items = list(
		/obj/item/reagent_containers/food/snacks/fjylozynboiled,
		/obj/item/reagent_containers/food/snacks/fjylozynboiled,
		/obj/item/organ/internal/liver/skrell/neaera
	)
	result = /obj/item/reagent_containers/food/snacks/gnaqmi