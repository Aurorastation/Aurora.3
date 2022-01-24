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

	w_class = ITEMSIZE_SMALL
	var/prefix

/obj/item/reagent_containers/food/snacks/variable/Initialize()
	. = ..()
	if (reagents)
		reagents.maximum_volume = size*8 + 10
	else
		create_reagents(size*8 + 10)
	update_icon()

/obj/item/reagent_containers/food/snacks/variable/on_reagent_change()
	return

/obj/item/reagent_containers/food/snacks/variable/proc/update_prefix()
	switch(scale)
		if (0 to 0.8)
			prefix = "small"
		if (0.8 to 1.2)
			prefix = "large"
		if (1.2 to 1.4)
			prefix = "extra large"
		if (1.4 to 1.6)
			prefix = "huge"
		if (1.6 to INFINITY)
			prefix = "massive"
	if(scale == min_scale)
		prefix = "tiny"

	name = "[prefix] [name]"

/obj/item/reagent_containers/food/snacks/proc/get_name_sans_prefix()
	return name

/obj/item/reagent_containers/food/snacks/variable/get_name_sans_prefix()
	return jointext(splittext(..(), " ") - prefix, " ")

/obj/item/reagent_containers/food/snacks/variable/proc/update_scale()
	if (reagents && reagents.total_volume)
		var/ratio = reagents.total_volume / size
		scale = sqrt(ratio) //Scaling factor is square root of desired area
		scale = Clamp(scale, min_scale, max_scale)
	else
		scale = min_scale
	w_class = round(initial(w_class) * scale)

/obj/item/reagent_containers/food/snacks/variable/update_icon(var/overwrite = FALSE)
	if(!scale || overwrite)
		update_scale()

	var/matrix/M = matrix()
	M.Scale(scale)
	transform = M

	if (!prefix || overwrite)
		update_prefix()

/obj/item/reagent_containers/food/snacks/variable/pizza
	name = "personal pizza"
	desc = "A personalized pan pizza meant for only one person."
	icon_state = "personal_pizza"
	size = 20
	w_class = ITEMSIZE_NORMAL

/obj/item/reagent_containers/food/snacks/variable/bread
	name = "bread"
	desc = "Tasty bread."
	icon_state = "breadcustom"
	size = 40
	w_class = ITEMSIZE_NORMAL

/obj/item/reagent_containers/food/snacks/variable/pie
	name = "pie"
	desc = "Tasty pie."
	icon_state = "piecustom"
	size = 25

/obj/item/reagent_containers/food/snacks/variable/cake
	name = "cake"
	desc = "A popular band."
	icon_state = "cakecustom"
	slices_num = 5
	slice_path = /obj/item/reagent_containers/food/snacks/variable/cakeslice
	size = 40
	w_class = ITEMSIZE_NORMAL

/obj/item/reagent_containers/food/snacks/variable/cakeslice
	name = "cake slice"
	desc = "A slice of cake"
	icon_state = "cakeslicecustom"
	trash = /obj/item/trash/plate
	w_class = ITEMSIZE_SMALL
	size = 8

/obj/item/reagent_containers/food/snacks/variable/cakeslice/update_icon()
	. = ..()
	//Filling overlay
	var/image/I = image(icon, "[icon_state]_filling")
	I.color = filling_color
	overlays += I

/obj/item/reagent_containers/food/snacks/variable/pocket
	name = "hot pocket"
	desc = "You wanna put a bangin- oh, nevermind."
	icon_state = "donk"
	size = 8
	w_class = ITEMSIZE_TINY

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
	w_class = ITEMSIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/donut
	name = "filled donut"
	desc = "Donut eat this!" // kill me
	icon_state = "donut"
	size = 8
	w_class = ITEMSIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/jawbreaker
	name = "flavored jawbreaker"
	desc = "It's like cracking a molar on a rainbow."
	icon_state = "jawbreaker"
	size = 4
	w_class = ITEMSIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/candybar
	name = "flavored chocolate bar"
	desc = "Made in a factory downtown."
	icon_state = "bar"
	size = 6
	w_class = ITEMSIZE_TINY

/obj/item/reagent_containers/food/snacks/variable/sucker
	name = "flavored sucker"
	desc = "Suck, suck, suck."
	icon_state = "sucker"
	size = 4
	w_class = ITEMSIZE_TINY

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
	w_class = ITEMSIZE_NORMAL

/obj/item/reagent_containers/food/snacks/variable/cereal/Initialize()
	. =..()
	name = pick(list("flakes", "krispies", "crunch", "pops", "O's", "crisp", "loops", "jacks", "clusters"))

/obj/item/reagent_containers/food/snacks/variable/mob
	desc = "Poor little thing."
	size = 5
	w_class = ITEMSIZE_TINY
	var/kitchen_tag = "animal"

