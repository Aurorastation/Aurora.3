/mob/living/proc/convert_to_rev()
	set name = "Invite to the Revolutionaries"
	set category = "IC"

	var/mob/living/carbon/human/M = input(usr, "Choose someone to convert.", "Invite to the Revolutionaries") as null|mob in orange(world.view, src)
	if(!M)
		return
	if(!M.mind)
		return
	for (var/obj/item/implant/mindshield/I in M)
		if (I.implanted)
			to_chat(src, "<span class='warning'>[M] is too loyal to be subverted!</span>")
			return
	convert_to_faction(src, M.mind, revs)

/proc/convert_to_faction(var/client/antag, var/datum/mind/player, var/datum/antagonist/faction)

	if(!player || !faction || !player.current)
		return

	if(!faction.faction_verb || !faction.faction_descriptor || !faction.faction_verb)
		return

	if(faction.is_antagonist(player))
		to_chat(antag, "<span class='warning'>\The [player.current] already serves the [faction.faction_descriptor].</span>")
		return

	if(player_is_antag(player))
		to_chat(antag, "<span class='warning'>\The [player.current]'s loyalties seem to be elsewhere...</span>")
		return

	if(!faction.can_become_antag(player) || isanimal(player.current))
		to_chat(antag, "<span class='warning'>\The [player.current] cannot be \a [faction.faction_role_text]!</span>")
		return

	if(world.time < player.rev_cooldown)
		to_chat(antag, "<span class='danger'>You must wait five seconds between attempts.</span>")
		return

	to_chat(antag, "<span class='danger'>You are attempting to convert \the [player.current]...</span>")
	log_admin("[antag.mob]([antag.ckey]) attempted to convert [player.current].",ckey=antag.ckey,ckey_target=key_name(player.current))
	message_admins("<span class='danger'>[antag.mob]([antag.ckey]) attempted to convert [player.current].</span>")

	player.rev_cooldown = world.time+100
	var/choice = alert(player.current,"Asked by [antag.mob]: Do you want to join the [faction.faction_descriptor]?","Join the [faction.faction_descriptor]?","No!","Yes!")
	if(choice == "Yes!" && faction.add_antagonist_mind(player, 0, faction.faction_role_text, faction.faction_welcome))
		to_chat(antag, "<span class='notice'>\The [player.current] joins the [faction.faction_descriptor]!</span>")
		return
	if(choice == "No!")
		to_chat(player, "<span class='danger'>You reject this subversive cause!</span>")
	to_chat(antag, "<span class='danger'>\The [player.current] does not support the [faction.faction_descriptor]!</span>")

/mob/living/proc/convert_to_loyalist()
	set name = "Invite to the Loyalists"
	set category = "IC"

	var/mob/living/carbon/human/M = input(usr, "Choose someone to convert.", "Invite to the Loyalists") as null|mob in orange(world.view, src)
	if(!M)
		return
	if(!M.mind)
		return
	convert_to_faction(src, M.mind, loyalists)

