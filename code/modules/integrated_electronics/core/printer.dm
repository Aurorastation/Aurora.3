#define MAX_CIRCUIT_CLONE_TIME 3 MINUTES //circuit slow-clones can only take up this amount of time to complete

/obj/item/device/integrated_circuit_printer
	name = "integrated circuit printer"
	desc = "A portable(ish) machine made to print tiny modular circuitry out of metal."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "circuit_printer"
	w_class = ITEMSIZE_LARGE
	var/upgraded = FALSE		// When hit with an upgrade disk, will turn true, allowing it to print the higher tier circuits.
	var/can_clone = TRUE		// Allows the printer to clone circuits, either instantly or over time depending on upgrade. Set to FALSE to disable entirely.
	var/fast_clone = FALSE		// If this is false, then cloning will take an amount of deciseconds equal to the metal cost divided by 100.
	var/debug = FALSE			// If it's upgraded and can clone, even without config settings.
	var/current_category = null
	var/cloning = FALSE			// If the printer is currently creating a circuit
	var/recycling = FALSE		// If an assembly is being emptied into this printer
	var/list/program			// Currently loaded save, in form of list
	var/materials = list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0)
	var/material_max = 25 * SHEET_MATERIAL_AMOUNT

/obj/item/device/integrated_circuit_printer/proc/check_interactivity(mob/user)
	return CanUseTopic(user)

/obj/item/device/integrated_circuit_printer/upgraded
	upgraded = TRUE
	can_clone = TRUE
	fast_clone = TRUE

/obj/item/device/integrated_circuit_printer/debug //translation: "integrated_circuit_printer/local_server"
	name = "debug circuit printer"
	debug = TRUE
	upgraded = TRUE
	can_clone = TRUE
	fast_clone = TRUE
	w_class = ITEMSIZE_TINY

/obj/item/device/integrated_circuit_printer/proc/try_update_ui(mob/user)
	if(user)
		var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
		if(ui)
			ui.check_for_change()

/obj/item/device/integrated_circuit_printer/proc/print_program(mob/user)
	if(!cloning)
		return

	visible_message("<span class='notice'>[src] has finished printing its assembly!</span>")
	playsound(src, 'sound/items/poster_being_created.ogg', 50, TRUE)
	var/obj/item/device/electronic_assembly/assembly = SSelectronics.load_electronic_assembly(get_turf(src), program)
	if(assembly)
		assembly.creator = key_name(user)
	cloning = FALSE

/obj/item/device/integrated_circuit_printer/proc/recycle(obj/item/O, mob/user, obj/item/device/electronic_assembly/assembly)
	if(!O.canremove) //in case we have an augment circuit
		return
	for(var/material in O.matter)
		if(materials[material] + O.matter[material] > material_max)
			var/material/material_datum = SSmaterials.get_material_by_name(material)
			if(material_datum)
				to_chat(user, "<span class='notice'>[src] can't hold any more [material_datum.display_name]!</span>")
			return
	for(var/material in O.matter)
		materials[material] += O.matter[material]
	if(assembly)
		assembly.remove_component(O)
	if(user)
		to_chat(user, "<span class='notice'>You recycle [O]!</span>")
	qdel(O)
	return TRUE

/obj/item/device/integrated_circuit_printer/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/stack/material))
		var/obj/item/stack/material/M = O
		var/amt = M.amount
		if(amt * SHEET_MATERIAL_AMOUNT + materials[M.material.name] > material_max)
			amt = -round(-(material_max - materials[M.material.name]) / SHEET_MATERIAL_AMOUNT) //round up
		if(M.use(amt))
			materials[M.material.name] = min(material_max, materials[M.material.name] + amt * SHEET_MATERIAL_AMOUNT)
			to_chat(user, "<span class='warning'>You insert [M.material.display_name] into \the [src].</span>")
			try_update_ui(user)
	if(istype(O, /obj/item/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, "<span class='warning'>[src] already has this upgrade. </span>")
			return TRUE
		to_chat(user, "<span class='notice'>You install [O] into [src]. </span>")
		upgraded = TRUE
		try_update_ui(user)
		return TRUE

	if(istype(O, /obj/item/disk/integrated_circuit/upgrade/clone))
		if(fast_clone)
			to_chat(user, "<span class='warning'>[src] already has this upgrade. </span>")
			return TRUE
		to_chat(user, "<span class='notice'>You install [O] into [src]. Circuit cloning will now be instant. </span>")
		fast_clone = TRUE
		try_update_ui(user)
		return TRUE

	if(istype(O, /obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/EA = O //microtransactions not included
		if(EA.battery)
			to_chat(user, "<span class='warning'>Remove [EA]'s power cell first!</span>")
			return
		if(EA.assembly_components.len)
			if(recycling)
				return
			if(!EA.opened)
				to_chat(user, "<span class='warning'>You can't reach [EA]'s components to remove them!</span>")
				return
			for(var/V in EA.assembly_components)
				var/obj/item/integrated_circuit/IC = V
				if(!IC.removable)
					to_chat(user, "<span class='warning'>[EA] has irremovable components in the casing, preventing you from emptying it.</span>")
					return
			to_chat(user, "<span class='notice'>You begin recycling [EA]'s components...</span>")
			playsound(src, 'sound/items/electronic_assembly_emptying.ogg', 50, TRUE)
			if(!do_after(user, 30, act_target = src) || recycling) //short channel so you don't accidentally start emptying out a complex assembly
				return
			recycling = TRUE
			for(var/V in EA.assembly_components)
				recycle(V, null, EA)
			to_chat(user, "<span class='notice'>You recycle all the components[EA.assembly_components.len ? " you could " : " "]from [EA]!</span>")
			playsound(src, 'sound/items/electronic_assembly_empty.ogg', 50, TRUE)
			recycling = FALSE
			return TRUE
		else
			return recycle(EA, user)

	if(istype(O, /obj/item/integrated_circuit))
		return recycle(O, user)

	return ..()

/obj/item/device/integrated_circuit_printer/attack_self(mob/user)
	interact(user)

/obj/item/device/integrated_circuit_printer/interact(mob/user)
	if(!(in_range(src, user) || issilicon(user)))
		return

	if(isnull(current_category))
		current_category = SSelectronics.printer_recipe_list[1]

	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "circuits-printer", 800, 630, "Integrated Circuit Printer")

	ui.open()

/obj/item/device/integrated_circuit_printer/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list()

	LAZYINITLIST(data["materials"])

	for(var/material in materials)
		var/material/material_datum = SSmaterials.get_material_by_name(material)
		VUEUI_SET_CHECK(data["materials"][material_datum.display_name], "[materials[material]]/[material_max]", ., data)

	if(current_category != data["current_category"])
		// Clear the list since we might need a new one
		data["category_recipes"] = list()
		// current_category is set in interact(). Shouldn't cause a problem here?
		for(var/path in SSelectronics.printer_recipe_list[current_category])
			var/obj/O = path
			var/can_build = TRUE
			if(ispath(path, /obj/item/integrated_circuit))
				var/obj/item/integrated_circuit/IC = path
				if((initial(IC.spawn_flags) & IC_SPAWN_RESEARCH) && (!(initial(IC.spawn_flags) & IC_SPAWN_DEFAULT)) && !upgraded)
					can_build = FALSE

			VUEUI_SET_CHECK(data["category_recipes"][initial(O.name)], list(initial(O.desc), can_build, "\ref[path]"), ., data)


	LAZYINITLIST(data["categories"])
	if(LAZYLEN(data["categories"]) == 0)
		for(var/category in SSelectronics.printer_recipe_list)
			data["categories"].Add(category)

	// Using VueUI monitor here breaks /advanced and /debug printers, which is kinda bad?
	VUEUI_SET_CHECK_IFNOTSET(data["debug"], debug, ., data)
	VUEUI_SET_CHECK(data["can_clone"], can_clone, ., data)
	VUEUI_SET_CHECK(data["fast_clone"], fast_clone, ., data)
	VUEUI_SET_CHECK(data["upgraded"], upgraded, ., data)
	VUEUI_SET_CHECK(data["cloning"], cloning, ., data)
	VUEUI_SET_CHECK(data["current_category"], current_category, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["recipes"], SSelectronics.printer_recipe_list, ., data)
	// Program can be null, which kinda breaks VUEUI_SET_CHECK, since data["program"] is null at first too
	if(isnull(data["program"]) || program != data["program"])
		data["program"] = program

/obj/item/device/integrated_circuit_printer/Topic(href, href_list, state = interactive_state)
	if(!check_interactivity(usr))
		return
	if(..())
		return TRUE
	add_fingerprint(usr)

	var/datum/vueui/ui = href_list["vueui"]

	if(href_list["category"])
		current_category = href_list["category"]

	if(href_list["build"])
		var/build_type = locate(href_list["build"])
		if(!build_type || !ispath(build_type))
			return TRUE

		var/list/cost = list()
		var/is_asm = FALSE
		if(ispath(build_type, /obj/item/device/electronic_assembly))
			var/obj/item/device/electronic_assembly/E = SSelectronics.cached_assemblies[build_type]
			cost = E.matter
			is_asm = TRUE
		else if(ispath(build_type, /obj/item/clothing/) || ispath(build_type, /obj/item/implant/integrated_circuit))
			// TODO: add matter calculations
			//is_asm = TRUE
		else if(ispath(build_type, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = SSelectronics.cached_circuits[build_type]
			cost = IC.matter

		if(!debug && !subtract_material_costs(cost, usr))
			return

		var/obj/item/built

		// TODO: Deal with batteries in clothing assemblies
		if(is_asm)
			built = new build_type(get_turf(src), TRUE)
		else
			built = new build_type(get_turf(src))

		usr.put_in_hands(built)

		if(istype(built, /obj/item/device/electronic_assembly))
			var/obj/item/device/electronic_assembly/E = built
			E.creator = key_name(usr)
			E.opened = TRUE
			E.update_icon()
		to_chat(usr, "<span class='notice'>[capitalize(built.name)] printed.</span>")
		// Not sure if this sound is a decent replacement. The original is a much more mechanical noise
		// Don't see much point in copying the sound, since this one works anyway
		// items/poster_being_created.ogg is a good alternative, but it might be too long 
		playsound(src, 'sound/bureaucracy/print.ogg', 50, TRUE)

	if(href_list["print"])
		//if(!config.allow_ic_printing && !debug)
		//	to_chat(usr, "<span class='warning'>Your facility has disabled printing of custom circuitry due to recent allegations of copyright infringement.</span>")
		//	return
		if(!can_clone) // Copying and printing ICs is cloning
			to_chat(usr, "<span class='warning'>This printer does not have the cloning upgrade.</span>")
			return
		switch(href_list["print"])
			if("load")
				if(cloning)
					return
				var/input = input(usr, "Put your code there:", "loading", null) as message
				if(cloning)
					return
				if(!input)
					program = null
					return

				var/validation = SSelectronics.validate_electronic_assembly(input)

				// Validation error codes are returned as text.
				if(istext(validation))
					to_chat(usr, "<span class='warning'>Error: [validation]</span>")
					return
				else if(islist(validation))
					program = validation
					to_chat(usr, "<span class='notice'>This is a valid program for [program["assembly"]["type"]].</span>")
					if(program["requires_upgrades"])
						if(upgraded)
							to_chat(usr, "<span class='notice'>It uses advanced component designs.</span>")
						else
							to_chat(usr, "<span class='warning'>It uses unknown component designs. Printer upgrade is required to proceed.</span>")
					if(program["unsupported_circuit"])
						to_chat(usr, "<span class='warning'>This program uses components not supported by the specified assembly. Please change the assembly type in the save file to a supported one.</span>")
					to_chat(usr, "<span class='notice'>Used space: [program["used_space"]]/[program["max_space"]].</span>")
					to_chat(usr, "<span class='notice'>Complexity: [program["complexity"]]/[program["max_complexity"]].</span>")
					to_chat(usr, "<span class='notice'>Cost: [json_encode(program["cost"])].</span>")

			if("print")
				if(!program || cloning)
					return

				if(program["requires_upgrades"] && !upgraded && !debug)
					to_chat(usr, "<span class='warning'>This program uses unknown component designs. Printer upgrade is required to proceed.</span>")
					return
				if(program["unsupported_circuit"] && !debug)
					to_chat(usr, "<span class='warning'>This program uses components not supported by the specified assembly. Please change the assembly type in the save file to a supported one.</span>")
					return
				else if(fast_clone)
					var/list/cost = program["cost"]
					if(debug || subtract_material_costs(cost, usr))
						cloning = TRUE
						print_program(usr)
				else
					var/list/cost = program["cost"]
					if(!subtract_material_costs(cost, usr))
						return
					var/cloning_time = 0
					for(var/material in cost)
						cloning_time += cost[material]
					cloning_time = round(cloning_time/15)
					cloning_time = min(cloning_time, MAX_CIRCUIT_CLONE_TIME)
					cloning = TRUE
					to_chat(usr, "<span class='notice'>You begin printing a custom assembly. This will take approximately [round(cloning_time/10)] seconds. You can still print \
					off normal parts during this time.</span>")
					playsound(src, 'sound/items/poster_being_created.ogg', 50, TRUE)
					addtimer(CALLBACK(src, .proc/print_program, usr), cloning_time)

			if("cancel")
				if(!cloning || !program)
					return

				to_chat(usr, "<span class='notice'>Cloning has been canceled. Cost has been refunded.</span>")
				cloning = FALSE
				var/cost = program["cost"]
				for(var/material in cost)
					materials[material] = min(material_max, materials[material] + cost[material])

	// forces change checking because it fails on some elements
	ui.check_for_change(TRUE)

/obj/item/device/integrated_circuit_printer/proc/subtract_material_costs(var/list/cost, var/mob/user)
	for(var/material in cost)
		if(materials[material] < cost[material])
			var/material/material_datum = SSmaterials.get_material_by_name(material)
			to_chat(user, "<span class='warning'>You need [cost[material]] [material_datum.display_name] to build that!</span>")
			return FALSE
	for(var/material in cost) //Iterate twice to make sure it's going to work before deducting
		materials[material] -= cost[material]
	return TRUE

// FUKKEN UPGRADE DISKS
/obj/item/disk/integrated_circuit/upgrade
	name = "integrated circuit printer upgrade disk"
	desc = "Install this into your integrated circuit printer to enhance it."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "upgrade_disk"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL

/obj/item/disk/integrated_circuit/upgrade/advanced
	name = "integrated circuit printer upgrade disk - advanced designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, advanced designs to the printer."

/obj/item/disk/integrated_circuit/upgrade/clone
	name = "integrated circuit printer upgrade disk - instant cloner"
	desc = "Install this into your integrated circuit printer to enhance it.  This one allows the printer to duplicate assemblies instantaneously."
	icon_state = "upgrade_disk_clone"
