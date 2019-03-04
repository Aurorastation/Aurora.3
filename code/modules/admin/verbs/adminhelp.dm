
//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as")

/proc/generate_ahelp_key_words(var/mob/mob, var/msg)
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	for(var/mob/M in mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai" && !ai_found)
					ai_found = 1
					msg += "<b>[original_word] <A HREF='?_src_=holder;adminchecklaws=\ref[mob]'>(CL)</A></b> "
					continue
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							msg += "<b>[original_word] <A HREF='?_src_=holder;adminmoreinfo=\ref[found]'>(?)</A>"
							if(!ai_found && isAI(found))
								ai_found = 1
								msg += " <A HREF='?_src_=holder;adminchecklaws=\ref[mob]'>(CL)</A>"
							msg += "</b> "
							continue
			msg += "[original_word] "

	return msg

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='warning'>Speech is currently admin-disabled.</span>")
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>")
		return

	adminhelped = ADMINHELPED

	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return
	var/original_msg = msg

	if(!mob) //this doesn't happen
		return

	//generate keywords lookup
	msg = generate_ahelp_key_words(mob, msg)

	// handle ticket
	var/datum/ticket/ticket = get_open_ticket_by_ckey(ckey)
	if(!ticket)
		ticket = new /datum/ticket(ckey)
	else if(ticket.status == TICKET_ASSIGNED)
		// manually check that the target client exists here as to not spam the usr for each logged out admin on the ticket
		var/admin_found = 0
		for(var/admin in ticket.assigned_admins)
			var/client/admin_client = client_by_ckey(admin)
			if(admin_client)
				admin_found = 1
				src.cmd_admin_pm(admin_client, original_msg, ticket)
				break
		if(!admin_found)
			to_chat(src, "<span class='warning'>Error: Private-Message: Client not found. They may have lost connection, so please be patient!</span>")
		return

	ticket.append_message(src.ckey, null, original_msg)

	//Options bar:  mob, details ( admin = 2, undibbsed admin = 3, mentor = 4, character name (0 = just ckey, 1 = ckey and character name), link? (0 no don't make it a link, 1 do so),
	//		highlight special roles (0 = everyone has same looking name, 1 = antags / special roles get a golden name)

	msg = "<span class='notice'><b><font color=red>HELP: </font>[get_options_bar(mob, 2, 1, 1, 1, ticket)] (<a href='?_src_=holder;take_ticket=\ref[ticket]'>[(ticket.status == TICKET_OPEN) ? "TAKE" : "JOIN"]</a>) (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>):</b> [msg]</span>"

	var/admin_number_present = 0
	var/admin_number_afk = 0

	for(var/client/X in admins)
		if((R_ADMIN|R_MOD) & X.holder.rights)
			admin_number_present++
			if(X.is_afk())
				admin_number_afk++
			if(X.prefs.toggles & SOUND_ADMINHELP)
				sound_to(X, 'sound/effects/adminhelp.ogg')

			to_chat(X, msg)

	//show it to the person adminhelping too
	to_chat(src, "<font color='blue'>PM to-<b>Staff </b>: [original_msg]</font>")

	var/admin_number_active = admin_number_present - admin_number_afk
	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admin_number_present] non-AFK admins.",admin_key=key_name(src))
	if(admin_number_active <= 0)
		post_webhook_event(WEBHOOK_ADMIN_PM_IMPORTANT, list("title"="Help is requested", "message"="Request for Help from **[key_name(src)]**: ```[html_decode(original_msg)]```\n[admin_number_afk ? "All admins AFK ([admin_number_afk])" : "No admins online"]!!"))
		discord_bot.send_to_admins("@here Request for Help from [key_name(src)]: [html_decode(original_msg)] - !![admin_number_afk ? "All admins AFK ([admin_number_afk])" : "No admins online"]!!")
		adminhelped = ADMINHELPED_DISCORD
	feedback_add_details("admin_verb","AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return
