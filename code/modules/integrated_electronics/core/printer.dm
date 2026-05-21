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
	data["clone_cost"] = assembly_to_clone ? round(get_clone_metal_cost(assembly_to_clone) / metal_per_sheet, 0.1) : clone_blueprint_data ? round(get_clone_blueprint_metal_cost(clone_blueprint_data) / metal_per_sheet, 0.1) : 0
	data["clone_phoron_cost"] = assembly_to_clone ? round(get_clone_phoron_cost(assembly_to_clone) / phoron_per_sheet, 0.01) : clone_blueprint_data ? round(get_clone_blueprint_phoron_cost(clone_blueprint_data) / phoron_per_sheet, 0.01) : 0
	data["clone_print_time"] = assembly_to_clone ? round(get_clone_print_time(assembly_to_clone) / 10, 0.1) : clone_blueprint_data ? round(get_clone_blueprint_print_time(clone_blueprint_data) / 10, 0.1) : 0
	data["currently_printing"] = currently_printing
	data["has_clone_blueprint"] = clone_blueprint_data ? TRUE : FALSE

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

	if(hascall(target, "get_cloneable_assembly"))
		var/obj/item/electronic_assembly/E = call(target, "get_cloneable_assembly")()
		if(istype(E))
			return E

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
	clone_blueprint_export = null

	to_chat(user, SPAN_NOTICE("You scan \the [target] into \the [src]'s cloning buffer."))
	return TRUE

/obj/item/integrated_circuit_printer/proc/import_clone_blueprint_text(var/import_text, var/mob/user)
	if(!import_text)
		return FALSE

	import_text = html_decode(import_text)

	var/start_index = findtext(import_text, "{")
	var/end_index = findlasttext(import_text, "}")

	if(start_index && end_index && end_index >= start_index)
		import_text = copytext(import_text, start_index, end_index + 1)

	var/list/imported_blueprint = json_decode(import_text)
	if(!islist(imported_blueprint))
		to_chat(user, SPAN_WARNING("That cloning blueprint text is invalid."))
		return FALSE

	var/assembly_path = text2path(imported_blueprint["assembly_type"])
	if(!assembly_path || !ispath(assembly_path, /obj/item/electronic_assembly))
		to_chat(user, SPAN_WARNING("That cloning blueprint does not contain a valid assembly type."))
		return FALSE

	clone_blueprint_data = imported_blueprint
	clone_blueprint_name = clone_blueprint_data["name"]
	clone_blueprint_export = import_text
	assembly_to_clone = null
	clone_item_to_clone = null

	to_chat(user, SPAN_NOTICE("You import the cloning blueprint: [clone_blueprint_name]."))
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
		return TRUE

	if(action == "export_clone")
		if(!can_clone)
			to_chat(usr, SPAN_WARNING("\The [src] needs a circuit cloner upgrade for that."))
			return FALSE

		if(!assembly_to_clone || QDELETED(assembly_to_clone))
			assembly_to_clone = null
			clone_item_to_clone = null
			to_chat(usr, SPAN_WARNING("There is no valid scanned assembly to export."))
			return FALSE

		clone_blueprint_data = serialize_clone_blueprint(assembly_to_clone)
		if(!clone_blueprint_data)
			to_chat(usr, SPAN_WARNING("The scanned assembly could not be exported."))
			return FALSE

		clone_blueprint_name = clone_blueprint_data["name"]
		clone_blueprint_export = json_encode(clone_blueprint_data)

		usr << browse("<html><body><textarea style='width: 100%; height: 95%; font-family: monospace;'>[html_encode(clone_blueprint_export)]</textarea></body></html>", "window=circuit_clone_export;size=900x600")
		to_chat(usr, SPAN_NOTICE("You export \the [assembly_to_clone] as copyable cloning blueprint text."))
		return TRUE

	if(action == "import_clone")
		if(!can_clone)
			to_chat(usr, SPAN_WARNING("\The [src] needs a circuit cloner upgrade for that."))
			return FALSE

		var/import_text = input(usr, "Paste circuit cloning blueprint text:", "Import Circuit Blueprint") as message|null
		if(!import_text)
			return FALSE

		return import_clone_blueprint_text(import_text, usr)

	if(action == "clear_import_buffer")
		clone_blueprint_import_buffer = ""
		to_chat(usr, SPAN_NOTICE("You clear the cloning blueprint import buffer."))
		return TRUE

	if(action == "append_import_chunk")
		if(!can_clone)
			to_chat(usr, SPAN_WARNING("\The [src] needs a circuit cloner upgrade for that."))
			return FALSE

		var/import_chunk = input(usr, "Paste the next cloning blueprint chunk:", "Append Blueprint Chunk") as message|null
		if(!import_chunk)
			return FALSE

		import_chunk = html_decode(import_chunk)
		clone_blueprint_import_buffer += import_chunk

		to_chat(usr, SPAN_NOTICE("You append [length(import_chunk)] character\s to the cloning blueprint import buffer. Buffer length: [length(clone_blueprint_import_buffer)]."))
		return TRUE

	if(action == "import_buffered_clone")
		if(!can_clone)
			to_chat(usr, SPAN_WARNING("\The [src] needs a circuit cloner upgrade for that."))
			return FALSE

		if(!clone_blueprint_import_buffer)
			to_chat(usr, SPAN_WARNING("The cloning blueprint import buffer is empty."))
			return FALSE

		return import_clone_blueprint_text(clone_blueprint_import_buffer, usr)

	if(action == "clear_imported_clone")
		clone_blueprint_data = null
		clone_blueprint_name = null
		clone_blueprint_export = null
		clone_blueprint_import_buffer = ""
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
		var/list/blueprint_to_print = null

		if(assembly_to_clone && !QDELETED(assembly_to_clone))
			live_scan_to_print = assembly_to_clone
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
			cost = get_clone_blueprint_metal_cost(blueprint_to_print)
			phoron_cost = get_clone_blueprint_phoron_cost(blueprint_to_print)
			print_time = get_clone_blueprint_print_time(blueprint_to_print)

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
			finish_clone_print(printing_user, cost, phoron_cost, live_scan_to_print, blueprint_to_print)

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
		var/is_asm = FALSE

		if(ispath(build_type, /obj/item/electronic_assembly))
			var/obj/item/electronic_assembly/E = build_type
			cost = round((initial(E.max_complexity) + initial(E.max_components)) / 4)
			is_asm = TRUE
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

		if(is_asm)
			new build_type(get_turf(loc), TRUE)
		else
			new build_type(get_turf(loc))

		return TRUE

	return FALSE


/obj/item/integrated_circuit_printer/proc/finish_clone_print(mob/user, cost, phoron_cost, obj/item/electronic_assembly/live_scan_to_print, list/blueprint_to_print)
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

	var/obj/item/electronic_assembly/new_clone = null

	if(live_scan_to_print && !QDELETED(live_scan_to_print))
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

	if(islist(source_pin.data))
		var/list/source_list = source_pin.data
		target_pin.write_data_to_pin(source_list.Copy())
	else
		target_pin.write_data_to_pin(source_pin.data)


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


/obj/item/integrated_circuit_printer/proc/make_saveable_clone_value(value)
	if(isnull(value) || isnum(value) || istext(value))
		return value

	if(islist(value))
		var/list/source_list = value
		var/list/new_list = list()

		for(var/entry in source_list)
			new_list += make_saveable_clone_value(entry)

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


/obj/item/integrated_circuit_printer/proc/serialize_clone_blueprint(obj/item/electronic_assembly/source)
	if(!source)
		return null

	var/list/circuit_order = list()

	for(var/obj/item/integrated_circuit/source_circuit in source.contents)
		if(!source_circuit.removable)
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

	var/list/blueprint = list()
	blueprint["assembly_type"] = "[source.type]"
	blueprint["name"] = source.name
	blueprint["detail_color"] = source.detail_color
	blueprint["circuits"] = circuits

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


/obj/item/integrated_circuit_printer/proc/copy_assembly_into_existing_from_blueprint(list/blueprint, obj/item/electronic_assembly/clone)
	if(!blueprint || !clone)
		return FALSE

	clone.name = blueprint["name"]
	clone.detail_color = blueprint["detail_color"]
	clone.opened = FALSE
	clone.update_icon()

	var/list/new_circuits = list()
	var/list/circuit_blueprints = blueprint["circuits"]

	for(var/list/circuit_data in circuit_blueprints)
		if(!circuit_data["removable"])
			continue

		var/circuit_path = text2path(circuit_data["type"])
		if(!circuit_path || !ispath(circuit_path, /obj/item/integrated_circuit))
			continue

		var/obj/item/integrated_circuit/new_circuit = new circuit_path(clone)
		new_circuit.displayed_name = circuit_data["displayed_name"]
		new_circuit.removable = circuit_data["removable"]
		new_circuit.assembly = clone
		clone.force_add_circuit(new_circuit)

		apply_blueprint_pin_data(circuit_data["inputs"], new_circuit.inputs)
		apply_blueprint_pin_data(circuit_data["outputs"], new_circuit.outputs)
		apply_blueprint_pin_data(circuit_data["activators"], new_circuit.activators)

		if(istype(new_circuit, /obj/item/integrated_circuit/memory/constant))
			var/obj/item/integrated_circuit/memory/constant/C = new_circuit
			C.data = circuit_data["constant_data"]
			C.accepting_refs = FALSE

		new_circuits += new_circuit

	for(var/i = 1 to circuit_blueprints.len)
		if(i > new_circuits.len)
			continue

		var/list/circuit_data = circuit_blueprints[i]
		if(!circuit_data["removable"])
			continue

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

	var/host_path = text2path(blueprint["host_type"])
	if(host_path && ispath(host_path, /obj/item))
		var/obj/item/host = new host_path(location)

		if(hascall(host, "get_cloneable_assembly"))
			var/obj/item/electronic_assembly/host_assembly = call(host, "get_cloneable_assembly")()
			if(istype(host_assembly))
				if(copy_assembly_into_existing_from_blueprint(blueprint, host_assembly))
					return host

		qdel(host)
		return null

	var/assembly_path = text2path(blueprint["assembly_type"])
	if(!assembly_path || !ispath(assembly_path, /obj/item/electronic_assembly))
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

	for(var/list/circuit_data in circuit_blueprints)
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

	for(var/list/circuit_data in circuit_blueprints)
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
		var/list/source_list = data
		new_constant.data = source_list.Copy()
	else
		new_constant.data = data

	new_constant.accepting_refs = FALSE


/obj/item/integrated_circuit_printer/proc/can_print(build_type)
	for(var/category in SSelectronics.printer_recipe_list)
		var/list/current_list = SSelectronics.printer_recipe_list[category]

		for(var/obj/O in current_list)
			if(O.type == build_type)
				return TRUE

	return FALSE


// FUKKEN UPGRADE DISKS
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
