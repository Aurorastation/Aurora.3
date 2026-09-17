GLOBAL_LIST_EMPTY(ic_database_servers)

/proc/ic_normalize_database_id(database_id)
	if(!istext(database_id) || !length(database_id))
		return "main"

	return lowertext(database_id)


/proc/ic_database_response(success = FALSE, response = null, status = "No response.")
	return list(
		"success" = success,
		"response" = response,
		"status" = status
	)


/obj/item/integrated_circuit/server
	category_text = "Data Server"
	complexity = 2
	power_draw_per_use = 300
	spawn_flags = 0
	activators = list(
		"compute" = IC_PINTYPE_PULSE_IN,
		"on computed" = IC_PINTYPE_PULSE_OUT
	)


/obj/item/integrated_circuit/server/proc/build_record_from_pins(field_count)
	var/list/record = list()

	for(var/i = 1 to field_count)
		var/key = get_pin_data(IC_INPUT, (i * 2) - 1)
		if(istext(key) && length(key))
			record[key] = get_pin_data(IC_INPUT, i * 2)

	return record


/obj/item/integrated_circuit/server/database
	name = "database server"
	desc = "A keyed database server for integrated circuits."
	extended_desc = "Stores keyed values for server client circuits. Commands: GET, SET, DELETE, CLEAR, HAS, KEYS, LEN, APPEND."
	icon_state = "addition"
	complexity = 8
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"server id" = IC_PINTYPE_STRING,
		"command" = IC_PINTYPE_STRING,
		"key" = IC_PINTYPE_STRING,
		"value" = IC_PINTYPE_ANY
	)

	inputs_default = list(
		"1" = "main",
		"2" = "GET"
	)

	outputs = list(
		"success" = IC_PINTYPE_BOOLEAN,
		"response" = IC_PINTYPE_ANY,
		"status" = IC_PINTYPE_STRING
	)

	var/database_id = "main"
	var/list/storage = list()


/obj/item/integrated_circuit/server/database/Initialize()
	. = ..()
	register_database()


/obj/item/integrated_circuit/server/database/Destroy()
	unregister_database()
	storage = null
	return ..()


/obj/item/integrated_circuit/server/database/proc/register_database()
	database_id = ic_normalize_database_id(database_id)
	GLOB.ic_database_servers[database_id] = src


/obj/item/integrated_circuit/server/database/proc/unregister_database()
	if(database_id && GLOB.ic_database_servers[database_id] == src)
		GLOB.ic_database_servers -= database_id


/obj/item/integrated_circuit/server/database/proc/set_database_id(new_id)
	new_id = ic_normalize_database_id(new_id)

	if(new_id == database_id)
		return

	unregister_database()
	database_id = new_id
	register_database()


/obj/item/integrated_circuit/server/database/proc/handle_request(command, key, value)
	if(!istext(command))
		return ic_database_response(FALSE, null, "Command must be text.")

	command = uppertext(command)

	switch(command)
		if("GET")
			if(!istext(key) || !length(key))
				return ic_database_response(FALSE, null, "GET requires a text key.")

			return ic_database_response(TRUE, storage[key], "Read complete.")

		if("SET")
			if(!istext(key) || !length(key))
				return ic_database_response(FALSE, null, "SET requires a text key.")

			storage[key] = value
			return ic_database_response(TRUE, value, "Write complete.")

		if("DELETE")
			if(!istext(key) || !length(key))
				return ic_database_response(FALSE, null, "DELETE requires a text key.")

			var/existed = (key in storage)
			storage -= key

			if(existed)
				return ic_database_response(TRUE, TRUE, "Deleted.")

			return ic_database_response(FALSE, FALSE, "Key not found.")

		if("CLEAR")
			storage.Cut()
			return ic_database_response(TRUE, TRUE, "Database cleared.")

		if("HAS")
			if(!istext(key) || !length(key))
				return ic_database_response(FALSE, null, "HAS requires a text key.")

			return ic_database_response(TRUE, (key in storage), "Check complete.")

		if("KEYS")
			var/list/keys = list()

			for(var/K in storage)
				keys.Add(K)

			return ic_database_response(TRUE, keys, "Keys returned.")

		if("LEN")
			return ic_database_response(TRUE, storage.len, "Length returned.")

		if("APPEND")
			if(!istext(key) || !length(key))
				return ic_database_response(FALSE, null, "APPEND requires a text key.")

			var/list/current = storage[key]

			if(!islist(current))
				current = list()

			current.Add(value)
			storage[key] = current

			return ic_database_response(TRUE, current, "Append complete.")

	return ic_database_response(FALSE, null, "Unknown command.")


/obj/item/integrated_circuit/server/database/do_work()
	pull_data()

	var/new_id = get_pin_data(IC_INPUT, 1)
	var/command = get_pin_data(IC_INPUT, 2)
	var/key = get_pin_data(IC_INPUT, 3)
	var/value = get_pin_data(IC_INPUT, 4)

	set_database_id(new_id)

	var/list/result = handle_request(command, key, value)

	set_pin_data(IC_OUTPUT, 1, result["success"])
	set_pin_data(IC_OUTPUT, 2, result["response"])
	set_pin_data(IC_OUTPUT, 3, result["status"])

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/client
	name = "database client"
	desc = "Sends requests to a database server."
	extended_desc = "Targets a database server by server id. Commands: GET, SET, DELETE, CLEAR, HAS, KEYS, LEN, APPEND."
	icon_state = "addition"
	complexity = 4
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"server id" = IC_PINTYPE_STRING,
		"command" = IC_PINTYPE_STRING,
		"key" = IC_PINTYPE_STRING,
		"value" = IC_PINTYPE_ANY
	)

	inputs_default = list(
		"1" = "main",
		"2" = "GET"
	)

	outputs = list(
		"success" = IC_PINTYPE_BOOLEAN,
		"response" = IC_PINTYPE_ANY,
		"status" = IC_PINTYPE_STRING
	)


/obj/item/integrated_circuit/server/client/do_work()
	pull_data()

	var/database_id = ic_normalize_database_id(get_pin_data(IC_INPUT, 1))
	var/command = get_pin_data(IC_INPUT, 2)
	var/key = get_pin_data(IC_INPUT, 3)
	var/value = get_pin_data(IC_INPUT, 4)

	var/list/result = ic_database_response(FALSE, null, "Server not found.")

	var/obj/item/integrated_circuit/server/database/S = GLOB.ic_database_servers[database_id]

	if(istype(S))
		result = S.handle_request(command, key, value)

	set_pin_data(IC_OUTPUT, 1, result["success"])
	set_pin_data(IC_OUTPUT, 2, result["response"])
	set_pin_data(IC_OUTPUT, 3, result["status"])

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/scanner
	name = "database scanner"
	desc = "Outputs a list of active database server ids."
	extended_desc = "Useful for debugging database wiring or discovering which database servers are available."
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list()

	outputs = list(
		"server ids" = IC_PINTYPE_LIST,
		"server count" = IC_PINTYPE_NUMBER
	)


/obj/item/integrated_circuit/server/scanner/do_work()
	var/list/server_ids = list()

	for(var/database_id in GLOB.ic_database_servers)
		var/obj/item/integrated_circuit/server/database/S = GLOB.ic_database_servers[database_id]

		if(istype(S))
			server_ids.Add(database_id)

	set_pin_data(IC_OUTPUT, 1, server_ids)
	set_pin_data(IC_OUTPUT, 2, server_ids.len)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/record_builder4
	name = "4-field record builder"
	desc = "Builds an associative list record from up to four key/value pairs."
	extended_desc = "This is useful for making database records like pressure, oxygen, temperature, and status."
	icon_state = "addition"
	complexity = 3
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"key 1" = IC_PINTYPE_STRING,
		"value 1" = IC_PINTYPE_ANY,
		"key 2" = IC_PINTYPE_STRING,
		"value 2" = IC_PINTYPE_ANY,
		"key 3" = IC_PINTYPE_STRING,
		"value 3" = IC_PINTYPE_ANY,
		"key 4" = IC_PINTYPE_STRING,
		"value 4" = IC_PINTYPE_ANY
	)

	outputs = list(
		"record" = IC_PINTYPE_LIST
	)


/obj/item/integrated_circuit/server/record_builder4/do_work()
	pull_data()

	set_pin_data(IC_OUTPUT, 1, build_record_from_pins(4))

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/record_builder8
	name = "8-field record builder"
	desc = "Builds an associative list record from up to eight key/value pairs."
	extended_desc = "This is useful for larger database records."
	icon_state = "addition"
	complexity = 5
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"key 1" = IC_PINTYPE_STRING,
		"value 1" = IC_PINTYPE_ANY,
		"key 2" = IC_PINTYPE_STRING,
		"value 2" = IC_PINTYPE_ANY,
		"key 3" = IC_PINTYPE_STRING,
		"value 3" = IC_PINTYPE_ANY,
		"key 4" = IC_PINTYPE_STRING,
		"value 4" = IC_PINTYPE_ANY,
		"key 5" = IC_PINTYPE_STRING,
		"value 5" = IC_PINTYPE_ANY,
		"key 6" = IC_PINTYPE_STRING,
		"value 6" = IC_PINTYPE_ANY,
		"key 7" = IC_PINTYPE_STRING,
		"value 7" = IC_PINTYPE_ANY,
		"key 8" = IC_PINTYPE_STRING,
		"value 8" = IC_PINTYPE_ANY
	)

	outputs = list(
		"record" = IC_PINTYPE_LIST
	)


/obj/item/integrated_circuit/server/record_builder8/do_work()
	pull_data()

	set_pin_data(IC_OUTPUT, 1, build_record_from_pins(8))

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/record_reader
	name = "record reader"
	desc = "Reads one field from an associative list record."
	extended_desc = "Use this after a database GET returns a record list."
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"record" = IC_PINTYPE_LIST,
		"field" = IC_PINTYPE_STRING
	)

	outputs = list(
		"value" = IC_PINTYPE_ANY,
		"found" = IC_PINTYPE_BOOLEAN
	)


/obj/item/integrated_circuit/server/record_reader/do_work()
	pull_data()

	var/list/record = get_pin_data(IC_INPUT, 1)
	var/field = get_pin_data(IC_INPUT, 2)

	var/value = null
	var/found = FALSE

	if(islist(record) && istext(field) && length(field))
		value = record[field]
		found = !isnull(value) || (field in record)

	set_pin_data(IC_OUTPUT, 1, value)
	set_pin_data(IC_OUTPUT, 2, found)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/record_writer
	name = "record writer"
	desc = "Writes one field into an associative list record."
	extended_desc = "Takes an existing record, writes a field, and outputs the edited record."
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"record" = IC_PINTYPE_LIST,
		"field" = IC_PINTYPE_STRING,
		"value" = IC_PINTYPE_ANY
	)

	outputs = list(
		"record" = IC_PINTYPE_LIST,
		"success" = IC_PINTYPE_BOOLEAN
	)


/obj/item/integrated_circuit/server/record_writer/do_work()
	pull_data()

	var/list/input_record = get_pin_data(IC_INPUT, 1)
	var/field = get_pin_data(IC_INPUT, 2)
	var/value = get_pin_data(IC_INPUT, 3)

	var/list/output_record = list()
	var/success = FALSE

	if(islist(input_record))
		output_record = input_record.Copy()

	if(istext(field) && length(field))
		output_record[field] = value
		success = TRUE

	set_pin_data(IC_OUTPUT, 1, output_record)
	set_pin_data(IC_OUTPUT, 2, success)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/record_keys
	name = "record keys"
	desc = "Outputs a list of keys from an associative list record."
	extended_desc = "Useful for reading database records and checking their field names."
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"record" = IC_PINTYPE_LIST
	)

	outputs = list(
		"keys" = IC_PINTYPE_LIST,
		"length" = IC_PINTYPE_NUMBER
	)


/obj/item/integrated_circuit/server/record_keys/do_work()
	pull_data()

	var/list/record = get_pin_data(IC_INPUT, 1)
	var/list/keys = list()

	if(islist(record))
		for(var/K in record)
			keys.Add(K)

	set_pin_data(IC_OUTPUT, 1, keys)
	set_pin_data(IC_OUTPUT, 2, keys.len)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/text_contains
	name = "text contains"
	desc = "Checks if one text value contains another."
	extended_desc = "Useful for filtering logs, messages, status strings, or command text."
	icon_state = "textpad"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"text" = IC_PINTYPE_STRING,
		"search" = IC_PINTYPE_STRING,
		"case sensitive" = IC_PINTYPE_BOOLEAN
	)

	inputs_default = list(
		"3" = FALSE
	)

	outputs = list(
		"contains" = IC_PINTYPE_BOOLEAN,
		"position" = IC_PINTYPE_NUMBER
	)


/obj/item/integrated_circuit/server/text_contains/do_work()
	pull_data()

	var/text = get_pin_data(IC_INPUT, 1)
	var/search = get_pin_data(IC_INPUT, 2)
	var/case_sensitive = get_pin_data(IC_INPUT, 3)

	var/position = 0

	if(istext(text) && istext(search) && length(search))
		if(case_sensitive)
			position = findtext(text, search)
		else
			position = findtext(lowertext(text), lowertext(search))

	set_pin_data(IC_OUTPUT, 1, position > 0)
	set_pin_data(IC_OUTPUT, 2, position)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/queue_push
	name = "queue push"
	desc = "Adds a value to the end of a queue list."
	extended_desc = "Use this with database APPEND or with a retrieved list."
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"queue" = IC_PINTYPE_LIST,
		"value" = IC_PINTYPE_ANY
	)

	outputs = list(
		"queue" = IC_PINTYPE_LIST,
		"length" = IC_PINTYPE_NUMBER
	)


/obj/item/integrated_circuit/server/queue_push/do_work()
	pull_data()

	var/list/input_queue = get_pin_data(IC_INPUT, 1)
	var/value = get_pin_data(IC_INPUT, 2)

	var/list/output_queue = list()

	if(islist(input_queue))
		output_queue = input_queue.Copy()

	output_queue.Add(value)

	set_pin_data(IC_OUTPUT, 1, output_queue)
	set_pin_data(IC_OUTPUT, 2, output_queue.len)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/queue_pop
	name = "queue pop"
	desc = "Removes and outputs the first value from a queue list."
	extended_desc = "Outputs the first list item separately, then outputs the remaining list as a new queue."
	icon_state = "subtraction"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"queue" = IC_PINTYPE_LIST
	)

	outputs = list(
		"value" = IC_PINTYPE_ANY,
		"remaining queue" = IC_PINTYPE_LIST,
		"had value" = IC_PINTYPE_BOOLEAN
	)


/obj/item/integrated_circuit/server/queue_pop/do_work()
	pull_data()

	var/list/input_queue = get_pin_data(IC_INPUT, 1)
	var/list/output_queue = list()
	var/value = null
	var/had_value = FALSE

	if(islist(input_queue))
		output_queue = input_queue.Copy()

	if(output_queue.len)
		value = output_queue[1]
		output_queue.Cut(1, 2)
		had_value = TRUE

	set_pin_data(IC_OUTPUT, 1, value)
	set_pin_data(IC_OUTPUT, 2, output_queue)
	set_pin_data(IC_OUTPUT, 3, had_value)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/list_first_last
	name = "list first/last"
	desc = "Outputs the first and last values from a list."
	extended_desc = "Useful for logs, queues, and message buffers."
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"list" = IC_PINTYPE_LIST
	)

	outputs = list(
		"first" = IC_PINTYPE_ANY,
		"last" = IC_PINTYPE_ANY,
		"length" = IC_PINTYPE_NUMBER,
		"has values" = IC_PINTYPE_BOOLEAN
	)


/obj/item/integrated_circuit/server/list_first_last/do_work()
	pull_data()

	var/list/input_list = get_pin_data(IC_INPUT, 1)

	var/first = null
	var/last = null
	var/length = 0
	var/has_values = FALSE

	if(islist(input_list))
		length = input_list.len

		if(length)
			first = input_list[1]
			last = input_list[length]
			has_values = TRUE

	set_pin_data(IC_OUTPUT, 1, first)
	set_pin_data(IC_OUTPUT, 2, last)
	set_pin_data(IC_OUTPUT, 3, length)
	set_pin_data(IC_OUTPUT, 4, has_values)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/database_counter
	name = "database counter client"
	desc = "Reads a numeric database value, changes it, and writes it back."
	extended_desc = "Useful for scores, cycle counts, alarm counts, and quotas."
	icon_state = "addition"
	complexity = 5
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"server id" = IC_PINTYPE_STRING,
		"key" = IC_PINTYPE_STRING,
		"amount" = IC_PINTYPE_NUMBER
	)

	inputs_default = list(
		"1" = "main",
		"3" = 1
	)

	outputs = list(
		"success" = IC_PINTYPE_BOOLEAN,
		"new value" = IC_PINTYPE_NUMBER,
		"status" = IC_PINTYPE_STRING
	)


/obj/item/integrated_circuit/server/database_counter/do_work()
	pull_data()

	var/database_id = ic_normalize_database_id(get_pin_data(IC_INPUT, 1))
	var/key = get_pin_data(IC_INPUT, 2)
	var/amount = get_pin_data(IC_INPUT, 3)

	var/success = FALSE
	var/new_value = 0
	var/status = "Server not found."

	if(isnull(amount))
		amount = 1

	if(!istext(key) || !length(key))
		status = "Counter requires a text key."
	else
		var/obj/item/integrated_circuit/server/database/S = GLOB.ic_database_servers[database_id]

		if(istype(S))
			var/current = S.storage[key]

			if(isnum(current))
				new_value = current
			else
				new_value = 0

			new_value += amount
			S.storage[key] = new_value

			success = TRUE
			status = "Counter updated."

	set_pin_data(IC_OUTPUT, 1, success)
	set_pin_data(IC_OUTPUT, 2, new_value)
	set_pin_data(IC_OUTPUT, 3, status)

	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/server/database_compare_write
	name = "database compare-write client"
	desc = "Writes a database value only if the current value matches the expected value."
	extended_desc = "Useful for locks, queues, safe counters, and avoiding accidental overwrites."
	icon_state = "addition"
	complexity = 6
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"server id" = IC_PINTYPE_STRING,
		"key" = IC_PINTYPE_STRING,
		"expected value" = IC_PINTYPE_ANY,
		"new value" = IC_PINTYPE_ANY
	)

	inputs_default = list(
		"1" = "main"
	)

	outputs = list(
		"success" = IC_PINTYPE_BOOLEAN,
		"current value" = IC_PINTYPE_ANY,
		"status" = IC_PINTYPE_STRING
	)


/obj/item/integrated_circuit/server/database_compare_write/do_work()
	pull_data()

	var/database_id = ic_normalize_database_id(get_pin_data(IC_INPUT, 1))
	var/key = get_pin_data(IC_INPUT, 2)
	var/expected_value = get_pin_data(IC_INPUT, 3)
	var/new_value = get_pin_data(IC_INPUT, 4)

	var/success = FALSE
	var/current_value = null
	var/status = "Server not found."

	if(!istext(key) || !length(key))
		status = "Compare-write requires a text key."
	else
		var/obj/item/integrated_circuit/server/database/S = GLOB.ic_database_servers[database_id]

		if(istype(S))
			current_value = S.storage[key]

			if(current_value == expected_value)
				S.storage[key] = new_value
				current_value = new_value
				success = TRUE
				status = "Compare-write complete."
			else
				status = "Current value did not match expected value."

	set_pin_data(IC_OUTPUT, 1, success)
	set_pin_data(IC_OUTPUT, 2, current_value)
	set_pin_data(IC_OUTPUT, 3, status)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/server/command_pad
	name = "database command pad"
	desc = "Parses typed text commands and sends them to a database server."
	extended_desc = "Commands: READ key, WRITE key value, DELETE key, HAS key, KEYS, LEN, CLEAR, APPEND key value."
	icon_state = "addition"
	complexity = 6
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"server id" = IC_PINTYPE_STRING,
		"command text" = IC_PINTYPE_STRING
	)

	inputs_default = list(
		"1" = "research"
	)

	outputs = list(
		"success" = IC_PINTYPE_BOOLEAN,
		"response" = IC_PINTYPE_ANY,
		"status" = IC_PINTYPE_STRING,
		"parsed command" = IC_PINTYPE_STRING,
		"parsed key" = IC_PINTYPE_STRING,
		"parsed value" = IC_PINTYPE_STRING
	)

	activators = list(
		"submit" = IC_PINTYPE_PULSE_IN,
		"on accepted" = IC_PINTYPE_PULSE_OUT,
		"on rejected" = IC_PINTYPE_PULSE_OUT
	)


/obj/item/integrated_circuit/server/command_pad/do_work()
	pull_data()

	var/database_id = ic_normalize_database_id(get_pin_data(IC_INPUT, 1))
	var/raw_text = get_pin_data(IC_INPUT, 2)

	var/success = FALSE
	var/response = null
	var/status = "No command."
	var/parsed_command = null
	var/parsed_key = null
	var/parsed_value = null

	if(!istext(raw_text) || !length(raw_text))
		set_pin_data(IC_OUTPUT, 1, FALSE)
		set_pin_data(IC_OUTPUT, 2, null)
		set_pin_data(IC_OUTPUT, 3, "Command pad requires text.")
		set_pin_data(IC_OUTPUT, 4, null)
		set_pin_data(IC_OUTPUT, 5, null)
		set_pin_data(IC_OUTPUT, 6, null)
		push_data()
		activate_pin(3)
		return

	var/text = trim(raw_text)
	var/first_space = findtext(text, " ")

	if(first_space)
		parsed_command = uppertext(trim(copytext(text, 1, first_space)))
		var/remainder = trim(copytext(text, first_space + 1))

		var/second_space = findtext(remainder, " ")
		if(second_space)
			parsed_key = trim(copytext(remainder, 1, second_space))
			parsed_value = trim(copytext(remainder, second_space + 1))
		else
			parsed_key = remainder
	else
		parsed_command = uppertext(text)

	switch(parsed_command)
		if("READ")
			parsed_command = "GET"

		if("WRITE")
			parsed_command = "SET"

		if("REMOVE")
			parsed_command = "DELETE"

		if("ADD")
			parsed_command = "APPEND"

	var/obj/item/integrated_circuit/server/database/S = GLOB.ic_database_servers[database_id]

	if(!istype(S))
		status = "Server not found."
	else
		var/list/result = S.handle_request(parsed_command, parsed_key, parsed_value)

		success = result["success"]
		response = result["response"]
		status = result["status"]

	set_pin_data(IC_OUTPUT, 1, success)
	set_pin_data(IC_OUTPUT, 2, response)
	set_pin_data(IC_OUTPUT, 3, status)
	set_pin_data(IC_OUTPUT, 4, parsed_command)
	set_pin_data(IC_OUTPUT, 5, parsed_key)
	set_pin_data(IC_OUTPUT, 6, parsed_value)

	push_data()

	if(success)
		activate_pin(2)
	else
		activate_pin(3)
