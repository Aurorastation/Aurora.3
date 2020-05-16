#define HEX_COLOR_RED 16711680
#define HEX_COLOR_GREEN 65280
#define HEX_COLOR_BLUE 255
#define HEX_COLOR_YELLOW 16776960

var/list/global_webhooks = list()

/proc/global_initialize_webhooks()
	if (!establish_db_connection(dbcon))
		var/file = return_file_text("config/webhooks.json")
		if (file)
			var/jsonData = json_decode(file)
			if(!jsonData)
				return 0
			for(var/hook in jsonData)
				if(!hook["url"] || !hook["tags"])
					continue
				var/datum/webhook/W = new(hook["url"], hook["tags"])
				global_webhooks += W
				if(hook["mention"])
					W.mention = hook["mention"]
			return 1
		else
			return 0
	else
		var/DBQuery/query = dbcon.NewQuery("SELECT url, tags, mention FROM ss13_webhooks")
		query.Execute()
		while (query.NextRow())
			var/url = query.item[1]
			var/list/tags = splittext(query.item[2], ";")
			var/mention = query.item[3]
			var/datum/webhook/W = new(url, tags)
			global_webhooks += W
			if(mention)
				W.mention = mention
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

	var/datum/http_request/req = SShttp.post(url, body = json_encode(Data), headers = list("Content-Type" = "application/json"))

	req.begin_async()
	UNTIL(req.is_complete())

	var/datum/http_response/res = req.into_response()

	if (res.errored)
		log_debug("Webhooks: proc error while sending: [res.error]")
		return FALSE
	else
		return TRUE

/proc/post_webhook_event(var/tag, var/list/data)
	set background = 1

	if (!global_webhooks.len)
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
				emb["description"] += " ([data["escaped"]>0 ? data["escaped"] : "none"] [emergency_shuttle.evac ? "escaped" : "transferred"]) and **[data["ghosts"]] ghosts**."
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
				"description" = "Round started with [data["playercount"]] [data["playercount"]>1 ? "players" : "player"]",
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
