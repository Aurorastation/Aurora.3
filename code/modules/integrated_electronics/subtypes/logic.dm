/*
 * subtypes/logic.dm
 * Logic and comparison circuits for boolean gates, equality checks, numeric comparisons, and conditional routing.
 */

/obj/item/integrated_circuit/logic
	name = "logic gate"
	desc = "This tiny chip will decide for you!"
	extended_desc = "Logic circuits treat null, 0, and empty text as FALSE. Non-zero numbers, non-empty text, valid refs, and populated lists are TRUE. Compare matching value types for reliable results."
	complexity = 3
	outputs = list("result" = IC_PINTYPE_BOOLEAN)
	activators = list("compare" = IC_PINTYPE_PULSE_IN)
	category_text = "LOGIC - Boolean Logic"
	power_draw_per_use = 10

/obj/item/integrated_circuit/logic/binary
	inputs = list(
		"A" = IC_PINTYPE_ANY,
		"B" = IC_PINTYPE_ANY
	)
	activators = list(
		"compare" = IC_PINTYPE_PULSE_IN,
		"on true result" = IC_PINTYPE_PULSE_OUT,
		"on false result" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/logic/binary/do_work()
	var/data1 = get_pin_data(IC_INPUT, 1)
	var/data2 = get_pin_data(IC_INPUT, 2)

	var/result = FALSE
	if (comparable(data1, data2))
		result = !!do_compare(data1, data2)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()

	if (result)
		activate_pin(2)
	else
		activate_pin(3)

/obj/item/integrated_circuit/logic/binary/proc/do_compare(A, B)
	return FALSE

/obj/item/integrated_circuit/logic/binary/proc/comparable(A, B)
	if (isnum(A) && isnum(B))
		. = TRUE
	else if (istext(A) && istext(B))
		. = TRUE
	else if (islist(A) && islist(B))
		. = TRUE
	else if (isdatum(A) && isdatum(B))
		. = TRUE
	else
		. = FALSE

/obj/item/integrated_circuit/logic/unary
	inputs = list(
		"A" = IC_PINTYPE_ANY
	)
	activators = list(
		"compare" = IC_PINTYPE_PULSE_IN,
		"on compare" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/logic/unary/do_work()
	var/mydata = get_pin_data(IC_INPUT, 1)
	set_pin_data(IC_OUTPUT, 1, !!do_check(mydata))
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/logic/unary/proc/do_check(A)
	return FALSE

/obj/item/integrated_circuit/logic/binary/equals
	name = "equal gate"
	desc = "This gate compares two values, and outputs the number one if both are the same."
	icon_state = "equal"
	category_text = "LOGIC - Comparisons"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/equals/do_compare(A, B)
	return A == B

/obj/item/integrated_circuit/logic/binary/jklatch
	name = "JK latch"
	desc = "This gate is a synchronized JK latch."
	icon_state = "jklatch"
	inputs = list("J" = IC_PINTYPE_ANY,"K" = IC_PINTYPE_ANY)
	outputs = list("Q" = IC_PINTYPE_BOOLEAN,"!Q" = IC_PINTYPE_BOOLEAN)
	activators = list("pulse in C" = IC_PINTYPE_PULSE_IN, "pulse out Q" = IC_PINTYPE_PULSE_OUT, "pulse out !Q" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/lstate=FALSE

/obj/item/integrated_circuit/logic/binary/jklatch/do_work()
	if(get_pin_data(IC_INPUT, 1))
		if(get_pin_data(IC_INPUT, 2))
			lstate=!lstate
		else
			lstate = TRUE
	else
		if(get_pin_data(IC_INPUT, 2))
			lstate=FALSE
	set_pin_data(IC_OUTPUT, 1, lstate ? TRUE : FALSE)
	set_pin_data(IC_OUTPUT, 2, !lstate ? TRUE : FALSE)
	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	push_data()

/obj/item/integrated_circuit/logic/binary/rslatch
	name = "RS latch"
	desc = "This gate is a synchronized RS latch. If both R and S are true, its state will not change."
	icon_state = "sr_nor"
	inputs = list("S" = IC_PINTYPE_ANY,"R" = IC_PINTYPE_ANY)
	outputs = list("Q" = IC_PINTYPE_BOOLEAN,"!Q" = IC_PINTYPE_BOOLEAN)
	activators = list("pulse in C" = IC_PINTYPE_PULSE_IN, "pulse out Q" = IC_PINTYPE_PULSE_OUT, "pulse out !Q" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/lstate=FALSE

/obj/item/integrated_circuit/logic/binary/rslatch/do_work()
	if(get_pin_data(IC_INPUT, 1))
		if(!get_pin_data(IC_INPUT, 2))
			lstate=TRUE
	else
		if(get_pin_data(IC_INPUT, 2))
			lstate=FALSE
	set_pin_data(IC_OUTPUT, 1, lstate ? TRUE : FALSE)
	set_pin_data(IC_OUTPUT, 2, !lstate ? TRUE : FALSE)
	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	push_data()

/obj/item/integrated_circuit/logic/binary/gdlatch
	name = "gated D latch"
	desc = "This gate is a synchronized gated D latch."
	icon_state = "gated_d"
	inputs = list("D" = IC_PINTYPE_ANY,"E" = IC_PINTYPE_ANY)
	outputs = list("Q" = IC_PINTYPE_BOOLEAN,"!Q" = IC_PINTYPE_BOOLEAN)
	activators = list("pulse in C" = IC_PINTYPE_PULSE_IN, "pulse out Q" = IC_PINTYPE_PULSE_OUT, "pulse out !Q" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/lstate=FALSE

/obj/item/integrated_circuit/logic/binary/gdlatch/do_work()
	if(get_pin_data(IC_INPUT, 2))
		if(get_pin_data(IC_INPUT, 1))
			lstate=TRUE
		else
			lstate=FALSE


	set_pin_data(IC_OUTPUT, 1, lstate ? TRUE : FALSE)
	set_pin_data(IC_OUTPUT, 2, !lstate ? TRUE : FALSE)
	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	push_data()

/obj/item/integrated_circuit/logic/binary/not_equals
	name = "not equal gate"
	desc = "This gate compares two values, and outputs the number one if both are different."
	icon_state = "not_equal"
	category_text = "LOGIC - Comparisons"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/not_equals/do_compare(A, B)
	return A != B

/obj/item/integrated_circuit/logic/binary/and
	name = "and gate"
	desc = "This gate will output 'one' if both inputs evaluate to true."
	icon_state = "and"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/and/do_compare(A, B)
	return A && B

/obj/item/integrated_circuit/logic/binary/or
	name = "or gate"
	desc = "This gate will output 'one' if one of the inputs evaluate to true."
	icon_state = "or"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/or/do_compare(A, B)
	return A || B

/obj/item/integrated_circuit/logic/binary/less_than
	name = "less than gate"
	desc = "This will output 'one' if the first input is less than the second input."
	icon_state = "less_than"
	category_text = "LOGIC - Comparisons"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/less_than/do_compare(A, B)
	return A < B

/obj/item/integrated_circuit/logic/binary/less_than_or_equal
	name = "less than or equal gate"
	desc = "This will output 'one' if the first input is less than, or equal to the second input."
	icon_state = "less_than_or_equal"
	category_text = "LOGIC - Comparisons"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/less_than_or_equal/do_compare(A, B)
	return A <= B

/obj/item/integrated_circuit/logic/binary/greater_than
	name = "greater than gate"
	desc = "This will output 'one' if the first input is greater than the second input."
	icon_state = "greater_than"
	category_text = "LOGIC - Comparisons"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/greater_than/do_compare(A, B)
	return A > B

/obj/item/integrated_circuit/logic/binary/greater_than_or_equal
	name = "greater_than or equal gate"
	desc = "This will output 'one' if the first input is greater than, or equal to the second input."
	icon_state = "greater_than_or_equal"
	category_text = "LOGIC - Comparisons"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/greater_than_or_equal/do_compare(A, B)
	return A >= B

/obj/item/integrated_circuit/logic/unary/not
	name = "not gate"
	desc = "This gate inverts what's fed into it."
	icon_state = "not"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	activators = list("invert" = IC_PINTYPE_PULSE_IN, "on inverted" = IC_PINTYPE_PULSE_OUT)

/obj/item/integrated_circuit/logic/unary/not/do_check(A)
	return !A

/obj/item/integrated_circuit/logic/edge_detector
	name = "edge detector"
	desc = "Turns a changing boolean signal into one-shot output pulses."
	extended_desc = "Stores the previous signal state internally. It only pulses when the input changes, making it useful for preventing ticker-fed logic from repeatedly firing the same action."
	icon_state = "template"
	complexity = 2
	inputs = list(
		"signal" = IC_PINTYPE_BOOLEAN
	)
	outputs = list(
		"current state" = IC_PINTYPE_BOOLEAN,
		"previous state" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"check" = IC_PINTYPE_PULSE_IN,
		"on rising edge" = IC_PINTYPE_PULSE_OUT,
		"on falling edge" = IC_PINTYPE_PULSE_OUT,
		"on changed" = IC_PINTYPE_PULSE_OUT,
		"on unchanged" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	var/previous_state = FALSE
	var/has_previous_state = FALSE

/obj/item/integrated_circuit/logic/edge_detector/do_work()
	var/current_state = get_pin_data(IC_INPUT, 1) ? TRUE : FALSE
	var/old_state = previous_state

	set_pin_data(IC_OUTPUT, 1, current_state)
	set_pin_data(IC_OUTPUT, 2, old_state)
	push_data()

	if(!has_previous_state)
		previous_state = current_state
		has_previous_state = TRUE
		activate_pin(5)
		return

	if(current_state == previous_state)
		activate_pin(5)
		return

	previous_state = current_state
	activate_pin(current_state ? 2 : 3)
	activate_pin(4)

/obj/item/integrated_circuit/logic/threshold_comparator
	name = "threshold comparator"
	desc = "Checks whether a number is below, inside, or above a range."
	icon_state = "comparator"
	category_text = "LOGIC - Comparisons"
	complexity = 3
	inputs = list(
		"value" = IC_PINTYPE_NUMBER,
		"minimum" = IC_PINTYPE_NUMBER,
		"maximum" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"below range" = IC_PINTYPE_BOOLEAN,
		"inside range" = IC_PINTYPE_BOOLEAN,
		"above range" = IC_PINTYPE_BOOLEAN,
		"status text" = IC_PINTYPE_STRING
	)
	activators = list(
		"compare" = IC_PINTYPE_PULSE_IN,
		"below" = IC_PINTYPE_PULSE_OUT,
		"inside" = IC_PINTYPE_PULSE_OUT,
		"above" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/threshold_comparator/do_work()
	var/value = get_pin_data(IC_INPUT, 1)
	var/minimum = get_pin_data(IC_INPUT, 2)
	var/maximum = get_pin_data(IC_INPUT, 3)

	if(!isnum(value) || !isnum(minimum) || !isnum(maximum))
		return

	var/below = value < minimum
	var/above = value > maximum
	var/inside = !below && !above

	set_pin_data(IC_OUTPUT, 1, below)
	set_pin_data(IC_OUTPUT, 2, inside)
	set_pin_data(IC_OUTPUT, 3, above)
	set_pin_data(IC_OUTPUT, 4, below ? "BELOW RANGE" : above ? "ABOVE RANGE" : "INSIDE RANGE")

	push_data()

	if(below)
		activate_pin(2)
	else if(inside)
		activate_pin(3)
	else
		activate_pin(4)


/obj/item/integrated_circuit/logic/multi_threshold_status
	name = "multi-threshold status"
	desc = "Classifies a number as normal, warning, or danger using low and high thresholds."
	icon_state = "comparator"
	category_text = "LOGIC - Comparisons"
	complexity = 5
	inputs = list(
		"value" = IC_PINTYPE_NUMBER,
		"danger low" = IC_PINTYPE_NUMBER,
		"warning low" = IC_PINTYPE_NUMBER,
		"warning high" = IC_PINTYPE_NUMBER,
		"danger high" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"normal" = IC_PINTYPE_BOOLEAN,
		"warning" = IC_PINTYPE_BOOLEAN,
		"danger" = IC_PINTYPE_BOOLEAN,
		"status text" = IC_PINTYPE_STRING
	)
	activators = list(
		"check" = IC_PINTYPE_PULSE_IN,
		"normal" = IC_PINTYPE_PULSE_OUT,
		"warning" = IC_PINTYPE_PULSE_OUT,
		"danger" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/multi_threshold_status/do_work()
	var/value = get_pin_data(IC_INPUT, 1)
	var/danger_low = get_pin_data(IC_INPUT, 2)
	var/warning_low = get_pin_data(IC_INPUT, 3)
	var/warning_high = get_pin_data(IC_INPUT, 4)
	var/danger_high = get_pin_data(IC_INPUT, 5)

	if(!isnum(value) || !isnum(danger_low) || !isnum(warning_low) || !isnum(warning_high) || !isnum(danger_high))
		return

	var/normal = FALSE
	var/warning = FALSE
	var/danger = FALSE
	var/status = "NORMAL"

	if(value <= danger_low)
		danger = TRUE
		status = "LOW DANGER"
	else if(value < warning_low)
		warning = TRUE
		status = "LOW WARNING"
	else if(value >= danger_high)
		danger = TRUE
		status = "HIGH DANGER"
	else if(value > warning_high)
		warning = TRUE
		status = "HIGH WARNING"
	else
		normal = TRUE

	set_pin_data(IC_OUTPUT, 1, normal)
	set_pin_data(IC_OUTPUT, 2, warning)
	set_pin_data(IC_OUTPUT, 3, danger)
	set_pin_data(IC_OUTPUT, 4, status)

	push_data()

	if(normal)
		activate_pin(2)
	else if(warning)
		activate_pin(3)
	else
		activate_pin(4)


/obj/item/integrated_circuit/logic/cooldown_limiter
	name = "cooldown limiter"
	desc = "Allows a pulse through only when its cooldown has expired."
	extended_desc = "Cooldown is clamped between 1 and 600 seconds. Disabled gates block incoming pulses without updating their cooldown."
	icon_state = "template"
	complexity = 4
	inputs = list(
		"cooldown seconds" = IC_PINTYPE_NUMBER,
		"enabled" = IC_PINTYPE_BOOLEAN
	)
	inputs_default = list(
		"1" = 2,
		"2" = TRUE
	)
	outputs = list(
		"ready" = IC_PINTYPE_BOOLEAN,
		"remaining cooldown" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"pulse in" = IC_PINTYPE_PULSE_IN,
		"pulse out" = IC_PINTYPE_PULSE_OUT,
		"on blocked" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

	var/next_allowed_time = 0

/obj/item/integrated_circuit/logic/cooldown_limiter/do_work()
	var/cooldown_seconds = get_pin_data(IC_INPUT, 1)
	var/enabled = get_pin_data(IC_INPUT, 2)

	if(!isnum(cooldown_seconds))
		cooldown_seconds = 2

	cooldown_seconds = between(1, cooldown_seconds, 600)

	if(!enabled)
		set_pin_data(IC_OUTPUT, 1, FALSE)
		set_pin_data(IC_OUTPUT, 2, 0)
		push_data()
		activate_pin(3)
		return

	if(world.time >= next_allowed_time)
		next_allowed_time = world.time + cooldown_seconds SECONDS
		set_pin_data(IC_OUTPUT, 1, TRUE)
		set_pin_data(IC_OUTPUT, 2, 0)
		push_data()
		activate_pin(2)
		return

	var/remaining = max(round((next_allowed_time - world.time) / 10, 0.1), 0)
	set_pin_data(IC_OUTPUT, 1, FALSE)
	set_pin_data(IC_OUTPUT, 2, remaining)
	push_data()
	activate_pin(3)


/obj/item/integrated_circuit/logic/pulse_counter
	name = "threshold pulse counter"
	desc = "Counts incoming pulses and reports when a threshold has been reached."
	extended_desc = "Count is clamped between -100000 and 100000. Use the reset pulse to set the count to the configured reset value."
	icon_state = "counter"
	complexity = 3
	inputs = list(
		"threshold" = IC_PINTYPE_NUMBER,
		"reset value" = IC_PINTYPE_NUMBER
	)
	inputs_default = list(
		"1" = 1,
		"2" = 0
	)
	outputs = list(
		"count" = IC_PINTYPE_NUMBER,
		"threshold met" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"increment" = IC_PINTYPE_PULSE_IN,
		"decrement" = IC_PINTYPE_PULSE_IN,
		"reset" = IC_PINTYPE_PULSE_IN,
		"on count changed" = IC_PINTYPE_PULSE_OUT,
		"on threshold met" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 20

	var/count = 0

/obj/item/integrated_circuit/logic/pulse_counter/do_work(activator_id)
	var/active_pin = activator_id

	if(istype(active_pin, /datum/integrated_io))
		active_pin = activators.Find(active_pin)

	if(!isnum(active_pin))
		active_pin = 1

	switch(active_pin)
		if(2)
			count--
		if(3)
			var/reset_value = get_pin_data(IC_INPUT, 2)
			count = isnum(reset_value) ? round(reset_value) : 0
		else
			count++

	count = clamp(count, -100000, 100000)
	var/threshold = get_pin_data(IC_INPUT, 1)
	if(!isnum(threshold))
		threshold = 1
	threshold = clamp(round(threshold), -100000, 100000)
	var/threshold_met = count >= threshold

	set_pin_data(IC_OUTPUT, 1, count)
	set_pin_data(IC_OUTPUT, 2, threshold_met)
	push_data()
	activate_pin(4)
	if(threshold_met)
		activate_pin(5)


/obj/item/integrated_circuit/logic/pulse_sequencer
	name = "pulse sequencer"
	desc = "Cycles through four output pulses. If reset is true when pulsed, the sequence resets instead."
	icon_state = "template"
	complexity = 4
	inputs = list(
		"reset" = IC_PINTYPE_BOOLEAN
	)
	outputs = list(
		"current step" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"pulse" = IC_PINTYPE_PULSE_IN,
		"step 1 pulse" = IC_PINTYPE_PULSE_OUT,
		"step 2 pulse" = IC_PINTYPE_PULSE_OUT,
		"step 3 pulse" = IC_PINTYPE_PULSE_OUT,
		"step 4 pulse" = IC_PINTYPE_PULSE_OUT,
		"on reset" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	var/current_step = 0

/obj/item/integrated_circuit/logic/pulse_sequencer/do_work()
	if(get_pin_data(IC_INPUT, 1))
		current_step = 0
		set_pin_data(IC_OUTPUT, 1, current_step)
		push_data()
		activate_pin(6)
		return

	current_step++

	if(current_step > 4)
		current_step = 1

	set_pin_data(IC_OUTPUT, 1, current_step)
	push_data()
	activate_pin(current_step + 1)
