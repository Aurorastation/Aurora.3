/*
 * core/helpers.dm
 * Utility procs for integrated electronics, including formatting, data conversion, cloning, list handling, and shared validation.
 */

/obj/item/integrated_circuit/proc/setup_io(list/io_list, io_type, list/io_default_list)
	var/list/io_list_copy = io_list.Copy()
	io_list.Cut()
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

/obj/item/integrated_circuit/proc/set_pin_data(pin_type, pin_number, datum/new_data)
	if(istype(new_data) && !isweakref(new_data))
		new_data = WEAKREF(new_data)

	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	if(!pin)
		CRASH("Invalid pin ref.")
	return pin.write_data_to_pin(new_data)

/obj/item/integrated_circuit/proc/get_pin_data(pin_type, pin_number, var/resolve_weakrefs = TRUE)
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	if(!pin)
		return null
	return pin.get_data(resolve_weakrefs)

/obj/item/integrated_circuit/proc/get_pin_data_as_type(pin_type, pin_number, as_type)
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	if(!pin)
		return null
	return pin.data_as_type(as_type)

/obj/item/integrated_circuit/proc/activate_pin(pin_number)
	var/datum/integrated_io/activate/A = activators[pin_number]
	if(!A)
		return FALSE
	A.push_data(pin_number)
	return TRUE

/datum/integrated_io/proc/get_data(var/resolve_weakrefs = TRUE)
	if(resolve_weakrefs && isweakref(data))
		return data.resolve()
	return data

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

/proc/ic_is_text(value)
	return istext(value)

/proc/ic_is_number(value)
	return isnum(value)

/proc/ic_is_list(value)
	return islist(value)

/proc/ic_is_ref(value)
	if(isweakref(value))
		return TRUE
	if(istype(value, /datum))
		return TRUE
	return FALSE

/proc/ic_is_safe_ref_atom(atom/A)
	if(!istype(A))
		return FALSE
	if(istype(A, /mob/abstract/ghost))
		return FALSE
	return TRUE

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

/proc/ic_safe_bool(value)
	return ic_truthy(value)

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
	var/list/split_values = splittext(text, separator)

	for(var/entry in split_values)
		output += trim(entry)

	return output

/proc/ic_copy_list(list/L)
	if(!islist(L))
		return list()

	return L.Copy()

/proc/ic_filter_nulls(list/L)
	if(!islist(L))
		return list()

	var/list/output = list()
	for(var/entry in L)
		if(!isnull(entry))
			output += entry

	return output

/proc/ic_list_contains(list/L, value)
	if(!islist(L))
		return FALSE

	return L.Find(value) ? TRUE : FALSE

/proc/ic_list_length(list/L)
	if(!islist(L))
		return 0

	return L.len

/proc/ic_clamp_number(value, minimum, maximum)
	var/number = ic_safe_number(value, minimum)

	if(number < minimum)
		return minimum

	if(number > maximum)
		return maximum

	return number

/proc/ic_percent(value, maximum)
	var/number = ic_safe_number(value, 0)
	var/max_number = ic_safe_number(maximum, 0)

	if(max_number <= 0)
		return 0

	return (number / max_number) * 100

/proc/ic_range_check(value, minimum, maximum)
	var/number = ic_safe_number(value, 0)

	if(number < minimum)
		return -1

	if(number > maximum)
		return 1

	return 0

/proc/ic_range_text(value, minimum, maximum)
	var/range_result = ic_range_check(value, minimum, maximum)

	if(range_result < 0)
		return "low"

	if(range_result > 0)
		return "high"

	return "normal"

/proc/ic_format_status(label, value)
	return "[ic_safe_text(label, "Status")]: [ic_display_value(value)]"

/proc/ic_format_warning(label, value)
	return "WARNING: [ic_safe_text(label, "Value")] [ic_display_value(value)]"

/proc/ic_format_error(label, value)
	return "ERROR: [ic_safe_text(label, "Value")] [ic_display_value(value)]"

/proc/ic_join_lines(list/L)
	if(!islist(L))
		return ""

	var/list/output = list()
	for(var/entry in L)
		if(isnull(entry))
			continue
		output += ic_display_value(entry)

	return jointext(output, "\n")

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

/proc/ic_sanitize_template_value(value)
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

/proc/ic_set_nested_list_value(list/L, index, value)
	if(!islist(L))
		return list()

	var/number_index = round(ic_safe_number(index, 0))

	if(number_index < 1 || number_index > IC_MAX_LIST_LENGTH)
		return L

	while(L.len < number_index)
		L += null

	L[number_index] = value
	return L

/proc/ic_number_or_null(value)
	if(isnum(value))
		return value

	if(istext(value))
		var/converted = text2num(value)
		if(!isnull(converted))
			return converted

	return null

/proc/ic_add_numbers(value_1, value_2)
	var/A = ic_number_or_null(value_1)
	var/B = ic_number_or_null(value_2)

	if(isnull(A) || isnull(B))
		return null

	return A + B

/proc/ic_subtract_numbers(value_1, value_2)
	var/A = ic_number_or_null(value_1)
	var/B = ic_number_or_null(value_2)

	if(isnull(A) || isnull(B))
		return null

	return A - B

/proc/ic_multiply_numbers(value_1, value_2)
	var/A = ic_number_or_null(value_1)
	var/B = ic_number_or_null(value_2)

	if(isnull(A) || isnull(B))
		return null

	return A * B

/proc/ic_divide_numbers(value_1, value_2)
	var/A = ic_number_or_null(value_1)
	var/B = ic_number_or_null(value_2)

	if(isnull(A) || isnull(B) || B == 0)
		return null

	return A / B
