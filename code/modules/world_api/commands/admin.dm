//Grant Respawn
/datum/topic_command/grant_respawn
	name = "grant_respawn"
	description = "Grants a respawn to a specific target"
	params = list(
		"senderkey" = list("name"="senderkey","desc"="Unique id of the person that authorized the respawn","req"=1,"type"="senderkey"),
		"target" = list("name"="target","desc"="Ckey of the target that should be granted a respawn","req"=1,"type"="str")
		)

/datum/topic_command/grant_respawn/run_command(queryparams)
	var/list/ghosts = get_ghosts(1,1)
	var/target = queryparams["target"]
	var/allow_antaghud = queryparams["allow_antaghud"]
	var/senderkey = queryparams["senderkey"] //Identifier of the sender (Ckey / Userid / ...)

	var/mob/abstract/observer/G = ghosts[target]

	if(!G in ghosts)
		statuscode = 404
		response = "Target not in ghosts list"
		data = null
		return TRUE

	if(G.has_enabled_antagHUD && config.antag_hud_restricted && allow_antaghud == 0)
		statuscode = 409
		response = "Ghost has used Antag Hud - Respawn Aborted"
		data = null
		return TRUE
	G.timeofdeath=-19999	/* time of death is checked in /mob/verb/abandon_mob() which is the Respawn verb.
										 timeofdeath is used for bodies on autopsy but since we're messing with a ghost I'm pretty sure
										 there won't be an autopsy.
									*/
	var/datum/preferences/P

	if (G.client)
		P = G.client.prefs
	else if (G.ckey)
		P = preferences_datums[G.ckey]
	else
		statuscode = 500
		response = "Something went wrong, couldn't find the target's preferences datum"
		data = null
		return TRUE

	for (var/entry in P.time_of_death)//Set all the prefs' times of death to a huge negative value so any respawn timers will be fine
		P.time_of_death[entry] = -99999

	G.has_enabled_antagHUD = 2
	G.can_reenter_corpse = 1

	G:show_message(text("<span class='notice'><B>You may now respawn.	You should roleplay as if you learned nothing about the round during your time with the dead.</B></span>"), 1)
	log_admin("[senderkey] allowed [key_name(G)] to bypass the 30 minute respawn limit via the API",ckey=key_name(G),admin_key=senderkey)
	message_admins("Admin [senderkey] allowed [key_name_admin(G)] to bypass the 30 minute respawn limit via the API", 1)


	statuscode = 200
	response = "Respawn Granted"
	data = null
	return TRUE

//Get available Fax Machines
/datum/topic_command/send_adminmsg
	name = "send_adminmsg"
	description = "Sends a adminmessage to a player"
	params = list(
		"ckey" = list("name"="ckey","desc"="The target of the adminmessage","req"=1,"type"="str"),
		"msg" = list("name"="msg","desc"="The message that should be sent","req"=1,"type"="str"),
		"senderkey" = list("name"="senderkey","desc"="Unique id of the person that sent the adminmessage","req"=1,"type"="senderkey"),
		"rank" = list("name"="rank","desc"="The rank that should be displayed - Defaults to admin if none specified","req"=0,"type"="str")
		)

/datum/topic_command/send_adminmsg/run_command(queryparams)
	/*
		We got an adminmsg from IRC bot lets split the API
		expected output:
			1. ckey = ckey of person the message is to
			2. msg = contents of message, parems2list requires
			3. rank = Rank that should be displayed
			4. senderkey = the ircnick that send the message.
	*/

	var/client/C
	var/req_ckey = ckey(queryparams["ckey"])

	for(var/client/K in clients)
		if(K.ckey == req_ckey)
			C = K
			break
	if(!C)
		statuscode = 404
		response = "No client with that name on server"
		data = null
		return TRUE

	var/rank = queryparams["rank"]
	if(!rank)
		rank = "Admin"

	var/message =	"<font color='red'>[rank] PM from <b><a href='?discord_msg=[queryparams["senderkey"]]'>[queryparams["senderkey"]]</a></b>: [queryparams["msg"]]</font>"
	var/amessage =	"<font color='blue'>[rank] PM from <a href='?discord_msg=[queryparams["senderkey"]]'>[queryparams["senderkey"]]</a> to <b>[key_name(C, highlight_special = 1)]</b> : [queryparams["msg"]]</font>"

	C.received_discord_pm = world.time
	C.discord_admin = queryparams["senderkey"]

	sound_to(C, 'sound/admin/bwoink.ogg')
	to_chat(C, message)

	for(var/client/A in admins)
		if(A != C)
			to_chat(A, amessage)


	statuscode = 200
	response = "Admin Message sent"
	data = null
	return TRUE
