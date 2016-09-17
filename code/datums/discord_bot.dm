#define CHAN_ADMIN		"channel_admin"
#define CHAN_CCIAA		"channel_cciaa"
#define CHAN_ANNOUNCE	"channel_announce"

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
	var/list/channels = list()

	var/active = 0
	var/auth_token = ""

	var/robust_debug = 0

	// Lazy man's rate limiting vars
	var/rate_limited_since = 0
	var/queue_being_pushed = 0
	var/list/queue = list()

/datum/discord_bot/proc/update_channels()
	if (!active)
		return 1

	if (!establish_db_connection(dbcon))
		log_debug("BOREALIS: Failed to update channels due to missing database.")
		return 2

	channels = list()

	var/DBQuery/channel_query = dbcon.NewQuery("SELECT channel_group, channel_id FROM discord_channels")
	channel_query.Execute()

	var/list/A
	while (channel_query.NextRow())
		if (isnull(channels[channel_query.item[1]]))
			channels[channel_query.item[1]] = list()

		A = channels[channel_query.item[1]]
		A += channel_query.item[2]

	log_debug("BOREALIS: Channels updated successfully.")
	return 0

/datum/discord_bot/proc/send_message(var/channel_group, var/message)
	if (!active || !auth_token)
		return

	if (!channel_group || !channels.len || isnull(channels[channel_group]))
		return

	if (!message)
		return

	if (length(message) > 2000)
		message = copytext(message, 1, 2001)

	// Let's run it through the proper JSON encoder, just in case of special characters.
	message = json_encode(list("content" = message))

	var/list/A = channels[channel_group]
	var/list/sent = list()
	for (var/channel in A)
		if (send_post_request("https://discordapp.com/api/channels/[channel]/messages", message, "Authorization: Bot [auth_token]", "Content-Type: application/json") == 429)
			// Whoopsies, rate limited.
			// Set up the queue.
			rate_limited_since = world.time
			queue.Add(list(message, A - sent))

			// Schedule a push.
			spawn (100)
				push_queue()

			// And exit.
			return
		else
			sent += channel

	if (robust_debug)
		log_debug("BOEALIS: Message sent to [channel_group]. JSON body: '[message]'")

/datum/discord_bot/proc/send_to_admins(message)
	send_message(CHAN_ADMIN, message)

/datum/discord_bot/proc/send_to_cciaa(message)
	send_message(CHAN_CCIAA, message)

/datum/discord_bot/proc/send_to_announce(message)
	send_message(CHAN_ANNOUNCE, message)

/datum/discord_bot/proc/push_queue()
	// What facking queue.
	if (!queue.len)
		if (robust_debug)
			log_debug("BOREALIS: Attempted to push a null length queue.")
		if (queue_being_pushed)
			queue_being_pushed = 0
		return

	if (queue_being_pushed)
		if (robust_debug)
			log_debug("BOREALIS: Attempted to initialize a second queue driver.")
		return

	if ((world.time - rate_limited_since) < 100)
		// Something broke the limit again. Ideally, this wouldn't happen. But sure.
		// Use a longer timeout, just in case.
		spawn (200)
			push_queue()

		queue_being_pushed = 0
		return

	// Async process lock var. No touchy.
	queue_being_pushed = 1

	// A[1] - message body.
	// A[2] - list of channels to send to.
	var/message
	var/list/destinations
	while (queue.len)
		if (isnull(queue[0]))
			log_debug("BOREALIS: Error parsing queue. Index 0 is inaccessible.")
			return

		message = queue[0][1]
		destinations = queue[0][2]

		for (var/channel in destinations)
			if (send_post_request("https://discordapp.com/api/channels/[channel]/messages", message, "Authorization: Bot [auth_token]", "Content-Type: application/json") == 429)
				// Limited again. Reschedule.
				rate_limited_since = world.time
				spawn (100)
					push_queue()

				queue_being_pushed = 0
				return
			else
				destinations.Remove(channel)

		queue.Remove(queue[0])

	queue_being_pushed = 0

#undef CHAN_ADMIN
#undef CHAN_CCIAA
#undef CHAN_ANNOUNCE
