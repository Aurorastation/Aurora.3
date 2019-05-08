/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel/fatshouter
	name = "oily cheese wheel"
	desc = "A big wheel of oily cheese."
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cheesewedge/fatshouter
	slices_num = 8
	center_of_mass = list("x"=16, "y"=10)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesewedge/fatshouter
	name = "oily cheese wedge"
	desc = "An oily wedge of cheese."
	bitesize = 2
	center_of_mass = list("x"=16, "y"=10)

/datum/chemical_reaction/butter/fatshouter
	name = "Butter"
	id = "butter"
	result = null
	required_reagents = list("fatshouter_milk" = 20, "sodiumchloride" = 3)
	result_amount = 1