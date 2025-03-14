/client/proc/configure_access_control()
	set category = "Server"
	set name = "Configure Access Control"

	if (!check_rights(R_SERVER))
		return

	var/datum/browser/config_window = new(usr, "access_control", "Access Control")
	config_window.add_head_content("<title>Access Control</title>")

	var/data = "These settings control who can access the server during this round.<br>"
	data += "They must be reset every single time the server restarts.<br>"
	data += "<b>If you do not know what these do, you shouldn't be touching them!</b><hr>"

	data += "<h2>Hub Visibility Setting:</h2><br>"
	data += "Currently [world.visibility ? "<font color='green'>VISIBLE</font>" : SPAN_WARNING("HIDDEN")]. <a href='byond://?_src_=holder;access_control=hub'>Toggle</a><br><hr>"

	data += "<h2>IP Intel Settings:</h2><br><ul>"
	data += "<li>Current warning level: [GLOB.config.ipintel_rating_bad ? "[GLOB.config.ipintel_rating_bad]" : SPAN_WARNING("DISABLED")]. <a href='byond://?_src_=holder;access_control=intel_bad'>Edit</a></li>"
	data += "<li>Current kick level: [GLOB.config.ipintel_rating_kick ? "[GLOB.config.ipintel_rating_kick]" : SPAN_WARNING("DISABLED")]. <a href='byond://?_src_=holder;access_control=intel_kick'>Edit</a></li>"
	data += "</ul><hr>"

	data += "<h2>Player Age Settings:</h2><br><ul>"
	data += "<li>New players: [GLOB.config.access_deny_new_players ? SPAN_WARNING("DENIED") : "<font color='green'>ALLOWED</font>"]. <a href='byond://?_src_=holder;access_control=new_players;'>Toggle</a></li>"
	data += "<li>Account age restriction: [GLOB.config.access_deny_new_accounts == -1 ? SPAN_WARNING("DISABLED") : "[GLOB.config.access_deny_new_accounts] DAYS"]. <a href='byond://?_src_=holder;access_control=new_accounts;'>Edit</a></li>"
	data += "</ul><hr>"

	data += "<h2>VM Detection Settings:</h2><br><ul>"
	data += "<li>VM identifier count to warn on: [GLOB.config.access_warn_vms ? "[GLOB.config.access_warn_vms]" : SPAN_WARNING("DISABLED")]. <a href='byond://?_src_=holder;access_control=vm_warn;'>Edit</a></li>"
	data += "<li>VM identifier count to kick on: [GLOB.config.access_deny_vms ? "[GLOB.config.access_deny_vms]" : SPAN_WARNING("DISABLED")]. <a href='byond://?_src_=holder;access_control=vm_kick;'>Edit</a></li>"
	data += "</ul>"

	data += "<h2>Guest join settings:</h2><br><ul>"
	data += "<li>Guests [(GLOB.config.guests_allowed || GLOB.config.external_auth) ? "<font color='green'>CAN</font>" : SPAN_WARNING("CAN NOT")] join.</li>"
	data += "<li>Guests [GLOB.config.guests_allowed ? "<font color='green'>CAN</font>" : SPAN_WARNING("CAN NOT")] play. <a href='byond://?_src_=holder;access_control=guest;'>Toggle</a></li>"
	data += "<li>External authetification: [GLOB.config.external_auth ? "<font color='green'>ENABLED</font>" : SPAN_WARNING("DISABLED")]. <a href='byond://?_src_=holder;access_control=external_auth;'>Toggle</a></li>"
	data += "</ul>"

	config_window.set_user(src.mob)
	config_window.set_content(data)
	config_window.open()

/datum/admins/proc/access_control_topic(control)
	if (!control)
		to_chat(usr, SPAN_WARNING("No control option sent. Cancelling."))
		return

	if (!check_rights(R_SERVER))
		log_and_message_admins("has tried editing access control without the permissions to do so.")
		return

	switch(control)
		if ("intel_bad")
			var/num = input("Please set the new threshold for warning based on IPintel (0 to disable).", "New Threshold", GLOB.config.ipintel_rating_kick) as num
			if (num < 0 || num > 1)
				to_chat(usr, SPAN_WARNING("Invalid number. Cancelling."))
				return

			GLOB.config.ipintel_rating_bad = num
			if (num)
				log_and_message_admins("has set the IPIntel warn threshold to [num].")
			else
				log_and_message_admins("has disabled warn based on IPIntel.")
		if ("intel_kick")
			var/num = input("Please set the new threshold for kicking based on IPintel (0 to disable).", "New Threshold", GLOB.config.ipintel_rating_kick) as num
			if (num < 0 || num > 1)
				to_chat(usr, SPAN_WARNING("Invalid number. Cancelling."))
				return

			GLOB.config.ipintel_rating_kick = num
			if (num)
				log_and_message_admins("has set the IPIntel kick threshold to [num].")
			else
				log_and_message_admins("has disabled kicking based on IPIntel.")
		if ("new_players")
			GLOB.config.access_deny_new_players = !GLOB.config.access_deny_new_players
			log_and_message_admins("has [GLOB.config.access_deny_new_players ? "ENABLED" : "DISABLED"] the kicking of new players.")
		if ("new_accounts")
			var/num = input("Please set the new threshold for denying access based on BYOND account age. (-1 to disable.)", "New Threshold", GLOB.config.access_deny_new_accounts) as num
			if (num < 0 && num != -1)
				to_chat(usr, SPAN_WARNING("Invalid number. Cancelling."))
				return

			GLOB.config.access_deny_new_accounts = num
			if (num != -1)
				log_and_message_admins("has set the access barrier for new BYOND accounts to [num] days.")
			else
				log_and_message_admins("has disabled kicking based on BYOND account age.")
		if ("vm_warn")
			var/num = input("Please set the new threshold for warning on login based on positive VM identifiers. (0 to disable.)", "New Threshold") in list(0, 1, 2)

			GLOB.config.access_warn_vms = num
			if (num)
				log_and_message_admins("has set players with [GLOB.config.access_warn_vms] positive identifiers out of 2 for VM usage to be warned.")
			else
				log_and_message_admins("has disabled warnings based on potential VM usage.")
		if ("vm_kick")
			var/num = input("Please set the new threshold for warning on login based on positive VM identifiers. (0 to disable.)", "New Threshold") in list(0, 1, 2)

			GLOB.config.access_deny_vms = num
			if (num)
				log_and_message_admins("has set players with [GLOB.config.access_deny_vms] positive identifiers out of 2 for VM usage to be warned.")
			else
				log_and_message_admins("has disabled warnings based on potential VM usage.")
		if ("hub")
			togglehubvisibility()
		if ("external_auth")
			GLOB.config.external_auth = !GLOB.config.external_auth
		if ("guest")
			GLOB.config.guests_allowed = !GLOB.config.guests_allowed
		else
			to_chat(usr, SPAN_DANGER("Unknown control message sent. Cancelling."))

	owner.configure_access_control()
