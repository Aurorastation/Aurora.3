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

		if (!config.use_discord_pins)
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

	if (!config.use_discord_pins)
	// The initialization of memos in case use_discord_pins == 1 is done in discord_bot.dm
	// Primary reason is to avoid null references when the bot isn't created yet.
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

/datum/server_greeting/proc/update_pins()
	set background = 1

	var/list/temp_list = discord_bot.retreive_pins()

	// A is a number in a string form
	// temp_list[A] is a list of lists.
	for (var/A in temp_list)
		var/list/memos = temp_list[A]
		var/flag = text2num(A)

		memo_list += new /datum/memo_datum(memos, flag)

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
			if (config.use_discord_pins)
				return 0

			memo_list[new_value[1]] = list("date" = time2text(world.realtime, "DD-MMM-YYYY"), "content" = new_value[2])

		if ("memo_delete")
			if (config.use_discord_pins)
				return 0

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

	if (user.holder && user.prefs.memo_hash != get_memo_hash(user))
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

	user.info_sent = 0

	// Make sure the user has the welcome screen assets.
	var/datum/asset/welcome = get_asset_datum(/datum/asset/simple/misc)
	welcome.send(user)

	user << browse('html/templates/welcome_screen.html', "window=greeting;size=800x500")

/*
 * A proc used to close the server greeting window for a user.
 * Args:
 * - var/user client
 * - var/reason text
 */
/datum/server_greeting/proc/close_window(var/client/user, var/reason)
	if (!user)
		return

	if (reason)
		to_chat(user, span("notice", reason))

	user << browse(null, "window=greeting")

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

	var/list/data = list("div" = "", "content" = "", "update" = 1, "changeHash" = null)

	if (outdated_info & OUTDATED_NOTE)
		to_chat(user, output("#note-placeholder", "greeting.browser:RemoveElement"))

		data["div"] = "#note"
		data["update"] = 1

		for (var/datum/client_notification/a in user.prefs.notifications)
			data["content"] = a.get_html()
			to_chat(user, output(JS_SANITIZE(data), "greeting.browser:AddContent"))

	if (!user.holder)
		to_chat(user, output("#memo-tab", "greeting.browser:RemoveElement"))
	else
		if (outdated_info & OUTDATED_MEMO)
			data["update"] = 1
			data["changeHash"] = get_memo_hash(user)
		else
			data["update"] = 0
			data["changeHash"] = null

		data["div"] = "#memo"
		data["content"] = get_memo_content(user)
		to_chat(user, output(JS_SANITIZE(data), "greeting.browser:AddContent"))

	if (outdated_info & OUTDATED_MOTD)
		data["update"] = 1
		data["changeHash"] = motd_hash
	else
		data["update"] = 0
		data["changeHash"] = null

	data["div"] = "#motd"
	data["content"] = motd
	to_chat(user, output(JS_SANITIZE(data), "greeting.browser:AddContent"))

	data["div"] = "#testmerges"
	data["content"] = revdata.greeting_info

	if (revdata.test_merges.len)
		data["update"] = 1
	else
		data["update"] = 0
	data["changeHash"] = null
	to_chat(user, output(JS_SANITIZE(data), "greeting.browser:AddContent"))

/*
 * Basically the Topic proc for the greeting datum.
 */
/datum/server_greeting/proc/handle_call(var/href_list, var/client/C)
	if (!href_list || !href_list["command"] || !C)
		return

	switch (href_list["command"])
		if ("request_data")
			send_to_javascript(C)

/*
 * Gets the appropriate memo hash for the memo system in use.
 * Args:
 * - var/C client
 * Returns:
 * - string
 */
/datum/server_greeting/proc/get_memo_hash(var/client/C)
	if (!C || !C.holder)
		return ""

	if (!config.use_discord_pins)
		return memo_hash

	var/joint_checksum = ""
	for (var/A in memo_list)
		var/datum/memo_datum/memo = A
		if (C.holder.rights & memo.flag)
			joint_checksum += memo.hash

	return md5(joint_checksum)

/*
 * Gets the appropriate memo content for the memo system in use.
 * Args:
 * - var/C client
 * Returns:
 * - string if old memo system is used (config.use_discord_pins = 0)
 * - list of strings if new memo system is used
 */
/datum/server_greeting/proc/get_memo_content(var/client/C)
	if (!C || !C.holder)
		return ""

	if (!config.use_discord_pins)
		return memo

	var/list/content = list()
	for (var/A in memo_list)
		var/datum/memo_datum/memo = A
		if (C.holder.rights & memo.flag)
			content += memo.contents

	return content

/datum/memo_datum
	var/contents
	var/hash
	var/flag

/datum/memo_datum/New(var/list/input = list(), var/_flag)
	flag = _flag

	// Yes. This is an unfortunately acceptable way of doing it.
	// Why? Because you cannot use numbers as indexes in an assoc list without fucking DM.
	var/static/list/flags_to_divs = list("[R_ADMIN]" = "danger",
										"[R_MOD]" = "warning",
										"[(R_MOD|R_ADMIN)]" = "warning",
										"[R_CCIAA]" = "info",
										"[R_DEV]" = "info")

	if (input.len)
		contents = "<div class='alert alert-[flags_to_divs["[flag]"]]'>"
		for (var/i = 1, i <= input.len, i++)
			contents += "<b>[input[i]["author"]]</b> wrote:<br>[nl2br(input[i]["content"])]"

			if (i < input.len)
				contents += "<hr></hr>"

		contents += "</div>"
	else
		contents = ""

	hash = md5(contents)

#undef OUTDATED_NOTE
#undef OUTDATED_MEMO
#undef OUTDATED_MOTD

#undef MEMOFILE

#undef JS_SANITIZE
