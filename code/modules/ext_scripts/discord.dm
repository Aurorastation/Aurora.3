#define CHAN_ADMIN "admin_channel"
#define CHAN_CCIAA "cciaa_channel"

/proc/send_to_discord(var/channel, var/message)
	if (!config.use_discord_bot)
		return
	if (!channel)
		log_game("send_to_discord() called without channel arg.")
		return
	if (!message)
		log_game("send_to_discord() called without message arg.")
		return

	var/arguments = " --key=\"[config.comms_password]\""
	arguments += " --channel=\"[channel]\""
	if (config.discord_bot_host)
		arguments += " --host=\"[config.discord_bot_host]\""
	if (config.discord_bot_port)
		arguments += " --port=\"[config.discord_bot_port]\""

	message = replacetext(message, "\"", "\\\"")

	ext_python("discordbot_message.py", "[arguments] [message]")
	return

/proc/send_to_admin_discord(var/message)
	send_to_discord(CHAN_ADMIN, message)

/proc/send_to_cciaa_discord(var/message)
	send_to_discord(CHAN_CCIAA, message)

#undef CHAN_CCIAA
#undef CHAN_ADMIN
