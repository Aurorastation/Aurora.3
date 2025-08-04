/*
	Basically just an empty shell for receiving and broadcasting radio messages. Not
	very flexible, but it gets the job done.
*/

/obj/machinery/telecomms/allinone
	name = "telecommunications mainframe"
	icon_state = "comm_server"
	desc = "A compact machine used for portable subspace telecommuniations processing."
	idle_power_usage = 0
	active_power_usage = 0
	produces_heat = FALSE
	overmap_range = 3

	var/away_aio = FALSE
	var/list/recent_broadcasts

/obj/machinery/telecomms/allinone/Initialize()
	. = ..()
	if(!freq_listening.len)
		freq_listening = ANTAG_FREQS
	LAZYINITLIST(recent_broadcasts)
	SSmachinery.all_receivers += src

	desc += " It has an effective reception range of [overmap_range] grids on the overmap."

/obj/machinery/telecomms/allinone/Destroy()
	SSmachinery.all_receivers -= src
	return ..()

/obj/machinery/telecomms/allinone/receive_signal(datum/signal/subspace/signal)
	signal.levels = broadcast_levels(signal)

	// Decompress the signal, mark it received
	signal.data["compression"] = 0
	signal.mark_done()

	var/signal_message = "[signal.frequency]:[signal.data["message"]]:[signal.data["realname"]]"
	if(signal_message in recent_broadcasts)
		return

	LAZYADD(recent_broadcasts, signal_message)

	if(signal.data["slow"] > 0)
		addtimer(TYPE_PROC_REF(/datum/signal/subspace, broadcast), signal.data["slow"]) // network lag
	else
		signal.broadcast()

	addtimer(CALLBACK(src, PROC_REF(remove_signal_message_from_recent_broadcasts), signal_message), 1 SECONDS)

/obj/machinery/telecomms/allinone/proc/remove_signal_message_from_recent_broadcasts(signal_message)
	recent_broadcasts -= signal_message

/obj/machinery/telecomms/allinone/ship
	away_aio = TRUE

/obj/machinery/telecomms/allinone/ship/LateInitialize()
	. = ..()
	if(!linked)
		return

	if(away_aio)
		if(linked.comms_name)
			name = "[lowertext(linked.comms_name)] [initial(name)]"
		freq_listening = list(
			HAIL_FREQ,
			assign_away_freq(linked.name)
		)

/obj/machinery/telecomms/allinone/ship/coalition_navy
	name = "coalition navy telecommunications mainframe"
	desc = "A compact machine used for portable subspace telecommuniations processing. This one also has encryption codes for Coalition navy vessels."

/obj/machinery/telecomms/allinone/ship/coalition_navy/LateInitialize()
	. = ..()
	freq_listening += COAL_FREQ

//This goes on the station map so away ships can maintain radio contact.
/obj/machinery/telecomms/allinone/ship/station_relay
	name = "external signal receiver"
	desc = "This device allows nearby third-party ships to maintain radio contact with their crew that are aboard the %STATIONNAME."
	idle_power_usage = 25
	active_power_usage = 200
	freq_listening = list(HAIL_FREQ)
	away_aio = FALSE

/obj/machinery/telecomms/allinone/ship/station_relay/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This device does not need to be linked to other telecommunications equipment; it will receive and broadcast on its own. It only needs to be powered."

/obj/machinery/telecomms/allinone/ship/station_relay/LateInitialize()
	. = ..()
	desc = replacetext(desc, "%STATIONNAME", SSatlas.current_map.station_name)
	for(var/ch in AWAY_FREQS_ASSIGNED)
		freq_listening |= AWAY_FREQS_ASSIGNED[ch]
	freq_listening |= AWAY_FREQS_UNASSIGNED
	freq_listening |= ANTAG_FREQS

/obj/machinery/telecomms/allinone/ship
