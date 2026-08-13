/*
 * subtypes/debug.dm
 * Debug/testing circuits used to inspect values, format helper output, and verify integrated electronics behavior.
 */

/obj/item/integrated_circuit/debug
	category_text = "Debugging"
	complexity = 1
	spawn_flags = 0

/obj/item/integrated_circuit/debug/helper_test
	name = "helper test circuit"
	desc = "Tests integrated circuit helper procs."
	extended_desc = "Outputs formatted helper proc results from one input."
	icon_state = "template"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	inputs = list(
		"input" = IC_PINTYPE_STRING,
		"number input" = IC_PINTYPE_STRING,
		"template" = IC_PINTYPE_STRING
	)
	outputs = list(
		"display value" = IC_PINTYPE_STRING,
		"type text" = IC_PINTYPE_STRING,
		"safe number" = IC_PINTYPE_NUMBER,
		"template output" = IC_PINTYPE_STRING
	)
	activators = list(
		"test" = IC_PINTYPE_PULSE_IN,
		"on tested" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/debug/helper_test/do_work()
	pull_data()

	var/input_value = get_pin_data(IC_INPUT, 1)
	var/number_value = get_pin_data(IC_INPUT, 2)
	var/template_value = get_pin_data(IC_INPUT, 3)

	set_pin_data(IC_OUTPUT, 1, ic_display_value(input_value))
	set_pin_data(IC_OUTPUT, 2, ic_type_text(input_value))
	set_pin_data(IC_OUTPUT, 3, ic_safe_number(number_value, 0))
	set_pin_data(IC_OUTPUT, 4, ic_apply_template(template_value, input_value, number_value, ic_type_text(input_value)))

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/debug/one_shot_pulse
	name = "one-shot pulse"
	desc = "Allows one pulse through, then blocks further pulses until reset."
	extended_desc = "This circuit is useful for preventing repeated signals. When triggered, it sends one pulse if it has not already fired. After firing, it will ignore further trigger pulses until the reset activator is pulsed."
	icon_state = "template"
	complexity = 2
	w_class = WEIGHT_CLASS_TINY
	size = 1
	power_draw_per_use = 50
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	var/has_fired = FALSE

	inputs = list(
		"enabled" = IC_PINTYPE_BOOLEAN
	)

	outputs = list(
		"has fired" = IC_PINTYPE_BOOLEAN
	)

	activators = list(
		"trigger" = IC_PINTYPE_PULSE_IN,
		"reset" = IC_PINTYPE_PULSE_IN,
		"pulse out" = IC_PINTYPE_PULSE_OUT,
		"blocked" = IC_PINTYPE_PULSE_OUT
	)

/obj/item/integrated_circuit/debug/one_shot_pulse/do_work(activator_id)
	var/active_pin = activator_id

	if(istype(active_pin, /datum/integrated_io))
		active_pin = activators.Find(active_pin)

	if(istext(active_pin))
		for(var/i = 1 to activators.len)
			var/datum/integrated_io/A = activators[i]
			if(A.name == active_pin)
				active_pin = i
				break

	if(!isnum(active_pin))
		active_pin = 1

	switch(active_pin)
		if(1)
			trigger_once()
			return
		if(2)
			reset_latch()
			return

/obj/item/integrated_circuit/debug/one_shot_pulse/proc/trigger_once()
	pull_data()

	var/enabled = get_pin_data(IC_INPUT, 1)

	if(!enabled)
		enabled = TRUE

	if(!enabled)
		set_pin_data(IC_OUTPUT, 1, has_fired)
		push_data()
		activate_pin(4)
		return

	if(has_fired)
		set_pin_data(IC_OUTPUT, 1, has_fired)
		push_data()
		activate_pin(4)
		return

	has_fired = TRUE
	set_pin_data(IC_OUTPUT, 1, has_fired)
	push_data()
	activate_pin(3)

/obj/item/integrated_circuit/debug/one_shot_pulse/proc/reset_latch()
	has_fired = FALSE
	set_pin_data(IC_OUTPUT, 1, has_fired)
	push_data()

/obj/item/integrated_circuit/debug/one_shot_pulse/copy_clone_state_to(obj/item/integrated_circuit/target)
	var/obj/item/integrated_circuit/debug/one_shot_pulse/new_latch = target
	if(!istype(new_latch))
		return

	new_latch.has_fired = has_fired

/obj/item/integrated_circuit/debug/blank
	name = "debug marker"
	desc = "A blank debug circuit. It does nothing and exists only as a movable, removable, renameable marker."
	extended_desc = "This circuit has no inputs, outputs, or activators. It is useful as a spacer, label, or visual divider inside an assembly."
	icon_state = "template"
	complexity = 0
	size = 0
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list()
	outputs = list()
	activators = list()

/obj/item/integrated_circuit/debug/blank/do_work()
	return
