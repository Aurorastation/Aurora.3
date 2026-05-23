/*
 * subtypes/built_in.dm
 * Built-in non-removable circuits used by assemblies to expose internal behavior to normal circuit networks.
 */

/// integrated circuit: Base integrated circuit component.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/built_in
	name = "integrated circuit"
	desc = "A base integrated circuit component."
	icon = 'icons/obj/assemblies/electronic_components.dmi'
	icon_state = "template"
	size = -1
	w_class = WEIGHT_CLASS_TINY
	removable = FALSE 			// Determines if a circuit is removable from the assembly.

/// assembly input: A built-in chip for handling pulses from attached assembly items.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/built_in/device_input
	name = "assembly input"
	desc = "A built-in chip for handling pulses from attached assembly items."
	complexity = 0 				//This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	activators = list("on pulsed" = IC_PINTYPE_PULSE_OUT)

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/built_in/device_input/do_work()
	activate_pin(1)

/// assembly out: A built-in chip for pulsing attached assembly items.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/built_in/device_output
	name = "assembly out"
	desc = "A built-in chip for pulsing attached assembly items."
	complexity = 0 				//This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	activators = list("pulse attached" = IC_PINTYPE_PULSE_IN)

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/built_in/device_output/do_work()
	if(istype(assembly, /obj/item/electronic_assembly/device))
		var/obj/item/electronic_assembly/device/device = assembly
		device.holder.pulse()

// Triggered when clothing assembly's hud button is clicked, used in-hand, or when another clothing-specific interaction occurs (like touching something with gloves on).
/// external trigger circuit: A built-in chip that outputs a pulse when an external control event occurs. It also provides additional data depending on the nature of the event and device. This outputs a pulse if the assembly's HUD button is clicke....
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/built_in/action_button
	name = "external trigger circuit"
	desc = "A built-in chip that outputs a pulse when an external control event occurs. It also provides additional data depending on the nature of the event and device."
	extended_desc = "This outputs a pulse if the assembly's HUD button is clicked while the assembly is closed."
	complexity = 0
	activators = list("on activation" = IC_PINTYPE_PULSE_OUT)
	outputs = list("output" = IC_PINTYPE_ANY)

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/built_in/action_button/do_work()
	activate_pin(1)
