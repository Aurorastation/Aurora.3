//See Setup.dm for the configuration vars:
//TOTAL_STOCK
//STOCK_UNCOMMON_PROB
//STOCK_RARE_PROB
//STOCK_LARGE_PROB

//Their values are set there

/*
At roundstart, some items will spawn in the cargo warehouse. MANY items in fact.

Generally, 20-40 items of various sorts will spawn.

Most of them (70-90%) will be chosen from the common items list. These items are designed to be fairly
useful and likely to be helpful to the station. They will help cement cargo's supply role - as the
place to go when you want to find things you lack.

A smaller amount will be from the uncommon items. This is a combination of more powerful items, and
useless but interesting curios. The uncommon category tends towards interestingness and niche use

Rare items will spawn fairly infrequently, These are things that can have a significant
effect on the round, and most of the spawnable weapons are in these categories. Many of the rare
items are prime targets for an antag raiding cargo, or a desperate crew looking for things to fight with

Large items are a more broadly weighted category with a variety of rare and common items. The main
defining criteria of this category is that they are dense, and usually structures or machinery, and
thus require a dedicated tile for themselves to spawn in.

Many items which draw from random pools, like meds/aid/signs/figures/plushies/booze/etc,
have been given higher probabilitiesthan those which simply spawn preset items. This encourages
more variety, and keeps the odds of any one specific item to be about the same

*/



//Debugging verbs. Uncomment this block for some useful cargo debug commands
/*
var/global/stockname = ""

/client/verb/set_stock_name()
	stockname = input(usr, "Enter name", "Select stock by name") as text

/client/verb/spawn_1()
	spawn_stock(stockname, get_turf(mob))

/client/verb/spawn_10()
	var/num = 10
	while (num > 0)
		spawn_stock(stockname, get_turf(mob))
		num--

/client/verb/spawn_100()
	var/num = 100
	while (num > 0)
		spawn_stock(stockname, get_turf(mob))
		num--
*/

var/list/global/random_stock_common = list(
	"backpack" = 1,
	"drawing" = 1,
	"toolbox" = 4,
	"meds" = 5,
	"steel" = 7,
	"glass" = 2.5,
	"wood" = 2,
	"plastic" = 1.5,
	"cardboard" = 1,
	"lightreplacer" = 1,
	"bodybag" = 2.2,
	"lamp" = 2.4,
	"mousetrap" = 2,
	"donk" = 2,
	"sterile" = 2,
	"light" = 1.8,
	"aid" = 4,
	"flame" = 2,
	"bombsupply" = 4.5,
	"tech" = 5,
	"smokes" = 2,
	"vials" = 2,
	"smallcell" = 4,
	"robolimb" = 2.5,
	"circuitboard" = 2,
	"smalloxy" = 3.2,
	"belts" = 2,
	"weldgear" = 2,
	"inflatable" = 3,
	"wheelchair" = 1,
	"meson" = 1.5,
	"beartrap" = 2,
	"trays" = 0.8,
	"utensil" = 2,
	"metalfoam" = 1.5,
	"nanopaste" = 2,
	"gloves" = 3.3,
	"insulated" = 1.8,
	"scanners" = 3.2,
	"binoculars" = 1.5,
	"flash" = 1,
	"maglock" = 2,
	"luminol" = 2,
	"cleaning" = 3.5,
	"BDSM" = 2,
	"charger" = 2,
	"spacesuit" = 2,
	"rollerbed" = 2.2,
	"smokebombs" = 1.1,
	"jar" = 2,
	"uvlight" = 1.2,
	"glasses" = 1.2,
	"pills" = 1.2,
	"cosmetic" = 2.2,
	"suitcooler" = 1.2,
	"officechair" = 1.2,
	"booze" = 3.7,
	"plant" = 3.5,
	"bag" = 2,
	"extinguish" = 2.2,
	"hailer" = 1.1,
	"target" = 2,
	"snacks" = 4,
	"oxytank" = 2.5,
	"posters" = 3,
	"parts" = 6,
	"cane" = 2,
	"warning" = 2.2,
	"gasmask" = 2,
	"cleanernades" = 1.5,
	"mining" = 2,
	"paicard" = 2,
	"phoronsheets" = 2,
	"hide" = 1,
	"arcade" = 2,
	"custom_ka" = 1,
	"nothing" = 0)

var/list/global/random_stock_uncommon = list(
	"beekit" = 1,
	"glowshrooms" = 2,
	"plasteel" = 3,
	"silver" = 2,
	"phoronglass" = 2,
	"sandstone" = 2,
	"marble" = 2,
	"iron" = 2,
	"flare" = 2,
	"deathalarm" = 2,
	"trackimp" = 1,
	"flashbang" = 0.75,
	"cuffs" = 1,
	"monkey" = 2,
	"specialcrayon" = 1.5,
	"contraband" = 2,
	"mediumcell" = 3,
	"chempack" = 5,
	"robolimbs" = 3,
	"circuitboards" = 3,
	"jetpack" = 3,
	"xenocostume" = 1,
	"inhaler" = 1,
	"advwelder" = 2,
	"sord" = 1,
	"policebaton" = 1.5,
	"stunbaton" = 0.75, //batons spawn with no powercell
	"firingpin" = 3,
	"watches" = 3,
	"MMI" = 1.5,
	"voidsuit" = 2,
	"nightvision" = 2,
	"violin" = 2,
	"atmosfiresuit" = 2,
	"pdacart" = 3,
	"debugger" = 2,
	"surgerykit" = 2.5,
	"crimekit" = 1,
	"carpet" = 2,
	"gift" = 4,
	"coatrack" = 1,
	"riotshield" = 2,
	"fireaxe" = 1,
	"service" = 2,
	"robot" = 2,
	"taperoll" = 1,
	"headset" = 2,
	"bat" = 1.2,
	"scythe" = 0.75,
	"manual" = 2,
	"jammer" = 2,
	"rped" = 2,
	"briefcase" = 2,
	"blade" = 1.2,
	"exoquip" = 2,
	"laserscalpel" = 1.3,
	"electropack" = 1,
	"monkeyhide" = 0.5,
	"cathide" = 0.5,
	"corgihide" = 0.5,
	"lizardhide" = 0.5,
	"wintercoat" = 0.5,
	"cookingoil" = 1,
	"coin" = 1.3,
	"nothing" = 0)

var/list/global/random_stock_rare = list(
	"gold" = 2.5,
	"diamond" = 1.5,
	"uranium" = 3,
	"EMP" = 0.75,
	"hypercell" = 3,
	"combatmeds" = 3,
	"batterer" = 0.75,
	"posibrain" = 3,
	"bsbeaker" = 3,
	"energyshield" = 2,
	"hardsuit" = 0.75,
	"cluster" = 2.0,
	"ladder" = 3,
	"sword" = 0.5,
	"ims" = 1.5,
	"exogear" = 1.5,
	"teleporter" = 1,
	"voice" = 1.5,
	"xenohide" = 0.5,
	"humanhide" = 0.5,
	"modkit" = 1,
	"contraband" = 0.8,
	"prebuilt_ka" = 0.5,
	"nothing" = 0)

var/list/global/random_stock_large = list(
	"russian" = 1,
	"emergency" = 2,
	"firecloset" = 2,
	"tacticool" = 0.2,
	"radsuit" = 3,
	"exosuit" = 1.2,//A randomly generated exosuit in a very variable condition.
	"EOD"	= 1.5,
	"biosuit" = 3,
	"hydrotray" = 3,
	"oxycanister" = 6,//Cargo should almost always have an oxycanister
	"oxydispenser" = 5,
	"bubbleshield" = 2,
	"watertank" = 2,
	"fueltank" = 2,
	"airpump" = 1,
	"airscrubber" = 1,
	"generator" = 5,
	"flasher" = 2,
	"vendor" = 6,
	"piano" = 2,
	"suspension" = 2,
	"animal" = 2.5,
	"cablelayer" = 1,
	"floodlight" = 3,
	"floorlayer" = 2,
	"heater" = 1.3,
	"dispenser" = 2.5,
	"jukebox" = 1.2,
	"pipemachine" = 1.7,
	"bike" = 0.3,
	"sol" = 0.2,
	"dog" = 0.2,
	"nothing" = 0)


/proc/spawn_cargo_stock()
	var/start_time = world.timeofday
	new /datum/cargospawner()
	admin_notice("<span class='danger'>Cargo Stock generation completed in [round(0.1*(world.timeofday-start_time),0.1)] seconds.</span>", R_DEBUG)

/datum/cargospawner
	var/list/containers = list()
	var/list/tables = list()
	var/list/full_containers = list()//Used to hold references to crates we filled up
	var/area/warehouse
	var/list/warehouseturfs = list()

	var/list/infest_mobs_minor = list(
		/mob/living/simple_animal/mouse = 1,
		/mob/living/simple_animal/lizard = 0.5,
		/mob/living/simple_animal/yithian = 0.7,
		/mob/living/simple_animal/tindalos = 0.6,
		/mob/living/bot/secbot = 0.1)

	var/list/infest_mobs_moderate = list(
		/mob/living/simple_animal/bee/standalone = 1,
		/mob/living/simple_animal/hostile/diyaab = 1,
		/mob/living/simple_animal/hostile/viscerator = 1,
		/mob/living/simple_animal/hostile/scarybat = 1)

	var/list/infest_mobs_severe = list(
		/mob/living/simple_animal/hostile/giant_spider/hunter = 1,
		/mob/living/simple_animal/hostile/shantak = 0.7,
		/mob/living/simple_animal/hostile/bear = 0.5,
		/mob/living/simple_animal/hostile/carp = 1.5,
		/mob/living/simple_animal/hostile/carp/russian = 0.3,
		"cratey" = 1
	)

/datum/cargospawner/New()
	//First lets get the reference to our warehouse
	for(var/areapath in typesof(/area/quartermaster/storage))
		warehouse = locate(areapath)
		if (warehouse)
			for (var/turf/simulated/floor/T in warehouse)
				warehouseturfs += T
			for (var/obj/structure/closet/crate/C in warehouse)
				containers |= C
			for (var/obj/structure/table/B in warehouse)
				tables |= B

/datum/cargospawner/proc/start()
	if (!warehouse || !warehouseturfs.len)
		admin_notice("<span class='danger'>ERROR: Cargo spawner failed to locate warehouse. Terminating.</span>", R_DEBUG)
		qdel(src)
		return

	//First, we spawn the larger items
	//Large objects are spawned on preset locations around cargo
	//These locations are designated by large stock marker objects, which are manually mapped in
	for (var/obj/effect/large_stock_marker/LSM in world)
		if (prob(STOCK_LARGE_PROB))
			spawn_stock(pickweight(random_stock_large), get_turf(LSM))
		qdel(LSM)


	//Now we spawn the smaller items
	//These are spawned inside the cargo warehouse, in crates and on tables.
	var/spawns = TOTAL_STOCK
	while (spawns > 0)
		var/atom/spawnloc = get_location()
		var/spawntype = get_spawntype()
		spawn_stock(spawntype, spawnloc, src)
		spawns--

	handle_infestation()
	shuffle_items()

/datum/cargospawner/proc/get_location()
	var/cratespawn = 0
	var/obj/structure/closet/crate/emptiest
	if (prob(70))//We'll usually put items in crates
		var/minweight = 99999999999//We will distribute items somewhat evenly among crates
		//by selecting the least-filled one for each spawn

		for (var/obj/structure/closet/crate/C in containers)
			if (C.stored_weight() < minweight && C.stored_weight() < C.storage_capacity)
				minweight = C.stored_weight()
				emptiest = C
				cratespawn = 1

	if (cratespawn)
		return emptiest
	else
		//If cratespawn is zero, we either failed to find a crate to spawn in, or didnt select
		//crate spawning with the random check.
		var/turf/clearest
		var/min_items = 999999999
		for (var/B in tables)//As with crates, we attempt to distribute items evenly. Pick least-filled
			var/TB = get_turf(B)
			var/numitems = 0
			for (var/obj/item in TB)
				numitems++
			if (numitems <= min_items)
				clearest = TB
				min_items = numitems


		if (!clearest)//This should never happen
			clearest = get_turf(pick(tables))

		return clearest


/datum/cargospawner/proc/get_spawntype()
	var/list/spawntypes = list("1" = STOCK_RARE_PROB, "2" = STOCK_UNCOMMON_PROB, "3" = (100 - (STOCK_RARE_PROB + STOCK_UNCOMMON_PROB)))
	var/stocktype = pickweight(spawntypes)
	switch (stocktype)
		if ("1")
			return pickweight(random_stock_rare)
		if ("2")
			return pickweight(random_stock_uncommon)
		if ("3")
			return pickweight(random_stock_common)

//Minor and moderate mobs are checked per crate
#define INFEST_PROB_MINOR	6
#define INFEST_PROB_MODERATE	3

#define INFEST_PROB_SEVERE	3//Severe is once per round, not per crate

/datum/cargospawner/proc/handle_infestation()
	for (var/obj/O in containers)
		if (prob(INFEST_PROB_MINOR))
	//No admin message for the minor mobs, because they are friendly and harmless
			var/ctype = pickweight(infest_mobs_minor)
			new ctype(O)
		else if	 (prob(INFEST_PROB_MODERATE))
			var/ctype = pickweight(infest_mobs_moderate)
			new ctype(O)
			msg_admin_attack("Common cargo warehouse critter [ctype] spawned inside [O.name] coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[O.x];Y=[O.y];Z=[O.z]'>JMP</a>)")


	//This is checked only once per round. ~3% chance to spawn a scary monster infesting the warehouse
	if (prob(INFEST_PROB_SEVERE))
		//Find a tile to spawn the thing
		var/list/turfs = list()
		var/turf/T
		for (var/turf/t in warehouseturfs)
			T = t//Failsafe incase none are clear
			if (turf_clear(T))
				turfs |= t

		if (turfs.len)
			T = pick(turfs)

		var/ctype = pickweight(infest_mobs_severe)

		if (ctype == "cratey")
			var/obj/C = pick(containers)

			var/mob/living/simple_animal/hostile/mimic/copy/cratey

			cratey = new /mob/living/simple_animal/hostile/mimic/copy(C.loc, C, null)


			//Cratey is kinda tough but slow, easy to run away from
			cratey.name = "Cratey"
			cratey.health = 150
			cratey.maxHealth = 150
			cratey.melee_damage_lower = 7
			cratey.melee_damage_upper = 18
			cratey.knockdown_people = 1
			cratey.move_to_delay = 12

			msg_admin_attack("Cratey spawned coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[cratey.x];Y=[cratey.y];Z=[cratey.z]'>JMP</a>)")

		else
			new ctype(T)
			msg_admin_attack("Rare cargo warehouse critter [ctype] spawned coords (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)")
			return

/datum/cargospawner/proc/shuffle_items()
	for (var/obj/O in containers)
		O.contents = shuffle(O.contents)

	for (var/obj/a in tables)
		var/turf/T = get_turf(a)
		T.contents = shuffle(T.contents)


/obj/effect/large_stock_marker
	name = "Large Stock Marker"
	desc = "This marks a place where a large object could spawn in cargo"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x3"

//This function actually handles the spawning.
//If location is a turf, it will look for crates, lockers or similar containers on that turf
//to spawn items into, instead of spawning them on the floor
/proc/spawn_stock(var/stock, var/atom/L, var/datum/cargospawner/CS = null)
	//L is the location we spawn in. Using a single letter as shorthand because its written so often
	switch(stock)
		if("arcade")
			new /obj/random/arcade(L)
			new /obj/random/arcade(L)
			new /obj/random/arcade(L)

		if ("toolbox")
			if (prob(5))
				new /obj/item/weapon/storage/toolbox/syndicate(L)
			else
				new /obj/random/toolbox(L)

		if("nanopaste")
			new /obj/item/stack/nanopaste(L)

		if ("meds")//A random low level medical item
			new /obj/random/medical(L)
			new /obj/random/medical(L)
			new /obj/random/medical(L)

		if ("steel")
			new /obj/item/stack/material/steel(L, 50)

		if ("glass")
			if (prob(35))
				new /obj/item/stack/material/glass/reinforced(L, rand(10,50))
			else
				new /obj/item/stack/material/glass(L, 50)
		if("wood")
			new /obj/item/stack/material/wood(L, rand(20,50))
		if("plastic")
			new /obj/item/stack/material/plastic(L, rand(10,50))
		if("cardboard")
			new /obj/item/stack/material/cardboard(L, rand(10,50))

		if ("lightreplacer")
			//A lightreplacer and a kit of lights
			var/obj/item/device/lightreplacer/LR
			if (prob(5))
				LR = new /obj/item/device/lightreplacer/advanced(L)
			else
				LR = new /obj/item/device/lightreplacer(L)
			LR.uses = 0

			new /obj/item/weapon/storage/box/lights/mixed(L)
			new /obj/item/weapon/storage/box/lights/mixed(L)

		if("bodybag")
			//A bundle of bodybags or stasis bags
			if (prob(25))
				new /obj/item/bodybag/cryobag(L)
				new /obj/item/bodybag/cryobag(L)
				new /obj/item/bodybag/cryobag(L)
				new /obj/item/bodybag/cryobag(L)
			else
				new /obj/item/weapon/storage/box/bodybags(L)

		if ("lamp")
			var/number = rand(1,3)
			while (number > 0)
				var/obj/item/device/flashlight/lamp/P
				if (prob(50))
					P = new /obj/item/device/flashlight/lamp/green(L)
				else
					P = new /obj/item/device/flashlight/lamp(L)
				P.on = 0
				P.update_icon()
				number--

		if("mousetrap")
			new /obj/item/weapon/storage/box/mousetraps(L)
		if("donk")
			if (prob(10))
				new /obj/item/weapon/storage/box/sinpockets(L)
			else
				new /obj/item/weapon/storage/box/donkpockets(L)
		if("sterile")
			new /obj/item/weapon/storage/box/gloves(L)
			new /obj/item/weapon/storage/box/masks(L)

		if("light")
			new /obj/item/weapon/storage/box/lights/mixed(L)
			if (prob(50))
				new /obj/item/weapon/storage/box/lights/mixed(L)
			if (prob(25))
				new /obj/item/weapon/storage/box/lights/coloredmixed(L)
			if (prob(15))
				var/type = pick(list(
					/obj/item/weapon/storage/box/lights/colored/red,
					/obj/item/weapon/storage/box/lights/colored/green,
					/obj/item/weapon/storage/box/lights/colored/blue,
					/obj/item/weapon/storage/box/lights/colored/cyan,
					/obj/item/weapon/storage/box/lights/colored/yellow,
					/obj/item/weapon/storage/box/lights/colored/magenta
					))
				new type(L)
		if("aid")
			new /obj/random/firstaid(L)
		if("flame")
			new /obj/item/weapon/storage/box/matches(L)
			new /obj/item/weapon/flame/lighter/random(L)
			new /obj/item/weapon/storage/fancy/candle_box(L)
			new /obj/item/weapon/storage/fancy/candle_box(L)

		if("bombsupply")
			new /obj/random/bomb_supply(L)
			new /obj/random/bomb_supply(L)
			new /obj/random/bomb_supply(L)
			new /obj/random/bomb_supply(L)
		if("tech")
			new /obj/random/tech_supply(L)
			new /obj/random/tech_supply(L)
			new /obj/random/tech_supply(L)
			new /obj/random/tech_supply(L)

		if("smokes")
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

		if("vials")
			if (prob(20))
				new /obj/item/weapon/storage/lockbox/vials(L)
			else
				new /obj/item/weapon/storage/fancy/vials(L)

		if("smallcell")
			var/number = rand(1,4)
			while (number > 0)
				var/type = pick(list(/obj/item/weapon/cell, /obj/item/weapon/cell/device, /obj/item/weapon/cell/apc, /obj/item/weapon/cell/high))
				new type(L)
				number --

		//Spawns a robo limb with a random manufacturer
		if("robolimb")
			var/manufacturer = pick(all_robolimbs)
			var/list/limblist = list(
			/obj/item/robot_parts/l_arm,
			/obj/item/robot_parts/r_arm,
			/obj/item/robot_parts/l_leg,
			/obj/item/robot_parts/r_leg)
			var/type = pick(limblist)
			new type(L, manufacturer)
		if("circuitboard")
			//Spawns a random circuitboard
			//Allboards being a global list might be faster, but it didnt seem worth the extra memory
			var/list/allboards = subtypesof(/obj/item/weapon/circuitboard)
			var/list/exclusion = list(/obj/item/weapon/circuitboard/unary_atmos, \
				/obj/item/weapon/circuitboard/telecomms, )
			exclusion += typesof(/obj/item/weapon/circuitboard/mecha)

			allboards -= exclusion
			var/type = pick(allboards)
			new type(L)

		if("smalloxy")
			new /obj/random/smalltank(L)
			new /obj/random/smalltank(L)
			new /obj/random/smalltank(L)
		if("belts")
			new /obj/random/belt(L)
			new /obj/random/belt(L)
		if("weldgear")
			if (prob(50))
				new /obj/item/clothing/glasses/welding(L)
			if (prob(50))
				new /obj/item/clothing/head/welding(L)
			if (prob(50))
				new /obj/item/weapon/weldpack(L)
		if("inflatable")
			new /obj/item/weapon/storage/briefcase/inflatable(L)

		//Wheelchair is not dense so it doesnt NEED a clear tile, but it looks a little silly to
		//have it on a crate. So we will attempt to find a clear tile around the spawnpoint.
		//We'll put it ontop of a crate if we need to though, its not essential to find clear space
		//In any case, we always spawn it on a turf and never in a container
		if("wheelchair")
			var/turf/T = get_turf(L)
			if (!turf_clear(T))
				for (var/turf/U in range(T,1))
					if (turf_clear(U))
						T = U
						break
			new /obj/structure/bed/chair/wheelchair(T)
		if ("meson")
			new /obj/item/clothing/glasses/meson(L)
			if (prob(50))
				new /obj/item/clothing/glasses/meson(L)
		if ("beartrap")
			new /obj/item/weapon/beartrap(L)
			if (prob(50))
				new /obj/item/weapon/beartrap(L)
		if ("trays")
			var/number = rand(1,7)
			for (var/i = 0;i < number, i++)
				new /obj/item/weapon/tray(L)
		if ("utensil")
			new /obj/item/weapon/storage/box/kitchen(L)
		if ("metalfoam")
			new /obj/item/weapon/grenade/chem_grenade/metalfoam(L)
			new /obj/item/weapon/grenade/chem_grenade/metalfoam(L)
			new /obj/item/weapon/grenade/chem_grenade/metalfoam(L)
		if ("gloves")
			var/list/allgloves = typesof(/obj/item/clothing/gloves)

			var/list/exclusion = list(/obj/item/clothing/gloves,
			/obj/item/clothing/gloves/swat/bst,
			/obj/item/clothing/gloves/black/fluff,
			/obj/item/clothing/gloves/powerfist,
			/obj/item/clothing/gloves/claws)
			exclusion += typesof(/obj/item/clothing/gloves/rig)
			exclusion += typesof(/obj/item/clothing/gloves/lightrig)
			exclusion += typesof(/obj/item/clothing/gloves/watch)
			exclusion += typesof(/obj/item/clothing/gloves/swat/fluff)
			exclusion += typesof(/obj/item/clothing/gloves/black/fluff)
			exclusion += typesof(/obj/item/clothing/gloves/white/unathi/fluff)
			exclusion += typesof(/obj/item/clothing/gloves/fluff)
			allgloves -= exclusion
			var/number = rand(1,5)
			while (number > 0)
				var/gtype = pick(allgloves)
				new gtype(L)
				number--
		if ("insulated")
			new /obj/item/clothing/gloves/yellow(L)
			new /obj/item/clothing/gloves/yellow(L)
		if ("scanners")
			//A random scanning device, most are useless
			var/list/possible = list(
			/obj/item/device/healthanalyzer = 5,
			/obj/item/device/breath_analyzer = 1,
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
			var/number = rand(1,3)
			while (number > 0)
				var/stype = pickweight(possible)
				new stype(L)
				number--
		if ("binoculars")
			new /obj/item/device/binoculars(L)
			if (prob(50))
				new /obj/item/device/binoculars(L)
		if ("flash")
			new /obj/item/device/flash(L)
		if ("BDSM")
			if (prob(50))
				new /obj/item/clothing/glasses/sunglasses/blindfold(L)
			if (prob(50))
				new /obj/item/clothing/mask/muzzle(L)
			if (prob(30))
				new /obj/item/clothing/suit/straight_jacket(L)
		if ("maglock")
			if (prob(50))
				new /obj/item/device/magnetic_lock/engineering(L)
			else
				new /obj/item/device/magnetic_lock/security(L)
		if ("luminol")
			new /obj/item/weapon/reagent_containers/spray/luminol(L)
		if ("cleaning")
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
		if ("charger")
			var/list/choices = list(/obj/machinery/cell_charger, /obj/machinery/recharger)
			var/newtype = pick(choices)
			var/obj/machinery/ma = new newtype(L)
			ma.anchored = 0
		if ("spacesuit")
			new /obj/item/clothing/suit/space(L)
			new /obj/item/clothing/head/helmet/space(L)
		if ("rollerbed")
			new /obj/item/roller(L)
		if ("jar")
			new /obj/item/glass_jar(L)
		if ("smokebombs")
			new /obj/item/weapon/storage/box/smokebombs(L)
		if ("uvlight")
			new /obj/item/device/uv_light(L)
		if("glasses")
			new /obj/item/weapon/storage/box/rxglasses(L)

		//Spawns a bottle of pills, lower odds than the meds spawn
		if ("pills")
			var/list/options = list(
			/obj/item/weapon/storage/pill_bottle/bicaridine,
			/obj/item/weapon/storage/pill_bottle/dexalin_plus,
			/obj/item/weapon/storage/pill_bottle/dermaline,
			/obj/item/weapon/storage/pill_bottle/dylovene,
			/obj/item/weapon/storage/pill_bottle/inaprovaline,
			/obj/item/weapon/storage/pill_bottle/kelotane,
			/obj/item/weapon/storage/pill_bottle/spaceacillin,
			/obj/item/weapon/storage/pill_bottle/tramadol
			)
			var/newtype = pick(options)
			new newtype(L)

		if ("cosmetic")
			if (prob(50))
				new /obj/item/weapon/lipstick/random(L)
			else
				new /obj/item/weapon/haircomb(L)
		if ("suitcooler")
			new /obj/item/device/suit_cooling_unit(L)
		if ("officechair")
			var/turf/T = get_turf(L)
			if (!turf_clear(T))
				for (var/turf/U in range(T,1))
					if (turf_clear(U))
						T = U
						break
			new /obj/structure/bed/chair/office/dark(T)
		if ("booze")
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
				var/number = rand(1,3)
				while (number > 0)
					var/type = pick(drinks)
					new type(L)
					number--
		if ("plant")
			var/turf/T = get_turf(L)
			if (!turf_clear(T))
				for (var/turf/U in range(T,1))
					if (turf_clear(U))
						T = U
						break
			new /obj/structure/flora/pottedplant/random(T)
		if ("bag")
			var/list/bags = list(
			/obj/item/weapon/storage/bag/trash,
			/obj/item/weapon/storage/bag/plasticbag,
			/obj/item/weapon/storage/bag/ore,
			/obj/item/weapon/storage/bag/plants,
			/obj/item/weapon/storage/bag/sheetsnatcher,
			/obj/item/weapon/storage/bag/cash,
			/obj/item/weapon/storage/bag/books
			)
			var/type = pick(bags)
			new type(L)
			if (prob(30))
				new type(L)

		if ("extinguish")
			var/list/ext = list(
			/obj/item/weapon/extinguisher,
			/obj/item/weapon/extinguisher/mini)

			var/number = rand(1,3)
			while (number > 0)
				var/type = pick(ext)
				new type(L)
				number--
		if ("hailer")
			if (prob(50))
				new /obj/item/device/megaphone(L)
			else
				new /obj/item/device/hailer(L)


		if ("taperoll")
			if (prob(50))
				new /obj/item/taperoll/police(L)
			else
				new /obj/item/taperoll/engineering(L)

		//A target, for target practise
		//Take em up to science for gun testing
		if ("target")
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


		if ("snacks")
	//Snackboxes are much more likely to spawn on tables than in crates.
	//This ensures the cargo bay will have a supply of food in an obtainable place for animals
	//allows nymphs and mice to raid it for nutrients, and thus gives playermice more
	//reason to infest the warehouse
			if (CS && prob(65))
				if (!istype(L, /turf))
					L = get_turf(pick(CS.tables))

			new /obj/item/weapon/storage/box/snack(L)

		if ("oxytank")
			new /obj/item/weapon/tank/oxygen(L)
			new /obj/item/weapon/tank/oxygen(L)

		//Parts used for machines
		//Also includes the telecomms parts even though they're useless
		//Because they are interesting
		if ("parts")
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

			var/number = rand(2,5)
			while (number > 0)
				var/part = pickweight(parts)
				new part(L)
				number--


		if ("cane")
			if (prob(5))
				new /obj/item/weapon/cane/concealed(L)
			else if (prob(20))
				new /obj/item/weapon/staff/broom(L)
			else
				new /obj/item/weapon/cane(L)

		if ("warning")
			if (prob(50))
				new /obj/item/weapon/caution(L)
			else
				new /obj/item/weapon/caution/cone(L)

		if ("gasmask")
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

		if ("cleanernades")
			if(prob(90))
				new /obj/item/weapon/grenade/chem_grenade/cleaner(L)
				new /obj/item/weapon/grenade/chem_grenade/cleaner(L)
			else
				new /obj/item/weapon/grenade/chem_grenade/large/phoroncleaner(L)

		if ("mining")
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

		if ("paicard")
			new /obj/item/device/paicard(L)

		if ("phoronsheets")
			new /obj/item/stack/material/phoron(L, rand(5,50))

		if ("hide")
			new /obj/item/stack/material/animalhide(L, rand(5,50))

		if("drawing")
			var/list/drawing = list(
				/obj/item/weapon/pen/crayon/rainbow = 2,
				/obj/item/weapon/pen/crayon/mime = 2,
				/obj/item/weapon/storage/fancy/crayons = 4,
				/obj/item/weapon/pen/chameleon = 1,
				/obj/item/weapon/pen/invisible = 2,
				/obj/item/weapon/pen/multi = 2
			)
			var/type = pickweight(drawing)
			new type(L)

		if("backpack")
			var/obj/item/weapon/storage/pack =  new /obj/random/backpack(src)
			if(istype(pack) && prob(75))
				new /obj/random/loot(pack)
				new /obj/random/loot(pack)
				new /obj/random/loot(pack)


//Uncommon items below here
//=============================================================
//=============================================================
//=============================================================
		if("beekit")
			new /obj/item/bee_pack(src)
			new /obj/item/weapon/bee_net(src)
			new /obj/item/weapon/bee_smoker(src)
		if("glowshrooms")
			new /obj/item/seeds/glowshroom(L)
			new /obj/item/seeds/glowshroom(L)
			new /obj/item/seeds/glowshroom(L)
		if("plasteel")
			new /obj/item/stack/material/plasteel(L, rand(1,30))
		if("silver")
			new /obj/item/stack/material/silver(L, rand(5,30))
		if("phoronglass")
			new /obj/item/stack/material/glass/phoronglass(L, 50)
		if("sandstone")
			new /obj/item/stack/material/sandstone(L, 50)
		if("marble")
			new /obj/item/stack/material/marble(L, 50)
		if("iron")
			new /obj/item/stack/material/iron(L, 50)
		if ("flare")
			new /obj/item/device/flashlight/flare(L)
			new /obj/item/device/flashlight/flare(L)
			if (prob(50))
				new /obj/random/glowstick(L)
		if("deathalarm")
			new /obj/item/weapon/storage/box/cdeathalarm_kit(L)
		if("trackimp")
			new /obj/item/weapon/storage/box/trackimp(L)
		if("flashbang")
			new /obj/item/weapon/storage/box/flashbangs(L)
		if("cuffs")
			new /obj/item/weapon/storage/box/handcuffs(L)
		if("monkey")
			if (prob(40))
				var/type = pick(list(/obj/item/weapon/storage/box/monkeycubes/farwacubes,
					/obj/item/weapon/storage/box/monkeycubes/stokcubes,
					/obj/item/weapon/storage/box/monkeycubes/neaeracubes))
				new type(L)
			else
				new /obj/item/weapon/storage/box/monkeycubes(L)
		if("specialcrayon")
			if (prob(50))
				new /obj/item/weapon/pen/crayon/mime(L)
			else
				new /obj/item/weapon/pen/crayon/rainbow(L)
		if("contraband")
			var/number = rand(1,8)
			while (number > 0)
				new /obj/random/contraband(L)
				number--
		if("firingpin")
			new /obj/item/weapon/storage/box/firingpins(L)
		if("mediumcell")
			var/number = rand(1,2)
			while (number > 0)
				var/type = pick(list(/obj/item/weapon/cell/super, /obj/item/weapon/cell/potato, /obj/item/weapon/cell/high))
				new type(L)
				number --

		//Spawns several random chemical cartridges
		//Can be slotted into any dispenser
		if("chempack")
			var/total = rand(2,6)
			var/list/chems = SSchemistry.chemical_reagents.Copy()
			var/list/exclusion = list("drink", "reagent", "adminordrazine", "beer2", "azoth", "elixir_life", "liquid_fire", "philosopher_stone", "undead_ichor", "love", "shapesand", "usolve", "sglue", "black_matter")
			chems -= exclusion
			for (var/i=0,i<total,i++)
				var/obj/item/weapon/reagent_containers/chem_disp_cartridge/C = new /obj/item/weapon/reagent_containers/chem_disp_cartridge(L)
				var/rname = pick(chems)
				var/datum/reagent/R = SSchemistry.chemical_reagents[rname]

				//If we get a drink, reroll it once.
				//Should result in a higher chance of getting medicines and chemicals
				if (istype(R, /datum/reagent/drink) || istype(R, /datum/reagent/alcohol/ethanol))
					rname = pick(chems)
					R = SSchemistry.chemical_reagents[rname]
				C.reagents.add_reagent(rname, C.volume)
				C.setLabel(R.name)

		//Spawns several robo limbs with random manufacturers
		if("robolimbs")
			var/list/limblist = list(
			/obj/item/robot_parts/l_arm,
			/obj/item/robot_parts/r_arm,
			/obj/item/robot_parts/l_leg,
			/obj/item/robot_parts/r_leg)
			var/number = rand(2,5)
			while (number > 0)
				var/manufacturer = pick(all_robolimbs)
				var/type = pick(limblist)
				new type(L, manufacturer)
				number--

		//Spawns several random circuitboards
		if("circuitboards")
			var/list/allboards = subtypesof(/obj/item/weapon/circuitboard)
			var/list/exclusion = list(/obj/item/weapon/circuitboard/unary_atmos, \
				/obj/item/weapon/circuitboard/telecomms, )
			exclusion += typesof(/obj/item/weapon/circuitboard/mecha)

			allboards -= exclusion

			var/number = rand(2,5)
			while (number > 0)
				var/type = pick(allboards)
				new type(L)
				number--

		if("jetpack")
			new /obj/item/weapon/tank/jetpack/void(L)
			new /obj/item/weapon/tank/emergency_oxygen/double(L)

		if ("xenocostume")
			new /obj/item/clothing/suit/xenos(L)
			new /obj/item/clothing/head/xenos(L)
		if ("advwelder")
			new /obj/item/weapon/weldingtool/hugetank(L)

		if ("sord")
			new /obj/item/weapon/sord(L)
		if ("policebaton")
			new /obj/item/weapon/melee/classic_baton(L)
		if ("stunbaton")
			//Batons are put into storage without their powercell
			var/obj/item/weapon/melee/baton/B = new /obj/item/weapon/melee/baton(L)
			B.bcell = null
			B.update_icon()
		if ("watches")
			new /obj/item/clothing/gloves/watch(L)
			new /obj/item/clothing/gloves/watch(L)
			new /obj/item/clothing/gloves/watch(L)

		if ("MMI")
			new /obj/item/device/mmi(L)
		if ("voidsuit")
			new /obj/random/voidsuit(L,1)

		if ("posters")
			new /obj/item/weapon/contraband/poster(L)
			if (prob(50))
				new /obj/item/weapon/contraband/poster(L)
			if (prob(50))
				new /obj/item/weapon/contraband/poster(L)

		if ("violin")
			new /obj/item/device/violin(L)
		if ("nightvision")
			new /obj/item/clothing/glasses/night(L)
		if ("atmosfiresuit")
			new /obj/item/clothing/head/hardhat/red/atmos(L)
			new /obj/item/clothing/suit/fire/atmos(L)
		if ("pdacart")
			var/number = rand(1,4)
			while (number > 0)
				new /obj/random/pda_cart(L)
				number--
		if ("surgerykit")
			new /obj/item/weapon/storage/firstaid/surgery(L)
		if ("debugger")
			new /obj/item/device/debugger(L)//No idea what this thing does, or if it works at all
		if ("crimekit")
			new /obj/item/weapon/storage/briefcase/crimekit(L)
		if ("carpet")
			new /obj/item/stack/tile/carpet(L, 50)
		if ("gift")
			new /obj/item/weapon/a_gift(L)
		if ("coatrack")
			var/turf/T = get_turf(L)
			if (!turf_clear(T))
				for (var/turf/U in range(T,1))
					if (turf_clear(U))
						T = U
						break
			new /obj/structure/coatrack(T)


		if ("riotshield")
			new /obj/item/weapon/shield/riot(L)
			if (prob(60))
				new /obj/item/weapon/shield/riot(L)
		if ("fireaxe")
			new /obj/item/weapon/material/twohanded/fireaxe(L)
		if ("service")
			new /obj/item/weapon/rsf(L)

		//Spawns a random deactivated bot
		if ("robot")
			var/list/bots = list(
			/mob/living/bot/cleanbot = 2,
			/mob/living/bot/secbot = 0.7,
			/mob/living/bot/medbot = 2,
			/mob/living/bot/floorbot = 2.5,
			/mob/living/bot/farmbot = 1,
			/mob/living/bot/secbot/ed209 = 0.3
			)

			var/type = pickweight(bots)
			if (type == "/mob/living/bot/secbot/ed209")//ED is large and should spawn on the floor
				L = get_turf(L)
				if (!turf_clear(L))
					for (var/turf/U in range(L,1))
						if (turf_clear(U))
							L = U
							break
			var/mob/living/bot/newbot = new type(L)
			newbot.on = 0//Deactivated
			if (prob(10))
				newbot.emag_act(9999,null)

	//Random headsets for low-security department
	//No command or sec
		if ("headset")
			var/list/sets = list(
			/obj/item/device/radio/headset/headset_eng = 1,
			/obj/item/device/radio/headset/headset_rob = 0.4,
			/obj/item/device/radio/headset/headset_med = 1,
			/obj/item/device/radio/headset/headset_sci = 0.8,
			/obj/item/device/radio/headset/headset_medsci = 0.4,
			/obj/item/device/radio/headset/headset_cargo = 1,
			/obj/item/device/radio/headset/headset_service = 1
			)

			var/type = pickweight(sets)
			new type(L)

		if ("bat")
			new /obj/item/weapon/material/twohanded/baseballbat(L)

		if ("scythe")
			new /obj/item/weapon/material/scythe(L)

	//Spawns a random manual book. These are mostly outdated, inaccurate, and obsolete.
	//This is here for novelty effect and these manuals shouldn't actually be followed
	//Only the manuals that actually contain stuff are here. Those that just link to a wiki page are excluded
		if ("manual")
			var/list/manuals = list(
			/obj/item/weapon/book/manual/excavation,
			/obj/item/weapon/book/manual/mass_spectrometry,
			/obj/item/weapon/book/manual/anomaly_spectroscopy,
			/obj/item/weapon/book/manual/materials_chemistry_analysis,
			/obj/item/weapon/book/manual/anomaly_testing,
			/obj/item/weapon/book/manual/stasis,
			/obj/item/weapon/book/manual/engineering_particle_accelerator,
			/obj/item/weapon/book/manual/supermatter_engine,
			/obj/item/weapon/book/manual/engineering_singularity_safety,
			/obj/item/weapon/book/manual/medical_cloning,
			/obj/item/weapon/book/manual/ripley_build_and_repair,
			/obj/item/weapon/book/manual/research_and_development,
			/obj/item/weapon/book/manual/robotics_cyborgs,
			/obj/item/weapon/book/manual/medical_diagnostics_manual,
			/obj/item/weapon/book/manual/chef_recipes,
			/obj/item/weapon/book/manual/barman_recipes,
			/obj/item/weapon/book/manual/detective,
			/obj/item/weapon/book/manual/nuclear,
			/obj/item/weapon/book/manual/atmospipes,
			/obj/item/weapon/book/manual/evaguide
			)

			var/type = pick(manuals)
			new type(L)

		if ("jammer")
			new /obj/item/device/radiojammer(L)

		if ("rped")
			new /obj/item/weapon/storage/part_replacer(L)


		if ("briefcase")
			if (prob(20))
				new /obj/item/weapon/storage/secure/briefcase(L)
			else
				new /obj/item/weapon/storage/briefcase(L)

		if ("blade")
			var/list/blades = list(
			/obj/item/weapon/material/butterfly = 1,
			/obj/item/weapon/material/butterfly/switchblade = 1,
			/obj/item/weapon/material/knife/hook = 1.5,
			/obj/item/weapon/material/knife/ritual = 1.5,
			/obj/item/weapon/material/knife/butch = 1,
			/obj/item/weapon/material/hatchet = 1.5,
			/obj/item/weapon/material/hatchet/unathiknife = 0.75,
			/obj/item/weapon/material/hatchet/tacknife = 1
			)

			var/type = pickweight(blades)
			new type(L)

				//a single random exosuit attachment from a limited list,
		//with some of the more overpowered ones excluded
		if ("exoquip")
			var/list/equips = list(
			/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp = 1,
			/obj/item/mecha_parts/mecha_equipment/tool/drill = 1,
			/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill = 0.7,
			/obj/item/mecha_parts/mecha_equipment/tool/extinguisher = 1,
			/obj/item/mecha_parts/mecha_equipment/tool/rcd = 0.08,
			/obj/item/mecha_parts/mecha_equipment/teleporter = 0.3,
			/obj/item/mecha_parts/mecha_equipment/wormhole_generator = 0.5,
			/obj/item/mecha_parts/mecha_equipment/gravcatapult = 0.8,
			/obj/item/mecha_parts/mecha_equipment/armor_booster/anticcw_armor_booster = 1,
			/obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster = 0.9,
			/obj/item/mecha_parts/mecha_equipment/repair_droid = 0.7,
			/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay = 0.4,
			/obj/item/mecha_parts/mecha_equipment/generator = 1.5,
			/obj/item/mecha_parts/mecha_equipment/generator/nuclear = 0.8,
			/obj/item/mecha_parts/mecha_equipment/tool/safety_clamp = 0.2,
			/obj/item/mecha_parts/mecha_equipment/tool/passenger = 1,
			/obj/item/mecha_parts/mecha_equipment/tool/sleeper = 0.9,
			/obj/item/mecha_parts/mecha_equipment/tool/cable_layer = 1.2,
			/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun = 1
			)

			var/type = pickweight(equips)
			new type(L)

		if ("laserscalpel")
			var/list/lasers = list(
			/obj/item/weapon/scalpel/laser1 = 3,
			/obj/item/weapon/scalpel/laser2 = 2,
			/obj/item/weapon/scalpel/laser3 = 1
			)
			var/type = pickweight(lasers)
			new type(L)

		if ("electropack")
			new /obj/item/device/radio/electropack(L)

			if (istype(L, /obj/structure/closet/crate) && prob(40))
				var/obj/structure/closet/crate/cr = L
				cr.rigged = 1//Boobytrapped crate, will electrocute when you attempt to open it
				//Can be disarmed with wirecutters or ignored with insulated gloves

		if("monkeyhide")
			new /obj/item/stack/material/animalhide/monkey(L, 50)

		if("cathide")
			new /obj/item/stack/material/animalhide/cat(L, 50)

		if("corgihide")
			new /obj/item/stack/material/animalhide/corgi(L, 50)

		if("lizardhide")
			new /obj/item/stack/material/animalhide/lizard(L, 50)

		if ("wintercoat")
			new /obj/random/hoodie(L)

		if("cookingoil")
			var/turf/T = get_turf(L)
			if (!turf_clear(T))
				for (var/turf/U in range(T,1))
					if (turf_clear(U))
						T = U
						break
			new /obj/structure/reagent_dispensers/cookingoil(T)

		if("coin")
			new /obj/random/coin(L)


//Rare items below here:
//=============================================================
//=============================================================
//=============================================================
		if("prebuilt_ka")
			new /obj/random/prebuilt_ka(L)
		if("custom_ka")
			new /obj/random/custom_ka(L)
		if("gold")
			new /obj/item/stack/material/gold(L, rand(2,15))
		if("diamond")
			new /obj/item/stack/material/diamond(L, rand(1,10))
		if("uranium")
			new /obj/item/stack/material/uranium(L, rand(5,30))
		if("EMP")
			new /obj/item/weapon/storage/box/emps(L)
		if("hypercell")
			new /obj/item/weapon/cell/hyper(L)
		if("combatmeds")
			new /obj/item/weapon/storage/firstaid/combat(L)
		if("batterer")
			new /obj/item/device/batterer(L)
		if("posibrain")
			new /obj/item/device/mmi/digital/posibrain(L)
		if("bsbeaker")
			new /obj/item/weapon/reagent_containers/glass/beaker/bluespace(L)
			if (prob(50))
				new /obj/item/weapon/reagent_containers/glass/beaker/bluespace(L)
		if("energyshield")
			new /obj/item/weapon/shield/energy(L)
		if("cluster")
			new /obj/item/weapon/grenade/flashbang/clusterbang(L)
		if("ladder")
			new /obj/item/weapon/ladder_mobile(L)
		if("sword")
			new /obj/random/sword(L)
		if("ims")
			new /obj/item/weapon/scalpel/manager(L)
		if("hardsuit")
			//A random RIG/hardsuit
			//It will come with some screwy electronics and possibly need reprogramming
			var/list/rigs = list(
			/obj/item/weapon/rig/unathi = 2,
			/obj/item/weapon/rig/unathi/fancy = 0.75,
			/obj/item/weapon/rig/combat = 0.1,
			/obj/item/weapon/rig/ert = 0.1,
			/obj/item/weapon/rig/ert/engineer = 0.1,
			/obj/item/weapon/rig/ert/medical = 0.15,
			/obj/item/weapon/rig/ert/security = 0.075,
			/obj/item/weapon/rig/ert/assetprotection = 0.05,
			/obj/item/weapon/rig/light = 0.5,
			/obj/item/weapon/rig/light/hacker = 0.8,
			/obj/item/weapon/rig/light/stealth = 0.5,
			/obj/item/weapon/rig/merc/empty = 0.5,
			/obj/item/weapon/rig/industrial = 3,
			/obj/item/weapon/rig/eva = 3,
			/obj/item/weapon/rig/ce = 2,
			/obj/item/weapon/rig/hazmat = 4,
			/obj/item/weapon/rig/medical = 4,
			/obj/item/weapon/rig/hazard = 3,
			/obj/item/weapon/rig/diving = 1
			)

			var/type = pickweight(rigs)
			var/obj/item/weapon/rig/module = new type(L)

			//screw it up a bit
			var/cnd = rand(40,100)
			module.lose_modules(cnd)
			module.misconfigure(cnd)
			module.sabotage_cell()
			module.sabotage_tank()


		//Several random non-weapon exosuit attachments
		if ("exogear")
			var/list/equips = list(
			/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp = 1,
			/obj/item/mecha_parts/mecha_equipment/tool/drill = 1,
			/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill = 0.7,
			/obj/item/mecha_parts/mecha_equipment/tool/extinguisher = 1,
			/obj/item/mecha_parts/mecha_equipment/tool/rcd = 0.08,
			/obj/item/mecha_parts/mecha_equipment/teleporter = 0.3,
			/obj/item/mecha_parts/mecha_equipment/wormhole_generator = 0.5,
			/obj/item/mecha_parts/mecha_equipment/gravcatapult = 0.8,
			/obj/item/mecha_parts/mecha_equipment/armor_booster/anticcw_armor_booster = 1,
			/obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster = 0.9,
			/obj/item/mecha_parts/mecha_equipment/repair_droid = 0.7,
			/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay = 0.4,
			/obj/item/mecha_parts/mecha_equipment/generator = 1.5,
			/obj/item/mecha_parts/mecha_equipment/generator/nuclear = 0.8,
			/obj/item/mecha_parts/mecha_equipment/tool/safety_clamp = 0.2,
			/obj/item/mecha_parts/mecha_equipment/tool/passenger = 1,
			/obj/item/mecha_parts/mecha_equipment/tool/sleeper = 0.9,
			/obj/item/mecha_parts/mecha_equipment/tool/cable_layer = 1.2,
			/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun = 1
			)


			var/number = rand(2,5)
			while (number > 0)
				var/type = pickweight(equips)
				new type(L)
				number--

		if ("teleporter")
			new /obj/item/weapon/hand_tele(L)

		if ("voice")
			new /obj/item/clothing/mask/gas/voice(L)

		if("xenohide")
			new /obj/item/stack/material/animalhide/xeno(L, rand(2,15))

		if("humanhide")
			new /obj/item/stack/material/animalhide/human(L, rand(2,15))

		if("modkit")
			var/list/modkits = list(
			/obj/item/device/kit/paint/ripley,
			/obj/item/device/kit/paint/ripley/death,
			/obj/item/device/kit/paint/ripley/flames_red,
			/obj/item/device/kit/paint/ripley/flames_blue,
			/obj/item/device/kit/paint/ripley/titan,
			/obj/item/device/kit/paint/ripley/earth,
			/obj/item/device/kit/paint/durand,
			/obj/item/device/kit/paint/durand/seraph,
			/obj/item/device/kit/paint/durand/phazon,
			/obj/item/device/kit/paint/gygax,
			/obj/item/device/kit/paint/gygax/darkgygax,
			/obj/item/device/kit/paint/gygax/recitence
			)

			var/type = pick(modkits)
			new type(L)

		if ("contraband")
			new /obj/random/contraband(L)

		if ("inhaler")
			if(prob(33))
				if(prob(10))
					new/obj/item/weapon/storage/box/inhalers_large(src)
				else
					new /obj/item/weapon/storage/box/inhalers(src)
			else
				var/number = rand(2,3)
				var/list/inhalers = list(
					/obj/item/weapon/reagent_containers/inhaler/dexalin = 8,
					/obj/item/weapon/reagent_containers/inhaler/hyperzine = 2,
					/obj/item/weapon/reagent_containers/inhaler/phoron = 2,
					/obj/item/weapon/reagent_containers/inhaler/soporific = 1,
					/obj/item/weapon/reagent_containers/inhaler/space_drugs = 3
				)
				while(number > 0)
					var/type = pickweight(inhalers)
					var/obj/item/weapon/reagent_containers/inhaler/spawned = new type(L)
					if(prob(10) || istype(spawned,/obj/item/weapon/reagent_containers/inhaler/space_drugs))
						spawned.name = "unlabeled inhaler"
						spawned.desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel. This one is unlabeled."
					number -= 1

				if(prob(33))
					new /obj/item/device/breath_analyzer(L)




//Large items go below here
//=============================================================
//=============================================================
//=============================================================
		if ("oxycanister")
			new /obj/machinery/portable_atmospherics/canister/oxygen(L)
		if ("oxydispenser")
			new /obj/structure/dispenser/oxygen(L)
		if ("bubbleshield")
			var/obj/O = new /obj/machinery/shield_gen(L)
			var/turf/T = get_turf(O)
			for (var/turf/U in range(O,1))
				if (turf_clear(U))
					T = U
					break
			new /obj/machinery/shield_capacitor(T)
		if ("hydrotray")
			new /obj/machinery/portable_atmospherics/hydroponics(L)
		if ("watertank")
			new /obj/structure/reagent_dispensers/watertank(L)
		if ("fueltank")
			new /obj/structure/reagent_dispensers/fueltank(L)
		if ("EOD")
			if (prob(33))
				new /obj/structure/closet/bombclosetsecurity(L)
			else
				new /obj/structure/closet/bombcloset(L)
		if ("biosuit")
			var/list/allsuits = typesof(/obj/structure/closet/l3closet)
			var/type = pick(allsuits)
			new type(L)
		if ("tacticool")
			new /obj/structure/closet/gimmick/tacticool(L)
		if ("emergency")
			new /obj/structure/closet/emcloset(L)
		if ("russian")
			new /obj/structure/closet/gimmick/russian(L)
		if ("firecloset")
			new /obj/structure/closet/firecloset(L)
		if ("radsuit")
			new /obj/structure/closet/radiation(L)

		if ("airpump")
			var/obj/machinery/portable_atmospherics/powered/M = new /obj/machinery/portable_atmospherics/powered/pump/filled(L)
			if (prob(60))
				M.cell = null
		if ("airscrubber")
			var/obj/machinery/portable_atmospherics/powered/M = new /obj/machinery/portable_atmospherics/powered/scrubber(L)
			if (prob(60))
				M.cell = null

		if ("suspension")//Xenoarch suspension field generator, they need a spare
			new /obj/machinery/suspension_gen(L)

		if ("flasher")
			new /obj/machinery/flasher/portable(L)
		if ("vendor")
			new /obj/random/vendor(L, 1)

		if ("piano")
			new /obj/structure/device/piano(L)

		if ("cablelayer")
			new /obj/machinery/cablelayer(L)

		if ("floodlight")
			new /obj/machinery/floodlight(L)

		if ("heater")
			new /obj/machinery/space_heater(L)

		if ("generator")
			var/list/generators = list(
				/obj/machinery/power/port_gen/pacman = 1,
				/obj/machinery/power/port_gen/pacman/super = 0.7,
				/obj/machinery/power/port_gen/pacman/mrs = 0.5
			)
			var/type = pickweight(generators)
			new type(L)

		//Spawns a reagent dispenser without most of its cartridges
		if ("dispenser")
			var/list/dispensers = list(
				/obj/machinery/chemical_dispenser/bar_alc/full = 0.6,
				/obj/machinery/chemical_dispenser/bar_soft/full = 1,
				/obj/machinery/chemical_dispenser/full = 0.3
			)
			var/type = pickweight(dispensers)
			var/obj/machinery/chemical_dispenser/CD = new type(L)
			CD.anchored = 0
			for (var/cart in CD.cartridges)
				if (prob(90))
					CD.cartridges -= cart


	//Spawns a random live animal crate
		if ("animal")
			var/list/animals = list(/obj/structure/largecrate/animal/chick,
			/obj/structure/largecrate/animal/cat,
			/obj/structure/largecrate/animal/goat,
			/obj/structure/largecrate/animal/cow,
			/obj/structure/largecrate/animal/corgi)
			var/type = pick(animals)
			new type(L)

		if ("floorlayer")
			new /obj/machinery/floorlayer(L)

		if ("jukebox")
			new /obj/machinery/media/jukebox(L)

		if ("pipemachine")
			if (prob(50))
				new /obj/machinery/pipedispenser/disposal(L)
			else
				new /obj/machinery/pipedispenser(L)

		if ("bike")
			new /obj/vehicle/bike(L)

		if ("sol")
			if (prob(50))
				new /obj/structure/closet/sol/navy(L)
			else
				new /obj/structure/closet/sol/marine(L)
		if ("dog")
			var/list/dogs = list(/obj/structure/largecrate/animal/dog,
			/obj/structure/largecrate/animal/dog/amaskan,
			/obj/structure/largecrate/animal/dog/pug)
			var/type = pick(dogs)
			new type(L)

	//This will be complex
	//Spawns a random exosuit, Probably not in good condition
	//It may be missing a cell, have hull damage or internal damage
		if ("exosuit")

			//First up, weighted list of suits to spawn.
			//Some of these come preloaded with modules
			//Those which have dangerous modules have lower weights

			//We may farther remove modules to mitigate it
			var/list/randsuits = list(
			/obj/mecha/working/hoverpod = 5,
			/obj/mecha/working/hoverpod/combatpod = 0.5,//Comes with weapons
			/obj/mecha/working/hoverpod/shuttlepod = 6,
			/obj/mecha/working/ripley = 5,
			/obj/mecha/working/ripley/firefighter = 6,
			/obj/mecha/working/ripley/deathripley = 0.5,//has a dangerous melee weapon
			/obj/mecha/working/ripley/mining = 4,
			/obj/mecha/medical/odysseus = 6,
			/obj/mecha/medical/odysseus/loaded = 5,
			/obj/mecha/combat/durand = 1,//comes unarmed
			/obj/mecha/combat/gygax = 1.5,//comes unarmed
			/obj/mecha/combat/gygax/dark = 0.5,//has weapons
			/obj/mecha/combat/marauder = 0.6,
			/obj/mecha/combat/marauder/seraph = 0.3,
			/obj/mecha/combat/marauder/mauler = 0.4,
			/obj/mecha/combat/phazon = 0.1,
			/obj/mecha/combat/honker = 0.01
			)
			var/type = pickweight(randsuits)
			var/obj/mecha/exosuit = new type(get_turf(L))
			//Now we determine the exosuit's condition
			var/cnd = rand(0,100)
			switch (cnd)
				if (0 to 3)
				//Perfect condition, it was well cared for and put into storage in a pristine state
				//Nothing is done to it.
				if (4 to 10)
				//Poorly maintained.
				//The internal airtank and power cell will be somewhat depleted, otherwise intact
					var/P = rand(0,50)
					P /= 100
					if (exosuit.cell)//Set the cell to a random charge below 50%
						exosuit.cell.charge =  exosuit.cell.maxcharge * P

					P = rand(50,100)
					P /= 100
					if(exosuit.internal_tank)//remove 50-100% of airtank contents
						exosuit.internal_tank.air_contents.remove(exosuit.internal_tank.air_contents.total_moles * P)


				if (11 to 20)
				//Wear and tear
				//Hull has light to moderate damage, tank and cell are depleted
				//Any equipment will have a 25% chance to be lost
					var/P = rand(0,30)
					P /= 100
					if (exosuit.cell)//Set the cell to a random charge below 50%
						exosuit.cell.charge =  exosuit.cell.maxcharge * P

					P = rand(70,100)
					P /= 100
					if(exosuit.internal_tank)//remove 50-100% of airtank contents
						exosuit.internal_tank.air_contents.remove(exosuit.internal_tank.air_contents.total_moles * P)

					exosuit.lose_equipment(25)//Lose modules

					P = rand(10,100)//Set hull integrity
					P /= 100
					exosuit.health = initial(exosuit.health)*P


				if (21 to 40)
				//Severe damage
				//Power cell has 50% chance to be missing or is otherwise low
				//Significant chance for internal damage
				//Hull integrity less than half
				//Each module has a 50% loss chance
				//Systems may be misconfigured
					var/P

					if (prob(50))//Remove cell
						exosuit.cell = null
					else
						P = rand(0,20)//or deplete it
						P /= 100
						if (exosuit.cell)//Set the cell to a random charge below 50%
							exosuit.cell.charge =  exosuit.cell.maxcharge * P

					P = rand(80,100)
					P /= 100//Deplete tank
					if(exosuit.internal_tank)//remove 50-100% of airtank contents
						exosuit.internal_tank.air_contents.remove(exosuit.internal_tank.air_contents.total_moles * P)

					exosuit.lose_equipment(50)//Lose modules
					exosuit.random_internal_damage(15)//Internal damage

					P = rand(5,50)//Set hull integrity
					P /= 100
					exosuit.health = initial(exosuit.health)*P
					exosuit.misconfigure_systems(15)


				if (41 to 80)
				//Decomissioned
				//The exosuit is a writeoff, it was tossed into storage for later scrapping.
				//Wasnt considered worth repairing, but you still can
				//Power cell missing, internal tank completely drained or ruptured/
				//65% chance for each type of internal damage
				//90% chance to lose each equipment
				//System settings will be randomly configured
					var/P
					if (prob(15))
						exosuit.cell.rigged = 1//Powercell will explode if you use it
					else if (prob(50))//Remove cell
						exosuit.cell = null

					if (exosuit.cell)
						P = rand(0,20)//or deplete it
						P /= 100
						if (exosuit.cell)//Set the cell to a random charge below 50%
							exosuit.cell.charge =  exosuit.cell.maxcharge * P

					exosuit.lose_equipment(90)//Lose modules
					exosuit.random_internal_damage(50)//Internal damage

					if (!exosuit.hasInternalDamage(MECHA_INT_TANK_BREACH))//If the tank isn't breaches
						qdel(exosuit.internal_tank)//Then delete it
						exosuit.internal_tank = null

					P = rand(5,50)//Set hull integrity
					P /= 100
					exosuit.health = initial(exosuit.health)*P
					exosuit.misconfigure_systems(45)


				if (81 to 100)
				//Salvage
				//The exosuit is wrecked. Spawns a wreckage object instead of a suit
					//Set the noexplode var so it doesn't explode, then just qdel it
					//The destroy proc handles wreckage generation
					exosuit.noexplode = 1
					qdel(exosuit)
					exosuit = null


		//Finally, so that the exosuit seems like it's been in storage for a while
		//We will take any malfunctions to their logical conclusion, and set the error states high
			if (exosuit)
				//If the tank has a breach, then there will be no air left
				if (exosuit.hasInternalDamage(MECHA_INT_TANK_BREACH) && exosuit.internal_tank)
					exosuit.internal_tank.air_contents.remove(exosuit.internal_tank.air_contents.total_moles)

				//If there's an electrical fault, the cell will be complerely drained
				if (exosuit.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT) && exosuit.cell)
					exosuit.cell.charge = 0


				exosuit.process_warnings()//Trigger them first, if they'll happen

				if (exosuit.power_alert_status)
					exosuit.last_power_warning = -99999999
					//Make it go into infrequent warning state instantly
					exosuit.power_warning_delay = 99999999
					//and set the delay between warnings to a functionally infinite value
					//so that it will shut up

				if (exosuit.damage_alert_status)
					exosuit.last_damage_warning = -99999999
					exosuit.damage_warning_delay = 99999999

				exosuit.process_warnings()
		else
			log_debug("ERROR: Random cargo spawn failed for [stock]")
