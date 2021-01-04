/obj/item/reagent_containers/food/snacks/csandwich/burger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/csandwich/burger/update()
	var/i = 0
	var/list/words = list()

	cut_overlays()
	var/list/ovr = list()
	for(var/obj/item/reagent_containers/food/snacks/O in ingredients)
		words += O.ingredient_name || O.name
		i++
		var/image/I = new(src.icon, "sandwich_filling")
		I.color = O.filling_color
		I.pixel_x = pick(list(-1,0,1))
		I.pixel_y = (i*2)+7
		I.appearance_flags |= RESET_COLOR // You grill the bread, not the ingredients.
		ovr += I
		bitesize += 1

	var/image/T = new(src.icon, "burger_top")
	T.pixel_x = pick(list(-1,0,1))
	T.pixel_y = (ingredients.len * 2)
	ovr += T

	add_overlay(ovr)

	name = lowertext("[english_list(words)] burger")
	if(length(name) > 80) name = "[pick(list("absurd","colossal","enormous","ridiculous"))] burger"
	w_class = n_ceil(Clamp((ingredients.len/2),2,4))

