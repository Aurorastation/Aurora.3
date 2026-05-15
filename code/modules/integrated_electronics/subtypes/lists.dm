//These circuits do things with lists, and use special list pins for stability.
/obj/item/integrated_circuit/list
	complexity = 1
	inputs = list(
		"input" = IC_PINTYPE_LIST
	)
	outputs = list("result" = IC_PINTYPE_STRING)
	activators = list("compute" = IC_PINTYPE_PULSE_IN, "on computed" = IC_PINTYPE_PULSE_OUT)
	category_text = "Lists"
	power_draw_per_use = 200


/obj/item/integrated_circuit/list/empty
	name = "empty list circuit"
	desc = "This circuit outputs an empty list."
	extended_desc = "Useful as a starting point for append, write, and other list-editing circuits."
	inputs = list()
	outputs = list(
		"empty list" = IC_PINTYPE_LIST
	)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/empty/do_work()
	set_pin_data(IC_OUTPUT, 1, list())
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/pick
	name = "pick circuit"
	desc = "This circuit will randomly 'pick' an element from a list that is inputted."
	extended_desc = "Will output null if the list is empty. Input list is unmodified."
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/pick/do_work()
	var/result = null
	var/list/input_list = get_pin_data(IC_INPUT, 1)

	if(input_list.len)
		result = pick(input_list)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/append
	name = "append circuit"
	desc = "This circuit will add an element to a list."
	extended_desc = "The new element will always be at the bottom of the list."
	inputs = list(
		"list to append" = IC_PINTYPE_LIST,
		"input" = IC_PINTYPE_ANY
	)
	outputs = list(
		"appended list" = IC_PINTYPE_LIST
	)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/append/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/list/output_list = input_list.Copy()
	var/new_entry = get_pin_data(IC_INPUT, 2)

	output_list.Add(new_entry)

	set_pin_data(IC_OUTPUT, 1, output_list)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/search
	name = "search circuit"
	desc = "This circuit will give index of desired element in the list."
	extended_desc = "Search will start at 1 position and will return first matching position."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"item" = IC_PINTYPE_ANY
	)
	outputs = list(
		"index" = IC_PINTYPE_NUMBER
	)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/search/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/item = get_pin_data(IC_INPUT, 2)

	set_pin_data(IC_OUTPUT, 1, input_list.Find(item))
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/at
	name = "at circuit"
	desc = "This circuit will pick an element from a list by index."
	extended_desc = "If there is no element with such index, result will be null."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"index" = IC_PINTYPE_NUMBER
	)
	outputs = list("item" = IC_PINTYPE_ANY)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/at/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/index = get_pin_data(IC_INPUT, 2)
	var/item = null

	if(!isnull(index))
		index = round(index)

		if(index >= 1 && index <= input_list.len)
			item = input_list[index]

	set_pin_data(IC_OUTPUT, 1, item)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/delete
	name = "delete circuit"
	desc = "This circuit will delete the element from a list by index."
	extended_desc = "If there is no element with such index, result list will be unchanged."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"index" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"redacted list" = IC_PINTYPE_LIST
	)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/delete/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/list/output_list = input_list.Copy()
	var/index = get_pin_data(IC_INPUT, 2)

	if(!isnull(index))
		index = round(index)

		if(index >= 1 && index <= output_list.len)
			output_list.Cut(index, index + 1)

	set_pin_data(IC_OUTPUT, 1, output_list)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/write
	name = "write circuit"
	desc = "This circuit will write an element into a list with a given index."
	extended_desc = "If the index is beyond the current list length, the list will expand with null entries until the index exists."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"index" = IC_PINTYPE_NUMBER,
		"item" = IC_PINTYPE_ANY
	)
	outputs = list(
		"redacted list" = IC_PINTYPE_LIST
	)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/write/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/list/output_list = input_list.Copy()
	var/index = get_pin_data(IC_INPUT, 2)
	var/item = get_pin_data(IC_INPUT, 3)

	if(!isnull(index))
		index = round(index)

		if(index >= 1)
			while(output_list.len < index)
				output_list.Add(null)

			output_list[index] = item

	set_pin_data(IC_OUTPUT, 1, output_list)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/write4
	name = "4-way write circuit"
	desc = "This circuit writes up to four items into a list."
	extended_desc = "Each item is written directly to its matching list position. Item 1 writes to list position 1, item 2 writes to position 2, and so on."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"item 1" = IC_PINTYPE_ANY,
		"item 2" = IC_PINTYPE_ANY,
		"item 3" = IC_PINTYPE_ANY,
		"item 4" = IC_PINTYPE_ANY
	)
	outputs = list(
		"redacted list" = IC_PINTYPE_LIST
	)
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/write4/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/list/output_list = input_list.Copy()

	for(var/i = 1; i <= 4; i++)
		var/item = get_pin_data(IC_INPUT, i + 1)

		while(output_list.len < i)
			output_list.Add(null)

		output_list[i] = item

	set_pin_data(IC_OUTPUT, 1, output_list)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/write8
	name = "8-way write circuit"
	desc = "This circuit writes up to eight items into a list."
	extended_desc = "Each item is written directly to its matching list position. Item 1 writes to list position 1, item 2 writes to position 2, and so on."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"item 1" = IC_PINTYPE_ANY,
		"item 2" = IC_PINTYPE_ANY,
		"item 3" = IC_PINTYPE_ANY,
		"item 4" = IC_PINTYPE_ANY,
		"item 5" = IC_PINTYPE_ANY,
		"item 6" = IC_PINTYPE_ANY,
		"item 7" = IC_PINTYPE_ANY,
		"item 8" = IC_PINTYPE_ANY
	)
	outputs = list(
		"redacted list" = IC_PINTYPE_LIST
	)
	icon_state = "addition"
	complexity = 3
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/write8/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/list/output_list = input_list.Copy()

	for(var/i = 1; i <= 8; i++)
		var/item = get_pin_data(IC_INPUT, i + 1)

		while(output_list.len < i)
			output_list.Add(null)

		output_list[i] = item

	set_pin_data(IC_OUTPUT, 1, output_list)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/len
	name = "len circuit"
	desc = "This circuit will give length of the list."
	inputs = list(
		"list" = IC_PINTYPE_LIST
	)
	outputs = list(
		"length" = IC_PINTYPE_NUMBER
	)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/len/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)

	set_pin_data(IC_OUTPUT, 1, input_list.len)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/jointext
	name = "join text circuit"
	desc = "This circuit will add all elements of a list into one string, separated by a character."
	extended_desc = "Default settings will encode the entire list into a string. Mixed list values are converted to display text before joining."
	inputs = list(
		"list to join" = IC_PINTYPE_LIST,
		"delimiter" = IC_PINTYPE_STRING,
		"start" = IC_PINTYPE_NUMBER,
		"end" = IC_PINTYPE_NUMBER
	)
	inputs_default = list(
		"2" = ",",
		"3" = 1,
		"4" = 0
	)
	outputs = list(
		"joined text" = IC_PINTYPE_STRING
	)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/jointext/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/delimiter = get_pin_data(IC_INPUT, 2)
	var/start = get_pin_data(IC_INPUT, 3)
	var/end = get_pin_data(IC_INPUT, 4)

	var/result = null

	if(input_list.len && !isnull(delimiter) && !isnull(start) && !isnull(end))
		start = round(start)
		end = round(end)

		var/list/text_list = list()

		for(var/value in input_list)
			text_list.Add("[value]")

		result = jointext(text_list, delimiter, start, end)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/any_greater_than
	name = "any greater than circuit"
	desc = "This circuit checks whether any number in a list is greater than a target value."
	extended_desc = "Non-number values are ignored. Outputs true if at least one number in the list is greater than the comparison value."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"compare value" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"result" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"compare" = IC_PINTYPE_PULSE_IN,
		"on true result" = IC_PINTYPE_PULSE_OUT,
		"on false result" = IC_PINTYPE_PULSE_OUT
	)
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/any_greater_than/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/compare_value = get_pin_data(IC_INPUT, 2)

	var/result = FALSE

	if(!isnull(compare_value))
		for(var/value in input_list)
			if(!isnum(value))
				continue

			if(value > compare_value)
				result = TRUE
				break

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()

	if(result)
		activate_pin(2)
	else
		activate_pin(3)


/obj/item/integrated_circuit/list/any_less_than
	name = "any less than circuit"
	desc = "This circuit checks whether any number in a list is less than a target value."
	extended_desc = "Non-number values are ignored. Outputs true if at least one number in the list is less than the comparison value."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"compare value" = IC_PINTYPE_NUMBER
	)
	outputs = list(
		"result" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"compare" = IC_PINTYPE_PULSE_IN,
		"on true result" = IC_PINTYPE_PULSE_OUT,
		"on false result" = IC_PINTYPE_PULSE_OUT
	)
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/any_less_than/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/compare_value = get_pin_data(IC_INPUT, 2)

	var/result = FALSE

	if(!isnull(compare_value))
		for(var/value in input_list)
			if(!isnum(value))
				continue

			if(value < compare_value)
				result = TRUE
				break

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()

	if(result)
		activate_pin(2)
	else
		activate_pin(3)


/obj/item/integrated_circuit/list/any_equal_to
	name = "any equal to circuit"
	desc = "This circuit checks whether any value in a list is equal to a target value."
	extended_desc = "Outputs true if at least one value in the list is equal to the comparison value. This can compare numbers, strings, booleans, refs, or null."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"compare value" = IC_PINTYPE_ANY
	)
	outputs = list(
		"result" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"compare" = IC_PINTYPE_PULSE_IN,
		"on true result" = IC_PINTYPE_PULSE_OUT,
		"on false result" = IC_PINTYPE_PULSE_OUT
	)
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/any_equal_to/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/compare_value = get_pin_data(IC_INPUT, 2)

	var/result = FALSE

	for(var/value in input_list)
		if(value == compare_value)
			result = TRUE
			break

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()

	if(result)
		activate_pin(2)
	else
		activate_pin(3)

/obj/item/integrated_circuit/list/arithmetic
	name = "list arithmetic"
	desc = "This circuit performs basic arithmetic between two lists of numbers."
	extended_desc = "Takes two lists and applies the selected operation index-by-index. If either value is not a number, the output at that position is null. Supported operations are add, subtract, multiply, and divide."
	icon_state = "addition"
	complexity = 8
	inputs = list(
		"list A" = IC_PINTYPE_LIST,
		"list B" = IC_PINTYPE_LIST,
		"operation" = IC_PINTYPE_STRING
	)
	outputs = list(
		"result" = IC_PINTYPE_LIST
	)
	activators = list(
		"calculate" = IC_PINTYPE_PULSE_IN,
		"on calculated" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/arithmetic/do_work()
	pull_data()

	var/list/list_a = get_pin_data(IC_INPUT, 1)
	var/list/list_b = get_pin_data(IC_INPUT, 2)
	var/operation = lowertext("[get_pin_data(IC_INPUT, 3)]")

	var/list/result = list()

	if(!islist(list_a) || !islist(list_b))
		set_pin_data(IC_OUTPUT, 1, null)
		push_data()
		activate_pin(2)
		return

	var/max_length = max(length(list_a), length(list_b))

	for(var/i = 1 to max_length)
		var/a = list_a[i]
		var/b = list_b[i]

		if(!isnum(a) || !isnum(b))
			result.len++
			continue

		switch(operation)
			if("add", "+", "addition")
				result += a + b

			if("subtract", "-", "subtraction")
				result += a - b

			if("multiply", "*", "multiplication")
				result += a * b

			if("divide", "/", "division")
				if(b == 0)
					result.len++
				else
					result += a / b

			else
				result.len++

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

