
/obj/item/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "bun"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=12)
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("bun" = 3))

/obj/item/reagent_containers/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/reagent_containers/food/snacks/result = null
	// Bun + meatball = burger
	if(istype(W,/obj/item/reagent_containers/food/snacks/meatball))
		result = new /obj/item/reagent_containers/food/snacks/burger(src)
		to_chat(user, "You make a burger.")

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/reagent_containers/food/snacks/cutlet))
		result = new /obj/item/reagent_containers/food/snacks/burger(src)
		to_chat(user, "You make a burger.")

	//Bun + katsu = chickenfillet
	else if(istype(W,/obj/item/reagent_containers/food/snacks/chickenkatsu))
		result = new /obj/item/reagent_containers/food/snacks/chickenfillet(src)
		to_chat(user, "You make a chicken fillet sandwich.")

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/reagent_containers/food/snacks/sausage))
		result = new /obj/item/reagent_containers/food/snacks/hotdog(src)
		to_chat(user, "You make a hotdog.")

	else if(istype(W,/obj/item/reagent_containers/food/snacks/variable/mob))
		var/obj/item/reagent_containers/food/snacks/variable/mob/MF = W

		switch (MF.kitchen_tag)
			if ("rodent")
				result = new /obj/item/reagent_containers/food/snacks/burger/mouse(src)
				to_chat(user, "You make a ratburger!")

	else if(istype(W,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/csandwich/roll/R = new(get_turf(src))
		R.attackby(W,user)
		qdel(src)

	if (result)
		if (W.reagents)
			//Reagents of reuslt objects will be the sum total of both.  Except in special cases where nonfood items are used
			//Eg robot head
			result.reagents.clear_reagents()
			W.reagents.trans_to(result, W.reagents.total_volume)
			reagents.trans_to(result, reagents.total_volume)

		//If the bun was in your hands, the result will be too
		if (loc == user)
			user.drop_from_inventory(src) //This has to be here in order to put the pun in the proper place
			user.put_in_hands(result)

		qdel(W)
		qdel(src)

/obj/item/reagent_containers/food/snacks/bunbun
	name = "\improper Bun Bun"
	desc = "A small bread monkey fashioned from two burger buns."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "bunbun"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("bun" = 4))

/obj/item/reagent_containers/food/snacks/sliceable/bread
	name = "bread"
	desc = "Some plain old Earthen bread."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "bread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice
	slices_num = 8
	filling_color = "#FFE396"
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 15, /singleton/reagent/nutriment/protein = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 6))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/breadslice
	name = "bread slice"
	desc = "A slice of home."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#D27332"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=4)

/obj/item/reagent_containers/food/snacks/breadslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 2))

/obj/item/reagent_containers/food/snacks/sliceable/tofubread
	name = "tofubread"
	desc = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "tofubread"
	slice_path = /obj/item/reagent_containers/food/snacks/tofubreadslice
	slices_num = 5
	filling_color = "#F7FFE0"
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 30)
	reagent_data = list(/singleton/reagent/nutriment = list("tofu" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/tofubreadslice
	name = "tofubread slice"
	desc = "A slice of delicious tofubread."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#F7FFE0"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/snacks/tofubreadslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("tofu" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread
	name = "cream cheese bread"
	desc = "Yum yum yum!"
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "creamcheesebread"
	slice_path = /obj/item/reagent_containers/food/snacks/creamcheesebreadslice
	slices_num = 5
	filling_color = "#FFF896"
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein/cheese = 15)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 6, "cream" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/creamcheesebreadslice
	name = "cream cheese bread slice"
	desc = "A slice of yum!"
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFF896"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/snacks/creamcheesebreadslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/nutriment/protein/cheese = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 3, "cream" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "meatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/meatbreadslice
	slices_num = 5
	filling_color = "#FF7575"
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/nutriment/protein = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatbreadslice
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FF7575"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/snacks/meatbreadslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein = 4, /singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra Heretical."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "xenomeatbread"
	slice_path = /obj/item/reagent_containers/food/snacks/xenomeatbreadslice
	slices_num = 5
	filling_color = "#8AFF75"
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/nutriment/protein = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/xenomeatbreadslice
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8AFF75"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=13)

/obj/item/reagent_containers/food/snacks/xenomeatbreadslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/bananabread
	name = "banana-nut bread"
	desc = "A heavenly and filling treat."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "bananabread"
	slice_path = /obj/item/reagent_containers/food/snacks/bananabreadslice
	slices_num = 5
	filling_color = "#EDE5AD"
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 20, /singleton/reagent/drink/banana = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bananabreadslice
	name = "banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=8)

/obj/item/reagent_containers/food/snacks/bananabreadslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/drink/banana = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/baguette
	name = "baguette"
	desc = "Bon appetit!"
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "baguette"
	filling_color = "#E3D796"
	center_of_mass = list("x"=18, "y"=12)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/blackpepper = 1, /singleton/reagent/sodiumchloride = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("french bread" = 6))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/croissant
	name = "croissant"
	desc = "True french cuisine."
	filling_color = "#E3D796"
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "croissant"

	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("french bread" = 4))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/honeybun
	name = "honey bun"
	desc = "A sticky pastry bun glazed with honey."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "honeybun"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/honey = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("pastry" = 1))
	bitesize = 3
	filling_color = "#A66829"

/obj/item/reagent_containers/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "flatbread"
	bitesize = 2
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 3))
	filling_color = "#B89F61"

/obj/item/reagent_containers/food/snacks/poppypretzel
	name = "poppy pretzel"
	desc = "It's all twisted up!"
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "poppypretzel"
	bitesize = 2
	filling_color = "#916E36"
	center_of_mass = list("x"=16, "y"=10)
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("poppy seeds" = 2, "pretzel" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/bagel
	name = "bagel"
	desc = "Goes great with cream cheese and smoked salmon."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "bagel"
	filling_color = "#F1B45E"
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("toasty dough" = 2))
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cracker
	name = "cracker"
	desc = "It's a salted cracker."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "cracker"
	filling_color = "#F5DEB8"
	center_of_mass = list("x"=17, "y"=6)
	reagents_to_add = list(/singleton/reagent/nutriment = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("salt" = 1, "cracker" = 2))

/obj/item/reagent_containers/food/snacks/stuffing
	name = "stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "stuffing"
	filling_color = "#C9AC83"

	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("dryness" = 2, "bread" = 2))
	bitesize = 1

//================================
// Toasts and Toasted Sandwiches
//================================
/obj/item/reagent_containers/food/snacks/toast
	name = "toasted bread"
	desc = "Plain, but consistent and reliable toast."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "toast"
	item_state = "toast"
	slot_flags = SLOT_MASK
	contained_sprite = TRUE
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("toasted bread" = 2))
	bitesize = 1

/obj/item/reagent_containers/food/snacks/twobread
	name = "two bread"
	desc = "It is very bitter and winy."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "twobread"
	filling_color = "#DBCC9A"
	center_of_mass = list("x"=15, "y"=12)
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("sourness" = 2, "bread" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jelliedtoast
	name = "jellied toast"
	desc = "A slice of bread covered with delicious jam."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "jellytoast"
	item_state = "toast"
	slot_flags = SLOT_MASK
	contained_sprite = TRUE
	trash = /obj/item/trash/plate
	filling_color = "#B572AB"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/nutriment = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("toasted bread" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jelliedtoast/cherry/reagents_to_add = list(/singleton/reagent/nutriment/cherryjelly = 5)

/obj/item/reagent_containers/food/snacks/jelliedtoast/slime/reagents_to_add = list(/singleton/reagent/slimejelly = 5)

/obj/item/reagent_containers/food/snacks/pbtoast
	name = "peanut butter toast"
	desc = "A slice of bread covered with appetizing peanut butter."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "pbtoast"
	item_state = "toast"
	slot_flags = SLOT_MASK
	contained_sprite = TRUE
	trash = /obj/item/trash/plate
	filling_color = "#B572AB"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/nutriment = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("toasted bread" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/egginthebasket
	name = "egg in the basket"
	desc = "Egg in the basket, also known as <i>egg in a hole</i>, or <i>bullseye egg</i>, or <i>egg in a nest</i>, or <i>framed egg</i>, or..."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "egginthebasket"
	item_state = "toast"
	slot_flags = SLOT_MASK
	contained_sprite = TRUE
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("toasted bread" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/garlicbread
	name = "garlic bread"
	desc = "Delicious garlic bread, but you probably shouldn't eat it for every meal."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "garlicbread"
	item_state = "toast"
	slot_flags = SLOT_MASK
	contained_sprite = TRUE
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/garlicsauce = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("toasted bread" = 2, "flavorful butter" = 3))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/honeytoast
	name = "piece of honeyed toast"
	desc = "For those who like their breakfast sweet."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "honeytoast"
	item_state = "toast"
	slot_flags = SLOT_MASK
	contained_sprite = TRUE
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	center_of_mass = list("x"=16, "y"=9)
	reagents_to_add = list(/singleton/reagent/nutriment = 1, /singleton/reagent/nutriment/honey = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 3))
	bitesize = 4

/obj/item/reagent_containers/food/snacks/fairy_bread
	name = "fairy bread"
	desc = "A piece of bread covered in sprinkles. Absolutely delicious!"
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "fairy_bread"
	item_state = "toast"
	slot_flags = SLOT_MASK
	contained_sprite = TRUE
	filling_color = "#FEFECC"
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/cheese_cracker
	name = "supreme cheese toast"
	desc = "A piece of toast lathered with butter, cheese, spices, and herbs."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "cheese_cracker"
	item_state = "toast"
	slot_flags = SLOT_MASK
	contained_sprite = TRUE
	reagents_to_add = list(/singleton/reagent/nutriment = 8)
	reagent_data = list(/singleton/reagent/nutriment = list("cheese toast" = 8))
	filling_color = "#FFF97D"

/obj/item/reagent_containers/food/snacks/sandwich
	name = "sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 3, "cheese" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/toastedsandwich
	name = "toasted sandwich"
	desc = "Now if you only had a pepper bar."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	center_of_mass = list("x"=16, "y"=4)
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 3, /singleton/reagent/carbon = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("toasted bread" = 3, "cheese" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/grilledcheese
	name = "grilled cheese sandwich"
	desc = "Goes great with Tomato soup!"
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("toasted bread" = 3, "cheese" = 3))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/reubensandwich
	name = "reuben sandwich"
	desc = "A toasted sandwich packed with savory, meat and sour goodness!"
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "reubensandwich"
	filling_color = "#BF8E60"
	reagents_to_add = list(/singleton/reagent/nutriment = 8, /singleton/reagent/nutriment/protein = 4, /singleton/reagent/nutriment/ketchup = 2, /singleton/reagent/nutriment/mayonnaise = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("a savory blend of sweet and salty ingredients" = 6, "toasted bread" = 2))
	bitesize = 3
	trash = /obj/item/trash/plate

/obj/item/reagent_containers/food/snacks/jellysandwich
	name = "jelly sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9E3A78"
	center_of_mass = list("x"=16, "y"=8)
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/jellysandwich/slime/reagents_to_add = list(/singleton/reagent/slimejelly = 5)

/obj/item/reagent_containers/food/snacks/jellysandwich/cherry/reagents_to_add = list(/singleton/reagent/nutriment/cherryjelly = 5)

/obj/item/reagent_containers/food/snacks/pbjsandwich
	name = "pbj sandwich"
	desc = "A staple classic lunch of gooey jelly and peanut butter."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "pbjsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#BB6A54"
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/blt
	name = "BLT"
	desc = "Bacon, lettuce, tomatoes. The perfect lunch."
	icon = 'icons/obj/item/reagent_containers/food/bread.dmi'
	icon_state = "blt"
	filling_color = "#D63C3C"
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("bread" = 4))
	bitesize = 2

