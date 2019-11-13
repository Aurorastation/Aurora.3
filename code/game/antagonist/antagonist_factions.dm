/mob/living/proc/convert_to_rev(mob/M as mob in oview(src))
	set name = "Convert Bourgeoise"
	set category = "Abilities"
	if(!M.mind)
		return
	for (var/obj/item/implant/loyalty/I in M)
		if (I.implanted)
			to_chat(src, "<span class='warning'>[M] is too loyal to the company!</span>")
			return
	convert_to_faction(M.mind, revs)

/mob/living/proc/convert_to_faction(var/datum/mind/player, var/datum/antagonist/faction)

	if(!player || !faction || !player.current)
		return

	if(!faction.faction_verb || !faction.faction_descriptor || !faction.faction_verb)
		return

	if(faction.is_antagonist(player))
		to_chat(src, "<span class='warning'>\The [player.current] already serves the [faction.faction_descriptor].</span>")
		return

	if(player_is_antag(player))
		to_chat(src, "<span class='warning'>\The [player.current]'s loyalties seem to be elsewhere...</span>")
		return

	if(!faction.can_become_antag(player) || isanimal(player.current))
		to_chat(src, "<span class='warning'>\The [player.current] cannot be \a [faction.faction_role_text]!</span>")
		return

	if(world.time < player.rev_cooldown)
		to_chat(src, "<span class='danger'>You must wait five seconds between attempts.</span>")
		return

	to_chat(src, "<span class='danger'>You are attempting to convert \the [player.current]...</span>")
	log_admin("[src]([src.ckey]) attempted to convert [player.current].",ckey=src.ckey,ckey_target=key_name(player.current))
	message_admins("<span class='danger'>[src]([src.ckey]) attempted to convert [player.current].</span>")

	player.rev_cooldown = world.time+100
	var/choice = alert(player.current,"Asked by [src]: Do you want to join the [faction.faction_descriptor]?","Join the [faction.faction_descriptor]?","No!","Yes!")
	if(choice == "Yes!" && faction.add_antagonist_mind(player, 0, faction.faction_role_text, faction.faction_welcome))
		to_chat(src, "<span class='notice'>\The [player.current] joins the [faction.faction_descriptor]!</span>")
		return
	if(choice == "No!")
		to_chat(player, "<span class='danger'>You reject this traitorous cause!</span>")
	to_chat(src, "<span class='danger'>\The [player.current] does not support the [faction.faction_descriptor]!</span>")

/mob/living/proc/convert_to_loyalist(mob/M as mob in oview(src))
	set name = "Convert Recidivist"
	set category = "Abilities"
	if(!M.mind)
		return
	convert_to_faction(M.mind, loyalists)
