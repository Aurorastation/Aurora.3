/*
 * subtypes/math_extended.dm
 * Extended numerical, list, vector, matrix, calculus, and vector-calculus circuits.
 */

#define IC_MATH_LIST_LIMIT 128
#define IC_MATH_VECTOR_LIMIT 16
#define IC_MATH_MATRIX_LIMIT 4
#define IC_MATH_GRID_LIMIT 7

/proc/ic_math_is_number(value)
	return isnum(value)

/proc/ic_math_numeric_list(list/input, limit = IC_MATH_LIST_LIMIT)
	if(!islist(input) || !length(input) || length(input) > limit)
		return null

	var/list/result = list()
	for(var/value in input)
		if(!isnum(value))
			return null
		result += value

	return result

/proc/ic_math_same_length_lists(list/a, list/b, limit = IC_MATH_LIST_LIMIT)
	if(!islist(a) || !islist(b) || !length(a) || length(a) != length(b) || length(a) > limit)
		return FALSE
	return TRUE

/proc/ic_math_sum(list/input)
	var/result = 0
	for(var/value in input)
		result += value
	return result

/proc/ic_math_mean(list/input)
	if(!length(input))
		return null
	return ic_math_sum(input) / length(input)

/proc/ic_math_median(list/input)
	if(!length(input))
		return null
	var/list/sorted = sortTim(input.Copy(), GLOBAL_PROC_REF(cmp_numeric_asc))
	var/middle = length(sorted) / 2
	if(length(sorted) % 2)
		return sorted[round(middle + 0.5)]
	return (sorted[middle] + sorted[middle + 1]) / 2

/proc/ic_math_mode(list/input)
	if(!length(input))
		return null
	var/list/counts = list()
	var/best_value = null
	var/best_count = 0
	for(var/value in input)
		counts["[value]"] = counts["[value]"] + 1
		if(counts["[value]"] > best_count)
			best_count = counts["[value]"]
			best_value = value
	return best_value

/proc/ic_math_variance(list/input)
	if(!length(input))
		return null
	var/mean = ic_math_mean(input)
	var/total = 0
	for(var/value in input)
		total += Square(value - mean)
	return total / length(input)

/proc/ic_math_percentile(list/input, percentile)
	if(!length(input) || !isnum(percentile) || percentile < 0 || percentile > 100)
		return null
	var/list/sorted = sortTim(input.Copy(), GLOBAL_PROC_REF(cmp_numeric_asc))
	if(length(sorted) == 1)
		return sorted[1]
	var/position = 1 + ((percentile / 100) * (length(sorted) - 1))
	var/lower_index = max(1, min(round(position), length(sorted)))
	var/upper_index = max(1, min(Ceiling(position), length(sorted)))
	if(lower_index == upper_index)
		return sorted[lower_index]
	var/fraction = position - lower_index
	return sorted[lower_index] + ((sorted[upper_index] - sorted[lower_index]) * fraction)

/proc/ic_math_vector_magnitude(list/vector)
	var/total = 0
	for(var/value in vector)
		total += value * value
	return sqrt(total)

/proc/ic_math_matrix(list/input)
	if(!islist(input) || !length(input) || length(input) > IC_MATH_MATRIX_LIMIT)
		return null

	var/width = 0
	var/list/result = list()
	for(var/row in input)
		if(!islist(row))
			return null
		var/list/row_list = row
		if(!length(row_list) || length(row_list) > IC_MATH_MATRIX_LIMIT)
			return null
		if(!width)
			width = length(row_list)
		else if(width != length(row_list))
			return null
		var/list/numeric_row = ic_math_numeric_list(row_list, IC_MATH_MATRIX_LIMIT)
		if(!numeric_row)
			return null
		result += list(numeric_row)

	return result

/proc/ic_math_grid(list/input)
	if(!islist(input) || !length(input) || length(input) > IC_MATH_GRID_LIMIT)
		return null

	var/width = 0
	var/list/result = list()
	for(var/row in input)
		if(!islist(row))
			return null
		var/list/row_list = row
		if(!length(row_list) || length(row_list) > IC_MATH_GRID_LIMIT)
			return null
		if(!width)
			width = length(row_list)
		else if(width != length(row_list))
			return null
		var/list/grid_row = list()
		for(var/value in row_list)
			if(isnum(value))
				grid_row += value
			else if(islist(value))
				var/list/vector = ic_math_numeric_list(value, 2)
				if(!vector || length(vector) < 2)
					return null
				grid_row += list(list(vector[1], vector[2]))
			else
				return null
		result += list(grid_row)

	return result

/proc/ic_math_matrix_dimensions(list/input)
	var/list/matrix = ic_math_matrix(input)
	if(!matrix)
		return null

	return list(length(matrix), length(matrix[1]))

/proc/ic_math_grid_dimensions(list/input)
	var/list/grid = ic_math_grid(input)
	if(!grid)
		return null

	return list(length(grid), length(grid[1]))

/proc/ic_math_matrix_to_text(list/input, limit = MAX_MESSAGE_LEN)
	var/list/matrix = ic_math_matrix(input)
	if(!matrix)
		return null

	var/list/rows = list()
	for(var/list/row in matrix)
		rows += "\[[jointext(row, ", ")]\]"

	var/text = jointext(rows, "; ")
	if(length(text) > limit)
		return "[copytext(text, 1, limit - 3)]..."
	return text

/proc/ic_math_grid_to_text(list/input, limit = MAX_MESSAGE_LEN)
	var/list/grid = ic_math_grid(input)
	if(!grid)
		return null

	var/list/rows = list()
	for(var/list/row in grid)
		var/list/values = list()
		for(var/value in row)
			if(islist(value))
				var/list/vector = value
				values += "([vector[1]], [vector[2]])"
			else
				values += "[value]"
		rows += "\[[jointext(values, ", ")]\]"

	var/text = jointext(rows, "; ")
	if(length(text) > limit)
		return "[copytext(text, 1, limit - 3)]..."
	return text

/obj/item/integrated_circuit/math
	name = "math circuit"
	desc = "Performs a mathematical operation."
	complexity = 2
	inputs = list("A" = IC_PINTYPE_NUMBER, "B" = IC_PINTYPE_NUMBER)
	outputs = list(
		"result" = IC_PINTYPE_NUMBER,
		"status" = IC_PINTYPE_STRING
	)
	activators = list(
		"compute" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on failure" = IC_PINTYPE_PULSE_OUT
	)
	category_text = "MATH - Utility"
	power_draw_per_use = 50
	spawn_flags = null
	var/operation = null

/obj/item/integrated_circuit/math/get_printer_spawn_flags()
	if(isnull(operation))
		return null
	return IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/math/proc/succeed(result, status = "OK")
	set_pin_data(IC_OUTPUT, 1, result)
	set_pin_data(IC_OUTPUT, 2, status)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/math/proc/fail(status = "Invalid input")
	set_pin_data(IC_OUTPUT, 2, status)
	push_data()
	activate_pin(3)

// Utility and algebra.
/obj/item/integrated_circuit/math/numeric
	category_text = "MATH - Utility"

/obj/item/integrated_circuit/math/numeric/do_work()
	var/A = get_pin_data(IC_INPUT, 1)
	var/B = get_pin_data(IC_INPUT, 2)
	var/C = get_pin_data(IC_INPUT, 3)

	if(operation != "atan2" && operation != "linear" && operation != "quadratic" && operation != "clamp" && !isnum(A))
		fail()
		return

	switch(operation)
		if("clamp")
			if(!isnum(A) || !isnum(B) || !isnum(C))
				fail()
				return
			succeed(clamp(A, B, C))
		if("floor")
			succeed(round(A))
		if("ceiling")
			succeed(Ceiling(A))
		if("log")
			if(!isnum(B) || A <= 0 || B <= 0 || B == 1)
				fail("Invalid logarithm")
				return
			succeed(log(B, A))
		if("ln")
			if(A <= 0)
				fail("Invalid logarithm")
				return
			succeed(log(A))
		if("exp")
			if(A > 100 || A < -100)
				fail("Out of range")
				return
			succeed(NUM_E ** A)
		if("arcsin")
			if(A < -1 || A > 1)
				fail("Out of range")
				return
			succeed(arcsin(A))
		if("arccos")
			if(A < -1 || A > 1)
				fail("Out of range")
				return
			succeed(arccos(A))
		if("arctan")
			succeed(arctan(A))
		if("atan2")
			if(!isnum(A) || !isnum(B))
				fail()
				return
			succeed(Atan2(A, B))
		if("deg2rad")
			succeed(A * M_PI / 180)
		if("rad2deg")
			succeed(A * 180 / M_PI)
		if("sinh")
			succeed(fsinh(A))
		if("cosh")
			succeed(fcosh(A))
		if("tanh")
			succeed(ftanh(A))
		if("deadband")
			if(!isnum(A) || !isnum(B))
				fail()
				return
			B = abs(B)
			succeed(abs(A) <= B ? 0 : A)
		if("linear")
			if(!isnum(A) || !isnum(B) || !isnum(C))
				fail()
				return
			succeed((A * B) + C)
		if("quadratic")
			var/D = get_pin_data(IC_INPUT, 4)
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D))
				fail()
				return
			succeed((A * B * B) + (C * B) + D)
		else
			fail("Unknown operation")

/obj/item/integrated_circuit/math/numeric/clamp
	name = "clamp circuit"
	desc = "Restricts a sensor, score, or control value to an inclusive minimum and maximum."
	inputs = list("value" = IC_PINTYPE_NUMBER, "minimum" = IC_PINTYPE_NUMBER, "maximum" = IC_PINTYPE_NUMBER)
	operation = "clamp"

/obj/item/integrated_circuit/math/numeric/floor
	name = "floor circuit"
	desc = "Rounds a number downward."
	inputs = list("value" = IC_PINTYPE_NUMBER)
	operation = "floor"

/obj/item/integrated_circuit/math/numeric/ceiling
	name = "ceiling circuit"
	desc = "Rounds a number upward."
	inputs = list("value" = IC_PINTYPE_NUMBER)
	operation = "ceiling"

/obj/item/integrated_circuit/math/numeric/linear
	name = "linear function circuit"
	desc = "Applies a linear scale and offset to a sensor value."
	category_text = "MATH - Algebra"
	inputs = list("scale" = IC_PINTYPE_NUMBER, "value" = IC_PINTYPE_NUMBER, "offset" = IC_PINTYPE_NUMBER)
	operation = "linear"

/obj/item/integrated_circuit/math/numeric/quadratic
	name = "quadratic function circuit"
	desc = "Calculates a*x^2+b*x+c."
	category_text = "MATH - Algebra"
	inputs = list("a" = IC_PINTYPE_NUMBER, "x" = IC_PINTYPE_NUMBER, "b" = IC_PINTYPE_NUMBER, "c" = IC_PINTYPE_NUMBER)
	operation = "quadratic"

/obj/item/integrated_circuit/math/numeric/logarithm
	name = "logarithm circuit"
	desc = "Calculates log base B of A."
	category_text = "MATH - Algebra"
	operation = "log"

/obj/item/integrated_circuit/math/numeric/natural_log
	name = "natural log circuit"
	desc = "Calculates the natural logarithm."
	category_text = "MATH - Algebra"
	inputs = list("value" = IC_PINTYPE_NUMBER)
	operation = "ln"

/obj/item/integrated_circuit/math/numeric/exponential
	name = "exponential circuit"
	desc = "Calculates e raised to the input value."
	category_text = "MATH - Algebra"
	inputs = list("value" = IC_PINTYPE_NUMBER)
	operation = "exp"

/obj/item/integrated_circuit/math/numeric/arcsin
	name = "arc sine circuit"
	desc = "Calculates arcsine in degrees."
	category_text = "MATH - Trigonometry"
	inputs = list("value" = IC_PINTYPE_NUMBER)
	operation = "arcsin"

/obj/item/integrated_circuit/math/numeric/arccos
	name = "arc cosine circuit"
	desc = "Calculates arccosine in degrees."
	category_text = "MATH - Trigonometry"
	inputs = list("value" = IC_PINTYPE_NUMBER)
	operation = "arccos"

/obj/item/integrated_circuit/math/numeric/arctan
	name = "arc tangent circuit"
	desc = "Calculates arctangent in degrees."
	category_text = "MATH - Trigonometry"
	inputs = list("value" = IC_PINTYPE_NUMBER)
	operation = "arctan"

/obj/item/integrated_circuit/math/numeric/atan2
	name = "atan2 circuit"
	desc = "Calculates a direction angle from relative X and Y components for aiming, display, or movement logic."
	category_text = "MATH - Trigonometry"
	inputs = list("relative x" = IC_PINTYPE_NUMBER, "relative y" = IC_PINTYPE_NUMBER)
	operation = "atan2"

/obj/item/integrated_circuit/math/numeric/deadband
	name = "deadband circuit"
	desc = "Suppresses small noisy values around zero so sensor-driven controls do not twitch."
	category_text = "MATH - Signal Processing"
	inputs = list("value" = IC_PINTYPE_NUMBER, "deadband" = IC_PINTYPE_NUMBER)
	operation = "deadband"

/obj/item/integrated_circuit/math/numeric/degrees_to_radians
	name = "degrees to radians circuit"
	desc = "Converts degrees to radians."
	category_text = "MATH - Trigonometry"
	inputs = list("degrees" = IC_PINTYPE_NUMBER)
	operation = "deg2rad"

/obj/item/integrated_circuit/math/numeric/radians_to_degrees
	name = "radians to degrees circuit"
	desc = "Converts radians to degrees."
	category_text = "MATH - Trigonometry"
	inputs = list("radians" = IC_PINTYPE_NUMBER)
	operation = "rad2deg"

/obj/item/integrated_circuit/math/numeric/hyperbolic_sine
	name = "hyperbolic sine circuit"
	desc = "Calculates hyperbolic sine."
	category_text = "MATH - Trigonometry"
	inputs = list("value" = IC_PINTYPE_NUMBER)
	operation = "sinh"

/obj/item/integrated_circuit/math/numeric/hyperbolic_cosine
	name = "hyperbolic cosine circuit"
	desc = "Calculates hyperbolic cosine."
	category_text = "MATH - Trigonometry"
	inputs = list("value" = IC_PINTYPE_NUMBER)
	operation = "cosh"

/obj/item/integrated_circuit/math/numeric/hyperbolic_tangent
	name = "hyperbolic tangent circuit"
	desc = "Calculates hyperbolic tangent."
	category_text = "MATH - Trigonometry"
	inputs = list("value" = IC_PINTYPE_NUMBER)
	operation = "tanh"

// Geometry.
/obj/item/integrated_circuit/math/geometry
	category_text = "MATH - Geometry"
	inputs = list(
		"x1" = IC_PINTYPE_NUMBER,
		"y1" = IC_PINTYPE_NUMBER,
		"x2" = IC_PINTYPE_NUMBER,
		"y2" = IC_PINTYPE_NUMBER
	)

/obj/item/integrated_circuit/math/geometry/do_work()
	var/A = get_pin_data(IC_INPUT, 1)
	var/B = get_pin_data(IC_INPUT, 2)
	var/C = get_pin_data(IC_INPUT, 3)
	var/D = get_pin_data(IC_INPUT, 4)
	var/E = get_pin_data(IC_INPUT, 5)
	var/F = get_pin_data(IC_INPUT, 6)

	switch(operation)
		if("distance2")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D))
				fail()
				return
			succeed(sqrt(Square(C - A) + Square(D - B)))
		if("distance2sq")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D))
				fail()
				return
			succeed(Square(C - A) + Square(D - B))
		if("distance3")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D) || !isnum(E) || !isnum(F))
				fail()
				return
			succeed(sqrt(Square(D - A) + Square(E - B) + Square(F - C)))
		if("manhattan")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D))
				fail()
				return
			succeed(abs(C - A) + abs(D - B))
		if("chebyshev")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D))
				fail()
				return
			succeed(max(abs(C - A), abs(D - B)))
		if("midpoint")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D))
				fail()
				return
			set_pin_data(IC_OUTPUT, 1, (A + C) / 2)
			set_pin_data(IC_OUTPUT, 2, (B + D) / 2)
			set_pin_data(IC_OUTPUT, 3, "OK")
			push_data()
			activate_pin(2)
		if("slope")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D) || C == A)
				fail("Vertical line")
				return
			succeed((D - B) / (C - A))
		if("angle")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D))
				fail()
				return
			succeed(Atan2(C - A, D - B))
		if("circle_area")
			if(!isnum(A) || A < 0)
				fail()
				return
			succeed(M_PI * A * A)
		if("circle_circumference")
			if(!isnum(A) || A < 0)
				fail()
				return
			succeed(2 * M_PI * A)
		if("rectangle_area")
			if(!isnum(A) || !isnum(B))
				fail()
				return
			succeed(A * B)
		if("box_volume")
			if(!isnum(A) || !isnum(B) || !isnum(C))
				fail()
				return
			succeed(A * B * C)
		if("sphere_volume")
			if(!isnum(A) || A < 0)
				fail()
				return
			succeed((4 / 3) * M_PI * A * A * A)

/obj/item/integrated_circuit/math/geometry/midpoint
	name = "midpoint 2D circuit"
	desc = "Finds the center point between two coordinates for patrol, follow, or targeting logic."
	outputs = list("x" = IC_PINTYPE_NUMBER, "y" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	operation = "midpoint"

/obj/item/integrated_circuit/math/geometry/distance2
	name = "distance 2D circuit"
	desc = "Calculates direct range between two coordinates for follow distance, target scoring, or proximity alarms."
	operation = "distance2"

/obj/item/integrated_circuit/math/geometry/distance2sq
	name = "distance squared 2D circuit"
	desc = "Calculates squared range for cheaper target comparisons when exact distance is not needed."
	operation = "distance2sq"

/obj/item/integrated_circuit/math/geometry/distance3
	name = "distance 3D circuit"
	desc = "Calculates Euclidean distance between two 3D points."
	inputs = list("x1" = IC_PINTYPE_NUMBER, "y1" = IC_PINTYPE_NUMBER, "z1" = IC_PINTYPE_NUMBER, "x2" = IC_PINTYPE_NUMBER, "y2" = IC_PINTYPE_NUMBER, "z2" = IC_PINTYPE_NUMBER)
	operation = "distance3"

/obj/item/integrated_circuit/math/geometry/manhattan
	name = "manhattan distance circuit"
	desc = "Calculates grid-step distance between two coordinates for tile movement estimates."
	operation = "manhattan"

/obj/item/integrated_circuit/math/geometry/chebyshev
	name = "chebyshev distance circuit"
	desc = "Calculates maximum-axis tile distance for simple range gates and square sensor zones."
	operation = "chebyshev"

/obj/item/integrated_circuit/math/geometry/slope
	name = "slope circuit"
	desc = "Calculates rise over run between two coordinates for directional trend displays."
	operation = "slope"

/obj/item/integrated_circuit/math/geometry/angle_between_points
	name = "angle between points circuit"
	desc = "Calculates a heading from one coordinate to another for directional displays or aiming logic."
	operation = "angle"

/obj/item/integrated_circuit/math/geometry/circle_area
	name = "circle area circuit"
	desc = "Calculates circle area from radius."
	inputs = list("radius" = IC_PINTYPE_NUMBER)
	operation = "circle_area"

/obj/item/integrated_circuit/math/geometry/circle_circumference
	name = "circle circumference circuit"
	desc = "Calculates circle circumference from radius."
	inputs = list("radius" = IC_PINTYPE_NUMBER)
	operation = "circle_circumference"

/obj/item/integrated_circuit/math/geometry/rectangle_area
	name = "rectangle area circuit"
	desc = "Calculates rectangle area."
	inputs = list("width" = IC_PINTYPE_NUMBER, "height" = IC_PINTYPE_NUMBER)
	operation = "rectangle_area"

/obj/item/integrated_circuit/math/geometry/box_volume
	name = "box volume circuit"
	desc = "Calculates box volume."
	inputs = list("width" = IC_PINTYPE_NUMBER, "height" = IC_PINTYPE_NUMBER, "depth" = IC_PINTYPE_NUMBER)
	operation = "box_volume"

/obj/item/integrated_circuit/math/geometry/sphere_volume
	name = "sphere volume circuit"
	desc = "Calculates sphere volume from radius."
	inputs = list("radius" = IC_PINTYPE_NUMBER)
	operation = "sphere_volume"

// List math and statistics.
/obj/item/integrated_circuit/math/list
	category_text = "MATH - List Math"
	inputs = list("list A" = IC_PINTYPE_LIST, "list B" = IC_PINTYPE_LIST)
	outputs = list(
		"result" = IC_PINTYPE_LIST,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 5

/obj/item/integrated_circuit/math/list/do_work()
	var/list/A = get_pin_data(IC_INPUT, 1)
	var/list/B = get_pin_data(IC_INPUT, 2)
	var/N = get_pin_data(IC_INPUT, 3)

	if(operation == "add" || operation == "subtract" || operation == "multiply" || operation == "divide")
		if(!ic_math_same_length_lists(A, B))
			fail("Mismatched or invalid lists")
			return
		var/list_length = length(A)
		var/list/result = list()
		for(var/i = 1 to list_length)
			var/a = A[i]
			var/b = B[i]
			if(!isnum(a) || !isnum(b) || (operation == "divide" && b == 0))
				fail("Invalid numeric entry")
				return
			switch(operation)
				if("add")
					result += a + b
				if("subtract")
					result += a - b
				if("multiply")
					result += a * b
				if("divide")
					result += a / b
		succeed(result)
		return

	var/list/numbers = ic_math_numeric_list(A)
	if(!numbers)
		fail("Invalid numeric list")
		return

	switch(operation)
		if("clamp")
			var/minimum = get_pin_data(IC_INPUT, 2)
			var/maximum = get_pin_data(IC_INPUT, 3)
			if(!isnum(minimum) || !isnum(maximum))
				fail()
				return
			var/list/result = list()
			for(var/value in numbers)
				result += clamp(value, minimum, maximum)
			succeed(result)
		if("abs")
			var/list/result = list()
			for(var/value in numbers)
				result += abs(value)
			succeed(result)
		if("normalize")
			var/minimum = min(numbers)
			var/maximum = max(numbers)
			if(maximum == minimum)
				fail("Flat list")
				return
			var/list/result = list()
			for(var/value in numbers)
				result += (value - minimum) / (maximum - minimum)
			succeed(result)
		if("moving_average")
			if(!isnum(N) || N < 1)
				fail("Invalid window")
				return
			N = round(N)
			var/list_length = length(numbers)
			var/list/result = list()
			for(var/i = 1 to list_length)
				var/start = max(1, i - N + 1)
				var/total = 0
				var/count = 0
				for(var/j = start to i)
					total += numbers[j]
					count++
				result += total / count
			succeed(result)
		else
			fail("Unknown operation")

/obj/item/integrated_circuit/math/list/list_add
	name = "list add circuit"
	desc = "Adds two matching numeric lists element by element, useful for combining sensor vectors or target scores."
	operation = "add"

/obj/item/integrated_circuit/math/list/list_subtract
	name = "list subtract circuit"
	desc = "Subtracts matching numeric lists element by element, useful for deltas between sensor samples."
	operation = "subtract"

/obj/item/integrated_circuit/math/list/list_multiply
	name = "list multiply circuit"
	desc = "Multiplies matching numeric lists element by element, useful for applying per-target weights."
	operation = "multiply"

/obj/item/integrated_circuit/math/list/list_divide
	name = "list divide circuit"
	desc = "Divides matching numeric lists element by element, useful for ratios or normalized sensor comparisons."
	operation = "divide"

/obj/item/integrated_circuit/math/list/list_clamp
	name = "list clamp circuit"
	desc = "Clamps every numeric value in a list for bounded sensor displays or threat scores."
	inputs = list("list" = IC_PINTYPE_LIST, "minimum" = IC_PINTYPE_NUMBER, "maximum" = IC_PINTYPE_NUMBER)
	operation = "clamp"

/obj/item/integrated_circuit/math/list/list_absolute
	name = "list absolute value circuit"
	desc = "Returns absolute values for every number in a list, useful for error magnitudes and sensor deltas."
	inputs = list("list" = IC_PINTYPE_LIST)
	operation = "abs"

/obj/item/integrated_circuit/math/list/list_normalize
	name = "list normalize circuit"
	desc = "Scales a numeric list to 0-1 for target scoring, display bars, and weighted selection."
	inputs = list("list" = IC_PINTYPE_LIST)
	operation = "normalize"

/obj/item/integrated_circuit/math/list/moving_average
	name = "moving average circuit"
	desc = "Smooths a numeric sample list for stable sensor displays and non-jittery alarms."
	category_text = "MATH - Statistics"
	inputs = list("samples" = IC_PINTYPE_LIST, "window" = IC_PINTYPE_NUMBER)
	operation = "moving_average"

/obj/item/integrated_circuit/math/statistics
	category_text = "MATH - Statistics"
	inputs = list("list" = IC_PINTYPE_LIST)
	outputs = list(
		"result" = IC_PINTYPE_NUMBER,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 5

/obj/item/integrated_circuit/math/statistics/do_work()
	var/list/input = get_pin_data(IC_INPUT, 1)
	var/list/numbers = ic_math_numeric_list(input)
	if(operation != "count" && !numbers)
		fail("Invalid numeric list")
		return

	switch(operation)
		if("count")
			if(!islist(input) || length(input) > IC_MATH_LIST_LIMIT)
				fail("Invalid list")
				return
			succeed(length(input))
		if("sum")
			succeed(ic_math_sum(numbers))
		if("mean")
			succeed(ic_math_mean(numbers))
		if("median")
			succeed(ic_math_median(numbers))
		if("mode")
			succeed(ic_math_mode(numbers))
		if("min")
			succeed(min(numbers))
		if("max")
			succeed(max(numbers))
		if("range")
			succeed(max(numbers) - min(numbers))
		if("variance")
			succeed(ic_math_variance(numbers))
		if("stdev")
			succeed(sqrt(ic_math_variance(numbers)))
		if("percentile")
			var/percentile = get_pin_data(IC_INPUT, 2)
			var/result = ic_math_percentile(numbers, percentile)
			if(isnull(result))
				fail("Invalid percentile")
				return
			succeed(result)
		if("index_min")
			succeed(numbers.Find(min(numbers)))
		if("index_max")
			succeed(numbers.Find(max(numbers)))
		if("weighted_average")
			var/list/weights = ic_math_numeric_list(get_pin_data(IC_INPUT, 2))
			var/list_length = length(numbers)
			if(!weights || length(weights) != list_length)
				fail("Invalid weights")
				return
			var/weighted_total = 0
			var/weight_total = 0
			for(var/i = 1 to list_length)
				weighted_total += numbers[i] * weights[i]
				weight_total += weights[i]
			if(weight_total == 0)
				fail("Zero weight")
				return
			succeed(weighted_total / weight_total)

/obj/item/integrated_circuit/math/statistics/count
	name = "count circuit"
	desc = "Counts list entries for target lists, sample buffers, and queue monitors."
	operation = "count"

/obj/item/integrated_circuit/math/statistics/sum
	name = "sum circuit"
	desc = "Sums numeric samples for total exposure, resource use, or combined score."
	operation = "sum"

/obj/item/integrated_circuit/math/statistics/mean
	name = "mean circuit"
	desc = "Averages sensor samples for stable displays and threshold checks."
	operation = "mean"

/obj/item/integrated_circuit/math/statistics/median
	name = "median circuit"
	desc = "Finds the median sample, useful for rejecting one-off sensor spikes."
	operation = "median"

/obj/item/integrated_circuit/math/statistics/mode
	name = "mode circuit"
	desc = "Calculates the mode of a numeric list."
	operation = "mode"

/obj/item/integrated_circuit/math/statistics/minimum
	name = "minimum of list circuit"
	desc = "Finds the smallest sample or best low-score target in a numeric list."
	operation = "min"

/obj/item/integrated_circuit/math/statistics/maximum
	name = "maximum of list circuit"
	desc = "Finds the largest sample or strongest target score in a numeric list."
	operation = "max"

/obj/item/integrated_circuit/math/statistics/range
	name = "range circuit"
	desc = "Measures spread between samples for anomaly, noise, or instability detection."
	operation = "range"

/obj/item/integrated_circuit/math/statistics/variance
	name = "variance circuit"
	desc = "Measures sample volatility for unstable sensors, radiation bursts, or target score spread."
	operation = "variance"

/obj/item/integrated_circuit/math/statistics/standard_deviation
	name = "standard deviation circuit"
	desc = "Measures typical sensor noise or target-score spread."
	operation = "stdev"

/obj/item/integrated_circuit/math/statistics/percentile
	name = "percentile circuit"
	desc = "Calculates a percentile for robust environmental thresholds or ranked target scores."
	inputs = list("list" = IC_PINTYPE_LIST, "percentile" = IC_PINTYPE_NUMBER)
	operation = "percentile"

/obj/item/integrated_circuit/math/statistics/index_minimum
	name = "index of minimum circuit"
	desc = "Returns the list position of the smallest value for target cycling or lowest reading selection."
	operation = "index_min"

/obj/item/integrated_circuit/math/statistics/index_maximum
	name = "index of maximum circuit"
	desc = "Returns the list position of the largest value for target cycling or hotspot selection."
	operation = "index_max"

/obj/item/integrated_circuit/math/statistics/weighted_average
	name = "weighted average circuit"
	desc = "Combines values with matching weights for target scoring and sensor fusion."
	inputs = list("values" = IC_PINTYPE_LIST, "weights" = IC_PINTYPE_LIST)
	operation = "weighted_average"

// Vector and matrix operations.
/obj/item/integrated_circuit/math/vector
	category_text = "MATH - Vector"
	inputs = list("vector A" = IC_PINTYPE_LIST, "vector B" = IC_PINTYPE_LIST)
	outputs = list(
		"result" = IC_PINTYPE_LIST,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 5

/obj/item/integrated_circuit/math/vector/do_work()
	var/list/A = ic_math_numeric_list(get_pin_data(IC_INPUT, 1), IC_MATH_VECTOR_LIMIT)
	var/list/B = ic_math_numeric_list(get_pin_data(IC_INPUT, 2), IC_MATH_VECTOR_LIMIT)
	var/N = get_pin_data(IC_INPUT, 2)

	switch(operation)
		if("create2")
			var/x = get_pin_data(IC_INPUT, 1)
			var/y = get_pin_data(IC_INPUT, 2)
			if(!isnum(x) || !isnum(y))
				fail()
				return
			succeed(list(x, y))
		if("create3")
			var/x = get_pin_data(IC_INPUT, 1)
			var/y = get_pin_data(IC_INPUT, 2)
			var/z = get_pin_data(IC_INPUT, 3)
			if(!isnum(x) || !isnum(y) || !isnum(z))
				fail()
				return
			succeed(list(x, y, z))
		if("add", "subtract", "dot")
			if(!A || !B || length(A) != length(B))
				fail("Mismatched vectors")
				return
			var/vector_length = length(A)
			if(operation == "dot")
				var/result = 0
				for(var/i = 1 to vector_length)
					result += A[i] * B[i]
				succeed(result)
				return
			var/list/result = list()
			for(var/i = 1 to vector_length)
				result += operation == "add" ? A[i] + B[i] : A[i] - B[i]
			succeed(result)
		if("scale")
			if(!A || !isnum(N))
				fail()
				return
			var/list/result = list()
			for(var/value in A)
				result += value * N
			succeed(result)
		if("magnitude")
			if(!A)
				fail()
				return
			succeed(ic_math_vector_magnitude(A))
		if("magnitude_sq")
			if(!A)
				fail()
				return
			var/result = 0
			for(var/value in A)
				result += value * value
			succeed(result)
		if("normalize")
			if(!A)
				fail()
				return
			var/magnitude = ic_math_vector_magnitude(A)
			if(magnitude == 0)
				fail("Zero vector")
				return
			var/list/result = list()
			for(var/value in A)
				result += value / magnitude
			succeed(result)
		if("cross")
			if(!A || !B || length(A) != 3 || length(B) != 3)
				fail("Requires 3D vectors")
				return
			succeed(list((A[2] * B[3]) - (A[3] * B[2]), (A[3] * B[1]) - (A[1] * B[3]), (A[1] * B[2]) - (A[2] * B[1])))
		if("cross2")
			if(!A || !B || length(A) != 2 || length(B) != 2)
				fail("Requires 2D vectors")
				return
			succeed((A[1] * B[2]) - (A[2] * B[1]))
		if("angle")
			if(!A || !B || length(A) != length(B))
				fail("Mismatched vectors")
				return
			var/vector_length = length(A)
			var/dot = 0
			for(var/i = 1 to vector_length)
				dot += A[i] * B[i]
			var/mag = ic_math_vector_magnitude(A) * ic_math_vector_magnitude(B)
			if(mag == 0)
				fail("Zero vector")
				return
			succeed(arccos(clamp(dot / mag, -1, 1)))
		if("projection")
			if(!A || !B || length(A) != length(B))
				fail("Mismatched vectors")
				return
			var/vector_length = length(A)
			var/dot_ab = 0
			var/dot_bb = 0
			for(var/i = 1 to vector_length)
				dot_ab += A[i] * B[i]
				dot_bb += B[i] * B[i]
			if(dot_bb == 0)
				fail("Zero vector")
				return
			var/scale = dot_ab / dot_bb
			var/list/result = list()
			for(var/value in B)
				result += value * scale
			succeed(result)
		if("clamp_magnitude")
			var/max_magnitude = get_pin_data(IC_INPUT, 2)
			if(!A || !isnum(max_magnitude) || max_magnitude < 0)
				fail()
				return
			var/magnitude = ic_math_vector_magnitude(A)
			if(magnitude <= max_magnitude)
				succeed(A.Copy())
				return
			var/list/result = list()
			for(var/value in A)
				result += value / magnitude * max_magnitude
			succeed(result)

/obj/item/integrated_circuit/math/vector/create2
	name = "vector create 2D circuit"
	desc = "Creates a 2D vector from relative X/Y values for movement, aiming, or field sampling."
	inputs = list("relative x" = IC_PINTYPE_NUMBER, "relative y" = IC_PINTYPE_NUMBER)
	operation = "create2"

/obj/item/integrated_circuit/math/vector/create3
	name = "vector create 3D circuit"
	desc = "Creates a 3D vector for coordinate deltas or multi-sensor values."
	inputs = list("x" = IC_PINTYPE_NUMBER, "y" = IC_PINTYPE_NUMBER, "z" = IC_PINTYPE_NUMBER)
	operation = "create3"

/obj/item/integrated_circuit/math/vector/add
	name = "vector add circuit"
	desc = "Adds two vectors for offset movement, steering, or combined sensor direction."
	operation = "add"

/obj/item/integrated_circuit/math/vector/subtract
	name = "vector subtract circuit"
	desc = "Subtracts vectors to get relative movement, target offsets, or sample deltas."
	operation = "subtract"

/obj/item/integrated_circuit/math/vector/scale
	name = "vector scale circuit"
	desc = "Scales a movement or sensor vector by a numeric strength."
	inputs = list("vector" = IC_PINTYPE_LIST, "scale" = IC_PINTYPE_NUMBER)
	operation = "scale"

/obj/item/integrated_circuit/math/vector/magnitude
	name = "vector magnitude circuit"
	desc = "Calculates vector length for distance, signal strength, or movement error."
	inputs = list("vector" = IC_PINTYPE_LIST)
	operation = "magnitude"

/obj/item/integrated_circuit/math/vector/magnitude_squared
	name = "vector magnitude squared circuit"
	desc = "Calculates squared vector length for cheap target-distance comparisons."
	inputs = list("vector" = IC_PINTYPE_LIST)
	operation = "magnitude_sq"

/obj/item/integrated_circuit/math/vector/normalize
	name = "vector normalize circuit"
	desc = "Turns a movement or gradient vector into a unit direction."
	inputs = list("vector" = IC_PINTYPE_LIST)
	operation = "normalize"

/obj/item/integrated_circuit/math/vector/dot
	name = "dot product circuit"
	desc = "Scores how closely two directions align for targeting, following, and field checks."
	outputs = list("result" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	operation = "dot"

/obj/item/integrated_circuit/math/vector/cross
	name = "cross product circuit"
	desc = "Calculates a 3D perpendicular vector for advanced orientation logic."
	operation = "cross"

/obj/item/integrated_circuit/math/vector/cross2
	name = "2D scalar cross product circuit"
	desc = "Calculates 2D turn direction, useful for left/right steering decisions."
	outputs = list("result" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	operation = "cross2"

/obj/item/integrated_circuit/math/vector/angle
	name = "angle between vectors circuit"
	desc = "Calculates angle between two vectors for aim error or heading difference."
	outputs = list("result" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	operation = "angle"

/obj/item/integrated_circuit/math/vector/projection
	name = "projection circuit"
	desc = "Projects one vector onto another to measure progress along a route or sensor axis."
	operation = "projection"

/obj/item/integrated_circuit/math/vector/clamp_magnitude
	name = "vector clamp magnitude circuit"
	desc = "Limits movement or control vector strength without changing direction."
	inputs = list("vector" = IC_PINTYPE_LIST, "maximum magnitude" = IC_PINTYPE_NUMBER)
	operation = "clamp_magnitude"

/obj/item/integrated_circuit/math/matrix
	category_text = "MATH - Matrix"
	inputs = list("matrix A" = IC_PINTYPE_LIST, "matrix B" = IC_PINTYPE_LIST)
	outputs = list("result" = IC_PINTYPE_LIST, "status" = IC_PINTYPE_STRING)
	complexity = 8

/obj/item/integrated_circuit/math/matrix/do_work()
	var/list/A = ic_math_matrix(get_pin_data(IC_INPUT, 1))
	var/list/B = ic_math_matrix(get_pin_data(IC_INPUT, 2))

	switch(operation)
		if("add", "subtract")
			if(!A || !B || length(A) != length(B) || length(A[1]) != length(B[1]))
				fail("Mismatched matrices")
				return
			var/list/result = list()
			for(var/y = 1 to length(A))
				var/list/row = list()
				for(var/x = 1 to length(A[y]))
					row += operation == "add" ? A[y][x] + B[y][x] : A[y][x] - B[y][x]
				result += list(row)
			succeed(result)
		if("multiply")
			if(!A || !B || length(A[1]) != length(B))
				fail("Dimension mismatch")
				return
			var/list/result = list()
			for(var/y = 1 to length(A))
				var/list/row = list()
				for(var/x = 1 to length(B[1]))
					var/value = 0
					for(var/k = 1 to length(B))
						value += A[y][k] * B[k][x]
					row += value
				result += list(row)
			succeed(result)
		if("matrix_vector")
			var/list/vector = ic_math_numeric_list(get_pin_data(IC_INPUT, 2), IC_MATH_VECTOR_LIMIT)
			if(!A || !vector || length(A[1]) != length(vector))
				fail("Dimension mismatch")
				return
			var/list/result = list()
			for(var/y = 1 to length(A))
				var/value = 0
				for(var/x = 1 to length(vector))
					value += A[y][x] * vector[x]
				result += value
			succeed(result)
		if("transpose")
			if(!A)
				fail()
				return
			var/list/result = list()
			for(var/x = 1 to length(A[1]))
				var/list/row = list()
				for(var/y = 1 to length(A))
					row += A[y][x]
				result += list(row)
			succeed(result)
		if("identity")
			var/size = get_pin_data(IC_INPUT, 1)
			if(!isnum(size) || size < 1 || size > IC_MATH_MATRIX_LIMIT)
				fail("Invalid size")
				return
			size = round(size)
			var/list/result = list()
			for(var/y = 1 to size)
				var/list/row = list()
				for(var/x = 1 to size)
					row += x == y ? 1 : 0
				result += list(row)
			succeed(result)
		if("det2")
			if(!A || length(A) != 2 || length(A[1]) != 2)
				fail("Requires 2x2")
				return
			succeed((A[1][1] * A[2][2]) - (A[1][2] * A[2][1]))
		if("det3")
			if(!A || length(A) != 3 || length(A[1]) != 3)
				fail("Requires 3x3")
				return
			var/result = A[1][1] * ((A[2][2] * A[3][3]) - (A[2][3] * A[3][2]))
			result -= A[1][2] * ((A[2][1] * A[3][3]) - (A[2][3] * A[3][1]))
			result += A[1][3] * ((A[2][1] * A[3][2]) - (A[2][2] * A[3][1]))
			succeed(result)
		if("inverse2")
			if(!A || length(A) != 2 || length(A[1]) != 2)
				fail("Requires 2x2")
				return
			var/determinant = (A[1][1] * A[2][2]) - (A[1][2] * A[2][1])
			if(determinant == 0)
				fail("Singular matrix")
				return
			succeed(list(list(A[2][2] / determinant, -A[1][2] / determinant), list(-A[2][1] / determinant, A[1][1] / determinant)))
		if("rotation2")
			var/angle = get_pin_data(IC_INPUT, 1)
			if(!isnum(angle))
				fail()
				return
			succeed(list(list(cos(angle), -sin(angle)), list(sin(angle), cos(angle))))

/obj/item/integrated_circuit/math/matrix/add
	name = "matrix add circuit"
	desc = "Adds two matrices."
	operation = "add"

/obj/item/integrated_circuit/math/matrix/subtract
	name = "matrix subtract circuit"
	desc = "Subtracts two matrices."
	operation = "subtract"

/obj/item/integrated_circuit/math/matrix/multiply
	name = "matrix multiply circuit"
	desc = "Combines numeric transforms for compact coordinate, grid, or vector processing."
	operation = "multiply"

/obj/item/integrated_circuit/math/matrix/vector_multiply
	name = "matrix vector multiply circuit"
	desc = "Applies a matrix transform to a vector for rotation, scaling, or coordinate conversion."
	inputs = list("matrix" = IC_PINTYPE_LIST, "vector" = IC_PINTYPE_LIST)
	operation = "matrix_vector"

/obj/item/integrated_circuit/math/matrix/transpose
	name = "transpose circuit"
	desc = "Swaps matrix rows and columns for grid reorientation and row/column inspection."
	inputs = list("matrix" = IC_PINTYPE_LIST)
	operation = "transpose"

/obj/item/integrated_circuit/math/matrix/identity
	name = "identity matrix circuit"
	desc = "Creates a neutral matrix transform for building or testing matrix chains."
	inputs = list("size" = IC_PINTYPE_NUMBER)
	operation = "identity"

/obj/item/integrated_circuit/math/matrix/determinant2
	name = "determinant 2x2 circuit"
	desc = "Calculates a 2x2 determinant."
	inputs = list("matrix" = IC_PINTYPE_LIST)
	outputs = list("result" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	operation = "det2"

/obj/item/integrated_circuit/math/matrix/determinant3
	name = "determinant 3x3 circuit"
	desc = "Calculates a 3x3 determinant."
	inputs = list("matrix" = IC_PINTYPE_LIST)
	outputs = list("result" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	operation = "det3"

/obj/item/integrated_circuit/math/matrix/inverse2
	name = "inverse 2x2 circuit"
	desc = "Calculates a 2x2 inverse matrix."
	inputs = list("matrix" = IC_PINTYPE_LIST)
	operation = "inverse2"

/obj/item/integrated_circuit/math/matrix/rotation2
	name = "2D rotation transform circuit"
	desc = "Creates a 2D rotation matrix from degrees for rotating movement or target vectors."
	inputs = list("angle" = IC_PINTYPE_NUMBER)
	operation = "rotation2"

/obj/item/integrated_circuit/math/matrix/from_rows
	name = "matrix from rows circuit"
	desc = "Builds a numeric matrix from row lists for transform, grid, and display circuits."
	inputs = list(
		"row 1" = IC_PINTYPE_LIST,
		"row 2" = IC_PINTYPE_LIST,
		"row 3" = IC_PINTYPE_LIST,
		"row 4" = IC_PINTYPE_LIST
	)
	outputs = list(
		"matrix" = IC_PINTYPE_LIST,
		"rows" = IC_PINTYPE_NUMBER,
		"columns" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 6
	operation = "from_rows"

/obj/item/integrated_circuit/math/matrix/from_rows/do_work()
	var/list/matrix = list()

	for(var/i = 1 to IC_MATH_MATRIX_LIMIT)
		var/list/row = get_pin_data(IC_INPUT, i)
		if(!islist(row))
			continue
		matrix += list(row)

	matrix = ic_math_matrix(matrix)
	if(!matrix)
		set_pin_data(IC_OUTPUT, 4, FALSE)
		set_pin_data(IC_OUTPUT, 5, "Invalid matrix")
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, matrix)
	set_pin_data(IC_OUTPUT, 2, length(matrix))
	set_pin_data(IC_OUTPUT, 3, length(matrix[1]))
	set_pin_data(IC_OUTPUT, 4, TRUE)
	set_pin_data(IC_OUTPUT, 5, "OK")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/math/matrix/from_flat_list
	name = "matrix from flat list circuit"
	desc = "Builds a numeric matrix from flat samples plus row and column counts."
	inputs = list(
		"values" = IC_PINTYPE_LIST,
		"rows" = IC_PINTYPE_NUMBER,
		"columns" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"matrix" = IC_PINTYPE_LIST,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 6
	operation = "from_flat_list"

/obj/item/integrated_circuit/math/matrix/from_flat_list/do_work()
	var/list/values = ic_math_numeric_list(get_pin_data(IC_INPUT, 1), IC_MATH_MATRIX_LIMIT * IC_MATH_MATRIX_LIMIT)
	var/rows = round(get_pin_data(IC_INPUT, 2))
	var/columns = round(get_pin_data(IC_INPUT, 3))

	if(!values || !isnum(rows) || !isnum(columns) || rows < 1 || rows > IC_MATH_MATRIX_LIMIT || columns < 1 || columns > IC_MATH_MATRIX_LIMIT || length(values) != rows * columns)
		set_pin_data(IC_OUTPUT, 2, FALSE)
		set_pin_data(IC_OUTPUT, 3, "Invalid matrix dimensions")
		push_data()
		activate_pin(3)
		return

	var/list/matrix = list()
	var/index = 1
	for(var/y = 1 to rows)
		var/list/row = list()
		for(var/x = 1 to columns)
			row += values[index++]
		matrix += list(row)

	set_pin_data(IC_OUTPUT, 1, matrix)
	set_pin_data(IC_OUTPUT, 2, TRUE)
	set_pin_data(IC_OUTPUT, 3, "OK")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/math/matrix/validator
	name = "matrix validator circuit"
	desc = "Checks whether a matrix is valid before feeding it into transforms or displays."
	inputs = list("matrix" = IC_PINTYPE_LIST)
	outputs = list(
		"valid" = IC_PINTYPE_BOOLEAN,
		"rows" = IC_PINTYPE_NUMBER,
		"columns" = IC_PINTYPE_NUMBER,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 3
	operation = "validator"

/obj/item/integrated_circuit/math/matrix/validator/do_work()
	var/list/dimensions = ic_math_matrix_dimensions(get_pin_data(IC_INPUT, 1))

	if(!dimensions)
		set_pin_data(IC_OUTPUT, 1, FALSE)
		set_pin_data(IC_OUTPUT, 2, 0)
		set_pin_data(IC_OUTPUT, 3, 0)
		set_pin_data(IC_OUTPUT, 4, "Invalid matrix")
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, TRUE)
	set_pin_data(IC_OUTPUT, 2, dimensions[1])
	set_pin_data(IC_OUTPUT, 3, dimensions[2])
	set_pin_data(IC_OUTPUT, 4, "OK")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/math/matrix/set_element
	name = "matrix element writer circuit"
	desc = "Writes one reading or transform value into a copied matrix at a row and column."
	inputs = list(
		"matrix" = IC_PINTYPE_LIST,
		"row" = IC_PINTYPE_NUMBER,
		"column" = IC_PINTYPE_NUMBER,
		"value" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"matrix" = IC_PINTYPE_LIST,
		"changed" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 5
	operation = "set_element"

/obj/item/integrated_circuit/math/matrix/set_element/do_work()
	var/list/matrix = ic_math_matrix(get_pin_data(IC_INPUT, 1))
	var/row_index = round(get_pin_data(IC_INPUT, 2))
	var/column_index = round(get_pin_data(IC_INPUT, 3))
	var/value = get_pin_data(IC_INPUT, 4)

	if(!matrix || !isnum(row_index) || !isnum(column_index) || !isnum(value) || row_index < 1 || row_index > length(matrix) || column_index < 1 || column_index > length(matrix[1]))
		set_pin_data(IC_OUTPUT, 2, FALSE)
		set_pin_data(IC_OUTPUT, 3, "Invalid element")
		push_data()
		activate_pin(3)
		return

	var/list/row = matrix[row_index]
	row[column_index] = value

	set_pin_data(IC_OUTPUT, 1, matrix)
	set_pin_data(IC_OUTPUT, 2, TRUE)
	set_pin_data(IC_OUTPUT, 3, "OK")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/math/matrix/read_element
	name = "matrix element reader circuit"
	desc = "Reads one matrix cell for displays, thresholds, or selected grid values."
	inputs = list(
		"matrix" = IC_PINTYPE_LIST,
		"row" = IC_PINTYPE_NUMBER,
		"column" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"value" = IC_PINTYPE_NUMBER,
		"found" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 3
	operation = "read_element"

/obj/item/integrated_circuit/math/matrix/read_element/do_work()
	var/list/matrix = ic_math_matrix(get_pin_data(IC_INPUT, 1))
	var/row_index = round(get_pin_data(IC_INPUT, 2))
	var/column_index = round(get_pin_data(IC_INPUT, 3))

	if(!matrix || !isnum(row_index) || !isnum(column_index) || row_index < 1 || row_index > length(matrix) || column_index < 1 || column_index > length(matrix[1]))
		set_pin_data(IC_OUTPUT, 2, FALSE)
		set_pin_data(IC_OUTPUT, 3, "Invalid element")
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, matrix[row_index][column_index])
	set_pin_data(IC_OUTPUT, 2, TRUE)
	set_pin_data(IC_OUTPUT, 3, "OK")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/math/matrix/to_text
	name = "matrix to text circuit"
	desc = "Converts a numeric matrix into compact display text for debugging transforms and grids."
	inputs = list("matrix" = IC_PINTYPE_LIST)
	outputs = list(
		"text" = IC_PINTYPE_STRING,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 4
	operation = "to_text"

/obj/item/integrated_circuit/math/matrix/to_text/do_work()
	var/text = ic_math_matrix_to_text(get_pin_data(IC_INPUT, 1), MAX_MESSAGE_LEN)

	if(isnull(text))
		set_pin_data(IC_OUTPUT, 2, "Invalid matrix")
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, text)
	set_pin_data(IC_OUTPUT, 2, length(text) >= MAX_MESSAGE_LEN - 3 ? "Truncated" : "OK")
	push_data()
	activate_pin(2)

// Calculus and interpolation.
/obj/item/integrated_circuit/math/calculus
	category_text = "MATH - Calculus"
	inputs = list("A" = IC_PINTYPE_NUMBER, "B" = IC_PINTYPE_NUMBER, "C" = IC_PINTYPE_NUMBER)
	outputs = list("result" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	complexity = 5

/obj/item/integrated_circuit/math/calculus/do_work()
	var/A = get_pin_data(IC_INPUT, 1)
	var/B = get_pin_data(IC_INPUT, 2)
	var/C = get_pin_data(IC_INPUT, 3)
	var/D = get_pin_data(IC_INPUT, 4)
	var/E = get_pin_data(IC_INPUT, 5)

	switch(operation)
		if("difference")
			if(!isnum(A) || !isnum(B))
				fail()
				return
			succeed(A - B)
		if("derivative")
			if(!isnum(A) || !isnum(B) || !isnum(C) || C == 0)
				fail("Invalid delta time")
				return
			succeed((A - B) / C)
		if("second_derivative")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D) || D == 0)
				fail("Invalid delta time")
				return
			succeed((A - (2 * B) + C) / (D * D))
		if("average_rate")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D) || D == C)
				fail("Invalid interval")
				return
			succeed((B - A) / (D - C))
		if("integral", "trapezoid")
			var/list/samples = ic_math_numeric_list(get_pin_data(IC_INPUT, 1))
			var/delta = get_pin_data(IC_INPUT, 2)
			if(!samples || !isnum(delta))
				fail()
				return
			var/result = 0
			if(operation == "integral")
				result = ic_math_sum(samples) * delta
			else
				if(length(samples) < 2)
					fail("Too few samples")
					return
				for(var/i = 1 to length(samples) - 1)
					result += ((samples[i] + samples[i + 1]) / 2) * delta
			succeed(result)
		if("running_integral")
			if(!isnum(A) || !isnum(B) || !isnum(C))
				fail()
				return
			succeed(B + (A * C))
		if("threshold")
			if(!isnum(A) || !isnum(B) || !isnum(C))
				fail()
				return
			succeed((B < C && A >= C) || (B > C && A <= C))
		if("hysteresis")
			if(!isnum(A) || !isnum(B) || !isnum(C) || C < B)
				fail()
				return
			var/previous_state = get_pin_data(IC_INPUT, 4)
			if(A >= C)
				succeed(TRUE)
				return
			if(A <= B)
				succeed(FALSE)
				return
			succeed(previous_state ? TRUE : FALSE)
		if("linear_interpolation", "lerp")
			if(!isnum(A) || !isnum(B) || !isnum(C))
				fail()
				return
			succeed(A + ((B - A) * C))
		if("inverse_lerp")
			if(!isnum(A) || !isnum(B) || !isnum(C) || B == A)
				fail()
				return
			succeed((C - A) / (B - A))
		if("remap")
			if(!isnum(A) || !isnum(B) || !isnum(C) || !isnum(D) || !isnum(E) || C == B)
				fail()
				return
			succeed(D + ((A - B) / (C - B)) * (E - D))
		if("smoothstep")
			if(!isnum(A) || !isnum(B) || !isnum(C) || B == A)
				fail()
				return
			var/t = clamp((C - A) / (B - A), 0, 1)
			succeed(t * t * (3 - (2 * t)))
		if("exp_smoothing")
			if(!isnum(A) || !isnum(B) || !isnum(C))
				fail()
				return
			C = clamp(C, 0, 1)
			succeed((C * A) + ((1 - C) * B))

/obj/item/integrated_circuit/math/calculus/derivative
	name = "derivative approximation circuit"
	desc = "Calculates rate of change so circuits can detect rapidly rising or falling sensor values."
	inputs = list("current" = IC_PINTYPE_NUMBER, "previous" = IC_PINTYPE_NUMBER, "delta time" = IC_PINTYPE_NUMBER)
	operation = "derivative"

/obj/item/integrated_circuit/math/calculus/difference
	name = "difference circuit"
	desc = "Outputs current minus previous for simple rising/falling sensor checks."
	inputs = list("current" = IC_PINTYPE_NUMBER, "previous" = IC_PINTYPE_NUMBER)
	operation = "difference"

/obj/item/integrated_circuit/math/calculus/second_derivative
	name = "second derivative approximation circuit"
	desc = "Calculates changing rate of change for acceleration-like trends in sensors or movement."
	inputs = list("current" = IC_PINTYPE_NUMBER, "previous" = IC_PINTYPE_NUMBER, "older" = IC_PINTYPE_NUMBER, "delta time" = IC_PINTYPE_NUMBER)
	operation = "second_derivative"

/obj/item/integrated_circuit/math/calculus/average_rate
	name = "average rate of change circuit"
	desc = "Calculates average change over an interval for logged sensor or distance readings."
	inputs = list("start value" = IC_PINTYPE_NUMBER, "end value" = IC_PINTYPE_NUMBER, "start time" = IC_PINTYPE_NUMBER, "end time" = IC_PINTYPE_NUMBER)
	operation = "average_rate"

/obj/item/integrated_circuit/math/calculus/integral
	name = "integral approximation from samples circuit"
	desc = "Totals a sample list over time for accumulated exposure, dose, or resource use."
	inputs = list("samples" = IC_PINTYPE_LIST, "delta" = IC_PINTYPE_NUMBER)
	operation = "integral"

/obj/item/integrated_circuit/math/calculus/running_integral
	name = "running integral circuit"
	desc = "Adds current value times delta to a previous total for exposure, dose, and accumulated resource tracking."
	inputs = list("current value" = IC_PINTYPE_NUMBER, "previous total" = IC_PINTYPE_NUMBER, "delta" = IC_PINTYPE_NUMBER)
	operation = "running_integral"

/obj/item/integrated_circuit/math/calculus/trapezoid
	name = "trapezoidal integral circuit"
	desc = "Totals a changing sample list more smoothly for accumulated exposure or environmental dose."
	inputs = list("samples" = IC_PINTYPE_LIST, "delta" = IC_PINTYPE_NUMBER)
	operation = "trapezoid"

/obj/item/integrated_circuit/math/calculus/threshold
	name = "threshold crossing detector circuit"
	desc = "Pulsed detector for sensor values crossing a threshold in either direction."
	inputs = list("current" = IC_PINTYPE_NUMBER, "previous" = IC_PINTYPE_NUMBER, "threshold" = IC_PINTYPE_NUMBER)
	outputs = list("crossed" = IC_PINTYPE_BOOLEAN, "status" = IC_PINTYPE_STRING)
	operation = "threshold"

/obj/item/integrated_circuit/math/calculus/hysteresis
	name = "hysteresis circuit"
	desc = "Keeps alarms and controllers from flickering by switching on at a high threshold and off at a low threshold."
	inputs = list("value" = IC_PINTYPE_NUMBER, "off threshold" = IC_PINTYPE_NUMBER, "on threshold" = IC_PINTYPE_NUMBER, "previous state" = IC_PINTYPE_BOOLEAN)
	outputs = list("state" = IC_PINTYPE_BOOLEAN, "status" = IC_PINTYPE_STRING)
	operation = "hysteresis"

/obj/item/integrated_circuit/math/calculus/linear_interpolation
	name = "linear interpolation circuit"
	desc = "Blends between two values for smooth displays, servo-like controls, or target prediction."
	inputs = list("start" = IC_PINTYPE_NUMBER, "end" = IC_PINTYPE_NUMBER, "t" = IC_PINTYPE_NUMBER)
	operation = "linear_interpolation"

/obj/item/integrated_circuit/math/calculus/lerp
	name = "lerp circuit"
	desc = "Blends between two values for smooth displays, servo-like controls, or target prediction."
	inputs = list("start" = IC_PINTYPE_NUMBER, "end" = IC_PINTYPE_NUMBER, "t" = IC_PINTYPE_NUMBER)
	operation = "lerp"

/obj/item/integrated_circuit/math/calculus/inverse_lerp
	name = "inverse lerp circuit"
	desc = "Converts a value inside a range into a 0-1 progress fraction for displays and scoring."
	inputs = list("start" = IC_PINTYPE_NUMBER, "end" = IC_PINTYPE_NUMBER, "value" = IC_PINTYPE_NUMBER)
	operation = "inverse_lerp"

/obj/item/integrated_circuit/math/calculus/remap
	name = "remap circuit"
	desc = "Converts sensor ranges into display percentages, threat scores, or actuator strengths."
	inputs = list("value" = IC_PINTYPE_NUMBER, "from min" = IC_PINTYPE_NUMBER, "from max" = IC_PINTYPE_NUMBER, "to min" = IC_PINTYPE_NUMBER, "to max" = IC_PINTYPE_NUMBER)
	operation = "remap"

/obj/item/integrated_circuit/math/calculus/smoothstep
	name = "smoothstep circuit"
	desc = "Produces a smoothed 0-1 transition between two thresholds for gradual control outputs."
	inputs = list("edge 0" = IC_PINTYPE_NUMBER, "edge 1" = IC_PINTYPE_NUMBER, "value" = IC_PINTYPE_NUMBER)
	operation = "smoothstep"

/obj/item/integrated_circuit/math/calculus/exponential_smoothing
	name = "exponential smoothing circuit"
	desc = "Filters noisy sensor values using the previous output and a tunable alpha."
	inputs = list("current" = IC_PINTYPE_NUMBER, "previous output" = IC_PINTYPE_NUMBER, "alpha" = IC_PINTYPE_NUMBER)
	operation = "exp_smoothing"

/obj/item/integrated_circuit/math/vector_calculus
	category_text = "MATH - Vector Calculus"
	inputs = list("grid" = IC_PINTYPE_LIST, "x" = IC_PINTYPE_NUMBER, "y" = IC_PINTYPE_NUMBER, "step" = IC_PINTYPE_NUMBER)
	outputs = list("result" = IC_PINTYPE_LIST, "status" = IC_PINTYPE_STRING)
	complexity = 8

/obj/item/integrated_circuit/math/vector_calculus/proc/read_grid_value(list/grid, x, y)
	if(y < 1 || y > length(grid))
		return null
	var/list/row = grid[y]
	if(x < 1 || x > length(row))
		return null
	return row[x]

/obj/item/integrated_circuit/math/vector_calculus/do_work()
	var/list/grid = ic_math_grid(get_pin_data(IC_INPUT, 1))
	var/x = round(get_pin_data(IC_INPUT, 2))
	var/y = round(get_pin_data(IC_INPUT, 3))
	var/step = get_pin_data(IC_INPUT, 4)
	if(!grid || !isnum(x) || !isnum(y) || !isnum(step) || step == 0)
		fail("Invalid grid")
		return

	var/center = read_grid_value(grid, x, y)
	var/left = read_grid_value(grid, x - 1, y)
	var/right = read_grid_value(grid, x + 1, y)
	var/down = read_grid_value(grid, x, y - 1)
	var/up = read_grid_value(grid, x, y + 1)

	if(isnull(center) || isnull(left) || isnull(right) || isnull(down) || isnull(up))
		fail("Point requires neighbors")
		return

	switch(operation)
		if("gradient")
			if(!isnum(left) || !isnum(right) || !isnum(down) || !isnum(up))
				fail("Scalar grid required")
				return
			succeed(list((right - left) / (2 * step), (up - down) / (2 * step)))
		if("laplacian")
			if(!isnum(center) || !isnum(left) || !isnum(right) || !isnum(down) || !isnum(up))
				fail("Scalar grid required")
				return
			succeed((left + right + up + down - (4 * center)) / (step * step))
		if("directional")
			var/list/direction = ic_math_numeric_list(get_pin_data(IC_INPUT, 5), IC_MATH_VECTOR_LIMIT)
			if(!direction || length(direction) < 2)
				fail("Direction required")
				return
			var/magnitude = ic_math_vector_magnitude(direction)
			if(magnitude == 0)
				fail("Zero direction")
				return
			var/gx = (right - left) / (2 * step)
			var/gy = (up - down) / (2 * step)
			succeed((gx * direction[1] / magnitude) + (gy * direction[2] / magnitude))
		if("divergence", "curl2")
			if(!islist(left) || !islist(right) || !islist(down) || !islist(up))
				fail("Vector grid required")
				return
			var/list/L = ic_math_numeric_list(left, 2)
			var/list/R = ic_math_numeric_list(right, 2)
			var/list/D = ic_math_numeric_list(down, 2)
			var/list/U = ic_math_numeric_list(up, 2)
			if(!L || !R || !D || !U || length(L) < 2 || length(R) < 2 || length(D) < 2 || length(U) < 2)
				fail("2D vector grid required")
				return
			if(operation == "divergence")
				succeed(((R[1] - L[1]) + (U[2] - D[2])) / (2 * step))
			else
				succeed(((R[2] - L[2]) - (U[1] - D[1])) / (2 * step))

/obj/item/integrated_circuit/math/vector_calculus/gradient
	name = "gradient circuit"
	desc = "Finds which direction nearby scalar readings increase, useful for heat, radiation, or signal tracking."
	operation = "gradient"

/obj/item/integrated_circuit/math/vector_calculus/divergence
	name = "divergence circuit"
	desc = "Measures whether a vector field spreads outward or inward around a point."
	outputs = list("result" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	operation = "divergence"

/obj/item/integrated_circuit/math/vector_calculus/curl2
	name = "curl 2D circuit"
	desc = "Measures local rotation in a 2D vector field for flow or steering analysis."
	outputs = list("result" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	operation = "curl2"

/obj/item/integrated_circuit/math/vector_calculus/laplacian
	name = "laplacian circuit"
	desc = "Detects hotspots and anomalies where the center reading differs sharply from its neighbors."
	outputs = list("result" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	operation = "laplacian"

/obj/item/integrated_circuit/math/vector_calculus/directional_derivative
	name = "directional derivative circuit"
	desc = "Measures whether scalar readings rise or fall along a supplied movement direction."
	inputs = list("grid" = IC_PINTYPE_LIST, "x" = IC_PINTYPE_NUMBER, "y" = IC_PINTYPE_NUMBER, "step" = IC_PINTYPE_NUMBER, "direction" = IC_PINTYPE_LIST)
	outputs = list("result" = IC_PINTYPE_NUMBER, "status" = IC_PINTYPE_STRING)
	operation = "directional"

/obj/item/integrated_circuit/math/vector_calculus/grid_from_rows
	name = "scalar grid from rows circuit"
	desc = "Builds a bounded scalar grid from nearby numeric readings for gradient, Laplacian, and hotspot circuits."
	inputs = list(
		"row 1" = IC_PINTYPE_LIST,
		"row 2" = IC_PINTYPE_LIST,
		"row 3" = IC_PINTYPE_LIST,
		"row 4" = IC_PINTYPE_LIST,
		"row 5" = IC_PINTYPE_LIST,
		"row 6" = IC_PINTYPE_LIST,
		"row 7" = IC_PINTYPE_LIST
	)
	outputs = list(
		"grid" = IC_PINTYPE_LIST,
		"rows" = IC_PINTYPE_NUMBER,
		"columns" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 8
	power_draw_per_use = 150
	operation = "grid_from_rows"

/obj/item/integrated_circuit/math/vector_calculus/grid_from_rows/do_work()
	var/list/grid = list()

	for(var/i = 1 to IC_MATH_GRID_LIMIT)
		var/list/row = get_pin_data(IC_INPUT, i)
		if(!islist(row))
			continue
		grid += list(row)

	grid = ic_math_grid(grid)
	if(!grid)
		set_pin_data(IC_OUTPUT, 4, FALSE)
		set_pin_data(IC_OUTPUT, 5, "Invalid grid")
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, grid)
	set_pin_data(IC_OUTPUT, 2, length(grid))
	set_pin_data(IC_OUTPUT, 3, length(grid[1]))
	set_pin_data(IC_OUTPUT, 4, TRUE)
	set_pin_data(IC_OUTPUT, 5, "OK")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/math/vector_calculus/vector_grid_from_components
	name = "vector grid from components circuit"
	desc = "Builds a 2D vector-field grid from matching X and Y component readings."
	inputs = list(
		"x component grid" = IC_PINTYPE_LIST,
		"y component grid" = IC_PINTYPE_LIST
	)
	outputs = list(
		"grid" = IC_PINTYPE_LIST,
		"rows" = IC_PINTYPE_NUMBER,
		"columns" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 10
	power_draw_per_use = 200
	operation = "vector_grid_from_components"

/obj/item/integrated_circuit/math/vector_calculus/vector_grid_from_components/do_work()
	var/list/x_grid = ic_math_grid(get_pin_data(IC_INPUT, 1))
	var/list/y_grid = ic_math_grid(get_pin_data(IC_INPUT, 2))

	if(!x_grid || !y_grid || length(x_grid) != length(y_grid) || length(x_grid[1]) != length(y_grid[1]))
		set_pin_data(IC_OUTPUT, 4, FALSE)
		set_pin_data(IC_OUTPUT, 5, "Mismatched grids")
		push_data()
		activate_pin(3)
		return

	var/list/result = list()
	for(var/y = 1 to length(x_grid))
		var/list/x_row = x_grid[y]
		var/list/y_row = y_grid[y]
		var/list/row = list()
		for(var/x = 1 to length(x_row))
			if(!isnum(x_row[x]) || !isnum(y_row[x]))
				set_pin_data(IC_OUTPUT, 4, FALSE)
				set_pin_data(IC_OUTPUT, 5, "Scalar grids required")
				push_data()
				activate_pin(3)
				return
			row += list(list(x_row[x], y_row[x]))
		result += list(row)

	set_pin_data(IC_OUTPUT, 1, result)
	set_pin_data(IC_OUTPUT, 2, length(result))
	set_pin_data(IC_OUTPUT, 3, length(result[1]))
	set_pin_data(IC_OUTPUT, 4, TRUE)
	set_pin_data(IC_OUTPUT, 5, "OK")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/math/vector_calculus/grid_validator
	name = "grid validator circuit"
	desc = "Checks whether a sensor grid is valid before feeding it into field-analysis circuits."
	inputs = list("grid" = IC_PINTYPE_LIST)
	outputs = list(
		"valid" = IC_PINTYPE_BOOLEAN,
		"rows" = IC_PINTYPE_NUMBER,
		"columns" = IC_PINTYPE_NUMBER,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 4
	operation = "grid_validator"

/obj/item/integrated_circuit/math/vector_calculus/grid_validator/do_work()
	var/list/dimensions = ic_math_grid_dimensions(get_pin_data(IC_INPUT, 1))

	if(!dimensions)
		set_pin_data(IC_OUTPUT, 1, FALSE)
		set_pin_data(IC_OUTPUT, 2, 0)
		set_pin_data(IC_OUTPUT, 3, 0)
		set_pin_data(IC_OUTPUT, 4, "Invalid grid")
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, TRUE)
	set_pin_data(IC_OUTPUT, 2, dimensions[1])
	set_pin_data(IC_OUTPUT, 3, dimensions[2])
	set_pin_data(IC_OUTPUT, 4, "OK")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/math/vector_calculus/grid_to_text
	name = "grid to text circuit"
	desc = "Converts a scalar or 2D vector grid into compact display text for debugging sensor layouts."
	inputs = list("grid" = IC_PINTYPE_LIST)
	outputs = list(
		"text" = IC_PINTYPE_STRING,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 5
	operation = "grid_to_text"

/obj/item/integrated_circuit/math/vector_calculus/grid_to_text/do_work()
	var/text = ic_math_grid_to_text(get_pin_data(IC_INPUT, 1), MAX_MESSAGE_LEN)

	if(isnull(text))
		set_pin_data(IC_OUTPUT, 2, "Invalid grid")
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, text)
	set_pin_data(IC_OUTPUT, 2, length(text) >= MAX_MESSAGE_LEN - 3 ? "Truncated" : "OK")
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/math/vector/to_text
	name = "vector to text circuit"
	desc = "Converts a numeric vector into compact display text for movement and field-analysis debugging."
	inputs = list("vector" = IC_PINTYPE_LIST)
	outputs = list(
		"text" = IC_PINTYPE_STRING,
		"status" = IC_PINTYPE_STRING
	)
	complexity = 3
	operation = "to_text"

/obj/item/integrated_circuit/math/vector/to_text/do_work()
	var/list/vector = ic_math_numeric_list(get_pin_data(IC_INPUT, 1), IC_MATH_VECTOR_LIMIT)

	if(!vector)
		set_pin_data(IC_OUTPUT, 2, "Invalid vector")
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, "([jointext(vector, ", ")])")
	set_pin_data(IC_OUTPUT, 2, "OK")
	push_data()
	activate_pin(2)

#undef IC_MATH_LIST_LIMIT
#undef IC_MATH_VECTOR_LIMIT
#undef IC_MATH_MATRIX_LIMIT
#undef IC_MATH_GRID_LIMIT
