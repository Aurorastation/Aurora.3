/obj/item/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEMSIZE_TINY

	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 50)

	req_access = list(access_engine)

	var/secure = FALSE //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access
	var/one_access = FALSE //if set to TRUE, door would receive req_one_access instead of req_access
	var/last_configurator
	var/locked = TRUE
	var/is_installed = FALSE // no double-spending

/obj/item/airlock_electronics/attack_self(mob/user)
	if(!ishuman(user) && !istype(user,/mob/living/silicon/robot))
		return ..(user)

	var/t1 = text("<B>Access control</B><br>\n")

	if(last_configurator)
		t1 += "Operator: [last_configurator]<br>"

	if(locked)
		t1 += "<a href='?src=\ref[src];login=1'>Swipe ID</a><hr>"
	else
		t1 += "<a href='?src=\ref[src];logout=1'>Block</a><hr>"

		t1 += "Access requirement is set to "
		t1 += one_access ? "<a style='color: green' href='?src=\ref[src];one_access=1'>ONE</a><hr>" : "<a style='color: red' href='?src=\ref[src];one_access=1'>ALL</a><hr>"

		t1 += conf_access == null ? "<font color=red>All</font><br>" : "<a href='?src=\ref[src];access=all'>All</a><br>"

		t1 += "<br>"

		var/list/accesses = get_all_station_access()
		for(var/acc in accesses)
			var/aname = get_access_desc(acc)

			if(!conf_access?.len || !(acc in conf_access))
				t1 += "<a href='?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else if(one_access)
				t1 += "<a style='color: green' href='?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else
				t1 += "<a style='color: red' href='?src=\ref[src];access=[acc]'>[aname]</a><br>"

	t1 += text("<p><a href='?src=\ref[];close=1'>Close</a></p>\n", src)

	user << browse(t1, "window=airlock_electronics")
	onclose(user, "airlock")

/obj/item/airlock_electronics/Topic(href, href_list)
	..()
	if(use_check_and_message(usr))
		return
	if(href_list["close"])
		usr << browse(null, "window=airlock")
		return

	if(href_list["login"])
		if(istype(usr, /mob/living/silicon))
			locked = FALSE
			last_configurator = usr.name
		else
			var/obj/item/I = usr.get_active_hand()
			if(istype(I, /obj/item/device/pda))
				var/obj/item/device/pda/pda = I
				I = pda.id
			if(I && src.check_access(I))
				locked = FALSE
				last_configurator = I:registered_name

	if(locked)
		return

	if(href_list["logout"])
		locked = TRUE

	if(href_list["one_access"])
		one_access = !one_access

	if(href_list["access"])
		toggle_access(href_list["access"])

	attack_self(usr)

/obj/item/airlock_electronics/proc/toggle_access(var/acc)
	if(acc == "all")
		conf_access = null
	else
		var/req = text2num(acc)

		if(conf_access == null)
			conf_access = list()

		if(!(req in conf_access))
			conf_access += req
		else
			conf_access -= req
			if(!conf_access.len)
				conf_access = null

/obj/item/airlock_electronics/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/airlock_electronics))
		if(src.locked)
			to_chat(user, SPAN_WARNING("\The [src] you're trying to set is locked! Swipe your ID to unlock."))
			return
		var/obj/item/airlock_electronics/A = W
		if(A.locked)
			to_chat(user, SPAN_WARNING("\The [src] you're trying to copy is locked! Swipe your ID to unlock."))
			return
		src.conf_access = A.conf_access
		src.one_access = A.one_access
		src.last_configurator = A.last_configurator
		to_chat(user, SPAN_NOTICE("Configuration settings copied successfully."))
	else if(istype(W, /obj/item/card/id))
		var/obj/item/card/id/I = W
		if(check_access(I))
			locked = !locked
			last_configurator = I.registered_name
			to_chat(user, SPAN_NOTICE("You swipe your ID over \the [src], [locked ? "locking" : "unlocking"] it."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
	else if(istype(W, /obj/item/device/pda))
		var/obj/item/device/pda/P = W
		var/obj/item/card/id/I = P.id
		if(!I)
			to_chat(user, SPAN_WARNING("Your PDA doesn't have an ID in it!"))
			return
		if(check_access(I))
			locked = !locked
			last_configurator = I.registered_name
			to_chat(user, SPAN_NOTICE("You swipe your PDA over \the [src], [locked ? "locking" : "unlocking"] it."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
	else
		..()

/obj/item/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "Designed to be somewhat more resistant to hacking than standard electronics."
	description_info = "With these electronics, wires will be randomized and bolts will drop if the airlock is broken."
	origin_tech = list(TECH_DATA = 2)
	secure = TRUE
