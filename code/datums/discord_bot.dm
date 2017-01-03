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
	var/list/channels_to_group = list()
	var/list/channels = list()

	var/list/roles_map = list()

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

	var/list/A
	while (channel_query.NextRow())
		// Create the channel map.
		if (isnull(channels_to_group[channel_query.item[1]]))
			channels_to_group[channel_query.item[1]] = list()

		// Create an entry in the roles map for the server ID.
		if (isnull(roles_map[channel_query.item[4]]))
			roles_map[channel_query.item[4]] = list()

		var/datum/discord_channel/B = new(text2num(channel_query.item[2]), channel_query.item[1], text2num())

		if (!B)
			log_debug("BOREALIS: Bad channel data during update channels. [jointext(channel_query.item, ", ")].")
			continue

		// Add the channel to the required lists.
		A = channels_to_group[channel_query.item[1]]
		A += B
		channels += B

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

		for (var/A in destinations)
			var/datum/discord_channel/channel = A
			switch (channel.send_message_to(auth_token, message))
				if (RATE_LIMITED)
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
	var/id = 0
	var/group = ""
	var/pin_flag = 0

/datum/discord_channel/New(var/_id, var/_group, var/_pin)
	id = _id
	group = _group

	if (_pin)
		pin_flag = _pin

/datum/discord_channel/proc/send_message_to(var/token, var/message)
	if (!token || !message)
		return ERROR_PROC

	var/res = send_post_request("https://discordapp.com/api/channels/[channel]/messages", message, "Authorization: Bot [token]", "Content-Type: application/json")

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

/datum/discord_channel/proc/get_pins(var/, var/token)
	var/res = send_get_request("https://discordapp.com/api/channels/[channel]/pins", "Authorization: Bot [token]")

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

			if (!isnull(B["mentions"]))
				var/list/mentions = B["mentions"]

				for (var/list/C in mentions)
					content = replacetextEx(content, "<@[C["id"]]>", C["username"])

			if (!isnull(B["mention_roles"]))


#undef CHAN_ADMIN
#undef CHAN_CCIAA
#undef CHAN_ANNOUNCE

#undef SEND_OK
#undef SEND_TIMEOUT
#undef ERROR_PROC
#undef ERROR_CURL
#undef ERROR_HTTP
