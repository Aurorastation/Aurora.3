#define WIRE     "wire"
#define WIRING   "wiring"
#define UNWIRE   "unwire"
#define UNWIRING "unwiring"

/obj/item/device/integrated_electronics/wirer
	name = "circuit wirer"
	desc = "It's a small wiring tool, with a wire roll, electric soldering iron, wire cutter, and more in one package. \
	The wires used are generally useful for small electronics, such as circuitboards and breadboards, as opposed to larger wires \
	used for power or data transmission."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "wirer-wire"
	item_state = "wirer"
	flags = CONDUCT
	w_class = 2
	var/datum/integrated_io/selected_io
	var/mode = WIRE

/obj/item/device/integrated_electronics/wirer/update_icon()
	icon_state = "wirer-[mode]"

/obj/item/device/integrated_electronics/wirer/proc/wire(var/datum/integrated_io/io, mob/user)
	if(!io.holder.assembly)
		to_chat(user, "<span class='warning'>\The [io.holder] needs to be secured inside an assembly first.</span>")
		return

	switch (mode)
		if (WIRE)
			selected_io = io
			to_chat(user, "<span class='notice'>You attach a data wire to \the [selected_io.holder]'s [selected_io.name] data channel.</span>")
			mode = WIRING
			update_icon()

		if (WIRING)
			if(io == selected_io)
				to_chat(user, "<span class='warning'>Wiring \the [selected_io.holder]'s [selected_io.name] into itself is rather pointless.</span>")
				return
			if(io.io_type != selected_io.io_type)
				to_chat(user, "<span class='warning'>Those two types of channels are incompatable.  The first is a [selected_io.io_type], \
				while the second is a [io.io_type].</span>")
				return
			if(io.holder.assembly && io.holder.assembly != selected_io.holder.assembly)
				to_chat(user, "<span class='warning'>Both \the [io.holder] and \the [selected_io.holder] need to be inside the same assembly.</span>")
				return
			selected_io.linked |= io
			io.linked |= selected_io

			to_chat(user, "<span class='notice'>You connect \the [selected_io.holder]'s [selected_io.name] to \the [io.holder]'s [io.name].</span>")
			mode = WIRE
			update_icon()
			selected_io.holder.interact(user) // This is to update the UI.
			selected_io = null

		if (UNWIRE)
			selected_io = io
			if(!io.linked.len)
				to_chat(user, "<span class='warning'>There is nothing connected to \the [selected_io] data channel.</span>")
				selected_io = null
				return
			to_chat(user, "<span class='notice'>You prepare to detach a data wire from \the [selected_io.holder]'s [selected_io.name] data channel.</span>")
			mode = UNWIRING
			update_icon()

		if (UNWIRING)
			if(io == selected_io)
				to_chat(user, "<span class='warning'>You can't wire a pin into each other, so unwiring \the [selected_io.holder] from \
				the same pin is rather moot.</span>")
				return
			if(selected_io in io.linked)
				io.linked.Remove(selected_io)
				selected_io.linked.Remove(io)
				to_chat(user, "<span class='notice'>You disconnect \the [selected_io.holder]'s [selected_io.name] from \
				\the [io.holder]'s [io.name].</span>")
				selected_io.holder.interact(user) // This is to update the UI.
				selected_io = null
				mode = UNWIRE
				update_icon()
			else
				to_chat(user, "<span class='warning'>\The [selected_io.holder]'s [selected_io.name] and \the [io.holder]'s \
				[io.name] are not connected.</span>")

/obj/item/device/integrated_electronics/wirer/attack_self(mob/user)
	switch(mode)
		if(WIRE)
			mode = UNWIRE
		if(WIRING)
			if(selected_io)
				to_chat(user, "<span class='notice'>You decide not to wire the data channel.</span>")
			selected_io = null
			mode = WIRE
		if(UNWIRE)
			mode = WIRE
		if(UNWIRING)
			if(selected_io)
				to_chat(user, "<span class='notice'>You decide not to disconnect the data channel.</span>")
			selected_io = null
			mode = UNWIRE
	update_icon()
	to_chat(user, "<span class='notice'>You set \the [src] to [mode].</span>")

#undef WIRE
#undef WIRING
#undef UNWIRE
#undef UNWIRING

/obj/item/device/integrated_electronics/debugger
	name = "circuit debugger"
	desc = "This small tool allows one working with custom machinery to directly set data to a specific pin, useful for writing \
	settings to specific circuits, or for debugging purposes.  It can also pulse activation pins."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "debugger"
	flags = CONDUCT
	w_class = 2
	var/data_to_write = null
	var/accepting_refs = 0

/obj/item/device/integrated_electronics/debugger/attack_self(mob/user)
	var/type_to_use = input("Please choose a type to use.","[src] type setting") as null|anything in list("string","number","ref", "null")
	if(!CanInteract(user, physical_state))
		return

	var/new_data = null
	switch(type_to_use)
		if("string")
			accepting_refs = 0
			new_data = sanitize(input("Now type in a string.","[src] string writing") as null|text, MAX_MESSAGE_LEN, 1, 0, 1)
			if(istext(new_data) && CanInteract(user, physical_state))
				data_to_write = new_data
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to \"[new_data]\".</span>")
		if("number")
			accepting_refs = 0
			new_data = input("Now type in a number.","[src] number writing") as null|num
			if(isnum(new_data) && CanInteract(user, physical_state))
				data_to_write = new_data
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to [new_data].</span>")
		if("ref")
			accepting_refs = 1
			to_chat(user, "<span class='notice'>You turn \the [src]'s ref scanner on.  Slide it across \
			an object for a ref of that object to save it in memory.</span>")
		if("null")
			data_to_write = null
			to_chat(user, "<span class='notice'>You set \the [src]'s memory to absolutely nothing.</span>")

/obj/item/device/integrated_electronics/debugger/afterattack(atom/target, mob/living/user, proximity)
	if(accepting_refs && proximity)
		data_to_write = WEAKREF(target)
		visible_message("<span class='notice'>[user] slides [src]'s ref scanner over \the [target].</span>")
		to_chat(user, "<span class='notice'>You set \the [src]'s memory to a reference to [target.name] \[Ref\].  The ref scanner is \
		now off.</span>")
		accepting_refs = 0

/obj/item/device/integrated_electronics/debugger/proc/write_data(var/datum/integrated_io/io, mob/user)
	switch (io.io_type)
		if (DATA_CHANNEL)
			io.write_data_to_pin(data_to_write)
			var/data_to_show = data_to_write
			if(isweakref(data_to_write))
				var/datum/weakref/w = data_to_write
				var/atom/A = w.resolve()
				data_to_show = A.name
			to_chat(user, "<span class='notice'>You write '[data_to_write ? data_to_show : "NULL"]' to the '[io]' pin of \the [io.holder].</span>")
		if (PULSE_CHANNEL)
			io.holder.check_then_do_work(ignore_power = TRUE)
			to_chat(user, "<span class='notice'>You pulse \the [io.holder]'s '[io]' pin.</span>")

	io.holder.interact(user) // This is to update the UI.

/obj/item/device/multitool
	var/datum/integrated_io/selected_io = null
	var/mode = 0

/obj/item/device/multitool/attack_self(mob/user)
	if(selected_io)
		selected_io = null
		to_chat(user, "<span class='notice'>You clear the wired connection from the multitool.</span>")
	else
		..()
	update_icon()

/obj/item/device/multitool/update_icon()
	if(selected_io)
		if(buffer || connecting || buffer_object)
			icon_state = "multitool_tracking"
		else
			icon_state = "multitool_red"
	else
		if(buffer || connecting || buffer_object)
			icon_state = "multitool_tracking_fail"
		else
			icon_state = "multitool"

/obj/item/device/multitool/proc/wire(datum/integrated_io/io, mob/user)
	if(!io.holder.assembly)
		to_chat(user, "<span class='warning'>\The [io.holder] needs to be secured inside an assembly first.</span>")
		return

	if(selected_io)
		if(io == selected_io)
			to_chat(user, "<span class='warning'>Wiring \the [selected_io.holder]'s '[selected_io.name]' pin into itself is rather pointless.</span>")
			return
		if(io.io_type != selected_io.io_type)
			to_chat(user, "<span class='warning'>Those two types of channels are incompatable.  The first is a [selected_io.io_type], \
			while the second is a [io.io_type].</span>")
			return
		if(io.holder.assembly && io.holder.assembly != selected_io.holder.assembly)
			to_chat(user, "<span class='warning'>Both \the [io.holder] and \the [selected_io.holder] need to be inside the same assembly.</span>")
			return
		selected_io.linked |= io
		io.linked |= selected_io

		to_chat(user, "<span class='notice'>You connect \the [selected_io.holder]'s '[selected_io.name]' pin to \the [io.holder]'s '[io.name]' pin.</span>")
		selected_io.holder.interact(user) // This is to update the UI.
		selected_io = null

	else
		selected_io = io
		to_chat(user, "<span class='notice'>You link \the multitool to \the [selected_io.holder]'s [selected_io.name] data channel.</span>")

	update_icon()

/obj/item/device/multitool/proc/unwire(datum/integrated_io/io1, datum/integrated_io/io2, mob/user)
	if(!io1.linked.len || !io2.linked.len)
		to_chat(user, "<span class='warning'>There is nothing connected to the data channel.</span>")
		return

	if(!(io1 in io2.linked) || !(io2 in io1.linked) )
		to_chat(user, "<span class='warning'>These data pins aren't connected!</span>")
		return
	else
		io1.linked.Remove(io2)
		io2.linked.Remove(io1)
		to_chat(user, "<span class='notice'>You clip the data connection between the [io1.holder.displayed_name]'s \
		'[io1.name]' pin and the [io2.holder.displayed_name]'s '[io2.name]' pin.</span>")
		io1.holder.interact(user) // This is to update the UI.
		update_icon()

/obj/item/device/integrated_electronics/detailer
	name = "assembly detailer"
	desc = "A combination autopainter and flash anodizer designed to give electronic assemblies a colorful, wear-resistant finish."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "detailer"
	item_flags = NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	var/detail_color = COLOR_ASSEMBLY_WHITE
	var/list/color_list = list(
		"black" = COLOR_ASSEMBLY_BLACK,
		"machine gray" = COLOR_ASSEMBLY_BGRAY,
		"white" = COLOR_ASSEMBLY_WHITE,
		"red" = COLOR_ASSEMBLY_RED,
		"orange" = COLOR_ASSEMBLY_ORANGE,
		"beige" = COLOR_ASSEMBLY_BEIGE,
		"brown" = COLOR_ASSEMBLY_BROWN,
		"gold" = COLOR_ASSEMBLY_GOLD,
		"yellow" = COLOR_ASSEMBLY_YELLOW,
		"gurkha" = COLOR_ASSEMBLY_GURKHA,
		"light green" = COLOR_ASSEMBLY_LGREEN,
		"green" = COLOR_ASSEMBLY_GREEN,
		"light blue" = COLOR_ASSEMBLY_LBLUE,
		"blue" = COLOR_ASSEMBLY_BLUE,
		"purple" = COLOR_ASSEMBLY_PURPLE,
		"hot pink" = COLOR_ASSEMBLY_HOT_PINK
		)

/obj/item/device/integrated_electronics/detailer/Initialize()
	update_icon()
	return ..()

/obj/item/device/integrated_electronics/detailer/update_icon()
	cut_overlays()
	var/image/detail_overlay = image('icons/obj/assemblies/electronic_tools.dmi', "detailer-color")
	detail_overlay.color = detail_color
	add_overlay(detail_overlay)

/obj/item/device/integrated_electronics/detailer/attack_self(mob/user)
	var/color_choice = input(user, "Select color.", "Assembly Detailer", detail_color) as null|anything in color_list
	if(!color_list[color_choice])
		return
	if(!in_range(src, user))
		return
	detail_color = color_list[color_choice]
	update_icon()

/obj/item/storage/bag/circuits
	name = "circuit kit"
	desc = "This kit is essential for any circuitry projects."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "circuit_kit"
	w_class = 3
	display_contents_with_number = 0
	can_hold = list(
		/obj/item/integrated_circuit,
		/obj/item/storage/bag/circuits/mini,
		/obj/item/device/electronic_assembly,
		/obj/item/device/integrated_electronics,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/device/multitool
	)

/obj/item/storage/bag/circuits/basic/fill()
	new /obj/item/storage/bag/circuits/mini/arithmetic(src)
	new /obj/item/storage/bag/circuits/mini/trig(src)
	new /obj/item/storage/bag/circuits/mini/input(src)
	new /obj/item/storage/bag/circuits/mini/output(src)
	new /obj/item/storage/bag/circuits/mini/memory(src)
	new /obj/item/storage/bag/circuits/mini/logic(src)
	new /obj/item/storage/bag/circuits/mini/time(src)
	new /obj/item/storage/bag/circuits/mini/reagents(src)
	new /obj/item/storage/bag/circuits/mini/transfer(src)
	new /obj/item/storage/bag/circuits/mini/converter(src)
	new /obj/item/storage/bag/circuits/mini/power(src)

	new /obj/item/device/electronic_assembly(src)
	new /obj/item/device/assembly/electronic_assembly(src)
	new /obj/item/device/assembly/electronic_assembly(src)
	new /obj/item/device/multitool(src)
	new /obj/item/screwdriver(src)
	new /obj/item/crowbar(src)
	make_exact_fit()

/obj/item/storage/bag/circuits/all/fill()
	..()
	new /obj/item/storage/bag/circuits/mini/arithmetic/all(src)
	new /obj/item/storage/bag/circuits/mini/trig/all(src)
	new /obj/item/storage/bag/circuits/mini/input/all(src)
	new /obj/item/storage/bag/circuits/mini/output/all(src)
	new /obj/item/storage/bag/circuits/mini/memory/all(src)
	new /obj/item/storage/bag/circuits/mini/logic/all(src)
	new /obj/item/storage/bag/circuits/mini/smart/all(src)
	new /obj/item/storage/bag/circuits/mini/manipulation/all(src)
	new /obj/item/storage/bag/circuits/mini/time/all(src)
	new /obj/item/storage/bag/circuits/mini/reagents/all(src)
	new /obj/item/storage/bag/circuits/mini/transfer/all(src)
	new /obj/item/storage/bag/circuits/mini/converter/all(src)
	new /obj/item/storage/bag/circuits/mini/power/all(src)

	new /obj/item/device/electronic_assembly(src)
	new /obj/item/device/electronic_assembly/medium(src)
	new /obj/item/device/electronic_assembly/large(src)
	new /obj/item/device/electronic_assembly/drone(src)
	new /obj/item/device/integrated_electronics/wirer(src)
	new /obj/item/device/integrated_electronics/debugger(src)
	new /obj/item/crowbar(src)
	make_exact_fit()

/obj/item/storage/bag/circuits/mini
	name = "circuit box"
	desc = "Used to partition categories of circuits, for a neater workspace."
	w_class = ITEMSIZE_SMALL
	display_contents_with_number = TRUE
	pickup_blacklist = list(
						/obj/item/storage/bag/circuits
							)
	can_hold = list(/obj/item/integrated_circuit)
	var/spawn_flags_to_use = IC_SPAWN_DEFAULT
	var/list/spawn_types = list()

/obj/item/storage/bag/circuits/mini/fill()
	spawn_types = typecacheof(spawn_types)
	for (var/thing in typecache_filter_list(SSelectronics.all_integrated_circuits, spawn_types))
		var/obj/item/integrated_circuit/IC = thing
		if (IC.spawn_flags & spawn_flags_to_use)
			for (var/i in 1 to 4)
				new IC.type(src)

	make_exact_fit()

/obj/item/storage/bag/circuits/mini/arithmetic
	name = "arithmetic circuit box"
	desc = "Warning: Contains math."
	icon_state = "box_arithmetic"
	spawn_types = list(
		/obj/item/integrated_circuit/arithmetic
	)

/obj/item/storage/bag/circuits/mini/arithmetic/all // Don't believe this will ever be needed.
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/trig
	name = "trig circuit box"
	desc = "Danger: Contains more math."
	icon_state = "box_trig"
	spawn_types = list(
		/obj/item/integrated_circuit/trig
	)

/obj/item/storage/bag/circuits/mini/trig/all // Ditto
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/input
	name = "input circuit box"
	desc = "Tell these circuits everything you know."
	icon_state = "box_input"
	spawn_types = list(
		/obj/item/integrated_circuit/input
	)

/obj/item/storage/bag/circuits/mini/input/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/output
	name = "output circuit box"
	desc = "Circuits to interface with the world beyond itself."
	icon_state = "box_output"
	spawn_types = list(
		/obj/item/integrated_circuit/output
	)

/obj/item/storage/bag/circuits/mini/output/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/memory
	name = "memory circuit box"
	desc = "Machines can be quite forgetful without these."
	icon_state = "box_memory"
	spawn_types = list(
		/obj/item/integrated_circuit/memory
	)

/obj/item/storage/bag/circuits/mini/memory/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/logic
	name = "logic circuit box"
	desc = "May or may not be Turing complete."
	icon_state = "box_logic"
	spawn_types = list(
		/obj/item/integrated_circuit/logic
	)

/obj/item/storage/bag/circuits/mini/logic/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/time
	name = "time circuit box"
	desc = "No time machine parts, sadly."
	icon_state = "box_time"
	spawn_types = list(
		/obj/item/integrated_circuit/time
	)

/obj/item/storage/bag/circuits/mini/time/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/reagents
	name = "reagent circuit box"
	desc = "Unlike most electronics, these circuits are supposed to come in contact with liquids."
	icon_state = "box_reagents"
	spawn_types = list(
		/obj/item/integrated_circuit/reagent
	)

/obj/item/storage/bag/circuits/mini/reagents/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/transfer
	name = "transfer circuit box"
	desc = "Useful for moving data representing something arbitrary to another arbitrary virtual place."
	icon_state = "box_transfer"
	spawn_types = list(
		/obj/item/integrated_circuit/transfer
	)

/obj/item/storage/bag/circuits/mini/transfer/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/converter
	name = "converter circuit box"
	desc = "Transform one piece of data to another type of data with these."
	icon_state = "box_converter"
	spawn_types = list(
		/obj/item/integrated_circuit/converter
	)

/obj/item/storage/bag/circuits/mini/converter/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/smart
	name = "smart box"
	desc = "Sentience not included."
	icon_state = "box_ai"
	spawn_types = list(
		/obj/item/integrated_circuit/smart
	)

/obj/item/storage/bag/circuits/mini/smart/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/manipulation
	name = "manipulation box"
	desc = "Make your machines actually useful with these."
	icon_state = "box_manipulation"
	spawn_types = list(
		/obj/item/integrated_circuit/manipulation
	)

/obj/item/storage/bag/circuits/mini/manipulation/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/power
	name = "power circuit box"
	desc = "Electronics generally require electricity."
	icon_state = "box_power"
	spawn_types = list(
		/obj/item/integrated_circuit/passive/power,
		/obj/item/integrated_circuit/power
	)

/obj/item/storage/bag/circuits/mini/power/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
