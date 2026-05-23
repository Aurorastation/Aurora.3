/*
	Pins both hold data for circuits, as well move data between them.  Some also cause circuits to do their function.  DATA_CHANNEL pins are the data holding/moving kind,
whereas PULSE_CHANNEL causes circuits to work() when their pulse hits them.


A visualization of how pins work is below.  Imagine the below image involves an addition circuit.
When the bottom pin, the activator, receives a pulse, all the numbers on the left (input) get added, and the answer goes on the right side (output).

Inputs      Outputs

A [2]\      /[8] result
B [1]-\|++|/
C [4]-/|++|
D [1]/  ||
		||
	Activator



*/
/datum/integrated_io
	// Stores `name` state used by this integrated electronics object.
	var/name = "input/output"
	// Stores `holder` state used by this integrated electronics object.
	var/obj/item/integrated_circuit/holder = null
	// Stores `data` state used by this integrated electronics object.
	var/datum/weakref/data = null // This is a weakref, to reduce typecasts.  Note that oftentimes numbers and text may also occupy this.
	// Stores `linked` state used by this integrated electronics object.
	var/list/linked = list()
	// Stores `io_type` state used by this integrated electronics object.
	var/io_type = DATA_CHANNEL

/// Constructs this object and applies setup that must happen at creation time.
/datum/integrated_io/New(var/newloc, var/name, var/new_data)
	..()
	src.name = name
	if(new_data)
		src.data = new_data
	holder = newloc
	if(!istype(holder))
		message_admins("ERROR: An integrated_io ([src.name]) spawned without a valid holder!  This is a bug.")
		LOG_DEBUG("ERROR: An integrated_io ([src.name]) spawned without a valid holder!  This is a bug.")

/// Releases owned objects and clears references before parent deletion runs.
/datum/integrated_io/Destroy()
	disconnect()
	data = null
	holder = null
	. = ..()

/// Implements `ui_host` behavior for this integrated electronics type.
/datum/integrated_io/ui_host()
	return holder.ui_host()

/// Implements `data_as_type` behavior for this integrated electronics type.
/datum/integrated_io/proc/data_as_type(var/as_type)
	if(!isweakref(data))
		return
	var/datum/weakref/w = data
	// Stores `output` state used by this integrated electronics object.
	var/output = w.resolve()
	return istype(output, as_type) ? output : null

/// Implements `display_data` behavior for this integrated electronics type.
/datum/integrated_io/proc/display_data(var/input)
	if(isnull(input))
		return "(null)" // Empty data means nothing to show.

	if(istext(input))
		return "(\"[input]\")" // Wraps the 'string' in escaped quotes, so that people know it's a 'string'.

/*
list[](
	"A",
	"B",
	"C"
)
*/

	if(islist(input))
		var/list/my_list = input
		var/result = "list\[[my_list.len]\]("
		if(my_list.len)
			result += "<br>"
			var/pos = 0
			for(var/line in my_list)
				result += "[display_data(line)]"
				pos++
				if(pos != my_list.len)
					result += ",<br>"
			result += "<br>"
		result += ")"
		return result

	if(isweakref(input))
		var/datum/weakref/w = input
		var/atom/A = w.resolve()
		//return A ? "([A.name] \[Ref\])" : "(null)" // For refs, we want just the name displayed.
		return A ? "([REF(A)] \[Ref\])" : "(null)"

	return "([input])" // Nothing special needed for numbers or other stuff.

/// Implements `display_data` behavior for this integrated electronics type.
/datum/integrated_io/activate/display_data()
	return "(\[pulse\])"

/// Implements `display_pin_type` behavior for this integrated electronics type.
/datum/integrated_io/proc/display_pin_type()
	return IC_FORMAT_ANY

/// Implements `display_pin_type` behavior for this integrated electronics type.
/datum/integrated_io/activate/display_pin_type()
	return IC_FORMAT_PULSE

/// Implements `scramble` behavior for this integrated electronics type.
/datum/integrated_io/proc/scramble()
	if(isnull(data))
		return
	if(isnum(data))
		write_data_to_pin(rand(-10000, 10000))
	if(istext(data))
		write_data_to_pin("ERROR")
	push_data()

/// Implements `scramble` behavior for this integrated electronics type.
/datum/integrated_io/activate/scramble()
	push_data()

/// Implements `write_data_to_pin` behavior for this integrated electronics type.
/datum/integrated_io/proc/write_data_to_pin(var/new_data)
	if(isnull(new_data) || isnum(new_data) || istext(new_data) || isweakref(new_data) || islist(new_data)) // Anything else is a type we don't want.
		data = new_data
		holder.on_data_written()

/// Pushes this circuit's output pin values to connected circuits.
/datum/integrated_io/proc/push_data()
	for(var/datum/integrated_io/io in linked)
		io.write_data_to_pin(data)

/// Pushes this circuit's output pin values to connected circuits.
/datum/integrated_io/activate/push_data()
	for(var/datum/integrated_io/io in linked)
		io.holder.check_then_do_work(FALSE)

/// Reads connected pin values into this circuit before work runs.
/datum/integrated_io/proc/pull_data()
	for(var/datum/integrated_io/io in linked)
		write_data_to_pin(io.data)

/// Returns the current `linked_to_desc` value or object used by this electronics code.
/datum/integrated_io/proc/get_linked_to_desc()
	if(linked.len)
		return "the [english_list(linked)]"
	return "nothing"

/// Removes a wire connection between pins.
/datum/integrated_io/proc/disconnect()
	//First we iterate over everything we are linked to.
	for(var/datum/integrated_io/their_io in linked)
		//While doing that, we iterate them as well, and disconnect ourselves from them.
		for(var/datum/integrated_io/their_linked_io in their_io.linked)
			if(their_linked_io == src)
				their_io.linked -= src

		//Now that we're removed from them, we gotta remove them from us.
		linked -= their_io

/// Implements `ask_for_data_type` behavior for this integrated electronics type.
/datum/integrated_io/proc/ask_for_data_type(mob/user, var/default, var/list/allowed_data_types = list("string","number","null"))
	// Stores `type_to_use` state used by this integrated electronics object.
	var/type_to_use = tgui_input_list(user, "Please choose a type to use.", "[src] type setting", allowed_data_types)
	if(!holder.check_interactivity(user))
		return

	var/new_data = null
	switch(type_to_use)
		if("string")
			new_data = tgui_input_text(user, "Now type in a string.", "[src] string writing", istext(default) ? default : "", MAX_MESSAGE_LEN)
			if(istext(new_data) && holder.check_interactivity(user) )
				to_chat(user, SPAN_NOTICE("You input [new_data] into the pin."))
				return new_data

		if("number")
			new_data = tgui_input_number(user, "Now type in a number.", "[src] number writing", isnum(default) ? default : 0)
			if(isnum(new_data) && holder.check_interactivity(user) )
				to_chat(user, SPAN_NOTICE("You input [new_data] into the pin."))
				return new_data

		if("null")
			if(holder.check_interactivity(user))
				to_chat(user, SPAN_NOTICE("You clear the pin's memory."))
				return new_data

// Basically a null check
/datum/integrated_io/proc/is_valid()
	return !isnull(data)

// This proc asks for the data to write, then writes it.
/datum/integrated_io/proc/ask_for_pin_data(mob/user)
	// Stores `new_data` state used by this integrated electronics object.
	var/new_data = ask_for_data_type(user)
	write_data_to_pin(new_data)

/datum/integrated_io/activate/ask_for_pin_data(mob/user) // This just pulses the pin.
	holder.check_then_do_work(ignore_power = TRUE)
	to_chat(user, SPAN_NOTICE("You pulse \the [holder]'s [src] pin."))

/// Defines `/datum/integrated_io/activate` for integrated electronics support.
/datum/integrated_io/activate
	name = "activation pin"
	io_type = PULSE_CHANNEL

/datum/integrated_io/activate/out // All this does is just make the UI say 'out' instead of 'in'
	data = 1
