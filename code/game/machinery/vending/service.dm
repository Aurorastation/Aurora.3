/**
 *	Dinnerware vendor
 *	Plastic utensil vendor
 *	Metal utensil vendor
 *	Glasses vendor
 */

/obj/machinery/vending/dinnerware
	name = "\improper Dinnerware vendor"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	icon_vend = "dinnerware-vend"
	light_mask = "dinnerware-lightmask"
	vend_id = "cutlery"
	products = list(
		/obj/item/material/kitchen/utensil/fork = 12,
		/obj/item/material/kitchen/utensil/knife = 12,
		/obj/item/material/kitchen/utensil/spoon = 12,
		/obj/item/material/kitchen/utensil/fork/chopsticks = 12,
		/obj/item/material/knife = 2,
		/obj/item/material/hatchet/butch = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 3,
		/obj/item/reagent_containers/glass/beaker/pitcher = 3,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 6,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 6,
		/obj/item/clothing/accessory/apron/chef = 2,
		/obj/item/clothing/suit/chef_jacket = 2,
		/obj/item/material/kitchen/rollingpin = 2,
		/obj/item/reagent_containers/cooking_container/oven = 5,
		/obj/item/reagent_containers/cooking_container/fryer = 4,
		/obj/item/reagent_containers/cooking_container/skillet = 4,
		/obj/item/reagent_containers/cooking_container/saucepan = 4,
		/obj/item/reagent_containers/cooking_container/pot = 4,
		/obj/item/reagent_containers/cooking_container/board = 3,
		/obj/item/reagent_containers/cooking_container/board/bowl = 2,
		/obj/item/reagent_containers/ladle = 4,
		/obj/item/storage/toolbox/lunchbox/nt = 6,
		/obj/item/storage/toolbox/lunchbox/idris = 6,
		/obj/item/reagent_containers/glass/rag = 8,
		/obj/item/evidencebag/plasticbag = 20,
		/obj/item/tray = 12,
		/obj/item/tray/tea = 2,
		/obj/item/tray/plate = 10,
		/obj/item/reagent_containers/bowl = 10,
		/obj/item/reagent_containers/bowl/plate = 10,
		/obj/item/reagent_containers/bowl/gravy_boat = 8,
		/obj/item/reagent_containers/glass/bottle/syrup = 4,
	)
	contraband = list(
		/obj/item/storage/toolbox/lunchbox/syndicate = 2
	)
	premium = list(
		/obj/item/storage/toolbox/lunchbox/scc/filled = 2,
	)
	restock_items = TRUE
	random_itemcount = 0
	light_color = COLOR_STEEL

/obj/machinery/vending/dinnerware/plastic
	name = "\improper plastic utensil vendor"
	desc = "A kitchen and restaurant utensil vendor."
	products = list(
		/obj/item/material/kitchen/utensil/fork/plastic = 12,
		/obj/item/material/kitchen/utensil/spoon/plastic = 12,
		/obj/item/material/kitchen/utensil/knife/plastic = 12,
		/obj/item/material/kitchen/utensil/fork/chopsticks/bamboo = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 3,
		/obj/item/reagent_containers/glass/beaker/pitcher = 3,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 6,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 6,
	)

/obj/machinery/vending/dinnerware/metal
	name = "\improper metal utensil vendor"
	desc = "An upscale kitchen and restaurant utensil vendor."
	products = list(
		/obj/item/material/kitchen/utensil/fork = 12,
		/obj/item/material/kitchen/utensil/spoon = 12,
		/obj/item/material/kitchen/utensil/knife = 12,
		/obj/item/material/kitchen/utensil/fork/chopsticks = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 3,
		/obj/item/reagent_containers/glass/beaker/pitcher = 3,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 6,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 6,
	)

/obj/machinery/vending/dinnerware/bar
	name = "\improper glasses vendor"
	desc = "A bar vendor for dispensing various glasses and cups."
	products = list(
		/obj/item/reagent_containers/glass/beaker/pitcher = 8,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 40,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 3,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 6,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/pint = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/square = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/mug = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shake = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/goblet = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/wine = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/flute = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cognac = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/rocks = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cocktail = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shot = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/teacup = 6,
		/obj/item/reagent_containers/food/drinks/flask/barflask = 2,
		/obj/item/reagent_containers/food/drinks/flask/vacuumflask = 2,
		/obj/item/material/kitchen/utensil/fork = 6,
		/obj/item/material/kitchen/utensil/knife = 6,
		/obj/item/material/kitchen/utensil/spoon = 6,
		/obj/item/tray = 12,
		/obj/item/tray/tea = 2,
	)

/obj/item/device/vending_refill/cutlery
	name = "cutlery resupply canister"
	vend_id = "cutlery"
	charges = 50
