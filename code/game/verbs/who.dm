
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/header = "<b>Current Players:</b><br>"
	var/count
	var/msg
	var/total_num = 0

	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights || R_DEV & holder.rights))
		msg += "<table border='1' border-collapse='collapse' width='100%' style='border-collapse: collapse'>"

		// table header
		msg += "<tr>"
		msg += "<td>Client Key</td>"
		msg += "<td>Character</td>"
		msg += "<td>Status</td>"
		msg += "<td>Age</td>"
		msg += "<td></td>"
		msg += "<td></td>"
		msg += "<td></td>"
		msg += "</tr>"

		for(var/client/client in sortKey(GLOB.clients))
			msg += "<tr>"

			// client key
			msg += "<td>[client.key]"
			if(client.holder && client.holder.fakekey)
				msg += " <i>(as [client.holder.fakekey])</i>"
			msg += "</td>"

			// character
			msg += "<td>[client.mob.real_name]</td>"

			// status
			msg += "<td>"
			switch(client.mob.stat)
				if(UNCONSCIOUS)
					msg += "<font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(client.mob))
						var/mob/abstract/ghost/observer/O = client.mob
						if(O.started_as_observer)
							msg += "<font color='gray'>Observing</font>"
						else
							msg += "<font color='black'><b>DEAD</b></font>"
					else if(isstoryteller(client.mob))
						msg += "<font color='blue'><b>STORYTELLING</b></font>"
					else
						msg += "<font color='black'><b>DEAD</b></font>"
			msg += "</td>"

			// account age
			var/age
			if(isnum(client.player_age))
				age = client.player_age
			else
				age = 0
			if(age <= 1)
				age = "<font color='#ff0000'><b>[age]</b></font>"
			else if(age < 10)
				age = "<font color='#ff8c00'><b>[age]</b></font>"
			msg += "<td>[age]</td>"

			// ping
			if((R_ADMIN & holder.rights) || (R_DEV & holder.rights))
				msg += "<td>[round(client.avgping, 1)]ms</td>"
			else
				msg += "<td></td>"

			// antag
			if(is_special_character(client.mob))
				msg += "<td><b>Antagonist</b></td>"
			else
				msg += "<td></td>"

			// more info button
			msg += "<td><A href='byond://?_src_=holder;adminmoreinfo=[REF(client.mob)]'>?</A></td>"

			total_num++
			msg += "</tr>"
		msg += "</table>"
	else
		for(var/client/client in sortKey(GLOB.clients))
			if(client.holder && client.holder.fakekey)
				msg += client.holder.fakekey
			else
				msg += client.key
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
		for(var/s in GLOB.staff)
			var/client/client = s
			if(R_ADMIN & client.holder.rights)	//Used to determine who shows up in admin rows

				if(client.holder.fakekey && !(R_ADMIN & holder.rights || R_MOD & holder.rights))		//Mentors can't see stealthmins
					continue

				msg += "\t[client.key] is a [client.holder.rank]"

				if(client.holder.fakekey)
					msg += " <i>(as [client.holder.fakekey])</i>"

				if(isobserver(client.mob))
					msg += " - Observing"
				else if(isnewplayer(client.mob))
					msg += " - Lobby"
				else if(isstoryteller(client.mob))
					msg += "- Storytelling"
				else
					msg += " - Playing"

				if(client.is_afk())
					msg += " (AFK)"
				msg += "<br>"

				num_admins_online++
			else if(R_MOD & client.holder.rights)				//Who shows up in mod/mentor rows.
				modmsg += "\t[client.key] is a [client.holder.rank]"

				if(isobserver(client.mob))
					modmsg += " - Observing"
				else if(isnewplayer(client.mob))
					modmsg += " - Lobby"
				else if(isstoryteller(client.mob))
					modmsg += "- Storytelling"
				else
					modmsg += " - Playing"

				if(client.is_afk())
					modmsg += " (AFK)"
				modmsg += "<br>"
				num_mods_online++

			else if (R_CCIAA & client.holder.rights)
				cciaamsg += "\t[client.key]"

				if(isobserver(client.mob))
					cciaamsg += " - Observing"
				else if(isnewplayer(client.mob))
					cciaamsg += " - Lobby"
				else if(isstoryteller(client.mob))
					cciaamsg += "- Storytelling"
				else
					cciaamsg += " - Playing"

				if (client.is_afk())
					cciaamsg += " (AFK)"
				cciaamsg += "<br>"
				num_cciaa_online++

			else if(client.holder.rights & R_DEV)
				devmsg += "\t[client.key] is a [client.holder.rank]"

				if(isobserver(client.mob))
					devmsg += " - Observing"
				else if(isnewplayer(client.mob))
					devmsg += " - Lobby"
				else if(isstoryteller(client.mob))
					devmsg += "- Storytelling"
				else
					devmsg += " - Playing"

				if(client.is_afk())
					devmsg += " (AFK)"
				devmsg += "<br>"
				num_devs_online++
	else
		for(var/s in GLOB.staff)
			var/client/client = s
			if(R_ADMIN & client.holder.rights)
				if(!client.holder.fakekey)
					if(client.is_afk())
						msg += "\t[client.key] is a [client.holder.rank] (AFK)<br>"
					else
						msg += "\t[client.key] is a [client.holder.rank]<br>"
					num_admins_online++
			else if (R_MOD & client.holder.rights)
				if(client.is_afk())
					modmsg += "\t[client.key] is a [client.holder.rank] (AFK)<br>"
				else
					modmsg += "\t[client.key] is a [client.holder.rank]<br>"
				num_mods_online++
			else if(client.holder.rights & R_DEV)
				if(client.is_afk())
					devmsg += "\t[client.key] is a [client.holder.rank] (AFK)<br>"
				else
					devmsg += "\t[client.key] is a [client.holder.rank]<br>"
				num_devs_online++
			else if (R_CCIAA & client.holder.rights)
				if(client.is_afk())
					cciaamsg += "\t[client.key] is a [client.holder.rank] (AFK)<br>"
				else
					cciaamsg += "\t[client.key] is a [client.holder.rank]<br>"
				num_cciaa_online++

	if(SSdiscord && SSdiscord.active)
		to_chat(src, "<span class='info'>Adminhelps are also sent to Discord. If no admins are available in game try anyway and an admin on Discord may see it and respond.</span>")
	msg = "<b>Current Admins ([num_admins_online]):</b><br>" + msg

	if(GLOB.config.show_mods)
		msg += "<br><b>Current Moderators ([num_mods_online]):</b><br>" + modmsg

	if (GLOB.config.show_auxiliary_roles)
		if (num_cciaa_online)
			msg += "<br><b>Current CCIA Agents ([num_cciaa_online]):</b><br>" + cciaamsg
		if(num_devs_online)
			msg += "<br><b>Current Developers ([num_devs_online]):</b><br>" + devmsg

	var/datum/browser/staff_win = new(usr, "staffwho", "Staff Who", 450, 500)
	staff_win.set_content(msg)
	staff_win.open()
