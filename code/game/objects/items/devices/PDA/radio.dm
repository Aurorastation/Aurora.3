/obj/item/integrated_signaler
	name = "\improper PDA radio module"
	desc = "An electronic radio system."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	var/obj/item/modular_computer/hostpda = null

	var/on = 0 //Are we currently active??
	var/menu_message = ""

/obj/item/integrated_signaler/Initialize()
	. = ..()
	if (istype(loc.loc, /obj/item/modular_computer))
		hostpda = loc.loc

/obj/item/integrated_signaler/Destroy()
	hostpda = null
	return ..()

/obj/item/integrated_signaler/proc/post_signal(var/freq, var/key, var/value, var/key2, var/value2, var/key3, var/value3, s_filter)
	var/datum/radio_frequency/frequency = SSradio.return_frequency(freq)

	if(!frequency) return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = TRANSMISSION_RADIO
	signal.data[key] = value
	if(key2)
		signal.data[key2] = value2
	if(key3)
		signal.data[key3] = value3

	frequency.post_signal(src, signal, filter = s_filter)

	return

/*
 * Radio Cartridge, essentially a signaler.
 */


/obj/item/integrated_signaler/signal
	var/frequency = 1457
	var/code = 30.0
	var/last_transmission
	var/listening = TRUE
	var/datum/radio_frequency/radio_connection

/obj/item/integrated_signaler/signal/network_card
	listening = FALSE

/obj/item/integrated_signaler/signal/Initialize()
	. = ..()
	if(!SSradio)
		return

	if (src.frequency < PUBLIC_LOW_FREQ || src.frequency > PUBLIC_HIGH_FREQ)
		src.frequency = sanitize_frequency(src.frequency)

	set_frequency(frequency)

/obj/item/integrated_signaler/signal/proc/set_frequency(new_frequency)
	if(!SSradio || !new_frequency)
		return FALSE
	var/sanitized_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
	if(sanitized_frequency > RADIO_HIGH_FREQ)
		sanitized_frequency = RADIO_HIGH_FREQ - 1
	if(radio_connection && frequency == sanitized_frequency)
		return TRUE
	if(radio_connection)
		SSradio.remove_object(src, frequency)
	frequency = sanitized_frequency
	if(listening)
		radio_connection = SSradio.add_object(src, frequency)
	else
		radio_connection = null
	return TRUE

/obj/item/integrated_signaler/signal/proc/set_listening(var/new_listening)
	new_listening = !!new_listening
	if(listening == new_listening)
		return TRUE

	listening = new_listening
	if(listening)
		return set_frequency(frequency)

	if(radio_connection)
		SSradio.remove_object(src, frequency)
	radio_connection = null
	return TRUE

/obj/item/integrated_signaler/signal/proc/send_signal(message="ACTIVATE", var/mob/user)
	if(!SSradio)
		return FALSE
	var/datum/radio_frequency/transmit_connection = radio_connection
	if(!transmit_connection)
		transmit_connection = SSradio.return_frequency(frequency)
	if(!transmit_connection)
		return FALSE
	if(within_jamming_range(src))
		return FALSE
	if(last_transmission && world.time < (last_transmission + 5))
		return FALSE
	last_transmission = world.time

	var/time = time2text(world.realtime,"hh:mm:ss")
	var/turf/T = get_turf(src)
	var/user_key = user ? user.key : usr?.key
	GLOB.lastsignalers.Add("[time] <B>:</B> [user_key ? user_key : "userless"] used [src] @ location ([T ? T.x : 0],[T ? T.y : 0],[T ? T.z : 0]) <B>:</B> [format_frequency(frequency)]/[code]")

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = message
	if(user)
		signal.data["user"] = WEAKREF(user)

	transmit_connection.post_signal(src, signal)
	return TRUE

/obj/item/integrated_signaler/signal/receive_signal(var/datum/signal/signal)
	if(!signal)
		return FALSE
	if(signal.source == src)
		return FALSE
	if(signal.data["message"] != "ACTIVATE")
		return FALSE
	if(isnull(signal.encryption))
		return FALSE
	if(within_jamming_range(src))
		return FALSE

	var/obj/item/computer_hardware/network_card/network_card = loc
	if(istype(network_card))
		return network_card.receive_signaler_signal(src, signal)
	return FALSE

/obj/item/integrated_signaler/signal/Destroy()
	if(SSradio)
		SSradio.remove_object(src, frequency)
	return ..()
