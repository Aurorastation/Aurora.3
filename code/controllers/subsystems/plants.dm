/var/datum/controller/subsystem/plants/SSplants

/datum/controller/subsystem/plants
	name = "Seeds & Plants"
	flags = 0	// Override parent's flags.
	wait = 75
	init_order = SS_INIT_SEEDS
	priority = SS_PRIORITY_PLANTS

	var/list/product_descs = list()         // Stores generated fruit descs.
	var/list/seeds = list()                 // All seed data stored here.
	var/list/gene_tag_masks = list()        // Gene obfuscation for delicious trial and error goodness.
	var/list/plant_icon_cache = list()      // Stores images of growth, fruits and seeds.
	var/list/plant_sprites = list()         // List of all harvested product sprites.
	var/list/plant_product_sprites = list() // List of all growth sprites plus number of growth stages.

	var/list/processing = list()
	var/list/current = list()

/datum/controller/subsystem/plants/New()
	NEW_SS_GLOBAL(SSplants)

/datum/controller/subsystem/plants/stat_entry()
	..("P:[processing.len]")

/datum/controller/subsystem/plants/Initialize(timeofday)
	// Build the icon lists.
	for(var/icostate in icon_states('icons/obj/hydroponics_growing.dmi'))
		var/split = findtext(icostate,"-")
		if(!split)
			// invalid icon_state
			continue

		var/ikey = copytext(icostate,(split+1))
		if(ikey == "dead")
			// don't count dead icons
			continue
		ikey = text2num(ikey)
		var/base = copytext(icostate,1,split)

		if(!(plant_sprites[base]) || (plant_sprites[base]<ikey))
			plant_sprites[base] = ikey

	for(var/icostate in icon_states('icons/obj/hydroponics_products.dmi'))
		var/split = findtext(icostate,"-")
		if(split)
			plant_product_sprites |= copytext(icostate,1,split)

	// Populate the global seed datum list.
	for(var/type in typesof(/datum/seed)-/datum/seed)
		var/datum/seed/S = new type
		seeds[S.name] = S
		S.uid = "[seeds.len]"
		S.roundstart = 1

	//Might as well mask the gene types while we're at it.
	var/list/used_masks = list()
	var/list/plant_traits = ALL_GENES
	while(plant_traits && plant_traits.len)
		var/gene_tag = pick(plant_traits)
		var/gene_mask = "[uppertext(num2hex(rand(0,255)))]"

		while(gene_mask in used_masks)
			gene_mask = "[uppertext(num2hex(rand(0,255)))]"

		used_masks += gene_mask
		plant_traits -= gene_tag
		gene_tag_masks[gene_tag] = gene_mask
	
	..()

/datum/controller/subsystem/plants/Recover()
	if (istype(SSplants))
		src.product_descs = SSplants.product_descs
		src.seeds = SSplants.seeds
		src.gene_tag_masks = SSplants.gene_tag_masks
		src.plant_icon_cache = SSplants.plant_icon_cache
		src.plant_sprites = SSplants.plant_sprites
		src.plant_product_sprites = SSplants.plant_product_sprites

/datum/controller/subsystem/plants/fire(resumed = 0)
	if (!resumed)
		var/list/old = current	// This should be empty, so might as well just reuse it.
		current = processing
		processing = old

	var/list/queue = current
	while (queue.len)
		var/obj/effect/plant/P = queue[queue.len]
		queue.len--

		if (!QDELETED(P))
			P.process()

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/plants/proc/add_plant(obj/effect/plant/plant)
	processing[plant] = TRUE

/datum/controller/subsystem/plants/proc/remove_plant(obj/effect/plant/plant)
	processing -= plant

// Proc for creating a random seed type.
/datum/controller/subsystem/plants/proc/create_random_seed(var/survive_on_station)
	var/datum/seed/seed = new()
	seed.randomize()
	seed.uid = seeds.len + 1
	seed.name = "[seed.uid]"
	seeds[seed.name] = seed

	if(survive_on_station)
		if(seed.consume_gasses)
			seed.consume_gasses["phoron"] = null
			seed.consume_gasses["carbon_dioxide"] = null
		if(seed.chems && !isnull(seed.chems["pacid"]))
			seed.chems["pacid"] = null // Eating through the hull will make these plants completely inviable, albeit very dangerous.
			seed.chems -= null // Setting to null does not actually remove the entry, which is weird.
		seed.set_trait(TRAIT_IDEAL_HEAT,293)
		seed.set_trait(TRAIT_HEAT_TOLERANCE,20)
		seed.set_trait(TRAIT_IDEAL_LIGHT,8)
		seed.set_trait(TRAIT_LIGHT_TOLERANCE,5)
		seed.set_trait(TRAIT_LOWKPA_TOLERANCE,25)
		seed.set_trait(TRAIT_HIGHKPA_TOLERANCE,200)
	return seed

// Debug for testing seed genes.
/client/proc/show_plant_genes()
	set category = "Debug"
	set name = "Show Plant Genes"
	set desc = "Prints the round's plant gene masks."

	if(!holder)	return

	if(!SSplants || !SSplants.gene_tag_masks)
		usr << "Gene masks not set."
		return

	for(var/mask in SSplants.gene_tag_masks)
		usr << "[mask]: [SSplants.gene_tag_masks[mask]]"
