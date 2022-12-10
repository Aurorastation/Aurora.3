
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/header = "<b>Current Players:</b><br>"
	var/count
	var/msg
	var/total_num = 0

	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights))
		for(var/client/C in sortKey(clients))
			msg += "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				msg += " <i>(as [C.holder.fakekey])</i>"
			msg += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					msg += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/abstract/observer/O = C.mob
						if(O.started_as_observer)
							msg += " - <font color='gray'>Observing</font>"
						else
							msg += " - <font color='black'><b>DEAD</b></font>"
					else
						msg += " - <font color='black'><b>DEAD</b></font>"

			var/age
			if(isnum(C.player_age))
				age = C.player_age
			else
				age = 0

			if(age <= 1)
				age = "<font color='#ff0000'><b>[age]</b></font>"
			else if(age < 10)
				age = "<font color='#ff8c00'><b>[age]</b></font>"

			msg += " - [age]"

			if(is_special_character(C.mob))
				msg += " - <b><span class='warning'>Antagonist</span></b>"
			msg += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			msg += "<br>"
			total_num++
	else
		for(var/client/C in sortKey(clients))
			if(C.holder && C.holder.fakekey)
				msg += C.holder.fakekey
			else
				msg += C.key
			total_num++
			msg += "<br>"

	count = "<b>Total Players: [total_num]</b><br>"
	msg = header + count + msg

	var/datum/browser/who_win = new(usr, "who", "Who", 450, 500)
	who_win.set_content(msg)
	who_win.open()

/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/msg = ""
	var/modmsg = ""
	var/cciaamsg = ""
	var/devmsg = ""
	var/num_mods_online = 0
	var/num_admins_online = 0
	var/num_cciaa_online = 0
	var/num_devs_online = 0
	if(holder)
		for(var/s in staff)
			var/client/C = s
			if(R_ADMIN & C.holder.rights)	//Used to determine who shows up in admin rows

				if(C.holder.fakekey && !(R_ADMIN & holder.rights || R_MOD & holder.rights))		//Mentors can't see stealthmins
					continue

				msg += "\t[C.key] is a [C.holder.rank]"

				if(C.holder.fakekey)
					msg += " <i>(as [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					msg += " - Observing"
				else if(istype(C.mob,/mob/abstract/new_player))
					msg += " - Lobby"
				else
					msg += " - Playing"

				if(C.is_afk())
					msg += " (AFK)"
				msg += "<br>"

				num_admins_online++
			else if(R_MOD & C.holder.rights)				//Who shows up in mod/mentor rows.
				modmsg += "\t[C.key] is a [C.holder.rank]"

				if(isobserver(C.mob))
					modmsg += " - Observing"
				else if(istype(C.mob,/mob/abstract/new_player))
					modmsg += " - Lobby"
				else
					modmsg += " - Playing"

				if(C.is_afk())
					modmsg += " (AFK)"
				modmsg += "<br>"
				num_mods_online++

			else if (R_CCIAA & C.holder.rights)
				cciaamsg += "\t[C.key]"
				if (isobserver(C.mob))
					cciaamsg += " - Observing"
				else if (istype(C.mob, /mob/abstract/new_player))
					cciaamsg += " - Lobby"
				else
					cciaamsg += " - Playing"

				if (C.is_afk())
					cciaamsg += " (AFK)"
				cciaamsg += "<br>"
				num_cciaa_online++

			else if(C.holder.rights & R_DEV)
				devmsg += "\t[C.key] is a [C.holder.rank]"
				if(isobserver(C.mob))
					devmsg += " - Observing"
				else if(istype(C.mob,/mob/abstract/new_player))
					devmsg += " - Lobby"
				else
					devmsg += " - Playing"

				if(C.is_afk())
					devmsg += " (AFK)"
				devmsg += "<br>"
				num_devs_online++

	else
		for(var/s in staff)
			var/client/C = s
			if(R_ADMIN & C.holder.rights)
				if(!C.holder.fakekey)
					if(C.is_afk())
						msg += "\t[C.key] is a [C.holder.rank] (AFK)<br>"
					else
						msg += "\t[C.key] is a [C.holder.rank]<br>"
					num_admins_online++
			else if (R_MOD & C.holder.rights)
				if(C.is_afk())
					modmsg += "\t[C.key] is a [C.holder.rank] (AFK)<br>"
				else
					modmsg += "\t[C.key] is a [C.holder.rank]<br>"
				num_mods_online++
			else if(C.holder.rights & R_DEV)
				if(C.is_afk())
					devmsg += "\t[C.key] is a [C.holder.rank] (AFK)<br>"
				else
					devmsg += "\t[C.key] is a [C.holder.rank]<br>"
				num_devs_online++
			else if (R_CCIAA & C.holder.rights)
				if(C.is_afk())
					cciaamsg += "\t[C.key] is a [C.holder.rank] (AFK)<br>"
				else
					cciaamsg += "\t[C.key] is a [C.holder.rank]<br>"
				num_cciaa_online++

	if(discord_bot && discord_bot.active)
		to_chat(src, "<span class='info'>Adminhelps are also sent to Discord. If no admins are available in game try anyway and an admin on Discord may see it and respond.</span>")
	msg = "<b>Current Admins ([num_admins_online]):</b><br>" + msg

	if(config.show_mods)
		msg += "<br><b>Current Moderators ([num_mods_online]):</b><br>" + modmsg

	if (config.show_auxiliary_roles)
		if (num_cciaa_online)
			msg += "<br><b>Current CCIA Agents ([num_cciaa_online]):</b><br>" + cciaamsg
		if(num_devs_online)
			msg += "<br><b>Current Developers ([num_devs_online]):</b><br>" + devmsg

	var/datum/browser/staff_win = new(usr, "staffwho", "Staff Who", 450, 500)
	staff_win.set_content(msg)
	staff_win.open()
