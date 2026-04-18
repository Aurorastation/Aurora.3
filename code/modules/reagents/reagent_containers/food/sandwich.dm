/obj/item/reagent_containers/food/snacks/breadslice/attackby(obj/item/attacking_item, mob/user, params)

	if(istype(attacking_item,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/csandwich/S = new(get_turf(src))
		S.attackby(attacking_item,user)
		qdel(src)
	..()

/obj/item/reagent_containers/food/snacks/csandwich
	name = "sandwich"
	desc = "The best thing since sliced bread."
	icon = 'icons/obj/item/reagent_containers/food/custom.dmi'
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	bitesize = 2

	var/list/ingredients = list()
	var/base_name = "sandwich"
	var/topper = "sandwich_top"

/obj/item/reagent_containers/food/snacks/csandwich/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/obj/item/O = pick(contents)
	. += SPAN_NOTICE("You think you can see [O.name] in there.")

/obj/item/reagent_containers/food/snacks/csandwich/attackby(obj/item/attacking_item, mob/user)

	var/sandwich_limit = 4
	for(var/obj/item/O in ingredients)
		if(istype(O,/obj/item/reagent_containers/food/snacks/breadslice))
			sandwich_limit += 4

	if(src.contents.len > sandwich_limit)
		to_chat(user, SPAN_WARNING("If you put anything else on \the [src] it's going to collapse."))
		return
	else if(istype(attacking_item, /obj/item/reagent_containers/food/snacks))
		to_chat(user, SPAN_NOTICE("You layer [attacking_item] over \the [src]."))
		var/obj/item/reagent_containers/F = attacking_item
		F.reagents.trans_to_obj(src, F.reagents.total_volume)
		user.drop_from_inventory(attacking_item, src)
		ingredients += attacking_item
		update()
		return
	..()

/obj/item/reagent_containers/food/snacks/csandwich/proc/update()
	var/i = 0
	var/list/words = list()

	ClearOverlays()
	var/list/ovr = list()
	for(var/obj/item/reagent_containers/food/snacks/O in ingredients)
		words += O.ingredient_name || O.name
		i++
		var/image/I = new(src.icon, "sandwich_filling")
		I.color = O.filling_color
		I.pixel_x = pick(list(-1,0,1))
		I.pixel_y = (i*2)+1
		I.appearance_flags |= RESET_COLOR // You grill the bread, not the ingredients.
		ovr += I

	var/image/T = new(src.icon, topper)
	T.pixel_x = pick(list(-1,0,1))
	T.pixel_y = (ingredients.len * 2)+1
	ovr += T

	AddOverlays(ovr)

	name = lowertext("[english_list(words)] [base_name]")
	if(length(name) > 80) name = "[pick(list("absurd","colossal","enormous","ridiculous"))] [base_name]"
	w_class = n_ceil(clamp((ingredients.len/2),2,4))

/obj/item/reagent_containers/food/snacks/csandwich/Destroy()
	QDEL_LIST(ingredients)
	return ..()

/obj/item/reagent_containers/food/snacks/csandwich/roll
	name = "roll"
	desc = "Like a sandwich, but rounder."
	icon_state = "roll"
	bitesize = 2
	base_name = "roll"
	topper = "roll_top"

/obj/item/reagent_containers/food/snacks/csandwich/burger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	bitesize = 2
	base_name = "burger"
	topper = "burger_top"

