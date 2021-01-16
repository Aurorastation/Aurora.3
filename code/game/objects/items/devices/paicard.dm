/obj/item/device/paicard
	name = "personal AI device"
	icon = 'icons/obj/pai.dmi'
	icon_state = "pai"
	item_state = "electronic"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2)
	var/list/installed_encryptionkeys = list()
	var/obj/item/device/radio/radio
	var/looking_for_personality = 0
	var/mob/living/silicon/pai/pai
	var/move_delay = 0

	light_power = 1
	light_range = 1
	light_color = COLOR_BRIGHT_GREEN

/obj/item/device/paicard/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	if(istype(loc, /mob/living/bot))
		if(world.time < move_delay)
			return
		var/mob/living/bot/B = loc
		move_delay = world.time + 1 SECOND
		if(!B.on)
			to_chat(pai, SPAN_WARNING("\The [B] isn't turned on!"))
			return
		step_towards(B, get_step(B, direction))
	var/obj/item/rig/rig = src.get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)

/obj/item/device/paicard/Initialize()
	. = ..()
	add_overlay("pai_off")
	SSpai.all_pai_devices += src
	update_light()

/obj/item/device/paicard/Destroy()
	SSpai.all_pai_devices -= src
	//Will stop people throwing friend pAIs into the singularity so they can respawn
	if(pai)
		pai.death(0)
	return ..()

/obj/item/device/paicard/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/card/id))
		scan_ID(C, user)
		return
	else if(istype(C, /obj/item/device/encryptionkey))
		if(length(installed_encryptionkeys) > 2)
			to_chat(user, SPAN_WARNING("\The [src] already has the full number of possible encryption keys installed!"))
			return
		var/obj/item/device/encryptionkey/EK = C
		var/added_channels = FALSE
		for(var/thing in (EK.channels | EK.additional_channels))
			if(!radio.channels[thing])
				added_channels = TRUE
				break
		if(added_channels)
			installed_encryptionkeys += EK
			user.drop_from_inventory(EK, src)
			user.visible_message("<b>[user]</b> slides \the [EK] into \the [src]'s encryption key slot.", SPAN_NOTICE("You slide \the [EK] into \the [src]'s encryption key slot, granting it access to the radio channels."))
			recalculateChannels()
			if(pai)
				to_chat(pai, SPAN_NOTICE("You now have access to these radio channels: [english_list(radio.channels)]."))
		else
			to_chat(user, SPAN_WARNING("\The [src] would not gain any new channels from \the [EK]."))
		return
	else if(C.isscrewdriver())
		if(!length(installed_encryptionkeys))
			to_chat(user, SPAN_WARNING("There are no installed encryption keys to remove!"))
			return
		user.visible_message("<b>[user]</b> uses \the [C] to pop the encryption key[length(installed_encryptionkeys) > 1 ? "s" : ""] out of \the [src].", SPAN_NOTICE("You use \the [C] to pop the encryption key[length(installed_encryptionkeys) > 1 ? "s" : ""] out of \the [src]."))
		for(var/key in installed_encryptionkeys)
			var/obj/item/device/encryptionkey/EK = key
			EK.forceMove(get_turf(src))
			installed_encryptionkeys -= EK
		recalculateChannels()
		return
	else if(istype(C, /obj/item/stack/nanopaste))
		if(!pai)
			to_chat(user, SPAN_WARNING("You cannot repair a pAI device if there's no active pAI personality installed."))
			return
	pai.attackby(C, user)

/obj/item/device/paicard/proc/recalculateChannels()
	radio.channels = list("Common" = radio.FREQ_LISTENING, "Entertainment" = radio.FREQ_LISTENING)
	for(var/keyslot in installed_encryptionkeys)
		var/obj/item/device/encryptionkey/EK = keyslot
		for(var/ch_name in (EK.channels | EK.additional_channels))
			radio.channels[ch_name] = radio.FREQ_LISTENING

	for(var/ch_name in radio.channels)
		if(!SSradio)
			sleep(30) // Waiting for the SSradio to be created.
		if(!SSradio)
			radio.name = "broken radio headset"
			return
		radio.secure_radio_connections[ch_name] = SSradio.add_object(radio, radiochannels[ch_name], RADIO_CHAT)

//This proc is called when the user scans their ID on the pAI card.
//It registers their ID and copies their access to the pai, allowing it to use airlocks the owner can
//Scanning an ID replaces any previously stored access with the new set.
//Only cards that match the imprinted DNA can be used, it's not a free Agent ID card.
//Possible TODO in future, allow emagging a paicard to let it work like an agent ID, accumulating access from any ID
/obj/item/device/paicard/proc/scan_ID(var/obj/item/card/id/card, var/mob/user)
	if (!pai)
		to_chat(user, "<span class='warning'>Error: ID Registration failed. No pAI personality installed.</span>")
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 20, 0)
		return 0

	if (!pai.master_dna)
		to_chat(user, "<span class='warning'>Error: ID Registration failed. User not registered as owner. Please complete imprinting process first.</span>")
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 20, 0)
		return 0

	if (pai.master_dna != card.dna_hash)
		to_chat(user, "<span class='warning'>Error: ID Registration failed. Biometric data on ID card does not match DNA sample of registered owner.</span>")
		playsound(src.loc, 'sound/machines/buzz-two.ogg', 20, 0)
		return 0

	pai.id_card.access.Cut()
	pai.id_card.access = card.access.Copy()
	pai.id_card.registered_name = card.registered_name
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
	to_chat(user, "<span class='notice'>ID Registration for [pai.id_card.registered_name] is a success. PAI access updated!</span>")
	return 1

/obj/item/device/paicard/proc/ID_readout()
	if (pai.id_card.registered_name)
		return "<span class='notice'>Identity of owner: [pai.id_card.registered_name] registered.</span>"
	else
		return "<span class='warning'>No ID card registered! Please scan your ID to share access.</span>"

/obj/item/device/paicard/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = {"
		<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
		<html>
			<head>
				<style>
					body {
					    margin-top:5px;
					    font-family:Verdana;
					    color:white;
					    font-size:13px;
					    background-image:url('uiBackground.png');
					    background-repeat:repeat-x;
					    background-color:#272727;
						background-position:center top;
					}
					table {
					    font-size:13px;
					    margin-left:-2px;
					}
					table.request {
					    border-collapse:collapse;
					}
					table.desc {
					    border-collapse:collapse;
					    font-size:13px;
					    border: 1px solid #161616;
					    width:100%;
					}
					table.download {
					    border-collapse:collapse;
					    font-size:13px;
					    border: 1px solid #161616;
					    width:100%;
					}
					tr.d0 td, tr.d0 th {
					    background-color: #506070;
					    color: white;
					}
					tr.d1 td, tr.d1 th {
					    background-color: #708090;
					    color: white;
					}
					tr.d2 td {
					    background-color: #00FF00;
					    color: white;
					    text-align:center;
					}
					td.button {
					    border: 1px solid #161616;
					    background-color: #40628a;
					}
					td.button {
					    border: 1px solid #161616;
					    background-color: #40628a;
					    text-align: center;
					}
					td.button_red {
					    border: 1px solid #161616;
					    background-color: #B04040;
					    text-align: center;
					}
					td.download {
					    border: 1px solid #161616;
					    background-color: #40628a;
					    text-align: center;
					}
					th {
					    text-align:left;
					    width:125px;
					}
					td.request {
					    width:140px;
					    vertical-align:top;
					}
					td.radio {
					    width:90px;
					    vertical-align:top;
					}
					td.request {
					    vertical-align:top;
					}
					a {
					    color:#4477E0;
					}
					a.button {
					    color:white;
					    text-decoration: none;
					}
					h2 {
					    font-size:15px;
					}
				</style>
			</head>
			<body>
	"}

	if(pai)
		dat += {"
			<b><font size='3px'>Personal AI Device</font></b><br><br>
			<table class="request">
				<tr>
					<td class="request">Installed Personality:</td>
					<td>[pai.name]</td>
				</tr>
				<tr>
					<td class="request">Prime directive:</td>
					<td>[pai.pai_law0]</td>
				</tr>
				<tr>
					<td class="request">Additional directives:</td>
					<td>[pai.pai_laws]</td>
				</tr>
				<tr>
					<td class="request">ID:</td>
					<td>[ID_readout()]</td>
				</tr>
			</table>
			<br>
		"}
		dat += {"
			<table>
				<td class="button">
					<a href='byond://?src=\ref[src];setlaws=1' class='button'>Configure Directives</a>
				</td>
			</table>
		"}
		if(pai && (!pai.master_dna || !pai.master))
			dat += {"
				<table>
					<td class="button">
						<a href='byond://?src=\ref[src];setdna=1' class='button'>Imprint Master DNA</a>
					</td>
				</table>
			"}
		dat += "<br>"
		if(radio)
			dat += "<b>Radio Uplink</b>"
			dat += {"
				<table class="request">
					<tr>
						<td class="radio">Transmit:</td>
						<td><a href='byond://?src=\ref[src];wires=4'>[radio.broadcasting ? "<font color=#55FF55>En" : "<font color=#FF5555>Dis" ]abled</font></a>

						</td>
					</tr>
					<tr>
						<td class="radio">Receive:</td>
						<td><a href='byond://?src=\ref[src];wires=2'>[radio.listening ? "<font color=#55FF55>En" : "<font color=#FF5555>Dis" ]abled</font></a>

						</td>
					</tr>
				</table>
				<br>
			"}
		else //</font></font>
			dat += "<b>Radio Uplink</b><br>"
			dat += "<font color=red><i>Radio firmware not loaded. Please install a pAI personality to load firmware.</i></font><br>"
		dat += {"
			<table>
				<td class="button_red"><a href='byond://?src=\ref[src];wipe=1' class='button'>Wipe current pAI personality</a>

				</td>
			</table>
		"}
	else
		if(looking_for_personality)
			dat += {"
				<b><font size='3px'>pAI Request Module</font></b><br><br>
				<p>Requesting AI personalities from central database... If there are no entries, or if a suitable entry is not listed, check again later as more personalities may be added.</p>
				<img src='loading.gif' /> Searching for personalities<br><br>

				<table>
					<tr>
						<td class="button">
							<a href='byond://?src=\ref[src];request=1' class="button">Refresh available personalities</a>
						</td>
					</tr>
				</table><br>
			"}
		else
			dat += {"
				<b><font size='3px'>pAI Request Module</font></b><br><br>
			    <p>No personality is installed.</p>
				<table>
					<tr>
						<td class="button"><a href='byond://?src=\ref[src];request=1' class="button">Request personality</a>
						</td>
					</tr>
				</table>
				<br>
				<p>Each time this button is pressed, a request will be sent out to any available personalities. Check back often give plenty of time for personalities to respond. This process could take anywhere from 15 seconds to several minutes, depending on the available personalities' timelines.</p>
			"}
	user << browse(dat, "window=paicard")
	onclose(user, "paicard")
	return

/obj/item/device/paicard/Topic(href, href_list)

	if(!usr || usr.stat)
		return

	if(href_list["setdna"])
		if(pai.master_dna)
			return
		var/mob/M = usr
		if(!istype(M, /mob/living/carbon))
			to_chat(usr, "<font color=blue>You don't have any DNA, or your DNA is incompatible with this device.</font>")
		else
			var/datum/dna/dna = usr.dna
			pai.master = M.real_name
			pai.master_dna = dna.unique_enzymes
			to_chat(pai, "<font color = red><h3>You have been bound to a new master.</h3></font>")
	if(href_list["request"])
		src.looking_for_personality = 1
		SSpai.findPAI(src, usr)
	if(href_list["wipe"])
		var/confirm = input("Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe") in list("Yes", "No")
		if(confirm == "Yes")
			for(var/mob/M in src)
				to_chat(M, "<font color = #ff0000><h2>You feel yourself slipping away from reality.</h2></font>")
				sleep(30)
				to_chat(M, "<font color = #ff4d4d><h3>Byte by byte you lose your sense of self.</h3></font>")
				sleep(20)
				to_chat(M, "<font color = #ff8787><h4>Your mental faculties leave you.</h4></font>")
				sleep(30)
				to_chat(M, "<font color = #ffc4c4><h5>oblivion... </h5></font>")
				M.death(0)
			removePersonality()
	if(href_list["wires"])
		var/t1 = text2num(href_list["wires"])
		switch(t1)
			if(4)
				radio.ToggleBroadcast()
			if(2)
				radio.ToggleReception()
	if(href_list["setlaws"])
		var/newlaws = sanitize(input("Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", pai.pai_laws) as message)
		if(newlaws)
			pai.pai_laws = newlaws
			to_chat(pai, "Your supplemental directives have been updated. Your new directives are:")
			to_chat(pai, "Prime Directive: <br>[pai.pai_law0]")
			to_chat(pai, "Supplemental Directives: <br>[pai.pai_laws]")
	attack_self(usr)

// 		WIRE_SIGNAL = 1
//		WIRE_RECEIVE = 2
//		WIRE_TRANSMIT = 4

/obj/item/device/paicard/proc/setPersonality(mob/living/silicon/pai/personality)
	src.pai = personality
	add_overlay("pai-happy")

/obj/item/device/paicard/proc/removePersonality()
	src.pai = null
	cut_overlays()
	add_overlay("pai-off")

/obj/item/device/paicard
	var/current_emotion = 1
/obj/item/device/paicard/proc/setEmotion(var/emotion)
	if(pai)
		cut_overlays()
		var/new_state
		switch(emotion)
			if(1) new_state = "pai-happy"
			if(2) new_state = "pai-cat"
			if(3) new_state = "pai-extremely-happy"
			if(4) new_state = "pai-face"
			if(5) new_state = "pai-laugh"
			if(6) new_state = "pai-off"
			if(7) new_state = "pai-sad"
			if(8) new_state = "pai-angry"
			if(9) new_state = "pai-what"
			if(10) new_state = "pai-neutral"
			if(11) new_state = "pai-silly"
			if(12) new_state = "pai-nose"
			if(13) new_state = "pai-smirk"
			if(14) new_state = "pai-exclamation"
			if(15) new_state = "pai-question"
		if (new_state)
			add_overlay(new_state)
		current_emotion = emotion

/obj/item/device/paicard/proc/alertUpdate()
	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("<span class='notice'>\The [src] flashes a message across its screen, \"Additional personalities available for download.\"</span>", 3, "<span class='notice'>\The [src] bleeps electronically.</span>", 2)

/obj/item/device/paicard/emp_act(severity)
	for(var/mob/M in src)
		M.emp_act(severity)

/obj/item/device/paicard/ex_act(severity)
	if(pai)
		pai.ex_act(severity)
	else
		qdel(src)

/obj/item/device/paicard/see_emote(mob/living/M, text)
	if(pai && pai.client && !pai.canmove)
		var/rendered = "<span class='message'>[text]</span>"
		pai.show_message(rendered, 2)
	..()

/obj/item/device/paicard/dropped(mob/user)

	///When an object is put into a container, drop fires twice.
	//once with it on the floor, and then once in the container
	//We only care about the second one
	if (istype(loc, /obj/item/storage))	//The second drop reads the container its placed into as the location
		update_location()


/obj/item/device/paicard/equipped(var/mob/user, var/slot)
	..()
	update_location(slot)

/obj/item/device/paicard/proc/update_location(var/slotnumber = null)
	if (!pai)
		return

	if (!slotnumber)
		if (istype(loc, /mob))
			slotnumber = get_equip_slot()

	report_onmob_location(1, slotnumber, pai)

/obj/item/device/paicard/show_message(msg, type, alt, alt_type)
	if(pai && pai.client)
		var/rendered = "<span class='message'>[msg]</span>"
		pai.show_message(rendered, type)
	..()
