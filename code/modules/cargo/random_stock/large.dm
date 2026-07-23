STOCK_ITEM_LARGE(emergency, 2)
	new /obj/structure/closet/emcloset(L)

STOCK_ITEM_LARGE(firecloset, 2)
	new /obj/structure/closet/firecloset(L)

STOCK_ITEM_LARGE(tacticool, 0.5)
	new /obj/structure/closet/gimmick/tacticool(L)

STOCK_ITEM_LARGE(radsuit, 3)
	new /obj/structure/closet/radiation(L)

STOCK_ITEM_LARGE(EOD, 1.5)
	if (prob(33))
		new /obj/structure/closet/bombclosetsecurity(L)
	else
		new /obj/structure/closet/bombcloset(L)

STOCK_ITEM_LARGE(hazmat_gear_locker, 3)
	new /obj/structure/closet/hazmat/general(L)

STOCK_ITEM_LARGE(hydrotray, 3)
	new /obj/structure/machinery/portable_atmospherics/hydroponics(L)

STOCK_ITEM_LARGE(oxycanister, 3)
	new /obj/structure/machinery/portable_atmospherics/canister/oxygen(L)

STOCK_ITEM_LARGE(oxydispenser, 5)
	new /obj/structure/dispenser/oxygen(L)

STOCK_ITEM_LARGE(bubbleshield, 0.5)
	var/obj/O = new /obj/structure/machinery/shield_gen(L)
	var/turf/T = get_turf(O)
	for (var/turf/U in range(O,1))
		if (turf_clear(U))
			T = U
			break
	new /obj/structure/machinery/shield_capacitor(T)

STOCK_ITEM_LARGE(watertank, 2)
	new /obj/structure/reagent_dispensers/watertank(L)

STOCK_ITEM_LARGE(fueltank, 2)
	new /obj/structure/reagent_dispensers/fueltank(L)

STOCK_ITEM_LARGE(lubetank, 2)
	new /obj/structure/reagent_dispensers/lube(L)

STOCK_ITEM_LARGE(airpump, 1)
	var/obj/structure/machinery/portable_atmospherics/powered/M = new /obj/structure/machinery/portable_atmospherics/powered/pump/filled(L)
	if (prob(60) && M.cell)
		QDEL_NULL(M.cell)

STOCK_ITEM_LARGE(airscrubber, 1)
	var/obj/structure/machinery/portable_atmospherics/powered/M = new /obj/structure/machinery/portable_atmospherics/powered/scrubber(L)
	if (prob(60) && M.cell)
		QDEL_NULL(M.cell)

STOCK_ITEM_LARGE(generator, 5)
	var/list/generators = list(
		/obj/structure/machinery/power/portgen/basic = 1,
		/obj/structure/machinery/power/portgen/basic/advanced = 0.7,
		/obj/structure/machinery/power/portgen/basic/super = 0.5
	)
	var/type = pickweight(generators)
	new type(L)

STOCK_ITEM_LARGE(flasher, 2)
	new /obj/structure/machinery/flasher/portable(L)

STOCK_ITEM_LARGE(vendor, 6)
	new /obj/random/vendor(L, 1)

STOCK_ITEM_LARGE(piano, 2)
	new /obj/structure/synthesized_instrument/synthesizer/piano(L)

STOCK_ITEM_LARGE(synthesizer, 2)
	new /obj/structure/synthesized_instrument/synthesizer(L)

//Xenoarch suspension field generator, they need a spare
STOCK_ITEM_LARGE(suspension, 2)
	new /obj/structure/machinery/suspension_gen(L)

STOCK_ITEM_LARGE(animal, 2.5)
	new /obj/random/animal_crate(L)

STOCK_ITEM_LARGE(cablelayer, 1)
	new /obj/structure/machinery/cablelayer(L)

STOCK_ITEM_LARGE(floodlight, 3)
	new /obj/structure/machinery/floodlight(L)

STOCK_ITEM_LARGE(floorlayer, 2)
	new /obj/structure/machinery/floorlayer(L)

STOCK_ITEM_LARGE(heater, 1.3)
	new /obj/structure/machinery/space_heater(L)

STOCK_ITEM_LARGE(dispenser, 3.5)
	var/list/dispensers = list(
		/obj/structure/machinery/chemical_dispenser/bar_alc/full = 0.6,
		/obj/structure/machinery/chemical_dispenser/bar_soft/full = 1,
		/obj/structure/machinery/chemical_dispenser/coffeemaster/full = 0.6,
		/obj/structure/machinery/chemical_dispenser/coffee/full = 1,
		/obj/structure/machinery/chemical_dispenser/full = 0.3
	)
	var/type = pickweight(dispensers)
	var/obj/structure/machinery/chemical_dispenser/CD = new type(L)
	CD.anchored = FALSE
	CD.update_use_power(POWER_USE_OFF)
	for (var/cart in CD.cartridges)
		if (prob(90))
			CD.cartridges -= cart

STOCK_ITEM_LARGE(jukebox, 1.2)
	new /obj/structure/machinery/media/jukebox(L)

STOCK_ITEM_LARGE(pipemachine, 1.7)
	if (prob(50))
		new /obj/structure/machinery/pipedispenser/disposal(L)
	else
		new /obj/structure/machinery/pipedispenser(L)

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
		/obj/structure/largecrate/animal/dog/pug, \
		/obj/structure/largecrate/animal/dog/bullterrier \
	)
	new dog(L)

STOCK_ITEM_LARGE(exosuit, 1.2) //A randomly generated exosuit in a very variable condition.
	new /obj/structure/machinery/mech_recharger(get_turf(L)) // exosuit would die without it otherwise
	new /mob/living/heavy_vehicle/premade/random/extra(L)

STOCK_ITEM_LARGE(unusualcrate, 0.3) //Like from the unknown object random event
	new /obj/structure/closet/crate/loot(L)

STOCK_ITEM_LARGE(fieldgen, 1)
	new /obj/structure/machinery/field_generator(L)

STOCK_ITEM_LARGE(shieldgenv1, 0.5)
	new /obj/structure/machinery/shieldwallgen(L)

STOCK_ITEM_LARGE(shieldgenv2, 0.5)
	new /obj/structure/machinery/shieldgen(L)

STOCK_ITEM_LARGE(heating, 1)
	new /obj/structure/machinery/chem_heater(L)
