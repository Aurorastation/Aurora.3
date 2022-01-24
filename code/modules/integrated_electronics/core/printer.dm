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

/obj/item/device/integrated_circuit_printer/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/stack = O
		if(stack.material.name == DEFAULT_WALL_MATERIAL)
			var/num = min((max_metal - metal) / metal_per_sheet, stack.amount)
			if(num < 1)
				to_chat(user, "<span class='warning'>\The [src] is too full to add more metal.</span>")
				return
			if(stack.use(num))
				to_chat(user, "<span class='notice'>You add [num] sheet\s to \the [src].</span>")
				metal += num * metal_per_sheet
				SSvueui.check_uis_for_change(src)
				return TRUE

	if(istype(O,/obj/item/integrated_circuit))
		to_chat(user, "<span class='notice'>You insert the circuit into \the [src]. </span>")
		user.unEquip(O)
		metal = min(metal + O.w_class, max_metal)
		qdel(O)
		SSvueui.check_uis_for_change(src)
		return TRUE

	if(istype(O,/obj/item/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, "<span class='warning'>\The [src] already has this upgrade. </span>")
			return TRUE
		to_chat(user, "<span class='notice'>You install \the [O] into  \the [src]. </span>")
		upgraded = TRUE
		SSvueui.check_uis_for_change(src)
		return TRUE

	if(istype(O,/obj/item/disk/integrated_circuit/upgrade/clone))
		if(can_clone)
			to_chat(user, "<span class='warning'>\The [src] already has this upgrade. </span>")
			return TRUE
		to_chat(user, "<span class='notice'>You install \the [O] into  \the [src]. </span>")
		can_clone = TRUE
		SSvueui.check_uis_for_change(src)
		return TRUE

	return ..()

/obj/item/device/integrated_circuit_printer/attack_self(var/mob/user)
	interact(user)

/obj/item/device/integrated_circuit_printer/interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "devices-circuit-printer", 600, 500, "Integrated Circuit Printer")
	ui.open()

/obj/item/device/integrated_circuit_printer/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	. = ..()
	data = . || data || list()

	data["metal"] = metal / metal_per_sheet
	data["metal_max"] = max_metal / metal_per_sheet
	data["upgraded"] = upgraded
	data["can_clone"] = can_clone
	data["assembly_to_clone"] = assembly_to_clone ? assembly_to_clone.name : FALSE
	
	if(upgraded)
		data["circuits"] = SSelectronics.printer_recipe_list_upgraded
	else
		data["circuits"] = SSelectronics.printer_recipe_list_basic

	return data

/obj/item/device/integrated_circuit_printer/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)

	if(href_list["build"])
		var/build_type = text2path(href_list["build"])
		if(!build_type || !ispath(build_type))
			return 1

		if (!can_print(build_type))
			to_chat(usr, "<span class='danger'>[src] buzzes angrily at you!</span>")
			return 1

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
			to_chat(usr, "<span class='warning'>You need [cost] metal to build that!.</span>")
			return 1
		metal -= cost
		if (is_asm)
			new build_type(get_turf(loc), TRUE)
		else
			new build_type(get_turf(loc))

	SSvueui.check_uis_for_change(src)

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
