//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

GLOBAL_LIST_EMPTY_TYPED(preferences_datums, /datum/preferences)

/datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/current_character = 0			//SQL character ID.
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id
	var/list/notifications = list()		//A list of datums, for the dynamic server greeting window.
	var/list/time_of_death = list()//This is a list of last times of death for various things with different respawn timers

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#010000"			//Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/list/be_special_role = list()		//Special role selection
	var/UI_style = "Midnight"
	var/toggles = TOGGLES_DEFAULT
	var/sfx_toggles = ASFX_DEFAULT
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255
	var/tgui_lock = FALSE
	var/tgui_inputs = TRUE
	var/tgui_buttons_large = FALSE
	var/tgui_inputs_swapped = FALSE
	var/tgui_say_light_mode = FALSE
	var/ui_scale = TRUE
	var/lobby_music_vol = 85
	var/looping_sound_volume = 100
	//Style for popup tooltips
	var/tooltip_style = "Midnight"

	//character preferences
	var/real_name						//our character's name
	var/can_edit_name = TRUE				//Whether or not a character's name can be edited. Used with SQL saving.
	var/can_edit_ipc_tag = TRUE
	var/gender = MALE					//gender of character (well duh)
	var/pronouns = NEUTER				//what the character will appear as to others when examined
	var/age = 30						//age of character
	var/height						//character's height
	var/spawnpoint = "Arrivals Shuttle" //where this character will spawn (0-2).
	var/b_type = "A+"					//blood type (not-chooseable)
	var/backbag = OUTFIT_BACKPACK		//backpack type (defines in outfit.dm)
	var/backbag_style = OUTFIT_FACTIONSPECIFIC
	var/backbag_color = OUTFIT_NOTHING
	var/backbag_strap = OUTFIT_NORMAL
	var/pda_choice = OUTFIT_TAB_PDA
	var/headset_choice = OUTFIT_HEADSET
	var/primary_radio_slot = "Left Ear"
	///Suit sensors setting in the loadout.
	var/sensor_setting
	var/h_style = "Bedhead 2"				//Hair type
	var/tail_style = null
	var/hair_colour = "#000000"			//Hair colour hex value, for SQL loading
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/g_style = "None"				//Gradient style
	var/grad_colour = "#000000"			//Gradient colour hex value, for SQL loading
	var/r_grad = 0						//Gradient color
	var/g_grad = 0						//Gradient color
	var/b_grad = 0						//Gradient color
	var/f_style = "Shaved"				//Face hair type
	var/facial_colour = "#000000"		//Facial colour hex value, for SQL loading
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = -90						//Skin tone
	var/skin_colour = "#000000"			//Skin colour hex value, for SQL loading
	var/r_skin = 37						//Skin color
	var/g_skin = 3						//Skin color
	var/b_skin = 2						//Skin color
	var/eyes_colour = "#000000"			//Eye colour hex value, for SQL loading
	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color
	var/species = SPECIES_HUMAN               //Species datum to use.
	var/species_preview                 //Used for the species selection window.
	var/list/alternate_languages = list() //Secondary language(s)
	var/list/language_prefixes = list() // Language prefix keys
	var/autohiss_setting = AUTOHISS_OFF
	var/list/gear						// The gear in the currently selected loadout item preset
	var/list/gear_list = list()			// The gear list holds all the different loadout item prests
	var/gear_slot = 1					//The current gear save slot
	var/gear_modified = FALSE

	// IPC Stuff
	var/machine_custom_model
	var/machine_tag_status = TRUE
	var/machine_serial_number
	var/machine_ownership_status = IPC_OWNERSHIP_COMPANY
	var/hidden_shell_status = FALSE

	/// Character citizenship.
	var/citizenship = "None"
	/// Antag faction/general associated faction.
	var/faction = "None"
	/// Religious association.
	var/religion = "None"
	/// Character accent.
	var/accent = "None"

	/// The character's culture singleton.
	var/culture
	/// The character's origin singleton.
	var/origin
	/// The character's education singleton.
	var/education

	/// The character's skills list. JSON.
	var/list/skills = list()
	/// The character's current spent skill points. Assoc list of SKILL_CATEGORY define to number of remaining skill points.
	var/list/skill_points_remaining

	/// The character's psionics. JSON.
	var/list/psionics = list()

	/// Direction-keyed live character preview screen objects and backgrounds.
	var/list/char_render_holders
	/// Species used to build the current preview screen objects.
	var/character_preview_species
	/// Whether the native TGUI character-slot picker is open.
	var/show_character_slots = FALSE
	/// Whether the character setup is sending its lightweight opening payload.
	var/character_setup_loading = FALSE
	var/static/list/preview_map_ids = list(
		"1" = "character_setup_preview_north",
		"2" = "character_setup_preview_south",
		"4" = "character_setup_preview_east",
		"8" = "character_setup_preview_west"
	)

		//Jobs, uses bitflags
	var/job_civilian_high = 0
	var/job_civilian_med = 0
	var/job_civilian_low = 0

	var/job_medsci_high = 0
	var/job_medsci_med = 0
	var/job_medsci_low = 0

	var/job_engsec_high = 0
	var/job_engsec_med = 0
	var/job_engsec_low = 0

	var/job_event_high = 0
	var/job_event_med = 0
	var/job_event_low = 0

	// A text blob which temporarily houses data from the SQL.
	var/unsanitized_jobs = ""

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = RETURN_TO_LOBBY

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()
	var/list/rlimb_data = list()
	var/list/body_markings = list() // "name" = "#rgbcolor"
	var/list/player_alt_titles = new()		// the default name of a job like "Physician"

	var/list/flavor_texts = list()
	var/list/flavour_texts_robot = list()

	var/med_record = ""
	var/sec_record = ""
	var/list/incidents = list()
	var/gen_record = ""
	var/exploit_record = ""
	var/ccia_record = ""
	var/list/ccia_actions = list()
	var/list/disabilities = list()

	var/economic_status = ECONOMICALLY_AVERAGE

	var/uplinklocation = "PDA"

	// OOC Metadata:
	var/metadata = ""

	// SPAAAACE
	var/toggles_secondary = SEE_ITEM_OUTLINES | PROGRESS_BARS | FLOATING_MESSAGES | HOTKEY_DEFAULT
	var/clientfps = 100
	var/floating_chat_color
	var/speech_bubble_type = "default"

	var/list/pai = list()	// A list for holding pAI related data.

	// Signature information
	var/signature = ""
	var/signfont = ""

	var/client/client = null

	var/savefile/loaded_preferences
	var/savefile/loaded_character
	var/datum/category_collection/player_setup_collection/player_setup

	var/bgstate = "plain_black"
	var/list/bgstate_options = list(
		"Plain Black" = "plain_black",
		"Plain White" = "plain_white",
		"Monotile" = "monotile",
		"Tiles" = "tile",
		"Dark Tiles" = "dark_tile",
		"Freezer Tiles" = "freezer_tile",
		"Reinforced Tiles" = "reinforced",
		"Wood Floor" = "wood",
		"Grass" = "grass",
		"Red Carpet" = "carpet_red",
		"Cyan Carpet" = "carpet_cyan",
		"Green Carpet" = "carpet_green",
		"Purple Carpet" = "carpet_purple",
		"Magenta Carpet" = "carpet_magenta",
		"Rubber Carpet" = "carpet_rubber",
		"Blue Circuits" = "circuit_blue",
		"Green Circuits" = "circuit_green",
		"Asteroid Turf" = "asteroid",
		"Desert Turf" = "desert",
		"Space" = "space"
	)

	var/fov_cone_alpha = 255

	var/scale_x = 1
	var/scale_y = 1

/datum/preferences/New(client/C)
	new_setup()

	if(istype(C))
		client = C
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			load_preferences()
			load_and_update_character()

/datum/preferences/Destroy()
	SStgui.close_uis(src)
	clear_character_previews()
	return ..()

/datum/preferences/proc/load_and_update_character(var/slot)
	load_character(slot)
	if(update_setup(loaded_preferences, loaded_character))
		save_preferences()
		save_character()

/datum/preferences/proc/getMinAge()
	var/datum/species/mob_species = GLOB.all_species[species]
	return mob_species.age_min

/datum/preferences/proc/getMaxAge()
	var/datum/species/mob_species = GLOB.all_species[species]
	return mob_species.age_max

/datum/preferences/proc/getMinHeight()
	var/datum/species/mob_species = GLOB.all_species[species]
	return mob_species.height_min

/datum/preferences/proc/getMaxHeight()
	var/datum/species/mob_species = GLOB.all_species[species]
	return mob_species.height_max

/datum/preferences/proc/getAvgHeight()
	var/datum/species/mob_species = GLOB.all_species[species]
	return mob_species.species_height

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)
		return
	if(!MC_RUNNING())
		to_chat(user, SPAN_WARNING("Character Setup is unavailable until the server has finished initializing. Please wait."))
		return

	ui_interact(user)

/datum/preferences/ui_state(mob/user)
	return GLOB.always_state

/datum/preferences/ui_status(mob/user, datum/ui_state/state)
	if(user?.client?.prefs != src)
		return UI_CLOSE
	return UI_INTERACTIVE

/datum/preferences/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		// This bootstrap page provides drag/close controls before React is ready.
		ui = new(user, src, "CharacterSetup", "Character Setup",
			ui_x = 1280,
			ui_y = 900,
			initial_html = file("tgui/public/character-setup-loading.html"),
			preferred_window_index = TGUI_CHARACTER_SETUP_WINDOW_INDEX)
		ui.set_autoupdate(FALSE)
		character_setup_loading = TRUE
		ui.open()
		addtimer(CALLBACK(src, PROC_REF(check_character_setup_bootstrap), ui), 8 SECONDS)

/// Reloads only the Character Setup browser if its React frontend never mounts.
/datum/preferences/proc/check_character_setup_bootstrap(datum/tgui/ui)
	if(!character_setup_loading || QDELETED(ui) || ui.closing || ui.window?.locked_by != ui)
		return
	ui.window.reinitialize()
	ui.window.send_message("update", ui.get_payload(
		with_data = TRUE,
		with_static_data = TRUE))
	addtimer(CALLBACK(src, PROC_REF(check_character_setup_bootstrap), ui), 8 SECONDS)

/datum/preferences/ui_close(mob/user)
	. = ..()
	show_character_slots = FALSE
	character_setup_loading = FALSE
	if(client)
		for(var/map_id in preview_map_ids)
			winset(client, preview_map_ids[map_id], "is-visible=false")
	clear_character_previews()

/datum/preferences/ui_data(mob/user)
	var/list/data = list()
	data["can_save"] = !!path
	data["character_name"] = real_name
	data["sql_saves"] = GLOB.config.sql_saves
	var/datum/faction/character_faction = SSjobs.name_factions[faction] || SSjobs.default_faction
	data["faction_name"] = character_faction.name
	data["faction_suffix"] = character_faction.title_suffix
	data["slot_dialog"] = show_character_slots ? get_character_slot_data(user) : null
	data["loading"] = character_setup_loading

	var/list/categories = list()
	for(var/datum/category_group/player_setup_category/category in player_setup.categories)
		categories += list(list(
			"name" = category.name,
			"ref" = REF(category),
			"selected" = (category == player_setup.selected_category)
		))
	data["categories"] = categories
	data["items"] = character_setup_loading ? list() : (player_setup.selected_category?.ui_data(user) || list())

	return data

/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("character_setup_ready")
			character_setup_loading = FALSE
			// Always answer retries so a missed full payload can recover without F5.
			return TRUE

		if("select_category")
			var/datum/category_group/player_setup_category/category = locate(params["category"])
			if(category && (category in player_setup.categories))
				player_setup.selected_category = category
				return TRUE

		if("preference_topic")
			var/datum/category_item/player_setup_item/item = locate(params["item"])
			var/list/topic = params["topic"]
			if(!item || !(item in player_setup.selected_category?.items) || !islist(topic))
				return FALSE
			return item.handle_ui_topic(topic, user)

		if("save")
			save_character()
			save_preferences()
			return TRUE

		if("reload")
			load_preferences()
			load_character()
			update_preview_icon()
			show_character_previews()
			return TRUE

		if("load")
			if(IsGuestKey(user.key))
				return FALSE
			show_character_slots = TRUE
			return TRUE

		if("close_slots")
			show_character_slots = FALSE
			return TRUE

		if("preview_ready")
			if(char_render_holders)
				// Force BYOND to bind existing screen objects to the newly mounted
				// named map controls; an idempotent |= alone does not reattach them.
				for(var/render_holder in char_render_holders)
					client.screen -= char_render_holders[render_holder]
				show_character_previews()
			else
				update_preview_icon()
			return TRUE

		if("select_slot")
			var/slot = text2num(params["slot"])
			if(!slot)
				return FALSE
			var/list/slot_data = get_character_slot_data(user)
			var/valid_slot = FALSE
			for(var/list/character_slot in slot_data["slots"])
				if(character_slot["id"] == slot)
					valid_slot = TRUE
					break
			if(!valid_slot || !load_character(slot))
				return FALSE
			show_character_slots = FALSE
			update_preview_icon()
			show_character_previews()
			return TRUE

		if("new_character")
			if(!GLOB.config.sql_saves)
				return FALSE
			var/list/slot_data = get_character_slot_data(user)
			if(!slot_data["can_create"])
				return FALSE
			new_setup(1)
			to_chat(user, SPAN_NOTICE("Your setup has been refreshed."))
			show_character_slots = FALSE
			update_preview_icon()
			show_character_previews()
			return TRUE

		if("delete")
			if(!GLOB.config.sql_saves)
				return FALSE
			if(alert(user, "You will be unable to re-create a character with the same name! Are you sure you want to permanently delete [real_name]? The slot cannot be restored.", "Permanently Delete Character", "No", "Yes") != "Yes")
				return FALSE
			if(alert(user, "Are you sure you want to PERMANENTLY delete your character?", "Confirm Permanent Deletion", "Yes", "No") != "Yes")
				return FALSE
			delete_character_sql(user.client)
			clear_character_previews()
			update_preview_icon()
			show_character_previews()
			return TRUE

	return FALSE

/datum/preferences/proc/update_character_previews(list/directional_appearances)
	if(!client)
		return

	var/mob/abstract/new_player/NP = client.mob
	if(istype(NP) && istype(NP.late_choices_ui)) // update character icon in late-choices UI
		NP.late_choices_ui.update_character_icon()

	// KEEP_TOGETHER uses a cached composite surface. Recreate only the character
	// objects when changing species, since their icon bounds can also change.
	if(character_preview_species != species)
		for(var/direction in GLOB.cardinals)
			var/atom/movable/screen/old_character = LAZYACCESS(char_render_holders, "[direction]")
			if(!old_character)
				continue
			client.screen -= old_character
			qdel(old_character)
			LAZYREMOVE(char_render_holders, "[direction]")
		character_preview_species = species

	var/datum/species/preview_species = GLOB.all_species[species]
	var/preview_x_offset = preview_species?.icon_x_offset ? -4 : 0
	for(var/direction in GLOB.cardinals)
		var/map_id = preview_map_ids["[direction]"]
		var/background_key = "background_[direction]"
		var/atom/movable/screen/background = LAZYACCESS(char_render_holders, background_key)
		if(!background)
			background = new
			background.appearance_flags = TILE_BOUND|PIXEL_SCALE|NO_CLIENT_COLOR
			background.icon = 'icons/turf/flooring/character_preview.dmi'
			background.plane = GAME_PLANE
			background.layer = TURF_LAYER
			background.screen_loc = "[map_id]:1,1 to 5,5"
			LAZYSET(char_render_holders, background_key, background)
		background.icon_state = bgstate

		var/atom/movable/screen/character = LAZYACCESS(char_render_holders, "[direction]")
		if(!character)
			character = new
			LAZYSET(char_render_holders, "[direction]", character)
		character.appearance = directional_appearances["[direction]"]
		// Assigning appearance also copies screen_loc from the mannequin (null),
		// so restore the named-map position after every appearance update.
		character.screen_loc = "[map_id]:3:[preview_x_offset],3"

	show_character_previews()

/datum/preferences/proc/show_character_previews()
	if(!client || !char_render_holders)
		return
	for(var/render_holder in char_render_holders)
		client.screen |= char_render_holders[render_holder]

/datum/preferences/proc/clear_character_previews()
	for(var/index in char_render_holders)
		var/atom/movable/screen/screen_object = char_render_holders[index]
		client?.screen -= screen_object
		qdel(screen_object)
	QDEL_LIST_ASSOC_VAL(char_render_holders)
	char_render_holders = null
	character_preview_species = null

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)
		return

	if(!istype(user, /mob/abstract/new_player))
		return

	if(href_list["preference"] == "open_whitelist_forum")
		if(GLOB.config.forumurl)
			send_link(user, GLOB.config.forumurl)
		else
			to_chat(user, SPAN_DANGER("The forum URL is not set in the server configuration."))
			return
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()

	if(GLOB.config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(GLOB.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(GLOB.last_names)]"

	character.real_name = real_name
	character.name = character.real_name
	character.set_species(species)
	if(character.dna)
		character.dna.real_name = character.real_name
	character.langchat_color = floating_chat_color

	character.flavor_texts["general"] = flavor_texts["general"]
	character.flavor_texts[BP_HEAD] = flavor_texts[BP_HEAD]
	character.flavor_texts["face"] = flavor_texts["face"]
	character.flavor_texts[BP_EYES] = flavor_texts[BP_EYES]
	character.flavor_texts["torso"] = flavor_texts["torso"]
	character.flavor_texts["arms"] = flavor_texts["arms"]
	character.flavor_texts["hands"] = flavor_texts["hands"]
	character.flavor_texts["legs"] = flavor_texts["legs"]
	character.flavor_texts["feet"] = flavor_texts["feet"]
	character.character_id = current_character

	character.med_record = med_record
	character.sec_record = sec_record
	character.incidents = incidents
	character.gen_record = gen_record
	character.ccia_record = ccia_record
	character.ccia_actions = ccia_actions
	character.exploit_record = exploit_record

	character.gender = gender
	character.pronouns = pronouns
	character.age = age
	character.b_type = b_type
	character.height = height

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.set_tail_style(tail_style)
	character.speech_bubble_type = speech_bubble_type

	character.h_style = h_style
	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	character.f_style = f_style
	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.g_style = g_style
	character.r_grad = r_grad
	character.g_grad = g_grad
	character.b_grad = b_grad

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.s_tone = s_tone

	character.lipstick_color = null

	character.citizenship = citizenship
	character.employer_faction = faction
	character.religion = religion
	character.accent = accent
	character.set_culture(GET_SINGLETON(text2path(culture)))
	character.set_origin(GET_SINGLETON(text2path(origin)))

	// Destroy/cyborgize organs & setup body markings
	character.sync_organ_prefs_to_mob(src)

	character.sync_trait_prefs_to_mob(src)

	character.all_underwear.Cut()
	character.all_underwear_metadata.Cut()
	for(var/underwear_category_name in all_underwear)
		var/datum/category_group/underwear/underwear_category = GLOB.global_underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = all_underwear[underwear_category_name]
			character.all_underwear[underwear_category_name] = underwear_category.items_by_name[underwear_item_name]
			if(all_underwear_metadata[underwear_category_name])
				character.all_underwear_metadata[underwear_category_name] = all_underwear_metadata[underwear_category_name]
		else
			all_underwear -= underwear_category_name

	if(backbag > OUTFIT_CHESTPOUCH || backbag < OUTFIT_NOTHING)
		backbag = OUTFIT_NOTHING //Same as above
	character.backbag = backbag
	character.backbag_style = backbag_style
	character.backbag_color = backbag_color
	character.backbag_strap = backbag_strap

	if(pda_choice > OUTFIT_WRISTBOUND || pda_choice < OUTFIT_NOTHING)
		pda_choice = OUTFIT_TAB_PDA

	character.pda_choice = pda_choice

	if(headset_choice > OUTFIT_CLIPON || headset_choice < OUTFIT_NOTHING)
		headset_choice = OUTFIT_HEADSET

	character.headset_choice = headset_choice

	if(length(psionics))
		for(var/power in psionics)
			var/singleton/psionic_power/P = GET_SINGLETON(text2path(power))
			if(istype(P) && (P.ability_flags & PSI_FLAG_CANON))
				P.apply(character)

	// Load all of the player-set skills first.
	for(var/skill_type in skills)
		var/singleton/skill/skill = GET_SINGLETON(skill_type)
		skill.on_spawn(character, skills[skill.type])

	// Attempt to load all the "required" skills.
	// Player-set skills won't be overwritten here as LoadComponent will never re-initialize a component that already exists.
	for(var/singleton/skill/required_skill as anything in SSskills.required_skills)
		character.LoadComponent(required_skill.component_type, SKILL_LEVEL_UNFAMILIAR)

	if(icon_updates)
		character.force_update_limbs()
		character.update_mutations(0)
		character.update_body(0)
		character.update_hair(0)
		character.update_underwear(0)
		character.update_icon()

/datum/preferences/proc/get_character_slot_data(mob/user)
	var/list/slots = list()
	var/used_slots = 0
	var/using_sql = GLOB.config.sql_saves

	if(using_sql && establish_db_connection(GLOB.dbcon))
		var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT id, name FROM ss13_characters WHERE ckey = :ckey: AND deleted_at IS NULL ORDER BY id ASC")
		if(query.Execute(list("ckey" = user.client.ckey)))
			while(query.NextRow())
				var/id = text2num(query.item[1])
				slots += list(list(
					"id" = id,
					"name" = query.item[2],
					"selected" = (id == current_character)
				))
			used_slots = query.RowCount()
			return list(
				"slots" = slots,
				"used" = used_slots,
				"limit" = GLOB.config.character_slots,
				"can_create" = (used_slots < GLOB.config.character_slots)
			)

	var/savefile/S = new /savefile(path)
	if(S)
		for(var/i = 1, i <= GLOB.config.character_slots, i++)
			S.cd = "/character[i]"
			var/name
			S["real_name"] >> name
			if(!name)
				name = "Character[i]"
			else
				used_slots++
			slots += list(list(
				"id" = i,
				"name" = name,
				"selected" = (i == default_slot)
			))

	return list(
		"slots" = slots,
		"used" = used_slots,
		"limit" = GLOB.config.character_slots,
		"can_create" = FALSE
	)

// Logs a character to the database. For statistics.
/datum/preferences/proc/log_character(var/mob/living/carbon/human/H)
	if (!GLOB.config.sql_saves || !GLOB.config.sql_stats || !establish_db_connection(GLOB.dbcon) || !H)
		return

	if(!H.mind.assigned_role)
		LOG_DEBUG("Char-Log: Char [current_character] - [H.name] has joined with mind.assigned_role set to NULL")

	var/DBQuery/query = GLOB.dbcon.NewQuery("INSERT INTO ss13_characters_log (char_id, game_id, datetime, job_name, alt_title) VALUES (:char_id:, :game_id:, NOW(), :job:, :alt_title:)")
	query.Execute(list("char_id" = current_character, "game_id" = GLOB.round_id, "job" = H.mind.assigned_role, "alt_title" = H.mind.role_alt_title))

// Turned into a proc so we could reuse it for SQL shenanigans.
/datum/preferences/proc/new_setup(var/re_initialize = 0)
	if (player_setup)
		qdel(player_setup)
		player_setup = null

	player_setup = new(src)
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender,species)
	var/generated_serial = uppertext(dd_limittext(md5(real_name), 12))
	machine_serial_number = generated_serial
	b_type = pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")
	signature = "<i>[real_name]</i>"
	signfont = "Verdana"

	current_character = 0
	can_edit_name = 1

	gear = list()
	gear_list = list() //Dont copy the loadout
	gear_modified = FALSE

	//Reset the records when making a new char
	med_record = ""
	sec_record = ""
	incidents = list()
	gen_record = ""
	exploit_record = ""
	ccia_record = ""

	// Do we need to reinitialize a whole bunch more vars?
	if (re_initialize)
		be_special_role = list()
		uplinklocation = initial(uplinklocation)

		r_hair = 0
		g_hair = 0
		b_hair = 0
		r_facial = 0
		g_facial = 0
		b_facial = 0
		r_skin = 0
		g_skin = 0
		b_skin = 0
		r_eyes = 0
		g_eyes = 0
		b_eyes = 0

		species = SPECIES_HUMAN
		citizenship = "None"
		faction = "None"
		religion = "None"
		accent = "None"

		species = SPECIES_HUMAN

		job_civilian_high = 0
		job_civilian_med = 0
		job_civilian_low = 0

		job_medsci_high = 0
		job_medsci_med = 0
		job_medsci_low = 0

		job_engsec_high = 0
		job_engsec_med = 0
		job_engsec_low = 0

		job_event_high = 0
		job_event_med = 0
		job_event_low = 0

		alternate_option = 1
		metadata = ""

		organ_data = list()
		rlimb_data = list()
		body_markings = list()
		player_alt_titles = new()

		flavor_texts = list()
		flavour_texts_robot = list()

		ccia_actions = list()
		disabilities = list()
		psionics = list()

		economic_status = ECONOMICALLY_AVERAGE

// Deletes a character from the database
/datum/preferences/proc/delete_character_sql(var/client/C)
	if (!C)
		return

	if (!current_character)
		to_chat(C, SPAN_NOTICE("You do not have a character loaded."))
		return

	if (!establish_db_connection(GLOB.dbcon))
		to_chat(C, SPAN_NOTICE("Unable to establish database connection."))
		return

	var/DBQuery/query = GLOB.dbcon.NewQuery("UPDATE ss13_characters SET deleted_at = NOW(), deleted_by = \"player\" WHERE id = :char_id:")
	query.Execute(list("char_id" = current_character))

	// Create a new character.
	new_setup(1)

	to_chat(C, SPAN_WARNING("Character successfully deleted! Please make a new one or load an existing setup."))

/datum/preferences/proc/get_species_datum()
	if (species)
		return GLOB.all_species[species]

	return null
