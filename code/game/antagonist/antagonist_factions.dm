/mob/living/proc/convert_to_rev()
	set name = "Invite to the Revolutionaries"
	set category = "IC"

	var/list/mobs_to_convert = list()
	for(var/mob/A in orange(world.view, src))
		mobs_to_convert += A
	var/mob/living/carbon/human/M = tgui_input_list(usr, "Choose someone to convert.", "Invite to the Revolutionaries", mobs_to_convert)
	if(!M)
		return
	if(!M.mind)
		return
	for (var/obj/item/implant/mindshield/I in M)
		if (I.implanted)
			to_chat(src, SPAN_WARNING("[M] is too loyal to be subverted!"))
			return
	convert_to_faction(src, M.mind, GLOB.revs)

/proc/convert_to_faction(var/client/antag, var/datum/mind/player, var/datum/antagonist/faction)

	if(!player || !faction || !player.current)
		return

	if(!faction.faction_descriptor || !LAZYLEN(faction.faction_verbs))
		return

	if(faction.is_antagonist(player))
		to_chat(antag, SPAN_WARNING("\The [player.current] already serves the [faction.faction_descriptor]."))
		return

	if(player_is_antag(player))
		to_chat(antag, SPAN_WARNING("\The [player.current]'s loyalties seem to be elsewhere..."))
		return

	if(!faction.can_become_antag(player) || isanimal(player.current))
		to_chat(antag, SPAN_WARNING("\The [player.current] cannot be \a [faction.faction_role_text]!"))
		return

	if(world.time < player.rev_cooldown)
		to_chat(antag, SPAN_DANGER("You must wait five seconds between attempts."))
		return

	to_chat(antag, SPAN_DANGER("You are attempting to convert \the [player.current]..."))
	log_admin("[antag.mob]([antag.ckey]) attempted to convert [player.current].")
	message_admins(SPAN_DANGER("[antag.mob]([antag.ckey]) attempted to convert [player.current]."))

	player.rev_cooldown = world.time+100
	var/choice = alert(player.current,"Asked by [antag.mob]: Do you want to join the [faction.faction_descriptor]?","Join the [faction.faction_descriptor]?","No!","Yes!")
	if(choice == "Yes!" && faction.add_antagonist_mind(player, 0, faction.faction_role_text, faction.faction_welcome))
		to_chat(antag, SPAN_NOTICE("\The [player.current] joins the [faction.faction_descriptor]!"))
		return
	if(choice == "No!")
		to_chat(player, SPAN_DANGER("You reject this subversive cause!"))
	to_chat(antag, SPAN_DANGER("\The [player.current] does not support the [faction.faction_descriptor]!"))

/mob/living/proc/convert_to_loyalist()
	set name = "Invite to the Loyalists"
	set category = "IC"

	var/list/mobs_to_convert = list()
	for(var/mob/A in orange(world.view, src))
		mobs_to_convert += A
	var/mob/living/carbon/human/M = tgui_input_list(usr, "Choose someone to convert.", "Invite to the Loyalists", mobs_to_convert)
	if(!M)
		return
	if(!M.mind)
		return
	convert_to_faction(src, M.mind, GLOB.loyalists)

