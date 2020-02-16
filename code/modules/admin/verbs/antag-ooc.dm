/client/proc/aooc(msg as text)
	set category = "OOC"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	if (istype(src.mob, /mob/abstract/observer) && !check_rights(R_ADMIN|R_MOD|R_CCIAA, 0))
		to_chat(src, "<span class='warning'>You cannot use AOOC while ghosting/observing!</span>")
		return

	if (handle_spam_prevention(msg, MUTE_AOOC))
		return

	msg = sanitize(msg)
	if(!msg)
		return

	var/display_name = src.key
	if (holder)
		display_name = "[display_name]([holder.rank])"
		if (holder.fakekey)
			display_name = holder.fakekey

	for(var/mob/M in mob_list)
		if (check_rights(R_ADMIN|R_MOD|R_CCIAA, 0, M) && M.client.aooc_mute_holder_check() == FALSE)
			to_chat(M, "<font color='#960018'><span class='ooc'>" + create_text_tag("aooc", "Antag-OOC:", M.client) + " <EM>[get_options_bar(src, 0, 1, 1)](<A HREF='?_src_=holder;adminplayerobservejump=\ref[src.mob]'>JMP</A>):</EM> <span class='message'>[msg]</span></span></font>")
		else if (M.mind && M.mind.special_role && M.client)
			to_chat(M, "<font color='#960018'><span class='ooc'>" + create_text_tag("aooc", "Antag-OOC:", M.client) + " <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>")

	log_ooc("(ANTAG) [key] : [msg]",ckey=key_name(mob))

// Checks if a newly joined player is an antag, and adds the AOOC verb if they are.
// Because they're tied to client objects, this gets removed every time you disconnect.
/client/proc/add_aooc_if_necessary()
	if (!src.mob || !src.mob.mind)
		return

	if (player_is_antag(src.mob.mind))
		src.verbs += /client/proc/aooc
