GLOBAL_LIST_EMPTY_TYPED(all_communicators, /obj/item/communicator)

/obj/item/communicator
	name = "communicator"
	desc = "A T-14.2 communicator, popular across the galaxy for it's simplicity to use." // todo: "galaxy"?
	icon = 'icons/obj/devices/communicator.dmi'
	icon_state = "communicator"
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_ID | SLOT_BELT

	// Tech and mats vars

	// Video vars

	var/list/outgoing_call_invites // lazylist
	var/list/incoming_call_invites // lazylist

	var/list/obj/item/communicator/connected_callers // lazylist

	// Instant messaging vars

	// Notepad vars

	/// TODO: Autodoc everything (copy proc comments from Polaris)
	var/can_hear_range = 3

	var/owner_name = ""
	var/owner_occupation = ""
	var/new_alert = FALSE

	var/datum/exonet_protocol/exonet = null

/obj/item/communicator/Initialize(mapload)
	. = ..()
	GLOB.all_communicators += src

	//This is a pretty terrible way of doing this.
	addtimer(CALLBACK(src, PROC_REF(register_to_user), null, TRUE), 5 SECONDS)

/obj/item/communicator/Destroy()
	GLOB.all_communicators -= src
	QDEL_NULL(exonet)

	for(var/obj/item/communicator/comm in connected_callers)
		comm.remove_from_call(src)
	LAZYNULL(connected_callers)
	return ..()

/obj/item/communicator/attack_self(mob/user, modifiers)
	. = ..()
	if(new_alert)
		new_alert = FALSE
		update_icon()

	if(!owner_name)
		register_to_user(user)
		// everything in this proc from here forwards is temp testing stuff
		return

	var/target_address = input(user, "Target Address:", "Debugging UI") as null|anything in GLOB.all_exonet_connections - exonet.address
	if(!target_address)
		return
	var/target_is_calling = LAZYISIN(incoming_call_invites, target_address)
	switch(input(user, "Action:", "Debugging UI") as null|anything in list("[target_is_calling ? "Accept " : ""]Voice call", "Ping"))
		if("Voice call")
			exonet.send_message(target_address, EXONET_MSG_CALL_INVITE)
		if("Accept Voice call")
			accept_call(user, target_address)
		if("Ping")
			if(!exonet.send_message(target_address, EXONET_MSG_PING))
				sleep(4 SECONDS)
				to_chat(user, SPAN_WARNING("[icon2html(src, user)] Request timed out: Destination unreachable."))

/obj/item/communicator/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/card/id))
		var/obj/item/card/id/id_card = attacking_item

		if(!owner_name)
			register_to_user(user)

		if(owner_name != id_card.registered_name || !id_card.assignment)
			to_chat(user, SPAN_NOTICE("[src] rejects the ID."))
		else if(owner_occupation != id_card.assignment)
			owner_occupation = id_card.assignment
			to_chat(user, SPAN_NOTICE("[icon2html(src, user)] Occupation updated."))

/obj/item/communicator/hear_talk(mob/M, text, verb, datum/language/speaking)
	. = ..()
	if(speaking.flags & (NONVERBAL|SIGNLANG) || get_dist(src, M) > can_hear_range)
		return

	for(var/obj/item/communicator/comm as anything in connected_callers)
		var/list/listeners = get_hearers_in_view(world.view, comm)
		comm.langchat_speech(text, listeners, speaking, M.langchat_color)

		// Lots copied from `hear_say()`. Saycode really needs refactoring.
		for(var/mob/listener in listeners)
			if(isdeaf(listener))
				continue

			var/listener_message
			if(!listener.say_understands(M, speaking))
				listener_message = speaking ? speaking.scramble(text, listener.languages) : stars(text)
			listener_message = speaking ? speaking.format_message(text, verb) : "<span class='message body'>[text]</span>"

			var/combined_message = "[icon2html(comm, listener)] [M.get_accent_icon()] <span class='game say'><span class='name'>[M.GetVoice()]</span> [listener_message]</span>"
			to_chat(listener, combined_message)

/obj/item/communicator/update_icon()
	. = ..()
	var/suffix
	if(LAZYLEN(connected_callers))
		suffix = "-active"

	if(new_alert)
		suffix = "-called"

	icon_state = "[initial(icon_state)][suffix]"

// called after initialize for if it's a loadout pick, on attack_self, and attackby an ID (temp comment)
/obj/item/communicator/proc/register_to_user(mob/user, silent = FALSE)
	user ||= get_holding_mob()
	if(!istype(user))
		return

	register_device(user.name)
	initialize_exonet(user)
	if(!silent)
		to_chat(user, SPAN_NOTICE("[icon2html(src, user)] Communicator registered."))

/obj/item/communicator/proc/initialize_exonet(mob/living/user)
	if(!istype(user) || exonet)
		return

	exonet = new(
		src,
		"communicator-[user.name]-[text_ref(src)]",
		CALLBACK(src, PROC_REF(receive_exonet_message))
	)
	//if(!node)
	//	node = get_exonet_node()
	//populate_known_devices()

/obj/item/communicator/proc/register_device(new_name)
	if(!new_name)
		return
	owner_name = new_name

	name = "[new_name]'s [initial(name)]"

/obj/item/communicator/proc/receive_exonet_message(datum/exonet_protocol/origin_datum, data_type, content)
	switch(data_type)
		if(EXONET_MSG_CALL_INVITE)
			add_call_invite(origin_datum.address)
		if(EXONET_MSG_TEXT)
			return //todo
		if(EXONET_MSG_PING) // Recieved a ping.
			// Send a reply.
			exonet.send_message(origin_datum.address, EXONET_MSG_PING_REPLY, "64 bytes received from [exonet.address] ecmp_seq=1 ttl=51 time=[rand(20, 35)] ms")
		if(EXONET_MSG_PING_REPLY) // Recieved a ping reply.
			if(ismob(loc))
				to_chat(loc, "[icon2html(src, loc)] [content]")
	return TRUE

/obj/item/communicator/proc/add_call_invite(caller_address)
	if(LAZYISIN(incoming_call_invites, caller_address) || LAZYISIN(outgoing_call_invites, caller_address))
		return

	LAZYADD(incoming_call_invites, caller_address)

	var/obj/item/communicator/caller_comm = exonet.get_atom_from_address(caller_address)
	LAZYADD(caller_comm.outgoing_call_invites, exonet.address)

	//if(ringer)
	playsound(src, 'sound/machines/twobeep.ogg', 50, TRUE)
	for(var/mob/M as anything in hearers(2, loc))
		M.show_message("[icon2html(src, M)] *beep* *beep*", 2)

	new_alert = TRUE
	update_icon()

	if(ismob(loc))
		to_chat(loc, SPAN_NOTICE("[icon2html(src, loc)] Communications request from [caller_comm.owner_name]."))


/obj/item/communicator/proc/add_to_call(obj/item/communicator/other)
	// Manual LAZYADD so that hearing sensitivity is tied to it.
	if(!connected_callers)
		connected_callers = list()
		become_hearing_sensitive()
	connected_callers += other

	update_icon()

/obj/item/communicator/proc/remove_from_call(obj/item/communicator/other)
	// Manual LAZYREMOVE so that hearing sensitivity is tied to it.
	connected_callers -= other
	if(!length(connected_callers))
		connected_callers = null
		lose_hearing_sensitivity()

	update_icon()

/obj/item/communicator/proc/accept_call(mob/user, caller_address)
	//voice_invites.Remove(candidate)
	//comm.voice_requests.Remove(src)

	// "connecting" text goes here

	var/obj/item/communicator/caller_comm = exonet.get_atom_from_address(caller_address)
	src.add_to_call(caller_comm)
	caller_comm.add_to_call(src)
