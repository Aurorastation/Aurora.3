/obj/item/device/holowarrant
	name = "warrant projector"
	desc = "The practical paperwork replacement for the officer on the go."
	icon_state = "holowarrant"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT
	var/list/storedwarrant = list() //All the warrants currently stored
	var/activename = null
	var/activecharges = null
	var/activeauth = null //Currently active warrant
	var/activetype = null //Is this a search or arrest warrtant?

//look at it
/obj/item/device/holowarrant/examine(mob/user)
	..()
	if(activename)
		to_chat(user, "It's a holographic warrant for '[activename]'.")
	if(in_range(user, src) || isobserver(user))
		show_content(user)
	else
		to_chat(user, "<span class='notice'>You have to go closer if you want to read it.</span>")

//hit yourself with it
/obj/item/device/holowarrant/attack_self(mob/living/user as mob)
	sync(user)
	if(!storedwarrant.len)
		user << "There seem to be no warrants stored in the device."
		return
	var/temp
	temp = input(usr, "Which warrant would you like to load?") as null|anything in storedwarrant
	for(var/datum/record/warrant/W in SSrecords.warrants)
		if(W.name == temp)
			activename = W.name
			activecharges = W.notes
			activeauth = W.authorization
			activetype = W.wtype

//hit other people with it
/obj/item/device/holowarrant/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	user.visible_message("<span class='notice'>[user] holds up a warrant projector and shows the contents to [M]. </span>", \
			"<span class='notice'>You show the warrant to [M]. </span>")
	M.examinate(src)

//sync with database
/obj/item/device/holowarrant/proc/sync(var/mob/user)
	storedwarrant = list()
	for(var/datum/record/warrant/W in SSrecords.warrants)
		storedwarrant += W.name
	to_chat(user, "<span class='notice'>The device hums faintly as it syncs with the station database</span>")

/obj/item/device/holowarrant/proc/show_content(mob/user, forceshow)
	if(activetype == "arrest")
		var/output = {"
		<HTML><HEAD><TITLE>Arrest Warrant: [activename]</TITLE></HEAD>
		<BODY bgcolor='#FFFFFF'>
		<font face="Verdana" color=black><font size = "1">
		<center><large><b>NanoTrasen Inc.
		<br>Civilian Branch of Operation</b></large>
		<br>
		<br><b>DIGITAL ARREST WARRANT</b></center>
		<hr>
		<b>Facility:</b>__<u>[current_map.station_name]</u>__<b>Date:</b>__<u>[worlddate2text()]__</u>
		<br>
		<br><small><i>This document serves as a notice and permits the sanctioned arrest of
		the denoted employee of the NanoTrasen Civilian Branch of Operation by the
		Security Department of the denoted facility. </br>
		In accordance with Corporate Regulation, the denoted employee must be presented with signed and stamped or
		digitally autorized warrant before the actions entailed can be conducted legally. </br>
		The Suspect/Department staff is expected to offer full co-operation.</br>
		In the event of the Suspect attempting to resist or flee, resisting arrest charges need to be applied !</br>
		In the event of staff attempting to interfere with a lawful arrest, they are to be detained as an accomplice !</br>
		In the event of no warrant being displayed <b>prior</b> to the arrest, security personell performing the arrest are subject to illegal detention charges !
		</i></small>
		<br>
		<br><b>Suspect's name: </b>
		<br>[activename]
		<br>
		<br><b>Reason(s): </b>
		<br>[activecharges]
		<br>
		<br>__<u>[activeauth]</u>__
		<br><small>Person authorizing arrest</small></br>
		</font></font>
		</BODY></HTML>
		"}

		show_browser(user, output, "window=Warrant for the arrest of [activename]")
	if(activetype == "search")
		var/output= {"
		<HTML><HEAD><TITLE>Search Warrant: [activename]</TITLE></HEAD>
		<BODY bgcolor='#FFFFFF'>
		<font face="Verdana" color=black><font size = "1">
		<center><large><b>NanoTrasen Inc.
		<br>Civilian Branch of Operation</b></large>
		<br>
		<br><b>DIGITAL SEARCH WARRANT</b></center>
		<hr>
		<b>Facility:</b>__<u>[current_map.station_name]</u>__<b>Date:</b>__<u>[worlddate2text()]__</u></br>
		<br>
		<small><i>This document serves as notice and permits the sanctioned search of
		the Suspect's person/belongings/premises and/or Department for any items and materials
		that could be connected to the suspected regulation violation described below,
		pending an investigation in progress. </br>
		The Security Officer(s) are obligated to remove any and all such items from the Suspects posession
		and/or Department and file it as evidence. </br>
		In accordance with Corporate Regulation, the denoted employee must be presented with signed and stamped or
		digitally autorized warrant before the actions entailed can be conducted legally. </br>
		The Suspect/Department staff is expected to offer full co-operation.</br>
		In the event of the Suspect/Department staff attempting	to resist/impede this search or flee, they must be taken into custody immediately! </br>
		All confiscated items must be filed and taken to Evidence!</small></i></br>
		<br><b>Suspect's/location name: </b>
		<br>[activename]
		<br>
		<br><b>For the following reasons: </b>
		<br>[activecharges]
		<br>
		<br>__<u>[activeauth]</u>__
		<br><small>Person authorizing search</small></br>
		</font></font>
		</BODY></HTML>
		"}
		show_browser(user, output, "window=Search warrant for [activename]")
