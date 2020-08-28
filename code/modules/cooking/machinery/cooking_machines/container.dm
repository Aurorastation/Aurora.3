//Cooking containers are used in ovens and fryers, to hold multiple ingredients for a recipe.
//They work fairly similar to the microwave - acting as a container for objects and reagents,
//which can be checked against recipe requirements in order to cook recipes that require several things

/obj/item/reagent_containers/cooking_container
	icon = 'icons/obj/cooking_machines.dmi'
	var/shortname
	var/max_space = 20//Maximum sum of w-classes of foods in this container at once
	volume = 80//Maximum units of reagents
	flags = OPENCONTAINER | NOREACT
	var/list/insertable = list(
		/obj/item/reagent_containers/food/snacks,
		/obj/item/holder,
		/obj/item/paper,
		/obj/item/flame/candle
		)
	var/appliancetype // Bitfield, uses the same as appliances
	w_class = ITEMSIZE_NORMAL

/obj/item/reagent_containers/cooking_container/examine(var/mob/user)
	. = ..()
	if (length(contents))
		var/string = "It contains:</br><ul><li>"
		string += jointext(contents, "</li></br><li>") + "</li></ul>"
		to_chat(user, SPAN_NOTICE(string))
	if (reagents.total_volume)
		to_chat(user, SPAN_NOTICE("It contains [reagents.total_volume] units of reagents."))


/obj/item/reagent_containers/cooking_container/attackby(var/obj/item/I as obj, var/mob/user as mob)
	for (var/possible_type in insertable)
		if (istype(I, possible_type))
			if (!can_fit(I))
				to_chat(user, SPAN_WARNING("There's no more space in [src] for that!"))
				return FALSE

			if(!user.unEquip(I))
				return
			I.forceMove(src)
			to_chat(user, SPAN_NOTICE("You put [I] into [src]."))
			return

/obj/item/reagent_containers/cooking_container/verb/empty()
	set src in oview(1)
	set name = "Empty Container"
	set category = "Object"
	set desc = "Removes items from the container, excluding reagents."

	do_empty(usr)

/obj/item/reagent_containers/cooking_container/proc/do_empty(mob/user)
	if (!isliving(user))
		//Here we only check for ghosts. Animals are intentionally allowed to remove things from oven trays so they can eat it
		return

	if (user.stat || user.restrained())
		to_chat(user, SPAN_NOTICE("You are in no fit state to do this."))
		return

	if (!Adjacent(user))
		to_chat(user, "You can't reach [src] from here.")
		return

	if (isemptylist(contents))
		to_chat(user, SPAN_WARNING("There's nothing in [src] you can remove!"))
		return

	for (var/atom/movable/A in contents)
		A.forceMove(get_turf(src))

	to_chat(user, SPAN_NOTICE("You remove all the solid items from [src]."))

/obj/item/reagent_containers/cooking_container/proc/check_contents()
	if (length(contents) == 0)
		if (!reagents || reagents.total_volume == 0)
			return 0.0//Completely empty
	else if (length(contents) == 1)
		if (!reagents || reagents.total_volume == 0)
			return 1.0//Contains only a single object which can be extracted alone
	return 2.0//Contains multiple objects and/or reagents

/obj/item/reagent_containers/cooking_container/AltClick(var/mob/user)
	do_empty(user)

//Deletes contents of container.
//Used when food is burned, before replacing it with a burned mess
/obj/item/reagent_containers/cooking_container/proc/clear()
	for (var/atom/a in contents)
		qdel(a)

	if (reagents)
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
	else if (reagents && reagents.total_volume > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		return . + R.name//Append name of most voluminous reagent
	return . + "empty"


/obj/item/reagent_containers/cooking_container/proc/can_fit(var/obj/item/I)
	var/total = 0
	for (var/obj/item/J in contents)
		total += J.w_class

	if((max_space - total) >= I.w_class)
		return TRUE


//Takes a reagent holder as input and distributes its contents among the items in the container
//Distribution is weighted based on the volume already present in each item
/obj/item/reagent_containers/cooking_container/proc/soak_reagent(var/datum/reagents/holder)
	var/total = 0
	var/list/weights = list()
	for (var/obj/item/I in contents)
		if (I.reagents && I.reagents.total_volume)
			total += I.reagents.total_volume
			weights[I] = I.reagents.total_volume

	if (total > 0)
		for (var/obj/item/I in contents)
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
	volume = 15
	force = 11
	hitsound = 'sound/weapons/smash.ogg'
	flags = OPENCONTAINER // Will still react
	appliancetype = SKILLET

/obj/item/reagent_containers/cooking_container/skillet/Initialize(var/mat_key)
	. = ..()
	var/material/material = SSmaterials.get_material_by_name(mat_key || MATERIAL_STEEL)
	if(material.name != MATERIAL_STEEL)
		color = material.icon_colour
	name = "[material.display_name] [initial(name)]"

/obj/item/reagent_containers/cooking_container/saucepan
	name = "saucepan"
	shortname = "saucepan"
	desc = "Is it a pot? Is it a pan? It's a saucepan!"
	icon_state = "pan"
	volume = 60
	slot_flags = SLOT_HEAD
	force = 8
	hitsound = 'sound/weapons/smash.ogg'
	flags = OPENCONTAINER // Will still react
	appliancetype = SAUCEPAN

/obj/item/reagent_containers/cooking_container/saucepan/Initialize(var/mat_key)
	. = ..()
	var/material/material = SSmaterials.get_material_by_name(mat_key || MATERIAL_STEEL)
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

/obj/item/reagent_containers/cooking_container/pot/Initialize(var/mat_key)
	. = ..()
	var/material/material = SSmaterials.get_material_by_name(mat_key || MATERIAL_STEEL)
	if(material.name != MATERIAL_STEEL)
		color = material.icon_colour
	name = "[material.display_name] [initial(name)]"

/obj/item/reagent_containers/cooking_container/fryer
	name = "fryer basket"
	shortname = "basket"
	desc = "Put ingredients in this; designed for use with a deep fryer. Warranty void if used."
	icon_state = "basket"
	appliancetype = FRYER

/obj/item/reagent_containers/cooking_container/plate
	name = "serving plate"
	shortname = "plate"
	desc = "A plate. You plate foods on this plate."
	icon_state = "plate"
	appliancetype = MIX
	volume = 5 // for things like jelly sandwiches etc

/obj/item/reagent_containers/cooking_container/plate/MouseDrop(var/obj/over_obj)
	if(over_obj != usr || use_check(usr))
		return ..()
	if(!(length(contents) || reagents?.total_volume))
		return ..()
	var/decl/recipe/recipe = select_recipe(src, appliance = appliancetype)
	if(!recipe)
		return
	var/list/results = recipe.make_food(src)
	var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes
	for (var/atom/movable/AM in results)
		AM.forceMove(temp)

	//making multiple copies of a recipe from one container. For example, tons of fries
	while (select_recipe(src, appliance = appliancetype) == recipe)
		var/list/TR = list()
		TR += recipe.make_food(src)
		for (var/atom/movable/AM in TR) //Move results to buffer
			AM.forceMove(temp)
		results += TR

	for (var/r in results)
		var/obj/item/reagent_containers/food/snacks/R = r
		R.forceMove(src) //Move everything from the buffer back to the container

	QDEL_NULL(temp) //delete buffer object
	return ..()

/obj/item/reagent_containers/cooking_container/plate/bowl
	name = "serving bowl"
	shortname = "bowl"
	desc = "A bowl. You bowl foods... wait, what?"
	volume = 180
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mixingbowl"
	center_of_mass = list("x" = 17,"y" = 7)
	matter = list(DEFAULT_WALL_MATERIAL = 300)
	volume = 180
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,180)
