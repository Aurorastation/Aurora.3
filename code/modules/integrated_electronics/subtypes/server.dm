/*
 * subtypes/server.dm
 * Data server circuits that store shared values and allow other circuits to push, pull, or query keyed data.
 */

GLOBAL_LIST_EMPTY(ic_database_servers)

/// Implements `ic_normalize_database_id` behavior for this integrated electronics type.
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


/// server: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/server
	category_text = "Data Server"
	complexity = 2
	power_draw_per_use = 300
	spawn_flags = 0
	activators = list(
		"compute" = IC_PINTYPE_PULSE_IN,
		"on computed" = IC_PINTYPE_PULSE_OUT
	)


/// database server: A keyed database server for integrated circuits. Stores keyed values for server client circuits. Commands: GET, SET, DELETE, CLEAR, HAS, KEYS, LEN, APPEND.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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

	// Stores `database_id` state used by this integrated electronics object.
	var/database_id = "main"
	// Stores `storage` state used by this integrated electronics object.
	var/list/storage = list()


/// Initializes runtime state after the parent type is constructed.
/obj/item/integrated_circuit/server/database/Initialize()
	. = ..()
	register_database()


/// Releases owned objects and clears references before parent deletion runs.
/obj/item/integrated_circuit/server/database/Destroy()
	unregister_database()
	storage = null
	return ..()


/// Implements `register_database` behavior for this integrated electronics type.
/obj/item/integrated_circuit/server/database/proc/register_database()
	database_id = ic_normalize_database_id(database_id)
	GLOB.ic_database_servers[database_id] = src


/// Implements `unregister_database` behavior for this integrated electronics type.
/obj/item/integrated_circuit/server/database/proc/unregister_database()
	if(database_id && GLOB.ic_database_servers[database_id] == src)
		GLOB.ic_database_servers -= database_id


/// Sets `database_id` and performs any required follow-up bookkeeping.
/obj/item/integrated_circuit/server/database/proc/set_database_id(new_id)
	new_id = ic_normalize_database_id(new_id)

	if(new_id == database_id)
		return

	unregister_database()
	database_id = new_id
	register_database()


/// Implements `handle_request` behavior for this integrated electronics type.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/database/do_work()
	pull_data()

	// Stores `new_id` state used by this integrated electronics object.
	var/new_id = get_pin_data(IC_INPUT, 1)
	// Stores `command` state used by this integrated electronics object.
	var/command = get_pin_data(IC_INPUT, 2)
	// Stores `key` state used by this integrated electronics object.
	var/key = get_pin_data(IC_INPUT, 3)
	// Stores `value` state used by this integrated electronics object.
	var/value = get_pin_data(IC_INPUT, 4)

	set_database_id(new_id)

	// Stores `result` state used by this integrated electronics object.
	var/list/result = handle_request(command, key, value)

	set_pin_data(IC_OUTPUT, 1, result["success"])
	set_pin_data(IC_OUTPUT, 2, result["response"])
	set_pin_data(IC_OUTPUT, 3, result["status"])

	push_data()
	activate_pin(2)


/// database client: Sends requests to a database server. Targets a database server by server id. Commands: GET, SET, DELETE, CLEAR, HAS, KEYS, LEN, APPEND.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/client/do_work()
	pull_data()

	// Stores `database_id` state used by this integrated electronics object.
	var/database_id = ic_normalize_database_id(get_pin_data(IC_INPUT, 1))
	// Stores `command` state used by this integrated electronics object.
	var/command = get_pin_data(IC_INPUT, 2)
	// Stores `key` state used by this integrated electronics object.
	var/key = get_pin_data(IC_INPUT, 3)
	// Stores `value` state used by this integrated electronics object.
	var/value = get_pin_data(IC_INPUT, 4)

	// Stores `result` state used by this integrated electronics object.
	var/list/result = ic_database_response(FALSE, null, "Server not found.")

	// Stores `S` state used by this integrated electronics object.
	var/obj/item/integrated_circuit/server/database/S = GLOB.ic_database_servers[database_id]

	if(istype(S))
		result = S.handle_request(command, key, value)

	set_pin_data(IC_OUTPUT, 1, result["success"])
	set_pin_data(IC_OUTPUT, 2, result["response"])
	set_pin_data(IC_OUTPUT, 3, result["status"])

	push_data()
	activate_pin(2)


/// database scanner: Outputs a list of active database server ids. Useful for debugging database wiring or discovering which database servers are available.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/scanner/do_work()
	// Stores `server_ids` state used by this integrated electronics object.
	var/list/server_ids = list()

	for(var/database_id in GLOB.ic_database_servers)
		var/obj/item/integrated_circuit/server/database/S = GLOB.ic_database_servers[database_id]

		if(istype(S))
			server_ids.Add(database_id)

	set_pin_data(IC_OUTPUT, 1, server_ids)
	set_pin_data(IC_OUTPUT, 2, server_ids.len)

	push_data()
	activate_pin(2)


/// 4-field record builder: Builds an associative list record from up to four key/value pairs. This is useful for making database records like pressure, oxygen, temperature, and status.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/record_builder4/do_work()
	pull_data()

	// Stores `record` state used by this integrated electronics object.
	var/list/record = list()

	// Stores `key1` state used by this integrated electronics object.
	var/key1 = get_pin_data(IC_INPUT, 1)
	// Stores `value1` state used by this integrated electronics object.
	var/value1 = get_pin_data(IC_INPUT, 2)
	if(istext(key1) && length(key1))
		record += key1
		record += value1

	// Stores `key2` state used by this integrated electronics object.
	var/key2 = get_pin_data(IC_INPUT, 3)
	// Stores `value2` state used by this integrated electronics object.
	var/value2 = get_pin_data(IC_INPUT, 4)
	if(istext(key2) && length(key2))
		record += key2
		record += value2

	// Stores `key3` state used by this integrated electronics object.
	var/key3 = get_pin_data(IC_INPUT, 5)
	// Stores `value3` state used by this integrated electronics object.
	var/value3 = get_pin_data(IC_INPUT, 6)
	if(istext(key3) && length(key3))
		record += key3
		record += value3

	// Stores `key4` state used by this integrated electronics object.
	var/key4 = get_pin_data(IC_INPUT, 7)
	// Stores `value4` state used by this integrated electronics object.
	var/value4 = get_pin_data(IC_INPUT, 8)
	if(istext(key4) && length(key4))
		record += key4
		record += value4

	set_pin_data(IC_OUTPUT, 1, record)

	push_data()
	activate_pin(2)


/// 8-field record builder: Builds an associative list record from up to eight key/value pairs. This is useful for larger database records.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/record_builder8/do_work()
	pull_data()

	// Stores `record` state used by this integrated electronics object.
	var/list/record = list()

	// Stores `key1` state used by this integrated electronics object.
	var/key1 = get_pin_data(IC_INPUT, 1)
	// Stores `value1` state used by this integrated electronics object.
	var/value1 = get_pin_data(IC_INPUT, 2)
	if(istext(key1) && length(key1))
		record += key1
		record += value1

	// Stores `key2` state used by this integrated electronics object.
	var/key2 = get_pin_data(IC_INPUT, 3)
	// Stores `value2` state used by this integrated electronics object.
	var/value2 = get_pin_data(IC_INPUT, 4)
	if(istext(key2) && length(key2))
		record += key2
		record += value2

	// Stores `key3` state used by this integrated electronics object.
	var/key3 = get_pin_data(IC_INPUT, 5)
	// Stores `value3` state used by this integrated electronics object.
	var/value3 = get_pin_data(IC_INPUT, 6)
	if(istext(key3) && length(key3))
		record += key3
		record += value3

	// Stores `key4` state used by this integrated electronics object.
	var/key4 = get_pin_data(IC_INPUT, 7)
	// Stores `value4` state used by this integrated electronics object.
	var/value4 = get_pin_data(IC_INPUT, 8)
	if(istext(key4) && length(key4))
		record += key4
		record += value4

	// Stores `key5` state used by this integrated electronics object.
	var/key5 = get_pin_data(IC_INPUT, 9)
	// Stores `value5` state used by this integrated electronics object.
	var/value5 = get_pin_data(IC_INPUT, 10)
	if(istext(key5) && length(key5))
		record += key5
		record += value5

	// Stores `key6` state used by this integrated electronics object.
	var/key6 = get_pin_data(IC_INPUT, 11)
	// Stores `value6` state used by this integrated electronics object.
	var/value6 = get_pin_data(IC_INPUT, 12)
	if(istext(key6) && length(key6))
		record += key6
		record += value6

	// Stores `key7` state used by this integrated electronics object.
	var/key7 = get_pin_data(IC_INPUT, 13)
	// Stores `value7` state used by this integrated electronics object.
	var/value7 = get_pin_data(IC_INPUT, 14)
	if(istext(key7) && length(key7))
		record += key7
		record += value7

	// Stores `key8` state used by this integrated electronics object.
	var/key8 = get_pin_data(IC_INPUT, 15)
	// Stores `value8` state used by this integrated electronics object.
	var/value8 = get_pin_data(IC_INPUT, 16)
	if(istext(key8) && length(key8))
		record += key8
		record += value8

	set_pin_data(IC_OUTPUT, 1, record)

	push_data()
	activate_pin(2)


/// record reader: Reads one field from an associative list record. Use this after a database GET returns a record list.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/record_reader/do_work()
	pull_data()

	// Stores `record` state used by this integrated electronics object.
	var/list/record = get_pin_data(IC_INPUT, 1)
	// Stores `field` state used by this integrated electronics object.
	var/field = get_pin_data(IC_INPUT, 2)

	// Stores `value` state used by this integrated electronics object.
	var/value = null
	// Stores `found` state used by this integrated electronics object.
	var/found = FALSE

	if(islist(record) && istext(field) && length(field))
		for(var/i = 1; i < record.len; i += 2)
			if(record[i] == field)
				value = record[i + 1]
				found = TRUE
				break

	set_pin_data(IC_OUTPUT, 1, value)
	set_pin_data(IC_OUTPUT, 2, found)

	push_data()
	activate_pin(2)


/// record writer: Writes one field into an associative list record. Takes an existing record, writes a field, and outputs the edited record.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/record_writer/do_work()
	pull_data()

	// Stores `input_record` state used by this integrated electronics object.
	var/list/input_record = get_pin_data(IC_INPUT, 1)
	// Stores `field` state used by this integrated electronics object.
	var/field = get_pin_data(IC_INPUT, 2)
	// Stores `value` state used by this integrated electronics object.
	var/value = get_pin_data(IC_INPUT, 3)

	// Stores `output_record` state used by this integrated electronics object.
	var/list/output_record = list()
	// Stores `success` state used by this integrated electronics object.
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


/// record keys: Outputs a list of keys from an associative list record. Useful for reading database records and checking their field names.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/record_keys/do_work()
	pull_data()

	// Stores `record` state used by this integrated electronics object.
	var/list/record = get_pin_data(IC_INPUT, 1)
	// Stores `keys` state used by this integrated electronics object.
	var/list/keys = list()

	if(islist(record))
		for(var/K in record)
			keys.Add(K)

	set_pin_data(IC_OUTPUT, 1, keys)
	set_pin_data(IC_OUTPUT, 2, keys.len)

	push_data()
	activate_pin(2)


/// text contains: Checks if one text value contains another. Useful for filtering logs, messages, status strings, or command text.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/text_contains/do_work()
	pull_data()

	// Stores `text` state used by this integrated electronics object.
	var/text = get_pin_data(IC_INPUT, 1)
	// Stores `search` state used by this integrated electronics object.
	var/search = get_pin_data(IC_INPUT, 2)
	// Stores `case_sensitive` state used by this integrated electronics object.
	var/case_sensitive = get_pin_data(IC_INPUT, 3)

	// Stores `position` state used by this integrated electronics object.
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


/// queue push: Adds a value to the end of a queue list. Use this with database APPEND or with a retrieved list.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/queue_push/do_work()
	pull_data()

	// Stores `input_queue` state used by this integrated electronics object.
	var/list/input_queue = get_pin_data(IC_INPUT, 1)
	// Stores `value` state used by this integrated electronics object.
	var/value = get_pin_data(IC_INPUT, 2)

	// Stores `output_queue` state used by this integrated electronics object.
	var/list/output_queue = list()

	if(islist(input_queue))
		output_queue = input_queue.Copy()

	output_queue.Add(value)

	set_pin_data(IC_OUTPUT, 1, output_queue)
	set_pin_data(IC_OUTPUT, 2, output_queue.len)

	push_data()
	activate_pin(2)


/// queue pop: Removes and outputs the first value from a queue list. Outputs the first list item separately, then outputs the remaining list as a new queue.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/queue_pop/do_work()
	pull_data()

	// Stores `input_queue` state used by this integrated electronics object.
	var/list/input_queue = get_pin_data(IC_INPUT, 1)
	// Stores `output_queue` state used by this integrated electronics object.
	var/list/output_queue = list()
	// Stores `value` state used by this integrated electronics object.
	var/value = null
	// Stores `had_value` state used by this integrated electronics object.
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


/// list first/last: Outputs the first and last values from a list. Useful for logs, queues, and message buffers.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/list_first_last/do_work()
	pull_data()

	// Stores `input_list` state used by this integrated electronics object.
	var/list/input_list = get_pin_data(IC_INPUT, 1)

	// Stores `first` state used by this integrated electronics object.
	var/first = null
	// Stores `last` state used by this integrated electronics object.
	var/last = null
	// Stores `length` state used by this integrated electronics object.
	var/length = 0
	// Stores `has_values` state used by this integrated electronics object.
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


/// database counter client: Reads a numeric database value, changes it, and writes it back. Useful for scores, cycle counts, alarm counts, and quotas.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/database_counter/do_work()
	pull_data()

	// Stores `database_id` state used by this integrated electronics object.
	var/database_id = ic_normalize_database_id(get_pin_data(IC_INPUT, 1))
	// Stores `key` state used by this integrated electronics object.
	var/key = get_pin_data(IC_INPUT, 2)
	// Stores `amount` state used by this integrated electronics object.
	var/amount = get_pin_data(IC_INPUT, 3)

	// Stores `success` state used by this integrated electronics object.
	var/success = FALSE
	// Stores `new_value` state used by this integrated electronics object.
	var/new_value = 0
	// Stores `status` state used by this integrated electronics object.
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


/// database compare-write client: Writes a database value only if the current value matches the expected value. Useful for locks, queues, safe counters, and avoiding accidental overwrites.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/database_compare_write/do_work()
	pull_data()

	// Stores `database_id` state used by this integrated electronics object.
	var/database_id = ic_normalize_database_id(get_pin_data(IC_INPUT, 1))
	// Stores `key` state used by this integrated electronics object.
	var/key = get_pin_data(IC_INPUT, 2)
	// Stores `expected_value` state used by this integrated electronics object.
	var/expected_value = get_pin_data(IC_INPUT, 3)
	// Stores `new_value` state used by this integrated electronics object.
	var/new_value = get_pin_data(IC_INPUT, 4)

	// Stores `success` state used by this integrated electronics object.
	var/success = FALSE
	// Stores `current_value` state used by this integrated electronics object.
	var/current_value = null
	// Stores `status` state used by this integrated electronics object.
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

/// database command pad: Parses typed text commands and sends them to a database server. Commands: READ key, WRITE key value, DELETE key, HAS key, KEYS, LEN, CLEAR, APPEND key value.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
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


/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/server/command_pad/do_work()
	pull_data()

	// Stores `database_id` state used by this integrated electronics object.
	var/database_id = ic_normalize_database_id(get_pin_data(IC_INPUT, 1))
	// Stores `raw_text` state used by this integrated electronics object.
	var/raw_text = get_pin_data(IC_INPUT, 2)

	// Stores `success` state used by this integrated electronics object.
	var/success = FALSE
	// Stores `response` state used by this integrated electronics object.
	var/response = null
	// Stores `status` state used by this integrated electronics object.
	var/status = "No command."
	// Stores `parsed_command` state used by this integrated electronics object.
	var/parsed_command = null
	// Stores `parsed_key` state used by this integrated electronics object.
	var/parsed_key = null
	// Stores `parsed_value` state used by this integrated electronics object.
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
	// Stores `first_space` state used by this integrated electronics object.
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

	// Stores `S` state used by this integrated electronics object.
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
