/*
 * core/special_pins/color_pin.dm
 * Color pin parsing, validation, and display handling for circuit color values.
 */

// These pins can only contain a color (in the form of #FFFFFF) or null.
/datum/integrated_io/color
	name = "color pin"

/datum/integrated_io/color/ask_for_pin_data(mob/user)
	var/new_data = input("Please select a color.","[src] color writing") as null|color
	if(holder.check_interactivity(user) )
		to_chat(user, SPAN_NOTICE("You input a <font color='[new_data]'>new color</font> into the pin."))
		write_data_to_pin(new_data)

/datum/integrated_io/color/write_data_to_pin(new_data)
	// Since this is storing the color as a string hex color code, we need to make sure it's actually one.
	if(isnull(new_data) || istext(new_data))
		if(istext(new_data))
			new_data = uppertext(new_data)
			if(length(new_data) != 7)
				return
			if(copytext(new_data, 1, 2) != "#")
				return
			var/hex_digits = copytext(new_data, 2, 8)
			var/safety_dance = 1
			while(safety_dance <= 6)
				var/hex = copytext(hex_digits, safety_dance, safety_dance + 1)
				if(!findtext("0123456789ABCDEF", hex))
					return
				safety_dance++

		data = new_data
		holder.on_data_written()

// This randomizes the color.
/datum/integrated_io/color/scramble()
	if(!is_valid())
		return
	var/new_data = get_random_colour(simple = FALSE, lower = 0, upper = 255)
	data = new_data
	push_data()

/datum/integrated_io/color/display_pin_type()
	return IC_FORMAT_COLOR

/datum/integrated_io/color/display_data(input)
	if(!isnull(data))
		return "(<font color='[data]'>[data]</font>)"
	return ..()
