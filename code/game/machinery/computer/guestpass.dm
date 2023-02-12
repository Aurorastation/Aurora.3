/////////////////////////////////////////////
//Guest pass ////////////////////////////////
/////////////////////////////////////////////
/obj/item/card/id/guest
	name = "guest pass"
	desc = "Allows temporary access to station areas."
	icon_state = "guest"
	overlay_state = "guest"

	var/temp_access = list() //to prevent agent cards stealing access as permanent
	var/expiration_time = 0
	var/reason = "NOT SPECIFIED"

/obj/item/card/id/guest/GetAccess()
	if (world.time > expiration_time)
		return access
	else
		return temp_access

/obj/item/card/id/guest/examine(mob/user)
	..(user)
	if(world.time > expiration_time)
		to_chat(usr, "This pass expired at: [worldtime2text(expiration_time)].")
	else
		to_chat(usr, "This pass expires at: [worldtime2text(expiration_time)].")

	to_chat(usr, "It grants access to the following areas:")
	for(var/A in temp_access)
		to_chat(usr, "[get_access_desc(A)]")
	to_chat(usr, "Issuing reason: [reason].")

/obj/item/card/id/guest/Initialize(mapload, duration)
	. = ..(mapload)
	expiration_time = duration + world.time
	addtimer(CALLBACK(src, PROC_REF(expire)), duration)

/obj/item/card/id/guest/proc/expire()
	icon_state += "_invalid"
	overlay_state += "_invalid"

#define GUEST_PASS_TERMINAL_UNSET "\[UNSET\]"

// Guest Pass Terminal
/obj/machinery/computer/guestpass
	name = "guest pass terminal"
	desc = "A guest pass terminal. It allows issuing temporary access passes to one or more areas."
	icon = 'icons/obj/computer.dmi'
	icon_state = "guestw"
	light_color = LIGHT_COLOR_BLUE
	icon_state = "altcomputerw"
	icon_screen = "guest"
	icon_scanline = "altcomputerw-scanline"
	density = FALSE
	appearance_flags = TILE_BOUND // prevents people from viewing the overlay through a wall

	var/obj/item/card/id/giver = GUEST_PASS_TERMINAL_UNSET
	var/list/accesses = list()
	var/giv_name = GUEST_PASS_TERMINAL_UNSET
	var/reason = GUEST_PASS_TERMINAL_UNSET
	var/duration = 10

	var/list/internal_log = list()
	var/mode = 0 // 0: Making pass. 1: Viewing logs.

/obj/machinery/computer/guestpass/Initialize()
	. = ..()
	uid = "[rand(100,999)]-G[rand(10,99)]"

/obj/machinery/computer/guestpass/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/card/id))
		if((!giver || giver == GUEST_PASS_TERMINAL_UNSET) && user.unEquip(O))
			O.forceMove(src)
			giver = O
			updateUsrDialog()
		else if(giver && giver != GUEST_PASS_TERMINAL_UNSET)
			to_chat(user, SPAN_WARNING("There is already ID card inside \the [src]."))
		return TRUE
	return ..()

/obj/machinery/computer/guestpass/attack_ai(var/mob/user as mob)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/computer/guestpass/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.set_machine(src)
	var/dat

	if(mode == 1) // Logs.
		dat += "<h3>Activity log</h3><br>"
		for (var/entry in internal_log)
			dat += "[entry]<br><hr>"
		dat += "<a href='?src=\ref[src];action=print'>Print</a><br>"
		dat += "<a href='?src=\ref[src];mode=0'>Back</a><br>"
	else
		dat += "<h3>Guest Pass Terminal #[uid]</h3>"
		dat += "Issuing ID: <a href='?src=\ref[src];action=id'>[giver]</a><br>"
		dat += "Issued To: <a href='?src=\ref[src];choice=giv_name'>[giv_name]</a><br>"
		dat += "Reason: <a href='?src=\ref[src];choice=reason'>[reason]</a><br>"
		dat += "Duration (minutes): <a href='?src=\ref[src];choice=duration'>[duration] m</a><br>"
		dat += "Access to Areas:<br>"
		if((giver && giver != GUEST_PASS_TERMINAL_UNSET) && giver.access)
			for(var/A in giver.access)
				var/area = get_access_desc(A)
				if (A in accesses)
					area = "<span style='color:#00dd12'>[area]</span>"
				dat += "<a href='?src=\ref[src];choice=access;access=[A]'>[area]</a><br>"
		dat += "<br><a href='?src=\ref[src];action=issue'>Issue Pass</a><br>"
		dat += "<a href='?src=\ref[src];mode=1'>View Activity Log</a><br><br>"

	var/datum/browser/guestpass_win = new(user, "guestpass", capitalize_first_letters(name), 400, 520)
	guestpass_win.set_content(dat)
	guestpass_win.open()

/obj/machinery/computer/guestpass/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	if(href_list["mode"])
		mode = text2num(href_list["mode"])

	if(href_list["choice"])
		switch(href_list["choice"])
			if("giv_name")
				var/nam = sanitizeName(input("Issued To:", "Name", giv_name) as text|null)
				if(nam)
					giv_name = nam
			if("reason")
				var/reas = sanitize(input("Reason:", "Reason", reason) as text|null)
				if(reas)
					reason = reas
			if("duration")
				var/dur = input("Duration (in minutes) during which pass is valid (up to 60 minutes):", "Duration") as num|null
				if(dur)
					if(dur > 0 && dur <= 60)
						duration = dur
					else
						to_chat(usr, "<b>\The [src]</b> displays, \"Invalid duration.\"")
			if("access")
				var/A = text2num(href_list["access"])
				if (A in accesses)
					accesses.Remove(A)
				else
					accesses.Add(A)
	if(href_list["action"])
		switch(href_list["action"])
			if("id")
				if(giver && giver != GUEST_PASS_TERMINAL_UNSET)
					if(ishuman(usr))
						giver.forceMove(usr.loc)
						if(!usr.get_active_hand())
							usr.put_in_hands(giver)
						giver = GUEST_PASS_TERMINAL_UNSET
					else
						giver.forceMove(src.loc)
						giver = GUEST_PASS_TERMINAL_UNSET
					accesses.Cut()
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/card/id) && usr.unEquip(I))
						I.forceMove(src)
						giver = I
				updateUsrDialog()

			if("print")
				var/dat = "<h3>Activity Log of Guest Pass Terminal #[uid]</h3><br>"
				for (var/entry in internal_log)
					dat += "[entry]<br><hr>"
				//to_chat(usr, "Printing the log, standby...")
				//sleep(50)
				var/obj/item/paper/P = new/obj/item/paper( loc )
				P.set_content_unsafe("activity log", dat)

			if("issue")
				if(giver && giver != GUEST_PASS_TERMINAL_UNSET)
					var/number = add_zero("[rand(0,9999)]", 4)
					var/entry = "\[[worldtime2text()]\] Pass #[number] issued by [giver.registered_name], [giver.assignment] to [giv_name].<br>Reason: [reason].<br>Grants access to the following areas:<br>"
					for (var/i=1 to accesses.len)
						var/A = accesses[i]
						if(A)
							var/area = get_access_desc(A)
							entry += "[i > 1 ? ", [area]" : "[area]"]<br>"
					entry += "Expires at: [worldtime2text(world.time + duration*10*60)]."
					internal_log.Add(entry)

					var/obj/item/card/id/guest/pass = new(loc, duration MINUTES)
					pass.temp_access = accesses.Copy()
					pass.registered_name = giv_name
					pass.reason = reason
					pass.name = "guest pass - [giv_name]"

					// Reset the Terminal
					giv_name = GUEST_PASS_TERMINAL_UNSET
					reason = GUEST_PASS_TERMINAL_UNSET
					duration = 10
				else
					to_chat(usr, SPAN_WARNING("Cannot issue a guest pass without a issuing ID."))
	updateUsrDialog()
	return

#undef GUEST_PASS_TERMINAL_UNSET