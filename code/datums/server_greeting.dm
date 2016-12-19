/*
 * Server greeting datum.
 * Contains the following information:
 * - hashes for the message of the day and staff memos
 * - the current message of the day and staff memos
 * - the fully parsed welcome screen HTML data
 *
 * #TODO_LATER: Update this to be reliant on the game, and not an HTML template, whenever we update to TGui. Less hacks involved, then.
 */

#define MEMOFILE "data/greeting.sav"

#define OUTDATED_MOTD 1
#define OUTDATED_MEMO 2
#define OUTDATED_NOTE 4

#define JS_SANITIZE(msg) list2params(list(json_encode(msg)))

/datum/server_greeting
	// Hashes to figure out if we need to display the greeting message.
	// These correspond to motd_hash and memo_hash on /datum/preferences for each client.
	var/motd_hash = ""
	var/memo_hash = ""

	// The stored strings of general subcomponents.
	var/motd = "<center>No new announcements to showcase.</center>"

	var/memo_list[] = list()
	var/memo = "<center>No memos have been posted.</center>"

	// Cached outdated information.
	var/list/client_cache = list()

/datum/server_greeting/New()
	..()

	load_from_file()

/*
 * Populates variables from save file, and loads the raw HTML data.
 * Needs to be called at least once for successful initialization.
 */
/datum/server_greeting/proc/load_from_file()
	var/savefile/F = new(MEMOFILE)
	if (F)
		if (F["motd"])
			F["motd"] >> motd

		if (F["memo"])
			F["memo"] >> memo_list

	update_data()

/*
 * A helper to regenerate the hashes for all data fields.
 * As well as to reparse the staff memo list.
 * Separated for the sake of avoiding the duplication of code.
 */
/datum/server_greeting/proc/update_data()
	if (motd)
		motd_hash = md5(motd)
	else
		motd = initial(motd)
		motd_hash = ""

	if (memo_list.len)
		memo = ""
		for (var/ckey in memo_list)
			var/data = {"<p><b>[ckey]</b> wrote on [memo_list[ckey]["date"]]:<br>
			[memo_list[ckey]["content"]]</p>"}

			memo += data

		memo_hash = md5(memo)
	else
		memo = initial(memo)
		memo_hash = ""

/*
 * Helper to update the MoTD or memo contents.
 * Args:
 * - var/change string
 * - var/new_value mixed
 * Returns:
 * - 1 upon success
 * - 0 upon failure
 */
/datum/server_greeting/proc/update_value(var/change, var/new_value)
	if (!change || !new_value)
		return 0

	switch (change)
		if ("motd")
			motd = new_value

		if ("memo_write")
			memo_list[new_value[1]] = list("date" = time2text(world.realtime, "DD-MMM-YYYY"), "content" = new_value[2])

		if ("memo_delete")
			if (memo_list[new_value])
				memo_list -= new_value
			else
				return 0

		else
			return 0

	var/savefile/F = new(MEMOFILE)
	F["motd"] << motd
	F["memo"] << memo_list

	update_data()

	return 1

/*
 * Helper proc to determine whether or not we need to show the greeting window to a user.
 * Args:
 * - var/user client
 * Returns:
 * - int
 */
/datum/server_greeting/proc/find_outdated_info(var/client/user, var/force_eval = 0)
	if (!user || !user.prefs)
		return 0

	if (!force_eval && !isnull(client_cache[user]))
		return client_cache[user]

	var/outdated_info = 0

	if (motd_hash && user.prefs.motd_hash != motd_hash)
		outdated_info |= OUTDATED_MOTD

	if (user.holder && memo_hash && user.prefs.memo_hash != memo_hash)
		outdated_info |= OUTDATED_MEMO

	if (user.prefs.notifications.len)
		outdated_info |= OUTDATED_NOTE

	client_cache[user] = outdated_info

	return outdated_info

/*
 * A proc used to open the server greeting window for a user.
 * Args:
 * - var/user client
 * - var/outdated_info int
 */
/datum/server_greeting/proc/display_to_client(var/client/user)
	if (!user)
		return

	user << browse('html/templates/welcome_screen.html', "window=greeting;size=640x500")

/*
 * Sends data to the JS controllers used in the server greeting.
 * Also updates the user's preferences, if any of the hashes were out of date.
 * Args:
 * - var/user client
 * - var/outdated_info int
 */
/datum/server_greeting/proc/send_to_javascript(var/client/user)
	if (!user)
		return

	// This is fine now, because it uses cached information.
	var/outdated_info = server_greeting.find_outdated_info(user)

	var/save_prefs = 0
	var/list/data = list("div" = "", "content" = "", "update" = 1)

	if (outdated_info & OUTDATED_NOTE)
		user << output("#note-placeholder", "greeting.browser:RemoveElement")

		data["div"] = "#note"
		data["update"] = 1

		for (var/datum/client_notification/a in user.prefs.notifications)
			data["content"] = a.get_html()
			user << output(JS_SANITIZE(data), "greeting.browser:AddContent")

	if (!user.holder)
		user << output("#memo-tab", "greeting.browser:RemoveElement")
	else
		if (outdated_info & OUTDATED_MEMO)
			data["update"] = 1
			user.prefs.memo_hash = memo_hash
			save_prefs = 1
		else
			data["update"] = 0

		data["div"] = "#memo"
		data["content"] = memo
		user << output(JS_SANITIZE(data), "greeting.browser:AddContent")

	if (outdated_info & OUTDATED_MOTD)
		data["update"] = 1
		user.prefs.motd_hash = motd_hash
		save_prefs = 1
	else
		data["update"] = 0

	data["div"] = "#motd"
	data["content"] = motd
	user << output(JS_SANITIZE(data), "greeting.browser:AddContent")

	if (save_prefs)
		user.prefs.save_preferences()

/*
 * Basically the Topic proc for the greeting datum.
 */
/datum/server_greeting/proc/handle_call(var/href_list, var/client/C)
	if (!href_list || !href_list["command"] || !C)
		return

	switch (href_list["command"])
		if ("request_data")
			send_to_javascript(C)

#undef OUTDATED_NOTE
#undef OUTDATED_MEMO
#undef OUTDATED_MOTD

#undef MEMOFILE
