//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Login: [key_name(src)] from [lastKnownIP ? lastKnownIP : "localhost"]-[computer_id] || BYOND v[client.byond_version]",ckey=key_name(src))
	if(config.log_access)
		for(var/mob/M in player_list)
			if(M == src)	continue
			if( M.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == client.address) )
					matches += "IP ([client.address])"
				if( (client.connection != "web") && (M.computer_id == client.computer_id) )
					if(matches)	matches += " and "
					matches += "ID ([client.computer_id])"
					spawn() alert("You have logged in already with another key this round, please log out of this one NOW or risk being banned!")
				if(matches)
					if(M.client)
						message_admins("<span class='warning'><B>Notice: </B></span><span class='notice'><A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as <A href='?src=\ref[usr];priv_msg=\ref[M]'>[key_name_admin(M)]</A>.</span>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)].",ckey=key_name(src))
					else
						message_admins("<span class='warning'><B>Notice: </B></span><span class='notice'><A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in). </span>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).",ckey=key_name(src))

/**
 * Currently marked as SHOULD_NOT_OVERRIDE.
 *
 * In the case of Aurora code, mob/Login is invoked BEFORE client initialization
 * is completed, in order to permit remote authentication.
 *
 * This also invokes mob/proc/LateLogin in cases where the client has already been
 * initialized. This is the case when a ckey is moved around from mob to mob during
 * gameplay.
 *
 * Use /mob/proc/LateLogin() instead.
 */
/mob/Login()
	SHOULD_NOT_OVERRIDE(TRUE)

	..()

	if (client.is_initialized)
		LateLogin()

/**
 * \brief A function to replace most uses of mob/Login with. 99% of the time, you
 * should implement an override of this function.
 *
 * This function is invoked AFTER client/proc/InitClient and client/proc/InitPrefs.
 * It can expect the client.ckey to be properly populated with the client's final
 * ckey.
 */
/mob/proc/LateLogin()
	SHOULD_CALL_PARENT(TRUE)

	player_list |= src
	update_Login_details()
	SSfeedback.update_status()

	client.images.Cut()				//remove the images such as AIs being unable to see runes
	client.screen.Cut()				//remove hud items just in case
	if(hud_used)
		qdel(hud_used)		//remove the hud objects
	hud_used = new /datum/hud(src)

	disconnect_time = null
	next_move = 1
	set_sight(sight|SEE_SELF)
	disconnect_time = null

	player_age = client.player_age

	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE

	if(eyeobj)
		eyeobj.possess(src)

	//set macro to normal incase it was overriden (like cyborg currently does)
	if(client.prefs.toggles_secondary & HOTKEY_DEFAULT)
		winset(src, null, "mainwindow.macro=hotkeymode hotkey_toggle.is-checked=true mapwindow.map.focus=true input.background-color=#D3B5B5")
	else
		winset(src, null, "mainwindow.macro=macro hotkey_toggle.is-checked=false input.focus=true input.background-color=#D3B5B5")
	MOB_STOP_THINKING(src)

	clear_important_client_contents(client)
	enable_client_mobs_in_contents(client)

	update_client_color()
	add_click_catcher()

	if(machine)
		machine.on_user_login(src)

	// Check code/modules/admin/verbs/antag-ooc.dm for definition
	client.add_aooc_if_necessary()

	client.chatOutput.start()
