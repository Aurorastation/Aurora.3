/*
 * subtypes/arithmetic.dm
 * Arithmetic circuits for numeric operations and math transformations.
 */

//These circuits do simple math.
/// arithmetic: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic
	complexity = 1
	inputs = list(
		"A" = IC_PINTYPE_NUMBER,
		"B" = IC_PINTYPE_NUMBER,
		"C" = IC_PINTYPE_NUMBER,
		"D" = IC_PINTYPE_NUMBER,
		"E" = IC_PINTYPE_NUMBER,
		"F" = IC_PINTYPE_NUMBER,
		"G" = IC_PINTYPE_NUMBER,
		"H" = IC_PINTYPE_NUMBER
	)
	outputs = list("result" = IC_PINTYPE_NUMBER)
	activators = list("compute" = IC_PINTYPE_PULSE_IN, "on computed" = IC_PINTYPE_PULSE_OUT)
	category_text = "Arithmetic"
	power_draw_per_use = 50 // Math is pretty cheap.

// +Adding+ //

/// addition circuit: This circuit can add numbers together.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/addition
	name = "addition circuit"
	desc = "This circuit can add numbers together."
	extended_desc = "Calculation order:<br>\
	result = ((((A + B) + C) + D) ... ) and so on, until all pins have been added.  \
	Null pins are ignored."
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/addition/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = 0
	for(var/datum/integrated_io/I in inputs)
		I.pull_data()
		if(isnum(I.data))
			result = result + I.data

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// -Subtracting- //

/// subtraction circuit: This circuit can subtract numbers.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/subtraction
	name = "subtraction circuit"
	desc = "This circuit can subtract numbers."
	extended_desc = "Calculation order:<br>\
	result = ((((A - B) - C) - D) ... ) and so on, until all pins have been subtracted.  \
	Null pins are ignored.  Pin A <b>must</b> be a number or the circuit will not function."
	icon_state = "subtraction"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/subtraction/do_work()
	// Stores `A` state used by this integrated electronics object.
	var/datum/integrated_io/A = inputs[1]
	if(!isnum(A.data))
		return
	var/result = A.data

	for(var/datum/integrated_io/I in inputs)
		if(I == A)
			continue
		I.pull_data()
		if(isnum(I.data))
			result = result - I.data

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// *Multiply* //

/// multiplication circuit: This circuit can multiply numbers.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/multiplication
	name = "multiplication circuit"
	desc = "This circuit can multiply numbers."
	extended_desc = "Calculation order:<br>\
	result = ((((A * B) * C) * D) ... ) and so on, until all pins have been multiplied.  \
	Null pins are ignored.  Pin A <b>must</b> be a number or the circuit will not function."
	icon_state = "multiplication"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/multiplication/do_work()
	// Stores `A` state used by this integrated electronics object.
	var/datum/integrated_io/A = inputs[1]
	if(!isnum(A.data))
		return
	var/result = A.data
	for(var/datum/integrated_io/I in inputs)
		if(I == A)
			continue
		I.pull_data()
		if(isnum(I.data))
			result = result * I.data

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// /Division/  //

/// division circuit: Divides one number by another. Division by zero is not valid..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/division
	name = "division circuit"
	desc = "Divides one number by another. Division by zero is not valid."
	extended_desc = "Calculation order:<br>\
	result = ((((A / B) / C) / D) ... ) and so on, until all pins have been divided.  \
	Null pins, and pins containing 0, are ignored.  Pin A <b>must</b> be a number or the circuit will not function."
	icon_state = "division"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/division/do_work()
	// Stores `A` state used by this integrated electronics object.
	var/datum/integrated_io/A = inputs[1]
	if(!isnum(A.data))
		return
	var/result = A.data

	for(var/datum/integrated_io/I in inputs)
		if(I == A)
			continue
		I.pull_data()
		if(isnum(I.data) && I.data != 0) //No runtimes here.
			result = result / I.data

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

//^ Exponent ^//

/// exponent circuit: Outputs A to the power of B.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/exponent
	name = "exponent circuit"
	desc = "Outputs A to the power of B."
	icon_state = "exponent"
	inputs = list("A" = IC_PINTYPE_NUMBER, "B" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/exponent/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = 0
	// Stores `A` state used by this integrated electronics object.
	var/datum/integrated_io/A = inputs[1]
	// Stores `B` state used by this integrated electronics object.
	var/datum/integrated_io/B = inputs[2]
	if(isnum(A.data) && isnum(B.data))
		result = A.data ** B.data

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// +-Sign-+ //

/// sign circuit: Outputs whether a number is positive, negative, or zero. Outputs 1 for positive numbers, -1 for negative numbers, and 0 for zero.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/sign
	name = "sign circuit"
	desc = "Outputs whether a number is positive, negative, or zero."
	extended_desc = "Outputs 1 for positive numbers, -1 for negative numbers, and 0 for zero."
	icon_state = "sign"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/sign/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = 0
	// Stores `A` state used by this integrated electronics object.
	var/datum/integrated_io/A = inputs[1]
	if(isnum(A.data))
		if(A.data > 0)
			result = 1
		else if (A.data < 0)
			result = -1
		else
			result = 0

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Round //

/// round circuit: Rounds A to the nearest B multiple of A. If B is not given a number, it will output the floor of A instead.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/round
	name = "round circuit"
	desc = "Rounds A to the nearest B multiple of A."
	extended_desc = "If B is not given a number, it will output the floor of A instead."
	icon_state = "round"
	inputs = list("A" = IC_PINTYPE_NUMBER, "B" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/round/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = 0
	// Stores `A` state used by this integrated electronics object.
	var/datum/integrated_io/A = inputs[1]
	// Stores `B` state used by this integrated electronics object.
	var/datum/integrated_io/B = inputs[2]
	if(isnum(A.data))
		if(isnum(B.data) && B.data != 0)
			result = round(A.data, B.data)
		else
			result = round(A.data)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)


// Absolute //

/// absolute circuit: This outputs a non-negative version of the number you put in. This may also be thought of as its distance from zero.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/absolute
	name = "absolute circuit"
	desc = "Outputs the absolute value of A."
	icon_state = "absolute"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/absolute/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = 0
	for(var/datum/integrated_io/I in inputs)
		I.pull_data()
		if(isnum(I.data))
			result = abs(I.data)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Averaging //

/// average circuit: Calculates the average of the provided numeric inputs. Note that null pins are ignored, whereas a pin containing 0 is included in the averaging calculation.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/average
	name = "average circuit"
	desc = "Calculates the average of the provided numeric inputs."
	extended_desc = "Note that null pins are ignored, whereas a pin containing 0 is included in the averaging calculation."
	icon_state = "average"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/average/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = 0
	// Stores `inputs_used` state used by this integrated electronics object.
	var/inputs_used = 0
	for(var/datum/integrated_io/I in inputs)
		I.pull_data()
		if(isnum(I.data))
			inputs_used++
			result = result + I.data

	if(inputs_used)
		result = result / inputs_used

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Pi, because why the hell not? //
/// pi constant circuit: Not recommended for cooking. Outputs '3.14159' when it receives a pulse.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/pi
	name = "pi constant circuit"
	desc = "Outputs the numeric constant pi when pulsed."
	icon_state = "pi"
	inputs = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/pi/do_work()
	set_pin_data(IC_OUTPUT, 1, M_PI)
	push_data()
	activate_pin(2)

// Random //
/// random number generator circuit: Outputs a random integer between A and B, inclusive.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/random
	name = "random number generator circuit"
	desc = "Outputs a random integer between A and B, inclusive."
	extended_desc = "'Inclusive' means that the upper bound is included in the range of numbers, e.g. L = 1 and H = 3 will allow \
	for outputs of 1, 2, or 3.  H being the higher number is not <i>strictly</i> required."
	icon_state = "random"
	inputs = list("L" = IC_PINTYPE_NUMBER,"H" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/random/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = 0
	// Stores `L` state used by this integrated electronics object.
	var/L = get_pin_data(IC_INPUT, 1)
	// Stores `H` state used by this integrated electronics object.
	var/H = get_pin_data(IC_INPUT, 2)

	if(isnum(L) && isnum(H))
		result = rand(L, H)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Square Root //

/// square root circuit: Outputs the square root of A.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/square_root
	name = "square root circuit"
	desc = "Outputs the square root of A."
	icon_state = "square_root"
	inputs = list("A" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/square_root/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = 0
	for(var/datum/integrated_io/I in inputs)
		I.pull_data()
		if(isnum(I.data))
			result = sqrt(I.data)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// % Modulo % //

/// modulo circuit: Outputs the remainder of A divided by B.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/modulo
	name = "modulo circuit"
	desc = "Outputs the remainder of A divided by B."
	icon_state = "modulo"
	inputs = list("A" = IC_PINTYPE_NUMBER, "B" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/modulo/do_work()
	// Stores `result` state used by this integrated electronics object.
	var/result = 0
	// Stores `A` state used by this integrated electronics object.
	var/A = get_pin_data(IC_INPUT, 1)
	// Stores `B` state used by this integrated electronics object.
	var/B = get_pin_data(IC_INPUT, 2)
	if(isnum(A) && isnum(B) && B != 0)
		result = A % B

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Min //

/// min circuit: Outputs the smallest provided number.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/min
	name = "min circuit"
	desc = "Outputs the smallest provided number."
	// The states are rarely used symbols for the operations
	// Letters didn't fit as well
	icon_state = "min"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/min/do_work()
	// Stores `values` state used by this integrated electronics object.
	var/list/values = list()
	for(var/datum/integrated_io/I in inputs)
		I.pull_data()
		if(isnum(I.data))
			values.Add(I.data)

	set_pin_data(IC_OUTPUT, 1, min(values))
	push_data()
	activate_pin(2)

// Max //

/// max circuit: Outputs the largest provided number.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/arithmetic/max
	name = "max circuit"
	desc = "Outputs the largest provided number."
	icon_state = "max"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/arithmetic/max/do_work()
	// Stores `values` state used by this integrated electronics object.
	var/list/values = list()
	for(var/datum/integrated_io/I in inputs)
		I.pull_data()
		if(isnum(I.data))
			values.Add(I.data)

	set_pin_data(IC_OUTPUT, 1, max(values))
	push_data()
	activate_pin(2)
