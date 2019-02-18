// NETWORKING TREE
//
// Abilities in this tree are oriented around giving the AI more control of normally uncontrollable systems.
// T1 - Basic Encryption Hack - Allows hacking of APCs. Hacked APCs can be controlled even when AI Control is cut and give exclusive control to the AI and linked cyborgs.
// T2 - Advanced Encryption Hack - Allows the AI to send fake CentCom message. Has high chance of failing.
// T3 - Elite Encryption Hack - Allows the AI to change alert levels. Has high chance of failing.
// T4 - System Override - Allows the AI to rapidly hack remaining APCs. When completed, grants access to the self destruct nuclear warhead.


// BEGIN RESEARCH DATUMS

/datum/malf_research_ability/networking/basic_hack
	ability = new/datum/game_mode/malfunction/verb/basic_encryption_hack()
	price = 25
	next = new/datum/malf_research_ability/networking/advanced_hack()
	name = "Basic Encryption Hack"

/datum/malf_research_ability/networking/advanced_hack
	ability = new/datum/game_mode/malfunction/verb/advanced_encryption_hack()
	price = 400
	next = new/datum/malf_research_ability/networking/elite_hack()
	name = "Advanced Encryption Hack"

/datum/malf_research_ability/networking/elite_hack
	ability = new/datum/game_mode/malfunction/verb/elite_encryption_hack()
	price = 1000
	next = new/datum/malf_research_ability/networking/system_override()
	name = "Elite Encryption Hack"


/datum/malf_research_ability/networking/system_override
	ability = new/datum/game_mode/malfunction/verb/system_override()
	price = 5000
	name = "System Override"

// END RESEARCH DATUMS
// BEGIN ABILITY VERBS

/datum/game_mode/malfunction/verb/basic_encryption_hack(obj/machinery/power/apc/A as obj in get_unhacked_apcs(src))
	set category = "Software"
	set name = "Basic Encryption Hack"
	set desc = "10 CPU - Basic encryption hack that allows you to overtake APCs on the station."
	var/price = 10
	var/mob/living/silicon/ai/user = usr

	if(!A)
		return

	if(!istype(A))
		to_chat(user, "This is not an APC!")
		return

	if(A)
		if(A.hacker && A.hacker == user)
			to_chat(user, "You already control this APC!")
			return
		else if(A.aidisabled)
			to_chat(user, "<span class='notice'>Unable to connect to APC. Please verify wire connection and try again.</span>")
			return
	else
		return

	if(!ability_prechecks(user, price) || !ability_pay(user, price))
		return

	log_ability_use(user, "basic encryption hack", A, 0)	// Does not notify admins, but it's still logged for reference.
	user.hacking = 1
	to_chat(user, "Beginning APC system override...")
	sleep(300)
	to_chat(user, "APC hack completed. Uploading modified operation software..")
	sleep(200)
	to_chat(user, "Restarting APC to apply changes..")
	sleep(100)
	if(A)
		A.ai_hack(user)
		if(A.hacker == user)
			to_chat(user, "Hack successful. You now have full control over the APC.")
		else
			to_chat(user, "<span class='notice'>Hack failed. Connection to APC has been lost. Please verify wire connection and try again.</span>")
	else
		to_chat(user, "<span class='notice'>Hack failed. Unable to locate APC. Please verify the APC still exists.</span>")
	user.hacking = 0


/datum/game_mode/malfunction/verb/advanced_encryption_hack()
	set category = "Software"
	set name = "Advanced Encryption Hack"
	set desc = "75 CPU - Attempts to bypass encryption on the Command Quantum Relay, giving you ability to fake legitimate messages. Has chance of failing."
	var/price = 75
	var/mob/living/silicon/ai/user = usr

	if(!ability_prechecks(user, price))
		return

	var/reporttitle
	var/reportbody
	var/reporttype = input(usr, "Choose whether to use a template or custom report.", "Create Command Report") in list("Template", "Custom", "Cancel")
	switch(reporttype)
		if("Template")
			establish_db_connection(dbcon)
			if (!dbcon.IsConnected())
				src << "<span class='notice'>Unable to connect to the database.</span>"
				return
			var/DBQuery/query = dbcon.NewQuery("SELECT title, message FROM ss13_ccia_general_notice_list WHERE deleted_at IS NULL")
			query.Execute()

			var/list/template_names = list()
			var/list/templates = list()

			while (query.NextRow())
				template_names += query.item[1]
				templates[query.item[1]] = query.item[2]

			// Catch empty list
			if (!templates.len)
				src << "<span class='notice'>There are no templates in the database.</span>"
				return

			reporttitle = input(usr, "Please select a command report template.", "Create Command Report") in template_names
			reportbody = templates[reporttitle]

		if("Custom")
			reporttitle = sanitizeSafe(input(usr, "Pick a title for the report.", "Title") as text|null)
			if(!reporttitle)
				reporttitle = "NanoTrasen Update"
			reportbody = sanitize(input(usr, "Please enter anything you want. Anything. Serious.", "Body", "") as message|null, extra = 0)
			if(!reportbody)
				return
		else
			return

	if (reporttype == "Template")
		sanitizeSafe(alert(usr, "Would you like it to appear as if CCIAMS made the report?",,"Yes","No"))
		if ("Yes")
			reportbody += "\n\n- CCIAMS, [commstation_name()]"
		else

	switch(alert("Should this be announced to the general population?",,"Yes","No"))
		if("Yes")
			if(!reporttitle || !reportbody || !ability_pay(user, price))
				to_chat(user, "Hack Aborted due to no title, no body message, or you do not have enough CPU for this action.")
				return

			log_ability_use(user, "advanced encryption hack")
			// Commented out while trialing the malf ai buff
			//if(prob(50) && user.hack_can_fail)
			//	to_chat(user, "Hack Failed.")
			//	if(prob(5))
			//		user.hack_fails ++
			//		announce_hack_failure(user, "quantum message relay")
			//		log_ability_use(user, "advanced encryption hack (CRITFAIL - title: [reporttitle])")
			//		return
			//	log_ability_use(user, "advanced encryption hack (FAIL - title: [reporttitle])")
			//	return
			log_ability_use(user, "advanced encryption hack (SUCCESS - title: [reporttitle])")
			command_announcement.Announce("[reportbody]", reporttitle, new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1, do_newscast=1, do_print=1)

		if("No")
			if(!reporttitle || !reportbody || !ability_pay(user, price))
				to_chat(user, "Hack Aborted due to no title, no body message, or you do not have enough CPU for this action.")
				return

			log_ability_use(user, "advanced encryption hack")
			// Commented out while trialing the malf ai buffs
			//if(prob(50) && user.hack_can_fail)
			//	to_chat(user, "Hack Failed.")
			//	if(prob(5))
			//		user.hack_fails ++
			//		announce_hack_failure(user, "quantum message relay")
			//		log_ability_use(user, "advanced encryption hack (CRITFAIL - title: [reporttitle])")
			//		return
			//	log_ability_use(user, "advanced encryption hack (FAIL - title: [reporttitle])")
			//	return
			log_ability_use(user, "advanced encryption hack (SUCCESS - title: [reporttitle])")
			to_world("<span class='alert'>New [current_map.company_name] Update available at all communication consoles.</span>")
			to_world(sound('sound/AI/commandreport.ogg'))
			post_comm_message(reporttitle, reportbody)

/datum/game_mode/malfunction/verb/elite_encryption_hack()
	set category = "Software"
	set name = "Elite Encryption Hack"
	set desc = "200 CPU - Allows you to hack station's ALERTCON system, changing alert level. Has high chance of failing."
	var/price = 200
	var/mob/living/silicon/ai/user = usr
	if(!ability_prechecks(user, price))
		return

	var/alert_target = input("Select new alert level:") in list("green", "blue", "red", "delta", "CANCEL")
	if(!alert_target || !ability_pay(user, price) || alert_target == "CANCEL")
		to_chat(user, "Hack Aborted")
		return
	//Reduced from 60-10 to 20-5 while trialing the malf ai buffs
	if(prob(20) && user.hack_can_fail)
		to_chat(user, "Hack Failed.")
		if(prob(5))
			user.hack_fails ++
			announce_hack_failure(user, "alert control system")
			log_ability_use(user, "elite encryption hack (CRITFAIL - [alert_target])")
			return
		log_ability_use(user, "elite encryption hack (FAIL - [alert_target])")
		return
	log_ability_use(user, "elite encryption hack (SUCCESS - [alert_target])")
	set_security_level(alert_target)


/datum/game_mode/malfunction/verb/system_override()
	set category = "Software"
	set name = "System Override"
	set desc = "500 CPU - Begins hacking station's primary firewall, quickly overtaking remaining APC systems. When completed grants access to station's self-destruct mechanism. Network administrators will probably notice this."
	var/price = 500
	var/mob/living/silicon/ai/user = usr
	if (alert(user, "Begin system override? This cannot be stopped once started. The network administrators will probably notice this.", "System Override:", "Yes", "No") != "Yes")
		return
	if (!ability_prechecks(user, price) || !ability_pay(user, price) || user.system_override)
		if(user.system_override)
			to_chat(user, "You already started the system override sequence.")
		return
	log_ability_use(user, "system override (STARTED)")
	var/list/remaining_apcs = list()
	for(var/obj/machinery/power/apc/A in SSmachinery.processing_machines)
		if(!(A.z in current_map.station_levels)) 		// Only station APCs
			continue
		if(A.hacker == user || A.aidisabled) 		// This one is already hacked, or AI control is disabled on it.
			continue
		remaining_apcs += A

	var/duration = (remaining_apcs.len * 100)		// Calculates duration for announcing system
	if(duration > 3000)								// Two types of announcements. Short hacks trigger immediate warnings. Long hacks are more "progressive".
		spawn(0)
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("Info: Abnormal network activity detected. Ongoing hacking attempts detcted. Automatic countermeasures activated. Trace activated.", "Network Monitoring")
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("Notice: Trace Update. Abnormal network activity originating from: Network terminal aboard [current_map.station_name]. External network connections disabled. Trace cancelled.", "Network Monitoring")
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("Warning: Automatic countermeasures ineffective. Breach of primary network firewall imminent.", "Network Monitoring")
			sleep(duration/5)
			if(!user || user.stat == DEAD)
				return
			command_announcement.Announce("Error: Network firewall breached. Network integrity compromised.", "Network Monitoring")
	else
		command_announcement.Announce("Error: Ongoing hacking attempt. Automatic countermeasures ineffective. Network firewall breached. Network integrity compromised. External network connections disabled.", "Network Monitoring")
	to_chat(user, "## BEGINNING SYSTEM OVERRIDE.")
	to_chat(user, "## ESTIMATED DURATION: [round((duration+300)/600)] MINUTES")
	user.hacking = 1
	user.system_override = 1
	// Now actually begin the hack. Each APC takes 10 seconds.
	for(var/obj/machinery/power/apc/A in shuffle(remaining_apcs))
		sleep(100)
		if(!user || user.stat == DEAD)
			return
		if(!A || !istype(A) || A.aidisabled)
			continue
		A.ai_hack(user)
		if(A.hacker == user)
			to_chat(user, "## OVERRIDDEN: [A.name]")

	to_chat(user, "## REACHABLE APC SYSTEMS OVERTAKEN. BYPASSING PRIMARY FIREWALL.")
	sleep(300)
	// Hack all APCs, including those built during hack sequence.
	for(var/obj/machinery/power/apc/A in SSmachinery.processing_machines)
		if((!A.hacker || A.hacker != src) && !A.aidisabled && A.z in current_map.station_levels)
			A.ai_hack(src)

	log_ability_use(user, "system override (FINISHED)")
	to_chat(user, "## PRIMARY FIREWALL BYPASSED. YOU NOW HAVE FULL SYSTEM CONTROL.")
	command_announcement.Announce("Our system administrators just reported that we've been locked out from your control network. Whoever did this now has full access to the station's systems.", "Network Administration Center")
	user.hack_can_fail = 0
	user.hacking = 0
	user.system_override = 2
	user.verbs += new/datum/game_mode/malfunction/verb/ai_destroy_station()


// END ABILITY VERBS
