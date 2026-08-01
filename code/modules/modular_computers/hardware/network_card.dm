GLOBAL_VAR_INIT(ntnet_card_uid, 1)

/obj/item/computer_hardware/network_card
	name = "basic NTNet network card"
	desc = "A basic network card for usage with standard NTNet frequencies."
	power_usage = 25
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	critical = FALSE
	icon_state = "netcard_basic"
	hardware_size = 1
	var/identification_id			// Identification ID. Technically MAC address of this device. Can't be changed by user.
	var/identification_string = ""	// Identification string, technically nickname seen in the network. Can be set by user.
	var/long_range = FALSE
	var/ethernet = FALSE // Hard-wired, therefore always on, ignores NTNet wireless checks.
	var/obj/item/integrated_signaler/signal/sradio = FALSE // integrated signaler - not present on basic model.
	var/obj/item/integrated_signaler/signal/secondary_sradio = FALSE // second receiver for NTOS signaler software.
	var/obj/item/integrated_signaler/signal/transmit_sradio = FALSE // transmitter for NTOS signaler software.
	malfunction_probability = 1

/obj/item/computer_hardware/network_card/diagnostics(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("NIX Unique ID: [identification_id]"))
	to_chat(user, SPAN_NOTICE("NIX User Tag: [identification_string]"))
	to_chat(user, SPAN_NOTICE("Supported protocols:"))
	to_chat(user, SPAN_NOTICE("511.m SFS (Subspace) - Standard Frequency Spread"))
	if(sradio)
		to_chat(user, SPAN_NOTICE("511.s WFS (Subspace) - Wide Frequency Spread / Signaling"))
	if(long_range)
		to_chat(user, SPAN_NOTICE("511.n HB (Subspace) - High Bandwidth / Long Range"))
	if(ethernet)
		to_chat(user, SPAN_NOTICE("OpenEth (Physical Connection) - Physical Network Connection Port"))

/obj/item/computer_hardware/network_card/Initialize()
	. = ..()
	identification_id = GLOB.ntnet_card_uid
	GLOB.ntnet_card_uid++

/obj/item/computer_hardware/network_card/signaler
	name = "NTNet signaler network card"
	desc = "An upgraded version of the basic network card, capable of transmitting and receiving over NTNet as well as custom frequencies."
	power_usage = 75
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 1)

/obj/item/computer_hardware/network_card/signaler/Initialize()
	. = ..()
	initialize_signaler_radios()

/obj/item/computer_hardware/network_card/advanced
	name = "advanced NTNet network card"
	desc = "An advanced network card for usage with standard NTNet frequencies. Its transmitter is strong enough to connect even off-station."
	long_range = TRUE
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	power_usage = 150 // Better range but higher power usage.
	icon_state = "netcard_advanced"
	hardware_size = 2

/obj/item/computer_hardware/network_card/advanced/Initialize()
	. = ..()
	initialize_signaler_radios()

/obj/item/computer_hardware/network_card/wired
	name = "wired NTNet network card"
	desc = "An advanced network card for usage with standard NTNet frequencies. This one also supports wired connection."
	ethernet = TRUE
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	power_usage = 150 // Better range but higher power usage.
	icon_state = "netcard_ethernet"
	hardware_size = 3

/obj/item/computer_hardware/network_card/wired/Initialize()
	. = ..()
	initialize_signaler_radios()

/obj/item/computer_hardware/network_card/proc/initialize_signaler_radios()
	if(!sradio)
		sradio = new /obj/item/integrated_signaler/signal/network_card(src)
	sradio.set_listening(FALSE)
	if(!secondary_sradio)
		secondary_sradio = new /obj/item/integrated_signaler/signal/network_card(src)
	secondary_sradio.set_listening(FALSE)
	if(!transmit_sradio)
		transmit_sradio = new /obj/item/integrated_signaler/signal/network_card(src)
	transmit_sradio.set_listening(FALSE)

/obj/item/computer_hardware/network_card/proc/get_signaler_radio(var/channel = 1)
	if(channel == 0)
		return transmit_sradio
	if(channel == 2)
		return secondary_sradio
	return sradio

/obj/item/computer_hardware/network_card/proc/receive_signaler_signal(var/obj/item/integrated_signaler/signal/receiver, var/datum/signal/signal)
	if(!parent_computer || !parent_computer.enabled || !enabled || !check_functionality())
		return FALSE

	var/channel
	if(receiver == sradio)
		channel = 1
	else if(receiver == secondary_sradio)
		channel = 2
	else
		return FALSE

	if(istype(parent_computer.active_program, /datum/computer_file/program/signaler))
		var/datum/computer_file/program/signaler/active_signaler = parent_computer.active_program
		active_signaler.receive_signal(channel, signal)

	for(var/datum/computer_file/program/signaler/signaler_program in parent_computer.idle_threads)
		signaler_program.receive_signal(channel, signal)

	return TRUE

// Returns a string identifier of this network card
/obj/item/computer_hardware/network_card/proc/get_network_tag()
	return "[identification_string] (NID [identification_id])"

// 0 - No signal, 1 - Low signal, 2 - High signal. 3 - Wired Connection
/obj/item/computer_hardware/network_card/proc/get_signal(var/specific_action = 0)
	if(!parent_computer) // Hardware is not installed in anything. No signal. How did this even get called?
		return 0
	if(!enabled)
		return 0
	if(!check_functionality())
		return 0
	if(!GLOB.ntnet_global || !GLOB.ntnet_global.check_function(specific_action))
		return 0

	if(parent_computer)
		var/turf/T = get_turf(parent_computer)
		if((T && istype(T)) && is_station_level(T.z))
			// Computer is on station. Low/High signal depending on what type of network card you have
			if(ethernet)
				return 3
			else if(long_range)
				return 2
			else
				return 1
		var/area/A = get_area(parent_computer)
		if(A.centcomm_area && ethernet)
			return 3

	if(long_range) // Computer is not on station, but it has upgraded network card. Low signal.
		return 1

	return 0 // Computer is not on station and does not have upgraded network card. No signal.

/obj/item/computer_hardware/network_card/Destroy()
	if(sradio)
		QDEL_NULL(sradio)
	if(secondary_sradio)
		QDEL_NULL(secondary_sradio)
	if(transmit_sradio)
		QDEL_NULL(transmit_sradio)
	if(parent_computer?.network_card == src)
		parent_computer.network_card = null
	parent_computer = null
	return ..()
