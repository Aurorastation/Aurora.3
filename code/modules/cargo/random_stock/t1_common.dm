// --- Common ---

STOCK_ITEM_COMMON(toolbox, 4)
	if (prob(5))
		new /obj/item/weapon/storage/toolbox/syndicate(L)
	else
		new /obj/random/toolbox(L)

// A random low-level medical item
STOCK_ITEM_COMMON(meds, 5)
	new /obj/random/medical(L)
	new /obj/random/medical(L)
	new /obj/random/medical(L)

STOCK_ITEM_COMMON(steel, 7)
	new /obj/item/stack/material/steel(L, 50)

STOCK_ITEM_COMMON(glass, 2.5)
	if (prob(35))
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
	if (prob(5))
		LR = new /obj/item/device/lightreplacer/advanced(L)
	else
		LR = new /obj/item/device/lightreplacer(L)
	LR.uses = 0

	new /obj/item/weapon/storage/box/lights/mixed(L)
	new /obj/item/weapon/storage/box/lights/mixed(L)

//A bundle of bodybags or stasis bags
STOCK_ITEM_COMMON(bodybag, 2.2)
	if (prob(25))
		new /obj/item/bodybag/cryobag(L)
		new /obj/item/bodybag/cryobag(L)
		new /obj/item/bodybag/cryobag(L)
		new /obj/item/bodybag/cryobag(L)
	else
		new /obj/item/weapon/storage/box/bodybags(L)

STOCK_ITEM_COMMON(lamp, 2.4)
	for (var/i in 1 to rand(1, 3))
		var/obj/item/device/flashlight/lamp/P
		if (prob(50))
			P = new /obj/item/device/flashlight/lamp/green(L)
		else
			P = new /obj/item/device/flashlight/lamp(L)
		P.on = FALSE
		P.queue_icon_update()

STOCK_ITEM_COMMON(mousetrap, 2)
	new /obj/item/weapon/storage/box/mousetraps(L)

STOCK_ITEM_COMMON(donk, 2)
	if (prob(10))
		new /obj/item/weapon/storage/box/sinpockets(L)
	else
		new /obj/item/weapon/storage/box/donkpockets(L)

STOCK_ITEM_COMMON(sterile, 2)
	new /obj/item/weapon/storage/box/gloves(L)
	new /obj/item/weapon/storage/box/masks(L)

STOCK_ITEM_COMMON(light, 1.8)
	new /obj/item/weapon/storage/box/lights/mixed(L)
	if (prob(50))
		new /obj/item/weapon/storage/box/lights/mixed(L)
	if (prob(25))
		new /obj/item/weapon/storage/box/lights/coloredmixed(L)
	if (prob(15))
		var/type = pick( \
			/obj/item/weapon/storage/box/lights/colored/red, \
			/obj/item/weapon/storage/box/lights/colored/green, \
			/obj/item/weapon/storage/box/lights/colored/blue, \
			/obj/item/weapon/storage/box/lights/colored/cyan, \
			/obj/item/weapon/storage/box/lights/colored/yellow, \
			/obj/item/weapon/storage/box/lights/colored/magenta \
		)
		new type(L)

STOCK_ITEM_COMMON(aid, 4)
	new /obj/random/firstaid(L)

STOCK_ITEM_COMMON(flame, 2)
	new /obj/item/weapon/storage/box/matches(L)
	new /obj/item/weapon/flame/lighter/random(L)
	new /obj/item/weapon/storage/fancy/candle_box(L)
	new /obj/item/weapon/storage/fancy/candle_box(L)

STOCK_ITEM_COMMON(crayons, 1.5)
	new /obj/item/weapon/storage/fancy/crayons(L)

STOCK_ITEM_COMMON(figure, 1)

STOCK_ITEM_COMMON(bombsupply, 4.5)
	new /obj/random/bomb_supply(L)
	new /obj/random/bomb_supply(L)
	new /obj/random/bomb_supply(L)
	new /obj/random/bomb_supply(L)

STOCK_ITEM_COMMON(tech, 5)
	new /obj/random/tech_supply(L)
	new /obj/random/tech_supply(L)
	new /obj/random/tech_supply(L)
	new /obj/random/tech_supply(L)

STOCK_ITEM_COMMON(smokes, 2)
	new /obj/item/weapon/flame/lighter/random(L)
	if (prob(20))
		new /obj/item/weapon/storage/fancy/cigar(L)
		new /obj/item/weapon/storage/fancy/cigar(L)
	else
		new /obj/item/weapon/storage/fancy/cigarettes/custom(L)
		new /obj/item/weapon/storage/fancy/cigarettes/custom(L)
		if (prob(50))
			new /obj/item/weapon/storage/fancy/cigarettes/dromedaryco(L)
			new /obj/item/weapon/storage/fancy/cigarettes/dromedaryco(L)
			new /obj/item/weapon/storage/fancy/cigarettes/dromedaryco(L)
			new /obj/item/weapon/storage/fancy/cigarettes/dromedaryco(L)
		else
			new /obj/item/weapon/storage/fancy/cigarettes(L)
			new /obj/item/weapon/storage/fancy/cigarettes(L)
			new /obj/item/weapon/storage/fancy/cigarettes(L)
			new /obj/item/weapon/storage/fancy/cigarettes(L)

	if (prob(30))
		new /obj/item/clothing/mask/smokable/pipe(L)

STOCK_ITEM_COMMON(vials, 2)
	if (prob(20))
		new /obj/item/weapon/storage/lockbox/vials(L)
	else
		new /obj/item/weapon/storage/fancy/vials(L)

STOCK_ITEM_COMMON(smallcell, 4)
	for (var/i in 1 to rand(1, 4))
		var/type = pick( \
			/obj/item/weapon/cell, \
			/obj/item/weapon/cell/device, \
			/obj/item/weapon/cell/apc, \
			/obj/item/weapon/cell/high \
		)
		new type(L)

STOCK_ITEM_COMMON(robolimb, 2.5)
	var/manufacturer = pick(all_robolimbs)
	var/limbtype = pick( \
		/obj/item/robot_parts/l_arm, \
		/obj/item/robot_parts/r_arm, \
		/obj/item/robot_parts/l_leg, \
		/obj/item/robot_parts/r_leg \
	)
	new limbtype(L, manufacturer)

//Spawns a random circuitboard
//Allboards being a global list might be faster, but it didnt seem worth the extra memory
STOCK_ITEM_COMMON(circuitboard, 2)
	var/list/allboards = subtypesof(/obj/item/weapon/circuitboard)
	var/list/exclusion = list(
		/obj/item/weapon/circuitboard/unary_atmos,
		/obj/item/weapon/circuitboard/telecomms
	)
	exclusion += typesof(/obj/item/weapon/circuitboard/mecha)

	allboards -= exclusion
	var/type = pick(allboards)
	new type(L)

STOCK_ITEM_COMMON(smalloxy, 3.2)
	new /obj/random/smalltank(L)
	new /obj/random/smalltank(L)
	new /obj/random/smalltank(L)

STOCK_ITEM_COMMON(belts, 2)
	new /obj/random/belt(L)
	new /obj/random/belt(L)

STOCK_ITEM_COMMON(backpack, 4.5)
	new /obj/random/backpack(L)
	new /obj/random/backpack(L)

STOCK_ITEM_COMMON(weldgear, 2)
	if (prob(50))
		new /obj/item/clothing/glasses/welding(L)
	if (prob(50))
		new /obj/item/clothing/head/welding(L)
	if (prob(50))
		new /obj/item/weapon/weldpack(L)

STOCK_ITEM_COMMON(inflatable, 3)
	new /obj/item/weapon/storage/briefcase/inflatable(L)

STOCK_ITEM_COMMON(wheelchair, 1)
	//Wheelchair is not dense so it doesnt NEED a clear tile, but it looks a little silly to
	//have it on a crate. So we will attempt to find a clear tile around the spawnpoint.
	//We'll put it ontop of a crate if we need to though, its not essential to find clear space
	//In any case, we always spawn it on a turf and never in a container
	var/turf/T = get_turf(L)
	if (!turf_clear(T))
		for (var/turf/U in range(T,1))
			if (turf_clear(U))
				T = U
				break

	new /obj/structure/bed/chair/wheelchair(T)

STOCK_ITEM_COMMON(meson, 1.5)
	new /obj/item/clothing/glasses/meson(L)
	if (prob(50))
		new /obj/item/clothing/glasses/meson(L)

STOCK_ITEM_COMMON(trap, 2)
	new /obj/item/weapon/trap(L)
	if (prob(50))
		new /obj/item/weapon/trap(L)

STOCK_ITEM_COMMON(trays, 1.8)
	for (var/i in 1 to rand(1, 7))
		new /obj/item/weapon/tray(L)

STOCK_ITEM_COMMON(utensil, 2)
	new /obj/item/weapon/storage/box/kitchen(L)

STOCK_ITEM_COMMON(metalfoam, 1.5)
	new /obj/item/weapon/grenade/chem_grenade/metalfoam(L)
	new /obj/item/weapon/grenade/chem_grenade/metalfoam(L)
	new /obj/item/weapon/grenade/chem_grenade/metalfoam(L)

STOCK_ITEM_COMMON(nanopaste, 2)
	new /obj/item/stack/nanopaste(L)

STOCK_ITEM_COMMON(gloves, 3.3)
	var/list/allgloves = typesof(/obj/item/clothing/gloves)

	var/list/exclusion = list(
		/obj/item/clothing/gloves,
		/obj/item/clothing/gloves/fluff,
		/obj/item/clothing/gloves/swat/bst,
		/obj/item/clothing/gloves/swat/fluff/hawk_gloves,
		/obj/item/clothing/gloves/black/fluff/kathleen_glove,
		/obj/item/clothing/gloves/powerfist,
		/obj/item/clothing/gloves/claws
	)
	exclusion += typesof(/obj/item/clothing/gloves/rig)
	exclusion += typesof(/obj/item/clothing/gloves/lightrig)
	exclusion += typesof(/obj/item/clothing/gloves/watch)
	allgloves -= exclusion

	for (var/i in 1 to rand(1, 5))
		var/gtype = pick(allgloves)
		new gtype(L)

STOCK_ITEM_COMMON(insulated, 1.8)
	new /obj/item/clothing/gloves/yellow(L)
	new /obj/item/clothing/gloves/yellow(L)

STOCK_ITEM_COMMON(scanners, 3.2)
	//A random scanning device, most are useless
	var/list/possible = list(
		/obj/item/device/healthanalyzer = 5,
		/obj/item/device/analyzer = 0.5,
		/obj/item/device/mass_spectrometer = 0.5,
		/obj/item/device/mass_spectrometer/adv = 0.5,
		/obj/item/device/slime_scanner = 1,
		/obj/item/weapon/autopsy_scanner = 1,
		/obj/item/device/robotanalyzer = 4,
		/obj/item/weapon/mining_scanner = 1,
		/obj/item/device/ano_scanner = 1,
		/obj/item/device/reagent_scanner = 2,
		/obj/item/device/reagent_scanner/adv = 2,
		/obj/item/weapon/barcodescanner = 1,
		/obj/item/device/depth_scanner = 1,
		/obj/item/device/antibody_scanner = 0.5
	)
	for (var/i in 1 to rand(1, 3))
		var/stype = pickweight(possible)
		new stype(L)

STOCK_ITEM_COMMON(binoculars, 1.5)
	new /obj/item/device/binoculars(L)
	if (prob(50))
		new /obj/item/device/binoculars(L)

STOCK_ITEM_COMMON(flash, 1)
	new /obj/item/device/flash(L)

STOCK_ITEM_COMMON(maglock, 2)
	if (prob(50))
		new /obj/item/device/magnetic_lock/engineering(L)
	else
		new /obj/item/device/magnetic_lock/security(L)

STOCK_ITEM_COMMON(luminol, 2)
	new /obj/item/weapon/reagent_containers/spray/luminol(L)

STOCK_ITEM_COMMON(cleaning, 3.5)
	if (prob(80))
		new /obj/item/weapon/reagent_containers/glass/rag(L)
	if (prob(80))
		var/list/soaps = list(
			/obj/item/weapon/soap,
			/obj/item/weapon/soap/nanotrasen,
			/obj/item/weapon/soap/deluxe,
			/obj/item/weapon/soap/syndie
		)
		var/soaptype = pick(soaps)
		new soaptype(L)
	if (prob(80))
		new /obj/item/weapon/mop(L)

STOCK_ITEM_COMMON(bsdm, 2)
	if (prob(50))
		new /obj/item/clothing/glasses/sunglasses/blindfold(L)
	if (prob(50))
		new /obj/item/clothing/mask/muzzle(L)
	if (prob(30))
		new /obj/item/clothing/suit/straight_jacket(L)

STOCK_ITEM_COMMON(charger, 2)
	var/newtype = pick(/obj/machinery/cell_charger, /obj/machinery/recharger)
	var/obj/machinery/ma = new newtype(L)
	ma.anchored = FALSE

STOCK_ITEM_COMMON(spacesuit, 2)
	new /obj/item/clothing/suit/space(L)
	new /obj/item/clothing/head/helmet/space(L)

STOCK_ITEM_COMMON(rollerbed, 2.2)
	new /obj/item/roller(L)

STOCK_ITEM_COMMON(smokebombs, 1.1)
	new /obj/item/weapon/storage/box/smokebombs(L)

STOCK_ITEM_COMMON(jar, 2)
	new /obj/item/glass_jar(L)

STOCK_ITEM_COMMON(uvlight, 1.2)
	new /obj/item/device/uv_light(L)

STOCK_ITEM_COMMON(glasses, 1.2)
	new /obj/item/weapon/storage/box/rxglasses(L)

STOCK_ITEM_COMMON(pills, 1.2)
	var/list/options = pick( \
		/obj/item/weapon/storage/pill_bottle/bicaridine, \
		/obj/item/weapon/storage/pill_bottle/dexalin_plus, \
		/obj/item/weapon/storage/pill_bottle/dermaline, \
		/obj/item/weapon/storage/pill_bottle/dylovene, \
		/obj/item/weapon/storage/pill_bottle/inaprovaline, \
		/obj/item/weapon/storage/pill_bottle/kelotane, \
		/obj/item/weapon/storage/pill_bottle/spaceacillin, \
		/obj/item/weapon/storage/pill_bottle/tramadol \
	)
	var/newtype = pick(options)
	new newtype(L)

STOCK_ITEM_COMMON(cosmetic, 2.2)
	if (prob(50))
		new /obj/item/weapon/lipstick/random(L)
	else
		new /obj/item/weapon/haircomb(L)

STOCK_ITEM_COMMON(suitcooler, 1.2)
	new /obj/item/device/suit_cooling_unit(L)

STOCK_ITEM_COMMON(officechair, 1.2)
	var/turf/T = get_turf(L)
	if (!turf_clear(T))
		for (var/turf/U in range(T,1))
			if (turf_clear(U))
				T = U
				break
	new /obj/structure/bed/chair/office/dark(T)

STOCK_ITEM_COMMON(booze, 3.7)
	if (prob(8))//Spare keg of beer or xuizi juice
		var/turf/T = get_turf(L)
		if (!turf_clear(T))
			for (var/turf/U in range(T,1))
				if (turf_clear(U))
					T = U
					break

		if (prob(80))
			new /obj/structure/reagent_dispensers/beerkeg(T)
		else
			new /obj/structure/reagent_dispensers/xuizikeg(T)
	else
		var/list/drinks = typesof(/obj/item/weapon/reagent_containers/food/drinks/bottle)
		drinks -= /obj/item/weapon/reagent_containers/food/drinks/bottle

		for (var/i in 1 to rand(1, 3))
			var/type = pick(drinks)
			new type(L)

STOCK_ITEM_COMMON(plant, 3.5)
	var/turf/T = get_turf(L)
	if (!turf_clear(T))
		for (var/turf/U in range(T,1))
			if (turf_clear(U))
				T = U
				break
	new /obj/structure/flora/pottedplant/random(T)

STOCK_ITEM_COMMON(bag, 3.5)
	var/type = pick( \
		/obj/item/weapon/storage/bag/trash, \
		/obj/item/weapon/storage/bag/plasticbag, \
		/obj/item/weapon/storage/bag/ore, \
		/obj/item/weapon/storage/bag/plants, \
		/obj/item/weapon/storage/bag/sheetsnatcher, \
		/obj/item/weapon/storage/bag/cash, \
		/obj/item/weapon/storage/bag/books \
	)
	new type(L)
	if (prob(30))
		new type(L)

STOCK_ITEM_COMMON(extinguish, 2.2)
	for (var/i in 1 to rand(1, 3))
		var/type = pick( \
			/obj/item/weapon/extinguisher, \
			/obj/item/weapon/extinguisher/mini \
		)
		new type(L)

STOCK_ITEM_COMMON(hailer, 1.1)
	if (prob(50))
		new /obj/item/device/megaphone(L)
	else
		new /obj/item/device/hailer(L)

//A target, for target practice
//Take em up to science for gun testing
STOCK_ITEM_COMMON(target, 2)
	var/turf/T = get_turf(L)
	if (!turf_clear(T))
		for (var/turf/U in range(T,1))
			if (turf_clear(U))
				T = U
				break
	if (prob(50))
		new /obj/item/target(T)
	else
		new /obj/structure/target_stake(T)

STOCK_ITEM_COMMON(snacks, 4)
	//Snackboxes are much more likely to spawn on tables than in crates.
	//This ensures the cargo bay will have a supply of food in an obtainable place for animals
	//allows nymphs and mice to raid it for nutrients, and thus gives playermice more
	//reason to infest the warehouse
	if (CS && prob(65))
		if (!isturf(L))
			L = get_turf(pick(CS.tables))

	if(prob(50))
		new /obj/item/weapon/storage/box/snack(L)
	else
		new /obj/item/weapon/storage/box/produce(L)

STOCK_ITEM_COMMON(oxytank, 2.5)
	new /obj/item/weapon/tank/oxygen(L)
	new /obj/item/weapon/tank/oxygen(L)

STOCK_ITEM_COMMON(signs, 4)
	var/list/allsigns = subtypesof(/obj/structure/sign)
	allsigns -= typesof(/obj/structure/sign/double)
	allsigns -= typesof(/obj/structure/sign/poster)
	allsigns -= /obj/structure/sign/directions
	allsigns -= typesof(/obj/structure/sign/christmas)
	allsigns -= typesof(/obj/structure/sign/flag)

	for (var/i in 1 to rand(1, 5))
		var/newsign = pick(allsigns)
		if (newsign != /obj/structure/sign)//Dont want to spawn the generic parent class
			var/obj/structure/sign/S = new newsign(L)
			S.unfasten()

STOCK_ITEM_COMMON(posters, 3)
	new /obj/item/weapon/contraband/poster(L)
	if (prob(50))
		new /obj/item/weapon/contraband/poster(L)
	if (prob(50))
		new /obj/item/weapon/contraband/poster(L)

STOCK_ITEM_COMMON(parts, 6)
	var/list/parts = list(
		/obj/item/weapon/stock_parts/console_screen = 3, //Low ranking parts, common
		/obj/item/weapon/stock_parts/capacitor = 3,
		/obj/item/weapon/stock_parts/scanning_module = 3,
		/obj/item/weapon/stock_parts/manipulator = 3,
		/obj/item/weapon/stock_parts/micro_laser = 3,
		/obj/item/weapon/stock_parts/matter_bin = 3,
		/obj/item/weapon/stock_parts/capacitor/adv = 1, //Improved parts, less common
		/obj/item/weapon/stock_parts/scanning_module/adv = 1,
		/obj/item/weapon/stock_parts/manipulator/nano = 1,
		/obj/item/weapon/stock_parts/micro_laser/high = 1,
		/obj/item/weapon/stock_parts/matter_bin/adv = 1,
		/obj/item/weapon/stock_parts/capacitor/super = 0.3, //Top level parts, rare
		/obj/item/weapon/stock_parts/scanning_module/phasic = 0.3,
		/obj/item/weapon/stock_parts/manipulator/pico = 0.3,
		/obj/item/weapon/stock_parts/micro_laser/ultra = 0.3,
		/obj/item/weapon/stock_parts/matter_bin/super = 0.3,
		/obj/item/weapon/stock_parts/subspace/ansible = 0.5, //Telecomms parts, useless novelties and red herrings.
		/obj/item/weapon/stock_parts/subspace/filter = 0.5,
		/obj/item/weapon/stock_parts/subspace/amplifier = 0.5,
		/obj/item/weapon/stock_parts/subspace/treatment = 0.5,
		/obj/item/weapon/stock_parts/subspace/analyzer = 0.5,
		/obj/item/weapon/stock_parts/subspace/crystal = 0.5,
		/obj/item/weapon/stock_parts/subspace/transmitter = 0.5
	)

	for (var/i in 1 to rand(2, 5))
		var/part = pickweight(parts)
		new part(L)

STOCK_ITEM_COMMON(cane, 2)
	if (prob(5))
		new /obj/item/weapon/cane/concealed(L)
	else if (prob(20))
		new /obj/item/weapon/staff/broom(L)
	else
		new /obj/item/weapon/cane(L)

STOCK_ITEM_COMMON(warning, 2.2)
	if (prob(50))
		new /obj/item/weapon/caution(L)
	else
		new /obj/item/weapon/caution/cone(L)

STOCK_ITEM_COMMON(gasmask, 2)
	var/list/masks = list(
		/obj/item/clothing/mask/gas = 10,
		/obj/item/clothing/mask/gas/plaguedoctor = 1,
		/obj/item/clothing/mask/gas/swat = 5,
		/obj/item/clothing/mask/gas/clown_hat = 0.5,
		/obj/item/clothing/mask/gas/sexyclown = 0.5,
		/obj/item/clothing/mask/gas/mime = 0.5,
		/obj/item/clothing/mask/gas/monkeymask = 0.5,
		/obj/item/clothing/mask/gas/sexymime = 0.5,
		/obj/item/clothing/mask/gas/cyborg = 1,
		/obj/item/clothing/mask/gas/owl_mask = 1
	)

	var/type = pickweight(masks)
	new type(L)

STOCK_ITEM_COMMON(cleanernades, 1.5)
	new /obj/item/weapon/grenade/chem_grenade/cleaner(L)
	new /obj/item/weapon/grenade/chem_grenade/cleaner(L)
	if (prob(50))
		new /obj/item/weapon/grenade/chem_grenade/cleaner(L)
		new /obj/item/weapon/grenade/chem_grenade/cleaner(L)

STOCK_ITEM_COMMON(mining, 2)
	if (prob(50))
		new /obj/item/weapon/shovel(L)
	if (prob(50))
		new /obj/item/weapon/pickaxe(L)
	if (prob(50))
		new /obj/item/clothing/glasses/material(L)
	if (prob(50))
		new /obj/item/device/flashlight/lantern(L)
	if (prob(50))
		new /obj/item/weapon/mining_scanner(L)
	if (prob(25))
		new /obj/item/weapon/storage/box/excavation(L)

STOCK_ITEM_COMMON(paicard, 2)
	new /obj/item/device/paicard(L)

STOCK_ITEM_COMMON(phoronsheets, 2)
	new /obj/item/stack/material/phoron(L, rand(5,50))

STOCK_ITEM_COMMON(hide, 1)
	new /obj/item/stack/material/animalhide(L, rand(5,50))

STOCK_ITEM_COMMON(custom_ka, 1)
	new /obj/random/custom_ka(L)

STOCK_ITEM_COMMON(nothing, 0)
	// do nothing
