/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN))	return

	msg = sanitize(msg)
	if(!msg)	return

	log_admin("ADMIN: [key_name(src)] : [msg]",admin_key=key_name(src))

	if(check_rights(R_ADMIN,0))
		for(var/s in staff)
			var/client/C = s
			if(R_ADMIN & C.holder.rights)
				to_chat(C, "<span class='admin_channel'>" + create_text_tag("ADMIN", C) + " <span class='name'>[key_name(usr, 1)]</span>([admin_jump_link(mob, src)]): <span class='message linkify'>[msg]</span></span>")

	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_mod_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD))	return

	msg = sanitize(msg)
	log_admin("MOD: [key_name(src)] : [msg]",admin_key=key_name(src))

	if (!msg)
		return

	var/sender_name = key_name(usr, 1)
	if(check_rights(R_ADMIN, 0))
		sender_name = "<span class='admin'>[sender_name]</span>"
	for(var/s in staff)
		var/client/C = s
		if ((R_ADMIN|R_MOD) & C.holder.rights)
			to_chat(C, "<span class='mod_channel'>" + create_text_tag("MOD", C) + " <span class='name'>[sender_name]</span>(<A HREF='?src=\ref[C.holder];adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message linkify'>[msg]</span></span>")

	feedback_add_details("admin_verb","MS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_dev_say(msg as text)
	set category = "Special Verbs"
	set name = "Devsay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_DEV)) return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	log_admin("DEV: [key_name(src)] : [msg]",admin_key=key_name(src))

	if(check_rights(R_DEV,0))
		msg = "<span class='devsay'>[create_text_tag("DEV")] <EM>[key_name(usr, 0, 1, 0)]</EM>: <span class='message linkify'>[msg]</span></span>"
		for(var/s in staff)
			var/client/C = s
			if(C.holder.rights & (R_ADMIN|R_DEV))
				to_chat(C, msg)

/client/proc/cmd_cciaa_say(msg as text)
	set category = "Special Verbs"
	set name = "Dosay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_CCIAA)) return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	log_admin("CCIASAY: [key_name(src)] : [msg]",admin_key=key_name(src))

	if(check_rights((R_CCIAA|R_ADMIN),0))
		msg = "<span class='cciaasay'><span class='prefix'>CCIAAgent:</span> <EM>[key_name(usr, 0, 1, 0)]</EM>: <span class='message linkify'>[msg]</span></span>"
		for(var/s in staff)
			var/client/C = s
			if(C.holder.rights & (R_ADMIN|R_CCIAA))
				to_chat(C, msg)
