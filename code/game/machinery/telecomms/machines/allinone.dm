/*
	Basically just an empty shell for receiving and broadcasting radio messages. Not
	very flexible, but it gets the job done.
*/

/obj/machinery/telecomms/allinone
	name = "telecommunications mainframe"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "comm_server"
	desc = "A compact machine used for portable subspace telecommuniations processing."
	density = 1
	anchored = 1
	use_power = POWER_USE_OFF
	idle_power_usage = 0
	produces_heat = 0
	var/intercept = FALSE // if TRUE, broadcasts all messages to syndicate channel
	var/list/listening_freqs = list()


/obj/machinery/telecomms/allinone/Initialize()
	. = ..()

	if(!listening_freqs || intercept)
		listening_freqs = ANTAG_FREQS	//Covers any updates to ANTAG_FREQS

	desc += " It has an effective broadcast range of [overmap_range] grids on the overmap."

/obj/machinery/telecomms/allinone/receive_signal(datum/signal/subspace/signal)
	if(!istype(signal) || signal.transmission_method != TRANSMISSION_SUBSPACE)
		return

	if(!on || !check_service_area(signal.levels) || !is_freq_listening(signal))
		return

	if(!check_receive_sector(signal) && !intercept) //Too far on the overmap to receive. Antag (intercept) don't care about sector checks.
		return

	if(!(signal.frequency in listening_freqs) && !intercept)
		return

	signal.levels = get_service_area()

	// Decompress the signal, mark it received
	signal.data["compression"] = 0
	signal.mark_done()
	if(signal.data["slow"] > 0)
		sleep(signal.data["slow"]) // simulate the network lag if necessary

	signal.broadcast()
/obj/machinery/telecomms/allinone/ship
	listening_freqs = list(SHIP_FREQ)

//This goes on the station map so away ships can maintain radio contact.
//Regular telecomms machines cannot listen to broadcasts coming from non-station z-levels. If we did this, comms would be receiving a substantial amount of duplicated messages.
/obj/machinery/telecomms/allinone/ship/station_relay
	name = "external signal receiver"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "ntnet"
	desc = "This device allows nearby third-party ships to maintain radio contact with their crew that are aboard the %STATIONNAME."
	desc_info = "This device does not need to be linked to other telecommunications equipment; it will receive and broadcast on its own. It only needs to be powered."
	use_power = POWER_USE_IDLE
	idle_power_usage = 25

/obj/machinery/telecomms/allinone/ship/station_relay/Initialize()
	. = ..()
	desc = replacetext(desc, "%STATIONNAME", current_map.station_name)
