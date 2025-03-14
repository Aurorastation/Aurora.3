//
// Client Defines
//

/client
	parent_type = /datum

// Admin
	var/datum/admins/holder = null
	var/datum/admins/deadmin_holder = null

// Spam Protection
	var/last_message = "" // Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message_count = 0 // Contains a number of how many times a message identical to last_message was sent.
	var/last_message_time
	var/spam_alert = 0

// Sounds
	var/ambient_hum_playing = null // Is the ambient hum playing?
	var/ambience_last_played_time = null // "world.time".

// Security
	var/info_sent = 0
	// comment out the line below when debugging locally to enable the options & messages menu
	//control_freak = 1
	var/ip_intel = "Disabled"

	var/received_discord_pm = -99999
	var/discord_admin //IRC- no more IRC, K? Discord admin that spoke with them last.
	var/mute_discord = 0

// Database
	var/player_age = "Requires database" // So admins know why it isn't working - Used to determine how old the account is - in days.
	var/related_accounts_ip = "Requires database" //So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database" //So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id
	var/whitelist_status = 0 //Used to determine what whitelists the player has access to. Uses bitflag values!
	var/need_saves_migrated = "Requires database" //Used to determine whether or not the ckey needs their saves migrated over to the database. Default is 0 upon successful connection.
	var/account_age = -1 // Age on the BYOND account in days.
	var/account_join_date = null // Date of the BYOND account creation in ISO 8601 format.
	var/unacked_warning_count = 0

	preload_rsc = PRELOAD_RSC

	var/authed = TRUE

	var/is_initialized = FALSE // Used to track whether the client has been initialized with InitClient.

// Other
	var/datum/preferences/prefs
	var/datum/tooltip/tooltips
	var/move_delay		= 1
	var/moving			= null
	var/adminobs		= null
	var/area			= null
	var/time_died_as_rat = 0
	var/list/autofire_aiming_at[2]

	var/adminhelped = NOT_ADMINHELPED

	///Last ping of the client
	var/lastping = 0
	///Average ping of the client
	var/avgping = 0
	///world.time they connected
	var/connection_time
	///world.realtime they connected
	var/connection_realtime
	///world.timeofday they connected
	var/connection_timeofday

	// List of all asset filenames sent to this client by the asset cache, along with their assoicated md5s
	var/list/sent_assets = list()
	/// List of all completed blocking send jobs awaiting acknowledgement by send_asset
	var/list/completed_asset_jobs = list()
	/// Last asset send job id.
	var/last_asset_job = 0
	var/last_completed_asset_job = 0

	///Hide top bars
	var/fullscreen = FALSE

	/// our current tab
	var/stat_tab

	/// If this client has been fully initialized or not
	var/fully_created = FALSE

	/// list of all tabs
	var/list/panel_tabs = list()
	/// list of tabs containing spells and abilities
	var/list/spell_tabs = list()
	///Our object window datum. It stores info about and handles behavior for the object tab
	var/datum/object_window_info/obj_window
	///When we started the currently active drag
	var/drag_start = 0
	///The params we were passed at the start of the drag, in list form
	var/list/drag_details
