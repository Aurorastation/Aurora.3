/obj/item/device/taperecorder
	name = "universal recorder"
	desc = "A device that can record up to an hour of dialogue and play it back. It automatically translates the content in playback."
	icon_state = "taperecorderidle"
	item_state = "analyzer"
	w_class = ITEMSIZE_SMALL

	matter = list(DEFAULT_WALL_MATERIAL = 60, MATERIAL_GLASS = 30)

	var/emagged = FALSE
	var/recording = FALSE
	var/playing = FALSE
	var/time_recorded = 0
	var/play_sleep_seconds = 0
	var/list/stored_info = list() // TOOK OUT NEW THING
	var/list/timestamp = list()
	var/can_print = TRUE
	var/obj/item/computer_hardware/hard_drive/portable/portable_drive
	flags = CONDUCT
	throwforce = 2
	throw_speed = 4
	throw_range = 20

/obj/item/device/taperecorder/Initialize()
	. = ..()
	become_hearing_sensitive(ROUNDSTART_TRAIT)
	portable_drive = new /obj/item/computer_hardware/hard_drive/portable(src)

/obj/item/device/taperecorder/Destroy()
	listening_objects -= src
	if(portable_drive)
		QDEL_NULL(portable_drive)
	return ..()

/obj/item/device/taperecorder/hear_talk(mob/living/M, msg, var/verb = "says", datum/language/speaking = null)
	if(isanimal(M))
		if(!M.universal_speak)
			return

	if(recording)
		timestamp += time_recorded

		if(speaking)
			if(!speaking.machine_understands)
				msg = speaking.scramble(msg)
			stored_info += "\[[time2text(time_recorded*10,"mm:ss")]\] [M.name] [speaking.format_message_plain(msg, verb)]"
		else
			stored_info += "\[[time2text(time_recorded*10,"mm:ss")]\] [M.name] [verb], \"[msg]\""

/obj/item/device/taperecorder/see_emote(mob/M, text, var/emote_type)
	if(emote_type != 2) //only hearable emotes
		return
	if(recording)
		timestamp += time_recorded
		stored_info += "\[[time2text(time_recorded*10,"mm:ss")]\] [strip_html_properly(text)]"

/obj/item/device/taperecorder/show_message(msg, type, alt, alt_type)
	var/recordedtext
	if(msg && type == 2) //must be hearable
		recordedtext = msg
	else if(alt && alt_type == 2)
		recordedtext = alt
	else
		return
	if(recording)
		timestamp += time_recorded
		stored_info += "*\[[time2text(time_recorded*10,"mm:ss")]\] *[strip_html_properly(recordedtext)]*" //"*" at front as a marker

/obj/item/device/taperecorder/emag_act(var/remaining_charges, mob/user)
	if(emagged)
		to_chat(user, SPAN_WARNING("It is already emagged!"))
		return FALSE
	emagged = TRUE
	recording = FALSE
	to_chat(user, SPAN_NOTICE("PZZTTPFFFT"))
	icon_state = "taperecorderidle"
	return TRUE

/obj/item/device/taperecorder/proc/explode()
	var/turf/T = get_turf(loc)
	visible_message(SPAN_DANGER("\The [src] explodes!"))
	if(T)
		T.hotspot_expose(700, 125)
		explosion(T, -1, -1, 0, 4)
	qdel(src)
	return

/obj/item/device/taperecorder/verb/record()
	set name = "Start Recording"
	set category = "Object"

	if(use_check_and_message(usr))
		return
	if(emagged)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	icon_state = "taperecorderrecording"
	if(time_recorded < 3600 && !playing)
		to_chat(usr, SPAN_NOTICE("Recording started."))
		recording = TRUE
		timestamp += time_recorded
		stored_info += "\[[time2text(time_recorded*10,"mm:ss")]\] Recording started."
		for(time_recorded, time_recorded < 3600)
			if(!recording)
				break
			time_recorded++
			sleep(10)
		recording = FALSE
		icon_state = "taperecorderidle"
		return
	else
		to_chat(usr, SPAN_NOTICE("Either your tape recorder's memory is full, or it is currently playing back its memory."))

/obj/item/device/taperecorder/verb/stop()
	set name = "Stop Recording"
	set category = "Object"

	if(use_check_and_message(usr))
		return
	if(emagged)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return

	if(recording)
		recording = FALSE
		timestamp += time_recorded
		stored_info += "\[[time2text(time_recorded*10,"mm:ss")]\] Recording stopped."
		to_chat(usr, SPAN_NOTICE("Recording stopped."))
		icon_state = "taperecorderidle"
		return
	else if(playing)
		playing = FALSE
		audible_message("<font color=Maroon><B>Tape Recorder</B>: Playback stopped.</font>", hearing_distance = 3)
		icon_state = "taperecorderidle"
		return

/obj/item/device/taperecorder/verb/clear_memory()
	set name = "Clear Memory"
	set category = "Object"

	if(use_check_and_message(usr))
		return
	if(emagged)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(recording || playing)
		to_chat(usr, SPAN_WARNING("You can't clear the memory while playing or recording!"))
		return
	else
		if(stored_info)
			stored_info.Cut()
		if(timestamp)
			timestamp.Cut()
		time_recorded = 0
		to_chat(usr, SPAN_NOTICE("Memory cleared."))
		return

/obj/item/device/taperecorder/verb/playback_memory()
	set name = "Playback Memory"
	set category = "Object"

	if(use_check_and_message(usr))
		return
	if(recording)
		to_chat(usr, SPAN_WARNING("You can't playback when recording!"))
		return
	if(playing)
		to_chat(usr, SPAN_WARNING("You're already playing!"))
		return
	playing = TRUE
	icon_state = "taperecorderplaying"
	to_chat(usr, SPAN_NOTICE("Playing started."))
	for(var/i = 1, time_recorded < 3600, sleep(10 * play_sleep_seconds))
		if(!playing)
			break
		if(stored_info.len < i)
			break
		var/playedmessage = stored_info[i]
		if(findtextEx(playedmessage, "*" , 1, 2)) //remove marker for action sounds
			playedmessage = copytext(playedmessage, 2)
		audible_message("<font color=Maroon><B>Tape Recorder</B>: [playedmessage]</font>", hearing_distance = 3)
		if(stored_info.len < i + 1)
			play_sleep_seconds = 1
			sleep(10)
			audible_message("<font color=Maroon><B>Tape Recorder</B>: End of recording.</font>", hearing_distance = 3)
		else
			play_sleep_seconds = timestamp[i + 1] - timestamp[i]
		if(play_sleep_seconds > 14)
			sleep(10)
			audible_message("<font color=Maroon><B>Tape Recorder</B>: Skipping [play_sleep_seconds] seconds of silence.</font>", hearing_distance = 3)
			play_sleep_seconds = 1
		i++
	icon_state = "taperecorderidle"
	playing = FALSE
	if(emagged)
		audible_message("<font color=Maroon><B>Tape Recorder</B>: This tape recorder will self-destruct in... Five.</font>", hearing_distance = 3)
		sleep(15)
		audible_message("<font color=Maroon><B>Tape Recorder</B>: Four.</font>", hearing_distance = 3)
		sleep(15)
		audible_message("<font color=Maroon><B>Tape Recorder</B>: Three.</font>", hearing_distance = 3)
		sleep(15)
		audible_message("<font color=Maroon><B>Tape Recorder</B>: Two.</font>", hearing_distance = 3)
		sleep(15)
		audible_message("<font color=Maroon><B>Tape Recorder</B>: One.</font>", hearing_distance = 3)
		sleep(15)
		explode()

/obj/item/device/taperecorder/verb/print_transcript()
	set name = "Print Transcript"
	set category = "Object"

	if(use_check_and_message(usr))
		return
	if(emagged)
		to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
		return
	if(!can_print)
		to_chat(usr, SPAN_WARNING("The recorder can't print that fast!"))
		return
	if(recording || playing)
		to_chat(usr, SPAN_WARNING("You can't print the transcript while playing or recording!"))
		return
	to_chat(usr, SPAN_NOTICE("Transcript printed."))
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i = 1, stored_info.len >= i, i++)
		var/printed_message = stored_info[i]
		if(findtextEx(printed_message,"*", 1, 2))
			printed_message = "\[[time2text(timestamp[i]*10,"mm:ss")]\] (Unrecognized sound)"
		t1 += "[printed_message]<BR>"
	P.info = t1
	P.name = "Transcript"
	usr.put_in_hands(P)
	can_print = FALSE
	addtimer(CALLBACK(src, PROC_REF(set_can_print), 1), 150)

/obj/item/device/taperecorder/proc/set_can_print(var/set_state = TRUE)
	can_print = set_state

/obj/item/device/taperecorder/verb/eject_usb()
	set name = "Eject Portable Storage"
	set category = "Object"

	if(use_check_and_message(usr))
		return
	if(!portable_drive)
		to_chat(usr, SPAN_WARNING("There is no portable drive connected to \the [src]."))
		return

	var/datum/computer_file/data/F = new /datum/computer_file/data(portable_drive)
	F.filename = "[capitalize_first_letters(src.name)] Digital Transcript ([worldtime2text()] - [time2text(world.time, "Month DD")])"
	F.filetype = "TXT"

	var/file_data = "<B>Transcript:</B><BR>"
	for(var/i = 1, stored_info.len >= i, i++)
		var/printed_message = stored_info[i]
		if(findtextEx(printed_message,"*", 1, 2))
			printed_message = "\[[time2text(timestamp[i]*10,"mm:ss")]\] (Unrecognized sound)"
		file_data += "[printed_message]<BR>"

	F.stored_data = file_data
	if(!portable_drive.store_file(F))
		to_chat(usr, SPAN_WARNING("\The [portable_drive] does not have enough space to store the latest transcript, but will eject anyway."))

	to_chat(usr, SPAN_NOTICE("You eject the portable drive."))
	usr.put_in_hands(portable_drive)
	portable_drive = null

/obj/item/device/taperecorder/attack_self(mob/user)
	if(!recording && !playing)
		if(use_check_and_message(usr))
			return
		if(emagged)
			to_chat(usr, SPAN_WARNING("The tape recorder makes a scratchy noise."))
			return
		icon_state = "taperecorderrecording"
		if(time_recorded < 3600 && !playing)
			to_chat(usr, SPAN_NOTICE("Recording started."))
			recording = TRUE
			timestamp += time_recorded
			stored_info += "\[[time2text(time_recorded*10,"mm:ss")]\] Recording started."
			for(time_recorded, time_recorded < 3600)
				if(!recording)
					break
				time_recorded++
				sleep(10)
			recording = FALSE
			icon_state = "taperecorderidle"
			return
		else
			to_chat(usr, SPAN_WARNING("Either your tape recorder's memory is full, or it is currently playing back its memory."))
	else
		if(use_check_and_message(usr))
			return
		if(recording)
			recording = FALSE
			timestamp += time_recorded
			stored_info += "\[[time2text(time_recorded*10,"mm:ss")]\] Recording stopped."
			to_chat(usr, SPAN_NOTICE("Recording stopped."))
			icon_state = "taperecorderidle"
			return
		else if(emagged)
			to_chat(usr, SPAN_WARNING("The tape recorder's buttons doesn't react!"))
			return
		else if(playing)
			playing = FALSE
			audible_message("<font color=Maroon><B>Tape Recorder</B>: Playback stopped.</font>", hearing_distance = 3)
			icon_state = "taperecorderidle"
			return

/obj/item/device/taperecorder/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/computer_hardware/hard_drive/portable))
		if(portable_drive)
			to_chat(user, SPAN_WARNING("\The [src] already has a portable drive!"))
			return
		user.drop_from_inventory(W, src)
		portable_drive = W
	else
		..()
