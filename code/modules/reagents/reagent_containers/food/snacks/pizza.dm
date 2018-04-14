/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza
	name = "tomato pizza"
	desc = "Is this even pizza?"
	icon_state = "tomatopizza"
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10)
	nutriment_amt = 20
	slices_num = 6
	bitesize = 2
	filling_color = "#BAA14C"

/obj/item/weapon/reagent_containers/food/snacks/pizza
	name = "tomato pizza slice"
	desc = "A slice of pizza."
	icon_state = "tomatopizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/pizza/filled
	nutriment_desc = list("pizza crust" = 5, "tomato" = 5)
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "margherita pizza"
	desc = "The golden standard of pizzas."
	icon_state = "pizzamargherita"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 35

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 5)
	reagents.add_reagent("tomatojuice", 6)

/obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	name = "margherita pizza slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/margheritaslice/filled
	nutriment_desc = list("pizza crust" = 5, "tomato" = 5)
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/margheritaslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 1)
	reagents.add_reagent("tomatojuice", 2)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "meatpizza"
	desc = "A pizza with meat topping."
	icon_state = "meatpizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_amt = 10
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza/Initialize()
	. = ..()
	reagents.add_reagent("protein", 44)
	reagents.add_reagent("cheese", 10)
	reagents.add_reagent("tomatojuice", 6)

/obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	name = "meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice/filled
	nutriment_desc = list("pizza crust" = 5, "tomato" = 5)
	nutriment_amt = 2

/obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("protein", 7)
	reagents.add_reagent("cheese", 2)
	reagents.add_reagent("tomatojuice", 2)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	name = "mushroompizza"
	desc = "Very special pizza."
	icon_state = "mushroompizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "tomato" = 10, "mushroom" = 10)
	nutriment_amt = 35
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 5)

/obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice
	name = "mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice/filled
	nutriment_desc = list("pizza crust" = 5, "tomato" = 5, "mushroom" = 5)
	nutriment_amt = 5
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 1)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "vegetable pizza"
	desc = "No one of Tomato Sapiens were harmed during making this pizza."
	icon_state = "vegetablepizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 10, "eggplant" = 5, "carrot" = 5, "corn" = 5)
	nutriment_amt = 25
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 6)
	reagents.add_reagent("imidazoline", 12)

/obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	name = "vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon_state = "vegetablepizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice/filled
	nutriment_desc = list("pizza crust" = 5, "eggplant" = 5, "carrot" = 5, "corn" = 5)
	nutriment_amt = 4

/obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice/filled/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 2)
	reagents.add_reagent("imidazoline", 2)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/crunch
	name = "pizza crunch"
	desc = "This was once a normal pizza, but it has been coated in batter and deep-fried. Whatever toppings it once had are a mystery, but they're still under there, somewhere..."
	icon_state = "pizzacrunch"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/pizzacrunchslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	nutriment_desc = list("pizza crust" = 15)
	nutriment_amt = 25
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/crunch/Initialize()
	. = ..()
	reagents.add_reagent("batter", 6)
	coating = reagents.get_reagent("batter")
	reagents.add_reagent("oil", 4)

/obj/item/weapon/reagent_containers/food/snacks/pizzacrunchslice
	name = "pizza crunch"
	desc = "A little piece of a heart attack. It's toppings are a mystery, hidden under batter"
	icon_state = "pizzacrunchslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)
	nutriment_desc = list("pizza crust" = 5)
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/pizzacrunchslice/Initialize()
	. = ..()
	reagents.add_reagent("batter", 2)
	coating = reagents.get_reagent("batter")
	reagents.add_reagent("oil", 1)

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food.dmi'
	icon_state = "pizzabox1"

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/pizza // Content pizza
	var/list/boxes = list() // If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/update_icon()
	cut_overlays()

	// Set appropriate description
	if( open && pizza )
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if( boxes.len > 0 )
		desc = "A pile of boxes suited for pizzas. There appears to be [boxes.len + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if( boxtag != "" )
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/image/pizzaimg = image(icon, icon_state = pizza.icon_state)
			pizzaimg.pixel_y = -3
			add_overlay(pizzaimg)

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( boxes.len > 0 )
			var/obj/item/pizzabox/topbox = boxes[boxes.len]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			var/image/tagimg = image(icon, icon_state = "pizzabox_tag")
			tagimg.pixel_y = boxes.len * 3
			add_overlay(tagimg)

	icon_state = "pizzabox[boxes.len+1]"

/obj/item/pizzabox/attack_hand( mob/user as mob )

	if( open && pizza )
		user.put_in_hands( pizza )

		user << "<span class='warning'>You take \the [src.pizza] out of \the [src].</span>"
		src.pizza = null
		update_icon()
		return

	if( boxes.len > 0 )
		if( user.get_inactive_hand() != src )
			..()
			return

		var/obj/item/pizzabox/box = boxes[boxes.len]
		boxes -= box

		user.put_in_hands( box )
		user << "<span class='warning'>You remove the topmost [src] from your hand.</span>"
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self( mob/user as mob )

	if( boxes.len > 0 )
		return

	open = !open

	if( open && pizza )
		ismessy = 1

	update_icon()

/obj/item/pizzabox/attackby( obj/item/I as obj, mob/user as mob )
	if( istype(I, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = I

		if( !box.open && !src.open )
			// Make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if( (boxes.len+1) + boxestoadd.len <= 5 )
				user.drop_item()

				box.loc = src
				box.boxes = list() // Clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				user << "<span class='warning'>You put \the [box] ontop of \the [src]!</span>"
			else
				user << "<span class='warning'>The stack is too high!</span>"
		else
			user << "<span class='warning'>Close \the [box] first!</span>"

		return

	if( istype(I, /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/) ) // Long ass fucking object name

		if( src.open )
			user.drop_item()
			I.loc = src
			src.pizza = I

			update_icon()

			user << "<span class='warning'>You put \the [I] in \the [src]!</span>"
		else
			user << "<span class='warning'>You try to push \the [I] through the lid but it doesn't work!</span>"
		return

	if( istype(I, /obj/item/weapon/pen/) )

		if( src.open )
			return

		var/t = sanitize(input("Enter what you want to add to the tag:", "Write", null, null) as text, 30)

		var/obj/item/pizzabox/boxtotagto = src
		if( boxes.len > 0 )
			boxtotagto = boxes[boxes.len]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return
	..()

/obj/item/pizzabox/margherita/New()
	pizza = new /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/vegetable/New()
	pizza = new /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom/New()
	pizza = new /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat/New()
	pizza = new /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "Meatlover's Supreme"