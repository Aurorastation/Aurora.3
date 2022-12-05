/*
	Basically just an empty shell for receiving and broadcasting radio messages. Not
	very flexible, but it gets the job done.
*/

/obj/machinery/telecomms/allinone
	name = "telecommunications mainframe"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "comm_server"
	desc = "A compact machine used for portable subspace telecommuniations processing."
	idle_power_usage = 0
	active_power_usage = 0
	produces_heat = FALSE
	overmap_range = 2 // AIOs aren't true relays

	var/away_aio = FALSE
	var/intercept = FALSE // if TRUE, broadcasts all messages to syndicate channel
	var/list/recent_broadcasts

/obj/machinery/telecomms/allinone/Initialize()
	. = ..()
	LAZYINITLIST(recent_broadcasts)
	if(intercept)
		freq_listening |= ANTAG_FREQS	//Covers any updates to ANTAG_FREQS

	desc += " It has an effective reception range of [overmap_range] grids on the overmap."

/obj/machinery/telecomms/allinone/receive_signal(datum/signal/subspace/signal)
	if(!use_power || !istype(signal) || signal.transmission_method != TRANSMISSION_SUBSPACE)
		return

	if(!intercept && (!is_freq_listening(signal) || !check_range(signal))) // If we're an antag intercepting all-in-one, don't bother checking overmap range or whether we care about the freq
		return

	signal.levels = GetConnectedZlevels(z)

	// Decompress the signal, mark it received
	signal.data["compression"] = 0
	signal.mark_done()

	var/signal_message = "[signal.frequency]:[signal.data["message"]]:[signal.data["realname"]]"
	if(signal_message in recent_broadcasts)
		return

	LAZYADD(recent_broadcasts, signal_message)

	if(signal.data["slow"] > 0)
		addtimer(CALLBACK(signal, /datum/signal/subspace/proc/broadcast), signal.data["slow"]) // network lag
	else
		signal.broadcast()

	spawn(10)
		recent_broadcasts -= signal_message

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

/obj/machinery/telecomms/allinone/ship/shuttle
	name = "shuttle communications unit"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "broadcast receiver"
	desc = "This compact machine allows shuttles and other parasite craft to perform limited radio communication while detached from their mothership."

/obj/machinery/telecomms/allinone/ship/shuttle/LateInitialize()
	. = ..()
	for (var/obj/machinery/telecomms/allinone/A in telecomms_list)
		if(A.z == src.z)
			toggle_power(POWER_USE_OFF)
			// TURN IT OFF

	for (var/obj/machinery/telecomms/broadcaster/B in telecomms_list)
		if(B.z == src.z)
			toggle_power(POWER_USE_OFF)
			// TURN IT OFF

//This goes on the station map so away ships can maintain radio contact.
//Regular telecomms machines cannot listen to broadcasts coming from non-station z-levels. If we did this, comms would be receiving a substantial amount of duplicated messages.
/obj/machinery/telecomms/allinone/ship/station_relay
	name = "external signal receiver"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "ntnet"
	desc = "This device allows nearby third-party ships to maintain radio contact with their crew that are aboard the %STATIONNAME."
	desc_info = "This device does not need to be linked to other telecommunications equipment; it will receive and broadcast on its own. It only needs to be powered."
	idle_power_usage = 25
	active_power_usage = 200
	freq_listening = list(HAIL_FREQ)
	away_aio = FALSE

/obj/machinery/telecomms/allinone/ship/station_relay/LateInitialize()
	. = ..()
	desc = replacetext(desc, "%STATIONNAME", current_map.station_name)
	freq_listening |= AWAY_FREQS_ASSIGNED
	freq_listening |= AWAY_FREQS_UNASSIGNED
