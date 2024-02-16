/obj/machinery/seed_extractor
	name = "seed extractor"
	desc = "Extracts and bags seeds from produce."
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "sextractor"
	density = 1
	anchored = 1

/obj/machinery/seed_extractor/attackby(obj/item/attacking_item, mob/user)

	// Fruits and vegetables.
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/grown) || istype(attacking_item, /obj/item/grown))

		user.remove_from_mob(attacking_item)

		var/datum/seed/new_seed_type
		if(istype(attacking_item, /obj/item/grown))
			var/obj/item/grown/F = attacking_item
			new_seed_type = SSplants.seeds[F.plantname]
		else
			var/obj/item/reagent_containers/food/snacks/grown/F = attacking_item
			new_seed_type = SSplants.seeds[F.plantname]

		if(new_seed_type)
			to_chat(user, "<span class='notice'>You extract some seeds from [attacking_item].</span>")
			var/produce = rand(1,4)
			for(var/i = 0;i<=produce;i++)
				var/obj/item/seeds/seeds = new(get_turf(src))
				seeds.seed_type = new_seed_type.name
				seeds.update_seed()
		else
			to_chat(user, "[attacking_item] doesn't seem to have any usable seeds inside it.")

		qdel(attacking_item)
		return TRUE

	//Grass.
	else if(istype(attacking_item, /obj/item/stack/tile/grass))
		var/obj/item/stack/tile/grass/S = attacking_item
		if (S.use(1))
			to_chat(user, "<span class='notice'>You extract some seeds from the grass tile.</span>")
			new /obj/item/seeds/grassseed(loc)
		return TRUE

	return ..()
