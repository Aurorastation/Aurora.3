/**
 * Multitool -- A multitool is used for hacking electronic devices.
 *
 */

/obj/item/device/multitool
	name = "multitool"
	desc = "This small, handheld device is made of durable, insulated plastic. It has a electrode jack, perfect for interfacing with numerous machines, as well as an in-built NT-SmartTrack! system."
	desc_info = "You can use this on airlocks or APCs to try to hack them without cutting wires. You can also use it to wire circuits, and track APCs by using it in-hand."
	icon = 'icons/obj/item/device/multitool.dmi'
	icon_state = "multitool"
	item_state = "multitool"
	item_icons = null
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 11
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	drop_sound = 'sound/items/drop/multitool.ogg'
	pickup_sound = 'sound/items/pickup/multitool.ogg'

	matter = list(MATERIAL_PLASTIC = 50, MATERIAL_GLASS = 20, DEFAULT_WALL_MATERIAL = 5)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

	var/obj/machinery/buffer // simple machine buffer for device linkage
	var/obj/machinery/clonepod/connecting //same for cryopod linkage
	var/buffer_name
	var/atom/buffer_object

	var/tracking_apc = FALSE
	var/mutable_appearance/apc_indicator

	var/datum/integrated_io/selected_io = null
	var/mode = 0

/obj/item/device/multitool/Destroy()
	unregister_buffer(buffer_object)
	QDEL_NULL(apc_indicator)
	return ..()

/obj/item/device/multitool/ismultitool()
	return TRUE

/obj/item/device/multitool/proc/get_buffer(var/typepath)
	// Only allow clearing the buffer name when someone fetches the buffer.
	// Means you cannot be sure the source hasn't been destroyed until the very moment it's needed.
	get_buffer_name(TRUE)
	if(buffer_object && (!typepath || istype(buffer_object, typepath)))
		return buffer_object

/obj/item/device/multitool/proc/get_buffer_name(var/null_name_if_missing = FALSE)
	if(buffer_object)
		buffer_name = buffer_object.name
	else if(null_name_if_missing)
		buffer_name = null
	return buffer_name

/obj/item/device/multitool/proc/set_buffer(var/atom/buffer)
	if(!buffer || istype(buffer))
		buffer_name = buffer ? buffer.name : null
		if(buffer != buffer_object)
			unregister_buffer(buffer_object)
			buffer_object = buffer
			if(buffer_object)
				RegisterSignal(buffer_object, COMSIG_QDELETING, PROC_REF(on_buffer_object_deletion))
		update_icon()

/obj/item/device/multitool/proc/on_buffer_object_deletion(datum/source)
	SIGNAL_HANDLER
	unregister_buffer(source)

/obj/item/device/multitool/proc/unregister_buffer(atom/buffer_to_unregister)
	// Only remove the buffered object, don't reset the name
	// This means one cannot know if the buffer has been destroyed until one attempts to use it.
	if(buffer_to_unregister == buffer_object && buffer_object)
		UnregisterSignal(buffer_object, COMSIG_QDELETING)
		buffer_object = null
		update_icon()

/obj/item/device/multitool/resolve_attackby(atom/A, mob/user, var/click_parameters)
	if(!isobj(A))
		return ..(A, user, click_parameters)

	var/obj/O = A
	var/datum/component/multitool/MT = O.GetComponent(/datum/component/multitool)
	if(!MT)
		return ..(A, user, click_parameters)

	user.AddTopicPrint(src)
	MT.interact(src, user)
	return 1

/obj/item/device/multitool/attack_self(mob/user)
	interact(user)

/obj/item/device/multitool/interact(mob/user)
	ui_interact(user)

/obj/item/device/multitool/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Multitool", "Multitool", 300, 250)
		ui.open()

/obj/item/device/multitool/ui_data(mob/user)
	var/list/data = list()

	data["tracking_apc"] = tracking_apc

	if(selected_io)
		data["selected_io"] = list("name" = selected_io.name, "type" = selected_io.io_type)
	return data

/obj/item/device/multitool/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return TRUE

	switch(action)
		if("track_apc")
			tracking_apc = !tracking_apc
			if(tracking_apc)
				START_PROCESSING(SSprocessing, src)
				apc_indicator = mutable_appearance(icon, "lost")
				AddOverlays(apc_indicator)
			else
				STOP_PROCESSING(SSprocessing, src)
				QDEL_NULL(apc_indicator)
			. = TRUE

		if("clear_io")
			selected_io = null
			. = TRUE

	update_icon()

/obj/item/device/multitool/update_icon()
	if(tracking_apc)
		icon_state = "multitool_clear"
	else if(selected_io)
		if(buffer || connecting || buffer_object)
			icon_state = "multitool_tracking"
		else
			icon_state = "multitool_red"
	else
		if(buffer || connecting || buffer_object)
			icon_state = "multitool_tracking_fail"
		else
			icon_state = "multitool"

/obj/item/device/multitool/process()
	if(!apc_indicator)
		return PROCESS_KILL

	var/turf/T = get_turf(src)
	var/area/A = T.loc
	var/obj/machinery/power/apc/APC = A.apc

	if(!APC || (APC.z != T.z))
		apc_indicator.icon_state = "lost"
	else
		// shamelessly stolen from technomancer
		dir = get_dir(T, APC.loc) // overlays can't have different dirs than their atoms, but the multitool only has one dir sprite, so this works
		switch(get_dist(T, APC.loc))
			if(-1 to 0)
				apc_indicator.icon_state = "direct"
			if(1 to 8)
				apc_indicator.icon_state = "close"
			if(9 to 16)
				apc_indicator.icon_state = "medium"
			if(16 to INFINITY)
				apc_indicator.icon_state = "far"
	SetOverlays(apc_indicator)

/obj/item/device/multitool/proc/wire(datum/integrated_io/io, mob/user)
	if(!io.holder.assembly)
		to_chat(user, SPAN_WARNING("\The [io.holder] needs to be secured inside an assembly first."))
		return

	if(selected_io)
		if(io == selected_io)
			to_chat(user, SPAN_WARNING("Wiring \the [selected_io.holder]'s '[selected_io.name]' pin into itself is rather pointless."))
			return
		if(io.io_type != selected_io.io_type)
			to_chat(user, SPAN_WARNING("Those two types of channels are incompatable.  The first is a [selected_io.io_type], \
			while the second is a [io.io_type]."))

			return
		if(io.holder.assembly && io.holder.assembly != selected_io.holder.assembly)
			to_chat(user, SPAN_WARNING("Both \the [io.holder] and \the [selected_io.holder] need to be inside the same assembly."))
			return
		selected_io.linked |= io
		io.linked |= selected_io

		to_chat(user, SPAN_NOTICE("You connect \the [selected_io.holder]'s '[selected_io.name]' pin to \the [io.holder]'s '[io.name]' pin."))
		selected_io.holder.interact(user) // This is to update the UI.
		selected_io = null

	else
		selected_io = io
		to_chat(user, SPAN_NOTICE("You link \the multitool to \the [selected_io.holder]'s [selected_io.name] data channel."))

	update_icon()

/obj/item/device/multitool/proc/unwire(datum/integrated_io/io1, datum/integrated_io/io2, mob/user)
	if(!io1.linked.len || !io2.linked.len)
		to_chat(user, SPAN_WARNING("There is nothing connected to the data channel."))
		return

	if(!(io1 in io2.linked) || !(io2 in io1.linked) )
		to_chat(user, SPAN_WARNING("These data pins aren't connected!"))
		return
	else
		io1.linked.Remove(io2)
		io2.linked.Remove(io1)
		to_chat(user, "<span class='notice'>You clip the data connection between the [io1.holder.displayed_name]'s \
		'[io1.name]' pin and the [io2.holder.displayed_name]'s '[io2.name]' pin.</span>")
		io1.holder.interact(user) // This is to update the UI.
		update_icon()
