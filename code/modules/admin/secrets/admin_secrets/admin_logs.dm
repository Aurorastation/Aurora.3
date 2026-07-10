/datum/admin_secret_item/admin_secret/admin_logs
	name = "Admin Logs"

/datum/admin_secret_item/admin_secret/admin_logs/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = "<B>Admin Log<HR></B>"

	var/list/admin_logs
	if(logger && logger.log_categories)
		var/datum/log_category/admin_category = logger.log_categories[LOG_CATEGORY_ADMIN]
		if(admin_category)
			admin_logs = admin_category.entries

	if(length(admin_logs))
		for(var/datum/log_entry/entry as anything in admin_logs)
			dat += "<li>[entry.to_readable_text()]</li>"
	else
		dat += "No-one has done anything this round!"
	user << browse(HTML_SKELETON(dat), "window=admin_log")
