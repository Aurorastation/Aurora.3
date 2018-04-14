/obj/item/weapon/reagent_containers/food/snacks/sliceable/pie/pumpkin
	name = "pumpkin pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/pie/pumpkin
	slices_num = 5
	filling_color = "#F5B951"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("pie" = 5, "cream" = 5, "pumpkin" = 5)
	nutriment_amt = 15

/obj/item/weapon/reagent_containers/food/snacks/pie/pumpkin
	name = "pumpkin pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)

/obj/item/weapon/reagent_containers/food/snacks/pie/pumpkin/filled
	nutriment_desc = list("pie" = 2, "cream" = 2, "pumpkin" = 2)
	nutriment_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pie/keylime
	name = "key lime pie"
	desc = "A tart, sweet dessert. What's a key lime, anyway?"
	icon_state = "keylimepie"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/pie/keylime
	slices_num = 5
	filling_color = "#F5B951"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("pie" = 10, "cream" = 10, "lime" = 15)
	nutriment_amt = 16

/obj/item/weapon/reagent_containers/food/snacks/pie/keylime
	name = "slice of key lime pie"
	desc = "A slice of tart pie, with whipped cream on top."
	icon_state = "keylimepieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/weapon/reagent_containers/food/snacks/pie/keylime/filled
	nutriment_desc = list("pie" = 5, "cream" = 5, "lime" = 5)
	nutriment_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pie/quiche
	name = "quiche"
	desc = "Real men eat this, contrary to popular belief."
	icon_state = "quiche"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/pie/quiche
	slices_num = 5
	filling_color = "#F5B951"
	center_of_mass = list("x"=16, "y"=10)
	nutriment_desc = list("pie" = 5, "cheese" = 5)
	nutriment_amt = 10

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pie/quiche/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 10)

/obj/item/weapon/reagent_containers/food/snacks/pie/quiche
	name = "slice of quiche"
	desc = "A slice of delicious quiche. Eggy, cheesy goodness."
	icon_state = "quicheslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 3
	center_of_mass = list("x"=16, "y"=12)

/obj/item/weapon/reagent_containers/food/snacks/pie/quiche/filled
	nutriment_desc = list("pie" = 2)
	nutriment_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/pie/quiche/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)


//TODO: MAKE SLICEABLE
/obj/item/weapon/reagent_containers/food/snacks/pie/apple
	name = "apple pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon_state = "applepie"
	filling_color = "#E0EDC5"
	center_of_mass = list("x"=16, "y"=13)
	nutriment_desc = list("sweetness" = 2, "apple" = 2, "pie" = 2)
	nutriment_amt = 4
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/pie/cherry
	name = "cherry pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	filling_color = "#FF525A"
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("sweetness" = 2, "cherry" = 2, "pie" = 2)
	nutriment_amt = 4
	bitesize = 3