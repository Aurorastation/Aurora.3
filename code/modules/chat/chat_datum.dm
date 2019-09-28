/datum/chat
	var/client/client
	var/loaded = FALSE
	var/broken = FALSE
	var/list/queue

/datum/chat/New(var/client/C)
	client = C
	queue = list()

/datum/chat/proc/Start()
	. = FALSE
	if(!isclient(client))
		return
	if(!winexists(client, "browseroutput"))
		set waitfor = FALSE
		broken = TRUE
		log_debug("VüChat: Failed to start chat for [client] due to outdated skin file.")
		alert(client, "Updated chat window does not exist. If you are using a custom skin file please allow the game to update.")
		return
	
	
	if(winget(client, "browseroutput", "is-visible") == "true")
		LoadHTML() // Let's load it again anyways
	else
		LoadHTML()
	
	addtimer(CALLBACK(src, .proc/checkForFail), 50)
	return TRUE

/datum/chat/proc/checkForFail()
	if(loaded)
		return
	hide()
	log_debug("VüChat: [client] has failed to load chat.")

/datum/chat/proc/LoadHTML()
	set waitfor = FALSE
	if(!client)
		return

#ifdef UIDEBUG
	send_rsc(client, file("vueui/dist/chat.js"), "chat.js")
	send_rsc(client, file("vueui/dist/chat.css"), "chat.css")
#else
	simple_asset_ensure_is_sent(client, /datum/asset/simple/chat)
#endif
	client << browse(GenerateHTML(), "window=browseroutput")

/datum/chat/proc/GenerateHTML()
	return {"
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta charset="UTF-8">
		<link rel="stylesheet" type="text/css" href="chat.css">
	</head>
	<body class="[get_theme_class()]">
		<div id="chattarget">
			Chat is loading...
		</div>
		<noscript>
			<div id='uiNoScript'>
				<h2>JAVASCRIPT REQUIRED</h2>
				<p>Your Internet Explorer's Javascript is disabled (or broken).<br/>
				Enable Javascript and then reconnect.</p>
			</div>
		</noscript>
	</body>
	<script type="application/json" id="initialstate">
		[generate_data_json()]
	</script>
	<script type="text/javascript" src="chat.js"></script>
</html>
"}

/datum/chat/proc/generate_data_json()
	. = list()
	.["ref"] = "\ref[src]"
	.["roundid"] = game_id
	return json_encode(.)

/datum/chat/proc/get_theme_class()
	if(SStheming)
		return SStheming.get_theme(client)
	return "Ligth"

/datum/chat/proc/jscall(var/list/params, var/function)
	send_output(client, list2params(params), "browseroutput:[function]")

/datum/chat/proc/FinilizeLoading()
	if(loaded)
		return
	loaded = TRUE
	show()
	ProcessQueue()

/datum/chat/proc/ProcessQueue()
	if(!client)
		return
	if(queue.len && loaded)
		jscall(list(json_encode(queue)), "receiveQueue")
		queue.Cut()

/datum/chat/proc/show()
	winset(client, "output", "is-visible=false")
	winset(client, "browseroutput", "is-disabled=false;is-visible=true")

/datum/chat/proc/hide()
	winset(client, "output", "is-visible=true")
	winset(client, "browseroutput", "is-disabled=true;is-visible=false")

/datum/chat/Topic(href, href_list)
	if(usr.client != client)
		return
	if(href_list["ready"])
		FinilizeLoading()

	. = ..()
	