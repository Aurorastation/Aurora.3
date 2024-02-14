/obj/item/device/integrated_circuit_printer
	name = "integrated circuit printer"
	desc = "A portable(ish) machine made to print tiny modular circuitry out of metal."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "circuit_printer"
	w_class = ITEMSIZE_LARGE
	var/metal = 0
	var/max_metal = 100
	var/metal_per_sheet = 10 // One sheet equals this much metal.

	var/upgraded = FALSE  // When hit with an upgrade disk, will turn true, allowing it to print the higher tier circuits.
	var/can_clone = FALSE // Same for above, but will allow the printer to duplicate a specific assembly.
	var/obj/item/device/electronic_assembly/assembly_to_clone

/obj/item/device/integrated_circuit_printer/upgraded
	upgraded = TRUE
	can_clone = TRUE

/obj/item/device/integrated_circuit_printer/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item,/obj/item/stack/material))
		var/obj/item/stack/material/stack = attacking_item
		if(stack.material.name == DEFAULT_WALL_MATERIAL)
			var/num = min((max_metal - metal) / metal_per_sheet, stack.amount)
			if(num < 1)
				to_chat(user, "<span class='warning'>\The [src] is too full to add more metal.</span>")
				return
			if(stack.use(num))
				to_chat(user, "<span class='notice'>You add [num] sheet\s to \the [src].</span>")
				metal += num * metal_per_sheet
				return TRUE

	if(istype(attacking_item,/obj/item/integrated_circuit))
		to_chat(user, "<span class='notice'>You insert the circuit into \the [src]. </span>")
		user.unEquip(attacking_item)
		metal = min(metal + attacking_item.w_class, max_metal)
		qdel(attacking_item)
		return TRUE

	if(istype(attacking_item,/obj/item/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, "<span class='warning'>\The [src] already has this upgrade. </span>")
			return TRUE
		to_chat(user, "<span class='notice'>You install \the [attacking_item] into  \the [src]. </span>")
		upgraded = TRUE
		return TRUE

	if(istype(attacking_item,/obj/item/disk/integrated_circuit/upgrade/clone))
		if(can_clone)
			to_chat(user, "<span class='warning'>\The [src] already has this upgrade. </span>")
			return TRUE
		to_chat(user, "<span class='notice'>You install \the [attacking_item] into  \the [src]. </span>")
		can_clone = TRUE
		return TRUE

	return ..()

/obj/item/device/integrated_circuit_printer/attack_self(var/mob/user)
	ui_interact(user)

/obj/item/device/integrated_circuit_printer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CircuitPrinter", "Integrated Circuit Printer", 600, 500)
		ui.open()

/obj/item/device/integrated_circuit_printer/ui_data(mob/user)
	var/list/data = list()

	data["metal"] = metal / metal_per_sheet
	data["metal_max"] = max_metal / metal_per_sheet
	data["upgraded"] = upgraded
	data["can_clone"] = can_clone
	data["assembly_to_clone"] = assembly_to_clone ? assembly_to_clone.name : "None"

	if(upgraded)
		data["circuits"] = SSelectronics.printer_recipe_list_upgraded
	else
		data["circuits"] = SSelectronics.printer_recipe_list_basic

	data["categories"] = SSelectronics.found_categories

	return data

/obj/item/device/integrated_circuit_printer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	add_fingerprint(usr)

	if(action == "build")
		var/build_type = text2path(params["build"])
		if(!build_type || !ispath(build_type))
			return FALSE

		if (!can_print(build_type))
			to_chat(usr, SPAN_WARNING("[src] buzzes angrily at you!"))
			return FALSE

		var/cost = 1
		var/is_asm = FALSE
		if(ispath(build_type, /obj/item/device/electronic_assembly))
			var/obj/item/device/electronic_assembly/E = build_type
			cost = round( (initial(E.max_complexity) + initial(E.max_components) ) / 4)
			is_asm = TRUE
		else if(ispath(build_type, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = build_type
			cost = initial(IC.w_class)

		if(metal - cost < 0)
			to_chat(usr, SPAN_WARNING("You need [cost] metal to build that!"))
			return FALSE
		metal -= cost
		if (is_asm)
			new build_type(get_turf(loc), TRUE)
		else
			new build_type(get_turf(loc))
		. = TRUE

/obj/item/device/integrated_circuit_printer/proc/can_print(build_type)
	for(var/category in SSelectronics.printer_recipe_list)
		var/list/current_list = SSelectronics.printer_recipe_list[category]

		for (var/obj/O in current_list)
			if (O.type == build_type)
				return TRUE

	return FALSE

// FUKKEN UPGRADE DISKS
/obj/item/disk/integrated_circuit/upgrade
	name = "integrated circuit printer upgrade disk"
	desc = "Install this into your integrated circuit printer to enhance it."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "upgrade_disk"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)

/obj/item/disk/integrated_circuit/upgrade/advanced
	name = "integrated circuit printer upgrade disk - advanced designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, advanced designs to the printer."

// To be implemented later.
/obj/item/disk/integrated_circuit/upgrade/clone
	name = "integrated circuit printer upgrade disk - circuit cloner"
	desc = "Install this into your integrated circuit printer to enhance it.  This one allows the printer to duplicate assemblies."
	icon_state = "upgrade_disk_clone"
	origin_tech = list(TECH_ENGINEERING = 5, TECH_DATA = 6)
