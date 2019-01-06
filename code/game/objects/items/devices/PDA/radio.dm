/obj/item/radio/integrated
	name = "\improper PDA radio module"
	desc = "An electronic radio system."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	var/obj/item/device/pda/hostpda = null

	var/on = 0 //Are we currently active??
	var/menu_message = ""

/obj/item/radio/integrated/Initialize()
	. = ..()
	if (istype(loc.loc, /obj/item/device/pda))
		hostpda = loc.loc

/obj/item/radio/integrated/Destroy()
	hostpda = null
	return ..()

/obj/item/radio/integrated/proc/post_signal(var/freq, var/key, var/value, var/key2, var/value2, var/key3, var/value3, s_filter)
	var/datum/radio_frequency/frequency = SSradio.return_frequency(freq)

	if(!frequency) return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = 1
	signal.data[key] = value
	if(key2)
		signal.data[key2] = value2
	if(key3)
		signal.data[key3] = value3

	frequency.post_signal(src, signal, filter = s_filter)

	return

/obj/item/radio/integrated/proc/generate_menu()

/obj/item/radio/integrated/beepsky
	var/list/botlist = null		// list of bots
	var/mob/living/bot/secbot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot

	var/control_freq = BOT_FREQ

	// create a new QM cartridge, and register to receive bot control & beacon message
/obj/item/radio/integrated/beepsky/Initialize()
	. = ..()
	SSradio.add_object(src, control_freq, filter = RADIO_SECBOT)

	// receive radio signals
	// can detect bot status signals
	// create/populate list as they are recvd

/obj/item/radio/integrated/beepsky/receive_signal(datum/signal/signal)
	if (signal.data["type"] == "secbot")
		if(!botlist)
			botlist = new()

		if(!(signal.source in botlist))
			botlist += signal.source

		if(active == signal.source)
			var/list/b = signal.data
			botstatus = b.Copy()

/obj/item/radio/integrated/beepsky/Topic(href, href_list)
	..()
	var/obj/item/device/pda/PDA = src.hostpda

	switch(href_list["op"])

		if("control")
			active = locate(href_list["bot"])
			post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

		if("scanbots")		// find all bots
			botlist = null
			post_signal(control_freq, "command", "bot_status", s_filter = RADIO_SECBOT)

		if("botlist")
			active = null

		if("stop", "go")
			post_signal(control_freq, "command", href_list["op"], "active", active, s_filter = RADIO_SECBOT)
			post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

		if("summon")
			post_signal(control_freq, "command", "summon", "active", active, "target", get_turf(PDA) , s_filter = RADIO_SECBOT)
			post_signal(control_freq, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)


/obj/item/radio/integrated/beepsky/Destroy()
	SSradio.remove_object(src, control_freq)
	return ..()

/obj/item/radio/integrated/mule
	var/list/botlist = null		// list of bots
	var/obj/machinery/bot/mulebot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot
	var/list/beacons

	var/beacon_freq = 1400
	var/control_freq = BOT_FREQ

	// create a new QM cartridge, and register to receive bot control & beacon message
/obj/item/radio/integrated/mule/Initialize()
	..()
	SSradio.add_object(src, control_freq, filter = RADIO_MULEBOT)
	SSradio.add_object(src, beacon_freq, filter = RADIO_NAVBEACONS)
	return INITIALIZE_HINT_LATELOAD

/obj/item/radio/integrated/mule/LateInitialize()
	post_signal(beacon_freq, "findbeacon", "delivery", s_filter = RADIO_NAVBEACONS)

/obj/item/radio/integrated/mule/Destroy()
	SSradio.remove_object(src, control_freq)
	SSradio.remove_object(src, beacon_freq)
	return ..()

	// receive radio signals
	// can detect bot status signals
	// and beacon locations
	// create/populate lists as they are recvd

/obj/item/radio/integrated/mule/receive_signal(datum/signal/signal)
	if(signal.data["type"] == "mulebot")
		if(!botlist)
			botlist = new()

		if(!(signal.source in botlist))
			botlist += signal.source

		if(active == signal.source)
			var/list/b = signal.data
			botstatus = b.Copy()

	else if(signal.data["beacon"])
		if(!beacons)
			beacons = new()

		beacons[signal.data["beacon"] ] = signal.source


//		if(istype(P)) P.updateSelfDialog()

/obj/item/radio/integrated/mule/Topic(href, href_list)
	..()
	var/cmd = "command"
	if(active) cmd = "command [active.suffix]"

	switch(href_list["op"])

		if("control")
			active = locate(href_list["bot"])
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

		if("scanbots")		// find all bots
			botlist = null
			post_signal(control_freq, "command", "bot_status", s_filter = RADIO_MULEBOT)

		if("botlist")
			active = null


		if("unload")
			post_signal(control_freq, cmd, "unload", s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)
		if("setdest")
			if(beacons)
				var/dest = input("Select Bot Destination", "Mulebot [active.suffix] Interlink", active.destination) as null|anything in beacons
				if(dest)
					post_signal(control_freq, cmd, "target", "destination", dest, s_filter = RADIO_MULEBOT)
					post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

		if("retoff")
			post_signal(control_freq, cmd, "autoret", "value", 0, s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)
		if("reton")
			post_signal(control_freq, cmd, "autoret", "value", 1, s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

		if("pickoff")
			post_signal(control_freq, cmd, "autopick", "value", 0, s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)
		if("pickon")
			post_signal(control_freq, cmd, "autopick", "value", 1, s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)

		if("stop", "go", "home")
			post_signal(control_freq, cmd, href_list["op"], s_filter = RADIO_MULEBOT)
			post_signal(control_freq, cmd, "bot_status", s_filter = RADIO_MULEBOT)



/*
 *	Radio Cartridge, essentially a signaler.
 */


/obj/item/radio/integrated/signal
	var/frequency = 1457
	var/code = 30.0
	var/last_transmission
	var/datum/radio_frequency/radio_connection

/obj/item/radio/integrated/signal/Initialize()
	. = ..()
	if(!SSradio)
		return

	if (src.frequency < PUBLIC_LOW_FREQ || src.frequency > PUBLIC_HIGH_FREQ)
		src.frequency = sanitize_frequency(src.frequency)

	set_frequency(frequency)

/obj/item/radio/integrated/signal/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency)

/obj/item/radio/integrated/signal/proc/send_signal(message="ACTIVATE")
	if(last_transmission && world.time < (last_transmission + 5))
		return
	last_transmission = world.time

	var/time = time2text(world.realtime,"hh:mm:ss")
	var/turf/T = get_turf(src)
	lastsignalers.Add("[time] <B>:</B> [usr.key] used [src] @ location ([T.x],[T.y],[T.z]) <B>:</B> [format_frequency(frequency)]/[code]")

	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = message

	radio_connection.post_signal(src, signal)

/obj/item/radio/integrated/signal/Destroy()
	SSradio.remove_object(src, frequency)
	return ..()
