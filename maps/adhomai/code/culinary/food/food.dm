/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel/fatshouter
	name = "oily cheese wheel"
	desc = "A big wheel of oily cheese. It is a dull white color."
	icon_state = "cheesewheel"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cheesewedge/fatshouter
	slices_num = 8
	filling_color = "#fffff0"
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesewedge/fatshouter
	name = "oily cheese wedge"
	desc = "An oily wedge of cheese. It is a dull white color."
	icon_state = "cheesewedge"
	filling_color = "#fffff0"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=10)

/obj/item/weapon/reagent_containers/food/snacks/coarsesalt
	name = "coarse salt"
	desc = "A lot of coarse salt."
	filling_color = "#FFFFFF"
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("sodiumchloride", 5)
	bitesize = 3
	w_class = 1

/obj/item/weapon/reagent_containers/food/snacks/coarsesalt/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 5)

/datum/chemical_reaction/butter/fatshouter
	name = "Butter"
	id = "butter"
	result = null
	required_reagents = list("fatshouter_milk" = 20, "sodiumchloride" = 3)
	result_amount = 1