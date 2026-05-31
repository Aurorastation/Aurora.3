/*
 * subtypes/lists.dm
 * List circuits for creating, reading, writing, merging, filtering, and transforming list pin data.
 */

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
	extended_desc = "Outputs an empty list that can be passed into append, write, and other list-editing circuits."
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
	extended_desc = "Outputs null if the list is empty. The input list is not changed."
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
	extended_desc = "Adds the new element to the end of the list."
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
	var/new_entry = get_pin_data(IC_INPUT, 2, FALSE)

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
		var/list/filtered_list = list()
		for(var/item in input_list)
			if(!isnull(item))
				filtered_list += item
		result = jointext(filtered_list, delimiter, start, end)

		set_pin_data(IC_OUTPUT, 1, result)
		push_data()
		activate_pin(2)


/obj/item/integrated_circuit/list/any_greater_than
	name = "any greater than circuit"
	desc = "This circuit checks whether any number in a list is greater than a target value."
	extended_desc = "Non-number values are ignored. Outputs true if at least one number in the list is greater than the comparison value."
	category_text = "MATH - List Comparisons"
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
	category_text = "MATH - List Comparisons"
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
	category_text = "MATH - List Comparisons"
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
	category_text = "MATH - List Math"
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

/obj/item/integrated_circuit/list/list_contains
	name = "list contains"
	desc = "Checks whether a list contains a value."
	category_text = "MATH - List Comparisons"
	icon_state = "template"
	complexity = 3
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"value" = IC_PINTYPE_ANY
	)
	outputs = list(
		"contains" = IC_PINTYPE_BOOLEAN,
		"index" = IC_PINTYPE_NUMBER,
		"matched value" = IC_PINTYPE_ANY
	)
	activators = list(
		"check" = IC_PINTYPE_PULSE_IN,
		"found" = IC_PINTYPE_PULSE_OUT,
		"not found" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/list_contains/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/value = get_pin_data(IC_INPUT, 2, FALSE)

	set_pin_data(IC_OUTPUT, 1, FALSE)
	set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, null)

	if(!islist(input_list) || !length(input_list))
		push_data()
		activate_pin(3)
		return

	var/index = 1

	for(var/item in input_list)
		if(item == value || "[item]" == "[value]")
			set_pin_data(IC_OUTPUT, 1, TRUE)
			set_pin_data(IC_OUTPUT, 2, index)
			set_pin_data(IC_OUTPUT, 3, item)
			push_data()
			activate_pin(2)
			return

		index++

	push_data()
	activate_pin(3)


/obj/item/integrated_circuit/list/list_filter_text
	name = "list text filter"
	desc = "Filters a list by matching text against each value."
	icon_state = "template"
	complexity = 5
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"match text" = IC_PINTYPE_STRING
	)
	outputs = list(
		"filtered list" = IC_PINTYPE_LIST,
		"matches found" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"filter" = IC_PINTYPE_PULSE_IN,
		"found" = IC_PINTYPE_PULSE_OUT,
		"not found" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/list_filter_text/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/match_text = get_pin_data(IC_INPUT, 2)
	var/list/filtered_list = list()

	if(!islist(input_list) || !istext(match_text) || !length(match_text))
		set_pin_data(IC_OUTPUT, 1, filtered_list)
		set_pin_data(IC_OUTPUT, 2, FALSE)
		push_data()
		activate_pin(3)
		return

	var/lower_match = lowertext(match_text)

	for(var/item in input_list)
		var/check_text = lowertext("[item]")

		if(isweakref(item))
			var/datum/weakref/WR = item
			var/atom/A = WR.resolve()
			if(A)
				check_text = lowertext("[A.name] [A.desc]")

		else if(istype(item, /atom))
			var/atom/A = item
			check_text = lowertext("[A.name] [A.desc]")

		if(findtext(check_text, lower_match))
			filtered_list += item

	set_pin_data(IC_OUTPUT, 1, filtered_list)
	set_pin_data(IC_OUTPUT, 2, length(filtered_list) ? TRUE : FALSE)

	push_data()
	activate_pin(length(filtered_list) ? 2 : 3)


/obj/item/integrated_circuit/list/list_join
	name = "list joiner"
	desc = "Joins a list into a single string using a separator."
	icon_state = "template"
	complexity = 3
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"separator" = IC_PINTYPE_STRING
	)
	outputs = list(
		"joined string" = IC_PINTYPE_STRING
	)
	activators = list(
		"join" = IC_PINTYPE_PULSE_IN,
		"on joined" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/list_join/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/separator = get_pin_data(IC_INPUT, 2)

	if(!islist(input_list))
		input_list = list()

	if(!istext(separator))
		separator = ", "

	var/list/text_values = list()

	for(var/item in input_list)
		text_values += "[item]"

	set_pin_data(IC_OUTPUT, 1, jointext(text_values, separator))
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/list_sort
	name = "list sorter"
	desc = "Sorts a list."
	extended_desc = "Sorts values alphabetically or numerically depending on what the list contains."
	icon_state = "template"
	complexity = 4
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"ascending" = IC_PINTYPE_BOOLEAN
	)
	outputs = list(
		"sorted list" = IC_PINTYPE_LIST
	)
	activators = list(
		"sort" = IC_PINTYPE_PULSE_IN,
		"on sorted" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/list_sort/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/ascending = get_pin_data(IC_INPUT, 2)

	if(!islist(input_list))
		input_list = list()

	var/list/sorted_list = input_list.Copy()
	sortTim(sorted_list, /proc/cmp_text_asc)

	if(!ascending)
		sorted_list = reverseList(sorted_list)

	set_pin_data(IC_OUTPUT, 1, sorted_list)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/random_selector
	name = "random list selector"
	desc = "Selects a random value from a list."
	icon_state = "template"
	complexity = 3
	inputs = list(
		"list" = IC_PINTYPE_LIST
	)
	outputs = list(
		"selected value" = IC_PINTYPE_ANY,
		"selected index" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"select" = IC_PINTYPE_PULSE_IN,
		"selected" = IC_PINTYPE_PULSE_OUT,
		"not selected" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/random_selector/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)

	if(!islist(input_list) || !length(input_list))
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		push_data()
		activate_pin(3)
		return

	var/index = rand(1, length(input_list))

	set_pin_data(IC_OUTPUT, 1, input_list[index])
	set_pin_data(IC_OUTPUT, 2, index)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/list/weighted_random_selector
	name = "weighted random selector"
	desc = "Selects a random value from a list using a matching list of weights."
	icon_state = "template"
	complexity = 6
	inputs = list(
		"values" = IC_PINTYPE_LIST,
		"weights" = IC_PINTYPE_LIST
	)
	outputs = list(
		"selected value" = IC_PINTYPE_ANY,
		"selected index" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"select" = IC_PINTYPE_PULSE_IN,
		"selected" = IC_PINTYPE_PULSE_OUT,
		"not selected" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/weighted_random_selector/do_work()
	var/list/values = get_pin_data(IC_INPUT, 1)
	var/list/weights = get_pin_data(IC_INPUT, 2)

	if(!islist(values) || !islist(weights) || !length(values) || !length(weights))
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
		push_data()
		activate_pin(3)
		return

	var/total_weight = 0

	for(var/i = 1 to min(length(values), length(weights)))
		var/weight = weights[i]
		if(isnum(weight) && weight > 0)
			total_weight += weight

	if(total_weight <= 0)
		push_data()
		activate_pin(3)
		return

	var/roll = rand(1, total_weight)
	var/current_weight = 0

	for(var/i = 1 to min(length(values), length(weights)))
		var/weight = weights[i]

		if(!isnum(weight) || weight <= 0)
			continue

		current_weight += weight

		if(roll <= current_weight)
			set_pin_data(IC_OUTPUT, 1, values[i])
			set_pin_data(IC_OUTPUT, 2, i)
			push_data()
			activate_pin(2)
			return

	push_data()
	activate_pin(3)
