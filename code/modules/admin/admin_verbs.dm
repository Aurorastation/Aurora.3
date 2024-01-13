//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list(
	/datum/admins/proc/show_player_panel,	//shows an interface for individual players, with various links (links require additional flags),
	/client/proc/player_panel_modern,
	/client/proc/toggleadminhelpsound,	/*toggles whether we hear a sound when adminhelps/PMs are used*/
	/client/proc/deadmin_self,			/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	/client/proc/hide_most_verbs,		/*hides all our hideable adminverbs*/
	/client/proc/cmd_mentor_check_new_players,
	/client/proc/notification_add		/*allows everyone to set up player notifications*/
	)
var/list/admin_verbs_admin = list(
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game.*/
	/client/proc/invisimin,				/*allows our mob to go invisible/visible*/
//	/datum/admins/proc/show_traitor_panel,	/*interface which shows a mob's mind*/ -Removed due to rare practical use. Moved to debug verbs ~Errorage */
	/datum/admins/proc/show_game_mode,  /*Configuration window for the current game mode.*/
	/datum/admins/proc/force_mode_latespawn, /*Force the mode to try a latespawn proc*/
	/datum/admins/proc/force_antag_latespawn, /*Force a specific template to try a latespawn proc*/
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/toggleguests,	/*toggles whether guests can join the current game*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/client/proc/colorooc,				/*allows us to set a custom colour for everythign we say in ooc*/
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,	/*admin-pm list*/
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/datum/admins/proc/access_news_network,	/*allows access of newscasters*/
	/client/proc/giveruntimelog,		/*allows us to give access to runtime logs to somebody*/
	/client/proc/getserverlog,			/*allows us to fetch server logs (diary) for other days*/
	/client/proc/view_signal_log,		/*allows admins to check the log of signaler uses*/
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/jumptozlevel,
	/client/proc/jumptoshuttle,
	/client/proc/jumptoship,
	/client/proc/jumptosector,
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
//	/client/proc/sendmob,				/*sends a mob somewhere*/ -Removed due to it needing two sorting procs to work, which were executed every time an admin right-clicked. ~Errorage */
	/client/proc/Jump,
	/client/proc/jumptokey,				//allows us to jump to the location of a mob with a certain ckey,
	/client/proc/jumptomob,				//allows us to jump to a specific mob,
	/client/proc/jumptoturf,			//allows us to jump to a specific turf,
	/client/proc/admin_call_shuttle,	//allows us to call the emergency shuttle,
	/client/proc/admin_cancel_shuttle,	//allows us to cancel the emergency shuttle, sending it back to centcomm,
	/client/proc/cmd_admin_direct_narrate,	//send text directly to a player with no padding. Useful for narratives and fluff-text,
	/client/proc/cmd_admin_local_narrate,	//sends text to all mobs within 7 tiles of src.mob
	/client/proc/cmd_admin_world_narrate,	//sends text to all players with no padding,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/check_ai_laws,			//shows AI and borg laws,
	/client/proc/rename_silicon,		//properly renames silicons,
	/client/proc/manage_silicon_laws,
	/client/proc/check_antagonists,
	/client/proc/dsay,					/*talk in deadchat using our ckey/fakekey*/
	/client/proc/toggleprayers,			/*toggles prayers on/off*/
//	/client/proc/toggle_hear_deadcast,	/*toggles whether we hear deadchat*/
	/client/proc/toggle_hear_radio,		/*toggles whether we hear the radio*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/secrets,
	/datum/admins/proc/toggleooc,		//toggles ooc on/off for everyone,
	/datum/admins/proc/togglelooc,		//toggles looc on/off for everyone,
	/datum/admins/proc/toggleoocdead,	//toggles ooc on/off for everyone who is dead,
	/datum/admins/proc/toggledsay,		//toggles dsay on/off for everyone,
	/client/proc/game_panel,			//game panel, allows to change game-mode etc,
	/client/proc/cmd_admin_say,			//admin-only ooc chat,
	/datum/admins/proc/PlayerNotes,
	/client/proc/cmd_mod_say,
	/datum/admins/proc/show_player_info,
	/client/proc/free_slot,			//frees slot for chosen job,
	/client/proc/cmd_admin_change_custom_event,
	/client/proc/cmd_admin_rejuvenate,
	/client/proc/toggleattacklogs,
	/client/proc/toggledebuglogs,
	/client/proc/toggleghostwriters,
	/client/proc/toggledrones,
	/client/proc/damage_menu,
	/client/proc/man_up,
	/client/proc/global_man_up,
	/client/proc/response_team, // Response Teams admin verb,
	/client/proc/toggle_antagHUD_use,
	/client/proc/toggle_antagHUD_restrictions,
	/client/proc/allow_stationbound_reset,
	/client/proc/end_round,
	/client/proc/event_manager_panel,
	/client/proc/empty_ai_core_toggle_latejoin,
	/client/proc/aooc,
	/client/proc/change_human_appearance_admin,	// Allows an admin to change the basic appearance of human-based mobs ,
	/client/proc/change_human_appearance_self,	// Allows the human-based mob itself change its basic appearance ,
	/client/proc/change_security_level,
	/client/proc/view_chemical_reaction_logs,
	/client/proc/makePAI,
	/datum/admins/proc/paralyze_mob,
	/datum/admins/proc/create_admin_fax,
	/client/proc/check_fax_history,
	/client/proc/cmd_cciaa_say,
	/client/proc/cmd_dev_say,
	/client/proc/cmd_dev_bst,
	/client/proc/clear_toxins,
	/client/proc/wipe_ai,	// allow admins to force-wipe AIs
	/client/proc/fix_player_list,
	/client/proc/reset_openturf,
	/client/proc/toggle_aooc,
	/client/proc/force_away_mission,
	/client/proc/alooc
)
var/list/admin_verbs_ban = list(
	/client/proc/unban_panel,
	/client/proc/jobbans,
	/client/proc/warning_panel,
	/client/proc/stickybanpanel
	)
var/list/admin_verbs_sounds = list(
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/play_server_sound
	)
var/list/admin_verbs_fun = list(
	/client/proc/object_talk,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_grab_observers,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/everyone_random,
	/client/proc/cinematic,
	/datum/admins/proc/toggle_space_ninja,
	/datum/admins/proc/toggle_round_spookyness,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/make_sound,
	/client/proc/toggle_random_events,
	/client/proc/editappear,
	/client/proc/roll_dices,
	/datum/admins/proc/create_admin_fax,
	/datum/admins/proc/call_supply_drop,
	/datum/admins/proc/call_drop_pod,
	/client/proc/show_tip,
	/client/proc/fab_tip,
	/client/proc/apply_sunstate,
	/datum/admins/proc/ccannoucment
	)

var/list/admin_verbs_spawn = list(
	/client/proc/game_panel,
	/datum/admins/proc/spawn_fruit,
	/datum/admins/proc/spawn_custom_item,
	/datum/admins/proc/spawn_plant,
	/datum/admins/proc/spawn_atom,		// allows us to spawn instances,
	/client/proc/respawn_character,
	/client/proc/spawn_chemdisp_cartridge
	)
var/list/admin_verbs_server = list(
	/datum/admins/proc/capture_map_part,
	/client/proc/Set_Holiday,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/datum/admins/proc/immreboot,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,		// delete an instance/object/mob/etc,
	/client/proc/cmd_debug_del_all,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/datum/admins/proc/toggle_round_spookyness,
	/datum/admins/proc/toggle_space_ninja,
	/client/proc/toggle_random_events,
	/client/proc/nanomapgen_DumpImage,
	/client/proc/toggle_recursive_explosions,
	/client/proc/restart_controller,
	/client/proc/cmd_ss_panic,
	/client/proc/configure_access_control,
	/datum/admins/proc/togglehubvisibility, //toggles visibility on the BYOND Hub
	/client/proc/force_away_mission
	)
var/list/admin_verbs_debug = list(
	/client/proc/getruntimelog,                     // allows us to access runtime logs to somebody,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/Debug2,
	/client/proc/DebugToggle,
	/client/proc/DebugToggleAll,
	/client/proc/kill_air,
	/client/proc/ZASSettings,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/kill_airgroup,
	/client/proc/debug_controller,
	/client/proc/debug_antagonist_template,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/air_report,
	/client/proc/reload_admins,
	/client/proc/print_random_map,
	/client/proc/create_random_map,
	/client/proc/apply_random_map,
	/client/proc/overlay_random_map,
	/client/proc/delete_random_map,
	/client/proc/show_plant_genes,
	/client/proc/enable_debug_verbs,
	/client/proc/callproc,
	/client/proc/callproc_target,
	/client/proc/toggledebuglogs,
	/client/proc/SDQL2_query,
	/client/proc/Jump,
	/client/proc/jumptomob,
	/client/proc/jumptocoord,
	/client/proc/jumptozlevel,
	/client/proc/jumptoshuttle,
	/client/proc/jumptoship,
	/client/proc/jumptosector,
	/client/proc/dsay,
	/client/proc/toggle_recursive_explosions,
	/client/proc/restart_sql,
	/client/proc/fix_player_list,
	/client/proc/lighting_show_verbs,
	/client/proc/restart_controller,
	/client/proc/cmd_display_del_log,
	/client/proc/cmd_display_init_log,
	/client/proc/cmd_ss_panic,
	/client/proc/reset_openturf,
	/datum/admins/proc/capture_map,
	/datum/admins/proc/map_template_load,
	/datum/admins/proc/map_template_load_new_z,
	/datum/admins/proc/map_template_upload,
	/client/proc/global_ao_regenerate,
	/client/proc/add_client_color,
	/client/proc/connect_ntsl,
	/client/proc/disconnect_ntsl,
	/turf/proc/view_chunk,
	/turf/proc/update_chunk,
	/client/proc/profiler_start,
	/client/proc/rustg_send_udp
	)

var/list/admin_verbs_paranoid_debug = list(
	/client/proc/callproc,
	/client/proc/callproc_target,
	/client/proc/debug_controller
	)

var/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
	)
var/list/admin_verbs_permissions = list(
	/client/proc/edit_admin_permissions
	)
var/list/admin_verbs_rejuv = list(
	/client/proc/respawn_character
	)

//verbs which can be hidden
var/list/admin_verbs_hideable = list(
	/client/proc/allow_character_respawn,
	/client/proc/toggle_view_range,
	/client/proc/stealth,
	/datum/admins/proc/toggle_round_spookyness,
	/client/proc/Getkey,
	/datum/admins/proc/announce,
	/client/proc/togglebuildmodeself,
	/client/proc/change_human_appearance_admin,
	/client/proc/change_human_appearance_self,
	/client/proc/change_security_level,
	/client/proc/makePAI,
	/client/proc/wipe_ai,
	/client/proc/toggleghostwriters,
	/client/proc/toggledrones,
	/client/proc/restart_sql,
	/client/proc/damage_menu,
	/client/proc/man_up,
	/client/proc/global_man_up,
	/client/proc/connect_ntsl,
	/client/proc/disconnect_ntsl,
	/client/proc/response_team,
	/client/proc/toggle_antagHUD_use,
	/client/proc/toggle_antagHUD_restrictions,
	/client/proc/event_manager_panel,
	/client/proc/empty_ai_core_toggle_latejoin,
	/client/proc/empty_ai_core_toggle_latejoin,
	/client/proc/cmd_admin_change_custom_event,
	/datum/admins/proc/togglehubvisibility,
	/datum/admins/proc/toggleooc,
	/datum/admins/proc/togglelooc,
	/datum/admins/proc/toggleoocdead,
	/datum/admins/proc/toggledsay,
	/client/proc/rename_silicon,
	/client/proc/manage_silicon_laws,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_local_narrate,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/cmd_admin_grab_observers,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/show_tip,
	/client/proc/fab_tip,
	/client/proc/jumptokey,
	/client/proc/jumptomob,
	/client/proc/jumptoturf,
	/client/proc/cmd_cciaa_say,
	/datum/admins/proc/access_news_network,
	/client/proc/jumptocoord,
	/client/proc/jumptozlevel,
	/client/proc/jumptoshuttle,
	/client/proc/jumptoship,
	/client/proc/jumptosector,
	/client/proc/colorooc,
	/client/proc/add_client_color,
	/datum/admins/proc/force_mode_latespawn,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/capture_map_part,
	/client/proc/Set_Holiday,
	/client/proc/configure_access_control,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/client/proc/create_poll,
	/client/proc/allow_stationbound_reset,
	/client/proc/end_round,
	/datum/admins/proc/immreboot,
	/client/proc/cmd_dev_bst,
	/client/proc/global_ao_regenerate,
	/client/proc/everyone_random,
	/datum/admins/proc/toggleAI,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/launch_ccia_shuttle,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/datum/admins/proc/toggle_space_ninja,
	/client/proc/toggle_random_events,
	/client/proc/nanomapgen_DumpImage,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/play_server_sound,
	/client/proc/make_sound,
	/client/proc/cmd_ss_panic,
	/client/proc/object_talk,
	/client/proc/cmd_admin_gib_self,
	/client/proc/drop_bomb,
	/client/proc/everyone_random,
	/client/proc/cinematic,
	/datum/admins/proc/toggle_space_ninja,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/toggle_recursive_explosions,
	/client/proc/toggle_random_events,
	/client/proc/editappear,
	/client/proc/roll_dices,
	/datum/admins/proc/call_supply_drop,
	/datum/admins/proc/call_drop_pod,
	/datum/admins/proc/spawn_fruit,
	/datum/admins/proc/spawn_custom_item,
	/datum/admins/proc/spawn_plant,
	/client/proc/show_plant_genes,
	/datum/admins/proc/spawn_atom,
	/client/proc/respawn_character,
	/client/proc/spawn_chemdisp_cartridge,
	/client/proc/jobbans,
	/client/proc/investigate_show,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/reset_openturf,
	/client/proc/Debug2,
	/client/proc/DebugToggle,
	/client/proc/DebugToggleAll,
	/client/proc/ZASSettings,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/debug_antagonist_template,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_debug_del_all,
	/client/proc/air_report,
	/client/proc/reload_admins,
	/client/proc/restart_controller,
	/client/proc/print_random_map,
	/client/proc/create_random_map,
	/client/proc/apply_random_map,
	/client/proc/overlay_random_map,
	/client/proc/delete_random_map,
	/client/proc/enable_debug_verbs,
	/client/proc/fix_player_list,
	/client/proc/SDQL2_query,
	/client/proc/cmd_admin_dress,
	/client/proc/kill_air,
	/client/proc/kill_airgroup,
	/client/proc/cmd_display_del_log,
	/datum/admins/proc/ccannoucment,
	/client/proc/cmd_display_init_log,
	/client/proc/getruntimelog,
	/client/proc/giveruntimelog,
	/client/proc/toggledebuglogs,
	/client/proc/getserverlog,
	/client/proc/view_chemical_reaction_logs,
	/datum/admins/proc/capture_map,
	/turf/proc/view_chunk,
	/turf/proc/update_chunk,
	/client/proc/lighting_show_verbs,
	/client/proc/callproc,
	/client/proc/callproc_target,
	/client/proc/debug_controller,
	/client/proc/print_logout_report,
	/client/proc/edit_admin_permissions,
	/proc/possess,
	/proc/release,
	/client/proc/force_away_mission,
	/client/proc/profiler_start,
	/client/proc/rustg_send_udp
	)
var/list/admin_verbs_mod = list(
	/client/proc/cmd_admin_pm_context,	// right-click adminPM interface,
	/client/proc/cmd_admin_pm_panel,	// admin-pm list,
	/client/proc/debug_variables,		// allows us to -see- the variables of any instance in the game.,
	/client/proc/toggledebuglogs,
	/datum/admins/proc/PlayerNotes,
	/client/proc/admin_ghost,			// allows us to ghost/reenter body at will,
	/client/proc/cmd_mod_say,
	/datum/admins/proc/show_player_info,
	/client/proc/dsay,
	/datum/admins/proc/show_player_panel,
	/client/proc/check_antagonists,
	/client/proc/jobbans,
	/client/proc/cmd_admin_subtle_message, 	/*send an message to somebody as a 'voice in their head'*/
	/datum/admins/proc/paralyze_mob,
	/client/proc/toggleattacklogs,
	/client/proc/cmd_admin_check_contents,
	/client/proc/print_logout_report,
	/client/proc/check_ai_laws,			/*shows AI and borg laws*/
	/client/proc/aooc,
	/client/proc/toggle_aooc,
	/client/proc/alooc,
	/client/proc/allow_character_respawn
)

var/list/admin_verbs_dev = list( //will need to be altered - Ryan784
	///datum/admins/proc/restart,
	/client/proc/Jump,
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/cmd_admin_pm_context,
	/client/proc/cmd_admin_pm_panel,	//admin-pm list
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/jumptozlevel,
	/client/proc/jumptoshuttle,
	/client/proc/jumptoship,
	/client/proc/jumptosector,
	/client/proc/cmd_dev_say,
	/client/proc/nanomapgen_DumpImage,
	/client/proc/admin_ghost,
	/client/proc/air_report,
	/client/proc/enable_debug_verbs,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/Debug2,
	/client/proc/DebugToggle,
	/client/proc/DebugToggleAll,
	/client/proc/debug_controller,
	/client/proc/debug_variables,
	/client/proc/dsay,
	/client/proc/getruntimelog,
	/client/proc/giveruntimelog,
	/client/proc/hide_most_verbs,
	/client/proc/kill_air,
	/client/proc/kill_airgroup,
	/client/proc/player_panel_modern,
	/client/proc/togglebuildmodeself,
	/client/proc/toggledebuglogs,
	/client/proc/ZASSettings,
	/client/proc/cmd_dev_bst,
	/client/proc/lighting_show_verbs,
	/client/proc/cmd_display_del_log,
	/client/proc/cmd_display_init_log,
	/client/proc/create_poll, //Allows to create polls
	/client/proc/profiler_start,
	/client/proc/rustg_send_udp
)
var/list/admin_verbs_cciaa = list(
	/client/proc/cmd_admin_pm_panel,	/*admin-pm list*/
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_cciaa_say,
	/datum/admins/proc/create_admin_fax,
	/client/proc/launch_ccia_shuttle,
	/client/proc/check_fax_history,
	/client/proc/aooc,
	/client/proc/check_antagonists,
	/client/proc/toggle_aooc
)

/client/proc/add_admin_verbs()
	if(holder)
		add_verb(src, admin_verbs_default)
		if(holder.rights & R_BUILDMODE)		add_verb(src, /client/proc/togglebuildmodeself)
		if(holder.rights & R_ADMIN)			add_verb(src, admin_verbs_admin)
		if(holder.rights & R_BAN)			add_verb(src, admin_verbs_ban)
		if(holder.rights & R_FUN)			add_verb(src, admin_verbs_fun)
		if(holder.rights & R_SERVER)		add_verb(src, admin_verbs_server)
		if(holder.rights & R_DEBUG)
			add_verb(src, admin_verbs_debug)
			if(GLOB.config.debugparanoid && !(holder.rights & R_ADMIN))
				remove_verb(src, admin_verbs_paranoid_debug)			//Right now it's just callproc but we can easily add others later on.
		if(holder.rights & R_POSSESS)		add_verb(src, admin_verbs_possess)
		if(holder.rights & R_PERMISSIONS)	add_verb(src, admin_verbs_permissions)
		if(holder.rights & R_STEALTH)		add_verb(src, /client/proc/stealth)
		if(holder.rights & R_REJUVINATE)	add_verb(src, admin_verbs_rejuv)
		if(holder.rights & R_SOUNDS)		add_verb(src, admin_verbs_sounds)
		if(holder.rights & R_SPAWN)			add_verb(src, admin_verbs_spawn)
		if(holder.rights & R_MOD)			add_verb(src, admin_verbs_mod)
		if(holder.rights & R_DEV)			add_verb(src, admin_verbs_dev)
		if(holder.rights & R_CCIAA)			add_verb(src, admin_verbs_cciaa)

/client/proc/remove_admin_verbs()
	remove_verb(src, admin_verbs_default)
	remove_verb(src, /client/proc/togglebuildmodeself)
	remove_verb(src, admin_verbs_admin)
	remove_verb(src, admin_verbs_ban)
	remove_verb(src, admin_verbs_fun)
	remove_verb(src, admin_verbs_server)
	remove_verb(src, admin_verbs_debug)
	remove_verb(src, admin_verbs_possess)
	remove_verb(src, admin_verbs_permissions)
	remove_verb(src, /client/proc/stealth)
	remove_verb(src, admin_verbs_rejuv)
	remove_verb(src, admin_verbs_sounds)
	remove_verb(src, admin_verbs_spawn)
	remove_verb(src, debug_verbs)
	add_aooc_if_necessary()

/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin"

	remove_verb(src, admin_verbs_hideable)
	add_verb(src, /client/proc/show_verbs)

	to_chat(src, "<span class='interface'>Most of your adminverbs have been hidden.</span>")
	feedback_add_details("admin_verb","HMV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	add_verb(src, /client/proc/show_verbs)

	to_chat(src, "<span class='interface'>Almost all of your adminverbs have been hidden.</span>")
	feedback_add_details("admin_verb","TAVVH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	remove_verb(src, /client/proc/show_verbs)
	add_admin_verbs()

	to_chat(src, "<span class='interface'>All of your adminverbs are now visible.</span>")
	feedback_add_details("admin_verb","TAVVS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)	return
	if(istype(mob,/mob/abstract/observer))
		//re-enter
		var/mob/abstract/observer/ghost = mob
		if(ghost.can_reenter_corpse)
			ghost.reenter_corpse()
			log_admin("[src] reentered their corpose using aghost.",admin_key=key_name(src))
		else
			to_chat(ghost, "<span class='warning'>Error: Aghost: Can't reenter corpse.</span>")
			return

		feedback_add_details("admin_verb","P") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	else if(istype(mob,/mob/abstract/new_player))
		to_chat(src, "<span class='warning'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</span>")
	else
		//ghostize
		var/mob/body = mob
		var/mob/abstract/observer/ghost = body.ghostize(1)
		ghost.admin_ghosted = 1
		if(body)
			body.teleop = ghost
			if(!body.key)
				body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		feedback_add_details("admin_verb","O") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		log_admin("[src] aghosted.",admin_key=key_name(src))

/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.set_invisibility(initial(mob.invisibility))
			to_chat(mob, "<span class='danger'>Invisimin off. Invisibility reset.</span>")
			mob.alpha = max(mob.alpha + 100, 255)
		else
			mob.set_invisibility(INVISIBILITY_OBSERVER)
			to_chat(mob, "<span class='notice'><b>Invisimin on. You are now as invisible as a ghost.</b></span>")
			mob.alpha = max(mob.alpha - 100, 0)

/client/proc/player_panel_modern()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		var/static/datum/tgui_module/moderator/shared/player_panel/global_player_panel = new()
		global_player_panel.ui_interact(usr)
	feedback_add_details("admin_verb","PPM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return


/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin"
	if(holder)
		var/static/datum/tgui_module/moderator/shared/check_antagonists/global_check_antags = new()
		global_check_antags.ui_interact(usr)
	feedback_add_details("admin_verb","CHA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/jobbans()
	set name = "Display Job bans"
	set category = "Admin"
	if(holder)
		if(GLOB.config.ban_legacy_system)
			holder.Jobbans()
		else
			holder.DB_ban_panel()
	feedback_add_details("admin_verb","VJB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		if(GLOB.config.ban_legacy_system)
			holder.unbanpanel()
		else
			holder.DB_ban_panel()
	feedback_add_details("admin_verb","UBP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()
	feedback_add_details("admin_verb","GP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()
	feedback_add_details("admin_verb","S") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/colorooc()
	set category = "Fun"
	set name = "OOC Text Color"
	if(!holder)	return
	var/response = alert(src, "Please choose a distinct color that is easy to read and doesn't mix with all the other chat and radio frequency colors.", "Change own OOC color", "Pick new color", "Reset to default", "Cancel")
	if(response == "Pick new color")
		prefs.ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color
	else if(response == "Reset to default")
		prefs.ooccolor = initial(prefs.ooccolor)
	prefs.save_preferences()

	feedback_add_details("admin_verb","OC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
		else
			var/new_key = ckeyEx(input("Enter your desired display name.", "Fake Key", key) as text|null)
			if(!new_key)	return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]", admin_key=key_name(usr),ckey=holder.fakekey)
		message_admins("[key_name_admin(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]", 1)
	feedback_add_details("admin_verb","SM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/drop_bomb() // Some admin dickery that can probably be done better -- TLE
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = tgui_input_list(usr, "What size explosion would you like to produce?", "Drop Bomb", choices)
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = tgui_input_number(usr, "Set the devastation range (in tiles).", "Devastation")
			var/heavy_impact_range = tgui_input_number(usr, "Set the heavy impact range (in tiles).", "Heavy")
			var/light_impact_range = tgui_input_number(usr, "Set the light impact range (in tiles).", "Light")
			var/flash_range = tgui_input_number(usr, "Set the flash range (in tiles).", "Flash")
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins("<span class='notice'>[ckey] creating an admin explosion at [epicenter.loc].</span>")
	feedback_add_details("admin_verb","DB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/make_sound(var/obj/O in range(world.view)) // -- TLE
	set category = "Special Verbs"
	set name = "Make Sound"
	set desc = "Display a message to everyone who can hear the target"
	if(O)
		var/message = sanitize(input("What do you want the message to be?", "Make Sound") as text|null)
		if(!message)
			return
		for (var/mob/V in hearers(O))
			V.show_message(message, 2)
		log_admin("[key_name(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound",admin_key=key_name(usr))
		message_admins("<span class='notice'>[key_name_admin(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound</span>", 1)
		feedback_add_details("admin_verb","MS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"
	if(src.mob)
		togglebuildmode(src.mob)
	feedback_add_details("admin_verb","TBMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/object_talk(var/msg as text) // -- TLE
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)
	feedback_add_details("admin_verb","OT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/kill_air() // -- TLE
	set category = "Debug"
	set name = "Kill Air"
	set desc = "Toggle Air Processing"
	if(!SSair.can_fire)
		SSair.can_fire = TRUE
		to_chat(usr, "<b>Enabled air processing.</b>")
	else
		if(alert("Confirm disabling air processing?",,"Yes","No") == "No")
			return
		SSair.can_fire = FALSE
		to_chat(usr, "<b>Disabled air processing.</b>")
	feedback_add_details("admin_verb","KA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] used 'kill air'.",admin_key=key_name(usr))
	message_admins("<span class='notice'>[key_name_admin(usr)] used 'kill air'.</span>", 1)

/client/proc/readmin_self()
	set name = "Re-Admin self"
	set category = "Admin"

	if(deadmin_holder)
		deadmin_holder.reassociate()
		log_admin("[src] re-admined themself.",admin_key=key_name(src))
		message_admins("[src] re-admined themself.", 1)
		to_chat(src, "<span class='interface'>You now have the keys to control the galaxy, or at least a small space ship</span>")
		remove_verb(src, /client/proc/readmin_self)

/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"


	if(holder)
		if(alert("Confirm self-deadmin for the round? You can re-admin yourself at any time.",,"Yes","No") == "Yes")
			log_admin("[src] deadmined themself.",admin_key=key_name(src))
			message_admins("[src] deadmined themself.", 1)
			deadmin()
			to_chat(src, "<span class='interface'>You are now a normal player.</span>")
			add_verb(src, /client/proc/readmin_self)
	feedback_add_details("admin_verb","DAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_aooc()
	set name = "Toggle AOOC"
	set category = "Admin"

	if(!check_rights(R_ADMIN|R_MOD|R_CCIAA))
		return

	if(holder)
		if (toggle_aooc_holder_check() == FALSE)
			to_chat(src, "<span class='notice'>AOOC is now muted.</span>")
			remove_verb(src, /client/proc/aooc)
		else
			to_chat(src, "<span class='notice'>AOOC is now unmuted.</span>")
			add_verb(src, /client/proc/aooc)

	feedback_add_details("admin_verb","TAOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin"
	if(holder)
		src.holder.output_ai_laws()

/client/proc/rename_silicon()
	set name = "Rename Silicon"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Rename Silicon.") as null|anything in GLOB.silicon_mob_list
	if(!S) return

	var/new_name = sanitizeSafe(input(src, "Enter new name. Leave blank or as is to cancel.", "[S.real_name] - Enter new silicon name", S.real_name))
	if(new_name && new_name != S.real_name)
		log_and_message_admins("has renamed the silicon '[S.real_name]' to '[new_name]'")
		S.SetName(new_name)
	feedback_add_details("admin_verb","RAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/manage_silicon_laws()
	set name = "Manage Silicon Laws"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Manage Silicon Laws") as null|anything in GLOB.silicon_mob_list
	if(!S) return

	var/datum/tgui_module/admin/law_manager/L = new(S)
	L.ui_interact(usr)
	log_and_message_admins("has opened [S]'s law manager.")
	feedback_add_details("admin_verb","MSL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/change_human_appearance_admin()
	set name = "Change Mob Appearance - Admin"
	set desc = "Allows you to change the mob appearance"
	set category = "Admin"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = tgui_input_list(usr, "Select mob.", "Change Mob Appearance - Self", GLOB.human_mob_list)
	if(!H) return

	log_and_message_admins("is altering the appearance of [H].")
	H.change_appearance(APPEARANCE_ALL, usr, FALSE)
	feedback_add_details("admin_verb","CHAA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/change_human_appearance_self()
	set name = "Change Mob Appearance - Self"
	set desc = "Allows the mob to change its appearance"
	set category = "Admin"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = tgui_input_list(usr, "Select mob.", "Change Mob Appearance - Self", GLOB.human_mob_list)
	if(!H) return

	if(!H.client)
		to_chat(usr, "Only mobs with clients can alter their own appearance.")
		return

	switch(alert("Do you wish for [H] to be allowed to select non-whitelisted races?","Alter Mob Appearance","Yes","No","Cancel"))
		if("Yes")
			log_and_message_admins("has allowed [H] to change [H.get_pronoun("his")] appearance, without whitelisting of races.")
			H.change_appearance(APPEARANCE_ALL, H, FALSE)
		if("No")
			log_and_message_admins("has allowed [H] to change [H.get_pronoun("his")] appearance, with whitelisting of races.")
			H.change_appearance(APPEARANCE_ALL, H, TRUE)
	feedback_add_details("admin_verb","CMAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/change_security_level()
	set name = "Set security level"
	set desc = "Sets the station security level"
	set category = "Admin"

	if(!check_rights(R_ADMIN))
		return
	var/sec_level = tgui_input_list(usr, "It's currently code [get_security_level()].", "Select Security Level", list("green", "blue", "red", "yellow", "delta") - get_security_level())
	var/msg = tgui_alert(usr, "Switch from code [get_security_level()] to code [sec_level]?", "Security Level", list("Yes","No"))
	if(msg == "Yes")
		set_security_level(sec_level)
		log_admin("[key_name(usr)] changed the security level to code [sec_level].",admin_key=key_name(usr))

//---- bs12 verbs ----

/client/proc/mod_panel()
	set name = "Moderator Panel"
	set category = "Admin"
/*	if(holder)
		holder.mod_panel()*/
//	feedback_add_details("admin_verb","MP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/editappear()
	set name = "Edit Appearance"
	set category = "Fun"

	if(!check_rights(R_FUN))	return

	var/mob/living/carbon/human/M = input("Select mob.", "Edit Appearance") as null|anything in GLOB.human_mob_list

	if(!istype(M, /mob/living/carbon/human))
		to_chat(usr, "<span class='warning'>You can only do this to humans!</span>")
		return
	switch(alert("Are you sure you wish to edit this mob's appearance? Skrell, Unathi and Tajaran can result in unintended consequences.",,"Yes","No"))
		if("No")
			return
	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		M.r_facial = hex2num(copytext(new_facial, 2, 4))
		M.g_facial = hex2num(copytext(new_facial, 4, 6))
		M.b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation") as color
	if(new_facial)
		M.r_hair = hex2num(copytext(new_hair, 2, 4))
		M.g_hair = hex2num(copytext(new_hair, 4, 6))
		M.b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation") as color
	if(new_eyes)
		M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
		M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
		M.b_eyes = hex2num(copytext(new_eyes, 6, 8))
		M.update_eyes()

	var/new_skin = input("Please select body color. This is for Tajaran, Unathi, and Skrell only!", "Character Generation") as color
	if(new_skin)
		M.r_skin = hex2num(copytext(new_skin, 2, 4))
		M.g_skin = hex2num(copytext(new_skin, 4, 6))
		M.b_skin = hex2num(copytext(new_skin, 6, 8))

	var/new_tone = input("Please select skin tone level: 30-220. Higher is darker.", "Character Generation")  as text

	if (new_tone)
		M.s_tone = max(min(round(text2num(new_tone)), 220), 30)
		M.s_tone =  -M.s_tone + 35

	// hair
	var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in GLOB.hair_styles_list
	if(new_hstyle)
		M.h_style = new_hstyle

	// facial hair
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in GLOB.facial_hair_styles_list
	if(new_fstyle)
		M.f_style = new_fstyle

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			M.gender = MALE
		else
			M.gender = FEMALE
	M.update_hair()
	M.update_body()
	M.check_dna(M)

/client/proc/playernotes()
	set name = "Show Player Info"
	set category = "Admin"
	if(holder)
		holder.PlayerNotes()
	return

/client/proc/free_slot()
	set name = "Free Job Slot"
	set category = "Admin"
	if(holder)
		var/list/jobs = list()
		for (var/datum/job/J in SSjobs.occupations)
			if (J.current_positions >= J.get_total_positions() && J.get_total_positions() != -1)
				jobs += J.title
		if (!jobs.len)
			to_chat(usr, SPAN_NOTICE("There are no fully staffed jobs."))
			return
		var/job = tgui_input_list(usr, "Please select a job slot to free.", "Free Job Slot", jobs)
		if (job)
			var/datum/job/J = SSjobs.GetJob(job)
			if(istype(J))
				J.total_positions++
				message_admins("A job slot for [job] has been added by [key_name_admin(usr)]. The total is now [J.get_total_positions()] with [J.current_positions] positions occupied.")
			else
				to_chat(usr, SPAN_DANGER("Failed to increase total positions in job [job]."))

/client/proc/toggleattacklogs()
	set name = "Toggle Attack Log Messages"
	set category = "Preferences"

	prefs.toggles ^= CHAT_ATTACKLOGS
	if (prefs.toggles & CHAT_ATTACKLOGS)
		to_chat(usr, "You now will get attack log messages")
	else
		to_chat(usr, "You now won't get attack log messages")
	prefs.save_preferences()


/client/proc/toggleghostwriters()
	set name = "Toggle ghost writers"
	set category = "Server"
	if(!holder)	return
	if(GLOB.config)
		if(GLOB.config.cult_ghostwriter)
			GLOB.config.cult_ghostwriter = 0
			to_chat(src, "<b>Disallowed ghost writers.</b>")
			message_admins("Admin [key_name_admin(usr)] has disabled ghost writers.", 1)
		else
			GLOB.config.cult_ghostwriter = 1
			to_chat(src, "<b>Enabled ghost writers.</b>")
			message_admins("Admin [key_name_admin(usr)] has enabled ghost writers.", 1)

/client/proc/toggledrones()
	set name = "Toggle maintenance drones"
	set category = "Server"
	if(!holder)	return
	if(GLOB.config)
		if(GLOB.config.allow_drone_spawn)
			GLOB.config.allow_drone_spawn = 0
			to_chat(src, "<b>Disallowed maint drones.</b>")
			message_admins("Admin [key_name_admin(usr)] has disabled maint drones.", 1)
		else
			GLOB.config.allow_drone_spawn = 1
			to_chat(src, "<b>Enabled maint drones.</b>")
			message_admins("Admin [key_name_admin(usr)] has enabled maint drones.", 1)

/client/proc/toggledebuglogs()
	set name = "Toggle Debug Log Messages"
	set category = "Preferences"

	prefs.toggles ^= CHAT_DEBUGLOGS
	if (prefs.toggles & CHAT_DEBUGLOGS)
		to_chat(usr, "You now will get debug log messages")
	else
		to_chat(usr, "You now won't get debug log messages")

/client/proc/damage_menu(mob/living/carbon/human/H as null|mob in GLOB.human_mob_list)
	set name = "Damage Menu"
	set desc = "Access a human mob's damage menu, allowing you to make their life hell."
	set category = "Fun"

	if(H)
		new /datum/tgui_module/damage_menu(WEAKREF(H), usr)

/client/proc/man_up(mob/T as mob in GLOB.mob_list)
	set category = "Fun"
	set name = "Man Up"
	set desc = "Tells mob to man up and deal with it."

	to_chat(T, "<span class='notice'><b><font size=3>Man up and deal with it.</font></b></span>")
	to_chat(T, "<span class='notice'>Move on.</span>")

	log_admin("[key_name(usr)] told [key_name(T)] to man up and deal with it.", admin_key=key_name(usr), ckey=key_name(T))
	message_admins("<span class='notice'>[key_name_admin(usr)] told [key_name(T)] to man up and deal with it.</span>", 1)

/client/proc/global_man_up()
	set category = "Fun"
	set name = "Man Up Global"
	set desc = "Tells everyone to man up and deal with it."

	for (var/mob/T as mob in GLOB.mob_list)
		to_chat(T, "<br><center><span class='notice'><b><font size=4>Man up.<br> Deal with it.</font></b><br>Move on.</span></center><br>")
		sound_to(T, 'sound/voice/ManUp1.ogg')

	log_admin("[key_name(usr)] told everyone to man up and deal with it.",admin_key=key_name(usr))
	message_admins("<span class='notice'>[key_name_admin(usr)] told everyone to man up and deal with it.</span>", 1)

/client/proc/give_spell(mob/T as mob in GLOB.mob_list) // -- Urist
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."
	var/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spells
	if(!S) return
	T.add_spell(new S)
	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the spell [S].",admin_key=key_name(usr),ckey=key_name(T))
	message_admins("<span class='notice'>[key_name_admin(usr)] gave [key_name(T)] the spell [S].</span>", 1)

/client/proc/toggle_recursive_explosions()
	set category = "Server"
	set name = "Explosion Type"
	set desc = "Toggle between recursive and non-recursive explosions."

	if (!check_rights(R_SERVER|R_DEBUG))
		return

	var/ans = alert(src, "This will force explosions to run in the [GLOB.config.use_spreading_explosions ? "old manner (circular)" : "new, realistic manner (spreading)"]. Do you want to proceed?", "Switch explosion type", "Yes", "Cancel")

	if (!ans || ans == "Cancel")
		to_chat(src, "<span class='notice'>Cancelled.</span>")
		return

	GLOB.config.use_spreading_explosions = !GLOB.config.use_spreading_explosions

	log_and_message_admins("has toggled explosions to be [GLOB.config.use_spreading_explosions ? "iterative/spreading" : "simple/circular"].")
	feedback_add_details("admin_verb", "TRE")

/client/proc/wipe_ai()
	set category = "Admin"
	set name = "Wipe AI"
	set desc = "Forces an AI to wipe its own core, ghosting them and freeing their job slot."

	if (!check_rights(R_ADMIN))
		return

	var/mob/living/silicon/ai/target = tgui_input_list(usr, "Choose the AI to force-wipe.", "AI Termination", ai_list)

	if (!target || alert("Are you sure you want to wipe [target.name]? They will be ghosted and their job slot freed.", "Confirm AI Termination", "No", "No", "Yes") != "Yes")
		return

	log_and_message_admins("admin-wiped [key_name_admin(target)]'s core.")
	target.do_wipe_core()

/client/proc/end_round()
	set name = "End Round"
	set desc = "This button will end the round."
	set category = "Server"

	if(!check_rights(R_ADMIN))
		return

	if(alert(usr, "Are you sure you want to end the round?", "Confirm Round End", "No", "Yes") != "Yes")
		return

	log_and_message_admins("has ended the round with the End Round button.")
	SSticker.game_tick(TRUE)

/client/proc/restart_sql()
	set category = "Debug"
	set name = "Reconnect SQL"
	set desc = "Causes the server to re-establish its connection to the MySQL server."

	if (!check_rights(R_DEBUG))
		return

	if (alert("Reconnect to SQL?", "SQL Reconnection", "No", "No", "Yes") != "Yes")
		return

	log_and_message_admins("is attempting to reconnect the server to MySQL.")

	GLOB.dbcon.Reconnect()

/client/proc/fix_player_list()
	set category = "Special Verbs"
	set name = "Regenerate Player List"
	set desc = "Use this to regenerate the player list if it becomes broken somehow."

	if (!check_rights(R_DEBUG|R_ADMIN))
		return

	if (alert("Regenerate player lists?", "Player List Repair", "No", "No", "Yes") != "Yes")
		return

	log_and_message_admins("is rebuilding the master player mob list.")
	for (var/P in GLOB.player_list)
		if (isnull(P) || !ismob(P))
			var/msg = "P_LIST DEBUG: Found null entry in GLOB.player_list!"
			log_debug(msg)
			message_admins(SPAN_DANGER(msg))
			GLOB.player_list -= P
		else
			var/mob/M = P
			if (!M.client)
				var/msg = "P_LIST DEBUG: Found a mob without a client in GLOB.player_list! [M.name]"
				log_debug(msg)
				message_admins(SPAN_DANGER(msg))
				GLOB.player_list -= M

/client/proc/reset_openturf()
	set category = "Debug"
	set name = "Reset Openturfs"
	set desc = "Deletes and regenerates all openturf overlays in the world."

	if (!check_rights(R_DEBUG|R_ADMIN))
		return

	if (alert("Rebuild openturfs? Openturfs may look strange while this runs.", "Fix openturf", "No", "No", "DO IT") != "DO IT")
		return

	log_and_message_admins("has regenerated all openturfs.")

	SSzcopy.hard_reset()

/client/proc/add_client_color(mob/T as mob in GLOB.mob_list)
	set category = "Debug"
	set name = "Add Client Color"
	set desc = "Adds a client color to a given mob"

	if(!check_rights(R_DEV))
		return

	if(!ishuman(T))
		to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
		return

	var/mob/living/carbon/human/C = T

	var/rr = input("Enter color value", "Red-Red") as num|null
	var/rg = input("Enter color value", "Red-Green") as num|null
	var/rb = input("Enter color value", "Red-Blue") as num|null
	var/gr = input("Enter color value", "Green-Red") as num|null
	var/gg = input("Enter color value", "Green-Green") as num|null
	var/gb = input("Enter color value", "Green-Blue") as num|null
	var/br = input("Enter color value", "Blue-Red") as num|null
	var/bg = input("Enter color value", "Blue-Green") as num|null
	var/bb = input("Enter color value", "Blue-Blue") as num|null
	var/priority = input("Enter priority value.", "Priority") as num|null
	if(!usr)
		return
	if(!C)
		to_chat(usr, "Mob doesn't exist anymore")
		return

	if(priority)
		var/datum/client_color/CC = new /datum/client_color()
		CC.client_color = list(rr,rg,rb, gr,gg,gb, br,bg,bb)
		CC.priority = priority
		C.client_colors |= CC
		sortTim(C.client_colors, GLOBAL_PROC_REF(cmp_clientcolor_priority))
		C.update_client_color()

	log_and_message_admins("<span class='notice'>gave [key_name(C)] a new client color.</span>")
	feedback_add_details("admin_verb","CR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

#ifdef ENABLE_SUNLIGHT
/client/proc/apply_sunstate()
	set category = "Fun"
	set name = "Apply Sun Preset"
	set desc = "Changes the sun preset. This takes a long time to apply, use sparingly!"

	if (!check_rights(R_FUN))
		return

	var/datum/sun_state/S = input("Choose a preset to apply:", "ILLUMINATE") as null|anything in SSsunlight.presets
	if (!S)
		to_chat(usr, "Cancelled.")

	SSsunlight.apply_sun_state(S)
	log_and_message_admins("has set the sun state to '[S]'.")
#else
/client/proc/apply_sunstate()
	set hidden = TRUE

	to_chat(usr, "The sunlight system is disabled.")
#endif

/client/proc/force_away_mission()
	set category = "Server"
	set name = "Force Away Mission"
	set desc = "Force a specific away mission to occur."

	if (!check_rights(R_SERVER))
		return

	var/mission_name = input("Enter Mission Name or press cancel to Reset","Mission Name") as null|text
	SSpersistent_configuration.forced_awaymission = mission_name

	if(!mission_name)
		log_and_message_admins("reset the forced away mission.")
	else
		log_and_message_admins("forced the following away mission: [mission_name].")

/client/proc/alooc(msg as text)
	set name = "ALOOC"
	set desc = "Admin Local OOC, seen only by those in view, regardless of their LOOC preferences."
	set category = "Admin"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD))
		return

	if(!mob)
		return

	msg = sanitize(msg)
	msg = process_chat_markup(msg, list("*"))
	if(!msg)
		return

	log_ooc("(ADMIN LOCAL) [mob.name]/[key] : [msg]",ckey=key_name(mob))

	var/mob/source = src.mob
	var/list/messageturfs = list() //List of turfs we broadcast to.
	var/list/messagemobs = list() //List of living mobs nearby who can hear it

	for(var/turf in range(world.view, get_turf(source)))
		messageturfs += turf
	if(isAI(source))
		var/mob/living/silicon/ai/AI = source
		for(var/turf in range(world.view, get_turf(AI.eyeobj)))
			messageturfs += turf

	for(var/mob/M in GLOB.player_list)
		if(!M.client || istype(M, /mob/abstract/new_player))
			continue
		if(isAI(M))
			var/mob/living/silicon/ai/AI = M
			if(get_turf(AI.eyeobj) in messageturfs)
				messagemobs += M
				continue
		if(get_turf(M) in messageturfs)
			messagemobs += M

	var/display_name = source.key
	if(holder && holder.fakekey)
		display_name = holder.fakekey

	msg = process_chat_markup(msg, list("*"))

	var/prefix
	var/admin_stuff
	for(var/client/target in GLOB.clients)
		admin_stuff = ""
		var/display_remote = FALSE
		if (target.holder && ((R_MOD|R_ADMIN) & target.holder.rights))
			display_remote = TRUE
		if(display_remote)
			prefix = "(R)"
			admin_stuff += "/([source.key])"
			if(target != source.client)
				admin_stuff += "(<A HREF='?src=\ref[target.holder];adminplayerobservejump=\ref[mob]'>JMP</A>)"
		if(target.mob in messagemobs)
			prefix = ""
		if((target.mob in messagemobs) || display_remote)
			to_chat(target, "<span class='ooc'><span class='adminlooc'>" + create_text_tag("ALOOC", target) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message linkify'>[msg]</span></span></span>")
