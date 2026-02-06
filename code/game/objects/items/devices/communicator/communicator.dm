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

	// Instant messaging vars

	// Notepad vars

	/// TODO: Autodoc everything (copy proc comments from Polaris)
	var/can_hear_range = 3

	var/list/outgoing_call_invites = list()
	var/list/incoming_call_invites = list()
	var/list/obj/item/communicator/connected_callers = list()

	var/owner_name = ""
	var/owner_occupation = ""
	var/ringer = TRUE
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
	hang_up(SPAN_DANGER("Connection timed out with remote host."))
	return ..()

/obj/item/communicator/attack_self(mob/user, modifiers)
	. = ..()
	if(new_alert)
		new_alert = FALSE
		update_icon()

	if(!owner_name)
		register_to_user(user)
		return

	if((input(user) as anything in list("TGUI", "Debug UI")) == "TGUI")
		ui_interact(user)
	else
		temp_debug_input(user)

/obj/item/communicator/proc/temp_debug_input(mob/user)
	var/target_address = input(user, "Target Address:", "Debugging UI") as null|anything in GLOB.all_exonet_connections - exonet.address
	if(!target_address)
		return

	var/actions = list()
	if(target_address in outgoing_call_invites)
		actions += "Cancel Voice Call"
	else if(target_address in incoming_call_invites)
		actions |= list("Accept Voice Call", "Decline Voice Call")
	else if(exonet.get_atom_from_address(target_address) in connected_callers)
		actions += "Stop Voice Call"
	else
		actions += "Voice Call"
	actions += "Ping"

	switch(input(user, "Action:", "Debugging UI") as null|anything in actions)
		if("Voice Call")
			exonet.send_message(target_address, EXONET_MSG_CALL_INVITE)
		if("Cancel Voice Call")
			exonet.send_message(target_address, EXONET_MSG_CALL_CANCEL)
		if("Accept Voice Call")
			accept_call(target_address)
		if("Decline Voice Call")
			remove_call_invite(target_address, SPAN_WARNING("Your communicator call request was declined."), SPAN_NOTICE("Declined request."))
		if("Stop Voice Call")
			hang_up(SPAN_DANGER("[user] hung up."))
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

/obj/item/communicator/update_icon()
	. = ..()
	var/suffix
	if(length(connected_callers))
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

/obj/item/communicator/proc/register_device(new_owner)
	if(!new_owner)
		return
	owner_name = new_owner
	name = "[new_owner]'s [initial(name)]"

/obj/item/communicator/proc/message_holding_mob(message)
	if(ismob(loc))
		to_chat(loc, "[icon2html(src, loc)] [message]")

/obj/item/communicator/proc/receive_exonet_message(origin_address, data_type, content)
	switch(data_type)
		if(EXONET_MSG_CALL_INVITE)
			add_call_invite(origin_address)
		if(EXONET_MSG_CALL_CANCEL)
			// Caller changes their mind and cancels.
			var/obj/item/communicator/caller_comm = exonet.get_atom_from_address(origin_address)
			remove_call_invite(origin_address, SPAN_NOTICE("Communications request cancelled."), SPAN_NOTICE("Communications request from [caller_comm || "ERROR"] cancelled."))
		if(EXONET_MSG_TEXT)
			return //todo
		if(EXONET_MSG_PING) // Recieved a ping.
			// Send a reply.
			exonet.send_message(origin_address, EXONET_MSG_PING_REPLY, "64 bytes received from [exonet.address] ecmp_seq=1 ttl=51 time=[rand(20, 35)] ms")
		if(EXONET_MSG_PING_REPLY) // Recieved a ping reply.
			message_holding_mob(content)
	return TRUE
