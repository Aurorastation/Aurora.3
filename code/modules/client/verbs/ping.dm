/client/verb/update_ping(time as num)
	set instant = TRUE
	set name = ".update_ping"
	var/ping = pingfromtime(time)
	lastping = ping
	if (!avgping)
		avgping = ping
	else
		avgping = MC_AVERAGE_SLOW(avgping, ping)

/client/proc/pingfromtime(time)
	return ((world.time+world.tick_lag*TICK_USAGE_REAL/100)-time)*100

/client/verb/display_ping(time as num)
	set instant = TRUE
	set name = ".display_ping"
	to_chat(src, SPAN_NOTICE("Round trip ping took [round(pingfromtime(time),1)]ms"))

/client/verb/ping()
	set name = "Ping"
	set category = "OOC"
	winset(src, null, "command=.display_ping+[world.time+world.tick_lag*TICK_USAGE_REAL/100]")

/client/verb/ping_storyteller()
	set name = "Ping storyteller"
	set category = "OOC"

	if(!mob || isnewplayer(mob))
		return

	if(!istype(SSticker?.mode, /datum/game_mode/odyssey))
		to_chat(src, SPAN_WARNING("You can only ping storytellers during an Odyssey round."))
		return

	if(!COOLDOWN_FINISHED(src, storyteller_ping_cooldown))
		to_chat(src, SPAN_WARNING("You can ping storytellers again in [DisplayTimeText(COOLDOWN_TIMELEFT(src, storyteller_ping_cooldown))]."))
		return

	var/confirm = tgui_alert(src, "Using the following input you can notify the storyteller about something important or do simply request they presence. Please provide a meaningful message to give the storyteller a better understanding of the situation.", "Ping Storyteller", list("Understood", "Cancel"))
	if(confirm != "Understood")
		return

	var/message = sanitize(tgui_input_text(src, "Enter your message for the Storyteller.", "Ping Storyteller", max_length = 256))
	if(!message)
		to_chat(src, SPAN_WARNING("You must enter a message to ping a storyteller."))
		return

	var/list/mob/abstract/ghost/storyteller/active_storytellers = list()
	for(var/mob/abstract/ghost/storyteller/storyteller as anything in SSodyssey?.storytellers)
		if(storyteller?.client)
			active_storytellers += storyteller

	if(!length(active_storytellers))
		to_chat(src, SPAN_WARNING("There are no active storytellers to receive your ping right now."))
		return

	for(var/mob/abstract/ghost/storyteller/storyteller as anything in active_storytellers)
		var/jump_link = "(<A href='byond://?src=[REF(storyteller)];storyteller_jump_to=[REF(mob)]'>JMP</A>)"
		to_chat(storyteller, SPAN_STORYTELLER("[create_text_tag("PING", storyteller.client)] <EM>[mob.name])</EM> [jump_link]: [span("message linkify", message)]"))

	COOLDOWN_START(src, storyteller_ping_cooldown, 1 MINUTES)
	to_chat(src, SPAN_NOTICE("Your ping has been sent to the storyteller."))
	log_admin("(STORYTELLER PING) [mob.name]/[key] : [message]")
