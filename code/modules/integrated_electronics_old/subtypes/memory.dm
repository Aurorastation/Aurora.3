/obj/item/integrated_circuit/memory
	complexity = 1
	category_text = "Memory"
	power_draw_per_use = 1

/obj/item/integrated_circuit/memory/storage
	name = "memory chip"
	icon_state = "memory1"
	desc = "This tiny chip can store one piece of data."
	inputs = list()
	outputs = list()
	activators = list(
		"set" = IC_PINTYPE_PULSE_IN,
		"on set" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/number_of_pins = 1

/obj/item/integrated_circuit/memory/storage/Initialize()
	for(var/i = 1 to number_of_pins)
		inputs["input [i]"] = IC_PINTYPE_ANY // This is just a string since pins don't get built until ..() is called.
		outputs["output [i]"] = IC_PINTYPE_ANY
	complexity = number_of_pins
	. = ..()

/obj/item/integrated_circuit/memory/storage/examine(mob/user)
	..()
	var/i
	for (i in 1 to outputs.len)
		var/datum/integrated_io/O = outputs[i]
		var/data = "nothing"
		if(isweakref(O.data))
			var/datum/d = O.data_as_type(/datum)
			if(d)
				data = "[d]"
		else if(!isnull(O.data))
			data = O.data
		to_chat(user, "\The [src] has [data] saved to address [i].")

/obj/item/integrated_circuit/memory/storage/do_work()
	for(var/i = 1 to inputs.len)
		var/data = get_pin_data(IC_INPUT, i)
		set_pin_data(IC_OUTPUT, i, data)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/memory/storage/medium
	name = "memory circuit"
	desc = "This circuit can store four pieces of data."
	icon_state = "memory4"
	power_draw_per_use = 2
	number_of_pins = 4

/obj/item/integrated_circuit/memory/storage/large
	name = "large memory circuit"
	desc = "This big circuit can hold eight pieces of data."
	icon_state = "memory8"
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 4
	number_of_pins = 8

/obj/item/integrated_circuit/memory/storage/huge
	name = "large memory stick"
	desc = "This stick of memory can hold up up to sixteen pieces of data."
	icon_state = "memory16"
	w_class = ITEMSIZE_NORMAL
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 4)
	power_draw_per_use = 8
	number_of_pins = 16

/obj/item/integrated_circuit/memory/constant
	name = "constant chip"
	desc = "This tiny chip can store one piece of data, which cannot be overwritten without disassembly."
	icon_state = "memory1"
	inputs = list()
	outputs = list("output pin" = IC_PINTYPE_ANY)
	activators = list(
		"push data" = IC_PINTYPE_PULSE_IN,
		"on push" = IC_PINTYPE_PULSE_OUT
	)
	var/accepting_refs = 0
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/data

/obj/item/integrated_circuit/memory/constant/do_work()
	set_pin_data(IC_OUTPUT, 1, data)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/memory/constant/attack_self(mob/user)
	var/datum/integrated_io/O = outputs[1]
	var/type_to_use = input("Please choose a type to use.","[src] type setting") as null|anything in list("string","number","ref", "null")
	if(!CanInteract(user, physical_state))
		return

	var/new_data = null
	switch(type_to_use)
		if("string")
			accepting_refs = 0
			new_data = sanitize(input("Now type in a string.","[src] string writing") as null|text, MAX_MESSAGE_LEN, 1, 0, 1)
			if(istext(new_data) && CanInteract(user, physical_state))
				data = new_data
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to [O.display_data(data)].</span>")
		if("number")
			accepting_refs = 0
			new_data = input("Now type in a number.","[src] number writing") as null|num
			if(isnum(new_data) && CanInteract(user, physical_state))
				data = new_data
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to [O.display_data(data)].</span>")
		if("ref")
			accepting_refs = 1
			to_chat(user, "<span class='notice'>You turn \the [src]'s ref scanner on.  Slide it across \
			an object for a ref of that object to save it in memory.</span>")
		if("null")
			data = null
			to_chat(user, "<span class='notice'>You set \the [src]'s memory to absolutely nothing.</span>")

/obj/item/integrated_circuit/memory/constant/afterattack(atom/target, mob/living/user, proximity)
	if(accepting_refs && proximity)
		var/datum/integrated_io/O = outputs[1]
		data = WEAKREF(target)
		visible_message("<span class='notice'>[user] slides [src]'s ref scanner over \the [target].</span>")
		to_chat(user, "<span class='notice'>You set \the [src]'s memory to a reference to [O.display_data(data)].  The ref scanner is \
		now off.</span>")
		accepting_refs = 0
