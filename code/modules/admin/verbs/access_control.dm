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
	data += "Currently [world.visibility ? "<font color='green'>VISIBLE</font>" : "<font color='red'>HIDDEN</font>"]. <a href='?_src_=holder;access_control=hub'>Toggle</a><br><hr>"

	data += "<h2>IP Intel Settings:</h2><br><ul>"
	data += "<li>Current warning level: [config.ipintel_rating_bad ? "[config.ipintel_rating_bad]" : "<font color='red'>DISABLED</font>"]. <a href='?_src_=holder;access_control=intel_bad'>Edit</a></li>"
	data += "<li>Current kick level: [config.ipintel_rating_kick ? "[config.ipintel_rating_kick]" : "<font color='red'>DISABLED</font>"]. <a href='?_src_=holder;access_control=intel_kick'>Edit</a></li>"
	data += "</ul><hr>"

	data += "<h2>Player Age Settings:</h2><br><ul>"
	data += "<li>New players: [config.access_deny_new_players ? "<font color='red'>DENIED</font>" : "<font color='green'>ALLOWED</font>"]. <a href='?_src_=holder;access_control=new_players;'>Toggle</a></li>"
	data += "<li>Account age restriction: [config.access_deny_new_accounts == -1 ? "<font color='red'>DISABLED</font>" : "[config.access_deny_new_accounts] DAYS"]. <a href='?_src_=holder;access_control=new_accounts;'>Edit</a></li>"
	data += "</ul><hr>"

	data += "<h2>VM Detection Settings:</h2><br><ul>"
	data += "<li>VM identifier count to warn on: [config.access_warn_vms ? "[config.access_warn_vms]" : "<font color='red'>DISABLED</font>"]. <a href='?_src_=holder;access_control=vm_warn;'>Edit</a></li>"
	data += "<li>VM identifier count to kick on: [config.access_deny_vms ? "[config.access_deny_vms]" : "<font color='red'>DISABLED</font>"]. <a href='?_src_=holder;access_control=vm_kick;'>Edit</a></li>"
	data += "</ul>"

	data += "<h2>Guest join settings:</h2><br><ul>"
	data += "<li>Guests [(config.guests_allowed || config.external_auth) ? "<font color='green'>CAN</font>" : "<font color='red'>CAN NOT</font>"] join.</li>"
	data += "<li>Guests [config.guests_allowed ? "<font color='green'>CAN</font>" : "<font color='red'>CAN NOT</font>"] play. <a href='?_src_=holder;access_control=guest;'>Toggle</a></li>"
	data += "<li>External authetification: [config.external_auth ? "<font color='green'>ENABLED</font>" : "<font color='red'>DISABLED</font>"]. <a href='?_src_=holder;access_control=external_auth;'>Toggle</a></li>"
	data += "</ul>"

	config_window.set_user(src.mob)
	config_window.set_content(data)
	config_window.open()

/datum/admins/proc/access_control_topic(control)
	if (!control)
		to_chat(usr, "<span class='warning'>No control option sent. Cancelling.</span>")
		return

	if (!check_rights(R_SERVER))
		log_and_message_admins("has tried editing access control without the permissions to do so.")
		return

	switch(control)
		if ("intel_bad")
			var/num = input("Please set the new threshold for warning based on IPintel (0 to disable).", "New Threshold", config.ipintel_rating_kick) as num
			if (num < 0 || num > 1)
				to_chat(usr, "<span class='warning'>Invalid number. Cancelling.</span>")
				return

			config.ipintel_rating_bad = num
			if (num)
				log_and_message_admins("has set the IPIntel warn threshold to [num].")
			else
				log_and_message_admins("has disabled warn based on IPIntel.")
		if ("intel_kick")
			var/num = input("Please set the new threshold for kicking based on IPintel (0 to disable).", "New Threshold", config.ipintel_rating_kick) as num
			if (num < 0 || num > 1)
				to_chat(usr, "<span class='warning'>Invalid number. Cancelling.</span>")
				return

			config.ipintel_rating_kick = num
			if (num)
				log_and_message_admins("has set the IPIntel kick threshold to [num].")
			else
				log_and_message_admins("has disabled kicking based on IPIntel.")
		if ("new_players")
			config.access_deny_new_players = !config.access_deny_new_players
			log_and_message_admins("has [config.access_deny_new_players ? "ENABLED" : "DISABLED"] the kicking of new players.")
		if ("new_accounts")
			var/num = input("Please set the new threshold for denying access based on BYOND account age. (-1 to disable.)", "New Threshold", config.access_deny_new_accounts) as num
			if (num < 0 && num != -1)
				to_chat(usr, "<span class='warning'>Invalid number. Cancelling.</span>")
				return

			config.access_deny_new_accounts = num
			if (num != -1)
				log_and_message_admins("has set the access barrier for new BYOND accounts to [num] days.")
			else
				log_and_message_admins("has disabled kicking based on BYOND account age.")
		if ("vm_warn")
			var/num = input("Please set the new threshold for warning on login based on positive VM identifiers. (0 to disable.)", "New Threshold") in list(0, 1, 2)

			config.access_warn_vms = num
			if (num)
				log_and_message_admins("has set players with [config.access_warn_vms] positive identifiers out of 2 for VM usage to be warned.")
			else
				log_and_message_admins("has disabled warnings based on potential VM usage.")
		if ("vm_kick")
			var/num = input("Please set the new threshold for warning on login based on positive VM identifiers. (0 to disable.)", "New Threshold") in list(0, 1, 2)

			config.access_deny_vms = num
			if (num)
				log_and_message_admins("has set players with [config.access_deny_vms] positive identifiers out of 2 for VM usage to be warned.")
			else
				log_and_message_admins("has disabled warnings based on potential VM usage.")
		if ("hub")
			togglehubvisibility()
		if ("external_auth")
			config.external_auth = !config.external_auth
		if ("guest")
			config.guests_allowed = !config.guests_allowed
		else
			to_chat(usr, "<span class='danger'>Unknown control message sent. Cancelling.</span>")

	owner.configure_access_control()
