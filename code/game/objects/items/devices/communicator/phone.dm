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

// Todo: Audible emotes over calls

/obj/item/communicator/proc/add_call_invite(caller_address)
	if((caller_address in incoming_call_invites) || (caller_address in outgoing_call_invites))
		return

	var/obj/item/communicator/caller_comm = exonet.get_atom_from_address(caller_address)
	if(!caller_comm || (caller_comm in connected_callers))
		return

	incoming_call_invites[caller_address] = caller_comm.owner_name
	caller_comm.outgoing_call_invites[exonet.address] = src.owner_name

	if(ringer)
		playsound(src, 'sound/machines/twobeep.ogg', 50, TRUE)
		for(var/mob/M as anything in hearers(2, loc))
			if(M == loc)
				M.show_message(SPAN_NOTICE("[icon2html(src, M)] Communications request from [caller_comm.owner_name]."))
			else
				M.show_message("[icon2html(src, M)] *beep* *beep*", 2)

	new_alert = TRUE
	update_icon()

/obj/item/communicator/proc/remove_call_invite(caller_address, caller_reason, callee_reason)
	if(!(caller_address in incoming_call_invites))
		return

	incoming_call_invites -= caller_address
	message_holding_mob(callee_reason)

	var/obj/item/communicator/caller_comm = exonet.get_atom_from_address(caller_address)
	if(!caller_comm)
		return
	caller_comm.outgoing_call_invites -= exonet.address
	caller_comm.message_holding_mob(caller_reason)

/obj/item/communicator/proc/add_to_call(obj/item/communicator/other)
	if(!length(connected_callers))
		become_hearing_sensitive()
	connected_callers += other

	update_icon()

/obj/item/communicator/proc/remove_from_call(obj/item/communicator/other)
	connected_callers -= other
	if(!length(connected_callers))
		lose_hearing_sensitivity()

	update_icon()

/obj/item/communicator/proc/accept_call(caller_address)
	incoming_call_invites -= caller_address

	var/obj/item/communicator/caller_comm = exonet.get_atom_from_address(caller_address)
	if(!caller_comm)
		return // todo: some kind of error message
	caller_comm.outgoing_call_invites -= exonet.address

	caller_comm.message_holding_mob(SPAN_NOTICE("Connecting to [src]."))
	message_holding_mob(SPAN_NOTICE("Attempting to call [caller_comm]."))
	sleep(1 SECOND)

	if(!accept_call_checks(caller_comm))
		return
	message_holding_mob(SPAN_NOTICE("Dialing internally from [station_name()]."))
	sleep(2 SECONDS)

	if(!accept_call_checks(caller_comm))
		return
	message_holding_mob(SPAN_NOTICE("Connection re-routed to [caller_comm] at [caller_address]."))
	sleep(4 SECONDS)

	if(!accept_call_checks(caller_comm))
		return
	message_holding_mob(SPAN_NOTICE("Connection to [caller_comm] at [caller_address] established!"))
	caller_comm.message_holding_mob(SPAN_NOTICE("Connection to [src] at [exonet.address] established!"))

	src.add_to_call(caller_comm)
	caller_comm.add_to_call(src)

// includes checks and stuff to handle the sleeps
/obj/item/communicator/proc/accept_call_checks(obj/item/communicator/caller_comm)
	if(QDELETED(src) || QDELETED(caller_comm))
		return FALSE
	return TRUE

/obj/item/communicator/proc/hang_up(reason)
	for(var/obj/item/communicator/comm in connected_callers)
		src.remove_from_call(comm)
		comm.remove_from_call(src)
		comm.message_holding_mob("[reason]")
