#define MESSAGE_SERVER_SPAM_REJECT 1
#define MESSAGE_SERVER_DEFAULT_SPAM_LIMIT 10

// Log datums stored by the message server.
/datum/data_pda_msg
	var/sender = "Unspecified"
	var/recipient = "Unspecified"
	var/message = "Blank"  // transferred message
	var/icon/photo  // attached photo

/datum/data_pda_msg/New(param_rec, param_sender, param_message, param_photo)
	if(param_rec)
		recipient = param_rec
	if(param_sender)
		sender = param_sender
	if(param_message)
		message = param_message
	if(param_photo)
		photo = param_photo

/datum/data_pda_msg/proc/get_photo_ref()
	if(photo)
		return "<a href='byond://?src=["\ref[src]"];photo=1'>(Photo)</a>"
	return ""

/datum/data_pda_msg/Topic(href,href_list)
	..()
	if(href_list["photo"])
		var/mob/M = usr
		M << browse_rsc(photo, "pda_photo.png")
		M << browse("<html><head><title>PDA Photo</title></head>" \
		+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
		+ "<img src='pda_photo.png' width='192' style='-ms-interpolation-mode:nearest-neighbor' />" \
		+ "</body></html>", "window=pdaphoto;size=192x192")
		onclose(M, "pdaphoto")

/datum/data_rc_msg
	var/rec_dpt = "Unspecified"  // receiving department
	var/send_dpt = "Unspecified"  // sending department
	var/message = "Blank"
	var/stamp = "Unstamped"
	var/id_auth = "Unauthenticated"
	var/priority = "Normal"

/datum/data_rc_msg/New(param_rec, param_sender, param_message, param_stamp, param_id_auth, param_priority)
	if(param_rec)
		rec_dpt = param_rec
	if(param_sender)
		send_dpt = param_sender
	if(param_message)
		message = param_message
	if(param_stamp)
		stamp = param_stamp
	if(param_id_auth)
		id_auth = param_id_auth
	if(param_priority)
		switch(param_priority)
			if(1)
				priority = "Normal"
			if(2)
				priority = "High"
			if(3)
				priority = "Extreme"
			else
				priority = "Undetermined"

/obj/machinery/telecomms/message_server
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"
	name = "messaging server"
	desc = "A machine that processes and routes request console messages."
	telecomms_type = /obj/machinery/telecomms/message_server
	density = TRUE
	anchored = TRUE
	idle_power_usage = 10
	active_power_usage = 100

	var/list/datum/data_pda_msg/pda_msgs = list() // TODO: actually re-link modular PDAs to the message servers
	var/list/datum/data_rc_msg/rc_msgs = list()
	var/decryptkey = "password"

	//Spam filtering stuff
	var/list/spamfilter = list("You have won", "your prize", "male enhancement", "shitcurity", \
			"are happy to inform you", "account number", "enter your PIN")
			//Messages having theese tokens will be rejected by server. Case sensitive
	var/spamfilter_limit = MESSAGE_SERVER_DEFAULT_SPAM_LIMIT	//Maximal amount of tokens

/obj/machinery/telecomms/message_server/Initialize()
	. = ..()
	if(!decryptkey)
		decryptkey = GenerateKey()
	// send_pda_message("System Administrator", "system", "This is an automated message. The messaging system is functioning correctly.")

/obj/machinery/telecomms/message_server/proc/GenerateKey()
	//Feel free to move to Helpers.
	var/newKey
	newKey += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newKey += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "big", "escape", "yellow", "gloves", "monkey", "engine", "nuclear", "ai")
	newKey += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return newKey

/obj/machinery/telecomms/message_server/process()
	//if(decryptkey == "password")
	//	decryptkey = generateKey()
	if(toggled && (stat & (BROKEN|NOPOWER)))
		toggled = FALSE
	update_icon()

/obj/machinery/telecomms/message_server/receive_information(datum/signal/subspace/pda/signal, obj/machinery/telecomms/machine_from)
	// can't log non-PDA signals
	if(!istype(signal) || !signal.data["message"] || !toggled)
		return

	// log the signal
	pda_msgs += new /datum/data_pda_msg(signal.format_target(), "[signal.data["name"]] ([signal.data["job"]])", signal.data["message"], signal.data["photo"])
	signal.data -= "reject"  // only gets through if it's logged

	// pass it along to either the hub or the broadcaster
	if(!relay_information(signal, /obj/machinery/telecomms/hub))
		relay_information(signal, /obj/machinery/telecomms/broadcaster)

/obj/machinery/telecomms/message_server/proc/send_rc_message(var/recipient = "",var/sender = "",var/message = "",var/stamp = "", var/id_auth = "", var/priority = 1)
	rc_msgs += new/datum/data_rc_msg(recipient,sender,message,stamp,id_auth)
	var/authmsg = "[message]<br>"
	if (id_auth)
		authmsg += "[id_auth]<br>"
	if (stamp)
		authmsg += "[stamp]<br>"
	for (var/obj/machinery/requests_console/Console in allConsoles)
		if (ckey(Console.department) == ckey(recipient))
			if(Console.inoperable())
				Console.message_log += "<B>Message lost due to console failure.</B><BR>Please contact [station_name()] system adminsitrator or AI for technical assistance.<BR>"
				continue
			if(Console.newmessagepriority < priority)
				Console.newmessagepriority = priority
				Console.icon_state = "req_comp[priority]"
			switch(priority)
				if(2)
					if(!Console.silent)
						playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
						Console.audible_message(text("[icon2html(Console, viewers(get_turf(Console)))] *The Requests Console beeps: 'PRIORITY Alert in [sender]'"),,5)
					Console.message_log += "<B><span class='warning'>High Priority message from <A href='?src=\ref[Console];write=[sender]'>[sender]</A></span></B><BR>[authmsg]"
					for(var/obj/item/modular_computer/pda in Console.alert_pdas)
						var/pda_message = "A high priority message has arrived!"
						pda.get_notification(pda_message, 1, "[Console.department] Requests Console")
				else
					if(!Console.silent)
						playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
						Console.audible_message(text("[icon2html(Console, viewers(get_turf(Console)))] *The Requests Console beeps: 'Message from [sender]'"),,4)
					Console.message_log += "<B>Message from <A href='?src=\ref[Console];write=[sender]'>[sender]</A></B><BR>[authmsg]"
					for(var/obj/item/modular_computer/pda in Console.alert_pdas)
						var/pda_message = "A message has arrived!"
						pda.get_notification(pda_message, 1, "[Console.department] Requests Console")
			Console.set_light(2)


/obj/machinery/telecomms/message_server/attack_hand(user as mob)
//	to_chat(user, "\blue There seem to be some parts missing from this server. They should arrive on the station in a few days, give or take a few CentCom delays.")
	to_chat(user, "You toggle request console message passing from [toggled ? "On" : "Off"] to [toggled ? "Off" : "On"]")
	toggled = !toggled
	update_icon()

	return

/obj/machinery/telecomms/message_server/attackby(obj/item/O as obj, mob/living/user as mob)
	if (toggled && !(stat & (BROKEN|NOPOWER)) && (spamfilter_limit < MESSAGE_SERVER_DEFAULT_SPAM_LIMIT*2) && \
		istype(O,/obj/item/circuitboard/message_monitor))
		spamfilter_limit += round(MESSAGE_SERVER_DEFAULT_SPAM_LIMIT / 2)
		user.drop_from_inventory(O,get_turf(src))
		qdel(O)
		to_chat(user, "You install additional memory and processors into message server. Its filtering capabilities been enhanced.")
	else
		..(O, user)

/obj/machinery/telecomms/message_server/update_icon()
	if((stat & (BROKEN|NOPOWER)))
		icon_state = "server-nopower"
	else if (!toggled)
		icon_state = "server-off"
	else
		icon_state = "server-on"

/datum/signal/subspace/pda
	frequency = PUB_FREQ
	server_type = /obj/machinery/telecomms/message_server

/datum/signal/subspace/pda/New(source, data)
	src.source = source
	src.data = data
	var/turf/T = get_turf(source)
	levels = list(T.z)
	data["reject"] = TRUE  // set to FALSE if a messaging server logs it

/datum/signal/subspace/pda/copy()
	var/datum/signal/subspace/pda/copy = new(source, data.Copy())
	copy.original = src
	copy.levels = levels
	return copy

/datum/signal/subspace/pda/proc/format_target()
	if (length(data["targets"]) > 1)
		return "Everyone"
	return data["targets"][1]

/datum/signal/subspace/pda/proc/format_message()
	if (data["photo"])
		return "[data["message"]] <a href='byond://?src=["\ref[src]"];photo=1'>(Photo)</a>"
	return data["message"]

/datum/signal/subspace/pda/broadcast()
	// TODO: need an iterable list of available PDAs
	// for (var/obj/item/modular_computer in SSmachinery.machinery)
	// 	if ("[P.owner] ([P.ownjob])" in data["targets"])
	// 		P.receive_message(src)

/datum/signal/subspace/pda/Topic(href, href_list)
	..()
	if (href_list["photo"])
		var/mob/M = usr
		M << browse_rsc(data["photo"], "pda_photo.png")
		M << browse("<html><head><title>PDA Photo</title></head>" \
		+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
		+ "<img src='pda_photo.png' width='192' style='-ms-interpolation-mode:nearest-neighbor' />" \
		+ "</body></html>", "window=pdaphoto;size=192x192")
		onclose(M, "pdaphoto")

var/obj/machinery/blackbox_recorder/blackbox

/obj/machinery/blackbox_recorder
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "blackbox"
	name = "blackbox recorder"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 10
	active_power_usage = 100

	// Note: actual logging has been moved to SSfeedback.

	//Only one can exist in the world!
/obj/machinery/blackbox_recorder/Initialize()
	. = ..()
	if(blackbox)
		if(istype(blackbox,/obj/machinery/blackbox_recorder))
			qdel(src)
	blackbox = src

/obj/machinery/blackbox_recorder/Destroy()
	feedback_set_details("blackbox_destroyed","true")
	feedback_set("blackbox_destroyed",1)
	return ..()
