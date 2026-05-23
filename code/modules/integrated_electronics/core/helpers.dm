/*
 * core/helpers.dm
 * Utility procs for integrated electronics, including formatting, data conversion, cloning, list handling, and shared validation.
 */

/obj/item/integrated_circuit/proc/setup_io(list/io_list, io_type, list/io_default_list)
	// Stores `io_list_copy` state used by this integrated electronics object.
	var/list/io_list_copy = io_list.Copy()
	io_list.Cut()
	// Stores `i` state used by this integrated electronics object.
	var/i = 0
	for(var/io_entry in io_list_copy)
		i++

		var/default_data = null
		var/io_type_override = null

		// Override the default data.
		if(LAZYLEN(io_default_list))
			default_data = io_default_list["[i]"]

		// Override the pin type.
		if(io_list_copy[io_entry])
			io_type_override = io_list_copy[io_entry]

		if(io_type_override)
			io_list += new io_type_override(src, io_entry, default_data)
		else
			io_list += new io_type(src, io_entry, default_data)

/// Writes a value to one of this circuit's pins.
/obj/item/integrated_circuit/proc/set_pin_data(pin_type, pin_number, datum/new_data)
	if(istype(new_data) && !isweakref(new_data))
		new_data = WEAKREF(new_data)

	// Stores `pin` state used by this integrated electronics object.
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	if(!pin)
		CRASH("Invalid pin ref.")
	return pin.write_data_to_pin(new_data)

/// Reads a value from one of this circuit's pins.
/obj/item/integrated_circuit/proc/get_pin_data(pin_type, pin_number, var/resolve_weakrefs = TRUE)
	// Stores `pin` state used by this integrated electronics object.
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	if(!pin)
		return null
	return pin.get_data(resolve_weakrefs)

/// Returns the current `pin_data_as_type` value or object used by this electronics code.
/obj/item/integrated_circuit/proc/get_pin_data_as_type(pin_type, pin_number, as_type)
	// Stores `pin` state used by this integrated electronics object.
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	if(!pin)
		return null
	return pin.data_as_type(as_type)

/// Pulses an activator pin so downstream circuits can react.
/obj/item/integrated_circuit/proc/activate_pin(pin_number)
	// Stores `A` state used by this integrated electronics object.
	var/datum/integrated_io/activate/A = activators[pin_number]
	if(!A)
		return FALSE
	A.push_data(pin_number)
	return TRUE

/// Returns the current `data` value or object used by this electronics code.
/datum/integrated_io/proc/get_data(var/resolve_weakrefs = TRUE)
	if(resolve_weakrefs && isweakref(data))
		return data.resolve()
	return data

/// Returns the current `pin_ref` value or object used by this electronics code.
/obj/item/integrated_circuit/proc/get_pin_ref(pin_type, pin_number)
	if(!pin_number || pin_number < 1)
		return null

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

/// Implements `handle_wire` behavior for this integrated electronics type.
/obj/item/integrated_circuit/proc/handle_wire(datum/integrated_io/pin, obj/item/integrated_electronics/tool)
	if(!pin || !tool)
		return FALSE

	if(istype(tool, /obj/item/integrated_electronics/wirer))
		var/obj/item/integrated_electronics/wirer/wirer = tool
		wirer.wire(pin, usr)
		return TRUE

	if(istype(tool, /obj/item/integrated_electronics/debugger))
		var/obj/item/integrated_electronics/debugger/debugger = tool
		debugger.write_data(pin, usr)
		return TRUE

	return FALSE

/// Implements `XorEncrypt` behavior for this integrated electronics type.
/proc/XorEncrypt(string, key)
	if(!string || !key || !istext(string) || !istext(key))
		return null

	var/r
	for(var/i = 1 to length(string))
		r += ascii2text(text2ascii(string, i) ^ text2ascii(key, (i - 1) % length(key) + 1))
	return r

// ------------------------------------------------------------
// Integrated circuit helper procs.
// These are intentionally generic so new circuits can reuse them
// instead of duplicating null, list, text, number, and boolean checks.
// ------------------------------------------------------------

/proc/ic_is_null(value)
	return isnull(value)

/// Implements `ic_is_text` behavior for this integrated electronics type.
/proc/ic_is_text(value)
	return istext(value)

/// Implements `ic_is_number` behavior for this integrated electronics type.
/proc/ic_is_number(value)
	return isnum(value)

/// Implements `ic_is_list` behavior for this integrated electronics type.
/proc/ic_is_list(value)
	return islist(value)

/// Implements `ic_is_ref` behavior for this integrated electronics type.
/proc/ic_is_ref(value)
	if(isweakref(value))
		return TRUE
	if(istype(value, /datum))
		return TRUE
	return FALSE

/// Implements `ic_truthy` behavior for this integrated electronics type.
/proc/ic_truthy(value)
	if(isnull(value))
		return FALSE

	if(isnum(value))
		return value != 0

	if(istext(value))
		return length(value) > 0

	if(islist(value))
		var/list/L = value
		return L.len > 0

	return TRUE

/// Implements `ic_falsey` behavior for this integrated electronics type.
/proc/ic_falsey(value)
	return !ic_truthy(value)

/proc/ic_safe_number(value, default_value = 0)
	if(isnum(value))
		return value

	if(istext(value))
		var/converted = text2num(value)
		if(!isnull(converted))
			return converted

	return default_value

/proc/ic_safe_text(value, default_value = "")
	if(isnull(value))
		return default_value

	if(istext(value))
		return value

	if(isnum(value))
		return num2text(value)

	if(isweakref(value))
		var/datum/weakref/W = value
		var/datum/resolved = W.resolve()
		if(resolved)
			return "[resolved]"
		return default_value

	return "[value]"

/// Implements `ic_safe_bool` behavior for this integrated electronics type.
/proc/ic_safe_bool(value)
	return ic_truthy(value)

/// Implements `ic_display_value` behavior for this integrated electronics type.
/proc/ic_display_value(value)
	if(isnull(value))
		return "null"

	if(isweakref(value))
		var/datum/weakref/W = value
		var/datum/resolved = W.resolve()
		if(resolved)
			return "[resolved]"
		return "null ref"

	if(islist(value))
		var/list/L = value
		return ic_list_to_text(L, ", ")

	if(istext(value))
		return value

	if(isnum(value))
		return num2text(value)

	return "[value]"

/// Implements `ic_type_text` behavior for this integrated electronics type.
/proc/ic_type_text(value)
	if(isnull(value))
		return "null"

	if(isweakref(value))
		return "weakref"

	if(isnum(value))
		return "number"

	if(istext(value))
		return "string"

	if(islist(value))
		return "list"

	if(istype(value, /datum))
		return "ref"

	return "unknown"

/proc/ic_list_to_text(list/L, separator = ", ")
	if(!islist(L))
		return ""

	var/list/output = list()
	for(var/entry in L)
		output += ic_display_value(entry)

	return jointext(output, separator)

/proc/ic_text_to_list(text, separator = ",")
	if(!istext(text))
		return list()

	var/list/output = list()
	// Stores `split_values` state used by this integrated electronics object.
	var/list/split_values = splittext(text, separator)

	for(var/entry in split_values)
		output += trim(entry)

	return output

/// Implements `ic_copy_list` behavior for this integrated electronics type.
/proc/ic_copy_list(list/L)
	if(!islist(L))
		return list()

	return L.Copy()

/// Implements `ic_filter_nulls` behavior for this integrated electronics type.
/proc/ic_filter_nulls(list/L)
	if(!islist(L))
		return list()

	var/list/output = list()
	for(var/entry in L)
		if(!isnull(entry))
			output += entry

	return output

/// Implements `ic_list_contains` behavior for this integrated electronics type.
/proc/ic_list_contains(list/L, value)
	if(!islist(L))
		return FALSE

	return L.Find(value) ? TRUE : FALSE

/// Implements `ic_list_length` behavior for this integrated electronics type.
/proc/ic_list_length(list/L)
	if(!islist(L))
		return 0

	return L.len

/// Implements `ic_clamp_number` behavior for this integrated electronics type.
/proc/ic_clamp_number(value, minimum, maximum)
	// Stores `number` state used by this integrated electronics object.
	var/number = ic_safe_number(value, minimum)

	if(number < minimum)
		return minimum

	if(number > maximum)
		return maximum

	return number

/// Implements `ic_percent` behavior for this integrated electronics type.
/proc/ic_percent(value, maximum)
	// Stores `number` state used by this integrated electronics object.
	var/number = ic_safe_number(value, 0)
	// Stores `max_number` state used by this integrated electronics object.
	var/max_number = ic_safe_number(maximum, 0)

	if(max_number <= 0)
		return 0

	return (number / max_number) * 100

/// Implements `ic_range_check` behavior for this integrated electronics type.
/proc/ic_range_check(value, minimum, maximum)
	// Stores `number` state used by this integrated electronics object.
	var/number = ic_safe_number(value, 0)

	if(number < minimum)
		return -1

	if(number > maximum)
		return 1

	return 0

/// Implements `ic_range_text` behavior for this integrated electronics type.
/proc/ic_range_text(value, minimum, maximum)
	// Stores `range_result` state used by this integrated electronics object.
	var/range_result = ic_range_check(value, minimum, maximum)

	if(range_result < 0)
		return "low"

	if(range_result > 0)
		return "high"

	return "normal"

/// Implements `ic_format_status` behavior for this integrated electronics type.
/proc/ic_format_status(label, value)
	return "[ic_safe_text(label, "Status")]: [ic_display_value(value)]"

/// Implements `ic_format_warning` behavior for this integrated electronics type.
/proc/ic_format_warning(label, value)
	return "WARNING: [ic_safe_text(label, "Value")] [ic_display_value(value)]"

/// Implements `ic_format_error` behavior for this integrated electronics type.
/proc/ic_format_error(label, value)
	return "ERROR: [ic_safe_text(label, "Value")] [ic_display_value(value)]"

/// Implements `ic_join_lines` behavior for this integrated electronics type.
/proc/ic_join_lines(list/L)
	if(!islist(L))
		return ""

	var/list/output = list()
	for(var/entry in L)
		if(isnull(entry))
			continue
		output += ic_display_value(entry)

	return jointext(output, "\n")

/// Implements `ic_make_saveable_value` behavior for this integrated electronics type.
/proc/ic_make_saveable_value(value)
	if(isnull(value) || isnum(value) || istext(value))
		return value

	if(isweakref(value))
		var/datum/weakref/W = value
		var/datum/resolved = W.resolve()
		if(resolved)
			return "[resolved]"
		return null

	if(islist(value))
		var/list/source_list = value
		var/list/new_list = list()

		for(var/entry in source_list)
			new_list += ic_make_saveable_value(entry)

		return new_list

	return "[value]"

/// Implements `ic_sanitize_template_value` behavior for this integrated electronics type.
/proc/ic_sanitize_template_value(value)
	// Stores `text_value` state used by this integrated electronics object.
	var/text_value = ic_display_value(value)
	text_value = replacetext(text_value, "\n", " ")
	text_value = replacetext(text_value, ascii2text(13), " ")
	return text_value

/proc/ic_apply_template(template, value_1 = null, value_2 = null, value_3 = null, value_4 = null, value_5 = null, value_6 = null, value_7 = null, value_8 = null)
	if(!istext(template))
		return ""

	var/output = template
	output = replacetext(output, "{1}", ic_sanitize_template_value(value_1))
	output = replacetext(output, "{2}", ic_sanitize_template_value(value_2))
	output = replacetext(output, "{3}", ic_sanitize_template_value(value_3))
	output = replacetext(output, "{4}", ic_sanitize_template_value(value_4))
	output = replacetext(output, "{5}", ic_sanitize_template_value(value_5))
	output = replacetext(output, "{6}", ic_sanitize_template_value(value_6))
	output = replacetext(output, "{7}", ic_sanitize_template_value(value_7))
	output = replacetext(output, "{8}", ic_sanitize_template_value(value_8))

	return output

/proc/ic_get_nested_list_value(list/L, index, default_value = null)
	if(!islist(L))
		return default_value

	var/number_index = round(ic_safe_number(index, 0))

	if(number_index < 1 || number_index > L.len)
		return default_value

	return L[number_index]

/// Implements `ic_set_nested_list_value` behavior for this integrated electronics type.
/proc/ic_set_nested_list_value(list/L, index, value)
	if(!islist(L))
		return list()

	var/number_index = round(ic_safe_number(index, 0))

	if(number_index < 1)
		return L

	while(L.len < number_index)
		L += null

	L[number_index] = value
	return L

/// Implements `ic_number_or_null` behavior for this integrated electronics type.
/proc/ic_number_or_null(value)
	if(isnum(value))
		return value

	if(istext(value))
		var/converted = text2num(value)
		if(!isnull(converted))
			return converted

	return null

/// Implements `ic_add_numbers` behavior for this integrated electronics type.
/proc/ic_add_numbers(value_1, value_2)
	// Stores `A` state used by this integrated electronics object.
	var/A = ic_number_or_null(value_1)
	// Stores `B` state used by this integrated electronics object.
	var/B = ic_number_or_null(value_2)

	if(isnull(A) || isnull(B))
		return null

	return A + B

/// Implements `ic_subtract_numbers` behavior for this integrated electronics type.
/proc/ic_subtract_numbers(value_1, value_2)
	// Stores `A` state used by this integrated electronics object.
	var/A = ic_number_or_null(value_1)
	// Stores `B` state used by this integrated electronics object.
	var/B = ic_number_or_null(value_2)

	if(isnull(A) || isnull(B))
		return null

	return A - B

/// Implements `ic_multiply_numbers` behavior for this integrated electronics type.
/proc/ic_multiply_numbers(value_1, value_2)
	// Stores `A` state used by this integrated electronics object.
	var/A = ic_number_or_null(value_1)
	// Stores `B` state used by this integrated electronics object.
	var/B = ic_number_or_null(value_2)

	if(isnull(A) || isnull(B))
		return null

	return A * B

/// Implements `ic_divide_numbers` behavior for this integrated electronics type.
/proc/ic_divide_numbers(value_1, value_2)
	// Stores `A` state used by this integrated electronics object.
	var/A = ic_number_or_null(value_1)
	// Stores `B` state used by this integrated electronics object.
	var/B = ic_number_or_null(value_2)

	if(isnull(A) || isnull(B) || B == 0)
		return null

	return A / B
