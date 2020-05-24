// Helpers for saving/loading integrated circuits.

// Maximum possible JSON values for different assembly elements, with maths
// ====Assembly:====
// Max assembly name: MAX_NAME_LEN chars
// Max assembly description: MAX_MESSAGE_LEN chars
// Max detail color: 9 chars ("#123456")
// Max special info (mathed from memory component and clothing/implant): 
//  17 ({"type":,"name":}) + IC_MAX_TYPE_LEN + MAX_NAME_LEN chars
// Max JSON metadata: 52 chars ({"type":,"name":,"desc":,"detail_color":,"special":})
// "type" field length
// (40 max for assemblies + 2 for quotes + wiggle room, just in case. Arbitrary for components)
#define IC_MAX_TYPE_LEN 50 
#define IC_MAX_COLOR_LEN 9
#define IC_MAX_ASSEMBLY_SPECIAL (17 + IC_MAX_TYPE_LEN + MAX_NAME_LEN)
#define IC_MAX_ASSEMBLY_METADATA 52
#define IC_MAX_ASSEMBLY_LEN (MAX_NAME_LEN + IC_MAX_TYPE_LEN + MAX_MESSAGE_LEN + IC_MAX_COLOR_LEN + IC_MAX_ASSEMBLY_SPECIAL + IC_MAX_ASSEMBLY_METADATA)

// ====Component:====
// Max type len: IC_MAX_TYPE_LEN chars
// Max component name: MAX_NAME_LEN chars
// Max special len: IC_MAX_MEMORY_LEN chars
// Max JSON metadata: 49 chars = 40 ({"name":,"type":,"inputs":[],"special":}) + 9 (commas for inputs, brackets included in input metadata)
// Max single input len: 7 + IC_MAX_MEMORY_LEN chars 
// ([xx,y,IC_MAX_MEMORY_LEN], double digit index in case we get such inputs)
// Max inputs: 10 (8 as the most + 2 for wiggle room)
#define IC_MAX_INPUT_LEN (7 + IC_MAX_MEMORY_LEN)
#define IC_MAX_COMPONENT_METADATA 49
#define IC_MAX_INPUTS 10
#define IC_MAX_COMPONENT_LEN (MAX_NAME_LEN + IC_MAX_TYPE_LEN + IC_MAX_MEMORY_LEN + IC_MAX_COMPONENT_METADATA + IC_MAX_INPUT_LEN * IC_MAX_INPUTS)

// ====Wire tuple:====
// {"x":[xxx,y,zzz],"y":[xxx,y,zzz]} = 33 chars (triple digits, some cases MAYBE MIGHT allow this)
#define IC_MAX_WIRE_LEN 33

// Saves type, modified name and modified inputs (if any) to a list
// The list is converted to JSON down the line.
//"Special" is not verified at any point except for by the circuit itself.
/obj/item/integrated_circuit/proc/save()
	var/list/component_params = list()
	var/init_name = initial(name)

	// Save initial name used for differentiating assemblies
	component_params["type"] = init_name

	// Save the modified name.
	if(init_name != displayed_name)
		component_params["name"] = displayed_name

	// Saving input values
	if(length(inputs))
		var/list/saved_inputs = list()

		for(var/index in 1 to inputs.len)
			var/datum/integrated_io/input = inputs[index]

			// Don't waste space saving the default values
			if(input.data == initial(input.data))
				continue

			var/list/input_value = list(index, FALSE, input.data)
			// Index, Type, Value
			// FALSE is default type used for num/text/list/null
			// TODO: support for special input types, such as internal refs and maybe typepaths

			if(islist(input.data) || isnum(input.data) || istext(input.data) || isnull(input.data))
				saved_inputs.Add(list(input_value))

		if(saved_inputs.len)
			component_params["inputs"] = saved_inputs

	var/special = save_special()
	if(!isnull(special))
		component_params["special"] = special

	return component_params

/obj/item/integrated_circuit/proc/save_special()
	return

// Verifies a list of component parameters
// Returns null on success, error name on failure
/obj/item/integrated_circuit/proc/verify_save(list/component_params)
	var/init_name = initial(name)
	// Validate name
	if(sanitizeName(component_params["name"]) != component_params["name"])
		return "Bad component name"
	// Validate input values
	if(component_params["inputs"])
		var/list/loaded_inputs = component_params["inputs"]
		if(!islist(loaded_inputs))
			return "Malformed input values list at [init_name]."

		var/inputs_amt = length(inputs)

		// Too many inputs? Inputs for input-less component? This is not good.
		if(!inputs_amt || inputs_amt < length(loaded_inputs))
			return "Input values list out of bounds at [init_name]."

		for(var/list/input in loaded_inputs)
			if(input.len != 3)
				return "Malformed input data at [init_name]."

			var/input_id = input[1]
			var/input_type = input[2]
			//var/input_value = input[3]

			// No special type support yet.
			if(input_type)
				return "Unidentified input type at [init_name]!"
			// TODO: support for special input types, such as typepaths and internal refs

			// Input ID is a list index, make sure it's sane.
			if(!isnum(input_id) || input_id % 1 || input_id > inputs_amt || input_id < 1)
				return "Invalid input index at [init_name]."


// Loads component parameters from a list
// Doesn't verify any of the parameters it loads, this is the job of verify_save()
/obj/item/integrated_circuit/proc/load(list/component_params)
	// Load name
	if(component_params["name"])
		displayed_name = component_params["name"]

	// Load input values
	if(component_params["inputs"])
		var/list/loaded_inputs = component_params["inputs"]

		for(var/list/input in loaded_inputs)
			var/index = input[1]
			//var/input_type = input[2]
			var/input_value = input[3]

			var/datum/integrated_io/pin = inputs[index]
			// The pins themselves validate the data.
			pin.write_data_to_pin(input_value)
			// TODO: support for special input types, such as internal refs and maybe typepaths

	if(!isnull(component_params["special"]))
		load_special(component_params["special"])

/obj/item/integrated_circuit/proc/load_special(special_data)
	return

// Saves type and modified name (if any) to a list
// The list is converted to JSON down the line.
/obj/item/device/electronic_assembly/proc/save()
	var/list/assembly_params = list()

	// Save initial name used for differentiating assemblies
	assembly_params["type"] = initial(name)

	// Save modified name
	if(initial(name) != name)
		assembly_params["name"] = name

	// Save modified description
	if(initial(desc) != desc)
		assembly_params["desc"] = desc

	// Save modified color
	if(initial(detail_color) != detail_color)
		assembly_params["detail_color"] = detail_color

	var/special = save_special()
	if(!isnull(special))
		assembly_params["special"] = special

	return assembly_params

/obj/item/device/electronic_assembly/proc/save_special()
	return null

// Verifies a list of assembly parameters
// Returns null on success, error name on failure
/obj/item/device/electronic_assembly/proc/verify_save(list/assembly_params)
	// Sanitize name and description, verify color
	if(assembly_params["name"])
		assembly_params["name"] = sanitizeName(assembly_params["name"])
	if(assembly_params["desc"])
		assembly_params["desc"] = sanitize(assembly_params["desc"])
	if(assembly_params["detail_color"] && !(assembly_params["detail_color"] in color_whitelist))
		return "Bad assembly color."

// Loads assembly parameters from a list
// Doesn't verify any of the parameters it loads, this is the job of verify_save()
/obj/item/device/electronic_assembly/proc/load(list/assembly_params)
	// Load modified name, if any.
	if(assembly_params["name"])
		name = assembly_params["name"]

	// Load modified description, if any.
	if(assembly_params["desc"])
		desc = assembly_params["desc"]

	if(assembly_params["detail_color"])
		detail_color = assembly_params["detail_color"]

	if(!isnull(assembly_params["special"]))
		load_special(assembly_params["special"])

	update_icon()

/obj/item/device/electronic_assembly/proc/load_special(special_data)
	return


// Attempts to save an assembly into a save file format.
// Returns null if assembly is not complete enough to be saved.
/datum/controller/subsystem/processing/electronics/proc/save_electronic_assembly(obj/item/device/electronic_assembly/assembly)
	// No components? Don't even try to save it.
	if(!length(assembly.assembly_components))
		return


	var/list/blocks = list()

	// Block 1. Assembly.
	blocks["assembly"] = assembly.save()
	// (implant assemblies are not yet supported)


	// Block 2. Components.
	var/list/components = list()
	for(var/c in assembly.assembly_components)
		var/obj/item/integrated_circuit/component = c
		components.Add(list(component.save()))
		CHECK_TICK
	blocks["components"] = components


	// Block 3. Wires.
	var/list/wires = list()
	var/list/saved_wires = list()

	for(var/c in assembly.assembly_components)
		var/obj/item/integrated_circuit/component = c
		var/list/all_pins = list()
		for(var/l in list(component.inputs, component.outputs, component.activators))
			if(l) //If it isn't null
				all_pins += l

		for(var/p in all_pins)
			var/datum/integrated_io/pin = p
			var/list/params = pin.get_pin_parameters()
			var/text_params = params.Join()

			for(var/p2 in pin.linked)
				var/datum/integrated_io/pin2 = p2
				var/list/params2 = pin2.get_pin_parameters()
				var/text_params2 = params2.Join()

				// Check if we already saved an opposite version of this wire
				// (do not save the same wire twice)
				if((text_params2 + "=" + text_params) in saved_wires)
					continue

				// If not, add a wire "hash" for future checks and save it
				saved_wires.Add(text_params + "=" + text_params2)
				// The wires are saved as tuples, so they can be sent over the loading UI
				wires.Add(list(list("x" = params, "y" = params2)))

				// There MIGHT be a lot of processing, so let's just slow it down if need be
				CHECK_TICK

	if(wires.len)
		blocks["wires"] = wires

	return json_encode(blocks)



// Checks assembly save and calculates some of the parameters.
// Returns assembly (type: list) if the save is valid.
// Returns error code (type: text) if loading has failed.
// The following parameters area calculated during validation and added to the returned save list:
// "requires_upgrades", "unsupported_circuit", "cost", "complexity", "max_complexity", "used_space", "max_space"
/datum/controller/subsystem/processing/electronics/proc/validate_electronic_assembly(assembly_info, components_info, wires_info)
	var/error
	var/list/blocks = list()

	if(isnull(assembly_info))
		return "No assembly provided."
	if(isnull(components_info) && !isnull(wires_info))
		// Can possibly happen in the future, so a safeguard here
		return "Malformed component input."

	// Block 1. Assembly.
	if(length(assembly_info) > IC_MAX_ASSEMBLY_LEN)
		return "Assembly code too large."
	var/list/assembly_params = json_decode(assembly_info)

	if(!islist(assembly_params) || !length(assembly_params))
		return "Invalid assembly data."	// No assembly, damaged assembly or empty assembly

	// Validate type, get a temporary component
	// TODO: Check for invalid path from params here
	var/assembly_path = all_assemblies[assembly_params["type"]]
	var/obj/item/device/electronic_assembly/assembly = cached_assemblies[assembly_path]
	if(!assembly)
		return "Invalid assembly type."

	// Check assembly save data for errors
	error = assembly.verify_save(assembly_params)
	if(error)
		return error

	// Read space & complexity limits and start keeping track of them
	blocks["complexity"] = 0
	blocks["max_complexity"] = assembly.max_complexity
	blocks["used_space"] = 0
	blocks["max_space"] = assembly.max_components

	// Start keeping track of total metal cost
	blocks["cost"] = assembly.matter.Copy()

	// Add the assembly info back
	blocks["assembly"] = assembly_params

	// Block 2. Components.
	if(!islist(components_info) || !length(components_info))
		return "Invalid components list."	// No components or damaged components list

	var/list/contents = list()
	blocks["components"] = list()
	for(var/C in components_info)
		if(length(C) > IC_MAX_COMPONENT_LEN)
			return "Malformed component info."
		var/list/component_params = json_decode(C)

		if(!islist(component_params) || !length(component_params))
			return "Invalid component data."

		// Validate type, get a temporary component
		var/component_path = all_integrated_circuits[component_params["type"]]
		var/obj/item/integrated_circuit/component = cached_circuits[component_path]
		if(!component)
			return "Invalid component type."

		// Add temporary component to contents list, to be used later when verifying the wires
		contents.Add(component)

		// Check component save data for errors
		error = component.verify_save(component_params)
		if(error)
			return error

		// Update estimated assembly complexity, taken space and material cost
		blocks["complexity"] += component.complexity
		blocks["used_space"] += component.size

		// NOTE: There are _currently_ no components that reduce complexity or used_space
		// So the check is taken here
		// Check complexity and space limitations
		if(blocks["used_space"] > blocks["max_space"])
			return "Used space overflow."
		if(blocks["complexity"] > blocks["max_complexity"])
			return "Complexity overflow."

		for(var/material in component.matter)
			blocks["cost"][material] += component.matter[material]

		// Check if the assembly requires printer upgrades
		if(!(component.spawn_flags & IC_SPAWN_DEFAULT))
			blocks["requires_upgrades"] = TRUE

		// Check if the assembly supports the circucit
		if((component.action_flags & assembly.allowed_circuit_action_flags) != component.action_flags)
			blocks["unsupported_circuit"] = TRUE

		blocks["components"].Add(list(component_params))

		// Not sure if this is needed here, since we don't have much processing/many items.
		// Better safe than sorry.
		CHECK_TICK


	// Block 3. Wires.
	if(wires_info)
		if(!islist(wires_info))
			return "Invalid wiring list."	// Damaged wires list

		blocks["wires"] = list()

		for(var/w in wires_info)
			if(length(w) > IC_MAX_WIRE_LEN)
				return "Malformed wire tuple."
			var/list/wire = json_decode(w)
			blocks["wires"].Add(list(wire))

			if(!islist(wire) || wire.len != 2)
				return "Invalid wire data list."

			var/datum/integrated_io/IO = assembly.get_pin_ref_list(wire["x"], contents)
			var/datum/integrated_io/IO2 = assembly.get_pin_ref_list(wire["y"], contents)
			if(!IO || !IO2)
				return "Invalid wire data."

			if(initial(IO.io_type) != initial(IO2.io_type))
				return "Wire type mismatch."

			CHECK_TICK

	return blocks


// Loads assembly (in form of list) into an object and returns it.
// No sanity checks are performed, save file is expected to be validated by validate_electronic_assembly
/datum/controller/subsystem/processing/electronics/proc/load_electronic_assembly(loc, list/blocks)

	// Block 1. Assembly.
	var/list/assembly_params = blocks["assembly"]
	var/obj/item/device/electronic_assembly/assembly_path = all_assemblies[assembly_params["type"]]
	var/obj/item/device/electronic_assembly/assembly = new assembly_path(null)
	assembly.load(assembly_params)



	// Block 2. Components.
	for(var/component_params in blocks["components"])
		var/obj/item/integrated_circuit/component_path = all_integrated_circuits[component_params["type"]]
		var/obj/item/integrated_circuit/component = new component_path(assembly)
		assembly.add_component(component)
		component.load(component_params)

		CHECK_TICK


	// Block 3. Wires.
	if(blocks["wires"])
		for(var/w in blocks["wires"])
			var/list/wire = w
			var/datum/integrated_io/IO = assembly.get_pin_ref_list(wire["x"])
			var/datum/integrated_io/IO2 = assembly.get_pin_ref_list(wire["y"])
			IO.connect_pin(IO2)

			CHECK_TICK

	assembly.forceMove(loc)
	assembly.post_load()
	return assembly
	