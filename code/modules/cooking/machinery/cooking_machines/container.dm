//Cooking containers are used in ovens and fryers, to hold multiple ingredients for a recipe.
//They work fairly similar to the microwave - acting as a container for objects and reagents,
//which can be checked against recipe requirements in order to cook recipes that require several things

/obj/item/reagent_containers/cooking_container
	icon = 'icons/obj/cooking_machines.dmi'
	var/shortname
	var/place_verb = "into"
	var/max_space = 20//Maximum sum of w-classes of foods in this container at once
	volume = 80//Maximum units of reagents
	flags = OPENCONTAINER | NOREACT
	var/list/insertable = list(
		/obj/item/reagent_containers/food/snacks,
		/obj/item/holder,
		/obj/item/paper,
		/obj/item/flame/candle,
		/obj/item/stack/rods,
		/obj/item/organ/internal/brain
		)
	var/appliancetype // Bitfield, uses the same as appliances
	w_class = ITEMSIZE_NORMAL

/obj/item/reagent_containers/cooking_container/examine(var/mob/user)
	. = ..()
	if(length(contents))
		to_chat(user, SPAN_NOTICE(get_content_info()))
	if(reagents.total_volume)
		to_chat(user, SPAN_NOTICE(get_reagent_info()))

/obj/item/reagent_containers/cooking_container/proc/get_content_info()
	var/string = "It contains:</br><ul><li>"
	string += jointext(contents, "</li><li>") + "</li></ul>"
	return string

/obj/item/reagent_containers/cooking_container/proc/get_reagent_info()
	return "It contains [reagents.total_volume] units of reagents."

/obj/item/reagent_containers/cooking_container/MouseEntered(location, control, params)
	. = ..()
	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && get_dist(usr, src) <= 2)
		params = replacetext(params, "shift=1;", "") // tooltip doesn't appear unless this is stripped
		var/description
		if(length(contents))
			description = get_content_info()
		if(reagents.total_volume)
			if(!description)
				description = ""
			description += get_reagent_info()
		openToolTip(usr, src, params, name, description)

/obj/item/reagent_containers/cooking_container/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/obj/item/reagent_containers/cooking_container/attackby(var/obj/item/I, var/mob/user)
	if(is_type_in_list(I, insertable))
		if (!can_fit(I))
			to_chat(user, SPAN_WARNING("There's no more space in [src] for that!"))
			return FALSE

		if(!user.unEquip(I))
			return
		I.forceMove(src)
		to_chat(user, SPAN_NOTICE("You put [I] [place_verb] [src]."))
		return

/obj/item/reagent_containers/cooking_container/verb/empty()
	set src in oview(1)
	set name = "Empty Container"
	set category = "Object"
	set desc = "Removes items from the container, excluding reagents."

	do_empty(usr)

/obj/item/reagent_containers/cooking_container/proc/do_empty(mob/user)
	if (use_check_and_message(user))
		return

	if (isemptylist(contents))
		to_chat(user, SPAN_WARNING("There's nothing in [src] you can remove!"))
		return

	for (var/contained in contents)
		var/atom/movable/AM = contained
		AM.forceMove(get_turf(src))

	to_chat(user, SPAN_NOTICE("You remove all the solid items from [src]."))

/obj/item/reagent_containers/cooking_container/proc/check_contents()
	if (isemptylist(contents))
		if (!reagents?.total_volume)
			return CONTAINER_EMPTY
	else if (length(contents) == 1)
		if (!reagents?.total_volume)
			return CONTAINER_SINGLE
	return CONTAINER_MANY

/obj/item/reagent_containers/cooking_container/AltClick(var/mob/user)
	do_empty(user)

//Deletes contents of container.
//Used when food is burned, before replacing it with a burned mess
/obj/item/reagent_containers/cooking_container/proc/clear()
	QDEL_NULL_LIST(contents)
	reagents.clear_reagents()

/obj/item/reagent_containers/cooking_container/proc/label(var/number, var/CT = null)
	//This returns something like "Fryer basket 1 - empty"
	//The latter part is a brief reminder of contents
	//This is used in the removal menu
	. = shortname
	if (!isnull(number))
		.+= " [number]"
	.+= " - "
	if (CT)
		return . + CT
	else if (LAZYLEN(contents))
		var/obj/O = locate() in contents
		return . + O.name //Just append the name of the first object
	else if (reagents.total_volume > 0)
		var/decl/reagent/R = reagents.get_primary_reagent_decl()
		return . + R.name//Append name of most voluminous reagent
	return . + "empty"


/obj/item/reagent_containers/cooking_container/proc/can_fit(var/obj/item/I)
	var/total = 0
	for (var/contained in contents)
		var/obj/item/J = contained
		total += J.w_class

	if((max_space - total) >= I.w_class)
		return TRUE


//Takes a reagent holder as input and distributes its contents among the items in the container
//Distribution is weighted based on the volume already present in each item
/obj/item/reagent_containers/cooking_container/proc/soak_reagent(var/datum/reagents/holder)
	var/total = 0
	var/list/weights = list()
	for (var/contained in contents)
		var/obj/item/I = contained
		if (I.reagents && I.reagents.total_volume)
			total += I.reagents.total_volume
			weights[I] = I.reagents.total_volume

	if (total > 0)
		for (var/contained in contents)
			var/obj/item/I = contained
			if (weights[I])
				holder.trans_to(I, weights[I] / total)


/obj/item/reagent_containers/cooking_container/oven
	name = "oven dish"
	shortname = "shelf"
	desc = "Put ingredients in this; designed for use with an oven. Warranty void if used."
	icon_state = "ovendish"
	max_space = 30
	volume = 120
	appliancetype = OVEN

/obj/item/reagent_containers/cooking_container/skillet
	name = "skillet"
	shortname = "skillet"
	desc = "Chuck ingredients in this to fry something on the stove."
	icon_state = "skillet"
	volume = 30
	force = 11
	hitsound = 'sound/weapons/smash.ogg'
	flags = OPENCONTAINER // Will still react
	appliancetype = SKILLET

/obj/item/reagent_containers/cooking_container/skillet/Initialize(var/mapload, var/mat_key)
	. = ..(mapload)
	var/material/material = SSmaterials.get_material_by_name(mat_key || MATERIAL_STEEL)
	if(!material)
		return
	if(material.name != MATERIAL_STEEL)
		color = material.icon_colour
	name = "[material.display_name] [initial(name)]"

/obj/item/reagent_containers/cooking_container/saucepan
	name = "saucepan"
	shortname = "saucepan"
	desc = "Is it a pot? Is it a pan? It's a saucepan!"
	icon_state = "pan"
	volume = 90
	slot_flags = SLOT_HEAD
	force = 8
	hitsound = 'sound/weapons/smash.ogg'
	flags = OPENCONTAINER // Will still react
	appliancetype = SAUCEPAN

/obj/item/reagent_containers/cooking_container/saucepan/Initialize(var/mapload, var/mat_key)
	. = ..(mapload)
	var/material/material = SSmaterials.get_material_by_name(mat_key || MATERIAL_STEEL)
	if(!material)
		return
	if(material.name != MATERIAL_STEEL)
		color = material.icon_colour
	name = "[material.display_name] [initial(name)]"

/obj/item/reagent_containers/cooking_container/pot
	name = "cooking pot"
	shortname = "pot"
	desc = "Boil things with this. Maybe even stick 'em in a stew."
	icon_state = "pot"
	max_space = 50
	volume = 180
	force = 8
	hitsound = 'sound/weapons/smash.ogg'
	flags = OPENCONTAINER // Will still react
	appliancetype = POT
	w_class = ITEMSIZE_LARGE

/obj/item/reagent_containers/cooking_container/pot/Initialize(mapload, mat_key)
	. = ..(mapload)
	var/material/material = SSmaterials.get_material_by_name(mat_key || MATERIAL_STEEL)
	if(!material)
		return
	if(mat_key && mat_key != MATERIAL_STEEL)
		color = material.icon_colour
	name = "[material.display_name] [initial(name)]"

/obj/item/reagent_containers/cooking_container/fryer
	name = "fryer basket"
	shortname = "basket"
	desc = "Put ingredients in this; designed for use with a deep fryer. Warranty void if used."
	icon_state = "basket"
	appliancetype = FRYER

/obj/item/reagent_containers/cooking_container/grill_grate
	name = "grill grate"
	shortname = "grate"
	place_verb = "onto"
	desc = "Primarily used to grill meat, place this on a grill and grab a can of energy drink."
	icon_state = "grill_grate"
	appliancetype = GRILL
	insertable = list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)

/obj/item/reagent_containers/cooking_container/grill_grate/can_fit()
	if(length(contents) >= 3)
		return FALSE
	return TRUE

/obj/item/reagent_containers/cooking_container/plate
	name = "serving plate"
	shortname = "plate"
	desc = "A plate. You plate foods on this plate."
	icon_state = "plate"
	appliancetype = MIX
	flags = OPENCONTAINER // Will still react
	volume = 15 // for things like jelly sandwiches etc
	max_space = 25

/obj/item/reagent_containers/cooking_container/plate/examine(mob/user)
	. = ..()
	if(length(contents) || reagents?.total_volume)
		to_chat(user, SPAN_NOTICE("To attempt cooking; click and hold, then drag this onto your character"))

/obj/item/reagent_containers/cooking_container/plate/MouseDrop(var/obj/over_obj)
	if(over_obj != usr || use_check(usr))
		return ..()
	if(!(length(contents) || reagents?.total_volume))
		return ..()
	var/decl/recipe/recipe = select_recipe(src, appliance = appliancetype)
	if(!recipe)
		return
	var/list/obj/results = recipe.make_food(src)
	var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes
	for (var/result in results)
		var/atom/movable/AM = result
		AM.forceMove(temp)

	//making multiple copies of a recipe from one container. For example, tons of fries
	while (select_recipe(src, appliance = appliancetype) == recipe)
		var/list/TR = list()
		TR += recipe.make_food(src)
		for (var/result in TR) //Move results to buffer
			var/atom/movable/AM = result
			AM.forceMove(temp)
		results += TR

	for (var/r in results)
		var/obj/item/reagent_containers/food/snacks/R = r
		R.forceMove(src) //Move everything from the buffer back to the container

	var/l = length(results)
	if (l && usr)
		var/name = results[1].name
		if (l > 1)
			to_chat(usr, SPAN_NOTICE("You made some [pluralize_word(name, TRUE)]!"))
		else
			to_chat(usr, SPAN_NOTICE("You made [name]!"))

	QDEL_NULL(temp) //delete buffer object
	return ..()

/obj/item/reagent_containers/cooking_container/plate/bowl
	name = "serving bowl"
	shortname = "bowl"
	desc = "A bowl. You bowl foods... wait, what?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mixingbowl"
	filling_states = "-10;10;25;50;75;80;100"
	center_of_mass = list("x" = 17,"y" = 7)
	max_space = 30
	matter = list(DEFAULT_WALL_MATERIAL = 300)
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,180)


/obj/item/reagent_containers/cooking_container/plate/bowl/on_reagent_change()
	update_icon()


/obj/item/reagent_containers/cooking_container/plate/bowl/pickup(mob/user)
	..()
	update_icon()


/obj/item/reagent_containers/cooking_container/plate/bowl/dropped(mob/user)
	..()
	update_icon()


/obj/item/reagent_containers/cooking_container/plate/bowl/attack_hand()
	..()
	update_icon()


/obj/item/reagent_containers/cooking_container/plate/bowl/update_icon()
	cut_overlays()
	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[icon_state][get_filling_state()]")
		filling.color = reagents.get_color()
		add_overlay(filling)

