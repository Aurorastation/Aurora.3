/obj/item/reagent_containers/food/snacks/tortilla
	name = "tortilla"
	desc = "A thin, flour-based tortilla that can be used in a variety of dishes, or can be served as is."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "tortilla"
	bitesize = 3
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla" = 1))
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	filling_color = "#A66829"

/obj/item/reagent_containers/food/snacks/enchiladas
	name = "enchiladas"
	desc = "Viva La Mexico!"
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#A36A1F"
	center_of_mass = list("x"=16, "y"=13)
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein = 6, /singleton/reagent/capsaicin = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla" = 3, "corn" = 3))
	bitesize = 4

// Tacos
//=========================
/obj/item/reagent_containers/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "taco"
	bitesize = 3
	center_of_mass = list("x"=21, "y"=12)
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/nutriment/protein = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("taco shell with cheese"))
	filling_color = "#EDE0AF"

/obj/item/reagent_containers/food/snacks/fish_taco
	name = "fish taco"
	desc = "A questionably cooked fish taco decorated with herbs, spices, and special sauce."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "fish_taco"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/seafood = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("flatbread" = 3))
	filling_color = "#FFF97D"


//chips
/obj/item/reagent_containers/food/snacks/chip
	name = "chip"
	desc = "A portion sized chip good for dipping."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "chip"
	var/bitten_state = "chip_half"
	bitesize = 1
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("nacho chips" = 1))
	filling_color = "#EDF291"


/obj/item/reagent_containers/food/snacks/chip/on_consume(mob/M as mob)
	if(reagents && reagents.total_volume)
		icon_state = bitten_state
	. = ..()

/obj/item/reagent_containers/food/snacks/chip/salsa
	name = "salsa chip"
	desc = "A portion sized chip good for dipping. This one has salsa on it."
	icon_state = "chip_salsa"
	bitten_state = "chip_half"
	bitesize = 2
	filling_color = "#FF4D36"

/obj/item/reagent_containers/food/snacks/chip/guac
	name = "guac chip"
	desc = "A portion sized chip good for dipping. This one has guac on it."
	icon_state = "chip_guac"
	bitten_state = "chip_half"
	bitesize = 2
	filling_color = "#35961D"

/obj/item/reagent_containers/food/snacks/chip/cheese
	name = "cheese chip"
	desc = "A portion sized chip good for dipping. This one has cheese sauce on it."
	icon_state = "chip_cheese"
	bitten_state = "chip_half"
	bitesize = 2
	filling_color = "#FFF454"

/obj/item/reagent_containers/food/snacks/chip/sourcream
	name = "sour cream chip"
	desc = "A portion sized chip good for dipping. This one has sour cream on it."
	icon_state = "chip_sourcream"
	bitten_state = "chip_half_sourcream"
	bitesize = 2
	filling_color = "#e4e4e4"

/obj/item/reagent_containers/food/snacks/chip/tajhummus
	name = "hummus chip"
	desc = "A portion sized chip good for dipping. This one has hummus on it."
	icon_state = "chip_hummus"
	bitten_state = "chip_half_hummus"
	bitesize = 2
	filling_color = "#cca628"

/obj/item/reagent_containers/food/snacks/chip/hummus
	name = "hummus chip"
	desc = "A portion sized chip good for dipping. This one has hummus on it."
	icon_state = "chip_hummus"
	bitten_state = "chip_half_hummus"
	bitesize = 2
	filling_color = "#cca628"

/obj/item/reagent_containers/food/snacks/chip/nacho
	name = "nacho chip"
	desc = "A nacho ship stray from a plate of cheesy nachos."
	icon_state = "chip_nacho"
	bitten_state = "chip_half"
	bitesize = 2
	filling_color = "#FFF454"

/obj/item/reagent_containers/food/snacks/chip/nacho/salsa
	name = "nacho chip"
	desc = "A stray nacho chip from a plate of cheesy nachos. This one has salsa on it."
	icon_state = "chip_nacho_salsa"
	bitten_state = "chip_half"
	bitesize = 2
	filling_color = "#FF4D36"

/obj/item/reagent_containers/food/snacks/chip/nacho/guac
	name = "nacho chip"
	desc = "A stray nacho chip from a plate of cheesy nachos. This one has guac on it."
	icon_state = "chip_nacho_guac"
	bitten_state = "chip_half"
	bitesize = 2
	filling_color = "#35961D"

/obj/item/reagent_containers/food/snacks/chip/nacho/cheese
	name = "nacho chip"
	desc = "A stray nacho chip from a plate of cheesy nachos. This one has extra cheese on it."
	icon_state = "chip_nacho_cheese"
	bitten_state = "chip_half"
	bitesize = 2
	filling_color = "#FFF454"

/obj/item/reagent_containers/food/snacks/chip/nacho/sourcream
	name = "nacho chip"
	desc = "A stray nacho chip from a plate of cheesy nachos. This one has extra sour cream on it."
	icon_state = "chip_nacho_sourcream"
	bitten_state = "chip_half_sourcream"
	bitesize = 2
	filling_color = "#e4e4e4"

/obj/item/reagent_containers/food/snacks/chip/nacho/tajhummus
	name = "nacho chip"
	desc = "A stray nacho chip from a plate of cheesy nachos. This one has extra hummus on it."
	icon_state = "chip_nacho_hummus"
	bitten_state = "chip_half_hummus"
	bitesize = 2
	filling_color = "#cca628"

/obj/item/reagent_containers/food/snacks/chip/nacho/hummus
	name = "nacho chip"
	desc = "A stray nacho chip from a plate of cheesy nachos. This one has extra hummus on it."
	icon_state = "chip_nacho_hummus"
	bitten_state = "chip_half_hummus"
	bitesize = 2
	filling_color = "#cca628"

// chip plates
/obj/item/reagent_containers/food/snacks/chipplate
	name = "basket of chips"
	desc = "A plate of chips intended for dipping."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "chip_basket"
	trash = /obj/item/trash/chipbasket
	var/vendingobject = /obj/item/reagent_containers/food/snacks/chip
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla chips" = 10))
	bitesize = 1
	reagents_to_add = list(/singleton/reagent/nutriment = 10)
	var/unitname = "chip"
	filling_color = "#FFF454"

/obj/item/reagent_containers/food/snacks/chipplate/attack_hand(mob/user as mob)
	var/obj/item/reagent_containers/food/snacks/returningitem = new vendingobject(loc)
	returningitem.reagents.clear_reagents()
	reagents.trans_to(returningitem, bitesize)
	returningitem.bitesize = bitesize/2
	user.put_in_hands(returningitem)
	if (reagents && reagents.total_volume)
		to_chat(user, "You take a [unitname] from the plate.")
	else
		to_chat(user, "You take the last [unitname] from the plate.")
		var/obj/waste = new trash(loc)
		if (loc == user)
			user.put_in_hands(waste)
		qdel(src)

/obj/item/reagent_containers/food/snacks/chipplate/MouseDrop(mob/user) //Dropping the chip onto the user
	if(istype(user) && user == usr)
		user.put_in_active_hand(src)
		src.pickup(user)
		return
	. = ..()

/obj/item/reagent_containers/food/snacks/chipplate/nachos
	name = "plate of nachos"
	desc = "A very cheesy nacho plate."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "nachos"
	trash = /obj/item/trash/plate
	vendingobject = /obj/item/reagent_containers/food/snacks/chip/nacho
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla chips" = 10))
	bitesize = 1
	reagents_to_add = list(/singleton/reagent/nutriment = 10)


//dips
/obj/item/reagent_containers/food/snacks/dip
	name = "queso dip"
	desc = "A simple, cheesy dip consisting of tomatos, cheese, and spices."
	var/nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/cheese
	var/avahtrans = /obj/item/reagent_containers/food/snacks/chip/miniavah/cheese
	var/chiptrans = /obj/item/reagent_containers/food/snacks/chip/cheese
	var/pitatrans = /obj/item/reagent_containers/food/snacks/pita

	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "dip_cheese"
	trash = /obj/item/trash/dipbowl
	bitesize = 1
	reagent_data = list(/singleton/reagent/nutriment = list("queso" = 20))
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	filling_color = "#FFF454"

/obj/item/reagent_containers/food/snacks/dip/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	var/obj/item/reagent_containers/food/snacks/returningitem
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/chip/nacho) && attacking_item.icon_state == "chip_nacho")
		returningitem = new nachotrans(src)
	else if (istype(attacking_item, /obj/item/reagent_containers/food/snacks/chip/miniavah) && attacking_item.icon_state == "avah_full" || attacking_item.icon_state == "avah_half")
		returningitem = new avahtrans(src)
	else if (istype(attacking_item, /obj/item/reagent_containers/food/snacks/chip) && (attacking_item.icon_state == "chip" || attacking_item.icon_state == "chip_half"))
		returningitem = new chiptrans(src)
	if(returningitem)
		returningitem.reagents.clear_reagents() //Clear the new chip
		var/memed = 0
		attacking_item.reagents.trans_to(returningitem, attacking_item.reagents.total_volume) //Old chip to new chip
		if(attacking_item.icon_state == "chip_half")
			returningitem.icon_state = "[returningitem.icon_state]_half"
			returningitem.bitesize = Clamp(returningitem.reagents.total_volume,1,10)
		else if(prob(1))
			memed = 1
			to_chat(user, "You scoop up some dip with \the [returningitem], but mid-scoop, \the [returningitem] breaks off into the dreadful abyss of dip, never to be seen again...")
			returningitem.icon_state = "[returningitem.icon_state]_half"
			returningitem.bitesize = Clamp(returningitem.reagents.total_volume,1,10)
		else
			returningitem.bitesize = Clamp(returningitem.reagents.total_volume*0.5,1,10)
		qdel(attacking_item)
		reagents.trans_to(returningitem, bitesize) //Dip to new chip
		user.put_in_hands(returningitem)

		if (reagents && reagents.total_volume)
			if(!memed)
				to_chat(user, "You scoop up some dip with \the [returningitem].")
		else
			if(!memed)
				to_chat(user, "You scoop up the remaining dip with \the [returningitem].")
			var/obj/waste = new trash(loc)
			if (loc == user)
				user.put_in_hands(waste)
			qdel(src)

/obj/item/reagent_containers/food/snacks/dip/salsa
	name = "salsa dip"
	desc = "Traditional Sol chunky salsa dip containing tomatos, peppers, and spices."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/salsa
	avahtrans = /obj/item/reagent_containers/food/snacks/chip/miniavah/salsa
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/salsa
	icon_state = "dip_salsa"
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("salsa" = 20))
	filling_color = "#FF4D36"

/obj/item/reagent_containers/food/snacks/dip/guac
	name = "guac dip"
	desc = "A recreation of the ancient Sol 'Guacamole' dip using tofu, limes, and spices. This recreation obviously leaves out mole meat."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/guac
	avahtrans = /obj/item/reagent_containers/food/snacks/chip/miniavah/guac
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/guac
	icon_state = "dip_guac"
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("guacmole" = 20))
	filling_color = "#35961D"

/obj/item/reagent_containers/food/snacks/dip/hummus
	name = "hummus"
	desc = "A tasty spread made from chickpeas and sesame seed paste."
	nachotrans = /obj/item/reagent_containers/food/snacks/chip/nacho/hummus
	avahtrans = /obj/item/reagent_containers/food/snacks/chip/miniavah/hummus
	chiptrans = /obj/item/reagent_containers/food/snacks/chip/hummus
	pitatrans = /obj/item/reagent_containers/food/snacks/pita/hummus
	icon_state = "hummus"
	reagents_to_add = list(/singleton/reagent/nutriment = 20)
	reagent_data = list(/singleton/reagent/nutriment = list("smooth chickpeas" = 20, "garlic" = 5))
	filling_color = "#F1DA96"

// Roasted Peanuts (under chips/nachos because finger food)
/obj/item/reagent_containers/food/snacks/roasted_peanut
	name = "roasted peanut"
	desc = "A singular roasted peanut. How peanut-ful."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "roast_peanut"
	bitesize = 2
	filling_color = "#D89E37"

/obj/item/reagent_containers/food/snacks/chipplate/peanuts_bowl
	name = "bowl of roasted peanuts"
	desc = "Peanuts roasted to flavourful and rich perfection."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "roast_peanuts_bowl"
	trash = /obj/item/trash/dipbowl
	vendingobject = /obj/item/reagent_containers/food/snacks/roasted_peanut
	bitesize = 4
	reagents_to_add = list(/singleton/reagent/nutriment/groundpeanuts = 15, /singleton/reagent/nutriment/triglyceride/oil/peanut = 5)
	unitname = "roasted peanut"
	filling_color = "#D89E37"

//burritos
/obj/item/reagent_containers/food/snacks/burrito
	name = "meat burrito"
	desc = "Meat wrapped in a flour tortilla. It's a burrito by definition."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "burrito"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla" = 6))
	filling_color = "#F06451"

/obj/item/reagent_containers/food/snacks/burrito_vegan
	name = "vegan burrito"
	desc = "Tofu wrapped in a flour tortilla. Those seen with this food object are Valid."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "burrito_vegan"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein/tofu = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla" = 6))

/obj/item/reagent_containers/food/snacks/burrito_spicy
	name = "spicy meat burrito"
	desc = "Meat and chilis wrapped in a flour tortilla. Washrooms are north of the kitchen."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "burrito_spicy"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla" = 6))
	filling_color = "#F06451"

/obj/item/reagent_containers/food/snacks/burrito_cheese
	name = "meat cheese burrito"
	desc = "Meat and melted cheese wrapped in a flour tortilla."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "burrito_cheese"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla" = 6))
	filling_color = "#FFF454"

/obj/item/reagent_containers/food/snacks/burrito_cheese_spicy
	name = "spicy cheese meat burrito"
	desc = "Meat, melted cheese, and chilis wrapped in a flour tortilla. Medical is north of the washrooms."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "burrito_cheese_spicy"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla" = 6))
	filling_color = "#FFF454"

/obj/item/reagent_containers/food/snacks/burrito_hell
	name = "el diablo"
	desc = "Meat and an insane amount of chilis packed in a flour tortilla. The chaplain's office is west of the kitchen."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "burrito_hell"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	reagent_data = list(/singleton/reagent/nutriment = list("hellfire" = 6))
	reagents_to_add = list(/singleton/reagent/nutriment = 24)// 10 Chilis is a lot.
	filling_color = "#F06451"

/obj/item/reagent_containers/food/snacks/breakfast_wrap
	name = "breakfast wrap"
	desc = "Bacon, eggs, cheese, and tortilla spiced and grilled to perfection."
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "breakfast_wrap"
	bitesize = 4
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/protein = 9, /singleton/reagent/capsaicin = 10) //It's kind of spicy
	reagent_data = list(/singleton/reagent/nutriment = list("tortilla" = 6))
	filling_color = "#FFF454"

/obj/item/reagent_containers/food/snacks/burrito_mystery
	name = "mystery meat burrito"
	desc = "The mystery is, why aren't you BSAing it?"
	icon = 'icons/obj/item/reagent_containers/food/mexican.dmi'
	icon_state = "burrito_mystery"
	bitesize = 5
	center_of_mass = list("x"=16, "y"=16)
	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("regret" = 6))
	filling_color = "#B042FF"
