#define CHAN_ADMIN		"channel_admin"
#define CHAN_CCIAA		"channel_cciaa"
#define CHAN_ANNOUNCE	"channel_announce"
#define CHAN_INVITE		"channel_invite"

#define SEND_OK			1
#define SEND_TIMEOUT	2
#define ERROR_PROC		4
#define ERROR_HTTP		8

#define HEX_COLOR_RED 16711680
#define HEX_COLOR_GREEN 65280
#define HEX_COLOR_BLUE 255
#define HEX_COLOR_YELLOW 16776960


SUBSYSTEM_DEF(discord)
	name = "Discord"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE | SS_NO_DISPLAY

	var/list/channels_to_group = list()		// Group flag -> list of channel datums map.
	var/list/channels = list()				// Channel ID -> channel datum map. Will ensure that only one datum per channel ID exists.
	var/list/webhooks = list()

	var/datum/discord_channel/invite_channel = null	// The channel datum where the ingame Join Channel button will link to.

	var/active = FALSE
	var/auth_token = ""
	var/subscriber_role = ""

	// Used to determine if BOREALIS should alert staff if the server is created
	// with world.visibility == 0.
	var/alert_visibility = 0

/datum/controller/subsystem/discord/can_vv_get(var_name)
	if(var_name == NAMEOF(src, auth_token))
		return FALSE
	if(var_name == NAMEOF(src, webhooks))
		return FALSE
	return ..()

/datum/controller/subsystem/discord/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, auth_token))
		return FALSE
	return ..()

/datum/controller/subsystem/discord/Initialize()
	GLOB.config.load("config/discord.txt", "discord")
	update_channels()
	initialize_webhooks()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/discord/stat_entry(msg)
	msg = "A: [active] | C: [length(channels)] | G: [length(channels_to_group)] | W: [length(webhooks)]"
	return ..()

/**
 * Initializes Webhooks
 *
 * Used to load the webhooks from the db or the flatfile
 * Wipes all current channels and channel maps.
 *
 * Returns Error code. 0 upon success.
 */
/datum/controller/subsystem/discord/proc/initialize_webhooks()
	PRIVATE_PROC(TRUE)
	if(!establish_db_connection(GLOB.dbcon))
		var/file = return_file_text("config/webhooks.json")
		if (file)
			var/jsonData = json_decode(file)
			if(!jsonData)
				return 1
			for(var/hook in jsonData)
				if(!hook["url"] || !hook["tags"])
					continue
				var/datum/webhook/W = new(hook["url"], hook["tags"])
				webhooks += W
				if(hook["mention"])
					W.mention = hook["mention"]
			return 0
		else
			return 1
	else
		var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT url, tags, mention FROM ss13_webhooks")
		query.Execute()
		while (query.NextRow())
			var/url = query.item[1]
			var/list/tags = splittext(query.item[2], ";")
			var/mention = query.item[3]
			var/datum/webhook/W = new(url, tags)
			webhooks += W
			if(mention)
				W.mention = mention
	return 0

/**
 * Proc update_channels
 * Used to load channels from the database and construct them with the discord API.
 * Wipes all current channels and channel maps.
 *
 * Returns Error code. 0 upon success.
 */
/datum/controller/subsystem/discord/proc/update_channels()
	log_subsystem_discord("UpdateChannels - Attempted")
	if (!active)
		log_subsystem_discord("UpdateChannels - Failed - Discord bot is not active")
		return 1

	if (!establish_db_connection(GLOB.dbcon))
		log_subsystem_discord("UpdateChannels - Failed - Unable to connect to database")
		return 2

	// Reset the channel lists.
	channels_to_group.Cut()
	channels.Cut()

	var/DBQuery/channel_query = GLOB.dbcon.NewQuery("SELECT channel_group, channel_id, pin_flag, server_id FROM discord_channels")
	channel_query.Execute()

	while (channel_query.NextRow())
		// Create the channel map.
		if (isnull(channels_to_group[channel_query.item[1]]))
			channels_to_group[channel_query.item[1]] = list()

		var/datum/discord_channel/B = channels[channel_query.item[2]]

		// We don't have this channel datum yet.
		if (isnull(B))
			B = new(channel_query.item[2], channel_query.item[4], text2num(channel_query.item[3]))

			if (!B)
				log_subsystem_discord("UpdateChannels - Error - Bad channel data during update channels - [jointext(channel_query.item, ", ")]")
				continue

			channels[channel_query.item[2]] = B

		if (text2num(channel_query.item[3]))
			B.pin_flag |= text2num(channel_query.item[3])

		// Add the channel to the required lists.
		channels_to_group[channel_query.item[1]] += B

	if (!isnull(channels_to_group[CHAN_INVITE]))
		invite_channel = channels_to_group[CHAN_INVITE][1]
	else
		log_subsystem_discord("UpdateChannels - No Invite Channel Designated")

	log_subsystem_discord("UpdateChannels - Completed")
	return 0

/**
 * Sends message to Channel Group
 *
 * Used to send a message to a specific channel group.
 * The request is sent via SShttp and automatically retried in case of 429/503 errors.
 * Arguments:
 * * channel_group - The name of the channel group which to target.
 * * message - The message to send.
 */
/datum/controller/subsystem/discord/proc/send_message(var/channel_group, var/message)
	SHOULD_NOT_SLEEP(TRUE)
	log_subsystem_discord("SendMessage - Attempted")
	if (!active)
		log_subsystem_discord("SendMessage - Failed - Bot not Active")
		return

	if (!auth_token)
		log_subsystem_discord("SendMessage - Failed - No Auth Token set")
		return

	if (!channel_group)
		log_subsystem_discord("SendMessage - Failed - No ChannelGroup specified")
		return

	if (!channels.len)
		log_subsystem_discord("SendMessage - Failed - No Channels Loaded from DB")
		return

	if (isnull(channels_to_group[channel_group]))
		log_subsystem_discord("SendMessage - Failed - No Channels found for group '[channel_group]'")
		return

	if (!message)
		log_subsystem_discord("SendMessage - Failed - No message specified")
		return

	if (length(message) > 2000)
		log_subsystem_discord("SendMessage - Message Cropped - Message too long")
		message = copytext(message, 1, 2001)

	// Let's run it through the proper JSON encoder, just in case of special characters.
	message = json_encode(list("content" = message))

	var/list/A = channels_to_group[channel_group]
	for (var/B in A)
		var/datum/discord_channel/channel = B
		log_subsystem_discord("SendMessage - Sending - Attempting to send to send to '[channel.id]'")
		SShttp.create_async_request(RUSTG_HTTP_METHOD_POST,"https://discordapp.com/api/channels/[channel.id]/messages",message,list("Authorization" = "Bot [auth_token]", "Content-Type" = "application/json"))

	log_subsystem_discord("SendMessage - Sent to [channel_group]. JSON body: '[message]'")

/**
 * Retrieves Pins
 *
 * Used to fetch a list of all pins from the designated channels.
 *
 * Returns list - A multilayered list of flags associated with pins. Structure looks like this: list("pin_flag" = list(list("author" = author name, "content" = content), list("author" = author name, "content" = content)))
 */
/datum/controller/subsystem/discord/proc/retreive_pins()
	log_subsystem_discord("RetrievePins - Attempted")
	if (!active)
		log_subsystem_discord("RetrievePins - Failed - Bot not Active")
		return list()

	if (!auth_token)
		log_subsystem_discord("RetrievePins - Failed - No Auth Token set")
		return list()

	if (!channels.len)
		log_subsystem_discord("RetrievePins - Failed - No Channels Loaded from DB")
		return

	if (isnull(channels_to_group["channel_pins"]))
		log_subsystem_discord("RetrievePins - Failed - No Channels found for group 'channel_pins'")
		return list()

	var/list/output = list()

	for (var/A in channels_to_group["channel_pins"])
		var/datum/discord_channel/channel = A
		if (isnull(output["[channel.pin_flag]"]))
			output["[channel.pin_flag]"] = list()

		var/ch_pins = channel.get_pins(auth_token)
		if (length(ch_pins))
			output["[channel.pin_flag]"] += ch_pins

	log_subsystem_discord("RetrievePins - Finished - Pins Acquired")

	return output

/**
 * Retrieves a Invite
 *
 * Used to retreive the invite to the invite channel.
 * One will be created if none exist.
 *
 * Returns text - The invite URL to the designated invite channel.
 */
/datum/controller/subsystem/discord/proc/retreive_invite()
	set background = 1
	if (!active)
		log_subsystem_discord("RetrieveInvite - Failed - Bot not Active")
		return ""

	if (!auth_token)
		log_subsystem_discord("RetrieveInvite - Failed - No Auth Token set")
		return ""

	if (!invite_channel)
		log_subsystem_discord("RetrieveInvite - Failed - No Invite Channel")
		return ""

	var/res = invite_channel.get_invite(auth_token)
	return isnum(res) ? "" : res

/**
 * Sends Discord message to Admins
 *
 * Forwards a message to the admin channels.
 */
/datum/controller/subsystem/discord/proc/send_to_admins(message)
	SHOULD_NOT_SLEEP(TRUE)
	send_message(CHAN_ADMIN, message)

/**
 * Sends Discord message to CCIA
 *
 * Forwards a message to the CCIAA channels.
 */
/datum/controller/subsystem/discord/proc/send_to_cciaa(message)
	SHOULD_NOT_SLEEP(TRUE)
	send_message(CHAN_CCIAA, message)

/**
 * Sends Discord message to Announce
 *
 * Forwards a message to the announcements channels.
 */
/datum/controller/subsystem/discord/proc/send_to_announce(message, prepend_role = 0)
	SHOULD_NOT_SLEEP(TRUE)
	if (prepend_role && subscriber_role)
		message = "<@&[subscriber_role]> " + message
	send_message(CHAN_ANNOUNCE, message)

/**
 * Escapes Discord message
 *
 * Escapes a Discord Message and sanitizes it for sending to a discord channel
 * If mentions are removed the "@role" is replaced with "@ role" in the message
 * Arguments:
 * * input - The message to sanitize
 * * remove_everyone - If everyone mentions should be removed - Defaults to TRUE
 * * remove_mentions - If other mentions should be removed - Defaults to FALSE
 */
/datum/controller/subsystem/discord/proc/discord_escape(var/input, var/remove_everyone = TRUE, var/remove_mentions = FALSE)
	. = replace_characters(input, list("`" = "\\`", "*" = "\\*", "_" = "\\_", "~" = "\\~"))

	if (remove_everyone)
		var/regex/evReg = regex("@everyone", "gi")
		. = evReg.Replace(., "@ everyone")
		var/regex/hereReg = regex("@here", "gi")
		. = hereReg.Replace(., "@ here")

	if (remove_mentions)
		var/regex/menReg = regex("<@\[\\d]+>", "g")
		. = menReg.Replace(., "\[mention]")
		var/regex/roleReg = regex("<@&\[\\d]+>", "g")
		. = roleReg.Replace(., "\[role mention]")

/**
 * Send Server invisibility alert
 *
 * Will alert the staff on Discord if the server is initialized in invisible mode.
 * Can be toggled via config.
 */
/datum/controller/subsystem/discord/proc/alert_server_visibility()
	SHOULD_NOT_SLEEP(TRUE)
	if (alert_visibility && !world.visibility)
		send_to_admins("Server started as invisible!")


/**
 * Sends a webhook event
 *
 * Sends a webhook based on the supplied tag and data.
 * Arguments:
 * * tag - A tag as defined in WEBHOOK_*
 * * data - Depends on the tag. Check below for required data
 */
/datum/controller/subsystem/discord/proc/post_webhook_event(var/tag, var/list/data)
	SHOULD_NOT_SLEEP(TRUE)
	var/escape_text
	if(evacuation_controller.evacuation_type == TRANSFER_EMERGENCY)
		escape_text = "escaped"
	else
		escape_text = "transfered"

	if (!webhooks.len)
		return
	var/OutData = list()
	switch (tag)
		if (WEBHOOK_ADMIN_PM)
			var/emb = list(
				"title" = data["title"],
				"description" = data["message"],
				"color" = HEX_COLOR_BLUE
			)
			OutData["embeds"] = list(emb)
		if (WEBHOOK_ADMIN_PM_IMPORTANT)
			var/emb = list(
				"title" = data["title"],
				"description" = data["message"],
				"color" = HEX_COLOR_BLUE
			)
			OutData["embeds"] = list(emb)
		if (WEBHOOK_ADMIN)
			var/emb = list(
				"title" = data["title"],
				"description" = data["message"],
				"color" = HEX_COLOR_BLUE
			)
			OutData["embeds"] = list(emb)
		if (WEBHOOK_ADMIN_IMPORTANT)
			var/emb = list(
				"title" = data["title"],
				"description" = data["message"],
				"color" = HEX_COLOR_BLUE
			)
			OutData["embeds"] = list(emb)
		if (WEBHOOK_ROUNDEND)
			var/emb = list(
				"title" = "Round has ended",
				"color" = HEX_COLOR_RED,
				"description" = "A round of **[data["gamemode"]]** has ended! \[Game ID: [data["gameid"]]\]\n"
			)
			emb["description"] += data["antags"]
			if(data["survivours"] > 0)
				emb["description"] += "There [data["survivours"]>1 ? "were **[data["survivours"]] survivors**" : "was **one survivor**"]"
				emb["description"] += " ([data["escaped"]>0 ? data["escaped"] : "none"] [escape_text]) and **[data["ghosts"]] ghosts**."
			else
				emb["description"] += "There were **no survivors** ([data["ghosts"]] ghosts)."
			OutData["embeds"] = list(emb)
		if (WEBHOOK_CCIAA_EMERGENCY_MESSAGE)
			var/emb = list(
				"title" = "Emergency message from station",
				"fields" = list()
			)
			var/f1 = list("name"="[data["sender"]] wrote:", "value"="[data["message"]]")
			emb["fields"] += list(f1)
			if (data["cciaa_present"])
				var/f2 = list("name"="[data["cciaa_present"]] CCIA agents online.")
				if (data["cciaa_present"] - data["cciaa_afk"] <= 0)
					f2["value"] = "***All of them are AFK!***"
					emb["color"] = HEX_COLOR_YELLOW
				else
					f2["value"] = "[data["cciaa_afk"]] AFK."
					emb["color"] = HEX_COLOR_GREEN
				emb["fields"] += list(f2)
			else
				var/f2 = list("name"="No CCIA agents online.","value"="_Someone should join._")
				emb["fields"] += list(f2)
				emb["color"] = HEX_COLOR_RED
			OutData["embeds"] = list(emb)
		if (WEBHOOK_ALERT_NO_ADMINS)
			OutData["content"] = "Round has started with no admins or mods online."
		if (WEBHOOK_ROUNDSTART)
			var/emb = list(
				"title" = "Round has started",
				"description" = "Round started with [data["playercount"]] player\s.",
				"color" = HEX_COLOR_GREEN
			)
			OutData["embeds"] = list(emb)
		else
			OutData["invalid"] = 1
	if (!OutData["invalid"])
		for (var/datum/webhook/W in webhooks)
			if(tag in W.tags)
				if (W.mention)
					if (OutData["content"])
						OutData["content"] = "[W.mention]: " + OutData["content"]
					else
						OutData["content"] = "[W.mention]"

				SShttp.create_async_request(RUSTG_HTTP_METHOD_POST,W.url,body = json_encode(OutData), headers = list("Content-Type" = "application/json"))

//
// Related Datums
//


/**
 * # Discord Channel
 *
 * A discord channel
 *
 * A specific discord channel
 */
/datum/discord_channel
	var/id = ""
	var/server_id = ""
	var/pin_flag = 0
	var/invite_url = ""

/**
 * Constructor
 *
 * Arguments:
 * * _id - the discord API id of the channel, as a string.
 * * _sid - the discord API server id for the channel, as a string.
 * * _pin - the bitflags of admin permissions which have access to the pins from this channel.
 */
/datum/discord_channel/New(var/_id, var/_sid, var/_pin)
	id = _id
	server_id = _sid

	if (_pin)
		pin_flag = _pin

/**
 * Get Pinned Messages
 *
 * Retreives a list of pinned messages from the channel.
 * Arguments:
 * * token	- the authorization token to be used for the requests.
 *
 * Returns mixed - 2d array of content upon success, in format: list(list("author" = text, "content" = text)). Num upon failure.
 */
/datum/discord_channel/proc/get_pins(var/token)
	var/datum/http_request/req = httpold_create_get("https://discordapp.com/api/channels/[id]/pins", headers = list("Authorization" = "Bot [token]"))

	req.begin_async()
	UNTIL(req.is_complete())

	var/datum/http_response/res = req.into_response()

	if (res.errored)
		log_subsystem_discord("GetPins - Proc error while fetching pins: [res.error]")
		return
	else if (res.status_code != 200)
		log_subsystem_discord("GetPins - HTTP error while fetching pins: [res.status_code].")
		return
	else
		var/list/A = json_decode(res.body)
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
					content = replacetextEx(content, "<@&[C]>", "@SomeRole")

			pinned_messages += list(list("author" = B["author"]["username"], "content" = content))

		return pinned_messages

/**
 * Get Invite for Channel
 *
 * Retreives (or creates if none found) an invite URL to the specific channel.
 * Arguments:
 * * token - the authorization token to be used for the requests.
 *
 * Returns text upon success, the link to the invite; num upon failure.
 */
/datum/discord_channel/proc/get_invite(var/token)
	if (invite_url)
		return invite_url

	var/datum/http_request/req = httpold_create_get("https://discordapp.com/api/channels/[id]/invites", headers = list("Authorization" = "Bot [token]"))

	req.begin_async()
	UNTIL(req.is_complete())

	var/datum/http_response/res = req.into_response()

	if (res.errored)
		log_subsystem_discord("GetInvite - Proc error while fetching invite: [res.error]")
		return
	else if (res.status_code != 200)
		log_subsystem_discord("GetInvite - HTTP error while fetching invite: [res.status_code].")
		return
	else
		var/list/A = json_decode(res.body)

		// No length to return data, but a valid 200 return header.
		// So we simply have no invites active. Make one!
		if (!A?.len)
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
					best_age = A[i]["max_age"]
					code = A[i]["code"]

		// Sanity check for debug I guess.
		if (!code)
			log_subsystem_discord("GetInvite - Retreived an empty invite. This should not happen. Response object: [json_encode(A)]")
			return

		// Save the URL for later retreival.
		invite_url = "https://discord.gg/[code]"
		return invite_url

/**
 * Create Invite
 *
 * Creates a permanent invite to a channel and returns it, under the assumption that
 * there are no other invites for this channel.
 * Arguments:
 * * token - the authorization token to be used for the requests.
 *
 * Returns mixed - String upon success - the URL of the newly generated invite. Num upon failure.
 */
/datum/discord_channel/proc/create_invite(var/token)
	var/data = list("max_age" = 0, "max_uses" = 0)
	var/datum/http_request/req = httpold_create_post("https://discordapp.com/api/channels/[id]/invites", json_encode(data), list("Authorization" = "Bot [token]", "Content-Type" = "application/json"))

	req.begin_async()
	UNTIL(req.is_complete())

	var/datum/http_response/res = req.into_response()

	if (!res.errored && res.status_code == 200)
		var/list/r_data = json_decode(res.body)

		// The first index should now exist. So we just use that!
		invite_url = "https://discord.gg/[r_data["code"]]"
		return invite_url



/datum/webhook
	var/url = ""
	var/list/tags
	var/mention = ""

/datum/webhook/New(var/U, var/list/T)
	. = ..()
	url = U
	tags = T



/hook/roundstart/proc/alert_no_admins()
	var/admins_number = 0

	for (var/C in GLOB.clients)
		var/client/cc = C
		if (cc.holder && (cc.holder.rights & (R_MOD|R_ADMIN)))
			admins_number++

	SSdiscord.post_webhook_event(WEBHOOK_ROUNDSTART, list("playercount"=GLOB.clients.len))
	if (!admins_number)
		SSdiscord.post_webhook_event(WEBHOOK_ALERT_NO_ADMINS, list())
		if (!SSdiscord)
			return 1
		SSdiscord.send_to_admins("@here Round has started with no admins or mods online.")

	return 1


#undef HEX_COLOR_RED
#undef HEX_COLOR_GREEN
#undef HEX_COLOR_BLUE
#undef HEX_COLOR_YELLOW

#undef CHAN_ADMIN
#undef CHAN_CCIAA
#undef CHAN_ANNOUNCE
#undef CHAN_INVITE

#undef SEND_OK
#undef SEND_TIMEOUT
#undef ERROR_PROC
#undef ERROR_HTTP
