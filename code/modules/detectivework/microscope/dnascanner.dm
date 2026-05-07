//DNA machine
/obj/machinery/dnaforensics
	name = "DNA analyzer"
	desc = "A high tech machine that is designed to read DNA samples properly."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnaopen"
	anchored = TRUE
	density = TRUE

	var/obj/item/forensics/swab/bloodsamp = null
	var/closed = FALSE
	var/scanning = FALSE
	var/scanner_progress = 0
	var/scanner_rate = 2.50
	var/last_process_worldtime = 0
	var/report_num = 0

/obj/machinery/dnaforensics/attackby(obj/item/attacking_item, mob/user)
	var/obj/item/forensics/swab/swab = attacking_item
	// General intended use (w swabs)
	if(istype(swab))
		if(swab.is_used())
			// Already a sample loaded
			if(bloodsamp)
				to_chat(user, SPAN_WARNING("There is already a sample in the machine."))
				return FALSE
			// Open the lid, dummy
			if(closed)
				to_chat(user, SPAN_WARNING("Open the cover before inserting the sample."))
				return FALSE
			// Insert the sample
			else
				user.unEquip(attacking_item)
				src.bloodsamp = swab
				swab.forceMove(src)
				to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]."))
				return TRUE
		// Used swabs only
		else
			to_chat(user, SPAN_WARNING("\The [src] only accepts used swabs."))
			return FALSE

	else if(attacking_item.tool_behaviour == TOOL_WRENCH)
		attacking_item.play_tool_sound(get_turf(src), 100)
		balloon_alert(user, "[anchored ? "secure" : "unsecure"]")
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")
		anchored = !anchored
		return TRUE
	return ..()

/obj/machinery/dnaforensics/ui_interact(mob/user, datum/tgui/ui)
	if(stat & NOPOWER)
		return
	if(use_check_and_message(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DnaForensics", "QuikScan DNA Analyzer")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/dnaforensics/ui_data(mob/user)
	var/list/data = list()

	data["scan_progress"] = round(scanner_progress)
	data["scanning"] = scanning
	data["bloodsamp"] = (bloodsamp ? bloodsamp.name : "")
	data["bloodsamp_desc"] = (bloodsamp ? (bloodsamp.desc ? bloodsamp.desc : "No information on record.") : "")
	data["lid_closed"] = closed

	return data

/obj/machinery/dnaforensics/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("scanItem")
			if(scanning)
				scanning = FALSE
				return TRUE

			if(!bloodsamp)
				to_chat(usr, SPAN_WARNING("Insert an item to scan."))
				return TRUE

			if(closed)
				scanner_progress = 0
				scanning = TRUE
				to_chat(usr, SPAN_NOTICE("Scan initiated."))
				update_icon()
				return TRUE

			to_chat(usr, SPAN_NOTICE("Please close sample lid before initiating scan."))
			return TRUE

		if("ejectItem")
			if(bloodsamp && !scanning)
				bloodsamp.forceMove(src.loc)
				bloodsamp = null
				return TRUE
			return FALSE

		if("toggleLid")
			toggle_lid()
			return TRUE

	return FALSE

/obj/machinery/dnaforensics/process()
	if(scanning)
		if(!bloodsamp || bloodsamp.loc != src)
			bloodsamp = null
			scanning = 0
		else if(scanner_progress >= 100)
			complete_scan()
			return
		else
			//calculate time difference
			var/deltaT = (world.time - last_process_worldtime) * 0.1
			scanner_progress = min(100, scanner_progress + scanner_rate * deltaT)
	last_process_worldtime = world.time

/obj/machinery/dnaforensics/proc/complete_scan()
	visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] makes an insistent chime."), range = 2)
	update_icon()
	if(bloodsamp)
		var/obj/item/paper/P = new()
		var/pname = "[src] report #[++report_num]"
		var/info
		P.stamped = list(/obj/item/stamp)
		P.overlays = list("paper_stamped")
		//dna data itself
		var/datetime = "[worlddate2text()] [worldtime2text()]"
		var/data = "No scan information available."
		if(bloodsamp.dna != null)
			data = "Spectometric analysis on provided sample has determined the presence of [length(bloodsamp.dna)] string\s of DNA.<br><br>"
			for(var/blood in bloodsamp.dna)
				if(bloodsamp.dna[blood])
					data += "<b>Blood type:</b> [bloodsamp.dna[blood]]<br>"
				data += "<b>DNA:</b> [blood]<br><br>"
		else
			data += "No DNA found.<br>"
		info = "<b><font size=\"4\">[src] forensic report #[report_num]</font></b><br><i>Scanned [datetime]</i><HR>"
		info += "<b>Scanned item:</b> [bloodsamp.name]<br><br>" + data
		P.set_content_unsafe(pname, info)
		print(P, user = usr)
		scanning = 0
		update_icon()
	return

/obj/machinery/dnaforensics/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/dnaforensics/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/dnaforensics/verb/toggle_lid()
	set category = "Object"
	set name = "Toggle Lid"
	set src in oview(1)

	if(use_check_and_message(usr))
		return

	if(scanning)
		to_chat(usr, SPAN_WARNING("You can't do that while [src] is scanning!"))
		return

	closed = !closed
	src.update_icon()

/obj/machinery/dnaforensics/update_icon()
	..()
	if(!(stat & NOPOWER) && scanning)
		icon_state = "dnaworking"
	else if(closed)
		icon_state = "dnaclosed"
	else
		icon_state = "dnaopen"
