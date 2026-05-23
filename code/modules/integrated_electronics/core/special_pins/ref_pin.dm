/*
 * core/special_pins/ref_pin.dm
 * Reference pin behavior for passing object references between circuits.
 */

// These pins only contain weakrefs or null.
/datum/integrated_io/ref
	name = "ref pin"

/datum/integrated_io/ref/ask_for_pin_data(mob/user) // This clears the pin.
	write_data_to_pin(null)

/// Implements `write_data_to_pin` behavior for this integrated electronics type.
/datum/integrated_io/ref/write_data_to_pin(var/new_data)
	if(isnull(new_data) || isweakref(new_data))
		data = new_data
		holder.on_data_written()

/// Implements `display_pin_type` behavior for this integrated electronics type.
/datum/integrated_io/ref/display_pin_type()
	return IC_FORMAT_REF
