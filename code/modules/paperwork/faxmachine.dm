GLOBAL_LIST_EMPTY_TYPED(allfaxes, /obj/machinery/photocopier/faxmachine)

///cache for faxes that have been sent to the admins
GLOBAL_LIST_EMPTY_TYPED(arrived_faxes, /obj/item)

///cache for faxes that have been sent by the admins
GLOBAL_LIST_EMPTY_TYPED(sent_faxes, /obj/item)

GLOBAL_LIST_EMPTY(alldepartments)
GLOBAL_LIST_EMPTY(admin_departments)

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	icon = 'icons/obj/library.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	req_one_access = list(ACCESS_LAWYER, ACCESS_HEADS)
	density = 0
	idle_power_usage = 30
	active_power_usage = 200
	print_animation = "faxreceive"

	var/static/const/adminfax_cooldown = 1800
	var/static/const/normalfax_cooldown = 300
	var/static/const/broadcastfax_cooldown = 3000

	var/static/const/broadcast_departments = "Stationwide broadcast (WARNING)"
	/// Identification.
	var/obj/item/card/id/identification
	/// Time since the last fax was sent.
	var/sendtime = 0
	/// Delay before another fax can be sent (in deciseconds). Used by set_cooldown() and get_remaining_cooldown().
	var/sendcooldown = 0
	/// Our department.
	var/department = "Unknown"
	/// Destination we are sending to.
	var/destination
	/// A list of PDAs to alert upon arrival of the fax.
	var/list/obj/item/modular_computer/alert_pdas = list()

/obj/machinery/photocopier/faxmachine/Initialize()
	. = ..()
	GLOB.allfaxes += src
	if( !(("[department]" in GLOB.alldepartments) || ("[department]" in GLOB.admin_departments)) )
		GLOB.alldepartments |= department
	destination = SSatlas.current_map.boss_name

/obj/machinery/photocopier/faxmachine/Destroy()
	GLOB.allfaxes -= src
	QDEL_NULL(identification)

	. = ..()

/obj/machinery/photocopier/faxmachine/ui_data(mob/user)
	var/list/data = list()
	data["destination"] = destination
	data["bossname"] = SSatlas.current_map.boss_name
	data["auth"] = is_authenticated()
	data["cooldown_end"] = sendtime + sendcooldown
	data["world_time"] = world.time
	data["destination"] = destination
	if(identification)
		data["idname"] = identification.name
	else
		data["idname"] = ""
	data["paper"] = (copy_item ? copy_item.name : "")

	data["alertpdas"] = list()
	if (alert_pdas && alert_pdas.len)
		for (var/obj/item/modular_computer/pda in alert_pdas)
			data["alertpdas"] += list(list("name" = "[alert_pdas[pda]]", "ref" = "[REF(pda)]"))
	data["departments"] = list()
	for (var/dept in (GLOB.alldepartments + GLOB.admin_departments + broadcast_departments))
		data["departments"] += "[dept]"

	return data

/obj/machinery/photocopier/faxmachine/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Fax", "Fax Machine", 400, 500)
		ui.open()

/obj/machinery/photocopier/faxmachine/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	SStgui.update_uis(src)

/obj/machinery/photocopier/faxmachine/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("send")
			if (get_remaining_cooldown() > 0)
				// Rate-limit sending faxes
				to_chat(usr, SPAN_WARNING("The fax machine isn't ready, yet!"))
				return

			if(copy_item && is_authenticated())
				if (destination in GLOB.admin_departments)
					send_admin_fax(usr, destination)
				else if (destination == broadcast_departments)
					send_broadcast_fax()
				else
					sendfax(destination)
			return TRUE

		if("remove")
			if(copy_item)
				copy_item.forceMove(loc)
				if (get_dist(usr, src) < 2)
					usr.put_in_hands(copy_item)
					to_chat(usr, SPAN_NOTICE("You take \the [copy_item] out of \the [src]."))
				else
					to_chat(usr, SPAN_NOTICE("You eject \the [copy_item] from \the [src]."))
				copy_item = null
				return TRUE

		if("remove_id")
			if (identification)
				if(ishuman(usr))
					identification.forceMove(usr.loc)
					if(!usr.get_active_hand())
						usr.put_in_hands(identification)
					identification = null
					return TRUE
				else
					identification.forceMove(src.loc)
					identification = null
					return TRUE
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/card/id) && usr.unEquip(I))
					I.forceMove(src)
					identification = I
					return TRUE

		if("linkpda")
			var/obj/item/modular_computer/pda = usr.get_active_hand()
			if (!pda || !istype(pda))
				to_chat(usr, SPAN_WARNING("You need to be holding a PDA to link it."))
			else if (pda in alert_pdas)
				to_chat(usr, SPAN_NOTICE("\The [pda] appears to be already linked."))
				//Update the name real quick.
				alert_pdas[pda] = pda.name
				return TRUE
			else
				alert_pdas += pda
				alert_pdas[pda] = pda.name
				to_chat(usr, SPAN_NOTICE("You link \the [pda] to \the [src]. It will now ping upon the arrival of a fax to this machine."))
				return TRUE

		if("unlink")
			var/obj/item/modular_computer/pda = locate(params["unlink"])
			if (pda && istype(pda))
				if (pda in alert_pdas)
					to_chat(usr, SPAN_NOTICE("You unlink [alert_pdas[pda]] from \the [src]. It will no longer be notified of new faxes."))
					alert_pdas -= pda
					return TRUE

		if("select_destination")
			if(!params["select_destination"])
				return
			destination = params["select_destination"]
			return TRUE

/obj/machinery/photocopier/faxmachine/process()
	.=..()
	var/static/ui_update_delay = 0

	if ((sendtime + sendcooldown) < world.time)
		sendcooldown = 0

/*
 * Check if current id in machine is autenthicated
 */
/obj/machinery/photocopier/faxmachine/proc/is_authenticated()
	return identification ? check_access(identification) : FALSE

/*
 * Set the send cooldown
 * 		cooldown: duration in ~1/10s
 */
/obj/machinery/photocopier/faxmachine/proc/set_cooldown(var/cooldown)
	// Reset send time
	sendtime = world.time

	// Set cooldown length
	sendcooldown = cooldown

/*
 * Get remaining cooldown duration in ~1/10s
 */
/obj/machinery/photocopier/faxmachine/proc/get_remaining_cooldown()
	var/remaining_time = (sendtime + sendcooldown) - world.time
	if ((remaining_time < 0) || (sendcooldown == 0))
		// Time is up, but Process() hasn't caught up, yet
		// or no cooldown has been set
		remaining_time = 0
	return remaining_time

/*
 * Send normal fax message to on-station fax machine
 * 		destination: 		(string) from /allfaxes
 * 		display_message: 	(bool) 1=display info text, 0="silent mode"
 */
/obj/machinery/photocopier/faxmachine/proc/sendfax(var/destination, var/display_message = 1)
	if(stat & (BROKEN|NOPOWER))
		return 0

	use_power_oneoff(200)

	var/success = 0
	for(var/obj/machinery/photocopier/faxmachine/F in GLOB.allfaxes)
		if( F.department == destination )
			success = F.receivefax(copy_item)

	if (success)
		set_cooldown(normalfax_cooldown)

	if (display_message)
		// Normal fax
		if (success)
			visible_message("[src] beeps, \"Message transmitted successfully.\"")
		else
			visible_message("[src] beeps, \"Error transmitting message.\"")
	return success

/obj/machinery/photocopier/faxmachine/proc/receivefax(var/obj/item/incoming)
	if(stat & (BROKEN|NOPOWER))
		return 0

	if(department == "Unknown")
		return 0	//You can't send faxes to "Unknown"

	if (!istype(incoming, /obj/item/paper) && !istype(incoming, /obj/item/photo) && !istype(incoming, /obj/item/paper_bundle))
		return 0

	playsound(loc, 'sound/bureaucracy/print.ogg', 75, 1)

	// give the sprite some time to flick
	spawn(20)
		if (istype(incoming, /obj/item/paper))
			copy(src, incoming, TRUE, FALSE, FALSE, toner = toner)
		else if (istype(incoming, /obj/item/photo))
			photocopy(src, incoming, toner = src.toner)
		else if (istype(incoming, /obj/item/paper_bundle))
			bundlecopy(src, incoming, toner = src.toner)
		do_pda_alerts()
		use_power_oneoff(active_power_usage)

	return 1

/obj/machinery/photocopier/faxmachine/proc/send_broadcast_fax()
	var success = 1
	for (var/dest in (GLOB.alldepartments - department))
		// Send to everyone except this department
		sleep(1)
		success &= sendfax(dest, 0)	// 0: don't display success/error messages

		if(!success)// Stop on first error
			break
	if (success)
		visible_message("[src] beeps, \"Messages transmitted successfully.\"")
		set_cooldown(broadcastfax_cooldown)
	else
		visible_message("[src] beeps, \"Error transmitting messages.\"")
		set_cooldown(normalfax_cooldown)

/obj/machinery/photocopier/faxmachine/proc/send_admin_fax(var/mob/sender, var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power_oneoff(200)

	if(SSatlas.current_sector.ccia_link == FALSE)
		if(destination in GLOB.admin_departments)
			visible_message("[src] beeps, \"Unable to connect to route to [SSatlas.current_map.boss_name].\"")
			return

	var/obj/item/rcvdcopy
	if (istype(copy_item, /obj/item/paper))
		rcvdcopy = copy(src, copy_item, FALSE, toner = toner)
	else if (istype(copy_item, /obj/item/photo))
		rcvdcopy = photocopy(src, copy_item, toner = toner)
	else if (istype(copy_item, /obj/item/paper_bundle))
		rcvdcopy = bundlecopy(src, copy_item, FALSE, toner = toner)
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")
		return

	rcvdcopy.forceMove(null)  //hopefully this shouldn't cause trouble
	GLOB.arrived_faxes += rcvdcopy

	//message badmins that a fax has arrived
	if (destination == SSatlas.current_map.boss_name)
		message_admins(sender, "[uppertext(SSatlas.current_map.boss_short)] FAX", rcvdcopy, "CentcommFaxReply", "#006100")
	else if (destination == "External Routing")
		message_admins(sender, "EXTERNAL ROUTING FAX", rcvdcopy, "CentcommFaxReply", "#1F66A0")

	set_cooldown(adminfax_cooldown)
	spawn(50)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")


/obj/machinery/photocopier/faxmachine/proc/message_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/reply_type, font_colour="#006100")
	var/msg = SPAN_NOTICE(" <b><font color='[font_colour]'>[faxname]: </font>[key_name(sender, 1)] (<A href='byond://?_src_=holder;adminplayeropts=[REF(sender)]'>PP</A>) (<A href='byond://?_src_=vars;Vars=[REF(sender)]'>VV</A>) (<A href='byond://?_src_=holder;subtlemessage=[REF(sender)]'>SM</A>) (<A href='byond://?_src_=holder;adminplayerobservejump=[REF(sender)]'>JMP</A>) (<A href='byond://?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<a href='byond://?_src_=holder;[reply_type]=[REF(src)];faxMachine=[REF(src)]'>REPLY</a>)</b>: Receiving '[sent.name]' via secure connection ... <a href='byond://?_src_=holder;AdminFaxView=[REF(sent)]'>view message</a>")

	var/cciaa_present = 0
	var/cciaa_afk = 0
	for(var/s in GLOB.staff)
		var/client/C = s
		var/flags = C.holder.rights & (R_ADMIN|R_CCIAA)
		if(flags)
			to_chat(C, msg)
		if (flags == R_CCIAA) // Admins sometimes get R_CCIAA, but CCIAA never get R_ADMIN
			cciaa_present++
			if (C.is_afk())
				cciaa_afk++

	var/discord_msg = "New fax arrived! [faxname]: \"[sent.name]\" by [sender]. ([cciaa_present] agents online"
	if (cciaa_present)
		if ((cciaa_present - cciaa_afk) <= 0)
			discord_msg += ", **all AFK!**)"
		else
			discord_msg += ", [cciaa_afk] AFK.)"
	else
		discord_msg += ".)"

	discord_msg += " Gamemode: [SSticker.mode]"

	SSdiscord.send_to_cciaa(discord_msg)

/obj/machinery/photocopier/faxmachine/proc/do_pda_alerts()
	for(var/obj/item/modular_computer/pda in alert_pdas)
		var/message = "New message has arrived!"
		pda.get_notification(message, 1, "[department] [name]")
