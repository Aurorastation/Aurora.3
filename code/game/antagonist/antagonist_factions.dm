/mob/living/proc/convert_to_rev(mob/M as mob in oview(src))
	set name = "Invite to the Contenders"
	set category = "Abilities"
	if(!M.mind)
		return
	for (var/obj/item/implant/mindshield/I in M)
		if (I.implanted)
			to_chat(src, SPAN_WARNING("[M] is too loyal to be subverted!"))
			return
	convert_to_faction(M.mind, revs)

/mob/living/proc/convert_to_faction(var/datum/mind/player, var/datum/antagonist/faction)

	if(!player || !faction || !player.current)
		return

	if(!faction.faction_verb || !faction.faction_descriptor || !faction.faction_verb)
		return

	if(faction.is_antagonist(player))
		to_chat(src, SPAN_WARNING("\The [player.current] already serves the [faction.faction_descriptor]."))
		return

	if(player_is_antag(player))
		to_chat(src, SPAN_WARNING("\The [player.current]'s loyalties seem to be elsewhere..."))
		return

	if(!faction.can_become_antag(player) || isanimal(player.current))
		to_chat(src, SPAN_WARNING("\The [player.current] cannot be \a [faction.faction_role_text]!"))
		return

	if(world.time < player.rev_cooldown)
		to_chat(src, SPAN_DANGER("You must wait five seconds between attempts."))
		return

	to_chat(src, SPAN_DANGER("You are attempting to convert \the [player.current]..."))
	log_admin("[src]([src.ckey]) attempted to convert [player.current].",ckey=src.ckey,ckey_target=key_name(player.current))
	message_admins(SPAN_DANGER("[src]([src.ckey]) attempted to convert [player.current]."))

	player.rev_cooldown = world.time+100
	var/choice = alert(player.current,"Asked by [src]: Do you want to join the [faction.faction_descriptor]?","Join the [faction.faction_descriptor]?","No!","Yes!")
	if(choice == "Yes!" && faction.add_antagonist_mind(player, 0, faction.faction_role_text, faction.faction_welcome))
		to_chat(src, SPAN_NOTICE("\The [player.current] joins the [faction.faction_descriptor]!"))
		return
	if(choice == "No!")
		to_chat(player, SPAN_DANGER("You reject this subversive cause!"))
	to_chat(src, SPAN_DANGER("\The [player.current] does not support the [faction.faction_descriptor]!"))

/mob/living/proc/convert_to_loyalist(mob/M as mob in oview(src))
	set name = "Invite to the Fellowship"
	set category = "Abilities"
	if(!M.mind)
		return
	for (var/obj/item/implant/mindshield/I in M)
		if (I.implanted)
			to_chat(src, SPAN_WARNING("[M] is too loyal to be subverted!"))
			return
	convert_to_faction(M.mind, loyalists)

