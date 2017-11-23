/obj/item/weapon/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	center_of_mass = list("x"=16, "y"=14)
	cooked_icon = "meatstake"

/obj/item/weapon/reagent_containers/food/snacks/meat/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("triglyceride", 2)
	src.bitesize = 1.5

/obj/item/weapon/reagent_containers/food/snacks/meat/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/material/knife))
		new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(src)
		user << "You cut the meat into thin strips."
		qdel(src)
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/meat/cook()

	if (!isnull(cooked_icon))
		icon_state = cooked_icon
		flat_icon = null //Force regenating the flat icon for coatings, since we've changed the icon of the thing being coated
	..()

	if (name == initial(name))
		name = "cooked [name]"

/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

// TODO cancelled, subtypes are fine. recipes use istype checks
/obj/item/weapon/reagent_containers/food/snacks/meat/human

/obj/item/weapon/reagent_containers/food/snacks/meat/bug
	filling_color = "#E6E600"
/obj/item/weapon/reagent_containers/food/snacks/meat/bug/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("phoron", 27)
	src.bitesize = 1.5

/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/weapon/reagent_containers/food/snacks/meat/chicken
	name = "chicken"
	icon_state = "chickenbreast"
	cooked_icon = "chickenbreast_cooked"
	filling_color = "#BBBBAA"

/obj/item/weapon/reagent_containers/food/snacks/meat/chicken/Initialize()
	. = ..()
	reagents.remove_reagent("triglyceride", INFINITY)
	//Chicken is low fat. Less total calories than other meats

/obj/item/weapon/reagent_containers/food/snacks/meat/undead
	name = "rotten meat"
	desc = "A slab of rotten meat."
	icon_state = "shadowmeat"
	health = 180
	filling_color = "#FF1C1C"

/obj/item/weapon/reagent_containers/food/snacks/meat/undead/Initialize()
	. = ..()
	reagents.add_reagent("protein", 6)
	reagents.add_reagent("undead_ichor", 5)
