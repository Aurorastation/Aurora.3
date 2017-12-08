// Wrapper obj for cooked food. Appearance is set in the cooking code, not on spawn.
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

	. = ..()
	if (reagents)
		reagents.maximum_volume = size*8 + 10
	else
		create_reagents(size*8 + 10)

	if (reagents && reagents.total_volume)
		var/ratio = reagents.total_volume / size

		scale = cubert(ratio) //Scaling factor is square root of desired area
		scale = Clamp(scale, min_scale, max_scale)
	else
		scale = min_scale

	var/matrix/M = matrix()
	M.Scale(scale)
	src.transform = M

	w_class *= scale
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

	name = "personal pizza"
	desc = "A personalized pan pizza meant for only one person."
	icon_state = "personal_pizza"
	size = 20
	w_class = 3

	name = "bread"
	desc = "Tasty bread."
	icon_state = "breadcustom"
	size = 40
	w_class = 3

	name = "pie"
	desc = "Tasty pie."
	icon_state = "piecustom"
	size = 25

	name = "cake"
	desc = "A popular band."
	icon_state = "cakecustom"
	size = 40
	w_class = 3

	name = "hot pocket"
	desc = "You wanna put a bangin- oh, nevermind."
	icon_state = "donk"
	size = 8
	w_class = 1

	name = "kebab"
	desc = "Remove this!"
	icon_state = "kabob"
	size = 10

	name = "waffles"
	desc = "Made with love."
	icon_state = "waffles"
	size = 12

	name = "cookie"
	desc = "Sugar snap!"
	icon_state = "cookie"
	size = 6
	w_class = 1

	name = "filled donut"
	desc = "Donut eat this!" // kill me
	icon_state = "donut"
	size = 8
	w_class = 1

	name = "flavored jawbreaker"
	desc = "It's like cracking a molar on a rainbow."
	icon_state = "jawbreaker"
	size = 4
	w_class = 1

	name = "flavored chocolate bar"
	desc = "Made in a factory downtown."
	icon_state = "bar"
	size = 6
	w_class = 1

	name = "flavored sucker"
	desc = "Suck, suck, suck."
	icon_state = "sucker"
	size = 4
	w_class = 1

	name = "jelly"
	desc = "All your friends will be jelly."
	icon_state = "jellycustom"
	size = 8


	name = "cereal"
	desc = "Crispy and flaky"
	icon_state = "cereal_box"
	size = 30
	w_class = 3

	. =..()
	name = pick(list("flakes", "krispies", "crunch", "pops", "O's", "crisp", "loops", "jacks", "clusters"))

	desc = "Poor little thing."
	size = 5
	w_class = 1
	var/kitchen_tag = "animal"

