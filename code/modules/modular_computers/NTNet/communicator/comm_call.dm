/datum/comm_call
	var/call_start_time
	var/list/datum/computer_file/program/communicator/connected_comms = list()

/datum/comm_call/New()
	. = ..()
	call_start_time = world.timeofday

/datum/comm_call/Destroy(force)
	for(var/datum/computer_file/program/communicator/comm as anything in connected_comms)
		remove_device(comm)
	return ..()

/datum/comm_call/proc/add_device(datum/computer_file/program/communicator/comm_app)
	connected_comms |= comm_app
	comm_app.computer.become_hearing_sensitive()
	comm_app.active_call = src

	RegisterSignal(comm_app.computer, COMSIG_OBJ_HEAR_TALK, PROC_REF(on_hear_talk))

/datum/comm_call/proc/remove_device(datum/computer_file/program/communicator/comm_app, message)
	connected_comms -= comm_app
	comm_app.computer.lose_hearing_sensitivity()
	comm_app.active_call = null

	UnregisterSignal(comm_app.computer, COMSIG_OBJ_HEAR_TALK)

	// If there's only one person left, just end the call. (`Destroy()` handles removing the last person)
	if(length(connected_comms) == 1)
		qdel(src)
	else if(message)
		for(var/datum/computer_file/program/communicator/comm as anything in connected_comms)
			comm.computer.output_error(message)

/datum/comm_call/proc/set_mute(datum/computer_file/program/communicator/comm_app, should_mute)
	if(should_mute)
		comm_app.computer.lose_hearing_sensitivity()
	else
		comm_app.computer.become_hearing_sensitive()

/datum/comm_call/proc/on_hear_talk(
	obj/item/modular_computer/handheld/communicator/hearer,
	mob/M,
	text,
	verb,
	datum/language/speaking
)
	// Todo: `output_spoken_message()`? (it would need tweaking)
	SIGNAL_HANDLER
	if(speaking.flags & (NONVERBAL|SIGNLANG) || get_dist(hearer, M) > hearer.mic_range)
		return

	for(var/datum/computer_file/program/communicator/comm_app as anything in connected_comms)
		var/obj/item/modular_computer/handheld/communicator/computer = comm_app.computer
		if(computer == hearer)
			continue

		var/speaker_range = comm_app.speakerphone_on ? world.view : 0
		var/list/comm_listeners = get_hearers_in_view(speaker_range, computer)
		computer.langchat_speech(text, comm_listeners, speaking, M.langchat_color)

		for(var/mob/listener in comm_listeners)
			if(isdeaf(listener))
				continue

			var/listener_message
			if(!listener.say_understands(M, speaking))
				listener_message = speaking ? speaking.scramble(text, listener.languages) : stars(text)
			listener_message = speaking ? speaking.format_message(text, verb) : "<span class='message body'>[text]</span>"

			var/combined_message = "[icon2html(computer, listener)] [M.get_accent_icon()] <span class='game say'><span class='name'>[M.GetVoice()]</span> [listener_message]</span>"
			to_chat(listener, combined_message)
