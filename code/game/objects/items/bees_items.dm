
/obj/item/queen_bee
	name = "queen bee packet"
	desc = "Place her into an apiary so she can get busy."
	icon = 'icons/obj/seeds.dmi'
	icon_state = "vine2"
	w_class = ITEMSIZE_TINY



/obj/item/apiary
	name = "moveable apiary"
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary_item"
	item_state = "giftbag"
	w_class = ITEMSIZE_HUGE

/obj/item/beezeez
	name = "bottle of BeezEez"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-1"

/obj/item/beezeez/Initialize() // Better than hardsprited in stuff.
	var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[icon_state]-100")
	filling.color = COLOR_BLUE
	add_overlay(filling)

/obj/item/reagent_containers/food/snacks/honeycomb
	name = "honeycomb"
	icon_state = "honeycomb"
	desc = "Dripping with sugary sweetness."
	reagents_to_add = list(
		/decl/reagent/nutriment/honey = 10,
		/decl/reagent/nutriment = 0.5,
		/decl/reagent/sugar = 2
	)
	bitesize = 2

/obj/item/book/manual/hydroponics_beekeeping
	name = "The Ins and Outs of Apiculture - A Precise Art"
	icon_state ="bookbee"
	icon_state ="book8"
	author = "Beekeeper Dave"
	title = "The Ins and Outs of Apiculture - A Precise Art"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Raising Bees</h1>

				Bees require their hive to be built near plants in order to feed on them, so construct it somewhere in a garden. Insert the honey frames so they can start preparing honey.<br>
				The lid needs to be closed to give them a safe environment to breed in, but you'll need to open it to perform maintenance and extract honey, open and close with a crowbar.<br>
				Use a smoker to calm them down before extracting honey, and if the bees get free, smoke them until they calm down, scoop them up with the net and return them to the hive. <br>
				The smoker runs on welding fuel, be sure to keep it topped up <br>
				Use a plant analyser to check on the hive, it'll let you know the population and their progress on making honey <br>
				Once you've extracted some honey frames, run them through the provided extractor machine to retrieve the products, and return the empty frames to the hive.<br>
				Don't forget to wear a thick suit, a biosuit is included for your safety. Bee stings can hurt <br>

				And last but not least, prepare for future expansion. Your bees will grow fast, and at some point you'll find the hive full. You can construct a second one and frames for it with enough wood.
				</body>
			</html>
			"}


