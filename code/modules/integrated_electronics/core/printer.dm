/obj/item/integrated_circuit_printer
	name = "integrated circuit printer"
	desc = "A portable(ish) machine made to print tiny modular circuitry out of metal."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "circuit_printer"
	w_class = WEIGHT_CLASS_NORMAL

	// Material storage.
	// One sheet equals 10 stored material units.
	// Total upgraded storage cap is 520 material units:
	// 500 steel + 20 phoron.
	var/metal = 0
	var/max_metal = 100
	var/metal_per_sheet = 10

	// Stored phoron amount available for printing.
	var/phoron = 0
	var/max_phoron = 20
	var/phoron_per_sheet = 10

	var/clone_metal_storage_bonus = 400

	var/upgraded = FALSE
	var/can_clone = FALSE
	var/obj/item/electronic_assembly/assembly_to_clone
	var/obj/item/clone_item_to_clone
	var/currently_printing = FALSE

	// Imported/exported copy-paste blueprint data.
	var/list/clone_blueprint_data = null
	var/clone_blueprint_name = null
	var/clone_blueprint_export = null
	var/clone_blueprint_import_buffer = ""
	var/clone_blueprint_export_visible = FALSE
	var/clone_blueprint_metal_cost = 0
	var/clone_blueprint_phoron_cost = 0
	var/clone_blueprint_print_time = 0

	// Clone timing is based on total clone steel cost.
	// 1 SECOND is 10 ticks on this codebase.
	var/clone_min_print_time = 5 SECONDS
	var/clone_max_print_time = 300 SECONDS


/obj/item/integrated_circuit_printer/upgraded
	upgraded = TRUE
	can_clone = TRUE
	max_metal = 500
	max_phoron = 20


/obj/item/integrated_circuit_printer/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/stack/material))
		var/obj/item/stack/material/stack = attacking_item
		var/material_name = lowertext(stack.material.name)

		if(stack.material.name == DEFAULT_WALL_MATERIAL)
			var/num = min(FLOOR((max_metal - metal) / metal_per_sheet, 1), stack.amount)
			if(num < 1)
				to_chat(user, SPAN_WARNING("\The [src] is too full to add more steel."))
				return TRUE

			if(stack.use(num))
				to_chat(user, SPAN_NOTICE("You add [num] steel sheet\s to \the [src]."))
				metal += num * metal_per_sheet
				return TRUE

		if(material_name == "phoron")
			var/num = min(FLOOR((max_phoron - phoron) / phoron_per_sheet, 1), stack.amount)
			if(num < 1)
				to_chat(user, SPAN_WARNING("\The [src] is too full to add more phoron."))
				return TRUE

			if(stack.use(num))
				to_chat(user, SPAN_NOTICE("You add [num] phoron sheet\s to \the [src]."))
				phoron += num * phoron_per_sheet
				return TRUE

	if(scan_cloneable_item(attacking_item, user))
		return TRUE

	if(istype(attacking_item, /obj/item/integrated_circuit))
		to_chat(user, SPAN_NOTICE("You insert the circuit into \the [src]. "))
		user.unEquip(attacking_item)
		metal = min(metal + attacking_item.w_class, max_metal)
		phoron = min(phoron + get_circuit_phoron_cost(attacking_item.type), max_phoron)
		qdel(attacking_item)
		return TRUE

	if(istype(attacking_item, /obj/item/disk/integrated_circuit/upgrade/clone))
		if(can_clone)
			to_chat(user, SPAN_WARNING("\The [src] already has this upgrade. "))
			return TRUE

		to_chat(user, SPAN_NOTICE("You install \the [attacking_item] into \the [src]. "))
		can_clone = TRUE
		max_metal = min(max_metal + clone_metal_storage_bonus, 500)
		qdel(attacking_item)
		return TRUE

	if(istype(attacking_item, /obj/item/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, SPAN_WARNING("\The [src] already has this upgrade. "))
			return TRUE

		to_chat(user, SPAN_NOTICE("You install \the [attacking_item] into \the [src]. "))
		upgraded = TRUE
		qdel(attacking_item)
		return TRUE

	return ..()


/obj/item/integrated_circuit_printer/attack_self(var/mob/user)
	ui_interact(user)


/obj/item/integrated_circuit_printer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		ui = new(user, src, "CircuitPrinter", "Integrated Circuit Printer", 600, 500)
		ui.open()


/obj/item/integrated_circuit_printer/ui_data(mob/user)
	var/list/data = list()

	data["metal"] = metal / metal_per_sheet
	data["metal_max"] = max_metal / metal_per_sheet
	data["phoron"] = phoron / phoron_per_sheet
	data["phoron_max"] = max_phoron / phoron_per_sheet
	data["upgraded"] = upgraded
	data["can_clone"] = can_clone
	data["assembly_to_clone"] = assembly_to_clone ? (clone_item_to_clone ? clone_item_to_clone.name : assembly_to_clone.name) : clone_blueprint_name ? clone_blueprint_name : "None"
	data["has_clone_loaded"] = assembly_to_clone || clone_blueprint_data ? TRUE : FALSE
	data["clone_cost"] = assembly_to_clone ? round(get_clone_metal_cost(assembly_to_clone) / metal_per_sheet, 0.1) : clone_blueprint_data ? round(clone_blueprint_metal_cost / metal_per_sheet, 0.1) : 0
	data["clone_phoron_cost"] = assembly_to_clone ? round(get_clone_phoron_cost(assembly_to_clone) / phoron_per_sheet, 0.01) : clone_blueprint_data ? round(clone_blueprint_phoron_cost / phoron_per_sheet, 0.01) : 0
	data["clone_print_time"] = assembly_to_clone ? round(get_clone_print_time(assembly_to_clone) / 10, 0.1) : clone_blueprint_data ? round(clone_blueprint_print_time / 10, 0.1) : 0
	data["currently_printing"] = currently_printing
	data["has_live_clone_scan"] = assembly_to_clone ? TRUE : FALSE
	data["has_clone_blueprint"] = clone_blueprint_data ? TRUE : FALSE
	data["has_clone_blueprint_export"] = clone_blueprint_export ? TRUE : FALSE
	data["clone_blueprint_export_visible"] = clone_blueprint_export_visible
	data["clone_blueprint_export"] = clone_blueprint_export_visible && clone_blueprint_export ? clone_blueprint_export : ""
	data["blueprint_chunk_limit"] = IC_BLUEPRINT_CHUNK_LIMIT
	data["blueprint_buffer_limit"] = IC_BLUEPRINT_BUFFER_LIMIT

	if(upgraded)
		data["circuits"] = SSelectronics.printer_recipe_list_upgraded
	else
		data["circuits"] = SSelectronics.printer_recipe_list_basic

	data["categories"] = SSelectronics.found_categories

	return data


/obj/item/integrated_circuit_printer/proc/resolve_cloneable_assembly(obj/item/target)
	if(!target)
		return null

	if(istype(target, /obj/item/electronic_assembly))
		return target

	if(istype(target, /obj/item/radio/headset/circuitry))
		var/obj/item/radio/headset/circuitry/headset = target
		return headset.get_cloneable_assembly()

	return null


/obj/item/integrated_circuit_printer/proc/scan_cloneable_item(obj/item/target, mob/user)
	var/obj/item/electronic_assembly/E = resolve_cloneable_assembly(target)

	if(!E)
		return FALSE

	if(!can_clone)
		to_chat(user, SPAN_WARNING("\The [src] needs a circuit cloner upgrade before it can scan assemblies."))
		return TRUE

	assembly_to_clone = E
	clone_item_to_clone = istype(target, /obj/item/electronic_assembly) ? null : target
	clone_blueprint_data = null
	clone_blueprint_name = null
	clone_blueprint_metal_cost = 0
	clone_blueprint_phoron_cost = 0
	clone_blueprint_print_time = 0
	clone_blueprint_export_visible = FALSE
	var/list/scanned_blueprint = serialize_clone_blueprint(assembly_to_clone, clone_item_to_clone)
	clone_blueprint_export = scanned_blueprint ? json_encode(scanned_blueprint) : null

	to_chat(user, SPAN_NOTICE("You scan \the [target] into \the [src]'s cloning buffer."))
	SStgui.update_uis(src)
	return TRUE

/obj/item/integrated_circuit_printer/proc/import_clone_blueprint_text(var/import_text, var/mob/user)
	if(!import_text)
		if(user)
			to_chat(user, SPAN_WARNING("No cloning blueprint text was provided."))
		return FALSE

	import_text = html_decode(import_text)

	if(length(import_text) > IC_BLUEPRINT_BUFFER_LIMIT)
		to_chat(user, SPAN_WARNING("That cloning blueprint is [length(import_text)] characters, but the maximum import size is [IC_BLUEPRINT_BUFFER_LIMIT] characters."))
		return FALSE

	var/start_index = findtext(import_text, "{")
	var/end_index = findlasttext(import_text, "}")

	if(start_index && end_index && end_index >= start_index)
		import_text = copytext(import_text, start_index, end_index + 1)


	var/imported_blueprint
	try
		imported_blueprint = json_decode(import_text)
	catch(var/exception/a)
		if(user)
			to_chat(user, SPAN_WARNING("That cloning blueprint text failed JSON decoding: [a]."))
			if(user)
				to_chat(user, SPAN_WARNING("Import text preview start: [copytext(import_text, 1, min(length(import_text), 200))]"))
				if(length(import_text) > 200)
					to_chat(user, SPAN_WARNING("Import text preview end: [copytext(import_text, max(1, length(import_text) - 199), length(import_text))]"))
		return FALSE


	if(!islist(imported_blueprint))
		if(user)
			to_chat(user, SPAN_WARNING("That cloning blueprint text is invalid JSON or did not decode into a list."))
		return FALSE

	var/assembly_path = text2path(imported_blueprint["assembly_type"])
	if(!assembly_path || !ispath(assembly_path, /obj/item/electronic_assembly))
		var/assembly_type_text = imported_blueprint["assembly_type"]
		if(user)
			to_chat(user, SPAN_WARNING("That cloning blueprint does not contain a valid assembly type: [assembly_type_text]."))
		return FALSE


	var/list/circuit_blueprints = imported_blueprint["circuits"]
	if(!islist(circuit_blueprints))
		if(user)
			to_chat(user, SPAN_WARNING("That cloning blueprint does not contain a valid circuits list."))
		return FALSE


	var/new_metal_cost = 0
	try
		new_metal_cost = get_clone_blueprint_metal_cost(imported_blueprint)
	catch(var/exception/b)
		if(user)
			to_chat(user, SPAN_WARNING("Blueprint steel cost calculation failed: [b]."))
		return FALSE

	var/new_phoron_cost = 0
	try
		new_phoron_cost = get_clone_blueprint_phoron_cost(imported_blueprint)
	catch(var/exception/c)
		if(user)
			to_chat(user, SPAN_WARNING("Blueprint phoron cost calculation failed: [c]."))
		return FALSE

	var/new_print_time = 0
	try
		new_print_time = get_clone_blueprint_print_time(imported_blueprint)
	catch(var/exception/d)
		if(user)
			to_chat(user, SPAN_WARNING("Blueprint print time calculation failed: [d]."))
		return FALSE

	var/new_blueprint_name = imported_blueprint["name"]
	if(!new_blueprint_name)
		var/obj/item/electronic_assembly/E = assembly_path
		new_blueprint_name = initial(E.name)

	clone_blueprint_data = imported_blueprint
	clone_blueprint_name = new_blueprint_name
	clone_blueprint_export = import_text
	clone_blueprint_export_visible = FALSE
	clone_blueprint_metal_cost = new_metal_cost
	clone_blueprint_phoron_cost = new_phoron_cost
	clone_blueprint_print_time = new_print_time
	assembly_to_clone = null
	clone_item_to_clone = null

	if(user)
		to_chat(user, SPAN_NOTICE("You import the cloning blueprint: [clone_blueprint_name]."))
	SStgui.update_uis(src)
	return TRUE

/obj/item/integrated_circuit_printer/proc/append_clone_blueprint_chunk(var/import_chunk, var/mob/user, var/max_chunk_length = IC_BLUEPRINT_CHUNK_LIMIT)
	if(!istext(import_chunk))
		if(user)
			to_chat(user, SPAN_WARNING("No blueprint chunk text was received from the UI."))
		return FALSE

	// The TGUI sends each chunk through encodeURIComponent() after slicing the
	// original JSON. Decode each complete encoded chunk before appending it.
	// This avoids BYOND/TGUI transport edge cases where raw JSON punctuation
	// can be lost or altered inside action parameters.
	if(length(import_chunk) > max_chunk_length * 6)
		if(user)
			to_chat(user, SPAN_WARNING("That encoded blueprint chunk is [length(import_chunk)] characters, but chunks must be [max_chunk_length] decoded characters or less."))
		return FALSE

	import_chunk = url_decode(import_chunk)

	if(!length(import_chunk))
		if(user)
			to_chat(user, SPAN_WARNING("The received blueprint chunk was empty."))
		return FALSE

	if(length(import_chunk) > max_chunk_length)
		if(user)
			to_chat(user, SPAN_WARNING("That blueprint chunk is [length(import_chunk)] characters, but chunks must be [max_chunk_length] characters or less."))
		return FALSE

	if(length(clone_blueprint_import_buffer) + length(import_chunk) > IC_BLUEPRINT_BUFFER_LIMIT)
		if(user)
			to_chat(user, SPAN_WARNING("The cloning blueprint import buffer cannot hold [length(clone_blueprint_import_buffer) + length(import_chunk)] characters. Maximum: [IC_BLUEPRINT_BUFFER_LIMIT]."))
		return FALSE

	clone_blueprint_import_buffer += import_chunk

	return TRUE

/obj/item/integrated_circuit_printer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	add_fingerprint(usr)

	if(currently_printing)
		to_chat(usr, SPAN_WARNING("\The [src] is already printing."))
		return FALSE

	if(action == "clear_clone")
		assembly_to_clone = null
		clone_item_to_clone = null
		if(!clone_blueprint_data)
			clone_blueprint_export = null
		clone_blueprint_export_visible = FALSE
		return TRUE

	if(action == "show_clone_blueprint_export")
		if(!clone_blueprint_export)
			to_chat(usr, SPAN_WARNING("There is no cloning blueprint export loaded."))
			return FALSE

		clone_blueprint_export_visible = TRUE
		return TRUE

	if(action == "hide_clone_blueprint_export")
		clone_blueprint_export_visible = FALSE
		return TRUE

	if(action == "begin_import_buffer")
		if(!can_clone)
			to_chat(usr, SPAN_WARNING("\The [src] needs a circuit cloner upgrade for that."))
			return FALSE

		clone_blueprint_import_buffer = ""
		clone_blueprint_export_visible = FALSE
		return TRUE

	if(action == "append_import_chunk_tgui")
		if(!can_clone)
			to_chat(usr, SPAN_WARNING("\The [src] needs a circuit cloner upgrade for that."))
			return FALSE

		var/import_chunk = params["chunk"]
		if(!istext(import_chunk))
			to_chat(usr, SPAN_WARNING("No blueprint chunk text was received from the UI."))
			return FALSE

		return append_clone_blueprint_chunk(import_chunk, usr)

	if(action == "reject_oversized_import_tgui")
		var/blueprint_length = text2num(params["length"])
		if(!blueprint_length)
			to_chat(usr, SPAN_WARNING("The pasted cloning blueprint is too large to import. Maximum: [IC_BLUEPRINT_BUFFER_LIMIT] characters."))
		else
			to_chat(usr, SPAN_WARNING("The pasted cloning blueprint is [blueprint_length] characters, but the maximum import size is [IC_BLUEPRINT_BUFFER_LIMIT] characters."))
		return FALSE

	if(action == "finish_import_buffer_tgui")
		if(!can_clone)
			to_chat(usr, SPAN_WARNING("\The [src] needs a circuit cloner upgrade for that."))
			return FALSE

		if(!clone_blueprint_import_buffer)
			to_chat(usr, SPAN_WARNING("The cloning blueprint import buffer is empty."))
			return FALSE


		var/import_success = import_clone_blueprint_text(clone_blueprint_import_buffer, usr)
		if(import_success)
			clone_blueprint_import_buffer = ""
		return import_success

	if(action == "clear_imported_clone")
		clone_blueprint_data = null
		clone_blueprint_name = null
		clone_blueprint_export = null
		clone_blueprint_import_buffer = ""
		clone_blueprint_export_visible = FALSE
		clone_blueprint_metal_cost = 0
		clone_blueprint_phoron_cost = 0
		clone_blueprint_print_time = 0
		to_chat(usr, SPAN_NOTICE("You clear the imported circuit cloning blueprint."))
		return TRUE

	if(action == "clone")
		if(!can_clone)
			to_chat(usr, SPAN_WARNING("\The [src] needs a circuit cloner upgrade for that."))
			return FALSE

		var/cost = 0
		var/phoron_cost = 0
		var/print_time = 0
		var/obj/item/electronic_assembly/live_scan_to_print = null
		var/obj/item/live_host_to_print = null
		var/list/blueprint_to_print = null

		if(assembly_to_clone && !QDELETED(assembly_to_clone))
			live_scan_to_print = assembly_to_clone
			if(clone_item_to_clone && !QDELETED(clone_item_to_clone))
				live_host_to_print = clone_item_to_clone
			cost = get_clone_metal_cost(live_scan_to_print)
			phoron_cost = get_clone_phoron_cost(live_scan_to_print)
			print_time = get_clone_print_time(live_scan_to_print)
		else
			assembly_to_clone = null
			clone_item_to_clone = null

			if(!clone_blueprint_data)
				to_chat(usr, SPAN_WARNING("There is no valid assembly or imported blueprint loaded into the cloning buffer."))
				return FALSE

			blueprint_to_print = clone_blueprint_data
			cost = clone_blueprint_metal_cost
			phoron_cost = clone_blueprint_phoron_cost
			print_time = clone_blueprint_print_time

		if(metal - cost < 0)
			to_chat(usr, SPAN_WARNING("You need [round(cost / metal_per_sheet, 0.1)] sheet\s of steel to clone that!"))
			return FALSE

		if(phoron - phoron_cost < 0)
			to_chat(usr, SPAN_WARNING("You need [round(phoron_cost / phoron_per_sheet, 0.01)] sheet\s of phoron to clone that!"))
			return FALSE

		currently_printing = TRUE
		to_chat(usr, SPAN_NOTICE("\The [src] begins printing a cloned assembly."))

		var/mob/printing_user = usr
		spawn(print_time)
			finish_clone_print(printing_user, cost, phoron_cost, live_scan_to_print, live_host_to_print, blueprint_to_print)

		return TRUE

	if(action == "build")
		var/build_type = text2path(params["build"])
		if(!build_type || !ispath(build_type))
			return FALSE

		if(!can_print(build_type))
			to_chat(usr, SPAN_WARNING("[src] buzzes angrily at you!"))
			return FALSE

		var/cost = 1
		var/phoron_cost = 0
		var/is_printed_assembly_container = is_printed_assembly_container_type(build_type)

		if(ispath(build_type, /obj/item/electronic_assembly))
			var/obj/item/electronic_assembly/E = build_type
			cost = round((initial(E.max_complexity) + initial(E.max_components)) / 4)
		else if(ispath(build_type, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = build_type
			cost = initial(IC.w_class)
			phoron_cost = get_circuit_phoron_cost(build_type)

		if(metal - cost < 0)
			to_chat(usr, SPAN_WARNING("You need [cost] steel to build that!"))
			return FALSE

		if(phoron - phoron_cost < 0)
			to_chat(usr, SPAN_WARNING("You need [round(phoron_cost / phoron_per_sheet, 0.01)] sheet\s of phoron to build that!"))
			return FALSE

		metal -= cost
		phoron -= phoron_cost

		if(is_printed_assembly_container)
			new build_type(get_turf(loc), TRUE)
		else
			new build_type(get_turf(loc))

		return TRUE

	return FALSE


/obj/item/integrated_circuit_printer/proc/finish_clone_print(mob/user, cost, phoron_cost, obj/item/electronic_assembly/live_scan_to_print, obj/item/live_host_to_print, list/blueprint_to_print)
	if(QDELETED(src))
		return

	currently_printing = FALSE

	if(metal - cost < 0)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] does not have enough steel to finish the cloned assembly."))
		return

	if(phoron - phoron_cost < 0)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] does not have enough phoron to finish the cloned assembly."))
		return

	metal -= cost
	phoron -= phoron_cost

	var/obj/item/new_clone = null

	if(live_scan_to_print && !QDELETED(live_scan_to_print))
		if(istype(live_host_to_print, /obj/item/radio/headset/circuitry) && !QDELETED(live_host_to_print))
			var/obj/item/radio/headset/circuitry/headset = live_host_to_print
			new_clone = headset.clone_with_integrated_assembly(get_turf(src), src, live_scan_to_print)
		else
			new_clone = clone_assembly(live_scan_to_print, get_turf(src))
	else if(blueprint_to_print)
		new_clone = clone_assembly_from_blueprint(blueprint_to_print, get_turf(src))

	if(!new_clone)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] fails to finish the cloned assembly."))
		return

	if(user)
		to_chat(user, SPAN_NOTICE("\The [src] finishes printing \the [new_clone]."))


/obj/item/integrated_circuit_printer/proc/get_circuit_phoron_cost(circuit_type)
	if(!circuit_type || !ispath(circuit_type, /obj/item/integrated_circuit))
		return 0

	var/obj/item/integrated_circuit/IC = circuit_type
	return max(0, initial(IC.phoron_cost) * phoron_per_sheet)


/obj/item/integrated_circuit_printer/proc/get_clone_metal_cost(obj/item/electronic_assembly/source)
	if(!source)
		return 0

	var/case_cost = round((source.max_complexity + source.max_components) / 4)
	var/component_cost = 0

	for(var/obj/item/integrated_circuit/IC in source.contents)
		if(!IC.removable)
			continue
		component_cost += max(1, IC.w_class)

	return max(1, case_cost + component_cost)


/obj/item/integrated_circuit_printer/proc/get_clone_phoron_cost(obj/item/electronic_assembly/source)
	if(!source)
		return 0

	var/component_cost = 0

	for(var/obj/item/integrated_circuit/IC in source.contents)
		if(!IC.removable)
			continue
		component_cost += get_circuit_phoron_cost(IC.type)

	return component_cost


/obj/item/integrated_circuit_printer/proc/get_clone_print_time(obj/item/electronic_assembly/source)
	if(!source)
		return clone_min_print_time

	var/cost = get_clone_metal_cost(source)
	var/effective_max_cost = max(1, max_metal)
	var/cost_ratio = cost / effective_max_cost

	if(cost_ratio < 0)
		cost_ratio = 0
	if(cost_ratio > 1)
		cost_ratio = 1

	var/scaled_time = clone_min_print_time + ((clone_max_print_time - clone_min_print_time) * cost_ratio)

	if(scaled_time < clone_min_print_time)
		scaled_time = clone_min_print_time
	if(scaled_time > clone_max_print_time)
		scaled_time = clone_max_print_time

	return round(scaled_time)


/obj/item/integrated_circuit_printer/proc/clone_pin_data(datum/integrated_io/source_pin, datum/integrated_io/target_pin)
	if(!source_pin || !target_pin)
		return

	target_pin.write_data_to_pin(ic_copy_clone_value(source_pin.data))


/obj/item/integrated_circuit_printer/proc/clone_io_list_data(list/source_pins, list/target_pins)
	var/pin_count = min(source_pins.len, target_pins.len)

	for(var/i = 1 to pin_count)
		clone_pin_data(source_pins[i], target_pins[i])


/obj/item/integrated_circuit_printer/proc/map_builtin_circuits(obj/item/electronic_assembly/source, obj/item/electronic_assembly/clone, list/circuit_map)
	var/list/used_clone_builtins = list()

	for(var/obj/item/integrated_circuit/source_circuit in source.contents)
		if(source_circuit.removable)
			continue

		for(var/obj/item/integrated_circuit/clone_circuit in clone.contents)
			if(clone_circuit.removable)
				continue
			if(clone_circuit.type != source_circuit.type)
				continue
			if(used_clone_builtins.Find(clone_circuit))
				continue

			circuit_map[source_circuit] = clone_circuit
			used_clone_builtins += clone_circuit
			break


/obj/item/integrated_circuit_printer/proc/copy_assembly_into_existing(obj/item/electronic_assembly/source, obj/item/electronic_assembly/clone)
	if(!source || !clone)
		return FALSE

	clone.name = source.name
	clone.detail_color = source.detail_color
	clone.opened = FALSE
	clone.update_icon()

	var/list/circuit_map = list()
	map_builtin_circuits(source, clone, circuit_map)

	for(var/obj/item/integrated_circuit/source_circuit in source.contents)
		if(!source_circuit.removable)
			continue

		var/obj/item/integrated_circuit/new_circuit = new source_circuit.type(clone)
		new_circuit.displayed_name = source_circuit.displayed_name
		new_circuit.removable = source_circuit.removable
		new_circuit.assembly = clone
		clone.force_add_circuit(new_circuit)
		circuit_map[source_circuit] = new_circuit

	for(var/obj/item/integrated_circuit/source_circuit in source.contents)
		if(!source_circuit.removable)
			continue

		var/obj/item/integrated_circuit/new_circuit = circuit_map[source_circuit]
		if(!new_circuit)
			continue

		clone_io_list_data(source_circuit.inputs, new_circuit.inputs)
		clone_io_list_data(source_circuit.outputs, new_circuit.outputs)
		clone_io_list_data(source_circuit.activators, new_circuit.activators)
		source_circuit.copy_clone_state_to(new_circuit)

	for(var/obj/item/integrated_circuit/source_circuit in source.contents)
		if(!source_circuit.removable)
			continue

		var/obj/item/integrated_circuit/new_circuit = circuit_map[source_circuit]
		if(!new_circuit)
			continue

		copy_cloned_links(source_circuit.inputs, new_circuit.inputs, circuit_map)
		copy_cloned_links(source_circuit.outputs, new_circuit.outputs, circuit_map)
		copy_cloned_links(source_circuit.activators, new_circuit.activators, circuit_map)

	return TRUE


/obj/item/integrated_circuit_printer/proc/clone_assembly(obj/item/electronic_assembly/source, atom/location)
	if(!source || !location)
		return null

	var/obj/item/electronic_assembly/clone = new source.type(location, TRUE)

	if(!copy_assembly_into_existing(source, clone))
		qdel(clone)
		return null

	return clone


/obj/item/integrated_circuit_printer/proc/copy_cloned_links(list/source_pins, list/target_pins, list/circuit_map)
	var/pin_count = min(source_pins.len, target_pins.len)

	for(var/i = 1 to pin_count)
		var/datum/integrated_io/source_pin = source_pins[i]
		var/datum/integrated_io/target_pin = target_pins[i]

		for(var/datum/integrated_io/source_link in source_pin.linked)
			var/obj/item/integrated_circuit/linked_source_circuit = source_link.holder
			var/obj/item/integrated_circuit/linked_new_circuit = circuit_map[linked_source_circuit]
			if(!linked_new_circuit)
				continue

			var/datum/integrated_io/linked_new_pin = null
			var/source_link_index = linked_source_circuit.inputs.Find(source_link)

			if(source_link_index)
				linked_new_pin = linked_new_circuit.inputs[source_link_index]
			else
				source_link_index = linked_source_circuit.outputs.Find(source_link)
				if(source_link_index)
					linked_new_pin = linked_new_circuit.outputs[source_link_index]
				else
					source_link_index = linked_source_circuit.activators.Find(source_link)
					if(source_link_index)
						linked_new_pin = linked_new_circuit.activators[source_link_index]

			if(linked_new_pin)
				target_pin.linked |= linked_new_pin


/proc/ic_copy_clone_value(value)
	if(islist(value))
		var/list/source_list = value
		var/list/new_list = list()

		for(var/entry in source_list)
			var/associated_value = source_list[entry]
			if(!isnull(associated_value))
				new_list[ic_copy_clone_value(entry)] = ic_copy_clone_value(associated_value)
			else
				new_list += list(ic_copy_clone_value(entry))

		return new_list

	return value


/obj/item/integrated_circuit_printer/proc/make_saveable_clone_value(value)
	if(isnull(value) || isnum(value) || istext(value))
		return value

	if(islist(value))
		var/list/source_list = value
		var/list/new_list = list()

		for(var/entry in source_list)
			var/associated_value = source_list[entry]
			if(!isnull(associated_value))
				new_list[make_saveable_clone_value(entry)] = make_saveable_clone_value(associated_value)
			else
				new_list += list(make_saveable_clone_value(entry))

		return new_list

	return null


/obj/item/integrated_circuit_printer/proc/serialize_pin_data_list(list/pins)
	var/list/pin_data = list()

	for(var/datum/integrated_io/pin in pins)
		pin_data += list(make_saveable_clone_value(pin.data))

	return pin_data


/obj/item/integrated_circuit_printer/proc/get_pin_group_name(obj/item/integrated_circuit/circuit, datum/integrated_io/pin)
	if(circuit.inputs.Find(pin))
		return "inputs"

	if(circuit.outputs.Find(pin))
		return "outputs"

	if(circuit.activators.Find(pin))
		return "activators"

	return null


/obj/item/integrated_circuit_printer/proc/get_pin_group_index(obj/item/integrated_circuit/circuit, datum/integrated_io/pin)
	var/index = circuit.inputs.Find(pin)
	if(index)
		return index

	index = circuit.outputs.Find(pin)
	if(index)
		return index

	index = circuit.activators.Find(pin)
	if(index)
		return index

	return 0


/obj/item/integrated_circuit_printer/proc/serialize_pin_links(obj/item/integrated_circuit/source_circuit, datum/integrated_io/source_pin, list/circuit_order)
	var/list/links = list()

	for(var/datum/integrated_io/source_link in source_pin.linked)
		var/obj/item/integrated_circuit/linked_circuit = source_link.holder
		var/linked_circuit_index = circuit_order.Find(linked_circuit)
		if(!linked_circuit_index)
			continue

		var/linked_group = get_pin_group_name(linked_circuit, source_link)
		var/linked_pin_index = get_pin_group_index(linked_circuit, source_link)

		if(!linked_group || !linked_pin_index)
			continue

		links += list(list(
			"circuit" = linked_circuit_index,
			"group" = linked_group,
			"pin" = linked_pin_index
		))

	return links


/obj/item/integrated_circuit_printer/proc/serialize_pin_link_list(obj/item/integrated_circuit/source_circuit, list/pins, list/circuit_order)
	var/list/link_data = list()

	for(var/datum/integrated_io/source_pin in pins)
		link_data += list(serialize_pin_links(source_circuit, source_pin, circuit_order))

	return link_data


/obj/item/integrated_circuit_printer/proc/serialize_clone_blueprint(obj/item/electronic_assembly/source, obj/item/host = null)
	if(!source)
		return null

	var/list/circuit_order = list()

	// Keep removable circuits first so existing blueprint imports retain their old circuit index behavior.
	// Built-in circuits are appended after them so exported JSON still records links to and from built-ins.
	for(var/obj/item/integrated_circuit/source_circuit in source.contents)
		if(!source_circuit.removable)
			continue
		circuit_order += source_circuit

	for(var/obj/item/integrated_circuit/source_circuit in source.contents)
		if(source_circuit.removable)
			continue
		circuit_order += source_circuit

	var/list/circuits = list()

	for(var/obj/item/integrated_circuit/source_circuit in circuit_order)
		var/list/circuit_data = list()
		circuit_data["type"] = "[source_circuit.type]"
		circuit_data["displayed_name"] = source_circuit.displayed_name
		circuit_data["removable"] = source_circuit.removable
		circuit_data["inputs"] = serialize_pin_data_list(source_circuit.inputs)
		circuit_data["outputs"] = serialize_pin_data_list(source_circuit.outputs)
		circuit_data["activators"] = serialize_pin_data_list(source_circuit.activators)
		circuit_data["input_links"] = serialize_pin_link_list(source_circuit, source_circuit.inputs, circuit_order)
		circuit_data["output_links"] = serialize_pin_link_list(source_circuit, source_circuit.outputs, circuit_order)
		circuit_data["activator_links"] = serialize_pin_link_list(source_circuit, source_circuit.activators, circuit_order)

		if(istype(source_circuit, /obj/item/integrated_circuit/memory/constant))
			var/obj/item/integrated_circuit/memory/constant/C = source_circuit
			circuit_data["constant_data"] = make_saveable_clone_value(C.data)

		circuits += list(circuit_data)

	// Serialized assembly data used for import/export cloning.
	var/list/blueprint = list()
	blueprint["assembly_type"] = "[source.type]"
	blueprint["name"] = source.name
	blueprint["detail_color"] = source.detail_color
	blueprint["circuits"] = circuits
	if(istype(host, /obj/item/radio/headset/circuitry))
		var/obj/item/radio/headset/circuitry/headset = host
		var/host_type = headset.get_clone_host_type()
		if(host_type && ispath(host_type, /obj/item))
			blueprint["host_type"] = "[host_type]"

	return blueprint


/obj/item/integrated_circuit_printer/proc/apply_blueprint_pin_data(list/source_data, list/target_pins)
	if(!source_data || !target_pins)
		return

	var/pin_count = min(source_data.len, target_pins.len)

	for(var/i = 1 to pin_count)
		var/datum/integrated_io/target_pin = target_pins[i]
		target_pin.write_data_to_pin(source_data[i])


/obj/item/integrated_circuit_printer/proc/get_blueprint_pin(obj/item/integrated_circuit/circuit, group, pin_index)
	if(!circuit || !group || !pin_index)
		return null

	if(group == "inputs")
		if(pin_index <= circuit.inputs.len)
			return circuit.inputs[pin_index]

	if(group == "outputs")
		if(pin_index <= circuit.outputs.len)
			return circuit.outputs[pin_index]

	if(group == "activators")
		if(pin_index <= circuit.activators.len)
			return circuit.activators[pin_index]

	return null


/obj/item/integrated_circuit_printer/proc/apply_blueprint_links(list/source_link_data, list/source_pins, list/new_circuits)
	if(!source_link_data || !source_pins || !new_circuits)
		return

	var/pin_count = min(source_link_data.len, source_pins.len)

	for(var/i = 1 to pin_count)
		var/datum/integrated_io/source_pin = source_pins[i]
		var/list/links = source_link_data[i]

		if(!links)
			continue

		for(var/list/link_data in links)
			var/linked_circuit_index = link_data["circuit"]
			var/linked_group = link_data["group"]
			var/linked_pin_index = link_data["pin"]

			if(!linked_circuit_index || linked_circuit_index > new_circuits.len)
				continue

			var/obj/item/integrated_circuit/linked_circuit = new_circuits[linked_circuit_index]
			var/datum/integrated_io/linked_pin = get_blueprint_pin(linked_circuit, linked_group, linked_pin_index)

			if(linked_pin)
				source_pin.linked |= linked_pin


/obj/item/integrated_circuit_printer/proc/find_matching_blueprint_builtin(obj/item/electronic_assembly/clone, circuit_path, list/used_builtins)
	if(!clone || !circuit_path)
		return null

	for(var/obj/item/integrated_circuit/clone_circuit in clone.contents)
		if(clone_circuit.removable)
			continue

		if(clone_circuit.type != circuit_path)
			continue

		if(used_builtins.Find(clone_circuit))
			continue

		used_builtins += clone_circuit
		return clone_circuit

	return null


/obj/item/integrated_circuit_printer/proc/copy_assembly_into_existing_from_blueprint(list/blueprint, obj/item/electronic_assembly/clone)
	if(!blueprint || !clone)
		return FALSE

	clone.name = blueprint["name"]
	clone.detail_color = blueprint["detail_color"]
	clone.opened = FALSE
	clone.update_icon()

	var/list/new_circuits = list()
	var/list/used_builtins = list()
	var/list/circuit_blueprints = blueprint["circuits"]

	// Build an index-aligned list that mirrors the blueprint circuit order.
	// Removable circuits are newly printed. Built-in circuits are mapped to the
	// clone assembly's existing non-removable circuits so links to built-ins survive.
	for(var/list/circuit_data in circuit_blueprints)
		var/circuit_path = text2path(circuit_data["type"])

		if(!circuit_path || !ispath(circuit_path, /obj/item/integrated_circuit))
			new_circuits += null
			continue

		var/obj/item/integrated_circuit/new_circuit = null

		if(circuit_data["removable"])
			new_circuit = new circuit_path(clone)
			new_circuit.displayed_name = circuit_data["displayed_name"]
			new_circuit.removable = circuit_data["removable"]
			new_circuit.assembly = clone
			clone.force_add_circuit(new_circuit)
		else
			new_circuit = find_matching_blueprint_builtin(clone, circuit_path, used_builtins)

		if(new_circuit)
			apply_blueprint_pin_data(circuit_data["inputs"], new_circuit.inputs)
			apply_blueprint_pin_data(circuit_data["outputs"], new_circuit.outputs)
			apply_blueprint_pin_data(circuit_data["activators"], new_circuit.activators)

			if(istype(new_circuit, /obj/item/integrated_circuit/memory/constant))
				var/obj/item/integrated_circuit/memory/constant/C = new_circuit
				C.data = circuit_data["constant_data"]
				C.accepting_refs = FALSE

		new_circuits += new_circuit

	// Apply links by blueprint index. Because new_circuits is index-aligned,
	// links to removable circuits and built-in circuits both resolve correctly.
	for(var/i = 1 to circuit_blueprints.len)
		var/list/circuit_data = circuit_blueprints[i]
		var/obj/item/integrated_circuit/new_circuit = new_circuits[i]

		if(!new_circuit)
			continue

		apply_blueprint_links(circuit_data["input_links"], new_circuit.inputs, new_circuits)
		apply_blueprint_links(circuit_data["output_links"], new_circuit.outputs, new_circuits)
		apply_blueprint_links(circuit_data["activator_links"], new_circuit.activators, new_circuits)

	return TRUE

/obj/item/integrated_circuit_printer/proc/clone_assembly_from_blueprint(list/blueprint, atom/location)
	if(!blueprint || !location)
		return null

	var/assembly_path = text2path(blueprint["assembly_type"])
	if(!assembly_path || !ispath(assembly_path, /obj/item/electronic_assembly))
		return null

	var/host_path = text2path(blueprint["host_type"])
	if(host_path && ispath(host_path, /obj/item))
		// Some host items, such as circuitry headsets, need their own clone helper to
		// create and attach the internal assembly correctly. A raw new host may not
		// have a cloneable assembly available yet, which caused imported headset
		// blueprints to decode successfully but fail at print completion.
		if(ispath(host_path, /obj/item/radio/headset/circuitry))
			var/obj/item/radio/headset/circuitry/source_headset = new host_path(src)
			var/obj/item/electronic_assembly/source_assembly = new assembly_path(src, TRUE)

			if(copy_assembly_into_existing_from_blueprint(blueprint, source_assembly))
				var/obj/item/cloned_host = source_headset.clone_with_integrated_assembly(location, src, source_assembly)
				qdel(source_assembly)
				qdel(source_headset)
				return cloned_host

			qdel(source_assembly)
			qdel(source_headset)
			return null

		var/obj/item/host = new host_path(location)

		if(istype(host, /obj/item/radio/headset/circuitry))
			var/obj/item/radio/headset/circuitry/headset = host
			var/obj/item/electronic_assembly/host_assembly = headset.get_cloneable_assembly()
			if(istype(host_assembly))
				if(copy_assembly_into_existing_from_blueprint(blueprint, host_assembly))
					return host

		qdel(host)
		return null

	var/obj/item/electronic_assembly/clone = new assembly_path(location, TRUE)

	if(!copy_assembly_into_existing_from_blueprint(blueprint, clone))
		qdel(clone)
		return null

	return clone


/obj/item/integrated_circuit_printer/proc/get_clone_blueprint_metal_cost(list/blueprint)
	if(!blueprint)
		return 0

	var/assembly_path = text2path(blueprint["assembly_type"])
	if(!assembly_path || !ispath(assembly_path, /obj/item/electronic_assembly))
		return 0

	var/obj/item/electronic_assembly/E = assembly_path
	var/case_cost = round((initial(E.max_complexity) + initial(E.max_components)) / 4)

	var/component_cost = 0
	var/list/circuit_blueprints = blueprint["circuits"]
	if(!islist(circuit_blueprints))
		return 0

	for(var/list/circuit_data in circuit_blueprints)
		if(!islist(circuit_data))
			continue
		if(!circuit_data["removable"])
			continue

		var/circuit_path = text2path(circuit_data["type"])
		if(!circuit_path || !ispath(circuit_path, /obj/item/integrated_circuit))
			continue

		var/obj/item/integrated_circuit/IC = circuit_path
		component_cost += max(1, initial(IC.w_class))

	return max(1, case_cost + component_cost)


/obj/item/integrated_circuit_printer/proc/get_clone_blueprint_phoron_cost(list/blueprint)
	if(!blueprint)
		return 0

	var/component_cost = 0
	var/list/circuit_blueprints = blueprint["circuits"]
	if(!islist(circuit_blueprints))
		return 0

	for(var/list/circuit_data in circuit_blueprints)
		if(!islist(circuit_data))
			continue
		if(!circuit_data["removable"])
			continue

		var/circuit_path = text2path(circuit_data["type"])
		if(!circuit_path || !ispath(circuit_path, /obj/item/integrated_circuit))
			continue

		component_cost += get_circuit_phoron_cost(circuit_path)

	return component_cost


/obj/item/integrated_circuit_printer/proc/get_clone_blueprint_print_time(list/blueprint)
	if(!blueprint)
		return clone_min_print_time

	var/cost = get_clone_blueprint_metal_cost(blueprint)
	var/effective_max_cost = max(1, max_metal)
	var/cost_ratio = cost / effective_max_cost

	if(cost_ratio < 0)
		cost_ratio = 0
	if(cost_ratio > 1)
		cost_ratio = 1

	var/scaled_time = clone_min_print_time + ((clone_max_print_time - clone_min_print_time) * cost_ratio)

	if(scaled_time < clone_min_print_time)
		scaled_time = clone_min_print_time
	if(scaled_time > clone_max_print_time)
		scaled_time = clone_max_print_time

	return round(scaled_time)


/obj/item/integrated_circuit/proc/copy_clone_state_to(obj/item/integrated_circuit/target)
	return


/obj/item/integrated_circuit/memory/constant/copy_clone_state_to(obj/item/integrated_circuit/target)
	var/obj/item/integrated_circuit/memory/constant/new_constant = target
	if(!istype(new_constant))
		return

	if(islist(data))
		new_constant.data = ic_copy_clone_value(data)
	else
		new_constant.data = data

	new_constant.accepting_refs = FALSE


/obj/item/integrated_circuit_printer/proc/can_print(build_type)
	var/list/recipes = upgraded ? SSelectronics.printer_recipe_list_upgraded : SSelectronics.printer_recipe_list_basic
	var/build_path = "[build_type]"

	for(var/list/recipe in recipes)
		if(recipe["path"] == build_path)
			return TRUE

	return FALSE


/obj/item/integrated_circuit_printer/proc/is_printed_assembly_container_type(build_type)
	return ispath(build_type, /obj/item/electronic_assembly) \
		|| ispath(build_type, /obj/item/implant/integrated_circuit) \
		|| ispath(build_type, /obj/item/clothing/under/circuitry) \
		|| ispath(build_type, /obj/item/clothing/gloves/circuitry) \
		|| ispath(build_type, /obj/item/clothing/glasses/circuitry) \
		|| ispath(build_type, /obj/item/clothing/shoes/circuitry) \
		|| ispath(build_type, /obj/item/clothing/head/circuitry) \
		|| ispath(build_type, /obj/item/clothing/ears/circuitry) \
		|| ispath(build_type, /obj/item/radio/headset/circuitry) \
		|| ispath(build_type, /obj/item/clothing/suit/circuitry)


/obj/item/disk/integrated_circuit/upgrade
	name = "integrated circuit printer upgrade disk"
	desc = "Install this into your integrated circuit printer to enhance it."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "upgrade_disk"
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)


/obj/item/disk/integrated_circuit/upgrade/advanced
	name = "integrated circuit printer upgrade disk - advanced designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, advanced designs to the printer."


/obj/item/disk/integrated_circuit/upgrade/clone
	name = "integrated circuit printer upgrade disk - circuit cloner"
	desc = "Install this into your integrated circuit printer to enhance it.  This one allows the printer to duplicate assemblies."
	icon_state = "upgrade_disk_clone"
	origin_tech = list(TECH_ENGINEERING = 5, TECH_DATA = 6)
