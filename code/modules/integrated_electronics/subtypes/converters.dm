/*
 * subtypes/converters.dm
 * Converter circuits that translate between numbers, strings, booleans, directions, colors, and other pin formats.
 */

//These circuits convert one variable to another.
/obj/item/integrated_circuit/converter
	complexity = 2
	inputs = list("input")
	outputs = list("output")
	activators = list("convert" = IC_PINTYPE_PULSE_IN, "on convert" = IC_PINTYPE_PULSE_OUT)
	category_text = "Converter"
	power_draw_per_use = 100

/obj/item/integrated_circuit/converter/num2text
	name = "number to string"
	desc = "This circuit can convert a number variable into a string."
	extended_desc = "Null or false-equivalent inputs output as the text value '0'."
	complexity = 1
	icon_state = "num-string"
	inputs = list("input" = IC_PINTYPE_NUMBER)
	outputs = list("output" = IC_PINTYPE_STRING)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/num2text/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(!isnull(incoming))
		result = num2text(incoming)
	else if(!incoming)
		result = "0"

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/num2text4
	name = "4-way number to string"
	desc = "This circuit can convert up to four number variables into strings."
	extended_desc = "Null or false-equivalent inputs output as the text value '0'."
	complexity = 2
	icon_state = "num-string"
	inputs = list(
		"input 1" = IC_PINTYPE_NUMBER,
		"input 2" = IC_PINTYPE_NUMBER,
		"input 3" = IC_PINTYPE_NUMBER,
		"input 4" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"output 1" = IC_PINTYPE_STRING,
		"output 2" = IC_PINTYPE_STRING,
		"output 3" = IC_PINTYPE_STRING,
		"output 4" = IC_PINTYPE_STRING
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/num2text4/do_work()
	pull_data()

	for(var/i = 1 to 4)
		var/result = null
		var/incoming = get_pin_data(IC_INPUT, i)

		if(!isnull(incoming))
			result = num2text(incoming)
		else if(!incoming)
			result = "0"

		set_pin_data(IC_OUTPUT, i, result)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/num2text8
	name = "8-way number to string"
	desc = "This circuit can convert up to eight number variables into strings."
	extended_desc = "Null or false-equivalent inputs output as the text value '0'."
	complexity = 4
	icon_state = "num-string"
	inputs = list(
		"input 1" = IC_PINTYPE_NUMBER,
		"input 2" = IC_PINTYPE_NUMBER,
		"input 3" = IC_PINTYPE_NUMBER,
		"input 4" = IC_PINTYPE_NUMBER,
		"input 5" = IC_PINTYPE_NUMBER,
		"input 6" = IC_PINTYPE_NUMBER,
		"input 7" = IC_PINTYPE_NUMBER,
		"input 8" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"output 1" = IC_PINTYPE_STRING,
		"output 2" = IC_PINTYPE_STRING,
		"output 3" = IC_PINTYPE_STRING,
		"output 4" = IC_PINTYPE_STRING,
		"output 5" = IC_PINTYPE_STRING,
		"output 6" = IC_PINTYPE_STRING,
		"output 7" = IC_PINTYPE_STRING,
		"output 8" = IC_PINTYPE_STRING
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/num2text8/do_work()
	pull_data()

	for(var/i = 1 to 8)
		var/result = null
		var/incoming = get_pin_data(IC_INPUT, i)

		if(!isnull(incoming))
			result = num2text(incoming)
		else if(!incoming)
			result = "0"

		set_pin_data(IC_OUTPUT, i, result)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/text2num
	name = "string to number"
	desc = "This circuit can convert a string variable into a number."
	icon_state = "string-num"
	inputs = list("input" = IC_PINTYPE_STRING)
	outputs = list(
		"output" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/text2num/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(!isnull(incoming))
		result = text2num(incoming)

	var/valid = isnum(result)
	set_pin_data(IC_OUTPUT, 1, result)
	set_pin_data(IC_OUTPUT, 2, valid)
	set_pin_data(IC_OUTPUT, 3, valid ? "Number parsed." : "Input is not a number.")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/ref2text
	name = "reference to string"
	desc = "This circuit can convert a reference to something else to a string, specifically the name of that reference."
	icon_state = "ref-string"
	inputs = list("input" = IC_PINTYPE_REF)
	outputs = list("output" = IC_PINTYPE_STRING)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/ref2text/do_work()
	var/result = null
	pull_data()
	var/atom/A = get_pin_data_as_type(IC_INPUT, 1, /atom)
	if(A)
		result = A.name

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/ref_exists
	name = "reference exists"
	desc = "Checks whether a reference currently points to a valid atom."
	icon_state = "ref-string"
	inputs = list("input" = IC_PINTYPE_REF)
	outputs = list(
		"exists" = IC_PINTYPE_BOOLEAN,
		"resolved ref" = IC_PINTYPE_REF
	)
	activators = list(
		"convert" = IC_PINTYPE_PULSE_IN,
		"on convert" = IC_PINTYPE_PULSE_OUT,
		"on valid" = IC_PINTYPE_PULSE_OUT,
		"on invalid" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/ref_exists/do_work()
	var/atom/A = get_pin_data_as_type(IC_INPUT, 1, /atom)
	var/valid = !!A

	set_pin_data(IC_OUTPUT, 1, valid)
	set_pin_data(IC_OUTPUT, 2, valid ? A : null)
	push_data()
	activate_pin(2)
	activate_pin(valid ? 3 : 4)

/obj/item/integrated_circuit/converter/ref_to_coords
	name = "reference to coordinates"
	desc = "Converts a reference into absolute X, Y, Z coordinates and its turf reference."
	icon_state = "ref-string"
	inputs = list("input" = IC_PINTYPE_REF)
	outputs = list(
		"X" = IC_PINTYPE_NUMBER,
		"Y" = IC_PINTYPE_NUMBER,
		"Z" = IC_PINTYPE_NUMBER,
		"turf" = IC_PINTYPE_REF,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	activators = list(
		"convert" = IC_PINTYPE_PULSE_IN,
		"on convert" = IC_PINTYPE_PULSE_OUT,
		"on valid" = IC_PINTYPE_PULSE_OUT,
		"on invalid" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/ref_to_coords/do_work()
	var/atom/A = get_pin_data_as_type(IC_INPUT, 1, /atom)
	var/turf/T = A ? get_turf(A) : null

	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)
	set_pin_data(IC_OUTPUT, 4, null)
	set_pin_data(IC_OUTPUT, 5, FALSE)
	set_pin_data(IC_OUTPUT, 6, "Invalid reference.")

	if(T)
		set_pin_data(IC_OUTPUT, 1, T.x)
		set_pin_data(IC_OUTPUT, 2, T.y)
		set_pin_data(IC_OUTPUT, 3, T.z)
		set_pin_data(IC_OUTPUT, 4, T)
		set_pin_data(IC_OUTPUT, 5, TRUE)
		set_pin_data(IC_OUTPUT, 6, "Coordinates converted.")

	push_data()
	activate_pin(2)
	activate_pin(T ? 3 : 4)

/obj/item/integrated_circuit/converter/lowercase
	name = "lowercase string converter"
	desc = "Converts text to lowercase."
	icon_state = "lowercase"
	inputs = list("input" = IC_PINTYPE_STRING)
	outputs = list("output" = IC_PINTYPE_STRING)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/lowercase/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(!isnull(incoming))
		result = lowertext(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/uppercase
	name = "uppercase string converter"
	desc = "Converts text to uppercase."
	icon_state = "uppercase"
	inputs = list("input" = IC_PINTYPE_STRING)
	outputs = list("output" = IC_PINTYPE_STRING)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/uppercase/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(!isnull(incoming))
		result = uppertext(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/concatenator
	name = "concatenator"
	desc = "Joins multiple text inputs into one text output."
	complexity = 4
	inputs = list(
		"A" = IC_PINTYPE_STRING,
		"B" = IC_PINTYPE_STRING,
		"C" = IC_PINTYPE_STRING,
		"D" = IC_PINTYPE_STRING,
		"E" = IC_PINTYPE_STRING,
		"F" = IC_PINTYPE_STRING,
		"G" = IC_PINTYPE_STRING,
		"H" = IC_PINTYPE_STRING
	)
	outputs = list("result" = IC_PINTYPE_STRING)
	activators = list("concatenate" = IC_PINTYPE_PULSE_IN, "on concatenated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/concatenator/do_work()
	var/result = null
	for(var/datum/integrated_io/I in inputs)
		I.pull_data()
		if(!isnull(I.data))
			result = result + I.data

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/separator
	name = "separator"
	desc = "Splits a text input into two outputs at the selected position."
	extended_desc = "This circuit splits a given string into two, based on the string, and the index value. \
	The index splits the string <b>after</b> the given index, including spaces. So 'a person' with an index of '3' \
	will split into 'a p' and 'erson'."
	complexity = 4
	inputs = list(
		"string to split" = IC_PINTYPE_STRING,
		"index" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"before split" = IC_PINTYPE_STRING,
		"after split" = IC_PINTYPE_STRING
	)
	activators = list("separate" = IC_PINTYPE_PULSE_IN, "on separated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH


/obj/item/integrated_circuit/converter/separator/do_work()
	var/text = get_pin_data(IC_INPUT, 1)
	var/index = get_pin_data(IC_INPUT, 2)

	var/split = min(index+1, length(text))

	var/before_text = copytext(text, 1, split)
	var/after_text = copytext(text, split, 0)

	set_pin_data(IC_OUTPUT, 1, before_text)
	set_pin_data(IC_OUTPUT, 2, after_text)
	push_data()

	activate_pin(2)

/obj/item/integrated_circuit/converter/findstring
	name = "find text"
	desc = "Outputs the position of a sample text within the input text, or 0 if it is not found."
	extended_desc = "The first pin is the string to be examined. The second pin is the sample to be found. \
	For example, 'eat this burger',' ' will give you position 4. This circuit isn't case sensitive."
	complexity = 4
	inputs = list(
		"string" = IC_PINTYPE_STRING,
		"sample" = IC_PINTYPE_STRING,
		)
	outputs = list(
		"position" = IC_PINTYPE_NUMBER
		)
	activators = list("search" = IC_PINTYPE_PULSE_IN, "after search" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/findstring/do_work()

	set_pin_data(IC_OUTPUT, 1, findtext(get_pin_data(IC_INPUT, 1),get_pin_data(IC_INPUT, 2)) )
	push_data()

	activate_pin(2)

/obj/item/integrated_circuit/converter/exploders
	name = "string exploder"
	desc = "This splits a single string into a list of strings."
	extended_desc = "This circuit splits a given string into a list of strings based on the string and given delimiter. \
	For example, 'eat this burger',' ' will be converted to list('eat','this','burger')."
	complexity = 4
	inputs = list(
		"string to split" = IC_PINTYPE_STRING,
		"delimiter" = IC_PINTYPE_STRING,
		)
	outputs = list(
		"list" = IC_PINTYPE_LIST
		)
	activators = list("separate" = IC_PINTYPE_PULSE_IN, "on separated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/exploders/do_work()
	var/strin = get_pin_data(IC_INPUT, 1)
	var/sample = get_pin_data(IC_INPUT, 2)
	set_pin_data(IC_OUTPUT, 1, splittext( strin ,sample ))
	push_data()

	activate_pin(2)

/obj/item/integrated_circuit/converter/abs_to_rel_coords
	name = "abs to rel coordinate converter"
	desc = "Easily convert absolute coordinates to relative coordinates with this."
	complexity = 4
	inputs = list(
		"X1" = IC_PINTYPE_NUMBER,
		"Y1" = IC_PINTYPE_NUMBER,
		"X2" = IC_PINTYPE_NUMBER,
		"Y2" = IC_PINTYPE_NUMBER
		)
	outputs = list(
		"X" = IC_PINTYPE_NUMBER,
		"Y" = IC_PINTYPE_NUMBER
		)
	activators = list("compute rel coordinates" = IC_PINTYPE_PULSE_IN, "on convert" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/abs_to_rel_coords/do_work()
	var/x1 = get_pin_data(IC_INPUT, 1)
	var/y1 = get_pin_data(IC_INPUT, 2)

	var/x2 = get_pin_data(IC_INPUT, 3)
	var/y2 = get_pin_data(IC_INPUT, 4)

	if(!isnull(x1) && !isnull(y1) && !isnull(x2) && !isnull(y2))
		set_pin_data(IC_OUTPUT, 1, x1 - x2)
		set_pin_data(IC_OUTPUT, 2, y1 - y2)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/dir_to_vector
	name = "direction to vector"
	desc = "Converts a BYOND direction into a two-number X/Y movement vector."
	icon_state = "num-string"
	inputs = list("direction" = IC_PINTYPE_DIR)
	outputs = list(
		"X" = IC_PINTYPE_NUMBER,
		"Y" = IC_PINTYPE_NUMBER,
		"vector" = IC_PINTYPE_LIST,
		"valid" = IC_PINTYPE_BOOLEAN
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/dir_to_vector/do_work()
	var/direction = get_pin_data(IC_INPUT, 1)
	var/x = 0
	var/y = 0

	if(isnum(direction))
		if(direction & EAST)
			x++
		if(direction & WEST)
			x--
		if(direction & NORTH)
			y++
		if(direction & SOUTH)
			y--

	set_pin_data(IC_OUTPUT, 1, x)
	set_pin_data(IC_OUTPUT, 2, y)
	set_pin_data(IC_OUTPUT, 3, list(x, y))
	set_pin_data(IC_OUTPUT, 4, isnum(direction) && (x || y))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/vector_to_dir
	name = "vector to direction"
	desc = "Converts X/Y vector components into a BYOND direction."
	icon_state = "num-string"
	inputs = list(
		"X" = IC_PINTYPE_NUMBER,
		"Y" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"direction" = IC_PINTYPE_DIR,
		"direction text" = IC_PINTYPE_STRING,
		"valid" = IC_PINTYPE_BOOLEAN
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/vector_to_dir/do_work()
	var/x = get_pin_data(IC_INPUT, 1)
	var/y = get_pin_data(IC_INPUT, 2)
	var/direction = 0

	if(isnum(x) && isnum(y))
		if(x > 0)
			direction |= EAST
		else if(x < 0)
			direction |= WEST
		if(y > 0)
			direction |= NORTH
		else if(y < 0)
			direction |= SOUTH

	set_pin_data(IC_OUTPUT, 1, direction || null)
	set_pin_data(IC_OUTPUT, 2, direction ? dir2text(direction) : null)
	set_pin_data(IC_OUTPUT, 3, !!direction)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/delta_to_dir
	name = "delta to direction"
	desc = "Converts relative delta X/Y values into a BYOND direction."
	icon_state = "num-string"
	inputs = list(
		"delta X" = IC_PINTYPE_NUMBER,
		"delta Y" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"direction" = IC_PINTYPE_DIR,
		"direction text" = IC_PINTYPE_STRING,
		"valid" = IC_PINTYPE_BOOLEAN
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/delta_to_dir/do_work()
	var/x = get_pin_data(IC_INPUT, 1)
	var/y = get_pin_data(IC_INPUT, 2)
	var/direction = 0

	if(isnum(x) && isnum(y))
		if(x > 0)
			direction |= EAST
		else if(x < 0)
			direction |= WEST
		if(y > 0)
			direction |= NORTH
		else if(y < 0)
			direction |= SOUTH

	set_pin_data(IC_OUTPUT, 1, direction || null)
	set_pin_data(IC_OUTPUT, 2, direction ? dir2text(direction) : null)
	set_pin_data(IC_OUTPUT, 3, !!direction)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/stringlength
	name = "len circuit"
	desc = "This circuit will return the number of characters in a string."
	complexity = 1
	inputs = list(
		"string" = IC_PINTYPE_STRING
		)
	outputs = list(
		"length" = IC_PINTYPE_NUMBER
		)
	activators = list("get length" = IC_PINTYPE_PULSE_IN, "on acquisition" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/stringlength/do_work()
	set_pin_data(IC_OUTPUT, 1, length(get_pin_data(IC_INPUT, 1)))
	push_data()

	activate_pin(2)

/obj/item/integrated_circuit/converter/hsv2hex
	name = "hsv to hexadecimal converter"
	desc = "This circuit can convert a HSV (Hue, Saturation, and Value) color to a Hexadecimal RGB color."
	extended_desc = "The first pin controls tint (0-359), the second pin controls how intense the tint is (0-255), \
	and the third controls how bright the tint is (0 for black, 127 for normal, 255 for white)."
	icon_state = "hsv-hex"
	inputs = list(
		"hue" = IC_PINTYPE_NUMBER,
		"saturation" = IC_PINTYPE_NUMBER,
		"value" = IC_PINTYPE_NUMBER
	)
	outputs = list("hexadecimal rgb" = IC_PINTYPE_COLOR)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/hsv2hex/do_work()
	var/result = null
	pull_data()
	var/hue = get_pin_data(IC_INPUT, 1)
	var/saturation = get_pin_data(IC_INPUT, 2)
	var/value = get_pin_data(IC_INPUT, 3)
	if(isnum(hue) && isnum(saturation) && isnum(value))
		result = HSVtoRGB(hsv(AngleToHue(hue),saturation,value))

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/rgb2hex
	name = "rgb to hexadecimal converter"
	desc = "This circuit can convert a RGB (Red, Green, Blue) color to a Hexadecimal RGB color."
	extended_desc = "The first pin controls red amount, the second pin controls green amount, and the third controls blue amount. They all go from 0-255."
	icon_state = "rgb-hex"
	inputs = list(
		"red" = IC_PINTYPE_NUMBER,
		"green" = IC_PINTYPE_NUMBER,
		"blue" = IC_PINTYPE_NUMBER
	)
	outputs = list("hexadecimal rgb" = IC_PINTYPE_COLOR)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/rgb2hex/do_work()
	var/result = null
	pull_data()
	var/red = get_pin_data(IC_INPUT, 1)
	var/green = get_pin_data(IC_INPUT, 2)
	var/blue = get_pin_data(IC_INPUT, 3)
	if(isnum(red) && isnum(green) && isnum(blue))
		result = rgb(red, green, blue)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)
