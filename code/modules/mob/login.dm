//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Login: [key_name(src)] from [lastKnownIP ? lastKnownIP : "localhost"]-[computer_id] || BYOND v[client.byond_version]")
	if(GLOB.config.guests_allowed) // shut up if guests allowed for testing
		return
	if(GLOB.config.logsettings["log_access"])
		for(var/mob/M in GLOB.player_list)
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
						message_admins(SPAN_WARNING("<B>Notice: </B></span><span class='notice'><A href='byond://?src=[REF(usr)];priv_msg=[REF(src)]'>[key_name_admin(src)]</A> has the same [matches] as <A href='byond://?src=[REF(usr)];priv_msg=[REF(M)]'>[key_name_admin(M)]</A>."), 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins(SPAN_WARNING("<B>Notice: </B></span><span class='notice'><A href='byond://?src=[REF(usr)];priv_msg=[REF(src)]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in). "), 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")

/mob
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

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
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOB_LOGIN)

	GLOB.player_list |= src
	update_Login_details()
	SSstatistics.update_status()

	client.images.Cut()				//remove the images such as AIs being unable to see runes
	client.screen.Cut()				//remove hud items just in case
	if(hud_used)
		qdel(hud_used)		//remove the hud objects
	hud_used = new /datum/hud(src)

	disconnect_time = null
	next_move = 1
	set_sight(sight|SEE_SELF)
	disconnect_time = null

	my_client = client

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
		winset(src, null, "mainwindow.macro=hotkeymode hotkey_toggle.is-checked=true mapwindow.map.focus=true")
	else
		winset(src, null, "mainwindow.macro=macro hotkey_toggle.is-checked=false input.focus=true")
	MOB_STOP_THINKING(src)

	clear_important_client_contents(client)
	enable_client_mobs_in_contents(client)

	CreateRenderers()
	update_client_color()
	add_click_catcher()

	if(client) //Should work based on "change_view" but we lack the infrastructure behind to make it useful, for now
		client.attempt_auto_fit_viewport()

	if(machine)
		machine.on_user_login(src)

	// Check code/modules/admin/verbs/antag-ooc.dm for definition
	client.add_aooc_if_necessary()

	if(client && !istype(src, /mob/abstract/new_player)) //Do not update the skybox if it's a new player mob, they don't see it anyways and it can runtime
		client.update_skybox(TRUE)

	if(spell_masters)
		for(var/atom/movable/screen/movable/spell_master/spell_master in spell_masters)
			spell_master.toggle_open(1)
			client.screen -= spell_master
