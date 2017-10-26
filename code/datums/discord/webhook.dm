#define HEX_COLOR_RED 16711680
#define HEX_COLOR_GREEN 65280
#define HEX_COLOR_BLUE 255
#define HEX_COLOR_YELLOW 16776960

var/list/global_webhooks = list()

/proc/global_initialize_webhooks()
	var/file = return_file_text("config/webhooks.json")
	var/jsonData = json_decode(file)
	for(var/hook in jsonData)
		if(!hook["url"] || !hook["tags"])
			continue
		var/datum/webhook/W = new(hook["url"], hook["tags"])
		global_webhooks += W
		if(hook["mention"])
			W.mention = hook["mention"]
		
	return 1

/datum/webhook
	var/url = ""
	var/list/tags
	var/mention = ""

/datum/webhook/New(var/U, var/list/T)
	. = ..()
	url = U
	tags = T

/datum/webhook/proc/send(var/Data)
	if (mention)
		if (Data["content"])
			Data["content"] = "[mention]: " + Data["content"]
		else
			Data["content"] = "[mention]"
	world.log << "Webhooks: Sent to [url] : [json_encode(Data)]"
	var/res = send_post_request(url, json_encode(Data), "Content-Type: application/json")
	switch (res)
		if (-1)
			return 0
		if (0 to 90)
			log_debug("Webhooks: cURL error while sending: [res]. Data: [Data].")
			return 0
		else
			return 1

/proc/post_webhook_event(var/tag, var/list/data)
	if (!global_webhooks.len)
		return
	var/OutData = list()
	switch (tag)
		if ("g_apms")
			var/emb = list(
				"title" = data["title"],
				"description" = data["message"],
				"color" = HEX_COLOR_BLUE
			)
			OutData["embeds"] = list(emb)
		if ("g_apms_a")
			var/emb = list(
				"title" = data["title"],
				"description" = data["message"],
				"color" = HEX_COLOR_BLUE
			)
			OutData["embeds"] = list(emb)
		if ("g_admin")
			var/emb = list(
				"title" = data["title"],
				"description" = data["message"],
				"color" = HEX_COLOR_BLUE
			)
			OutData["embeds"] = list(emb)
		if ("g_admin_a") // Another tag for getting attetion to more important stuff
			var/emb = list(
				"title" = data["title"],
				"description" = data["message"],
				"color" = HEX_COLOR_BLUE
			)
			OutData["embeds"] = list(emb)
		if ("roundend")
			var/emb = list(
				"title" = "Round has ended",
				"color" = HEX_COLOR_RED,
				"description" = "A round of **[data["gamemode"]]** has ended! \[Game ID: [data["gameid"]]\]\n"
			)
			emb["description"] += data["antags"]
			if(data["survivours"] > 0)
				emb["description"] += "There [data["survivours"]>1 ? "were **[data["survivours"]] survivors**" : "was **one survivor**"]"
				emb["description"] += " ([data["escaped"]>0 ? data["escaped"] : "none"] [emergency_shuttle.evac ? "escaped" : "transferred"]) and **[data["ghosts"]] ghosts**."
			else
				emb["description"] += "There were **no survivors** ([data["ghosts"]] ghosts)."
			OutData["embeds"] = list(emb)
		if ("cciaa_emergincy")
			var/emb = list(
				"title" = "Emergency message from station",
				"description" = "[data["sender"]] sent message `[data["message"]]`",
				"fields" = list()
			)
			if (data["cciaa_present"])
				var/f = list("name"="[data["cciaa_present"]] CCIA agents online.")
				if (data["cciaa_present"] - data["cciaa_afk"] <= 0)
					f["value"] = "***All of them are AFK!***"
					emb["color"] = HEX_COLOR_YELLOW
				else
					f["value"] = "[data["cciaa_afk"]] AFK."
					emb["color"] = HEX_COLOR_GREEN
				emb["fields"] += list(f)
			else
				var/f = list("name"="No CCIA agents online.","value"="_Someone should join._")
				emb["fields"] += list(f)
				emb["color"] = HEX_COLOR_RED
			OutData["embeds"] = list(emb)
		if ("alert_noadmins")
			OutData["content"] = "Round has started with no admins or mods online."
		if ("roundstart")
			var/emb = list(
				"title" = "Round has started",
				"description" = "Round started with [data["playercount"]] [data["playercount"]>1 ? "players" :]",
				"color" = HEX_COLOR_GREEN
			)
			OutData["embeds"] = list(emb)
		else
			OutData["invalid"] = 1
	if (!OutData["invalid"])
		for (var/datum/webhook/W in global_webhooks)
			if(tag in W.tags)
				W.send(OutData)

#undef HEX_COLOR_RED
#undef HEX_COLOR_GREEN
#undef HEX_COLOR_BLUE
#undef HEX_COLOR_YELLOW