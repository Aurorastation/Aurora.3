STOCK_ITEM_LARGE(russian, 1)
	new /obj/structure/closet/gimmick/russian(L)

STOCK_ITEM_LARGE(emergency, 2)
	new /obj/structure/closet/emcloset(L)

STOCK_ITEM_LARGE(firecloset, 2)
	new /obj/structure/closet/firecloset(L)

STOCK_ITEM_LARGE(tacticool, 0.2)
	new /obj/structure/closet/gimmick/tacticool(L)

STOCK_ITEM_LARGE(radsuit, 3)
	new /obj/structure/closet/radiation(L)

STOCK_ITEM_LARGE(EOD, 1.5)
	if (prob(33))
		new /obj/structure/closet/bombclosetsecurity(L)
	else
		new /obj/structure/closet/bombcloset(L)

STOCK_ITEM_LARGE(biosuit, 3)
	var/list/allsuits = typesof(/obj/structure/closet/l3closet)
	var/type = pick(allsuits)
	new type(L)

STOCK_ITEM_LARGE(hydrotray, 3)
	new /obj/machinery/portable_atmospherics/hydroponics(L)

STOCK_ITEM_LARGE(oxycanister, 6)//Cargo should almost always have an oxycanister
	new /obj/machinery/portable_atmospherics/canister/oxygen(L)

STOCK_ITEM_LARGE(oxydispenser, 5)
	new /obj/structure/dispenser/oxygen(L)

STOCK_ITEM_LARGE(bubbleshield, 2)
	var/obj/O = new /obj/machinery/shield_gen(L)
	var/turf/T = get_turf(O)
	for (var/turf/U in range(O,1))
		if (turf_clear(U))
			T = U
			break
	new /obj/machinery/shield_capacitor(T)

STOCK_ITEM_LARGE(watertank, 2)
	new /obj/structure/reagent_dispensers/watertank(L)

STOCK_ITEM_LARGE(fueltank, 2)
	new /obj/structure/reagent_dispensers/fueltank(L)

STOCK_ITEM_LARGE(airpump, 1)
	var/obj/machinery/portable_atmospherics/powered/M = new /obj/machinery/portable_atmospherics/powered/pump/filled(L)
	if (prob(60) && M.cell)
		QDEL_NULL(M.cell)

STOCK_ITEM_LARGE(airscrubber, 1)
	var/obj/machinery/portable_atmospherics/powered/M = new /obj/machinery/portable_atmospherics/powered/scrubber(L)
	if (prob(60) && M.cell)
		QDEL_NULL(M.cell)

STOCK_ITEM_LARGE(generator, 5)
	var/list/generators = list(
		/obj/machinery/power/port_gen/pacman = 1,
		/obj/machinery/power/port_gen/pacman/super = 0.7,
		/obj/machinery/power/port_gen/pacman/mrs = 0.5
	)
	var/type = pickweight(generators)
	new type(L)

STOCK_ITEM_LARGE(flasher, 2)
	new /obj/machinery/flasher/portable(L)

STOCK_ITEM_LARGE(vendor, 6)
	new /obj/random/vendor(L, 1)

STOCK_ITEM_LARGE(piano, 2)
	new /obj/structure/device/piano(L)

//Xenoarch suspension field generator, they need a spare
STOCK_ITEM_LARGE(suspension, 2)
	new /obj/machinery/suspension_gen(L)

STOCK_ITEM_LARGE(animal, 2.5)
	new /obj/random/animal_crate(L)

STOCK_ITEM_LARGE(cablelayer, 1)
	new /obj/machinery/cablelayer(L)

STOCK_ITEM_LARGE(floodlight, 3)
	new /obj/machinery/floodlight(L)

STOCK_ITEM_LARGE(floorlayer, 2)
	new /obj/machinery/floorlayer(L)

STOCK_ITEM_LARGE(heater, 1.3)
	new /obj/machinery/space_heater(L)

STOCK_ITEM_LARGE(dispenser, 2.5)
	var/list/dispensers = list(
		/obj/machinery/chemical_dispenser/bar_alc/full = 0.6,
		/obj/machinery/chemical_dispenser/bar_soft/full = 1,
		/obj/machinery/chemical_dispenser/full = 0.3
	)
	var/type = pickweight(dispensers)
	var/obj/machinery/chemical_dispenser/CD = new type(L)
	CD.anchored = FALSE
	for (var/cart in CD.cartridges)
		if (prob(90))
			CD.cartridges -= cart

STOCK_ITEM_LARGE(jukebox, 1.2)
	new /obj/machinery/media/jukebox(L)

STOCK_ITEM_LARGE(pipemachine, 1.7)
	if (prob(50))
		new /obj/machinery/pipedispenser/disposal(L)
	else
		new /obj/machinery/pipedispenser(L)

STOCK_ITEM_LARGE(bike, 0.3)
	if (prob(75))
		new /obj/vehicle/bike(L)
	else
		new /obj/vehicle/bike/monowheel(L)

STOCK_ITEM_LARGE(sol, 0.2)
	if (prob(50))
		new /obj/structure/closet/sol/navy(L)
	else
		new /obj/structure/closet/sol/marine(L)

STOCK_ITEM_LARGE(dog, 0.2)
	var/dog = pick( \
		/obj/structure/largecrate/animal/dog, \
		/obj/structure/largecrate/animal/dog/amaskan, \
		/obj/structure/largecrate/animal/dog/pug \
	)
	new dog(L)

STOCK_ITEM_LARGE(nothing, 0)
	// no-op