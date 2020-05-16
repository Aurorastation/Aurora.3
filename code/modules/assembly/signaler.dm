/obj/item/device/assembly/signaler
	name = "remote signaling device"
	desc = "Used to remotely activate devices."
	icon_state = "signaller"
	item_state = "signaler"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 200)
	wires = WIRE_RECEIVE | WIRE_PULSE | WIRE_RADIO_PULSE | WIRE_RADIO_RECEIVE

	secured = 1

	var/code = 30
	var/frequency = 1457
	var/delay = 0
	var/airlock_wire
	var/obj/machinery/machine
	var/datum/wires/connected
	var/datum/radio_frequency/radio_connection
	var/deadman = 0

/obj/item/device/assembly/signaler/Initialize()
	. = ..()
	set_frequency(frequency)

/obj/item/device/assembly/signaler/activate()
	if(cooldown > 0)	return 0
	cooldown = 2
	addtimer(CALLBACK(src, .proc/process_cooldown), 10)

	signal()
	return 1

/obj/item/device/assembly/signaler/update_icon()
	if(holder)
		holder.update_icon()
	return

/obj/item/device/assembly/signaler/interact(mob/user as mob, flag1)
	var/t1 = "-------"
//		if ((src.b_stat && !( flag1 )))
//			t1 = text("-------<BR>\nGreen Wire: []<BR>\nRed Wire:   []<BR>\nBlue Wire:  []<BR>\n", (src.wires & 4 ? text("<A href='?src=\ref[];wires=4'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=4'>Mend Wire</A>", src)), (src.wires & 2 ? text("<A href='?src=\ref[];wires=2'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=2'>Mend Wire</A>", src)), (src.wires & 1 ? text("<A href='?src=\ref[];wires=1'>Cut Wire</A>", src) : text("<A href='?src=\ref[];wires=1'>Mend Wire</A>", src)))
//		else
//			t1 = "-------"	Speaker: [src.listening ? "<A href='byond://?src=\ref[src];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src];listen=1'>Disengaged</A>"]<BR>
	var/dat = {"
	<TT>

	<A href='byond://?src=\ref[src];send=1'>Send Signal</A><BR>
	<B>Frequency/Code</B> for signaler:<BR>
	Frequency:
	<A href='byond://?src=\ref[src];freq=-10'>-</A>
	<A href='byond://?src=\ref[src];freq=-2'>-</A>
	[format_frequency(src.frequency)]
	<A href='byond://?src=\ref[src];freq=2'>+</A>
	<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

	Code:
	<A href='byond://?src=\ref[src];code=-5'>-</A>
	<A href='byond://?src=\ref[src];code=-1'>-</A>
	[src.code]
	<A href='byond://?src=\ref[src];code=1'>+</A>
	<A href='byond://?src=\ref[src];code=5'>+</A><BR>
	[t1]
	</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return


/obj/item/device/assembly/signaler/Topic(href, href_list)
	..()

	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=radio")
		onclose(usr, "radio")
		return

	if (href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if(new_frequency < RADIO_LOW_FREQ || new_frequency > RADIO_HIGH_FREQ)
			new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
		set_frequency(new_frequency)

	if(href_list["code"])
		src.code += text2num(href_list["code"])
		src.code = round(src.code)
		src.code = min(100, src.code)
		src.code = max(1, src.code)

	if(href_list["send"])
		spawn( 0 )
			signal()

	if(usr)
		attack_self(usr)

	return


/obj/item/device/assembly/signaler/proc/signal()
	if(!radio_connection)
		return
	if(within_jamming_range(src))
		return
	var/datum/signal/signal = new
	signal.source = src
	signal.encryption = code
	signal.data["message"] = "ACTIVATE"
	radio_connection.post_signal(src, signal)
	return


/obj/item/device/assembly/signaler/pulse(var/radio = 0)
	if(src.connected && src.wires)
		connected.Pulse(src)
	else if(holder)
		holder.process_activation(src, 1, 0)
	else if(machine)
		machine.do_signaler()
	else
		..(radio)
	return 1


/obj/item/device/assembly/signaler/receive_signal(datum/signal/signal)
	if(!signal)
		return 0

	if(within_jamming_range(src))
		return 0

	if(signal.encryption != code)
		return 0

	if(!(src.wires & WIRE_RADIO_RECEIVE))
		return 0

	pulse(1)

	if(machine)
		machine.visible_message("\icon[machine] [capitalize_first_letters(src.name)] beeps, \"<b>Beep beep!</b>\"")
	else if(!holder)
		visible_message("\icon[src] [capitalize_first_letters(src.name)] beeps, \"<b>Beep beep!</b>\"")
	return


/obj/item/device/assembly/signaler/proc/set_frequency(new_frequency)
	if(!frequency)
		return
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_CHAT)
	return

//Triggers the deadmanswitch if its dropped or moved into ones backpack
/obj/item/device/assembly/signaler/dropped(var/mob/user)
	. = ..()
	if(deadman)
		if(!user.client)
			deadman_deactivate(user) //To deactivate the deadman if someone disconnects
		else
			deadman_trigger(user)

//Triggers the deadmanswitch if its moved between slots (i.e. from hand into the pocket)
/obj/item/device/assembly/signaler/on_slotmove(var/mob/user)
	. = ..()
	if(deadman)
		deadman_trigger(user)

/obj/item/device/assembly/signaler/process()
	//If we have disabled the deadmanswitch. stop here
	if(!deadman)
		STOP_PROCESSING(SSprocessing, src)
		return
	//That there is just a fallback in case dropped is not being called
	var/mob/M = src.loc
	if(!ismob(M))
		deadman_trigger()
	else if(prob(20))
		M.visible_message("[M]'s finger twitches a bit over [src]'s deadman switch!")
	return

/obj/item/device/assembly/signaler/proc/deadman_trigger(var/mob/user)
	if(deadman) //If its not activated, there is no point in triggering it
		if(user)
			src.visible_message("<span class='warning'>[user] releases [src]'s deadman switch!</span>")
		else
			src.visible_message("<span class='warning'>[src]'s deadman switch is released!</span>")
		signal()
		deadman = 0
		STOP_PROCESSING(SSprocessing, src)

/obj/item/device/assembly/signaler/verb/deadman_it()
	set src in usr
	set name = "Hold the deadman switch!"
	set desc = "Sends a signal if dropped or moved into a container."
	if(!deadman)
		deadman_activate(usr)
	else
		deadman_deactivate(usr)


/obj/item/device/assembly/signaler/proc/deadman_activate(var/mob/user)
	deadman = 1
	START_PROCESSING(SSprocessing, src)
	log_and_message_admins("is threatening to trigger a signaler deadman's switch")
	user.visible_message("<span class='warning'>[user] presses and holds [src]'s deadman switch...</span>")
	to_chat(user,"<span class='warning'>Your are now holding [src]'s deadman switch. Dropping, putting the device away, or being hit will activate the signaller.</span>")
	to_chat(user,"<span class='critical'>To deactivate it, make sure to press the verb again.</span>")

/obj/item/device/assembly/signaler/proc/deadman_deactivate(var/mob/user)
	deadman = 0
	STOP_PROCESSING(SSprocessing, src)
	user.visible_message("<span class='warning'>[user] secures [user]'s deadman switch...</span>")

/obj/item/device/assembly/signaler/Destroy()
	if(SSradio)
		SSradio.remove_object(src,frequency)
	frequency = 0
	return ..()
