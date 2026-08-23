
/obj/random/animal_crate
	name = "random animal"
	desc = "Contains a random crate with an animal."
	icon_state = "woodcrate"
	spawnlist = list(
		/obj/structure/largecrate/animal/corgi = 3,
		/obj/structure/largecrate/animal/cow = 4,
		/obj/structure/largecrate/animal/goat = 3,
		/obj/structure/largecrate/animal/snake = 3,
		/obj/structure/largecrate/animal/cat = 2,
		/obj/structure/largecrate/animal/chick = 4,
		/obj/structure/largecrate/animal/adhomai = 0.5,
		/obj/structure/largecrate/animal/adhomai/fatshouter = 0.5,
		/obj/structure/largecrate/animal/adhomai/rafama = 0.5,
		/obj/structure/largecrate/animal/adhomai/schlorrgo = 0.2,
		/obj/structure/largecrate/animal/hakhma = 0.5,
		/obj/structure/largecrate/animal/moghes = 0.5,
		/obj/structure/largecrate/animal/moghes/warmount = 0.2,
		/obj/structure/largecrate/animal/moghes/miervesh = 0.5,
		/obj/structure/largecrate/animal/moghes/otzek = 0.5
	)

/obj/random/vendor
	name = "random vendor"
	icon_state = "vendor"
	var/depleted = FALSE
	var/scan_id = TRUE // Should the spawned vendor check IDs
	spawnlist = list(
		/obj/structure/machinery/vending/boozeomat = 1,
		/obj/structure/machinery/vending/coffee = 1,
		/obj/structure/machinery/vending/snack = 1,
		/obj/structure/machinery/vending/cola = 1,
		/obj/structure/machinery/vending/cigarette = 1,
		/obj/structure/machinery/vending/medical = 1.2,
		/obj/structure/machinery/vending/phoronresearch = 0.7,
		/obj/structure/machinery/vending/security = 0.3,
		/obj/structure/machinery/vending/hydronutrients = 1,
		/obj/structure/machinery/vending/hydroseeds = 1,
		/obj/structure/machinery/vending/dinnerware = 1,
		/obj/structure/machinery/vending/sovietsoda = 2,
		/obj/structure/machinery/vending/tool = 1,
		/obj/structure/machinery/vending/engivend = 0.6,
		/obj/structure/machinery/vending/engineering = 1,
		/obj/structure/machinery/vending/robotics = 1,
		/obj/structure/machinery/vending/tacticool = 0.2,
		/obj/structure/machinery/vending/tacticool/ert = 0.1
	)
	has_postspawn = TRUE

/obj/random/vendor/Initialize(mapload, _depleted = 0)
	depleted = _depleted
	. = ..()

/obj/random/vendor/post_spawn(obj/structure/machinery/vending/V)
	if (!depleted)
		return

	//Greatly reduce the contents. it will have 0-20% of what it usually has
	for (var/content in V.products)
		if (prob(40))
			V.products[content] = 0	//40% chance to completely lose an item
		else
			var/multiplier = rand(0,20)	//Else, we reduce it to a very low percentage
			if (multiplier)
				multiplier /= 100

			V.products[content] *= multiplier
			if (V.products[content] < 1 && V.products[content] > 0)	//But we'll usually have at least 1 left
				V.products[content] = 0

			// Clamp to an integer so we don't get 0.78 of a screwdriver.
			V.products[content] = round(V.products[content])

	V.scan_id &= scan_id

/obj/random/pottedplant/spawn_item()
	var/obj/structure/flora/pottedplant/P = null
	var/list/unwanted = list(
		/obj/structure/flora/pottedplant, // don't want parent base obj
		/obj/structure/flora/pottedplant/dead2, // does not fit horizon's aesthetic
		/obj/structure/flora/pottedplant/empty
	)
	var/list/rare = list(
		/obj/structure/flora/pottedplant/eye,
		/obj/structure/flora/pottedplant/dead
	)
	while(!P)
		P = pick(typesof(/obj/structure/flora/pottedplant))
		if((P in unwanted) || ((P in rare) && prob(50)))
			P = null
	. = new P(loc)

/obj/random/pottedplant_small
	name = "random potted plant, small"
	desc = "Spawns a random potted plant."
	icon_state = "potted_plant_small"
	spawn_nothing_percentage = 1

/obj/random/pottedplant_small/spawn_item()
	var/obj/item/flora/pottedplant_small/P = null
	var/list/unwanted = list(
		/obj/item/flora/pottedplant_small, // don't want parent base obj
		/obj/item/flora/pottedplant_small/empty
	)
	var/list/rare = list(
		/obj/item/flora/pottedplant_small/dead
	)
	while(!P)
		P = pick(typesof(/obj/item/flora/pottedplant_small))
		if((P in unwanted) || ((P in rare) && prob(50)))
			P = null
	. = new P(loc)

/obj/random/holoturret
	name = "random holoturret"
	desc = "This is a random turret item. It could be active or simply a statue."
	icon_state = "holoturret"
	spawnlist = list(
		/obj/structure/machinery/porta_turret/hologram = 1,
		/obj/structure/unathi_statue/warrior/right = 1,
	)

ABSTRACT_TYPE(/obj/random/table)

/obj/random/table/wood
	name = "random wooden table"
	icon_state = "table"
	spawnlist = list(
		/obj/structure/table/wood,
		/obj/structure/table/wood/bamboo,
		/obj/structure/table/wood/birch,
		/obj/structure/table/wood/ebony,
		/obj/structure/table/wood/mahogany,
		/obj/structure/table/wood/maple,
		/obj/structure/table/wood/reinf,
		/obj/structure/table/wood/walnut,
		/obj/structure/table/wood/yew,
	)
