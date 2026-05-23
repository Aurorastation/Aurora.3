/*
 * passive/passive.dm
 * Base passive circuit category for circuits that provide background behavior instead of triggered work.
 */

// 'Passive' components do not have any pins, and instead contribute in some form to the assembly holding them.
/// passive: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/passive
	inputs = list()
	outputs = list()
	activators = list()
	power_draw_idle = 0
	power_draw_per_use = 0
