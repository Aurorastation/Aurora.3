/*
 * subtypes/data_transfer.dm
 * Data transfer circuits for copying, routing, packing, or unpacking values between pins.
 */

/// transfer: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/transfer
	category_text = "Data Transfer"
	power_draw_per_use = 20

/// two multiplexer: Selects one input and sends that value to the output.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/transfer/multiplexer
	name = "two multiplexer"
	desc = "Selects one input and sends that value to the output."
	extended_desc = "The first input pin is used to select which of the other input pins which has its data moved to the output. \
	If the input selection is outside the valid range then no output is given."
	complexity = 2
	icon_state = "mux2"
	inputs = list("input selection" = IC_PINTYPE_NUMBER)
	outputs = list("output" = IC_PINTYPE_ANY)
	activators = list(
		"select" = IC_PINTYPE_PULSE_IN,
		"on select" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40
	// Stores `number_of_inputs` state used by this integrated electronics object.
	var/number_of_inputs = 2

/// Initializes runtime state after the parent type is constructed.
/obj/item/integrated_circuit/transfer/multiplexer/Initialize()
	for(var/i = 1 to number_of_inputs)
		inputs["input [i]"] = IC_PINTYPE_ANY // This is just a string since pins don't get built until ..() is called.

	complexity = number_of_inputs
	. = ..()
	desc += " It has [number_of_inputs] input pins."
	extended_desc += " This multiplexer has a range from 1 to [inputs.len - 1]."

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/transfer/multiplexer/do_work()
	// Stores `input_index` state used by this integrated electronics object.
	var/input_index = get_pin_data(IC_INPUT, 1)
	// Stores `output` state used by this integrated electronics object.
	var/output = null

	if(!isnull(input_index) && (input_index >= 1 && input_index < inputs.len))
		output = get_pin_data(IC_INPUT, input_index + 1)

	set_pin_data(IC_OUTPUT, 1, output)
	push_data()
	activate_pin(2)

/// four multiplexer: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/transfer/multiplexer/medium
	name = "four multiplexer"
	number_of_inputs = 4
	icon_state = "mux4"

/// eight multiplexer: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/transfer/multiplexer/large
	name = "eight multiplexer"
	number_of_inputs = 8
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "mux8"

/// sixteen multiplexer: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/transfer/multiplexer/huge
	name = "sixteen multiplexer"
	icon_state = "mux16"
	w_class = WEIGHT_CLASS_SMALL
	number_of_inputs = 16

/// two demultiplexer: Sends one input value to the selected output.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/transfer/demultiplexer
	name = "two demultiplexer"
	desc = "Sends one input value to the selected output."
	extended_desc = "The first input pin is used to select which of the output pins is given the data from the second input pin. \
	If the output selection is outside the valid range then no output is given."
	complexity = 2
	icon_state = "dmux2"
	inputs = list(
		"output selection" = IC_PINTYPE_NUMBER,
		"input" = IC_PINTYPE_ANY
	)
	outputs = list()
	activators = list(
		"select" = IC_PINTYPE_PULSE_IN,
		"on select" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 40
	// Stores `number_of_outputs` state used by this integrated electronics object.
	var/number_of_outputs = 2

/// Initializes runtime state after the parent type is constructed.
/obj/item/integrated_circuit/transfer/demultiplexer/Initialize()
	for(var/i = 1 to number_of_outputs)
		outputs["output [i]"] = IC_PINTYPE_ANY
	complexity = number_of_outputs

	. = ..()
	desc += " It has [number_of_outputs] output pins."
	extended_desc += " This demultiplexer has a range from 1 to [outputs.len]."

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/transfer/demultiplexer/do_work()
	// Stores `output_index` state used by this integrated electronics object.
	var/output_index = get_pin_data(IC_INPUT, 1)
	// Stores `output` state used by this integrated electronics object.
	var/output = get_pin_data(IC_INPUT, 2)

	for(var/i = 1 to outputs.len)
		set_pin_data(IC_OUTPUT, i, i == output_index ? output : null)

	push_data()
	activate_pin(2)

/// four demultiplexer: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/transfer/demultiplexer/medium
	name = "four demultiplexer"
	icon_state = "dmux4"
	number_of_outputs = 4

/// eight demultiplexer: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/transfer/demultiplexer/large
	name = "eight demultiplexer"
	icon_state = "dmux8"
	w_class = WEIGHT_CLASS_SMALL
	number_of_outputs = 8

/// sixteen demultiplexer: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/transfer/demultiplexer/huge
	name = "sixteen demultiplexer"
	icon_state = "dmux16"
	w_class = WEIGHT_CLASS_SMALL
	number_of_outputs = 16

/// subspace transceiver: Transmits data wirelessly between linked devices. The first input is the data to send. The second input selects the transmission channel.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/transfer/wireless
	name = "subspace transceiver"
	desc = "Transmits data wirelessly between linked devices."
	extended_desc = "The first input is the data to send. The second input selects the transmission channel."
	complexity = 12
	spawn_flags = IC_SPAWN_RESEARCH
	icon_state = "bluespace"
	power_draw_per_use = 1000	// fancy subspace comms aren't cheap power-wise
	w_class = WEIGHT_CLASS_SMALL
	inputs = list(
		"data" = IC_PINTYPE_ANY,
		"channel" = IC_PINTYPE_STRING
	)
	outputs = list(
		"data" = IC_PINTYPE_ANY
	)
	activators = list(
		"send" = IC_PINTYPE_PULSE_IN,
		"receive" = IC_PINTYPE_PULSE_OUT
	)

	// Stores `last_channel` state used by this integrated electronics object.
	var/last_channel

	// Stores `listener` state used by this integrated electronics object.
	var/listener/listener

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/transfer/wireless/do_work()
	pull_data()

	// Stores `data` state used by this integrated electronics object.
	var/data = get_pin_data(IC_INPUT, 1)
	if (data != null)
		var/chan = "[WP_ELECTRONICS][get_pin_data(IC_INPUT, 2) || "default"]"
		// ntsl2.receive_subspace(chan, data) TODO: KAROLIS Re add messaging
		for (var/thing in GET_LISTENERS(chan))
			var/listener/L = thing
			var/obj/item/integrated_circuit/transfer/wireless/W = L.target
			if (W != src)
				W.receive(data)

/// Implements `receive` behavior for this integrated electronics type.
/obj/item/integrated_circuit/transfer/wireless/proc/receive(datum/data)
	set_pin_data(IC_OUTPUT, 1, data)
	push_data()
	activate_pin(2)

/// Releases owned objects and clears references before parent deletion runs.
/obj/item/integrated_circuit/transfer/wireless/Destroy()
	QDEL_NULL(listener)
	return ..()

/// Implements `on_data_written` behavior for this integrated electronics type.
/obj/item/integrated_circuit/transfer/wireless/on_data_written()
	// Stores `chan` state used by this integrated electronics object.
	var/chan = "[WP_ELECTRONICS][get_pin_data(IC_INPUT, 2) || "default"]"
	if (chan != last_channel)
		QDEL_NULL(listener)
		listener = new(chan, src)
		last_channel = chan
