/obj/item/integrated_circuit/proc/setup_io(list/io_list, io_type, list/io_default_list)
	var/list/io_list_copy = io_list.Copy()
	io_list.Cut()
	var/i = 0
	for(var/io_entry in io_list_copy)
		var/default_data = null
		var/io_type_override = null
		// Override the default data.
		if(LAZYLEN(io_default_list)) // List containing special pin types that need to be added.
			default_data = io_default_list["[i]"] // This is deliberately text because the index is a number in text form.

		// Override the pin type.
		if(io_list_copy[io_entry])
			io_type_override = io_list_copy[io_entry]

		if(io_type_override)
			io_list += new io_type_override(src, io_entry, default_data)
		else
			io_list += new io_type(src, io_entry, default_data)

/obj/item/integrated_circuit/proc/set_pin_data(pin_type, pin_number, datum/new_data)
	if (istype(new_data) && !isweakref(new_data))
		new_data = WEAKREF(new_data)

	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	if (!pin)
		CRASH("Invalid pin ref.")
	return pin.write_data_to_pin(new_data)

/obj/item/integrated_circuit/proc/get_pin_data(pin_type, pin_number)
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	return pin.get_data()

/obj/item/integrated_circuit/proc/get_pin_data_as_type(pin_type, pin_number, as_type)
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	return pin.data_as_type(as_type)

/obj/item/integrated_circuit/proc/activate_pin(pin_number)
	var/datum/integrated_io/activate/A = activators[pin_number]
	A.push_data()

/datum/integrated_io/proc/get_data()
	if(isnull(data))
		return
	if(isweakref(data))
		return data.resolve()
	return data

/obj/item/integrated_circuit/proc/get_pin_ref(pin_type, pin_number)
	switch(pin_type)
		if(IC_INPUT)
			if(pin_number > inputs.len)
				return null
			return inputs[pin_number]
		if(IC_OUTPUT)
			if(pin_number > outputs.len)
				return null
			return outputs[pin_number]
		if(IC_ACTIVATOR)
			if(pin_number > activators.len)
				return null
			return activators[pin_number]
	return null

/obj/item/integrated_circuit/proc/handle_wire(datum/integrated_io/pin, obj/item/device/integrated_electronics/tool)
	if(istype(tool, /obj/item/device/integrated_electronics/wirer))
		var/obj/item/device/integrated_electronics/wirer/wirer = tool
		if(pin)
			wirer.wire(pin, usr)
			return 1

	else if(istype(tool, /obj/item/device/integrated_electronics/debugger))
		var/obj/item/device/integrated_electronics/debugger/debugger = tool
		if(pin)
			debugger.write_data(pin, usr)
			return 1
	return 0
