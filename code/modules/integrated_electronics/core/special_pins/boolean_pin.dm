/*
 * core/special_pins/boolean_pin.dm
 * Boolean pin type behavior and conversion for TRUE/FALSE style circuit values.
 */

// These pins only contain 0 or 1.  Null is not allowed.
/datum/integrated_io/boolean
	name = "boolean pin"
	data = FALSE

/datum/integrated_io/boolean/ask_for_pin_data(mob/user) // 'Ask' is a bit misleading, acts more like a toggle.
	// Stores `new_data` state used by this integrated electronics object.
	var/new_data = !data
	write_data_to_pin(new_data)

/// Implements `write_data_to_pin` behavior for this integrated electronics type.
/datum/integrated_io/boolean/write_data_to_pin(var/new_data)
	if(new_data == FALSE || new_data == TRUE)
		data = new_data
		holder.on_data_written()

/// Implements `scramble` behavior for this integrated electronics type.
/datum/integrated_io/boolean/scramble()
	write_data_to_pin(rand(FALSE,TRUE))
	push_data()

/// Implements `display_pin_type` behavior for this integrated electronics type.
/datum/integrated_io/boolean/display_pin_type()
	return IC_FORMAT_BOOLEAN

/// Implements `display_data` behavior for this integrated electronics type.
/datum/integrated_io/boolean/display_data(var/input)
	if(data == TRUE)
		return "(True)"
	return "(False)"
