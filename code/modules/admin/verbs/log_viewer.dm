ADMIN_VERB(log_viewer_new, R_ADMIN|R_MOD, "View Round Logs", "View the round logs.", ADMIN_CATEGORY_MAIN)
	if(!logger)
		to_chat(user, SPAN_WARNING("The structured logger is not initialized."))
		return

	logger.ui_interact(user.mob)
