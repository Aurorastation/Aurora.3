/datum/seed_pile
	var/name
	var/amount
	var/datum/seed/seed_type // Keeps track of what our seed is
	var/list/obj/item/seeds/seeds = list() // Tracks actual objects contained in the pile
	var/ID

/datum/seed_pile/New(var/obj/item/seeds/O, var/ID)
	name = O.name
	amount = 1
	seed_type = O.seed
	seeds += O
	src.ID = ID

/datum/seed_pile/proc/matches(var/obj/item/seeds/O)
	if (O.seed == seed_type)
		return TRUE
	return FALSE

/obj/machinery/seed_storage
	name = "seed storage"
	desc = "It stores, sorts, and dispenses seeds."
	icon = 'icons/obj/vending.dmi'
	icon_state = SEED_NOUN_SEEDS
	density = 1
	anchored = 1
	idle_power_usage = 100

	var/screen_x = 700
	var/screen_y = 700

	var/list/datum/seed_pile/piles = list()
	var/list/starting_seeds = list()
	var/list/scanner = list() // What properties we can view

/obj/machinery/seed_storage/random // This is mostly for testing, but I guess admins could spawn it
	name = "random seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light")
	starting_seeds = list(/obj/item/seeds/random = 50)

/obj/machinery/seed_storage/garden
	name = "garden seed storage"
	scanner = list("stats")
	starting_seeds = list(
		/obj/item/seeds/aghrasshseed = 3,
		/obj/item/seeds/ambrosiavulgarisseed = 3,
		/obj/item/seeds/appleseed = 3,
		/obj/item/seeds/bananaseed = 3,
		/obj/item/seeds/barnacle = 15,
		/obj/item/seeds/berryseed = 3,
		/obj/item/seeds/blackraspberryseed = 3,
		/obj/item/seeds/blizzard = 3,
		/obj/item/seeds/blueberryseed = 3,
		/obj/item/seeds/blueraspberryseed = 3,
		/obj/item/seeds/cabbageseed = 3,
		/obj/item/seeds/carrotseed = 3,
		/obj/item/seeds/chantermycelium = 3,
		/obj/item/seeds/cherryseed = 3,
		/obj/item/seeds/chiliseed = 3,
		/obj/item/seeds/chickpeas = 3,
		/obj/item/seeds/clam = 15,
		/obj/item/seeds/cocoapodseed = 3,
		/obj/item/seeds/coffeeseed = 3,
		/obj/item/seeds/cornseed = 3,
		/obj/item/seeds/dynseed = 3,
		/obj/item/seeds/earthenroot = 2,
		/obj/item/seeds/eggplantseed = 3,
		/obj/item/seeds/eki = 3,
		/obj/item/seeds/fjylozyn = 1,
		/obj/item/seeds/garlicseed = 3,
		/obj/item/seeds/grapeseed = 3,
		/obj/item/seeds/grassseed = 3,
		/obj/item/seeds/guamiseed = 2,
		/obj/item/seeds/gukheseed = 3,
		/obj/item/seeds/jaekseol = 3,
		/obj/item/seeds/lemonseed = 3,
		/obj/item/seeds/limeseed = 3,
		/obj/item/seeds/mossseed = 2,
		/obj/item/seeds/mtearseed = 2,
		/obj/item/seeds/mintseed = 3,
		/obj/item/seeds/mollusc = 15,
		/obj/item/seeds/nifberries = 2,
		/obj/item/seeds/onionseed = 3,
		/obj/item/seeds/oracleseed = 3,
		/obj/item/seeds/orangeseed = 3,
		/obj/item/seeds/peanutseed = 3,
		/obj/item/seeds/peppercornseed = 3,
		/obj/item/seeds/plastiseed = 3,
		/obj/item/seeds/plumpmycelium = 3,
		/obj/item/seeds/poppyseed = 3,
		/obj/item/seeds/potatoseed = 3,
		/obj/item/seeds/pumpkinseed = 3,
		/obj/item/seeds/qlortseed = 2,
		/obj/item/seeds/raspberryseed = 3,
		/obj/item/seeds/clam/rasval = 15,
		/obj/item/seeds/reishimycelium = 2,
		/obj/item/seeds/replicapod = 3,
		/obj/item/seeds/riceseed = 3,
		/obj/item/seeds/richcoffeeseed = 3,
		/obj/item/seeds/sarezhiseed = 3,
		/obj/item/seeds/seaweed = 3,
		/obj/item/seeds/ = 3,
		/obj/item/seeds/serkiflowerseed = 1,
		/obj/item/seeds/shandseed = 2,
		/obj/item/seeds/soyaseed = 3,
		/obj/item/seeds/sthberryseed = 3,
		/obj/item/seeds/strawberryseed = 3,
		/obj/item/seeds/sugarcaneseed = 3,
		/obj/item/seeds/sugartree = 2,
		/obj/item/seeds/sunflowerseed = 3,
		/obj/item/seeds/teaseed = 3,
		/obj/item/seeds/tieguanyin = 3,
		/obj/item/seeds/tobaccoseed = 3,
		/obj/item/seeds/tomatoseed = 3,
		/obj/item/seeds/towermycelium = 3,
		/obj/item/seeds/vanilla = 3,
		/obj/item/seeds/watermelonseed = 3,
		/obj/item/seeds/wheatseed = 3,
		/obj/item/seeds/whitebeetseed = 3,
		/obj/item/seeds/wulumunushaseed = 2,
		/obj/item/seeds/xuiziseed = 3,
		/obj/item/seeds/ylpha = 2
	)

/obj/machinery/seed_storage/xenobotany
	name = "Xenobotany seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light")
	starting_seeds = list(
		/obj/item/seeds/aghrasshseed = 3,
		/obj/item/seeds/ambrosiavulgarisseed = 3,
		/obj/item/seeds/appleseed = 3,
		/obj/item/seeds/amanitamycelium = 2,
		/obj/item/seeds/bananaseed = 3,
		/obj/item/seeds/berryseed = 3,
		/obj/item/seeds/blackraspberryseed = 3,
		/obj/item/seeds/blizzard = 3,
		/obj/item/seeds/blueberryseed = 3,
		/obj/item/seeds/blueraspberryseed = 3,
		/obj/item/seeds/cabbageseed = 3,
		/obj/item/seeds/carrotseed = 3,
		/obj/item/seeds/chantermycelium = 3,
		/obj/item/seeds/cherryseed = 3,
		/obj/item/seeds/chiliseed = 3,
		/obj/item/seeds/chickpeas = 3,
		/obj/item/seeds/cocaseed = 3,
		/obj/item/seeds/cocoapodseed = 3,
		/obj/item/seeds/coffeeseed = 3,
		/obj/item/seeds/cornseed = 3,
		/obj/item/seeds/dynseed = 3,
		/obj/item/seeds/replicapod = 3,
		/obj/item/seeds/earthenroot = 2,
		/obj/item/seeds/eggplantseed = 3,
		/obj/item/seeds/eki = 3,
		/obj/item/seeds/fjylozyn = 3,
		/obj/item/seeds/garlicseed = 3,
		/obj/item/seeds/glowshroom = 2,
		/obj/item/seeds/grapeseed = 3,
		/obj/item/seeds/grassseed = 3,
		/obj/item/seeds/guamiseed = 2,
		/obj/item/seeds/gukheseed = 3,
		/obj/item/seeds/koisspore = 3,
		/obj/item/seeds/lemonseed = 3,
		/obj/item/seeds/libertymycelium = 2,
		/obj/item/seeds/limeseed = 3,
		/obj/item/seeds/mossseed = 2,
		/obj/item/seeds/mtearseed = 2,
		/obj/item/seeds/mintseed = 3,
		/obj/item/seeds/nettleseed = 2,
		/obj/item/seeds/nifberries = 2,
		/obj/item/seeds/onionseed = 3,
		/obj/item/seeds/oracleseed = 3,
		/obj/item/seeds/orangeseed = 3,
		/obj/item/seeds/peanutseed = 3,
		/obj/item/seeds/peppercornseed = 3,
		/obj/item/seeds/plastiseed = 3,
		/obj/item/seeds/plumpmycelium = 3,
		/obj/item/seeds/poppyseed = 3,
		/obj/item/seeds/potatoseed = 3,
		/obj/item/seeds/pumpkinseed = 3,
		/obj/item/seeds/qlortseed = 2,
		/obj/item/seeds/raspberryseed = 3,
		/obj/item/seeds/reishimycelium = 2,
		/obj/item/seeds/riceseed = 3,
		/obj/item/seeds/richcoffeeseed = 3,
		/obj/item/seeds/sarezhiseed = 3,
		/obj/item/seeds/seaweed = 3,
		/obj/item/seeds/serkiflowerseed,
		/obj/item/seeds/soyaseed = 3,
		/obj/item/seeds/sthberryseed = 3,
		/obj/item/seeds/strawberryseed = 3,
		/obj/item/seeds/sugarcaneseed = 3,
		/obj/item/seeds/sunflowerseed = 3,
		/obj/item/seeds/sugartree = 2,
		/obj/item/seeds/shandseed = 2,
		/obj/item/seeds/teaseed = 3,
		/obj/item/seeds/tobaccoseed = 3,
		/obj/item/seeds/tomatoseed = 3,
		/obj/item/seeds/towermycelium = 3,
		/obj/item/seeds/vanilla = 3,
		/obj/item/seeds/watermelonseed = 3,
		/obj/item/seeds/wheatseed = 3,
		/obj/item/seeds/whitebeetseed = 3,
		/obj/item/seeds/wulumunushaseed = 3,
		/obj/item/seeds/xuiziseed = 3,
		/obj/item/seeds/ylpha = 2
	)
	screen_x = 1000
	screen_y = 700

/obj/machinery/seed_storage/Initialize()
	. = ..()
	for(var/typepath in starting_seeds)
		var/amount = starting_seeds[typepath]
		if(isnull(amount)) amount = 1

		for (var/i = 1 to amount)
			var/O = new typepath
			add(O)

/obj/machinery/seed_storage/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/seed_storage/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SeedStorage", "Seed Storage", screen_x, screen_y)
		ui.open()

/obj/machinery/seed_storage/ui_data(mob/user)
	var/list/data = list()
	data["seeds"] = list()
	for(var/datum/seed_pile/S in piles)
		var/datum/seed/seed = S.seed_type
		if(!seed)
			continue
		var/list/seed_type = list("name" = seed.seed_name, "uid" = seed.uid, "pile_id" = S.ID)
		var/list/traits = list()

		if("stats" in scanner)
			data["scan_stats"] = TRUE
			seed_type["endurance"] = seed.get_trait(TRAIT_ENDURANCE)
			seed_type["yield"] = seed.get_trait(TRAIT_YIELD)
			seed_type["maturation"] = seed.get_trait(TRAIT_MATURATION)
			seed_type["production"] = seed.get_trait(TRAIT_PRODUCTION)
			seed_type["potency"] = seed.get_trait(TRAIT_POTENCY)
			if(seed.get_trait(TRAIT_HARVEST_REPEAT))
				seed_type["harvest"] = "multiple"
			else
				seed_type["harvest"] = "single"

		if("temperature" in scanner)
			data["scan_temperature"] = TRUE
			seed_type["ideal_heat"] = "[seed.get_trait(TRAIT_IDEAL_HEAT)] K"

		if("light" in scanner)
			data["scan_light"] = TRUE
			seed_type["ideal_light"] = "[seed.get_trait(TRAIT_IDEAL_LIGHT)] L"

		if("soil" in scanner)
			data["scan_soil"] = TRUE
			if(seed.get_trait(TRAIT_REQUIRES_NUTRIENTS))
				if(seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) < 0.05)
					seed_type["nutrient_consumption"] = "Low"
				else if(seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) > 0.2)
					seed_type["nutrient_consumption"] = "High"
				else
					seed_type["nutrient_consumption"] = "Average"
			else
				seed_type["nutrient_consumption"] = "No"

			if(seed.get_trait(TRAIT_REQUIRES_WATER))
				if(seed.get_trait(TRAIT_WATER_CONSUMPTION) < 1)
					seed_type["water_consumption"] = "Low"
				else if(seed.get_trait(TRAIT_WATER_CONSUMPTION) > 5)
					seed_type["water_consumption"] = "High"
				else
					seed_type["water_consumption"] =  "Average"
			else
				seed_type["water_consumption"] = "No"

		switch(seed.get_trait(TRAIT_CARNIVOROUS))
			if(1)
				traits += "CARN"
			if(2)
				traits	+= "CARN (!)"

		switch(seed.get_trait(TRAIT_SPREAD))
			if(1)
				traits += "VINE"
			if(2)
				traits	+= "VINE (!)"

		if ("pressure" in scanner)
			if(seed.get_trait(TRAIT_LOWKPA_TOLERANCE) < 20)
				traits += "LP"
			if(seed.get_trait(TRAIT_HIGHKPA_TOLERANCE) > 220)
				traits += "HP"

		if ("temperature" in scanner)
			if(seed.get_trait(TRAIT_HEAT_TOLERANCE) > 30)
				traits += "TEMRES"
			else if(seed.get_trait(TRAIT_HEAT_TOLERANCE) < 10)
				traits += "TEMSEN"

		if ("light" in scanner)
			if(seed.get_trait(TRAIT_LIGHT_TOLERANCE) > 10)
				traits += "LIGRES"
			else if(seed.get_trait(TRAIT_LIGHT_TOLERANCE) < 3)
				traits += "LIGSEN"

		if(seed.get_trait(TRAIT_TOXINS_TOLERANCE) < 3)
			traits += "TOXSEN"
		else if(seed.get_trait(TRAIT_TOXINS_TOLERANCE) > 6)
			traits += "TOXRES"

		if(seed.get_trait(TRAIT_PEST_TOLERANCE) < 3)
			traits += "PESTSEN"
		else if(seed.get_trait(TRAIT_PEST_TOLERANCE) > 6)
			traits += "PESTRES"

		if(seed.get_trait(TRAIT_WEED_TOLERANCE) < 3)
			traits += "WEEDSEN"
		else if(seed.get_trait(TRAIT_WEED_TOLERANCE) > 6)
			traits += "WEEDRES"

		if(seed.get_trait(TRAIT_PARASITE))
			traits += "PAR"

		if("temperature" in scanner)
			if(seed.get_trait(TRAIT_ALTER_TEMP) > 0)
				traits += "TEMP+"
			if(seed.get_trait(TRAIT_ALTER_TEMP) < 0)
				traits += "TEMP-"

		if(seed.get_trait(TRAIT_BIOLUM))
			traits += "LUM"

		seed_type["amount"] = S.amount
		seed_type["traits"] = english_list(traits)
		data["seeds"] += list(seed_type)
	return data

/obj/machinery/seed_storage/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return
	switch(action)
		if("vend")
			for(var/datum/seed_pile/N in piles)
				if (N.ID == params["id"])
					var/obj/O = pick(N.seeds)
					if(O)
						--N.amount
						N.seeds -= O
						if (N.amount <= 0 || N.seeds.len <= 0)
							piles -= N
							qdel(N)
						O.forceMove(src.loc)
					else
						piles -= N
						qdel(N)
			. = TRUE
		if ("purge")
			for(var/datum/seed_pile/N in piles)
				for(var/obj/O in N.seeds)
					qdel(O)
					piles -= N
					qdel(N)
			. = TRUE

/obj/machinery/seed_storage/attackby(var/obj/item/O, var/mob/user)
	if (istype(O, /obj/item/seeds))
		add(O)
		user.visible_message(SPAN_NOTICE("[user] puts \the [O.name] into \the [src]."), SPAN_NOTICE("You put \the [O] into \the [src]."))
		return
	else if (istype(O, /obj/item/storage/bag/plants))
		var/obj/item/storage/P = O
		var/loaded = 0
		for(var/obj/item/seeds/G in P.contents)
			++loaded
			add(G)
		if (loaded)
			user.visible_message(SPAN_NOTICE("[user] puts the seeds from \the [O.name] into \the [src]."), SPAN_NOTICE("You put the seeds from \the [O.name] into \the [src]."))
		else
			to_chat(user, SPAN_WARNING("There are no seeds in \the [O.name]."))
		return
	else if(O.iswrench())
		playsound(loc, O.usesound, 50, 1)
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src]."))

/obj/machinery/seed_storage/proc/add(var/obj/item/seeds/O)
	if (istype(O.loc, /mob))
		var/mob/user = O.loc
		user.remove_from_mob(O)
	else if(istype(O.loc,/obj/item/storage))
		var/obj/item/storage/S = O.loc
		S.remove_from_storage(O, src)

	O.forceMove(src)
	var/newID = 0

	for (var/datum/seed_pile/N in piles)
		if (N.matches(O))
			++N.amount
			N.seeds += (O)
			return
		else if(N.ID >= newID)
			newID = N.ID + 1

	piles += new /datum/seed_pile(O, newID)
