/obj/item/reagent_containers/food/snacks/sushi
	name = "sushi"
	desc = "A small, neatly wrapped morsel. Itadakimasu!"
	icon = 'icons/obj/item/reagent_containers/food/sushi.dmi'
	icon_state = "sushi_rice"
	bitesize = 1
	var/fish_type = "fish"
	reagent_data = list(/singleton/reagent/nutriment = list())

/obj/item/reagent_containers/food/snacks/sushi/Initialize(var/ml, var/obj/item/reagent_containers/food/snacks/rice, var/obj/item/reagent_containers/food/snacks/topping)
	. = ..(ml)
	if(istype(topping))
		var/list/flavor = LAZYLEN(topping.reagent_data) ? topping.reagent_data[/singleton/reagent/nutriment] : null
		var/list/ourflavor = LAZYLEN(reagent_data) ? reagent_data[/singleton/reagent/nutriment] : null
		for(var/taste_thing in flavor)
			if(!ourflavor[taste_thing]) ourflavor[taste_thing] = 0
			ourflavor[taste_thing] += flavor[taste_thing]
		if(istype(topping, /obj/item/reagent_containers/food/snacks/sashimi))
			var/obj/item/reagent_containers/food/snacks/sashimi/sashimi = topping
			fish_type = sashimi.fish_type
		else if(istype(topping, /obj/item/reagent_containers/food/snacks/meat/chicken))
			fish_type = "chicken"
		else if(istype(topping, /obj/item/reagent_containers/food/snacks/friedegg))
			fish_type = "egg"
		else if(istype(topping, /obj/item/reagent_containers/food/snacks/tofu))
			fish_type = "tofu"
		else if(istype(topping, /obj/item/reagent_containers/food/snacks/rawcutlet) || istype(topping, /obj/item/reagent_containers/food/snacks/cutlet))
			fish_type = "meat"

		if(topping.reagents)
			topping.reagents.trans_to(src, topping.reagents.total_volume)

		var/mob/M = topping.loc
		if(istype(M)) M.drop_from_inventory(topping)
		qdel(topping)

	if(istype(rice))
		if(rice.reagents)
			rice.reagents.trans_to(src, 5)
		if(!rice.reagents || !rice.reagents.total_volume)
			var/mob/M = rice.loc
			if(istype(M)) M.drop_from_inventory(rice)
			qdel(rice)
	update_icon()

/obj/item/reagent_containers/food/snacks/sushi/update_icon()
	name = "[fish_type] sushi"
	overlays = list("[fish_type]", "nori")

/////////////
// SASHIMI //
/////////////
/obj/item/reagent_containers/food/snacks/sashimi
	name = "sashimi"
	icon = 'icons/obj/item/reagent_containers/food/sushi.dmi'
	desc = "Thinly sliced raw fish. Tasty."
	icon_state = "sashimi"
	filling_color = "#FFDEFE"
	gender = PLURAL
	bitesize = 3
	reagents_to_add = list(/singleton/reagent/nutriment/protein/seafood = 3)
	var/fish_type = "fish"
	var/slices = 1

/obj/item/reagent_containers/food/snacks/sashimi/Initialize(var/ml, var/_fish_type)
	. = ..(ml)
	if(_fish_type) fish_type = _fish_type
	name = "[fish_type] sashimi"
	update_icon()

/obj/item/reagent_containers/food/snacks/sashimi/update_icon()
	icon_state = "sashimi_base"
	cut_overlays()
	var/slice_offset = (slices-1)*2
	for(var/slice = 1 to slices)
		var/image/I = image(icon = icon, icon_state = "sashimi")
		I.pixel_x = slice_offset-((slice-1)*4)
		I.pixel_y = I.pixel_x
		add_overlay(I)

/obj/item/reagent_containers/food/snacks/sashimi/attackby(obj/item/attacking_item, mob/user)
	if(!(locate(/obj/structure/table) in loc))
		return ..()

	// Add more slices.
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/sashimi))
		var/obj/item/reagent_containers/food/snacks/sashimi/other_sashimi = attacking_item
		if(slices + other_sashimi.slices > 5)
			to_chat(user, SPAN_WARNING("You can't stack the sashimi that high!"))
			return
		if(!user.unEquip(attacking_item))
			return
		slices += other_sashimi.slices
		bitesize = slices
		update_icon()
		if(attacking_item.reagents)
			attacking_item.reagents.trans_to(src, attacking_item.reagents.total_volume)
		qdel(attacking_item)
		return

	// Make sushi.
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/boiledrice))
		if(slices > 1)
			to_chat(user, SPAN_WARNING("Putting more than one slice of fish on your sushi is just greedy."))
		else
			if(!user.unEquip(attacking_item))
				return
			new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), attacking_item, src)
		return
	. = ..()

// Used for turning rice into sushi.
/obj/item/reagent_containers/food/snacks/boiledrice/attackby(obj/item/attacking_item, mob/user)
	var/static/list/acceptable_types = list(
		/obj/item/reagent_containers/food/snacks/sashimi = TRUE,
		/obj/item/reagent_containers/food/snacks/friedegg = TRUE,
		/obj/item/reagent_containers/food/snacks/tofu = TRUE,
		/obj/item/reagent_containers/food/snacks/cutlet = TRUE,
		/obj/item/reagent_containers/food/snacks/rawcutlet = TRUE,
		/obj/item/reagent_containers/food/snacks/meat/chicken = TRUE
	)
	if(!(locate(/obj/structure/table) in loc))
		return ..()
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/sashimi))
		var/obj/item/reagent_containers/food/snacks/sashimi/sashimi = attacking_item
		if(sashimi.slices > 1)
			to_chat(user, SPAN_WARNING("Putting more than one slice of fish on your sushi is just greedy."))
			return
	if(is_type_in_typecache(attacking_item, acceptable_types))
		new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), src, attacking_item)
		return
	. = ..()
// Used for turning other food into sushi.
/obj/item/reagent_containers/food/snacks/friedegg/attackby(obj/item/attacking_item, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(attacking_item, /obj/item/reagent_containers/food/snacks/boiledrice))
		new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), attacking_item, src)
		return
	. = ..()
/obj/item/reagent_containers/food/snacks/tofu/attackby(obj/item/attacking_item, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(attacking_item, /obj/item/reagent_containers/food/snacks/boiledrice))
		new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), attacking_item, src)
		return
	. = ..()
/obj/item/reagent_containers/food/snacks/rawcutlet/attackby(obj/item/attacking_item, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(attacking_item, /obj/item/reagent_containers/food/snacks/boiledrice))
		new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), attacking_item, src)
		return
	. = ..()
/obj/item/reagent_containers/food/snacks/cutlet/attackby(obj/item/attacking_item, var/mob/user)
	if((locate(/obj/structure/table) in loc) && istype(attacking_item, /obj/item/reagent_containers/food/snacks/boiledrice))
		new /obj/item/reagent_containers/food/snacks/sushi(get_turf(src), attacking_item, src)
		return
	. = ..()
// End non-fish sushi.
