// Wrapper obj for cooked food. Appearance is set in the cooking code, not on spawn.
/obj/item/reagent_containers/food/snacks/variable
	name = "cooked food"
	icon = 'icons/obj/food_custom.dmi'
	desc = "If you can see this description then something is wrong. Please report the bug on the tracker."
	bitesize = 2

	var/size = 5 //The quantity of reagents which is considered "normal" for this kind of food
	//These objects will change size depending on the ratio of reagents to this value
	var/min_scale = 0.5
	var/max_scale = 2
	var/scale = 1

	w_class = 2
	var/prefix

/obj/item/reagent_containers/food/snacks/variable/Initialize()
	. = ..()
	if (reagents)
		reagents.maximum_volume = size*8 + 10
	else
		create_reagents(size*8 + 10)

/obj/item/reagent_containers/food/snacks/variable/update_icon()
	if (reagents && reagents.total_volume)
		var/ratio = reagents.total_volume / size

		scale = cubert(ratio) //Scaling factor is square root of desired area
		scale = Clamp(scale, min_scale, max_scale)
	else
		scale = min_scale

	var/matrix/M = matrix()
	M.Scale(scale)
	src.transform = M

	w_class = round(w_class * scale)
	if (!prefix)
		if (scale == min_scale)
			prefix = "tiny"
		else if (scale <= 0.8)
			prefix = "small"

		else
			if (scale >= 1.2)
				prefix = "large"
			if (scale >= 1.4)
				prefix = "extra large"
			if (scale >= 1.6)
				prefix = "huge"
			if (scale >= max_scale)
				prefix = "massive"

		name = "[prefix] [name]"

/obj/item/reagent_containers/food/snacks/variable/pizza
	name = "personal pizza"
	desc = "A personalized pan pizza meant for only one person."
	icon_state = "personal_pizza"
	size = 20
	w_class = 3

/obj/item/reagent_containers/food/snacks/variable/bread
	name = "bread"
	desc = "Tasty bread."
	icon_state = "breadcustom"
	size = 40
	w_class = 3

/obj/item/reagent_containers/food/snacks/variable/pie
	name = "pie"
	desc = "Tasty pie."
	icon_state = "piecustom"
	size = 25

/obj/item/reagent_containers/food/snacks/variable/cake
	name = "cake"
	desc = "A popular band."
	icon_state = "cakecustom"
	size = 40
	w_class = 3

/obj/item/reagent_containers/food/snacks/variable/pocket
	name = "hot pocket"
	desc = "You wanna put a bangin- oh, nevermind."
	icon_state = "donk"
	size = 8
	w_class = 1

/obj/item/reagent_containers/food/snacks/variable/kebab
	name = "kebab"
	desc = "Remove this!"
	icon_state = "kabob"
	size = 10

/obj/item/reagent_containers/food/snacks/variable/waffles
	name = "waffles"
	desc = "Made with love."
	icon_state = "waffles"
	size = 12

/obj/item/reagent_containers/food/snacks/variable/cookie
	name = "cookie"
	desc = "Sugar snap!"
	icon_state = "cookie"
	size = 6
	w_class = 1

/obj/item/reagent_containers/food/snacks/variable/donut
	name = "filled donut"
	desc = "Donut eat this!" // kill me
	icon_state = "donut"
	size = 8
	w_class = 1

/obj/item/reagent_containers/food/snacks/variable/jawbreaker
	name = "flavored jawbreaker"
	desc = "It's like cracking a molar on a rainbow."
	icon_state = "jawbreaker"
	size = 4
	w_class = 1

/obj/item/reagent_containers/food/snacks/variable/candybar
	name = "flavored chocolate bar"
	desc = "Made in a factory downtown."
	icon_state = "bar"
	size = 6
	w_class = 1

/obj/item/reagent_containers/food/snacks/variable/sucker
	name = "flavored sucker"
	desc = "Suck, suck, suck."
	icon_state = "sucker"
	size = 4
	w_class = 1

/obj/item/reagent_containers/food/snacks/variable/jelly
	name = "jelly"
	desc = "All your friends will be jelly."
	icon_state = "jellycustom"
	size = 8


/obj/item/reagent_containers/food/snacks/variable/cereal
	name = "cereal"
	desc = "Crispy and flaky"
	icon_state = "cereal_box"
	size = 30
	w_class = 3

/obj/item/reagent_containers/food/snacks/variable/cereal/Initialize()
	. =..()
	name = pick(list("flakes", "krispies", "crunch", "pops", "O's", "crisp", "loops", "jacks", "clusters"))

/obj/item/reagent_containers/food/snacks/variable/mob
	desc = "Poor little thing."
	size = 5
	w_class = 1
	var/kitchen_tag = "animal"

