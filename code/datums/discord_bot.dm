#define CHAN_ADMIN		"channel_admin"
#define CHAN_CCIAA		"channel_cciaa"
#define CHAN_ANNOUNCE	"channel_announce"

#define SEND_OK			0
#define SEND_TIMEOUT	1
#define ERROR_PROC		2
#define ERROR_CURL		3
#define ERROR_HTTP		4

var/datum/discord_bot/discord_bot = null

/hook/startup/proc/initialize_discord_bot()
	if (discord_bot)
		// This shouldn't be possible, but sure!
		return 0

	discord_bot = new()

	config.load("config/discord.txt", "discord")

	discord_bot.update_channels()

	return 1

/datum/discord_bot
	var/list/channels_to_group = list()		// Group flag -> list of channel datums map.
	var/list/channels = list()				// Channel ID -> channel datum map. Will ensure that only one datum per channel ID exists.

	var/list/roles_map = list()				// Role ID -> role name map.
	var/datum/discord_channel/invite = null	// The channel datum where the ingame Join Channel button will link to.

	var/active = 0
	var/auth_token = ""

	var/robust_debug = 0

	// Lazy man's rate limiting vars
	var/queue_push_planned = 0
	var/list/queue = list()

/datum/discord_bot/proc/update_channels()
	if (!active)
		return 1

	if (!establish_db_connection(dbcon))
		log_debug("BOREALIS: Failed to update channels due to missing database.")
		return 2

	// Reset the channel lists.
	channels_to_group.Cut()
	channels.Cut()

	var/DBQuery/channel_query = dbcon.NewQuery("SELECT channel_group, channel_id, pin_flag, server_id FROM discord_channels")
	channel_query.Execute()

	while (channel_query.NextRow())
		// Create the channel map.
		if (isnull(channels_to_group[channel_query.item[1]]))
			channels_to_group[channel_query.item[1]] = list()

		// Create an entry in the roles map for the server ID.
		if (isnull(roles_map[channel_query.item[4]]))
			roles_map[channel_query.item[4]] = list()

		var/datum/discord_channel/B = channels[channel_query.item[2]]

		// We don't have this channel datum yet.
		if (isnull(B))
			B = new(channel_query.item[2], channel_query.item[3], channel_query.item[4])

			if (!B)
				log_debug("BOREALIS: Bad channel data during update channels. [jointext(channel_query.item, ", ")].")
				continue

			channels[channel_query.item[2]] = B

		// Add the channel to the required lists.
		channels_to_group[channel_query.item[1]] += B

	log_debug("BOREALIS: Channels updated successfully.")
	return 0

/datum/discord_bot/proc/send_message(var/channel_group, var/message)
	if (!active || !auth_token)
		return

	if (!channel_group || !channels.len || isnull(channels_to_group[channel_group]))
		return

	if (!message)
		return

	if (length(message) > 2000)
		message = copytext(message, 1, 2001)

	// Let's run it through the proper JSON encoder, just in case of special characters.
	message = json_encode(list("content" = message))

	var/list/A = channels_to_group[channel_group]
	var/list/sent = list()
	for (var/B in A)
		var/datum/discord_channel/channel = B
		if (channel.send_message_to(auth_token, message) == SEND_TIMEOUT)
			// Whoopsies, rate limited.
			// Set up the queue.
			queue.Add(list(message, A - sent))

			if (!queue_push_planned)
				// Schedule a push.
				queue_push_planned = 1
				spawn (100)
					push_queue()

			// And exit.
			return
		else
			sent += channel

	if (robust_debug)
		log_debug("BOEALIS: Message sent to [channel_group]. JSON body: '[message]'")

/datum/discord_bot/proc/retreive_pins()
	if (!active || !auth_token)
		return

	if (!channels.len || isnull(channels_to_group["pins"]))
		return



/datum/discord_bot/proc/send_to_admins(message)
	send_message(CHAN_ADMIN, message)

/datum/discord_bot/proc/send_to_cciaa(message)
	send_message(CHAN_CCIAA, message)

/datum/discord_bot/proc/send_to_announce(message)
	send_message(CHAN_ANNOUNCE, message)

/datum/discord_bot/proc/push_queue()
	// What facking queue.
	if (!queue || !queue.len)
		queue_push_planned = 0

		if (robust_debug)
			log_debug("BOREALIS: Attempted to push a null length queue.")
		return

	// A[1] - message body.
	// A[2] - list of channels to send to.
	var/message
	var/list/destinations
	for (var/list/A in queue)
		message = A[1]
		destinations = A[2]

		for (var/B in destinations)
			var/datum/discord_channel/channel = B
			switch (channel.send_message_to(auth_token, message))
				if (SEND_TIMEOUT)
					// Limited again. Reschedule.
					spawn (100)
						push_queue()

					return
				else
					destinations.Remove(channel)

		queue.Remove(A)

	// Reset the var once we're done with the queue.
	queue_push_planned = 0

// A holder class for channels.
/datum/discord_channel
	var/id = ""
	var/server_id = ""
	var/pin_flag = 0
	var/invite_url = ""

/*
 * Constructor
 *
 * @param text _id	- the
 * @param text _sid	- the sanitized message content to be sent.
 * @param num _pin	- a specific return code for the discord_bot to handle.
 */
/datum/discord_channel/New(var/_id, var/_sid, var/_pin)
	id = _id
	server_id = _sid

	if (_pin)
		pin_flag = _pin

/*
 * Proc send_message_to
 * Sends a message to the channel.
 *
 * @param text token	- the authorization token to be used for the requests.
 * @param text message	- the sanitized message content to be sent.
 * @return num			- a specific return code for the discord_bot to handle.
 */
/datum/discord_channel/proc/send_message_to(var/token, var/message)
	if (!token || !message)
		return ERROR_PROC

	var/res = send_post_request("https://discordapp.com/api/channels/[id]/messages", message, "Authorization: Bot [token]", "Content-Type: application/json")

	switch (res)
		if (-1)
			return ERROR_PROC

		if (200)
			return SEND_OK

		if (429)
			return SEND_TIMEOUT

		if (0 to 90)
			log_debug("BOREALIS: cURL error while forwarding message to Discord API: [res]. Message body: [message].")
			return ERROR_CURL

		if (100 to 600)
			log_debug("BOREALIS: HTTP error while forwarding message to Discord API: [res]. Channel: [id]. Message body: [message].")
			return ERROR_HTTP

		else
			log_debug("BOREALIS: Unknown response code while forwarding message to Discord API: [res].")
			return ERROR_PROC

/*
 * Proc get_pins
 * Retreives a list of pinned messages from the channel.
 *
 * @param text token	- the authorization token to be used for the requests.
 * @return mixed		- 2d array of content upon success, in format: list(list("author" = text, "content" = text)).
 *						  Num upon failure.
 */
/datum/discord_channel/proc/get_pins(var/token)
	var/res = send_get_request("https://discordapp.com/api/channels/[id]/pins", "Authorization: Bot [token]")

	// Is a number, so an error code.
	if (isnum(res))
		switch (res)
			if (-1)
				return ERROR_PROC

			if (0 to 90)
				log_debug("BOREALIS: cURL error while fetching pins from the Discord API: [res].")
				return ERROR_CURL

			if (100 to 600)
				log_debug("BOREALIS: HTTP error while fetching pins from the Discord API: [res].")
				return ERROR_HTTP

			else
				log_debug("BOREALIS: Unknown response code while fetching pins from the Discord API: [res].")
				return ERROR_PROC
	else
		var/list/A = res
		var/list/pinned_messages = list()

		// Begin processing the list structure delivered back to us from send_get_request.
		for (var/list/B in A)
			var/content = B["content"]

			// We have mentions to take care of.
			if (!isnull(B["mentions"]))
				var/list/mentions = B["mentions"]

				for (var/list/C in mentions)
					content = replacetextEx(content, "<@[C["id"]]>", C["username"])

			// Role mentions are up next.
			if (!isnull(B["mention_roles"]))
				var/list/mentions = B["mention_roles"]

				for (var/C in mentions)
					content = replacetextEx(content, "<@&[C]>", discord_bot.roles_map[C])

			pinned_messages += list(list("author" = B["author"]["username"], "content" = content))

		return pinned_messages

/*
 * Proc get_invite
 * Retreives (or creates if none found) an invite URL to the specific channel.
 *
 * @param text token	- the authorization token to be used for the requests.
 * @return mixed		- text upon success, the link to the invite; num upon failure.
 */
/datum/discord_channel/proc/get_invite(var/token)
	if (invite_url)
		return invite_url

	var/res = send_get_request("https://discordapp.com/api/channels/[id]/invites", "Authorization: Bot [token]")

	// Is a number, so an error code.
	if (isnum(res))
		switch (res)
			if (-1)
				return ERROR_PROC

			if (0 to 90)
				log_debug("BOREALIS: cURL error while fetching pins from the Discord API: [res].")
				return ERROR_CURL

			if (100 to 600)
				log_debug("BOREALIS: HTTP error while fetching pins from the Discord API: [res].")
				return ERROR_HTTP

			else
				log_debug("BOREALIS: Unknown response code while fetching pins from the Discord API: [res].")
				return ERROR_PROC
	else
		var/list/A = res

		// No length to return data, but a valid 200 return header.
		// So we simply have no invites active. Make one!
		if (!A || !A.len)
			return create_invite(token)

		var/best_age = A[1]["max_age"]
		var/code = A[1]["code"]

		// Find the best invite.
		// Why? Because round time expires are lame, I guess.
		if (best_age != 0)
			for (var/i = 2, i < A.len, i++)
				if (A[i]["max_age"] == 0)
					code = A[i]["code"]
					break

				if (best_age < A[i]["max_age"])
					best_Age = A[i]["max_age"]
					code = A[i]["code"]

		// Sanity check for debug I guess.
		if (!code)
			log_debug("BOREALIS: Retreived an empty invite. This should not happen. Response object: [json_encode(A)]")

		// Save the URL for later retreival.
		invite_url = "https://discord.gg/[code]"
		return invite_url



#undef CHAN_ADMIN
#undef CHAN_CCIAA
#undef CHAN_ANNOUNCE

#undef SEND_OK
#undef SEND_TIMEOUT
#undef ERROR_PROC
#undef ERROR_CURL
#undef ERROR_HTTP
