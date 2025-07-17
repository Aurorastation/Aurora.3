/obj/item/reagent_containers/food/drinks/carton
	name = "carton"
	desc = "An abstract way to organize bottles that are really cartons. Finally!"
	icon = 'icons/obj/item/reagent_containers/food/drinks/carton.dmi'
	icon_state = "carton"
	item_state = "carton" //dear contributors, item_state handles inhands and onmob sprites. do not touch if you do not have added/changed the inhands. thanks. -wezzy
	volume = 100
	center_of_mass = list("x"=16, "y"=6)
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/reagent_containers/food/drinks/carton/milk
	name = "space milk"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	reagents_to_add = list(/singleton/reagent/drink/milk = 50)

/obj/item/reagent_containers/food/drinks/carton/soymilk
	name = "soymilk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	reagents_to_add = list(/singleton/reagent/drink/milk/soymilk = 50)

/obj/item/reagent_containers/food/drinks/carton/orangejuice
	name = "orange juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	reagents_to_add = list(/singleton/reagent/drink/orangejuice = 100)

/obj/item/reagent_containers/food/drinks/carton/cream
	name = "milk cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	reagents_to_add = list(/singleton/reagent/drink/milk/cream = 100)

/obj/item/reagent_containers/food/drinks/carton/tomatojuice
	name = "tomato juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	reagents_to_add = list(/singleton/reagent/drink/tomatojuice = 100)

/obj/item/reagent_containers/food/drinks/carton/limejuice
	name = "lime juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	reagents_to_add = list(/singleton/reagent/drink/limejuice = 100)

/obj/item/reagent_containers/food/drinks/carton/cranberryjuice
	name = "cranberry juice"
	desc = "Tart and sweet. A unique flavor for a unique berry."
	icon_state = "cranberryjuice"
	reagents_to_add = list(/singleton/reagent/drink/cranberryjuice = 100)

/obj/item/reagent_containers/food/drinks/carton/lemonjuice
	name = "lemon juice"
	desc = "This juice is VERY sour."
	icon_state = "lemonjuice"
	reagents_to_add = list(/singleton/reagent/drink/lemonjuice = 100)

/obj/item/reagent_containers/food/drinks/carton/dynjuice
	name = "dyn juice"
	desc = "Juice from a Skrell medicinal herb. It's supposed to be diluted."
	icon_state = "dyncarton"
	reagents_to_add = list(/singleton/reagent/drink/dynjuice = 100)

/obj/item/reagent_containers/food/drinks/carton/applejuice
	name = "apple juice"
	desc = "Juice from an apple. Yes."
	icon_state = "applejuice"
	reagents_to_add = list(/singleton/reagent/drink/applejuice = 100)

/obj/item/reagent_containers/food/drinks/carton/watermelonjuice
	name = "watermelon juice"
	desc = "Juice from a watermelon. Not to be confused with water."
	icon_state = "watermelonjuice"
	reagents_to_add = list(/singleton/reagent/drink/watermelonjuice = 100)

/obj/item/reagent_containers/food/drinks/carton/bananajuice
	name = "banana juice"
	desc = "Juice from a banana. However that works."
	icon_state = "bananajuice"
	reagents_to_add = list(/singleton/reagent/drink/banana = 100)

/obj/item/reagent_containers/food/drinks/carton/fatshouters
	name = "fatshouters milk carton"
	desc = "Fatty fatshouters milk in a carton."
	reagents_to_add = list(/singleton/reagent/drink/milk/adhomai = 100)

/obj/item/reagent_containers/food/drinks/carton/mutthir
	name = "mutthir carton"
	icon_state = "mutthir"
	desc = "A beverage made with Fatshouters' yogurt mixed with Nm'shaan's sugar and sweet herbs."
	desc_extended = "A beverage made with Fatshouters' yogurt mixed with Nm'shaan's sugar and sweet herbs. Mutthir is usually consumed during meals by both nobles and commoners. \
	The drink can also be smoked for flavor. Mutthir is believed to have originated from the worldwide appreciated Fatshouters' fermented milk. Rock Nomads living in the Nomadic Host \
	were quick to adopt the drink to their diet."
	reagents_to_add = list(/singleton/reagent/drink/milk/adhomai/mutthir = 100)

/obj/item/reagent_containers/food/drinks/carton/eggnog
	name = "eggnog carton"
	icon_state = "cream"
	desc = "A beverage, made out of egg, sugar alcohol and in this case, cream."
	desc_extended = "Eggnog, also called Egg flip, is an alcoholic beverage, made out of egg, milk or cream, sugar and alcohol. Eggnog is by principle a longdrink and they can be served \
	hot or cold. Originally it was served in winter and hot. Every serving uses one egg. It is a classic Christmas beverage, loved by every species, universe-wide. Or so you heard."
	reagents_to_add = list(/singleton/reagent/alcohol/eggnog = 100)

//small carton

/obj/item/reagent_containers/food/drinks/carton/small
	name = "small_carton"
	icon_state = "mini-milk"
	drop_sound = 'sound/items/drop/papercup.ogg'
	pickup_sound = 'sound/items/pickup/papercup.ogg'
	center_of_mass = list("x"=16, "y"=14)
	volume = 30

/obj/item/reagent_containers/food/drinks/carton/small/milk
	name = "small milk carton"
	desc = "It's milk. White and nutritious goodness!"
	reagents_to_add = list(/singleton/reagent/drink/milk = 20)

/obj/item/reagent_containers/food/drinks/carton/small/milk/choco
	name = "small chocolate milk carton"
	desc = "It's milk. This one is in delicious chocolate flavor."
	icon_state = "mini-milk_choco"
	reagents_to_add = list(/singleton/reagent/drink/milk/chocolate = 20)

/obj/item/reagent_containers/food/drinks/carton/small/milk/strawberry
	name = "small strawberry milk carton"
	desc = "It's milk. This one is in delicious strawberry flavor."
	icon_state = "mini-milk_strawberry"
	reagents_to_add = list(/singleton/reagent/drink/milk/strawberry = 20)
