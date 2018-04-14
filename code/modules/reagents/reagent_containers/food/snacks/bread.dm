//BREAD

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread
	name = "bread"
	icon_state = "Some plain old Earthen bread."
	icon_state = "bread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/bread
	slices_num = 8
	filling_color = "#FFE396"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 6)
	nutriment_amt = 15
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/Initialize()
	. = ..()
	reagents.add_reagent("protein", 5)

/obj/item/weapon/reagent_containers/food/snacks/bread
	name = "bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#D27332"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=4)

/obj/item/weapon/reagent_containers/food/snacks/bread/filled
	nutriment_desc = list("bread" = 2)
	nutriment_amt = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/creamcheese
	name = "cream cheese bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/bread/creamcheese
	slices_num = 5
	filling_color = "#FFF896"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 6, "cream" = 3)
	nutriment_amt = 5
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/creamcheese/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 15)

/obj/item/weapon/reagent_containers/food/snacks/bread/creamcheese
	name = "cream cheese bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFF896"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/bread/creamcheese/filled
	nutriment_desc = list("bread" = 3, "cream" = 2)
	nutriment_amt = 1
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bread/creamcheese/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/meat
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman."
	icon_state = "meatbread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/bread/meat
	slices_num = 5
	filling_color = "#FF7575"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/meat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 20)

/obj/item/weapon/reagent_containers/food/snacks/bread/meat
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FF7575"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/bread/meat/filled
	nutriment_desc = list("bread" = 5)
	nutriment_amt = 2
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bread/meat/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)
	reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/xeno
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/bread/xeno
	slices_num = 5
	filling_color = "#8AFF75"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 10
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/xeno/Initialize()
	. = ..()
	reagents.add_reagent("protein", 20)

/obj/item/weapon/reagent_containers/food/snacks/bread/xeno
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8AFF75"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/bread/xeno/filled
	nutriment_desc = list("bread" = 5)
	nutriment_amt = 2
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bread/xeno/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 4)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/banana
	name = "banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/bread/banana
	slices_num = 5
	filling_color = "#EDE5AD"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("bread" = 10)
	nutriment_amt = 20
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/banana/Initialize()
	. = ..()
	reagents.add_reagent("banana", 20)

/obj/item/weapon/reagent_containers/food/snacks/bread/banana
	name = "banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=8)

/obj/item/weapon/reagent_containers/food/snacks/bread/banana/filled
	nutriment_desc = list("bread" = 5)
	nutriment_amt = 4
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bread/banana/filled/Initialize()
	. = ..()
	reagents.add_reagent("banana", 4)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread/tofu
	name = "tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/bread/tofu
	slices_num = 5
	filling_color = "#F7FFE0"
	center_of_mass = list("x"=16, "y"=9)
	nutriment_desc = list("tofu" = 10)
	nutriment_amt = 30
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bread/tofu
	name = "tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#F7FFE0"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/bread/tofu/filled
	nutriment_desc = list("tofu" = 5)
	nutriment_amt = 6
	bitesize = 2