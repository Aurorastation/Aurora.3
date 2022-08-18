/client
	parent_type = /datum

		////////////////
		//ADMIN THINGS//
		////////////////
	var/datum/admins/holder = null
	var/datum/admins/deadmin_holder = null
	var/buildmode		= 0

		///////////////////
		//SPAM PROTECTION//
		///////////////////
	var/last_message	= "" //Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message_count = 0 //contins a number of how many times a message identical to last_message was sent.
	var/last_message_time
	var/spam_alert = 0

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs
	var/datum/tooltip/tooltips
	var/move_delay		= 1
	var/moving			= null
	var/adminobs		= null
	var/area			= null
	var/time_died_as_rat = 0
	var/list/autofire_aiming_at[2]

	var/adminhelped = NOT_ADMINHELPED

		///////////////
		//SOUND STUFF//
		///////////////
	var/ambient_hum_playing = null // "world.time".
	var/ambience_last_played_time = null // "world.time".

		////////////
		//SECURITY//
		////////////
	var/info_sent = 0
	// comment out the line below when debugging locally to enable the options & messages menu
	//control_freak = 1
	var/ip_intel = "Disabled"

	var/received_discord_pm = -99999
	var/discord_admin			//IRC- no more IRC, K? Discord admin that spoke with them last.
	var/mute_discord = 0


		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = "Requires database"	//So admins know why it isn't working - Used to determine how old the account is - in days.
	var/related_accounts_ip = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id
	var/whitelist_status = 0						//Used to determine what whitelists the player has access to. Uses bitflag values!
	var/need_saves_migrated = "Requires database"	//Used to determine whether or not the ckey needs their saves migrated over to the database. Default is 0 upon successful connection.
	var/account_age = -1							// Age on the BYOND account in days.
	var/account_join_date = null					// Date of the BYOND account creation in ISO 8601 format.
	var/unacked_warning_count = 0

	preload_rsc = PRELOAD_RSC

	var/authed = TRUE

	var/is_initialized = FALSE // Used to track whether the client has been initialized with InitClient.

	///goonchat chatoutput of the client
	var/datum/chatOutput/chatOutput