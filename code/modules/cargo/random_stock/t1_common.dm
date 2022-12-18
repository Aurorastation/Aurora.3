// --- Common ---

STOCK_ITEM_COMMON(toolbox, 4)
	if(prob(5))
		new /obj/item/storage/toolbox/syndicate(L)
	else
		new /obj/random/toolbox(L)

// A random low-level medical item
STOCK_ITEM_COMMON(meds, 5)
	new /obj/random/medical(L)
	new /obj/random/medical(L)
	if(prob(50))
		new /obj/random/medical(L)

STOCK_ITEM_COMMON(steel, 7)
	new /obj/item/stack/material/steel(L, 50)

STOCK_ITEM_COMMON(glass, 2.5)
	if(prob(35))
		new /obj/item/stack/material/glass/reinforced(L, rand(10,50))
	else
		new /obj/item/stack/material/glass(L, 50)

STOCK_ITEM_COMMON(wood, 2)
	new /obj/item/stack/material/wood(L, rand(20,50))

STOCK_ITEM_COMMON(plastic, 1.5)
	new /obj/item/stack/material/plastic(L, rand(10,50))

STOCK_ITEM_COMMON(cardboard, 1)
	new /obj/item/stack/material/cardboard(L, rand(10,50))

//A lightreplacer and a kit of lights
STOCK_ITEM_COMMON(lightreplacer, 1)
	var/obj/item/device/lightreplacer/LR
	if(prob(5))
		LR = new /obj/item/device/lightreplacer/advanced(L)
	else
		LR = new /obj/item/device/lightreplacer(L)
	LR.uses = 0

	new /obj/item/storage/box/lights/mixed(L)

//A bundle of bodybags or stasis bags
STOCK_ITEM_COMMON(bodybag, 2.2)
	if(prob(25))
		new /obj/item/bodybag/cryobag(L)
		if(prob(50))
			new /obj/item/bodybag/cryobag(L)
			new /obj/item/bodybag/cryobag(L)
	else
		new /obj/item/storage/box/bodybags(L)

STOCK_ITEM_COMMON(lamp, 2)
	var/obj/item/device/flashlight/lamp/P
	if(prob(50))
		P = new /obj/item/device/flashlight/lamp/green(L)
	else
		P = new /obj/item/device/flashlight/lamp(L)
	P.on = FALSE
	P.queue_icon_update()

STOCK_ITEM_COMMON(mousetrap, 2)
	new /obj/item/storage/box/mousetraps(L)

STOCK_ITEM_COMMON(sterile, 2)
	new /obj/item/storage/box/gloves(L)
	new /obj/item/storage/box/masks(L)

STOCK_ITEM_COMMON(light, 1.8)
	new /obj/item/storage/box/lights/mixed(L)
	if(prob(25))
		new /obj/item/storage/box/lights/coloredmixed(L)
	if(prob(15))
		var/type = pick( \
			/obj/item/storage/box/lights/colored/red, \
			/obj/item/storage/box/lights/colored/green, \
			/obj/item/storage/box/lights/colored/blue, \
			/obj/item/storage/box/lights/colored/cyan, \
			/obj/item/storage/box/lights/colored/yellow, \
			/obj/item/storage/box/lights/colored/magenta \
		)
		new type(L)

STOCK_ITEM_COMMON(aid, 4)
	new /obj/random/firstaid(L)

STOCK_ITEM_COMMON(flame, 2)
	new /obj/item/storage/box/fancy/matches(L)
	new /obj/item/flame/lighter/random(L)

STOCK_ITEM_COMMON(candles, 1.5)
	new /obj/item/storage/box/fancy/candle_box(L)
	if(prob(75))
		new /obj/item/storage/box/fancy/candle_box(L)

STOCK_ITEM_COMMON(crayons, 1.5)
	new /obj/item/storage/box/fancy/crayons(L)

STOCK_ITEM_COMMON(figure, 1)
	new /obj/random/action_figure(L)

STOCK_ITEM_COMMON(bombsupply, 4.5)
	for(var/i in 1 to rand(1, 3))
		new /obj/random/bomb_supply(L)

STOCK_ITEM_COMMON(tech, 5)
	for(var/i in 1 to rand(1, 3))
		new /obj/random/tech_supply(L)

STOCK_ITEM_COMMON(smokable, 2)
	if(prob(50))
		new /obj/item/flame/lighter/random(L)
	for(var/i in 1 to rand(2, 4))
		new /obj/random/smokable(L)

STOCK_ITEM_COMMON(vials, 2)
	if(prob(20))
		new /obj/item/storage/lockbox/vials(L)
	else
		new /obj/item/storage/box/fancy/vials(L)

STOCK_ITEM_COMMON(smallcell, 4)
	for(var/i in 1 to rand(1, 2))
		var/type = pick( \
			/obj/item/cell, \
			/obj/item/cell/device, \
			/obj/item/cell/apc, \
			/obj/item/cell/high \
		)
		new type(L)

//Spawns a random circuitboard
//Allboards being a global list might be faster, but it didnt seem worth the extra memory
STOCK_ITEM_COMMON(circuitboard, 1)
	var/list/allboards = subtypesof(/obj/item/circuitboard)
	var/list/exclusion = list(
		/obj/item/circuitboard/unary_atmos,
		/obj/item/circuitboard/telecomms
	)
	exclusion += typesof(/obj/item/circuitboard/mecha)

	allboards -= exclusion
	var/type = pick(allboards)
	new type(L)

STOCK_ITEM_COMMON(oxy, 3.2)
	new /obj/random/smalltank(L)
	if(prob(25))
		new /obj/random/smalltank(L)
		new /obj/random/smalltank(L)
	if(prob(40))
		new /obj/item/tank/oxygen(L)

STOCK_ITEM_COMMON(belts, 2)
	new /obj/random/belt(L)
	if(prob(50))
		new /obj/random/belt(L)

STOCK_ITEM_COMMON(backpack, 3.5)
	new /obj/random/backpack(L)
	new /obj/random/backpack(L)

STOCK_ITEM_COMMON(weldgear, 2)
	if(prob(50))
		new /obj/item/clothing/glasses/welding(L)
	if(prob(50))
		new /obj/item/clothing/head/welding(L)
	if(prob(50))
		new /obj/item/reagent_containers/weldpack(L)

STOCK_ITEM_COMMON(inflatable, 3)
	new /obj/item/storage/bag/inflatable(L)

STOCK_ITEM_COMMON(wheelchair, 1)
	//Wheelchair is not dense so it doesnt NEED a clear tile, but it looks a little silly to
	//have it on a crate. So we will attempt to find a clear tile around the spawnpoint.
	//We'll put it ontop of a crate if we need to though, its not essential to find clear space
	//In any case, we always spawn it on a turf and never in a container
	var/turf/T = get_turf(L)
	if(!turf_clear(T))
		for (var/turf/U in range(T,1))
			if (turf_clear(U))
				T = U
				break

	new /obj/structure/bed/stool/chair/office/wheelchair(T)

STOCK_ITEM_COMMON(trap, 2)
	new /obj/item/trap(L)
	if(prob(30))
		new /obj/item/trap(L)

STOCK_ITEM_COMMON(utensil, 2)
	new /obj/item/storage/box/kitchen(L)

STOCK_ITEM_COMMON(utilitygrenades, 1.5)
	for(var/i in 1 to rand(1, 3))
		if(prob(50))
			new /obj/item/grenade/chem_grenade/metalfoam(L)
		else
			new /obj/item/grenade/chem_grenade/cleaner(L)

STOCK_ITEM_COMMON(nanopaste, 2)
	new /obj/item/stack/nanopaste(L)

STOCK_ITEM_COMMON(gloves, 3.3)
	var/list/allgloves = typesof(/obj/item/clothing/gloves)

	var/list/exclusion = list(
		/obj/item/clothing/gloves,
		/obj/item/clothing/gloves/fluff,
		/obj/item/clothing/gloves/swat/bst,
		/obj/item/clothing/gloves/powerfist,
		/obj/item/clothing/gloves/claws
	)
	exclusion += typesof(/obj/item/clothing/gloves/rig)
	exclusion += typesof(/obj/item/clothing/gloves/lightrig)
	exclusion += typesof(/obj/item/clothing/wrists/watch)
	exclusion += typesof(/obj/item/clothing/gloves/fluff)
	exclusion += typesof(/obj/item/clothing/gloves/ballistic)
	allgloves -= exclusion

	for (var/i in 1 to rand(1, 3))
		var/gtype = pick(allgloves)
		new gtype(L)

STOCK_ITEM_COMMON(insulated, 1.5)
	new /obj/item/clothing/gloves/yellow(L)
	if(prob(50))
		new /obj/item/clothing/gloves/yellow(L)

STOCK_ITEM_COMMON(scanners, 3.2)
	//A random scanning device, most are useless
	var/list/possible = list(
		/obj/item/device/healthanalyzer = 5,
		/obj/item/device/analyzer = 0.5,
		/obj/item/device/mass_spectrometer = 0.5,
		/obj/item/device/mass_spectrometer/adv = 0.5,
		/obj/item/device/slime_scanner = 1,
		/obj/item/autopsy_scanner = 1,
		/obj/item/device/robotanalyzer = 4,
		/obj/item/mining_scanner = 1,
		/obj/item/device/ano_scanner = 1,
		/obj/item/device/reagent_scanner = 2,
		/obj/item/device/reagent_scanner/adv = 2,
		/obj/item/barcodescanner = 1,
		/obj/item/device/depth_scanner = 1
	)
	for(var/i in 1 to rand(1, 2))
		var/stype = pickweight(possible)
		new stype(L)

STOCK_ITEM_COMMON(binoculars, 1.5)
	new /obj/item/device/binoculars(L)

STOCK_ITEM_COMMON(flash, 1)
	new /obj/item/device/flash(L)

STOCK_ITEM_COMMON(maglock, 2)
	if(prob(50))
		new /obj/item/device/magnetic_lock/engineering(L)
	else
		new /obj/item/device/magnetic_lock/security(L)

STOCK_ITEM_COMMON(forensic, 1)
	if(prob(50))
		new /obj/item/reagent_containers/spray/luminol(L)
	else
		new /obj/item/device/uv_light(L)
	if(prob(25))
		new /obj/item/storage/box/slides(L)

STOCK_ITEM_COMMON(cleaning, 3.5)
	if(prob(80))
		new /obj/item/reagent_containers/glass/rag(L)
	if(prob(80))
		new /obj/random/soap(L)
	if(prob(80))
		new /obj/item/mop(L)
	else if(prob(5))
		new /obj/item/mop/advanced(L)

STOCK_ITEM_COMMON(bsdm, 1.5)
	if(prob(50))
		new /obj/item/clothing/glasses/sunglasses/blindfold(L)
	if(prob(20))
		new /obj/item/clothing/mask/muzzle(L)
	if(prob(20))
		new /obj/item/clothing/suit/straight_jacket(L)

STOCK_ITEM_COMMON(charger, 2)
	var/newtype = pick(/obj/machinery/cell_charger, /obj/machinery/charger)
	var/obj/machinery/ma = new newtype(L)
	ma.anchored = FALSE
	ma.update_use_power(POWER_USE_OFF)

STOCK_ITEM_COMMON(spacesuit, 2)
	new /obj/item/clothing/suit/space(L)
	new /obj/item/clothing/head/helmet/space(L)

STOCK_ITEM_COMMON(rollerbed, 2.2)
	new /obj/item/roller(L)

STOCK_ITEM_COMMON(smokebombs, 1.1)
	new /obj/item/storage/box/smokebombs(L)

STOCK_ITEM_COMMON(jar, 2)
	new /obj/item/glass_jar(L)

STOCK_ITEM_COMMON(pills, 1.2)
	var/list/options = pick( \
		/obj/item/storage/pill_bottle/bicaridine, \
		/obj/item/storage/pill_bottle/butazoline, \
		/obj/item/storage/pill_bottle/dexalin_plus, \
		/obj/item/storage/pill_bottle/dermaline, \
		/obj/item/storage/pill_bottle/dylovene, \
		/obj/item/storage/pill_bottle/inaprovaline, \
		/obj/item/storage/pill_bottle/kelotane, \
		/obj/item/storage/pill_bottle/cetahydramine, \
		/obj/item/storage/pill_bottle/mortaphenyl, \
		/obj/item/storage/pill_bottle/perconol \
	)
	var/newtype = pick(options)
	new newtype(L)

STOCK_ITEM_COMMON(cosmetic, 2.2)
	if(prob(50))
		new /obj/item/lipstick/random(L)
	else
		new /obj/item/haircomb(L)

STOCK_ITEM_COMMON(suitcooler, 1.2)
	new /obj/item/device/suit_cooling_unit(L)

STOCK_ITEM_COMMON(paperwork, 1.2)
	if(prob(50))
		new /obj/item/device/hand_labeler(L)
	else
		new /obj/item/clipboard(L)
	if(prob(15))
		var/obj/item/pen/fountain/F = pick(typesof(/obj/item/pen/fountain))
		new F(L)
	else if(prob(15))
		new /obj/item/pen/multi(L)


STOCK_ITEM_COMMON(booze, 3.7)
	if(prob(8))//Spare keg of beer or xuizi juice
		var/turf/T = get_turf(L)
		if (!turf_clear(T))
			for (var/turf/U in range(T,1))
				if (turf_clear(U))
					T = U
					break

		new /obj/random/keg(T)

	else
		var/list/drinks = subtypesof(/obj/item/reagent_containers/food/drinks/bottle)
		drinks += subtypesof(/obj/item/reagent_containers/food/drinks/carton)

		for (var/i in 1 to rand(1, 2))
			var/type = pick(drinks)
			new type(L)

STOCK_ITEM_COMMON(plant, 3.5)
	var/turf/T = get_turf(L)
	if(!turf_clear(T))
		for (var/turf/U in range(T,1))
			if (turf_clear(U))
				T = U
				break
	new /obj/structure/flora/pottedplant/random(T)

STOCK_ITEM_COMMON(bag, 2)
	var/type = pick( \
		/obj/item/storage/bag/trash, \
		/obj/item/storage/bag/plasticbag, \
		/obj/item/storage/bag/ore, \
		/obj/item/storage/bag/plants, \
		/obj/item/storage/bag/sheetsnatcher, \
		/obj/item/storage/bag/money, \
		/obj/item/storage/bag/books \
	)
	new type(L)
	if(prob(30))
		new type(L)

STOCK_ITEM_COMMON(extinguish, 2.2)
	for(var/i in 1 to rand(1, 2))
		var/type = pick( \
			/obj/item/extinguisher, \
			/obj/item/extinguisher/mini \
		)
		new type(L)

STOCK_ITEM_COMMON(hailer, 1.1)
	if(prob(50))
		new /obj/item/device/megaphone(L)
	else
		new /obj/item/device/hailer(L)

//A target, for target practice
//Take em up to science for gun testing
STOCK_ITEM_COMMON(target, 0.5)
	var/turf/T = get_turf(L)
	if(!turf_clear(T))
		for(var/turf/U in range(T,1))
			if(turf_clear(U))
				T = U
				break
	if(prob(50))
		new /obj/item/target(T)
	else
		new /obj/structure/target_stake(T)

STOCK_ITEM_COMMON(snacks, 4)
	//Snackboxes are much more likely to spawn on tables than in crates.
	//This ensures the cargo bay will have a supply of food in an obtainable place for animals
	//allows nymphs and rats to raid it for nutrients, and thus gives player rats more
	//reason to infest the warehouse
	if(CS && prob(65))
		if(!isturf(L))
			L = get_turf(pick(CS.tables))

	var/list/snacks = list(
		/obj/item/storage/box/donkpockets = 10,
		/obj/item/storage/box/sinpockets = 5,
		/obj/item/storage/box/snack = 10,
		/obj/item/storage/box/produce = 8,
		/obj/item/storage/field_ration = 3,
		/obj/item/storage/field_ration/nka = 1
	)

	var/type = pickweight(snacks)
	new type(L)

STOCK_ITEM_COMMON(posters, 3)
	new /obj/item/contraband/poster(L)
	if(prob(40))
		new /obj/item/contraband/poster(L)

STOCK_ITEM_COMMON(parts, 4)
	var/list/parts = list(
		/obj/item/stock_parts/console_screen = 3, //Low ranking parts, common
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/scanning_module = 3,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/stock_parts/micro_laser = 3,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/capacitor/adv = 1, //Improved parts, less common
		/obj/item/stock_parts/scanning_module/adv = 1,
		/obj/item/stock_parts/manipulator/nano = 1,
		/obj/item/stock_parts/micro_laser/high = 1,
		/obj/item/stock_parts/matter_bin/adv = 1,
		/obj/item/stock_parts/capacitor/super = 0.3, //Top level parts, rare
		/obj/item/stock_parts/scanning_module/phasic = 0.3,
		/obj/item/stock_parts/manipulator/pico = 0.3,
		/obj/item/stock_parts/micro_laser/ultra = 0.3,
		/obj/item/stock_parts/matter_bin/super = 0.3,
		/obj/item/stock_parts/subspace/ansible = 0.5, //Telecomms parts, useless novelties and red herrings.
		/obj/item/stock_parts/subspace/filter = 0.5,
		/obj/item/stock_parts/subspace/amplifier = 0.5,
		/obj/item/stock_parts/subspace/treatment = 0.5,
		/obj/item/stock_parts/subspace/analyzer = 0.5,
		/obj/item/stock_parts/subspace/crystal = 0.5,
		/obj/item/stock_parts/subspace/transmitter = 0.5
	)

	for(var/i in 1 to rand(1, 2))
		var/part = pickweight(parts)
		new part(L)

STOCK_ITEM_COMMON(cane, 2)
	if(prob(5))
		new /obj/item/cane/concealed(L)
	else if(prob(40))
		new /obj/item/cane/crutch(L)
	else
		new /obj/item/cane(L)

STOCK_ITEM_COMMON(warning, 2.2)
	if(prob(50))
		new /obj/item/clothing/suit/caution(L)
	else
		new /obj/item/clothing/head/cone(L)

STOCK_ITEM_COMMON(gasmask, 2)
	var/list/masks = list(
		/obj/item/clothing/mask/gas = 10,
		/obj/item/clothing/mask/gas/swat = 5,
		/obj/item/clothing/mask/gas/mime = 0.5,
		/obj/item/clothing/mask/gas/monkeymask = 0.5,
		/obj/item/clothing/mask/gas/sexymime = 0.5,
		/obj/item/clothing/mask/gas/cyborg = 1,
		/obj/item/clothing/mask/gas/owl_mask = 1
	)

	var/type = pickweight(masks)
	new type(L)

STOCK_ITEM_COMMON(mining, 2)
	var/list/mine_items = list(/obj/item/shovel, /obj/item/device/flashlight/lantern, /obj/item/mining_scanner, /obj/item/storage/box/excavation)
	for(var/i in 1 to rand(1, 2))
		var/to_spawn = pick(mine_items)
		new to_spawn(L)

STOCK_ITEM_COMMON(paicard, 2)
	new /obj/item/device/paicard(L)

STOCK_ITEM_COMMON(hide, 1)
	new /obj/item/stack/material/animalhide(L, rand(5,50))

STOCK_ITEM_COMMON(custom_ka, 1)
	new /obj/random/custom_ka(L)

STOCK_ITEM_COMMON(towel, 1)
	new /obj/item/towel(L)

STOCK_ITEM_COMMON(camera, 1)
	new /obj/item/device/camera(L)
	if(prob(60))
		new /obj/item/device/camera_film(L)

STOCK_ITEM_COMMON(nothing, 0)
	// do nothing
