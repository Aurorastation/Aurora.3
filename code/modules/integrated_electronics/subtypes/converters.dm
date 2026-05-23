/*
 * subtypes/converters.dm
 * Converter circuits that translate between numbers, strings, booleans, directions, colors, and other pin formats.
 */

//These circuits convert one variable to another.
/// converter: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/converter
	complexity = 2
	inputs = list("input")
	outputs = list("output")
	activators = list("convert" = IC_PINTYPE_PULSE_IN, "on convert" = IC_PINTYPE_PULSE_OUT)
	category_text = "Converter"
	power_draw_per_use = 100

/// number to string: This circuit can convert a number variable into a string. Null or false-equivalent inputs output as the text value '0'.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/converter/num2text
	name = "number to string"
	desc = "This circuit can convert a number variable into a string."
	extended_desc = "Null or false-equivalent inputs output as the text value '0'."
	complexity = 1
	icon_state = "num-string"
	inputs = list("input" = IC_PINTYPE_NUMBER)
	outputs = list("output" = IC_PINTYPE_STRING)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/num2text/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = null
	pull_data()
	// Stores `incoming` state used by this integrated electronics object.
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(!isnull(incoming))
		result = num2text(incoming)
	else if(!incoming)
		result = "0"

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/// 4-way number to string: This circuit can convert up to four number variables into strings. Null or false-equivalent inputs output as the text value '0'.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
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

/// 8-way number to string: This circuit can convert up to eight number variables into strings. Null or false-equivalent inputs output as the text value '0'.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
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

/// string to number: This circuit can convert a string variable into a number.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/converter/text2num
	name = "string to number"
	desc = "This circuit can convert a string variable into a number."
	icon_state = "string-num"
	inputs = list("input" = IC_PINTYPE_STRING)
	outputs = list("output" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/text2num/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = null
	pull_data()
	// Stores `incoming` state used by this integrated electronics object.
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(!isnull(incoming))
		result = text2num(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/// reference to string: This circuit can convert a reference to something else to a string, specifically the name of that reference.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/converter/ref2text
	name = "reference to string"
	desc = "This circuit can convert a reference to something else to a string, specifically the name of that reference."
	icon_state = "ref-string"
	inputs = list("input" = IC_PINTYPE_REF)
	outputs = list("output" = IC_PINTYPE_STRING)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/ref2text/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = null
	pull_data()
	// Stores `A` state used by this integrated electronics object.
	var/atom/A = get_pin_data_as_type(IC_INPUT, 1, /atom)
	if(A)
		result = A.name

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/// lowercase string converter: Converts text to lowercase.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/converter/lowercase
	name = "lowercase string converter"
	desc = "Converts text to lowercase."
	icon_state = "lowercase"
	inputs = list("input" = IC_PINTYPE_STRING)
	outputs = list("output" = IC_PINTYPE_STRING)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/lowercase/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = null
	pull_data()
	// Stores `incoming` state used by this integrated electronics object.
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(!isnull(incoming))
		result = lowertext(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/// uppercase string converter: Converts text to uppercase.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/converter/uppercase
	name = "uppercase string converter"
	desc = "Converts text to uppercase."
	icon_state = "uppercase"
	inputs = list("input" = IC_PINTYPE_STRING)
	outputs = list("output" = IC_PINTYPE_STRING)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/uppercase/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = null
	pull_data()
	// Stores `incoming` state used by this integrated electronics object.
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(!isnull(incoming))
		result = uppertext(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/// concatenator: Joins multiple text inputs into one text output.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/concatenator/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = null
	for(var/datum/integrated_io/I in inputs)
		I.pull_data()
		if(!isnull(I.data))
			result = result + I.data

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/// separator: Splits a text input into two outputs at the selected position.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/separator/do_work()
	// Stores `text` state used by this integrated electronics object.
	var/text = get_pin_data(IC_INPUT, 1)
	// Stores `index` state used by this integrated electronics object.
	var/index = get_pin_data(IC_INPUT, 2)

	// Stores `split` state used by this integrated electronics object.
	var/split = min(index+1, length(text))

	// Stores `before_text` state used by this integrated electronics object.
	var/before_text = copytext(text, 1, split)
	// Stores `after_text` state used by this integrated electronics object.
	var/after_text = copytext(text, split, 0)

	set_pin_data(IC_OUTPUT, 1, before_text)
	set_pin_data(IC_OUTPUT, 2, after_text)
	push_data()

	activate_pin(2)

/// find text: Outputs the position of a sample text within the input text, or 0 if it is not found.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/findstring/do_work()

	set_pin_data(IC_OUTPUT, 1, findtext(get_pin_data(IC_INPUT, 1),get_pin_data(IC_INPUT, 2)) )
	push_data()

	activate_pin(2)

/// string exploder: This splits a single string into a list of strings.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/exploders/do_work()
	// Stores `strin` state used by this integrated electronics object.
	var/strin = get_pin_data(IC_INPUT, 1)
	// Stores `sample` state used by this integrated electronics object.
	var/sample = get_pin_data(IC_INPUT, 2)
	set_pin_data(IC_OUTPUT, 1, splittext( strin ,sample ))
	push_data()

	activate_pin(2)

/// radians to degrees converter: Converts radians to degrees.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/converter/radians2degrees
	name = "radians to degrees converter"
	desc = "Converts radians to degrees."
	inputs = list("radian" = IC_PINTYPE_NUMBER)
	outputs = list("degrees" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/radians2degrees/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = null
	pull_data()
	// Stores `incoming` state used by this integrated electronics object.
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(!isnull(incoming))
		result = TO_DEGREES(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/// degrees to radians converter: Converts degrees to radians.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/converter/degrees2radians
	name = "degrees to radians converter"
	desc = "Converts degrees to radians."
	inputs = list("degrees" = IC_PINTYPE_NUMBER)
	outputs = list("radians" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/degrees2radians/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = null
	pull_data()
	// Stores `incoming` state used by this integrated electronics object.
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(!isnull(incoming))
		result = TO_RADIANS(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)


/// abs to rel coordinate converter: Easily convert absolute coordinates to relative coordinates with this.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/abs_to_rel_coords/do_work()
	// Stores `x1` state used by this integrated electronics object.
	var/x1 = get_pin_data(IC_INPUT, 1)
	// Stores `y1` state used by this integrated electronics object.
	var/y1 = get_pin_data(IC_INPUT, 2)

	// Stores `x2` state used by this integrated electronics object.
	var/x2 = get_pin_data(IC_INPUT, 3)
	// Stores `y2` state used by this integrated electronics object.
	var/y2 = get_pin_data(IC_INPUT, 4)

	if(!isnull(x1) && !isnull(y1) && !isnull(x2) && !isnull(y2))
		set_pin_data(IC_OUTPUT, 1, x1 - x2)
		set_pin_data(IC_OUTPUT, 2, y1 - y2)

	push_data()
	activate_pin(2)

/// len circuit: This circuit will return the number of characters in a string.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/stringlength/do_work()
	set_pin_data(IC_OUTPUT, 1, length(get_pin_data(IC_INPUT, 1)))
	push_data()

	activate_pin(2)

/// hsv to hexadecimal converter: This circuit can convert a HSV (Hue, Saturation, and Value) color to a Hexadecimal RGB color.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/hsv2hex/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = null
	pull_data()
	// Stores `hue` state used by this integrated electronics object.
	var/hue = get_pin_data(IC_INPUT, 1)
	// Stores `saturation` state used by this integrated electronics object.
	var/saturation = get_pin_data(IC_INPUT, 2)
	// Stores `value` state used by this integrated electronics object.
	var/value = get_pin_data(IC_INPUT, 3)
	if(isnum(hue) && isnum(saturation) && isnum(value))
		result = HSVtoRGB(hsv(AngleToHue(hue),saturation,value))

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/// rgb to hexadecimal converter: This circuit can convert a RGB (Red, Green, Blue) color to a Hexadecimal RGB color. The first pin controls red amount, the second pin controls green amount, and the third controls blue amount. They all go from 0-255.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/converter/rgb2hex/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = null
	pull_data()
	// Stores `red` state used by this integrated electronics object.
	var/red = get_pin_data(IC_INPUT, 1)
	// Stores `green` state used by this integrated electronics object.
	var/green = get_pin_data(IC_INPUT, 2)
	// Stores `blue` state used by this integrated electronics object.
	var/blue = get_pin_data(IC_INPUT, 3)
	if(isnum(red) && isnum(green) && isnum(blue))
		result = rgb(red, green, blue)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)
