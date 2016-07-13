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

/datum/server_greeting
	// Hashes to figure out if we need to display the greeting message.
	// These correspond to motd_hash and memo_hash on /datum/preferences for each client.
	var/motd_hash = ""
	var/memo_hash = ""

	// The stored strings of general subcomponents.
	var/motd = ""
	var/memo_list[] = list()
	var/memo = ""

	var/raw_data_user = ""
	var/raw_data_staff = ""
	// The near-final string to be displayed.
	// Only one placeholder remains: <!--notifications-->.
	var/user_data = ""
	var/staff_data = ""

/datum/server_greeting/New()
	..()

	load_from_file()

	prepare_data()

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

	raw_data_staff = file2text('html/templates/welcome_screen.html')

	// This is a lazy way, but it disables the user from being able to see the memo button.
	var/staff_button = "<li role=\"presentation\" id=\"memo-tab\"><a href=\"#memo\" aria-controls=\"memo\" role=\"tab\" data-toggle=\"tab\">Staff Memos</a></li>"
	raw_data_user = replacetextEx(raw_data_staff, staff_button, "")

/*
 * Generates hashes, placeholders, and reparses var/memo.
 * Then updates staff_data and user_data with the new contents.
 * To be called after load_from_file or update_value.
 */
/datum/server_greeting/proc/prepare_data()
	if (!motd)
		motd = "<center>No new announcements to showcase.</center>"
		motd_hash = ""
	else
		motd_hash = md5(motd)

	memo = ""

	if (memo_list.len)
		for (var/ckey in memo_list)
			var/data = {"
			<p><b>[ckey]</b> wrote on [memo_list[ckey]["date"]]:<br>
			[memo_list[ckey]["content"]]</p>
			"}

			memo += data

		memo_hash = md5(memo)
	else
		memo = "<center>No memos have been posted.</center>"
		memo_hash = ""

	var/html_one = raw_data_staff
	html_one = replacetextEx(html_one, "<!--motd-->", motd)
	html_one = replacetextEx(html_one, "<!--memo-->", memo)
	staff_data = html_one

	var/html_two = raw_data_user
	html_two = replacetextEx(html_two, "<!--motd-->", motd)
	user_data = html_two

	return

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
			motd_hash = md5(new_value)

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

	prepare_data()

	return 1

/*
 * Helper proc to determine whether or not we need to show the greeting window to a user.
 * Args:
 * - var/user client
 * Returns:
 * - int
 */
/datum/server_greeting/proc/find_outdated_info(var/client/user)
	if (!user || !user.prefs)
		return 0

	var/outdated_info = 0

	if (motd_hash && user.prefs.motd_hash != motd_hash)
		outdated_info |= OUTDATED_MOTD

	if (user.holder && memo_hash && user.prefs.memo_hash != memo_hash)
		outdated_info |= OUTDATED_MEMO

	if (user.prefs.notifications.len)
		outdated_info |= OUTDATED_NOTE

	return outdated_info

/*
 * Composes the final message and displays it to the user.
 * Also clears the user's notifications, should he have any.
 */
/datum/server_greeting/proc/display_to_client(var/client/user, var/outdated_info = 0)
	if (!user)
		return

	var/notifications = "<div class=\"row\"><div class=\"alert alert-info\">You do not have any notifications to show.</div></div>"
	var/list/outdated_tabs = list()
	var/save_prefs = 0

	if (outdated_info & OUTDATED_NOTE)
		outdated_tabs += "#note-tab"

		notifications = ""
		for (var/datum/client_notification/a in user.prefs.notifications)
			notifications += a.get_html()

	if (outdated_info & OUTDATED_MEMO)
		outdated_tabs += "#memo-tab"
		user.prefs.memo_hash = memo_hash
		save_prefs = 1

	if (outdated_info & OUTDATED_MOTD)
		outdated_tabs += "#motd-tab"
		user.prefs.motd_hash = motd_hash
		save_prefs = 1

	var/data = user_data

	if (user.holder)
		data = staff_data

	data = replacetextEx(data, "<!--note-->", notifications)

	if (outdated_tabs.len)
		var/tab_string = json_encode(outdated_tabs)
		data = replacetextEx(data, "var updated_tabs = \[\]", "var updated_tabs = [tab_string]")

	user << browse(data, "window=welcome_screen;size=640x500")

	if (save_prefs)
		user.prefs.handle_preferences_save(user)

#undef OUTDATED_NOTE
#undef OUTDATED_MEMO
#undef OUTDATED_MOTD

#undef MEMOFILE
