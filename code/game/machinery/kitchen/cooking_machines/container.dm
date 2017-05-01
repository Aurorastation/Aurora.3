//Cooking containers are used in ovens and fryers, to hold multiple ingredients for a recipe.
//They work fairly similar to the microwave - acting as a container for objects and reagents,
//which can be checked against recipe requirements in order to cook recipes that require several things

/obj/item/weapon/reagent_containers/cooking_container
	icon = 'icons/obj/cooking_machines.dmi'
	var/shortname
	var/max_space = 20//Maximum sum of w-classes of foods in this container at once
	var/max_reagents = 80//Maximum units of reagents
	flags = OPENCONTAINER | NOREACT
	var/list/insertable = list(/obj/item/weapon/reagent_containers/food/snacks,
	/obj/item/weapon/holder,
	/obj/item/weapon/paper)

/obj/item/weapon/reagent_containers/cooking_container/New()
	..()
	create_reagents(max_reagents)
	flags |= OPENCONTAINER


/obj/item/weapon/reagent_containers/cooking_container/examine(var/mob/user)
	..()
	if (contents.len)
		var/string = "It contains....</br>"
		for (var/atom/movable/A in contents)
			string += "[A.name] </br>"
		user << span("notice", string)
	if (reagents.total_volume)
		user << span("notice", "It contains [reagents.total_volume]u of reagents.")


/obj/item/weapon/reagent_containers/cooking_container/attackby(var/obj/item/I as obj, var/mob/user as mob)
	for (var/possible_type in insertable)
		if (istype(I, possible_type))
			if (!can_fit(I))
				user << span("warning","There's no more space in the [src] for that!")
				return 0

			if(!user.unEquip(I))
				return
			I.forceMove(src)
			user << span("notice", "You put the [I] into the [src]")
			return

/obj/item/weapon/reagent_containers/cooking_container/verb/empty()
	set src in view()
	set name = "Empty Container"
	set category = "Object"
	set desc = "Removes items from the container. does not remove reagents."

	if (!isliving(usr))
		usr << "Ghosts can't mess with cooking containers"
		//Here we only check for ghosts. Animals are intentionally allowed to remove things from oven trays so they can eat it
		return

	if (!Adjacent(usr))
		usr << "You can't reach the [src] from there, get closer!"
		return

	if (!contents.len)
		usr << span("warning", "Theres nothing in the [src] you can remove!")

	for (var/atom/movable/A in contents)
		A.forceMove(get_turf(src))

	usr << span("notice", "You remove all the solid items from the [src].")

/obj/item/weapon/reagent_containers/cooking_container/proc/check_contents()
	if (contents.len == 0)
		if (!reagents || reagents.total_volume == 0)
			return 0//Completely empty
	else if (contents.len == 1)
		if (!reagents || reagents.total_volume == 0)
			return 1//Contains only a single object which can be extracted alone
	return 2//Contains multiple objects and/or reagents

/obj/item/weapon/reagent_containers/cooking_container/AltClick(var/mob/user)
	.=1
	if(user.stat || user.restrained())	return
	empty()


//Deletes contents of container.
//Used when food is burned, before replacing it with a burned mess
/obj/item/weapon/reagent_containers/cooking_container/proc/clear()
	for (var/atom/a in contents)
		qdel(a)

	if (reagents)
		reagents.clear_reagents()

/obj/item/weapon/reagent_containers/cooking_container/proc/label(var/number, var/CT = null)
	//This returns something like "Fryer basket 1 - empty"
	//The latter part is a brief reminder of contents
	//This is used in the removal menu
	. = shortname
	if (!isnull(number))
		.+= " [number]"
	.+= " - "
	if (CT)
		.+=CT
	else if (contents.len)
		for (var/obj/O in contents)
			.+=O.name//Just append the name of the first object
			return
	else if (reagents && reagents.total_volume > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		.+=R.name//Append name of most voluminous reagent
		return
	else
		. += "empty"


/obj/item/weapon/reagent_containers/cooking_container/proc/can_fit(var/obj/item/I)
	var/total = 0
	for (var/obj/item/J in contents)
		total += J.w_class

	if((max_space - total) >= I.w_class)
		return 1


//Takes a reagent holder as input and distributes its contents among the items in the container
//Distribution is weighted based on the volume already present in each item
/obj/item/weapon/reagent_containers/cooking_container/proc/soak_reagent(var/datum/reagents/holder)
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


/obj/item/weapon/reagent_containers/cooking_container/oven
	name = "Oven Dish"
	shortname = "shelf"
	desc = "Put ingredients in this for cooking to a recipe,in an oven."
	icon_state = "ovendish"
	max_space = 30
	max_reagents = 120

/obj/item/weapon/reagent_containers/cooking_container/fryer
	name = "Fryer basket"
	shortname = "basket"
	desc = "Belongs in a deep fryer, put ingredients in it for cooking to a recipe"
	icon_state = "basket"