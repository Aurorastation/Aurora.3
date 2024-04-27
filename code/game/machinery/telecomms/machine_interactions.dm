/obj/machinery/telecomms
	var/temp = "" // output message
	var/construct_op = 0


/obj/machinery/telecomms/attackby(obj/item/attacking_item, mob/user)

	// Using a multitool lets you access the receiver's interface
	if(attacking_item.ismultitool())
		user.set_machine(src)
		interact(user, attacking_item)
		return TRUE

	// REPAIRING: Use Nanopaste to repair half of the system's integrity. At 24 machines, it will take 48 uses of nanopaste to repair the entire array.
	if(istype(attacking_item, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/T = attacking_item
		if (integrity < 100)               								//Damaged, let's repair!
			if (T.use(1))
				integrity = between(0, initial(integrity) / 2, initial(integrity))
				to_chat(user, "You apply the Nanopaste to [src], repairing some of the damage.")
		else
			to_chat(user, "This machine is already in perfect condition.")
		return TRUE


	switch(construct_op)
		if(0)
			if(attacking_item.isscrewdriver())
				to_chat(user, SPAN_NOTICE("You unfasten the bolts."))
				attacking_item.play_tool_sound(get_turf(src), 50)
				construct_op ++
				. = TRUE
		if(1)
			if(attacking_item.isscrewdriver())
				to_chat(user, SPAN_NOTICE("You fasten the bolts."))
				attacking_item.play_tool_sound(get_turf(src), 50)
				construct_op --
				. = TRUE
			if(attacking_item.iswrench())
				to_chat(user, SPAN_NOTICE("You dislodge the external plating."))
				attacking_item.play_tool_sound(get_turf(src), 75)
				construct_op ++
				. = TRUE
		if(2)
			if(attacking_item.iswrench())
				to_chat(user, SPAN_NOTICE("You secure the external plating."))
				attacking_item.play_tool_sound(get_turf(src), 75)
				construct_op --
				. = TRUE
			if(attacking_item.iswirecutter())
				attacking_item.play_tool_sound(get_turf(src), 50)
				to_chat(user, SPAN_NOTICE("You remove the cables."))
				construct_op ++
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( user.loc )
				A.amount = 5
				stat |= BROKEN // the machine's been borked!
				. = TRUE
		if(3)
			if(attacking_item.iscoil())
				var/obj/item/stack/cable_coil/A = attacking_item
				if (A.use(5))
					to_chat(user, "<span class='notice'>You insert the cables.</span>")
					construct_op--
					stat &= ~BROKEN // the machine's not borked anymore!
				else
					to_chat(user, "<span class='warning'>You need five coils of wire for this.</span>")
				. = TRUE
			if(attacking_item.iscrowbar())
				to_chat(user, SPAN_NOTICE("You begin prying out the circuit board's components..."))
				if(attacking_item.use_tool(src, user, 60, volume = 50))
					to_chat(user, SPAN_NOTICE("You finish prying out the components."))

					// Drop all the component stuff
					if(contents.len > 0)
						for(var/obj/x in src)
							x.forceMove(user.loc)
					else

						// If the machine wasn't made during runtime, probably doesn't have components:
						// manually find the components and drop them!
						var/newpath = text2path(circuitboard)
						var/obj/item/circuitboard/C = new newpath
						for(var/component in C.req_components)
							for(var/i = 1, i <= C.req_components[component], i++)
								newpath = text2path(component)
								var/obj/item/s = new newpath
								s.forceMove(user.loc)
								if(s.iscoil())
									var/obj/item/stack/cable_coil/A = s
									A.amount = 1

						// Drop a circuit board too
						C.forceMove(user.loc)

					// Create a machine frame and delete the current machine
					var/obj/machinery/constructable_frame/machine_frame/F = new
					F.forceMove(src.loc)
					qdel(src)
				. = TRUE
	update_icon()

/obj/machinery/telecomms/attack_ai(mob/living/silicon/user)
	if(!ai_can_interact(user))
		return
	interact(user, user.get_multitool())

/obj/machinery/telecomms/interact(mob/user, var/obj/item/device/multitool/M)
	if(!M)
		M = user.get_multitool()
	var/dat
	dat += "<br>[temp]<br><br>"
	dat += "Power Status: <a href='?src=\ref[src];input=toggle'>[src.use_power ? "On" : "Off"]</a>"
	if(operable() && use_power)
		if(id != "" && id)
			dat += "<br>Identification String: <a href='?src=\ref[src];input=id'>[id]</a>"
		else
			dat += "<br>Identification String: <a href='?src=\ref[src];input=id'>NULL</a>"
		dat += "<br>Network: <a href='?src=\ref[src];input=network'>[network]</a>"
		dat += "<br>Prefabrication: [autolinkers.len ? "TRUE" : "FALSE"]"
		if(hide) dat += "<br>Shadow Link: ACTIVE</a>"

		//Show additional options for certain machines.
		dat += Options_Menu()

		dat += "<br>Linked Network Entities: <ol>"

		var/i = 0
		for(var/obj/machinery/telecomms/T in links)
			i++
			if(T.hide && !src.hide)
				continue
			dat += "<li>\ref[T] [T.name] ([T.id])  <a href='?src=\ref[src];unlink=[i]'>\[X\]</a></li>"
		dat += "</ol>"

		dat += "Filtering Frequencies: "

		i = 0
		if(length(freq_listening))
			for(var/x in freq_listening)
				i++
				if(i < length(freq_listening))
					dat += "[format_frequency(x)] GHz<a href='?src=\ref[src];delete=[x]'>\[X\]</a>; "
				else
					dat += "[format_frequency(x)] GHz<a href='?src=\ref[src];delete=[x]'>\[X\]</a>"
		else
			dat += "NONE"

		dat += "<br>  <a href='?src=\ref[src];input=freq'>\[Add Filter\]</a>"
		dat += "<hr>"

		if(M)
			var/obj/machinery/telecomms/device = M.get_buffer()
			if(istype(device))
				dat += "<br>MULTITOOL BUFFER: [device] ([device.id]) <a href='?src=\ref[src];link=1'>\[Link\]</a> <a href='?src=\ref[src];flush=1'>\[Flush\]</a>"
			else
				dat += "<br>MULTITOOL BUFFER: <a href='?src=\ref[src];buffer=1'>\[Add Machine\]</a>"

	temp = ""

	var/datum/browser/tcomms_win = new(user, "tcommachine", "[name] Access", 520, 500)
	tcomms_win.set_content(dat)
	tcomms_win.set_window_options(replacetext(tcomms_win.window_options, "can_resize=1", "can_resize=0"))
	tcomms_win.open()

// Additional Options for certain machines. Use this when you want to add an option to a specific machine.
// Example of how to use below.

/obj/machinery/telecomms/proc/Options_Menu()
	return ""

/*
// Add an option to the processor to switch processing mode. (COMPRESS -> UNCOMPRESS or UNCOMPRESS -> COMPRESS)
/obj/machinery/telecomms/processor/Options_Menu()
	var/dat = "<br>Processing Mode: <A href='?src=\ref[src];process=1'>[process_mode ? "UNCOMPRESS" : "COMPRESS"]</a>"
	return dat
*/
// The topic for Additional Options. Use this for checking href links for your specific option.
// Example of how to use below.
/obj/machinery/telecomms/proc/Options_Topic(href, href_list)
	return

/*
/obj/machinery/telecomms/processor/Options_Topic(href, href_list)

	if(href_list["process"])
		temp = "<font color = #666633>-% Processing mode changed. %-</font>"
		src.process_mode = !src.process_mode
*/
// BUS

/obj/machinery/telecomms/bus/Options_Menu()
	var/dat = "<br>Change Signal Frequency: <A href='?src=\ref[src];change_freq=1'>[change_frequency ? "YES ([change_frequency])" : "NO"]</a>"
	return dat

/obj/machinery/telecomms/bus/Options_Topic(href, href_list)

	if(href_list["change_freq"])

		var/newfreq = input(usr, "Specify a new frequency for new signals to change to. Enter null to turn off frequency changing. Decimals assigned automatically.", src, network) as null|num
		if(canAccess(usr))
			if(newfreq)
				if(findtext(num2text(newfreq), "."))
					newfreq *= 10 // shift the decimal one place
				if(newfreq < 10000)
					change_frequency = newfreq
					temp = "<font color = #666633>-% New frequency to change to assigned: \"[newfreq] GHz\" %-</font>"
			else
				change_frequency = 0
				temp = "<font color = #666633>-% Frequency changing deactivated %-</font>"


/obj/machinery/telecomms/Topic(href, href_list)

	if(!isliving(usr))
		return

	if(stat & (BROKEN|NOPOWER))
		return

	var/obj/item/device/multitool/P = usr.get_multitool()

	if(href_list["input"])
		switch(href_list["input"])

			if("toggle")

				toggle_power()
				temp = "<font color = #666633>-% [src] has been [src.use_power ? "activated" : "deactivated"].</font>"

			/*
			if("hide")
				src.hide = !hide
				temp = "<font color = #666633>-% Shadow Link has been [src.hide ? "activated" : "deactivated"].</font>"
			*/

			if("id")
				var/newid = copytext(reject_bad_text(input(usr, "Specify the new ID for this machine", src, id) as null|text),1,MAX_MESSAGE_LEN)
				if(newid && canAccess(usr))
					id = newid
					temp = "<font color = #666633>-% New ID assigned: \"[id]\" %-</font>"

			if("network")
				var/newnet = sanitize(input(usr, "Specify the new network for this machine. This will break all current links.", src, network) as null|text)
				if(newnet && canAccess(usr))

					if(length(newnet) > 15)
						temp = "<font color = #666633>-% Too many characters in new network tag %-</font>"

					else
						for(var/obj/machinery/telecomms/T in links)
							remove_link(T)

						network = newnet
						links = list()
						temp = "<font color = #666633>-% New network tag assigned: \"[network]\" %-</font>"


			if("freq")
				var/newfreq = input(usr, "Specify a new frequency to filter (GHz). Decimals assigned automatically.", src, network) as null|num
				if(newfreq && canAccess(usr))
					if(findtext(num2text(newfreq), "."))
						newfreq *= 10 // shift the decimal one place
					if(!(newfreq in freq_listening) && newfreq < 10000)
						freq_listening.Add(newfreq)
						temp = "<font color = #666633>-% New frequency filter assigned: \"[newfreq] GHz\" %-</font>"

	if(href_list["delete"])

		// changed the layout about to workaround a pesky runtime -- Doohl

		var/x = text2num(href_list["delete"])
		temp = "<font color = #666633>-% Removed frequency filter [x] %-</font>"
		freq_listening.Remove(x)

	if(href_list["unlink"])

		if(text2num(href_list["unlink"]) <= length(links))
			var/obj/machinery/telecomms/T = links[text2num(href_list["unlink"])]
			if(T)
				temp = "<font color = #666633>-% Removed \ref[T] [T.name] from linked entities. %-</font>"
				remove_link(T)

	if(href_list["link"])

		if(P)
			var/obj/machinery/telecomms/device = P.get_buffer()
			if(device)
				add_new_link(device)
				temp = "<font color = #666633>-% Successfully linked with \ref[device] [device.name] %-</font>"
			else
				temp = "<font color = #666633>-% Unable to acquire buffer %-</font>"

	if(href_list["buffer"])

		P.set_buffer(src)
		var/atom/buffer = P.get_buffer()
		temp = "<font color = #666633>-% Successfully stored \ref[buffer] [buffer.name] in buffer %-</font>"


	if(href_list["flush"])

		temp = "<font color = #666633>-% Buffer successfully flushed. %-</font>"
		P.set_buffer(null)

	src.Options_Topic(href, href_list)

	usr.set_machine(src)
	src.add_fingerprint(usr)

	updateDialog()

// Adds new_connection to src's links list AND vice versa. also updates links_by_telecomms_type
/obj/machinery/telecomms/proc/add_new_link(obj/machinery/telecomms/new_connection)
	if (!istype(new_connection) || new_connection == src)
		return FALSE

	if ((new_connection in links) && (src in new_connection.links))
		return FALSE

	links |= new_connection
	new_connection.links |= src

	LAZYADDASSOCLIST(links_by_telecomms_type, new_connection.telecomms_type, new_connection)
	LAZYADDASSOCLIST(new_connection.links_by_telecomms_type, telecomms_type, src)

	return TRUE

// Removes old_connection from src's links list AND vice versa. also updates links_by_telecomms_type
/obj/machinery/telecomms/proc/remove_link(obj/machinery/telecomms/old_connection)
	if (!istype(old_connection) || old_connection == src)
		return FALSE

	if (old_connection in links)
		links -= old_connection
		LAZYREMOVEASSOC(links_by_telecomms_type, old_connection.telecomms_type, old_connection)

	if (src in old_connection.links)
		old_connection.links -= src
		LAZYREMOVEASSOC(old_connection.links_by_telecomms_type, telecomms_type, src)

	return TRUE

/obj/machinery/telecomms/proc/canAccess(var/mob/user)
	if(issilicon(user) || in_range(user, src))
		return 1
	return 0
