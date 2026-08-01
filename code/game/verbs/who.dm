/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/count
	var/msg
	var/total_num = 0

	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights || R_DEV & holder.rights))
		msg += "<table border='1' border-collapse='collapse' width='100%' style='border-collapse: collapse'>"

		// Table Header
		msg += "<tr>"
		msg += "<td>Client Key</td>"
		msg += "<td>Character</td>"
		msg += "<td>Status</td>"
		msg += "<td>Age</td>"
		msg += "<td>Ping</td>"
		msg += "<td>Antag</td>"
		msg += "<td>More Info</td>"
		msg += "</tr>"

		for(var/client/client in sortKey(GLOB.clients))
			msg += "<tr>"

			// Client Key
			msg += "<td>[client.key]"
			if(client.holder && client.holder.fakekey)
				msg += " <i>(as [client.holder.fakekey])</i>"
			msg += "</td>"

			// Character
			msg += "<td>[client.mob.real_name]</td>"

			// Status
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
							msg += "<font color='black'><b>Dead</b></font>"
					else if(isstoryteller(client.mob))
						msg += "<font color='blue'><b>Storytelling</b></font>"
					else
						msg += "<font color='black'><b>Dead</b></font>"
				else
					msg += "<font color='green'><b>Alive</b></font>"
			msg += "</td>"

			// Account Age
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

			// Ping
			if((R_ADMIN & holder.rights) || (R_DEV & holder.rights))
				msg += "<td>[round(client.avgping, 1)] ms</td>"
			else
				msg += "<td></td>"

			// Antag
			if(is_special_character(client.mob))
				msg += "<td><b>Antagonist</b></td>"
			else
				msg += "<td></td>"

			// More Info
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

	count = "<b>Current Players ([total_num])</b><br>"
	msg = count + msg

	var/datum/browser/who_win = new(usr, "who", "Who", 450, 500)
	who_win.set_content(msg)
	who_win.open()

#define STAFFWHO_STATUS_OBSERVING " \[Observing\]"
#define STAFFWHO_STATUS_LOBBY " \[Lobby\]"
#define STAFFWHO_STATUS_STORYTELLING " \[Storytelling\]"
#define STAFFWHO_STATUS_PLAYING " \[Playing\]"
#define STAFFWHO_AFK " (AFK)"

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
			if(R_ADMIN & client.holder.rights) // Who shows up in admin rows.

				if(client.holder.fakekey && !(R_ADMIN & holder.rights || R_MOD & holder.rights))
					continue

				msg += "\t[client.key] · [client.holder.rank]"

				if(client.holder.fakekey)
					msg += " <i>(as [client.holder.fakekey])</i>"

				if(isobserver(client.mob))
					msg += STAFFWHO_STATUS_OBSERVING
				else if(isnewplayer(client.mob))
					msg += STAFFWHO_STATUS_LOBBY
				else if(isstoryteller(client.mob))
					msg += STAFFWHO_STATUS_STORYTELLING
				else
					msg += STAFFWHO_STATUS_PLAYING

				if(client.is_afk())
					msg += STAFFWHO_AFK
				msg += "<br>"

				num_admins_online++
			else if(R_MOD & client.holder.rights) // Who shows up in mod rows.
				modmsg += "\t[client.key] · [client.holder.rank]"

				if(isobserver(client.mob))
					modmsg += STAFFWHO_STATUS_OBSERVING
				else if(isnewplayer(client.mob))
					modmsg += STAFFWHO_STATUS_LOBBY
				else if(isstoryteller(client.mob))
					modmsg += STAFFWHO_STATUS_STORYTELLING
				else
					modmsg += STAFFWHO_STATUS_PLAYING

				if(client.is_afk())
					modmsg += STAFFWHO_AFK
				modmsg += "<br>"
				num_mods_online++

			else if(R_CCIAA & client.holder.rights) // Who shows up in CCIAA rows.
				cciaamsg += "\t[client.key] · [client.holder.rank]"

				if(isobserver(client.mob))
					cciaamsg += STAFFWHO_STATUS_OBSERVING
				else if(isnewplayer(client.mob))
					cciaamsg += STAFFWHO_STATUS_LOBBY
				else if(isstoryteller(client.mob))
					cciaamsg += STAFFWHO_STATUS_STORYTELLING
				else
					cciaamsg += STAFFWHO_STATUS_PLAYING

				if(client.is_afk())
					cciaamsg += STAFFWHO_AFK
				cciaamsg += "<br>"
				num_cciaa_online++

			else if(client.holder.rights & R_DEV) // Who shows up in dev rows.
				devmsg += "\t[client.key] · [client.holder.rank]"

				if(isobserver(client.mob))
					devmsg += STAFFWHO_STATUS_OBSERVING
				else if(isnewplayer(client.mob))
					devmsg += STAFFWHO_STATUS_LOBBY
				else if(isstoryteller(client.mob))
					devmsg += STAFFWHO_STATUS_STORYTELLING
				else
					devmsg += STAFFWHO_STATUS_PLAYING

				if(client.is_afk())
					devmsg += STAFFWHO_AFK
				devmsg += "<br>"
				num_devs_online++
	else
		for(var/s in GLOB.staff)
			var/client/client = s
			if(R_ADMIN & client.holder.rights)
				if(!client.holder.fakekey)
					if(client.is_afk())
						msg += "\t[client.key] · [client.holder.rank] (AFK)<br>"
					else
						msg += "\t[client.key] · [client.holder.rank]<br>"
					num_admins_online++
			else if(R_MOD & client.holder.rights)
				if(client.is_afk())
					modmsg += "\t[client.key] · [client.holder.rank] (AFK)<br>"
				else
					modmsg += "\t[client.key] · [client.holder.rank]<br>"
				num_mods_online++
			else if(client.holder.rights & R_DEV)
				if(client.is_afk())
					devmsg += "\t[client.key] · [client.holder.rank] (AFK)<br>"
				else
					devmsg += "\t[client.key] · [client.holder.rank]<br>"
				num_devs_online++
			else if(R_CCIAA & client.holder.rights)
				if(client.is_afk())
					cciaamsg += "\t[client.key] · [client.holder.rank] (AFK)<br>"
				else
					cciaamsg += "\t[client.key] · [client.holder.rank]<br>"
				num_cciaa_online++

	if(SSdiscord && SSdiscord.active)
		to_chat(src, SPAN_INFO("Adminhelps are also sent to Discord. If no admins are available in game try anyway and an admin on Discord may see it and respond."))

	msg = "<b>Current Administrators ([num_admins_online])</b><br>" + msg

	if(GLOB.config.show_mods)
		msg += "<br><b>Current Moderators ([num_mods_online])</b><br>" + modmsg

	if(GLOB.config.show_auxiliary_roles)
		if(num_cciaa_online)
			msg += "<br><b>Current CCIA Agents ([num_cciaa_online])</b><br>" + cciaamsg
		if(num_devs_online)
			msg += "<br><b>Current Developers ([num_devs_online])</b><br>" + devmsg

	var/datum/browser/staff_win = new(usr, "staffwho", "Staff Who", 450, 500)
	staff_win.set_content(msg)
	staff_win.open()

#undef STAFFWHO_STATUS_OBSERVING
#undef STAFFWHO_STATUS_LOBBY
#undef STAFFWHO_STATUS_STORYTELLING
#undef STAFFWHO_STATUS_PLAYING
#undef STAFFWHO_AFK
