/*
While these computers can be placed anywhere, they will only function if placed on either a non-space, non-shuttle turf
with an /obj/effect/overmap/visitable/ship present elsewhere on that z level, or else placed in a shuttle area with an /obj/effect/overmap/visitable/ship
somewhere on that shuttle. Subtypes of these can be then used to perform ship overmap movement functions.
*/
/obj/machinery/computer/ship
	/// Weakrefs to mobs in direct-view mode.
	var/list/viewers
	/// How much the view is increased by when the mob is in overmap mode.
	var/extra_view = 0
	/// The ship we're attached to. This is a typecheck for linked, to ensure we're linked to a ship and not a sector
	var/obj/effect/overmap/visitable/ship/connected
	/// Are we targeting anything right now?
	var/targeting = FALSE
	var/linked_type = /obj/effect/overmap/visitable/ship

	/// For hotwiring, how many cycles are needed. This decreases by 1 each cycle and triggers at 0
	var/hotwire_progress = 8

/obj/machinery/computer/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Consoles like these are typically access-locked."
	. += "You can remove this lock with <b>wirecutters</b>, but it would take awhile! Alternatively, you can also use a cryptographic sequencer (emag) for instant removal."

/obj/machinery/computer/ship/proc/display_reconnect_dialog(var/mob/user, var/flavor)
	var/datum/browser/popup = new (user, "[src]", "[src]")
	popup.set_content("<center><strong><font color = 'red'>Error</strong></font><br>Unable to connect to [flavor].<br><a href='byond://?src=[REF(src)];sync=1'>Reconnect</a></center>")
	popup.open()

/obj/machinery/computer/ship/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iscoil()) // Repair from hotwire
		var/obj/item/stack/cable_coil/C = attacking_item
		if(hotwire_progress >= initial(hotwire_progress))
			to_chat(usr, SPAN_BOLD("\The [src] does not require repairs."))
		else
			to_chat(usr, SPAN_BOLD("You attempt to replace some cabling for \the [src]..."))
			while(C.can_use(2, user))
				if(do_after(user, 15 SECONDS, src, DO_UNIQUE))
					if(hotwire_progress < initial(hotwire_progress))
						C.use(2)
						hotwire_progress++
						if(hotwire_progress >= initial(hotwire_progress))
							restore_access(user)
							return
						to_chat(usr, SPAN_BOLD("You replace some broken cabling of \the [src] <b>([(hotwire_progress / initial(hotwire_progress)) * 100]%)</b>."))
						playsound(src.loc, 'sound/items/Deconstruct.ogg', 30, TRUE)
			return

	if(attacking_item.iswirecutter()) // Hotwiring
		if(!req_access && !req_one_access && !emagged) // Already hacked/no need to hack
			to_chat(user, SPAN_BOLD("[src] is not access-locked."))
			return
		// Begin hotwire
		user.visible_message("<b>[user]</b> opens a panel underneath \the [src] and starts snipping wires...", SPAN_BOLD("You open the maintenance panel and attempt to hotwire \the [src]..."))
		while(hotwire_progress > 0)
			if(do_after(user, 15 SECONDS, src, DO_UNIQUE))
				hotwire_progress--
				if(hotwire_progress <= 0)
					emag_act(user=user, hotwired=TRUE)
					return
				to_chat(user, SPAN_BOLD("You snip some cabling from \the [src] <b>([((initial(hotwire_progress)-hotwire_progress) / initial(hotwire_progress)) * 100]%)</b>."))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 30, TRUE)
			else
				return
	return ..()

/obj/machinery/computer/ship/attack_hand(mob/user)
	if(use_check_and_message(user))
		return
	if(!emagged && !allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return FALSE
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/computer/ship/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	src.add_hiddenprint(user)
	ui_interact(user)

/obj/machinery/computer/ship/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(initial(hotwire_progress) != hotwire_progress)
		if(hotwire_progress != 0)
			. += SPAN_ITALIC("The bottom panel appears open with wires hanging out. It can be repaired with additional cabling. <i>Current progress: [(hotwire_progress / initial(hotwire_progress)) * 100]%</i>")
		else
			. += SPAN_ITALIC("The bottom panel appears open with wires hanging out. It can be repaired with additional cabling.")

/obj/machinery/computer/ship/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/hotwired = FALSE)
	if(emagged)
		to_chat(user, SPAN_WARNING("\The [src] has already been subverted."))
		return FALSE
	emagged = TRUE
	if(hotwired)
		user.visible_message(SPAN_WARNING("\The [src] sparks as a panel suddenly opens and burnt cabling spills out!"),SPAN_BOLD("You short out the console's ID checking system. It's now available to everyone!"))
	else
		user.visible_message(SPAN_WARNING("\The [src] sparks!"),SPAN_BOLD("You short out the console's ID checking system. It's now available to everyone!"))
	spark(src, 2, 0)
	hotwire_progress = 0
	return TRUE

/// Used to restore access removed from emag_act() by setting access from req_access_old and req_one_access_old
/obj/machinery/computer/ship/proc/restore_access(var/mob/user)
	if(!emagged)
		to_chat(user, SPAN_WARNING("There is no access to restore for \the [src]!"))
		return FALSE
	emagged = FALSE
	to_chat(user, "You repair out the console's ID checking system. It's access restrictions have been restored.")
	playsound(loc, 'sound/machines/ping.ogg', 50, FALSE)
	hotwire_progress = initial(hotwire_progress)
	return TRUE

/obj/machinery/computer/ship/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	if(href_list["sync"])
		sync_linked()
		return TOPIC_REFRESH
	if(href_list["close"])
		unlook(usr)
		usr.unset_machine()
		return TOPIC_HANDLED
	return TOPIC_NOACTION

/obj/machinery/computer/ship/sync_linked()
	. = ..()
	if(istype(linked, linked_type))
		connected = linked

// Management of mob view displacement. look to shift view to the ship on the overmap; unlook to shift back.

/obj/machinery/computer/ship/proc/look(var/mob/user)
	if(linked)
		user.reset_view(linked)
	if(user.client)
		user.client.view = world.view + extra_view
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(unlook))
	if(user.eyeobj)
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(unlook))
	LAZYDISTINCTADD(viewers, WEAKREF(user))
	if(linked)
		LAZYDISTINCTADD(linked.navigation_viewers, WEAKREF(user))
	ADD_TRAIT(user, TRAIT_COMPUTER_VIEW, REF(src))

/// Handles disabling the user's overmap view when a signal comes in, primarily used when the TGUI is closed, see helm.dm and sensors.dm
/obj/machinery/computer/ship/proc/handle_unlook_signal(var/datum/source, var/mob/user)
	SIGNAL_HANDLER

	unlook(user)

/obj/machinery/computer/ship/proc/unlook(var/mob/user)
	user.reset_view()
	var/client/c = user.client

	if(isEye(user))
		var/mob/abstract/eye/E = user
		E.reset_view()
		c = E.owner.client

	if(c)
		c.view = world.view
		c.pixel_x = 0
		c.pixel_y = 0

	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

	if(isEye(user)) // If we're an AI eye, the computer has our AI mob in its viewers list not the eye mob
		var/mob/abstract/eye/E = user
		UnregisterSignal(E.owner, COMSIG_MOVABLE_MOVED)
		LAZYREMOVE(viewers, WEAKREF(E.owner))
	LAZYREMOVE(viewers, WEAKREF(user))
	if(linked)
		LAZYREMOVE(linked.navigation_viewers, WEAKREF(user))

	if(linked)
		for(var/obj/machinery/computer/ship/sensors/sensor in linked.consoles)
			sensor.hide_contacts(user)

	REMOVE_TRAIT(user, TRAIT_COMPUTER_VIEW, REF(src))

/obj/machinery/computer/ship/proc/viewing_overmap(mob/user)
	return (WEAKREF(user) in viewers) || (linked && (WEAKREF(user) in linked.navigation_viewers))

/obj/machinery/computer/ship/CouldNotUseTopic(mob/user)
	. = ..()
	unlook(user)

/obj/machinery/computer/ship/CouldUseTopic(mob/user)
	. = ..()
	if(viewing_overmap(user))
		look(user)

/obj/machinery/computer/ship/check_eye(var/mob/user)
	if(!viewing_overmap(user))
		return FALSE

	var/flags = issilicon(user) ? USE_ALLOW_NON_ADJACENT : 0
	if (use_check_and_message(user, flags) || user.blinded || !operable() || !linked)
		return -1
	else
		return SEE_THRU

/obj/machinery/computer/ship/Destroy()
	if(linked)
		linked = null
	if(connected)
		LAZYREMOVE(connected.consoles, src)
	. = ..()

/obj/machinery/computer/ship/sensors/Destroy()
	sensor_ref = null
	identification = null
	QDEL_NULL(sound_token)
	if(LAZYLEN(viewers))
		for(var/datum/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
				if(linked)
					LAZYREMOVE(linked.navigation_viewers, W)
	. = ..()

/obj/machinery/computer/ship/on_user_login(mob/M)
	unlook(M)

/obj/machinery/computer/ship/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	. = ..()

	if(.)
		if(istype(linked, linked_type))
			connected = linked
			if(istype(connected)) // we do a little type abuse
				LAZYSET(connected.consoles, src, TRUE)

/obj/machinery/computer/ship/Initialize()
	. = ..()
	if(SSatlas.current_map.use_overmap && !linked)
		var/my_sector = GLOB.map_sectors["[z]"]
		if(istype(my_sector, linked_type))
			attempt_hook_up(my_sector)
