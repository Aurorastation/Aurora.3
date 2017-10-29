/obj/item/integrated_circuit/transfer
	category_text = "Data Transfer"
	power_draw_per_use = 2

/obj/item/integrated_circuit/transfer/multiplexer
	name = "two multiplexer"
	desc = "This is what those in the business tend to refer to as a 'mux' or data selector. It moves data from one of the selected inputs to the output."
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
	power_draw_per_use = 4
	var/number_of_inputs = 2

/obj/item/integrated_circuit/transfer/multiplexer/Initialize()
	for(var/i = 1 to number_of_inputs)
		inputs["input [i]"] = IC_PINTYPE_ANY // This is just a string since pins don't get built until ..() is called.

	complexity = number_of_inputs
	. = ..()
	desc += " It has [number_of_inputs] input pins."
	extended_desc += " This multiplexer has a range from 1 to [inputs.len - 1]."

/obj/item/integrated_circuit/transfer/multiplexer/do_work()
	var/input_index = get_pin_data(IC_INPUT, 1)
	var/output = null

	if(!isnull(input_index) && (input_index >= 1 && input_index < inputs.len))
		output = get_pin_data(IC_INPUT, input_index + 1)

	set_pin_data(IC_OUTPUT, 1, output)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/transfer/multiplexer/medium
	name = "four multiplexer"
	number_of_inputs = 4
	icon_state = "mux4"

/obj/item/integrated_circuit/transfer/multiplexer/large
	name = "eight multiplexer"
	number_of_inputs = 8
	w_class = ITEMSIZE_SMALL
	icon_state = "mux8"

/obj/item/integrated_circuit/transfer/multiplexer/huge
	name = "sixteen multiplexer"
	icon_state = "mux16"
	w_class = ITEMSIZE_SMALL
	number_of_inputs = 16

/obj/item/integrated_circuit/transfer/demultiplexer
	name = "two demultiplexer"
	desc = "This is what those in the business tend to refer to as a 'demux'. It moves data from the input to one of the selected outputs."
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
	power_draw_per_use = 4
	var/number_of_outputs = 2

/obj/item/integrated_circuit/transfer/demultiplexer/Initialize()
	for(var/i = 1 to number_of_outputs)
		outputs["output [i]"] = IC_PINTYPE_ANY
	complexity = number_of_outputs

	. = ..()
	desc += " It has [number_of_outputs] output pins."
	extended_desc += " This demultiplexer has a range from 1 to [outputs.len]."

/obj/item/integrated_circuit/transfer/demultiplexer/do_work()
	var/output_index = get_pin_data(IC_INPUT, 1)
	var/output = get_pin_data(IC_INPUT, 2)

	for(var/i = 1 to outputs.len)
		set_pin_data(IC_OUTPUT, i, i == output_index ? output : null)
	
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/transfer/demultiplexer/medium
	name = "four demultiplexer"
	icon_state = "dmux4"
	number_of_outputs = 4

/obj/item/integrated_circuit/transfer/demultiplexer/large
	name = "eight demultiplexer"
	icon_state = "dmux8"
	w_class = ITEMSIZE_SMALL
	number_of_outputs = 8

/obj/item/integrated_circuit/transfer/demultiplexer/huge
	name = "sixteen demultiplexer"
	icon_state = "dmux16"
	w_class = ITEMSIZE_SMALL
	number_of_outputs = 16

/obj/item/integrated_circuit/transfer/wireless
	name = "subspace transceiver"
	desc = "A wireless transmitter-receiver pair that can transmit data between devices."
	extended_desc = "The first input is the data to send to the other device, and the second input is the channel to send it on."
	complexity = 12
	spawn_flags = IC_SPAWN_RESEARCH
	icon_state = "bluespace"
	power_draw_per_use = 100	// fancy subspace comms aren't cheap power-wise
	w_class = ITEMSIZE_SMALL
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

	var/last_channel

	var/listener/listener

/obj/item/integrated_circuit/transfer/wireless/do_work()
	pull_data()

	var/data = get_pin_data(IC_INPUT, 1)
	if (data != null)
		var/chan = "[WP_ELECTRONICS][get_pin_data(IC_INPUT, 2) || "default"]"
		for (var/thing in GET_LISTENERS(chan))
			var/listener/L = thing
			var/obj/item/integrated_circuit/transfer/wireless/W = L.target
			if (W != src)
				W.receive(data)

/obj/item/integrated_circuit/transfer/wireless/proc/receive(datum/data)
	set_pin_data(IC_OUTPUT, 1, data)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/transfer/wireless/Destroy()
	QDEL_NULL(listener)
	return ..()

/obj/item/integrated_circuit/transfer/wireless/on_data_written()
	var/chan = "[WP_ELECTRONICS][get_pin_data(IC_INPUT, 2) || "default"]"
	if (chan != last_channel)
		QDEL_NULL(listener)
		listener = new(chan, src)
		last_channel = chan
