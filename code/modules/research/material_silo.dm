/obj/structure/machinery/r_n_d/material_silo
	name = "material silo"
	desc = "A centralized material store used by linked research fabricators."
	icon_state = "silo"

	idle_power_usage = 30 WATTS

	/// Total material capacity, measured in material units.
	var/max_material_storage = 800000

	/// Materials shared by every fabricator connected to the same R&D console.
	var/list/materials = list(
		MATERIAL_STEEL = 0,
		MATERIAL_GLASS = 0,
		MATERIAL_GOLD = 0,
		MATERIAL_SILVER = 0,
		MATERIAL_PHORON = 0,
		MATERIAL_URANIUM = 0,
		MATERIAL_DIAMOND = 0,
		MATERIAL_PLASTEEL = 0,
		MATERIAL_ALUMINIUM = 0,
		MATERIAL_LEAD = 0
	)

/obj/structure/machinery/r_n_d/material_silo/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += SPAN_NOTICE("\t- The shared storage capacity is <b>[max_material_storage / SHEET_MATERIAL_AMOUNT]</b> sheets.")

/obj/structure/machinery/r_n_d/material_silo/Initialize(mapload, d, populate_components, is_internal)
	. = ..()
	update_icon()

/obj/structure/machinery/r_n_d/material_silo/update_icon()
	. = ..()
	ClearOverlays()
	if(!(stat & (NOPOWER | BROKEN)))
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")

/obj/structure/machinery/r_n_d/material_silo/proc/TotalMaterials()
	SSmaterials.normalize_material_amounts(materials)
	var/total = 0
	for(var/material in materials)
		total += materials[material]
	return total

/obj/structure/machinery/r_n_d/material_silo/proc/get_material_amount(material_id)
	SSmaterials.normalize_material_amounts(materials)
	var/material = SSmaterials.material_to_path(material_id, FALSE)
	if(!material)
		material = material_id
	return materials[material] || 0

/obj/structure/machinery/r_n_d/material_silo/proc/has_material(material_id, amount)
	return get_material_amount(material_id) >= amount

/obj/structure/machinery/r_n_d/material_silo/proc/add_material(material_id, amount)
	if(amount <= 0)
		return 0
	var/material = SSmaterials.material_to_path(material_id, FALSE)
	if(!material)
		material = material_id
	if(!(material in materials))
		return 0
	var/accepted = min(amount, max_material_storage - TotalMaterials())
	if(accepted <= 0)
		return 0
	SSmaterials.add_material_amount(materials, material, accepted)
	update_linked_uis()
	return accepted

/obj/structure/machinery/r_n_d/material_silo/proc/remove_material(material_id, amount)
	if(amount <= 0)
		return TRUE
	var/material = SSmaterials.material_to_path(material_id, FALSE)
	if(!material)
		material = material_id
	if(!has_material(material, amount))
		return FALSE
	SSmaterials.remove_material_amount(materials, material, amount)
	update_linked_uis()
	return TRUE

/obj/structure/machinery/r_n_d/material_silo/proc/eject_material(material_id, requested_sheets)
	if(requested_sheets < 1)
		return FALSE
	var/material = SSmaterials.material_to_path(material_id, FALSE)
	if(!material)
		return FALSE
	var/available = round(get_material_amount(material) / SHEET_MATERIAL_AMOUNT)
	var/amount = min(requested_sheets, available)
	if(amount < 1)
		return FALSE
	var/stack_type = SSmaterials.material_stack_type(material)
	if(!stack_type)
		return FALSE
	var/obj/item/stack/material/stack = new stack_type(loc, amount)
	stack.update_icon()
	SSmaterials.remove_material_amount(materials, material, amount * SHEET_MATERIAL_AMOUNT)
	update_linked_uis()
	return TRUE

/obj/structure/machinery/r_n_d/material_silo/proc/wake_linked_fabricators()
	linked_console?.dispatch_fabrication_jobs()

/obj/structure/machinery/r_n_d/material_silo/proc/update_linked_uis()
	if(!linked_console)
		return
	SStgui.update_uis(linked_console)
	for(var/obj/structure/machinery/r_n_d/fabricator/fabricator as anything in linked_console.linked_fabricators)
		SStgui.update_uis(fabricator)

/obj/structure/machinery/r_n_d/material_silo/attackby(obj/item/attacking_item, mob/user)
	if(user.a_intent == I_HURT)
		return ..()
	if(default_deconstruction_screwdriver(user, attacking_item))
		disconnect_console()
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE
	if(panel_open)
		to_chat(user, SPAN_NOTICE("You can't load \the [src] while it's opened."))
		return TRUE
	if(!istype(attacking_item, /obj/item/stack/material))
		return ..()
	if(stat)
		return TRUE

	var/obj/item/stack/material/stack = attacking_item
	if(!stack.default_type || !stack.material)
		to_chat(user, SPAN_WARNING("This stack cannot be stored."))
		return TRUE

	var/material = SSmaterials.material_to_path(stack.default_type, FALSE)
	if(!material)
		material = stack.default_type
	if(!(material in materials))
		to_chat(user, SPAN_WARNING("\The [src] cannot hold [stack.material.name]."))
		return TRUE

	var/max_value = min(stack.get_amount(), round((max_material_storage - TotalMaterials()) / SHEET_MATERIAL_AMOUNT))
	if(max_value < 1)
		to_chat(user, SPAN_NOTICE("\The [src] is full."))
		return TRUE

	var/amount = tgui_input_number(user, "How many sheets do you want to add?", "Add sheets", min(10, max_value), max_value = max_value, min_value = 1, round_value = TRUE)
	if(!amount || !Adjacent(user))
		return TRUE

	use_power_oneoff(max(1000, SHEET_MATERIAL_AMOUNT * amount / 10))
	if(do_after(user, 1.6 SECONDS) && stack.use(amount))
		SSmaterials.add_material_amount(materials, material, amount * SHEET_MATERIAL_AMOUNT)
		to_chat(user, SPAN_NOTICE("You add [amount] sheet\s of [stack.material.name] to \the [src]."))
		update_linked_uis()
		wake_linked_fabricators()
	return TRUE

/obj/structure/machinery/r_n_d/material_silo/dismantle()
	SSmaterials.normalize_material_amounts(materials)
	for(var/material in materials)
		var/sheets = round(materials[material] / SHEET_MATERIAL_AMOUNT)
		if(sheets < 1)
			continue
		var/stack_type = SSmaterials.material_stack_type(material)
		if(!stack_type)
			continue
		var/obj/item/stack/material/stack = new stack_type(loc, sheets)
		stack.update_icon()
	..()

/obj/structure/machinery/r_n_d/material_silo/proc/disconnect_console()
	if(linked_console)
		linked_console.linked_silo = null
		linked_console = null
