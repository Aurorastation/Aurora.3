//Cooking containers are used in ovens and fryers, to hold multiple ingredients for a recipe.
//They work fairly similar to the microwave - acting as a container for objects and reagents,
//which can be checked against recipe requirements in order to cook recipes that require several things

/obj/item/reagent_containers/cooking_container
	icon = 'icons/obj/item/reagent_containers/cooking_container.dmi'
	var/shortname
	var/place_verb = "into"
	var/max_space = 20//Maximum sum of w-classes of foods in this container at once
	volume = 80//Maximum units of reagents
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT
	var/list/insertable = list(
		/obj/item/reagent_containers/food/snacks,
		/obj/item/holder,
		/obj/item/paper,
		/obj/item/flame/candle,
		/obj/item/stack/rods,
		/obj/item/organ/internal/brain
		)
	drop_sound = 'sound/items/drop/metal_pot.ogg'
	pickup_sound = 'sound/items/pickup/metal_pot.ogg'
	var/appliancetype // Bitfield, uses the same as appliances
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/cooking_container/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(length(contents))
		var/string = "It contains:</br><ul><li>"
		string += jointext(contents, "</li><li>") + "</li></ul>"
		. += string
	if(reagents.total_volume)
		. += "It contains <b>[reagents.total_volume] units</b> of reagents total."

/obj/item/reagent_containers/cooking_container/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/reagent_containers/cooking_container/pickup(mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_containers/cooking_container/dropped(mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_containers/cooking_container/attack_hand()
	. = ..()
	update_icon()

/obj/item/reagent_containers/cooking_container/attackby(obj/item/attacking_item, mob/user)
	if(is_type_in_list(attacking_item, insertable))
		if (!can_fit(attacking_item))
			to_chat(user, SPAN_WARNING("There's no more space in [src] for that!"))
			return FALSE

		if(!user.unEquip(attacking_item))
			return
		attacking_item.forceMove(src)
		to_chat(user, SPAN_NOTICE("You put [attacking_item] [place_verb] [src]."))
		update_icon()
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
	update_icon()

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
	QDEL_LIST(contents)
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
		var/singleton/reagent/R = reagents.get_primary_reagent_decl()
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

/obj/item/reagent_containers/cooking_container/update_icon()
	ClearOverlays()
	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]_filling_overlay")
		filling.color = reagents.get_color()
		AddOverlays(filling)

/obj/item/reagent_containers/cooking_container/oven
	name = "oven dish"
	shortname = "shelf"
	desc = "Put ingredients in this; designed for use with an oven. Warranty void if used."
	icon_state = "ovendish"
	max_space = 30
	volume = 120
	appliancetype = OVEN

/obj/item/reagent_containers/cooking_container/oven/update_icon()
	ClearOverlays()
	for(var/obj/item/I in contents)
		var/image/food = overlay_image(I.icon, I.icon_state, I.color)
		var/matrix/M = matrix()
		M.Scale(0.5)
		food.transform = M
		AddOverlays(food)

/obj/item/reagent_containers/cooking_container/skillet
	name = "skillet"
	shortname = "skillet"
	desc = "Chuck ingredients in this to fry something on the stove."
	icon_state = "skillet"
	volume = 30
	force = 16
	hitsound = 'sound/weapons/smash.ogg'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
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
	force = 18
	hitsound = 'sound/weapons/smash.ogg'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
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
	force = 18
	hitsound = 'sound/weapons/smash.ogg'
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
	appliancetype = POT
	w_class = WEIGHT_CLASS_BULKY

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

/obj/item/reagent_containers/cooking_container/microwave_plate
	name = "microwave plate"
	shortname = "plate"
	desc = "Put ingredients on this; designed for use with a microwave."
	icon_state = "microwave_plate"
	appliancetype = MICROWAVE
	max_space = 30
	volume = 90
	force = 18
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/reagent_containers/cooking_container/board
	name = "chopping board"
	shortname = "board"
	place_verb = "onto"
	desc = "A board for preparing food. Not chopping. I'm sorry."
	icon_state = "board"
	drop_sound = /singleton/sound_category/generic_drop_sound
	pickup_sound = /singleton/sound_category/generic_pickup_sound
	appliancetype = MIX
	atom_flags = ATOM_FLAG_OPEN_CONTAINER // Will still react
	volume = 15 // for things like jelly sandwiches etc
	max_space = 25

/obj/item/reagent_containers/cooking_container/board/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "After adding food ingredients, click-drag this onto your character to attempt to cook/prepare them."

/obj/item/reagent_containers/cooking_container/board/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(over != user || use_check(user))
		return ..()
	if(!(length(contents) || reagents?.total_volume))
		return ..()
	var/singleton/recipe/recipe = select_recipe(src, appliance = appliancetype)
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
	if (l && user)
		var/name = results[1].name
		if (l > 1)
			to_chat(user, SPAN_NOTICE("You made some [pluralize_word(name, TRUE)]!"))
		else
			to_chat(user, SPAN_NOTICE("You made [name]!"))

	QDEL_NULL(temp) //delete buffer object
	return ..()

/obj/item/reagent_containers/cooking_container/board/update_icon()
	ClearOverlays()
	for(var/obj/item/I in contents)
		var/image/food = overlay_image(I.icon, I.icon_state, I.color)
		var/matrix/M = matrix()
		M.Scale(0.5)
		food.transform = M
		AddOverlays(food)

/obj/item/reagent_containers/cooking_container/board/bowl
	name = "mixing bowl"
	shortname = "bowl"
	desc = "A bowl. You bowl foods... wait, what?"
	icon_state = "mixingbowl"
	filling_states = "-10;10;25;50;75;80;100"
	center_of_mass = list("x" = 17,"y" = 7)
	max_space = 30
	matter = list(DEFAULT_WALL_MATERIAL = 300)
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,180)

/obj/item/reagent_containers/cooking_container/board/bowl/update_icon()
	ClearOverlays()
	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state][get_filling_state()]")
		filling.color = reagents.get_color()
		AddOverlays(filling)
