/client/proc/dsay(msg as text)
	set category = "Special Verbs"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = 1
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(!src.mob)
		return


	if(!(prefs.toggles & CHAT_DEAD))
		to_chat(src, "<span class='warning'>You have deadchat muted.</span>")
		return

	if (src.handle_spam_prevention(msg,MUTE_DEADCHAT))
		return

	var/stafftype = uppertext(holder.rank)

	msg = sanitize(msg)
	log_admin("DSAY: [key_name(src)] : [msg]",admin_key=key_name(src))

	msg = process_chat_markup(msg)

	if (!msg)
		return

	say_dead_direct("<span class='name'>[stafftype]([src.holder.fakekey ? src.holder.fakekey : src.key])</span> says, <span class='message linkify'>\"[msg]\"</span>")

	feedback_add_details("admin_verb","D") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
