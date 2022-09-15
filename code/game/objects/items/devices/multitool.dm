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
	contained_sprite = TRUE
	flags = CONDUCT
	force = 5.0
	w_class = ITEMSIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	drop_sound = 'sound/items/drop/multitool.ogg'
	pickup_sound = 'sound/items/pickup/multitool.ogg'

	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20)

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
				destroyed_event.register(buffer_object, src, /obj/item/device/multitool/proc/unregister_buffer)
		update_icon()

/obj/item/device/multitool/proc/unregister_buffer(var/atom/buffer_to_unregister)
	// Only remove the buffered object, don't reset the name
	// This means one cannot know if the buffer has been destroyed until one attempts to use it.
	if(buffer_to_unregister == buffer_object && buffer_object)
		destroyed_event.unregister(buffer_object, src)
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
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "devices-multitool", 300, 250, capitalize_first_letters(name), state = inventory_state)
	ui.open()

/obj/item/device/multitool/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		data = list()

	VUEUI_SET_CHECK(data["tracking_apc"], tracking_apc, ., data)

	VUEUI_SET_CHECK(data["has_selected_io"], !isnull(selected_io), ., data)
	if(selected_io)
		VUEUI_SET_CHECK(data["selected_io_name"], selected_io.name, ., data)
		VUEUI_SET_CHECK(data["selected_io_type"], selected_io.io_type, ., data)

/obj/item/device/multitool/Topic(href, href_list)
	. = ..()
	if(.)
		return TRUE

	if(href_list["track_apc"])
		tracking_apc = !tracking_apc
		if(tracking_apc)
			START_PROCESSING(SSprocessing, src)
			apc_indicator = mutable_appearance(icon, "lost")
			add_overlay(apc_indicator)
		else
			STOP_PROCESSING(SSprocessing, src)
			QDEL_NULL(apc_indicator)

	if(href_list["clear_io"])
		selected_io = null

	update_icon()
	SSvueui.check_uis_for_change(src)

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
	set_overlays(apc_indicator)

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
	SSvueui.check_uis_for_change(src)

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
