/**
 *	Dinnerware vendor
 *	Plastic utensil vendor
 *	Metal utensil vendor
 *	Glasses vendor
 */

/obj/structure/machinery/vending/dinnerware
	name = "\improper Dinnerware vendor"
	desc = "A kitchen and restaurant equipment vendor."
	persistent_stock = TRUE
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	icon_vend = "dinnerware-vend"
	light_mask = "dinnerware-lightmask"
	vend_id = "cutlery"
	products = list(
		/obj/item/material/kitchen/utensil/fork = 20,
		/obj/item/material/kitchen/utensil/knife = 20,
		/obj/item/material/kitchen/utensil/spoon = 20,
		/obj/item/material/kitchen/utensil/fork/chopsticks = 20,
		/obj/item/material/knife = 12,
		/obj/item/material/hatchet/butch = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 20,
		/obj/item/reagent_containers/glass/beaker/pitcher = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 20,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 20,
		/obj/item/clothing/accessory/apron/chef = 12,
		/obj/item/clothing/suit/chef_jacket = 12,
		/obj/item/material/kitchen/rollingpin = 12,
		/obj/item/reagent_containers/cooking_container/oven = 12,
		/obj/item/reagent_containers/cooking_container/fryer = 12,
		/obj/item/reagent_containers/cooking_container/skillet = 12,
		/obj/item/reagent_containers/cooking_container/saucepan = 12,
		/obj/item/reagent_containers/cooking_container/pot = 12,
		/obj/item/reagent_containers/cooking_container/board = 12,
		/obj/item/reagent_containers/cooking_container/board/bowl = 12,
		/obj/item/reagent_containers/ladle = 12,
		/obj/item/storage/toolbox/lunchbox/nt = 12,
		/obj/item/storage/toolbox/lunchbox/idris = 12,
		/obj/item/reagent_containers/bowl/takeout_box = 20,
		/obj/item/reagent_containers/glass/rag = 12,
		/obj/item/evidencebag/plasticbag = 20,
		/obj/item/tray = 20,
		/obj/item/tray/tea = 20,
		/obj/item/tray/plate = 20,
		/obj/item/reagent_containers/bowl = 20,
		/obj/item/reagent_containers/bowl/plate = 20,
		/obj/item/reagent_containers/bowl/gravy_boat = 20,
		/obj/item/reagent_containers/glass/bottle/syrup = 12,
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

/obj/structure/machinery/vending/dinnerware/plastic
	name = "\improper plastic utensil vendor"
	desc = "A utensil vendor for the galley and the mess."
	products = list(
		/obj/item/material/kitchen/utensil/fork/plastic = 20,
		/obj/item/material/kitchen/utensil/spoon/plastic = 20,
		/obj/item/material/kitchen/utensil/knife/plastic = 20,
		/obj/item/material/kitchen/utensil/fork/chopsticks/bamboo = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 20,
		/obj/item/reagent_containers/glass/beaker/pitcher = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 20,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 20,
	)

/obj/structure/machinery/vending/dinnerware/metal
	name = "\improper metal utensil vendor"
	desc = "An upscale utensil vendor for the galley and the mess."
	products = list(
		/obj/item/material/kitchen/utensil/fork = 20,
		/obj/item/material/kitchen/utensil/spoon = 20,
		/obj/item/material/kitchen/utensil/knife = 20,
		/obj/item/material/kitchen/utensil/fork/chopsticks = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 20,
		/obj/item/reagent_containers/glass/beaker/pitcher = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 20,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 20,
	)

/obj/structure/machinery/vending/dinnerware/bar
	name = "\improper glasses vendor"
	desc = "A bar vendor for dispensing various glasses and cups."
	products = list(
		/obj/item/reagent_containers/glass/beaker/pitcher = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 40,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 20,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/pint = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/square = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/mug = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shake = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/goblet = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/wine = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/flute = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cognac = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/rocks = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cocktail = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shot = 20,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/teacup = 20,
		/obj/item/reagent_containers/food/drinks/flask/barflask = 12,
		/obj/item/reagent_containers/food/drinks/flask/vacuumflask = 12,
		/obj/item/material/kitchen/utensil/fork = 20,
		/obj/item/material/kitchen/utensil/knife = 20,
		/obj/item/material/kitchen/utensil/spoon = 20,
		/obj/item/tray = 20,
		/obj/item/tray/tea = 20,
	)

/obj/item/vending_refill/cutlery
	name = "cutlery resupply canister"
	vend_id = "cutlery"
	charges = 50
