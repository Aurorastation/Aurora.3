/obj/item/disk/botany
	name = "flora data disk"
	desc = "A small disk used for carrying data on plant genetics."
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "disk"
	w_class = WEIGHT_CLASS_TINY

	/// The current gene data on the disk.
	var/list/genes = list()
	/// The player-facing name of the gene's source.
	var/genesource = "unknown"

/obj/item/disk/botany/New()
	..()
	pixel_x = rand(-5,5)
	pixel_y = rand(-5,5)

/obj/item/disk/botany/attack_self(var/mob/user as mob)
	if(genes.len)
		var/choice = alert(user, "Are you sure you want to wipe the disk?", "Xenobotany Data", "No", "Yes")
		if(src && user && genes && choice && choice == "Yes" && user.Adjacent(get_turf(src)))
			to_chat(user, "You wipe the disk data.")
			name = initial(name)
			desc = initial(name)
			genes = list()
			genesource = "unknown"

/obj/item/storage/box/botanydisk
	name = "flora disk box"
	desc = "A box of flora data disks, apparently."

/obj/item/storage/box/botanydisk/fill()
	..()
	for(var/i = 0;i<7;i++)
		new /obj/item/disk/botany(src)

/obj/machinery/botany
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "hydrotray3"
	density = TRUE
	anchored = TRUE

	/// Currently loaded seed packet.
	var/obj/item/seeds/seed
	/// Currently loaded data disk.
	var/obj/item/disk/botany/loaded_disk
	/// Is the machine current performing a task?
	var/active = FALSE
	/// Duration the task requires for completion.
	var/action_time = 5
	/// World time when the last action was queued.
	var/last_action = 0
	/// Whether the currently queued task should eject the current disk, if present.
	var/eject_disk = FALSE
	/// Whether the task has failed or not.
	var/failed_task = FALSE
	/// Helps determine whether or not a given operation requires a disk to be loaded with genes or to be empty.
	var/disk_needs_genes = FALSE

/// Gets run every process tick.
/obj/machinery/botany/process()
	..()
	if(!active) return

	if(world.time > last_action + action_time)
		finished_task()

/obj/machinery/botany/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/botany/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/botany/proc/finished_task()
	active = 0
	if(failed_task)
		failed_task = 0
		visible_message("[icon2html(src, viewers(get_turf(src)))] [src] pings unhappily, flashing a red warning light.")
	else
		visible_message("[icon2html(src, viewers(get_turf(src)))] [src] pings happily.")

	if(eject_disk)
		eject_disk = 0
		if(loaded_disk)
			loaded_disk.forceMove(get_turf(src))
			visible_message("[icon2html(src, viewers(get_turf(src)))] [src] beeps and spits out [loaded_disk].")
			loaded_disk = null

/obj/machinery/botany/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/seeds))
		if(seed)
			to_chat(user, "There is already a seed loaded.")
			return
		var/obj/item/seeds/S = attacking_item
		if(S.seed && S.GET_SEED_TRAIT(seed, TRAIT_IMMUTABLE) > 0)
			to_chat(user, "That seed is not compatible with our genetics technology.")
		else
			user.drop_from_inventory(attacking_item,src)
			seed = attacking_item
			to_chat(user, "You load [attacking_item] into [src].")
		return

	if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		panel_open = !panel_open
		to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance panel."))
		return

	if(panel_open)
		if(attacking_item.tool_behaviour == TOOL_CROWBAR)
			dismantle()
			return

	if(istype(attacking_item,/obj/item/disk/botany))
		if(loaded_disk)
			to_chat(user, "There is already a data disk loaded.")
			return
		else
			var/obj/item/disk/botany/B = attacking_item

			if(B.genes && B.genes.len)
				if(!disk_needs_genes)
					to_chat(user, "That disk already has gene data loaded.")
					return
			else
				if(disk_needs_genes)
					to_chat(user, "That disk does not have any gene data loaded.")
					return

			user.drop_from_inventory(attacking_item,src)
			loaded_disk = attacking_item
			to_chat(user, "You load [attacking_item] into [src].")

		return
	..()

/// UI data shared between both editor and extractor machinery.
/obj/machinery/botany/ui_data(mob/user)
	var/list/data = list()

	data["activity"] = active
	data["loadedSeed"] = seed ? "[seed.name]" : null
	data["disk"] = loaded_disk ? TRUE : FALSE

	return data

/// UI action behavior shared between both editor and extractor machinery.
/obj/machinery/botany/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("eject_packet")
			if(!seed)
				return FALSE

			seed.forceMove(get_turf(src))

			if(seed.seed.name == "new line" || isnull(SSplants.seeds[seed.seed.name]))
				seed.seed.uid = SSplants.seeds.len + 1
				seed.seed.name = "[seed.seed.uid]"
				SSplants.seeds[seed.seed.name] = seed.seed

			seed.update_seed()
			visible_message("[icon2html(src, viewers(get_turf(src)))] [src] beeps and spits out [seed].")
			seed = null

		if("eject_disk")
			if(!loaded_disk)
				return FALSE

			loaded_disk.forceMove(get_turf(src))
			visible_message("[icon2html(src, viewers(get_turf(src)))] [src] beeps and spits out [loaded_disk].")
			loaded_disk = null

		else
			return FALSE

	return TRUE

/// Allows for a trait to be extracted from a seed packet, destroying that seed.
/obj/machinery/botany/extractor
	name = "lysis-isolation centrifuge"
	icon_state = "centrifuge"
	component_types = list(
			/obj/item/circuitboard/botany_extractor,
			/obj/item/stock_parts/manipulator = 3,
			/obj/item/stock_parts/scanning_module = 1
		)
	/// Currently scanned seed genetic structure.
	var/datum/seed/genetics
	/// Increments with each scan, stops allowing gene mods after a certain point.
	var/degradation = 0

/obj/machinery/botany/extractor/ui_interact(mob/user, datum/tgui/ui)
	if(!user)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BotanyIsolator", "Lysis-Isolation Centrifuge")
		ui.open()

/obj/machinery/botany/extractor/ui_data(mob/user)
	var/list/data = ..()

	data["degradation"] = degradation
	data["geneMasks"] = SSplants.gene_masked_list

	if(genetics)
		data["hasGeneticsData"] = TRUE
		data["sourceName"] = genetics.display_name
		if(!genetics.roundstart)
			data["sourceName"] += " (variety #[genetics.uid])"

	data["loadedseed"] = seed ? "[seed.name]" : "Unknown"
	data["disk"] = loaded_disk ? TRUE : FALSE

	return data

/obj/machinery/botany/extractor/ui_act(action, params)
	switch(action)
		if("scan_genome")
			if(!seed)
				return FALSE

			last_action = world.time
			active = TRUE

			if(seed && seed.seed)
				genetics = seed.seed
				degradation = 0

			qdel(seed)
			seed = null

			return TRUE

		if("get_gene")
			if(!genetics || !loaded_disk)
				return TRUE

			var/gene_tag = params["gene"]
			if(!gene_tag)
				return TRUE

			last_action = world.time
			active = TRUE

			var/datum/plantgene/P = genetics.get_gene(gene_tag)
			if(!P)
				return TRUE

			loaded_disk.genes += P

			loaded_disk.genesource = "[genetics.display_name]"
			if(!genetics.roundstart)
				loaded_disk.genesource += " (variety #[genetics.uid])"

			loaded_disk.name += " ([SSplants.gene_tag_masks[gene_tag]], #[genetics.uid])"
			loaded_disk.desc += " The label reads 'gene [SSplants.gene_tag_masks[gene_tag]], sampled from [genetics.display_name]'."
			eject_disk = TRUE

			degradation += rand(20,60)
			if(degradation >= 100)
				failed_task = TRUE
				genetics = null
				degradation = 0
			return TRUE

		if("clear_buffer")
			if(!genetics)
				return
			genetics = null
			degradation = 0
			return TRUE

	return ..()

/// Injects an extracted trait into another packet of seeds with a chance of destroying it based on the size/complexity of the plasmid.
/obj/machinery/botany/editor
	name = "bioballistic delivery system"
	icon_state = "traitgun"
	disk_needs_genes = TRUE
	component_types = list(
			/obj/item/circuitboard/botany_editor,
			/obj/item/stock_parts/manipulator = 3,
			/obj/item/stock_parts/scanning_module = 1
		)

/obj/machinery/botany/editor/ui_interact(mob/user, datum/tgui/ui)
	if(!user)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BotanyEditor", "Bioballistic Delivery System")
		ui.open()

/obj/machinery/botany/editor/ui_data(mob/user)
	var/list/data = ..()

	data["degradation"] = seed ? seed.modified : 0
	data["disk"] = !!loaded_disk

	if(loaded_disk && loaded_disk.genes.len)
		data["sourceName"] = loaded_disk.genesource
		data["locus"] = ""

		for(var/datum/plantgene/P in loaded_disk.genes)
			if(data["locus"] != "")
				data["locus"] += ", "
			data["locus"] += "[SSplants.gene_tag_masks[P.genetype]]"

	data["loadedseed"] = seed ? "[seed.name]" : null

	return data

/obj/machinery/botany/editor/ui_act(action, params)
	if(action == "apply_gene")
		if(!loaded_disk || !seed)
			return TRUE

		last_action = world.time
		active = TRUE

		if(!isnull(SSplants.seeds[seed.seed.name]))
			seed.seed = seed.seed.diverge(1)
			seed.seed_type = seed.seed.name
			seed.update_seed()

		if(prob(seed.modified))
			failed_task = TRUE
			seed.modified = 101

		for(var/datum/plantgene/gene in loaded_disk.genes)
			seed.seed.apply_gene(gene)
			seed.modified += rand(5,10)

		return TRUE

	return ..()

/obj/item/circuitboard/botany_extractor
	name = T_BOARD("lysis-isolation centrifuge")
	build_path = /obj/machinery/botany/extractor
	origin_tech = list(TECH_DATA = 3)


/obj/item/circuitboard/botany_editor
	name = T_BOARD("bioballistic delivery system")
	build_path = /obj/machinery/botany/editor
	origin_tech = list(TECH_DATA = 3)
