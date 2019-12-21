var/list/obj/machinery/photocopier/faxmachine/allfaxes = list()
var/list/arrived_faxes = list()	//cache for faxes that have been sent to the admins
var/list/sent_faxes = list()	//cache for faxes that have been sent by the admins
var/list/alldepartments = list()
var/list/admin_departments

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	icon = 'icons/obj/library.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	req_one_access = list(access_lawyer, access_heads)
	density = 0//It's a small machine that sits on a table, this allows small things to walk under that table
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 200

	var/static/const/adminfax_cooldown = 1800		// in 1/10 seconds
	var/static/const/normalfax_cooldown = 300
	var/static/const/broadcastfax_cooldown = 3000

	var/static/const/broadcast_departments = "Stationwide broadcast (WARNING)"
	var/obj/item/card/id/scan = null // identification
	var/sendtime = 0		// Time when fax was sent
	var/sendcooldown = 0	// Delay, before another fax can be sent (in 1/10 second). Used by set_cooldown() and get_remaining_cooldown()

	var/department = "Unknown" // our department

	var/list/obj/item/device/pda/alert_pdas = list() //A list of PDAs to alert upon arrival of the fax.

/obj/machinery/photocopier/faxmachine/Initialize()
	. = ..()
	allfaxes += src
	if( !(("[department]" in alldepartments) || ("[department]" in admin_departments)) )
		alldepartments |= department

/obj/machinery/photocopier/faxmachine/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueui/ui)
	// Build baseline data, that's read-only
	if(!newdata)
		. = newdata = list("destination" = "[current_map.boss_name]", "idname" = "", "paper" = "")
	newdata["bossname"] = current_map.boss_name
	VUEUI_SET_CHECK(newdata["auth"], is_authenticated(), ., newdata)
	VUEUI_SET_CHECK(newdata["cooldownend"], sendtime + sendcooldown, ., newdata)
	if(scan)
		VUEUI_SET_CHECK(newdata["idname"], scan.name, ., newdata)
	else
		VUEUI_SET_CHECK(newdata["idname"], "", ., newdata)
	VUEUI_SET_CHECK(newdata["paper"], (copyitem ? copyitem.name : ""), ., newdata)

	if(newdata["alertpdas"] && alert_pdas && newdata["alertpdas"].len != alert_pdas.len)
		. = newdata
	newdata["alertpdas"] = list()
	if (alert_pdas && alert_pdas.len)
		for (var/obj/item/device/pda/pda in alert_pdas)
			newdata["alertpdas"] += list(list("name" = "[alert_pdas[pda]]", "ref" = "\ref[pda]"))
	newdata["departiments"] = list()
	for (var/dept in (alldepartments + admin_departments + broadcast_departments))
		newdata["departiments"] += "[dept]"

	// Get destination from UI
	if(!(newdata["destination"] in (alldepartments + admin_departments + broadcast_departments)))
		newdata["destination"] = "[current_map.boss_name]"

/obj/machinery/photocopier/faxmachine/ui_interact(mob/user as mob)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "paperwork-fax", 450, 350, capitalize(src.name))
	ui.open()

/obj/machinery/photocopier/faxmachine/attackby(obj/item/O as obj, mob/user as mob)
	. = ..()
	SSvueui.check_uis_for_change(src)

/obj/machinery/photocopier/faxmachine/Topic(href, href_list)
	if(href_list["send"])
		if (get_remaining_cooldown() > 0)
			// Rate-limit sending faxes
			to_chat(usr, "<span class='warning'>The fax machine isn't ready, yet!</span>")
			SSvueui.check_uis_for_change(src)
			return

		var/datum/vueui/ui = href_list["vueui"]
		if(!istype(ui))
			return
		var/destination = ui.data["destination"]
		if(copyitem && is_authenticated())
			if (destination in admin_departments)
				send_admin_fax(usr, destination)
			else if (destination == broadcast_departments)
				send_broadcast_fax()
			else
				sendfax(destination)
			SSvueui.check_uis_for_change(src)

	else if(href_list["remove"])
		if(copyitem)
			copyitem.forceMove(loc)
			if (get_dist(usr, src) < 2)
				usr.put_in_hands(copyitem)
				to_chat(usr, "<span class='notice'>You take \the [copyitem] out of \the [src].</span>")
			else
				to_chat(usr, "<span class='notice'>You eject \the [copyitem] from \the [src].</span>")
			copyitem = null
			SSvueui.check_uis_for_change(src)

	if(href_list["scan"])
		if (scan)
			if(ishuman(usr))
				scan.forceMove(usr.loc)
				if(!usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			else
				scan.forceMove(src.loc)
				scan = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/card/id) && usr.unEquip(I))
				I.forceMove(src)
				scan = I
		SSvueui.check_uis_for_change(src)

	if(href_list["linkpda"])
		var/obj/item/device/pda/pda = usr.get_active_hand()
		if (!pda || !istype(pda))
			to_chat(usr, "<span class='warning'>You need to be holding a PDA to link it.</span>")
		else if (pda in alert_pdas)
			to_chat(usr, "<span class='notice'>\The [pda] appears to be already linked.</span>")
			//Update the name real quick.
			alert_pdas[pda] = pda.name
			SSvueui.check_uis_for_change(src)
		else
			alert_pdas += pda
			alert_pdas[pda] = pda.name
			to_chat(usr, "<span class='notice'>You link \the [pda] to \the [src]. It will now ping upon the arrival of a fax to this machine.</span>")
			SSvueui.check_uis_for_change(src)

	if(href_list["unlink"])
		var/obj/item/device/pda/pda = locate(href_list["unlink"])
		if (pda && istype(pda))
			if (pda in alert_pdas)
				to_chat(usr, "<span class='notice'>You unlink [alert_pdas[pda]] from \the [src]. It will no longer be notified of new faxes.</span>")
				alert_pdas -= pda
				SSvueui.check_uis_for_change(src)

/obj/machinery/photocopier/faxmachine/machinery_process()
	.=..()
	var/static/ui_update_delay = 0

	if ((sendtime + sendcooldown) < world.time)
		sendcooldown = 0

/*
 * Check if current id in machine is autenthicated
 */
/obj/machinery/photocopier/faxmachine/proc/is_authenticated()
	return scan ? check_access(scan) : FALSE

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

	use_power(200)

	var/success = 0
	for(var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if( F.department == destination )
			success = F.receivefax(copyitem)

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

	flick("faxreceive", src)
	playsound(loc, "sound/bureaucracy/print.ogg", 75, 1)

	// give the sprite some time to flick
	spawn(20)
		if (istype(incoming, /obj/item/paper))
			copy(incoming, 1, 0, 0)
		else if (istype(incoming, /obj/item/photo))
			photocopy(incoming)
		else if (istype(incoming, /obj/item/paper_bundle))
			bundlecopy(incoming)
		do_pda_alerts()
		use_power(active_power_usage)

	return 1

/obj/machinery/photocopier/faxmachine/proc/send_broadcast_fax()
	var success = 1
	for (var/dest in (alldepartments - department))
		// Send to everyone except this department
		delay(1)
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

	use_power(200)

	var/obj/item/rcvdcopy
	if (istype(copyitem, /obj/item/paper))
		rcvdcopy = copy(copyitem, 0)
	else if (istype(copyitem, /obj/item/photo))
		rcvdcopy = photocopy(copyitem)
	else if (istype(copyitem, /obj/item/paper_bundle))
		rcvdcopy = bundlecopy(copyitem, 0)
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")
		return

	rcvdcopy.forceMove(null)  //hopefully this shouldn't cause trouble
	arrived_faxes += rcvdcopy

	//message badmins that a fax has arrived
	if (destination == current_map.boss_name)
		message_admins(sender, "[uppertext(current_map.boss_short)] FAX", rcvdcopy, "CentcommFaxReply", "#006100")
	else if (destination == "External Routing")
		message_admins(sender, "EXTERNAL ROUTING FAX", rcvdcopy, "CentcommFaxReply", "#1F66A0")

	set_cooldown(adminfax_cooldown)
	spawn(50)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")


/obj/machinery/photocopier/faxmachine/proc/message_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/reply_type, font_colour="#006100")
	var/msg = "<span class='notice'> <b><font color='[font_colour]'>[faxname]: </font>[key_name(sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[sender]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[sender]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<a href='?_src_=holder;[reply_type]=\ref[src];faxMachine=\ref[src]'>REPLY</a>)</b>: Receiving '[sent.name]' via secure connection ... <a href='?_src_=holder;AdminFaxView=\ref[sent]'>view message</a></span>"

	var/cciaa_present = 0
	var/cciaa_afk = 0
	for(var/s in staff)
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

	discord_bot.send_to_cciaa(discord_msg)

/obj/machinery/photocopier/faxmachine/proc/do_pda_alerts()
	if (!alert_pdas || !alert_pdas.len)
		return

	for (var/obj/item/device/pda/pda in alert_pdas)
		if (pda.toff || pda.message_silent)
			continue

		var/message = "New fax has arrived at [src.department] fax machine."
		pda.new_info(pda.message_silent, pda.ttone, "\icon[pda] <b>[message]</b>")