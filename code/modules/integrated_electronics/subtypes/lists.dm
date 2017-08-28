//These circuits do things with lists, and use special list pins for stability.
/obj/item/integrated_circuit/list
	complexity = 1
	inputs = list(
	"input" = IC_PINTYPE_LIST
	)
	outputs = list("result" = IC_PINTYPE_STRING)
	activators = list("compute" = IC_PINTYPE_PULSE_IN, "on computed" = IC_PINTYPE_PULSE_OUT)
	category_text = "Lists"
	power_draw_per_use = 20

/obj/item/integrated_circuit/list/pick
	name = "pick circuit"
	desc = "This circuit will randomly 'pick' an element from a list that is inputted."
	extended_desc = "Will output null if the list is empty.  Input list is unmodified."
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/list/pick/do_work()
	var/result = null
	var/list/input_list = get_pin_data(IC_INPUT, 1) // List pins guarantee that there is a list inside, even if just an empty one.
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
	var/list/output_list = list()
	var/new_entry = get_pin_data(IC_INPUT, 2)
	output_list = input_list.Copy()
	output_list.Add(new_entry)

	set_pin_data(IC_OUTPUT, 1, output_list)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/list/jointext
	name = "join text circuit"
	desc = "This circuit will add all elements of a list into one string, seperated by a character."
	extended_desc = "Default settings will encode the entire list into a string."
	inputs = list(
		"list to join" = IC_PINTYPE_LIST,
		"delimiter" = IC_PINTYPE_CHAR,
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

	if(input_list.len && delimiter && !isnull(start) && !isnull(end))
		result = jointext(input_list, delimiter, start, end)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)