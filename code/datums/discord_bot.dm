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
	for (var/channel in A)
		send_post_request("https://discordapp.com/api/channels/[channel]/messages", message, "Authorization: Bot [auth_token]", "Content-Type: application/json")

	if (robust_debug)
		log_debug("BOEALIS: Message sent to [channel_group]. JSON body: '[message]'")

/datum/discord_bot/proc/send_to_admins(message)
	send_message(CHAN_ADMIN, message)

/datum/discord_bot/proc/send_to_cciaa(message)
	send_message(CHAN_CCIAA, message)

/datum/discord_bot/proc/send_to_announce(message)
	send_message(CHAN_ANNOUNCE, message)

#undef CHAN_ADMIN
#undef CHAN_CCIAA
#undef CHAN_ANNOUNCE
