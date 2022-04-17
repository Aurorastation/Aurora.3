/*
While these computers can be placed anywhere, they will only function if placed on either a non-space, non-shuttle turf
with an /obj/effect/overmap/visitable/ship present elsewhere on that z level, or else placed in a shuttle area with an /obj/effect/overmap/visitable/ship
somewhere on that shuttle. Subtypes of these can be then used to perform ship overmap movement functions.
*/
/obj/machinery/computer/ship
	var/list/viewers // Weakrefs to mobs in direct-view mode.
	var/extra_view = 0 // how much the view is increased by when the mob is in overmap mode.

/obj/machinery/computer/ship/proc/display_reconnect_dialog(var/mob/user, var/flavor)
	var/datum/browser/popup = new (user, "[src]", "[src]")
	popup.set_content("<center><strong><font color = 'red'>Error</strong></font><br>Unable to connect to [flavor].<br><a href='?src=\ref[src];sync=1'>Reconnect</a></center>")
	popup.open()

/obj/machinery/computer/ship/attack_hand(mob/user)
	if(use_check_and_message(user))
		return

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/computer/ship/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	src.add_hiddenprint(user)
	ui_interact(user)

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

// Management of mob view displacement. look to shift view to the ship on the overmap; unlook to shift back.

/obj/machinery/computer/ship/proc/look(var/mob/user)
	if(linked)
		user.reset_view(linked)
	if(user.client)
		user.client.view = world.view + extra_view
	moved_event.register(user, src, /obj/machinery/computer/ship/proc/unlook)
	if(user.eyeobj)
		moved_event.register(user.eyeobj, src, /obj/machinery/computer/ship/proc/unlook)
	LAZYDISTINCTADD(viewers, WEAKREF(user))

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

	moved_event.unregister(user, src, /obj/machinery/computer/ship/proc/unlook)

	if(isEye(user)) // If we're an AI eye, the computer has our AI mob in its viewers list not the eye mob
		var/mob/abstract/eye/E = user
		moved_event.unregister(E.owner, src, /obj/machinery/computer/ship/proc/unlook)
		LAZYREMOVE(viewers, WEAKREF(E.owner))
	LAZYREMOVE(viewers, WEAKREF(user))

/obj/machinery/computer/ship/proc/viewing_overmap(mob/user)
	return (WEAKREF(user) in viewers)

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
	if (use_check_and_message(user, flags) || user.blinded || inoperable() || !linked)
		return -1
	else
		return 0

/obj/machinery/computer/ship/Destroy()
	if(linked)
		LAZYREMOVE(linked.consoles, src)
	. = ..()

/obj/machinery/computer/ship/sensors/Destroy()
	sensors = null
	if(LAZYLEN(viewers))
		for(var/datum/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	. = ..()

/obj/machinery/computer/ship/on_user_login(mob/M)
	unlook(M)

/obj/machinery/computer/ship/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	. = ..()

	if(.)
		LAZYSET(linked.consoles, src, TRUE)

/obj/machinery/computer/ship/Initialize()
	. = ..()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable/ship))
			attempt_hook_up(my_sector)
