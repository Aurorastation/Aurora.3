
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

Actual definitions for possible items go in the files in `./random_stock`. Use the macros `STOCK_ITEM_COMMON(id,prob)`, `STOCK_ITEM_UNCOMMON(id,prob)`, `STOCK_ITEM_RARE(id,prob)`,
	and `STOCK_ITEM_LARGE(id,prob)` to declare your spawn, and put your spawn code under the define like you're defining a proc. IDs must be unique within a category (common, large, etc),
	but can be duplicated across categories. Available parameters are `atom/L` (loc the object should be spawned at), and for large objects, `datum/cargospawner/CS` (a ref to the parent cargospawner)

Example:

STOCK_ITEM_COMMON(bees, 2)
	if (prob(95))
		new /mob/living/bees(L)
	else
		new /mob/living/bees/evil(L)

*/

// This datum doesn't actually do anything beyond hold the setup_cargo_stock proc. Defining it as a global proc causes things to break.
/var/datum/cargo_master/cargo_master = new


// Called in misc_early to generate the cargo lists (as Atoms runs before Cargo).
/datum/cargo_master/proc/setup_cargo_stock()


// These lists are populated by the files in `./random_stock`.
var/list/global/random_stock_common = list()
var/list/global/random_stock_uncommon = list()
var/list/global/random_stock_rare = list()
var/list/global/random_stock_large = list()

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
		/mob/living/simple_animal/rat = 1,
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
			var/type = pickweight(random_stock_large)
			if (type)
				call(type)(get_turf(LSM))
		qdel(LSM)

	//Now we spawn the smaller items
	//These are spawned inside the cargo warehouse, in crates and on tables.
	for (var/i in 1 to TOTAL_STOCK)
		var/atom/spawnloc = get_location()
		var/spawntype = get_spawntype()
		if (spawntype)
			call(spawntype)(spawnloc, src)

	handle_infestation()
	shuffle_items()

/datum/cargospawner/proc/get_location()
	var/cratespawn = 0
	var/obj/structure/closet/crate/emptiest
	if (prob(70))//We'll usually put items in crates
		var/minweight = 1000000000 //We will distribute items somewhat evenly among crates
		//by selecting the least-filled one for each spawn

		for (var/obj/structure/closet/crate/C in containers)
			if (C.stored_weight() < minweight && C.stored_weight() < C.storage_capacity)
				minweight = C.stored_weight()
				emptiest = C
				cratespawn = 1

	if (cratespawn)
		return emptiest
	else if (length(tables))
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
