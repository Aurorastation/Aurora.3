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
	req_one_access = list(access_lawyer, access_heads, access_armory) //Warden needs to be able to Fax tau ceti gov too.
	density = 0//It's a small machine that sits on a table, this allows small things to walk under that table
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 200

	var/static/const/adminfax_cooldown = 1800		// in 1/10 seconds
	var/static/const/normalfax_cooldown = 300
	var/static/const/broadcastfax_cooldown = 3000

	var/static/const/broadcast_departments = "Stationwide broadcast (WARNING)"
	var/obj/item/weapon/card/id/scan = null // identification
	var/authenticated = 0
	var/sendtime = 0		// Time when fax was sent
	var/sendcooldown = 0	// Delay, before another fax can be sent (in 1/10 second). Used by set_cooldown() and get_remaining_cooldown()

	var/department = "Unknown" // our department
	var/destination = null // the department we're sending to

	var/list/obj/item/device/pda/alert_pdas = list() //A list of PDAs to alert upon arrival of the fax.

/obj/machinery/photocopier/faxmachine/Initialize()
	. = ..()
	allfaxes += src
	if(!destination) destination = "[current_map.boss_name]"
	if( !(("[department]" in alldepartments) || ("[department]" in admin_departments)) )
		alldepartments |= department

/obj/machinery/photocopier/faxmachine/attack_hand(mob/user as mob)
	user.set_machine(src)

	var/remaining_cooldown = get_remaining_cooldown()
	var/dat = "Fax Machine<BR>"

	var/scan_name
	if(scan)
		scan_name = scan.name
	else
		scan_name = "--------"

	dat += "Confirm Identity: <a href='byond://?src=\ref[src];scan=1'>[scan_name]</a><br>"

	if(authenticated)
		dat += "<a href='byond://?src=\ref[src];logout=1'>{Log Out}</a>"
	else
		dat += "<a href='byond://?src=\ref[src];auth=1'>{Log In}</a>"

	dat += "<hr>"

	if(authenticated)
		dat += "<b>Logged in to:</b> [current_map.boss_name] Quantum Entanglement Network<br><br>"

		if(copyitem)
			dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Item</a><br><br>"

			if(remaining_cooldown > 0)
				dat += "<b>Transmitter arrays realigning. Please stand by. [round(remaining_cooldown / 10)] seconds remaining.</b><br>"

			else

				dat += "<a href='byond://?src=\ref[src];send=1'>Send</a><br>"
				dat += "<b>Currently sending:</b> [copyitem.name]<br>"
				dat += "<b>Sending to:</b> <a href='byond://?src=\ref[src];dept=1'>[destination]</a><br>"

		else
			if(remaining_cooldown > 0)
				dat += "Please insert paper to send via secure connection.<br><br>"
				dat += "<b>Transmitter arrays realigning. Please stand by. [round(remaining_cooldown / 10)] seconds remaining.</b><br>"
			else
				dat += "Please insert paper to send via secure connection.<br><br>"

	else
		dat += "Proper authentication is required to use this device.<br><br>"

		if(copyitem)
			dat += "<a href ='byond://?src=\ref[src];remove=1'>Remove Item</a><br>"

	dat += "<br>PDAs to notify:<br>"

	if (alert_pdas && alert_pdas.len)
		for (var/obj/item/device/pda/pda in alert_pdas)
			dat += "[alert_pdas[pda]] - <a href='byond://?src=\ref[src];unlink=\ref[pda]'>Unlink</a><br>"

	dat += "<br><a href='byond://?src=\ref[src];linkpda=1'>Add PDA to Notify</a>"

	user << browse(dat, "window=copier")
	onclose(user, "copier")

	if (remaining_cooldown > 0)
		spawn(50)
			// Auto-refresh every 5 seconds, if cooldown is active
			updateUsrDialog()

	return

/obj/machinery/photocopier/faxmachine/Topic(href, href_list)
	if(href_list["send"])
		if (get_remaining_cooldown() > 0)
			// Rate-limit sending faxes
			usr << "<span class='warning'>The fax machine isn't ready, yet!</span>"
			updateUsrDialog()
			return

		if(copyitem)
			if (destination in admin_departments)
				send_admin_fax(usr, destination)
			else if (destination == broadcast_departments)
				send_broadcast_fax()
			else
				sendfax(destination)
			updateUsrDialog()

	else if(href_list["remove"])
		if(copyitem)
			copyitem.loc = loc
			if (get_dist(usr, src) < 2)
				usr.put_in_hands(copyitem)
				usr << "<span class='notice'>You take \the [copyitem] out of \the [src].</span>"
			else
				usr << "<span class='notice'>You eject \the [copyitem] from \the [src].</span>"
			copyitem = null
			updateUsrDialog()

	if(href_list["scan"])
		if (scan)
			if(ishuman(usr))
				scan.loc = usr.loc
				if(!usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			else
				scan.loc = src.loc
				scan = null
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id) && usr.unEquip(I))
				I.loc = src
				scan = I
		authenticated = 0

	if(href_list["dept"])
		var/lastdestination = destination
		destination = input(usr, "Which department?", "Choose a department", "") as null|anything in (alldepartments + admin_departments + broadcast_departments)
		if(!destination) destination = lastdestination

	if(href_list["auth"])
		if ( (!( authenticated ) && (scan)) )
			if (check_access(scan))
				authenticated = 1

	if(href_list["logout"])
		authenticated = 0

	if(href_list["linkpda"])
		var/obj/item/device/pda/pda = usr.get_active_hand()
		if (!pda || !istype(pda))
			usr << "<span class='warning'>You need to be holding a PDA to link it.</span>"
		else if (pda in alert_pdas)
			usr << "<span class='notice'>\The [pda] appears to be already linked.</span>"
			//Update the name real quick.
			alert_pdas[pda] = pda.name
		else
			alert_pdas += pda
			alert_pdas[pda] = pda.name
			usr << "<span class='notice'>You link \the [pda] to \the [src]. It will now ping upon the arrival of a fax to this machine.</span>"

	if(href_list["unlink"])
		var/obj/item/device/pda/pda = locate(href_list["unlink"])
		if (pda && istype(pda))
			if (pda in alert_pdas)
				usr << "<span class='notice'>You unlink [alert_pdas[pda]] from \the [src]. It will no longer be notified of new faxes.</span>"
				alert_pdas -= pda

	updateUsrDialog()

/obj/machinery/photocopier/faxmachine/machinery_process()
	.=..()
	var/static/ui_update_delay = 0

	if ((sendtime + sendcooldown) < world.time)
		sendcooldown = 0

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
			success = F.recievefax(copyitem)

	if (success)
		set_cooldown(normalfax_cooldown)

	if (display_message)
		// Normal fax
		if (success)
			visible_message("[src] beeps, \"Message transmitted successfully.\"")
		else
			visible_message("[src] beeps, \"Error transmitting message.\"")
	return success

/obj/machinery/photocopier/faxmachine/proc/recievefax(var/obj/item/incoming)
	if(stat & (BROKEN|NOPOWER))
		return 0

	if(department == "Unknown")
		return 0	//You can't send faxes to "Unknown"

	if (!istype(incoming, /obj/item/weapon/paper) && !istype(incoming, /obj/item/weapon/photo) && !istype(incoming, /obj/item/weapon/paper_bundle))
		return 0

	flick("faxreceive", src)
	playsound(loc, "sound/items/polaroid1.ogg", 50, 1)

	// give the sprite some time to flick
	spawn(20)
		if (istype(incoming, /obj/item/weapon/paper))
			copy(incoming, 1, 0, 0)
		else if (istype(incoming, /obj/item/weapon/photo))
			photocopy(incoming)
		else if (istype(incoming, /obj/item/weapon/paper_bundle))
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
	if (istype(copyitem, /obj/item/weapon/paper))
		rcvdcopy = copy(copyitem, 0)
	else if (istype(copyitem, /obj/item/weapon/photo))
		rcvdcopy = photocopy(copyitem)
	else if (istype(copyitem, /obj/item/weapon/paper_bundle))
		rcvdcopy = bundlecopy(copyitem, 0)
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")
		return

	rcvdcopy.forceMove(null)  //hopefully this shouldn't cause trouble
	arrived_faxes += rcvdcopy

	//message badmins that a fax has arrived
	if (destination == current_map.boss_name)
		message_admins(sender, "[uppertext(current_map.boss_short)] FAX", rcvdcopy, "CentcommFaxReply", "#006100")
	else if (destination == "[current_map.system_name] Government")
		message_admins(sender, "[uppertext(current_map.system_name)] GOVERNMENT FAX", rcvdcopy, "CentcommFaxReply", "#1F66A0")

	set_cooldown(adminfax_cooldown)
	spawn(50)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")


/obj/machinery/photocopier/faxmachine/proc/message_admins(var/mob/sender, var/faxname, var/obj/item/sent, var/reply_type, font_colour="#006100")
	var/msg = "<span class='notice'> <b><font color='[font_colour]'>[faxname]: </font>[key_name(sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[sender]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[sender]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<a href='?_src_=holder;[reply_type]=\ref[src];faxMachine=\ref[src]'>REPLY</a>)</b>: Receiving '[sent.name]' via secure connection ... <a href='?_src_=holder;AdminFaxView=\ref[sent]'>view message</a></span>"

	var/cciaa_present = 0
	var/cciaa_afk = 0
	for(var/client/C in admins)
		var/flags = C.holder.rights & (R_ADMIN|R_CCIAA)
		if(flags)
			C << msg
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

	discord_bot.send_to_cciaa(discord_msg)

/obj/machinery/photocopier/faxmachine/proc/do_pda_alerts()
	if (!alert_pdas || !alert_pdas.len)
		return

	for (var/obj/item/device/pda/pda in alert_pdas)
		if (pda.toff || pda.message_silent)
			continue

		var/message = "New fax has arrived at [src.department] fax machine."
		pda.new_info(pda.message_silent, pda.ttone, "\icon[pda] <b>[message]</b>")
