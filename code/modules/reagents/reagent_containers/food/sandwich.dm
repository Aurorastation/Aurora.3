/obj/item/reagent_containers/food/snacks/breadslice/attackby(obj/item/W as obj, mob/user)

	if(istype(W,/obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/csandwich/S = new(get_turf(src))
		S.attackby(W,user)
		qdel(src)
	..()

/obj/item/reagent_containers/food/snacks/csandwich
	name = "sandwich"
	desc = "The best thing since sliced bread."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	bitesize = 2

	var/list/ingredients = list()
	var/base_name = "sandwich"
	var/topper = "sandwich_top"

/obj/item/reagent_containers/food/snacks/csandwich/attackby(obj/item/W as obj, mob/user)

	var/sandwich_limit = 4
	for(var/obj/item/O in ingredients)
		if(istype(O,/obj/item/reagent_containers/food/snacks/breadslice))
			sandwich_limit += 4

	if(src.contents.len > sandwich_limit)
		to_chat(user, SPAN_WARNING("If you put anything else on \the [src] it's going to collapse."))
		return
	else if(istype(W,/obj/item/reagent_containers/food/snacks))
		to_chat(user, SPAN_NOTICE("You layer [W] over \the [src]."))
		var/obj/item/reagent_containers/F = W
		F.reagents.trans_to_obj(src, F.reagents.total_volume)
		user.drop_from_inventory(W,src)
		ingredients += W
		update()
		return
	..()

/obj/item/reagent_containers/food/snacks/csandwich/proc/update()
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
		I.pixel_y = (i*2)+1
		I.appearance_flags |= RESET_COLOR // You grill the bread, not the ingredients.
		ovr += I

	var/image/T = new(src.icon, topper)
	T.pixel_x = pick(list(-1,0,1))
	T.pixel_y = (ingredients.len * 2)+1
	ovr += T

	add_overlay(ovr)

	name = lowertext("[english_list(words)] [base_name]")
	if(length(name) > 80) name = "[pick(list("absurd","colossal","enormous","ridiculous"))] [base_name]"
	w_class = n_ceil(Clamp((ingredients.len/2),2,4))

/obj/item/reagent_containers/food/snacks/csandwich/Destroy()
	QDEL_NULL_LIST(ingredients)
	return ..()

/obj/item/reagent_containers/food/snacks/csandwich/examine(mob/user)
	..(user)
	var/obj/item/O = pick(contents)
	to_chat(user, SPAN_NOTICE("You think you can see [O.name] in there."))
