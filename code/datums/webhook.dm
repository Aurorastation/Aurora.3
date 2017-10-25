var/list/global_webhooks = list()

/hook/startup/proc/initialize_webhooks()
	return global_initialize_webhooks()

proc/global_initialize_webhooks()
	var/list/Lines = file2list("config/webhooks.txt")
	for(var/line in Lines)
		if(!length(line))
			continue
		if(copytext(line,1,2) == "#")
			continue

		var/list/Parts = text2list(line, "-")
		if(!Parts.len && Parts < 2)
			continue

		var/url = trim(Parts[1])
		var/list/Tags = text2list(trim(lowertext(Parts[2])), ";")
		if(!Tags.len)
			continue
		var/datum/webhook/W = new(url, Tags)
		global_webhooks += W
	return 1

/datum/webhook
	var/url = ""
	var/list/tags

/datum/webhook/New(var/U, var/list/T)
	. = ..()
	url = U
	tags = T

/datum/webhook/proc/send(var/Data)
	var/res = send_post_request(url, Data, "Content-Type: application/json")
	switch (res)
		if (-1)
			return 0
		if (0 to 90)
			log_debug("Webhooks: cURL error while sending: [res]. Data: [Data].")
			return 0
		else
			return 1

/proc/post_webhook_event(var/tag, var/list/data)
	var/OutData = list()
	switch (tag)
		if ("g_cciaa")
			OutData["content"] = data["message"]
		if ("g_admin")
			OutData["content"] = data["message"]
		if ("roundend")
			var/emb = list(
				"title" = "Round has ended",
				"color" = 16711680,
				"description" = "A round of **[data["gamemode"]]** has ended! \[Game ID: [data["gameid"]]\]\n"
			)
			emb["description"] += data["antags"]
			if(data["survivours"] > 0)
				emb["description"] += "There [data["survivours"]>1 ? "were **[data["survivours"]] survivors**" : "was **one survivor**"]"
				emb["description"] += " ([data["escaped"]>0 ? data["escaped"] : "none"] [emergency_shuttle.evac ? "escaped" : "transferred"]) and **[data["ghosts"]] ghosts**."
			else
				emb["description"] += "There were **no survivors** ([data["ghosts"]] ghosts)."
			OutData["embeds"] = list(emb)
		else
			OutData["invalid"] = 1
	if (!OutData["invalid"])
		for (var/datum/webhook/W in global_webhooks)
			if(tag in W.tags)
				W.send(json_encode(OutData))