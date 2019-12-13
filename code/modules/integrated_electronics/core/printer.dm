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
	var/current_category
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
				interact(user)
				return TRUE

	if(istype(O,/obj/item/integrated_circuit))
		to_chat(user, "<span class='notice'>You insert the circuit into \the [src]. </span>")
		user.unEquip(O)
		metal = min(metal + O.w_class, max_metal)
		qdel(O)
		interact(user)
		return TRUE

	if(istype(O,/obj/item/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, "<span class='warning'>\The [src] already has this upgrade. </span>")
			return TRUE
		to_chat(user, "<span class='notice'>You install \the [O] into  \the [src]. </span>")
		upgraded = TRUE
		interact(user)
		return TRUE

	if(istype(O,/obj/item/disk/integrated_circuit/upgrade/clone))
		if(can_clone)
			to_chat(user, "<span class='warning'>\The [src] already has this upgrade. </span>")
			return TRUE
		to_chat(user, "<span class='notice'>You install \the [O] into  \the [src]. </span>")
		can_clone = TRUE
		interact(user)
		return TRUE

	return ..()

/obj/item/device/integrated_circuit_printer/attack_self(var/mob/user)
	interact(user)

/obj/item/device/integrated_circuit_printer/interact(mob/user)
	var/window_height = 600
	var/window_width = 500

	if(isnull(current_category))
		current_category = SSelectronics.printer_recipe_list[1]

	var/HTML = "<center><h2>Integrated Circuit Printer</h2></center><br>"
	HTML += "Metal: [metal/metal_per_sheet]/[max_metal/metal_per_sheet] sheets.<br>"
	HTML += "Circuits available: [upgraded ? "Regular":"Advanced"]."
	HTML += "Assembly Cloning: [can_clone ? "Available": "Unavailable"]."
	if(assembly_to_clone)
		HTML += "Assembly '[assembly_to_clone.name]' loaded."
	HTML += "Crossed out circuits mean that the printer is not sufficentally upgraded to create that circuit.<br>"
	HTML += "<hr>"
	HTML += "Categories:"
	for(var/category in SSelectronics.printer_recipe_list)
		if(category != current_category)
			HTML += " <a href='?src=\ref[src];category=[category]'>[category]</a> "
		else // Bold the button if it's already selected.
			HTML += " <b>[category]</b> "
	HTML += "<hr>"
	HTML += "<center><h4>[current_category]</h4></center>"

	var/list/current_list = SSelectronics.printer_recipe_list[current_category]
	for(var/obj/O in current_list)
		var/can_build = TRUE
		if(istype(O, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = O
			if((IC.spawn_flags & IC_SPAWN_RESEARCH) && (!(IC.spawn_flags & IC_SPAWN_DEFAULT)) && !upgraded)
				can_build = FALSE
		if(can_build)
			HTML += "<A href='?src=\ref[src];build=[O.type]'>[O.name]</A>: [O.desc]<br>"
		else
			HTML += "<s>[O.name]: [O.desc]</s><br>"

	var/datum/browser/B = new(user, "integrated_printer", null, window_width, window_height)
	B.set_content(HTML)
	B.open(FALSE)

/obj/item/device/integrated_circuit_printer/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)

	if(href_list["category"])
		current_category = href_list["category"]

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

	interact(usr)

/obj/item/device/integrated_circuit_printer/proc/can_print(build_type)
	var/list/current_list = SSelectronics.printer_recipe_list[current_category]

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
