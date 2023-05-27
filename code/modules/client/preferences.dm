//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/list/preferences_datums = list()

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
	var/html_UI_style = "Nano"
	//Style for popup tooltips
	var/tooltip_style = "Midnight"
	var/motd_hash = ""					//Hashes for the new server greeting window.
	var/memo_hash = ""

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
	var/list/gear						// Custom/fluff item loadout.
	var/list/gear_list = list()			//Custom/fluff item loadouts.
	var/gear_slot = 1					//The current gear save slot

	// IPC Stuff
	var/machine_tag_status = TRUE
	var/machine_serial_number
	var/machine_ownership_status = IPC_OWNERSHIP_COMPANY

		//Some faction information.
	var/home_system = "Unset"           //System of birth.
	var/citizenship = "None"            //Current home system.
	var/faction = "None"                //Antag faction/general associated faction.
	var/religion = "None"               //Religious association.
	var/accent = "None"               //Character accent.

	var/culture
	var/origin

	var/list/char_render_holders		//Should only be a key-value list of north/south/east/west = obj/screen.
	var/static/list/preview_screen_locs = list(
		"1" = "character_preview_map:1,5:-12",
		"2" = "character_preview_map:1,3:15",
		"4"  = "character_preview_map:1:0,2:10",
		"8"  = "character_preview_map:1:0,1:5",
		"BG" = "character_preview_map:1,1 to 1,5"
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
	var/toggles_secondary = PROGRESS_BARS | FLOATING_MESSAGES | HOTKEY_DEFAULT
	var/clientfps = 40
	var/floating_chat_color
	var/speech_bubble_type = "normal"

	var/list/pai = list()	// A list for holding pAI related data.

	// Signature information
	var/signature = ""
	var/signfont = ""

	var/client/client = null

	var/savefile/loaded_preferences
	var/savefile/loaded_character
	var/datum/category_collection/player_setup_collection/player_setup

	var/bgstate = "000"
	var/list/bgstate_options = list(
		"fffff",
		"000",
		"new_steel",
		"dark2",
		"wood",
		"wood_light",
		"grass_alt",
		"new_reinforced",
		"new_white"
		)

	var/fov_cone_alpha = 255

/datum/preferences/New(client/C)
	new_setup()

	if(istype(C))
		client = C
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			load_preferences()
			load_and_update_character()

/datum/preferences/Destroy()
	. = ..()
	QDEL_NULL_LIST(char_render_holders)

/datum/preferences/proc/load_and_update_character(var/slot)
	load_character(slot)
	if(update_setup(loaded_preferences, loaded_character))
		save_preferences()
		save_character()

/datum/preferences/proc/getMinAge()
	var/datum/species/mob_species = all_species[species]
	return mob_species.age_min

/datum/preferences/proc/getMaxAge()
	var/datum/species/mob_species = all_species[species]
	return mob_species.age_max

/datum/preferences/proc/getMinHeight()
	var/datum/species/mob_species = all_species[species]
	return mob_species.height_min

/datum/preferences/proc/getMaxHeight()
	var/datum/species/mob_species = all_species[species]
	return mob_species.height_max

/datum/preferences/proc/getAvgHeight()
	var/datum/species/mob_species = all_species[species]
	return mob_species.species_height

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)	return
	var/dat = "<center>"

	if(path)
		dat += "<a href='?src=\ref[src];load=1'>Load slot</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Save slot</a> - "
		dat += "<a href='?src=\ref[src];reload=1'>Reload slot</a>"
		if (config.sql_saves)
			dat += " - <a href='?src=\ref[src];delete=1'>Delete slot</a>"

	else
		dat += "Please create an account to save your preferences."

	if(!char_render_holders)
		update_preview_icon()
	show_character_previews()

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)
	send_theme_resources(user)
	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_browser", "Character Setup", 1400, 1000)
	popup.set_content(dat)
	popup.open(FALSE) // Skip registering onclose on the browser pane
	onclose(user, "preferences_window", src) // We want to register on the window itself

/datum/preferences/proc/update_character_previews(mutable_appearance/MA)
	if(!client)
		return

	var/mob/abstract/new_player/NP = client.mob
	if(istype(NP) && istype(NP.late_choices_ui)) // update character icon in late-choices UI
		NP.late_choices_ui.update_character_icon()

	var/obj/screen/BG= LAZYACCESS(char_render_holders, "BG")
	if(!BG)
		BG = new
		BG.appearance_flags = TILE_BOUND|PIXEL_SCALE|NO_CLIENT_COLOR
		BG.layer = TURF_LAYER
		BG.icon = 'icons/turf/total_floors.dmi'
		LAZYSET(char_render_holders, "BG", BG)
		client.screen |= BG
	BG.icon_state = bgstate
	BG.screen_loc = preview_screen_locs["BG"]

	for(var/D in global.cardinal)
		var/obj/screen/O = LAZYACCESS(char_render_holders, "[D]")
		if(!O)
			O = new
			LAZYSET(char_render_holders, "[D]", O)
			client.screen |= O
		O.appearance = MA
		O.dir = D
		O.screen_loc = preview_screen_locs["[D]"]

/datum/preferences/proc/show_character_previews()
	if(!client || !char_render_holders)
		return
	for(var/render_holder in char_render_holders)
		client.screen |= char_render_holders[render_holder]

/datum/preferences/proc/clear_character_previews()
	for(var/index in char_render_holders)
		var/obj/screen/S = char_render_holders[index]
		client?.screen -= S
		qdel(S)
	char_render_holders = null

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)
		return

	if(!istype(user, /mob/abstract/new_player))
		return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			send_link(user, config.forumurl)
		else
			to_chat(user, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
			return
	else if(href_list["close"])
		// User closed preferences window, cleanup anything we need to.
		clear_character_previews()
		return 1
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		save_character()
		save_preferences()
	else if(href_list["reload"])
		load_preferences()
		load_character()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			if (config.sql_saves)
				open_load_dialog_sql(usr)
			else
				open_load_dialog_file(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		close_load_dialog(usr)
	else if(href_list["new_character_sql"])
		new_setup(1)
		to_chat(usr, "<span class='notice'>Your setup has been refreshed.</span>")
		usr.client.prefs.update_preview_icon()
		close_load_dialog(usr)
	else if(href_list["close_load_dialog"])
		close_load_dialog(usr)
	else if(href_list["delete"])
		if (!config.sql_saves)
			return 0
		if (alert(usr, "You will be unable to re-create a character with the same name! Are you sure you want to delete the loaded character?", "Delete Character", "No", "Yes") == "Yes")
			delete_character_sql(usr.client)
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = 1)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()

	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(last_names)]"

	character.real_name = real_name
	character.name = character.real_name
	character.set_species(species)
	if(character.dna)
		character.dna.real_name = character.real_name
	character.set_floating_chat_color(floating_chat_color)

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

	character.citizenship = citizenship
	character.employer_faction = faction
	character.religion = religion
	character.accent = accent
	character.origin = GET_SINGLETON(text2path(origin))
	character.culture = GET_SINGLETON(text2path(culture))
	character.origin.on_apply(character)
	character.culture.on_apply(character)

	// Destroy/cyborgize organs & setup body markings
	character.sync_organ_prefs_to_mob(src)

	character.sync_trait_prefs_to_mob(src)

	character.all_underwear.Cut()
	character.all_underwear_metadata.Cut()
	for(var/underwear_category_name in all_underwear)
		var/datum/category_group/underwear/underwear_category = global_underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = all_underwear[underwear_category_name]
			character.all_underwear[underwear_category_name] = underwear_category.items_by_name[underwear_item_name]
			if(all_underwear_metadata[underwear_category_name])
				character.all_underwear_metadata[underwear_category_name] = all_underwear_metadata[underwear_category_name]
		else
			all_underwear -= underwear_category_name

	if(backbag > OUTFIT_POCKETBOOK || backbag < OUTFIT_NOTHING)
		backbag = OUTFIT_NOTHING //Same as above
	character.backbag = backbag
	character.backbag_style = backbag_style
	character.backbag_color = backbag_color
	character.backbag_strap = backbag_strap

	if(pda_choice > OUTFIT_WRISTBOUND || pda_choice < OUTFIT_NOTHING)
		pda_choice = OUTFIT_TAB_PDA

	character.pda_choice = pda_choice

	if(headset_choice > OUTFIT_THIN_WRISTRAD || headset_choice < OUTFIT_NOTHING)
		headset_choice = OUTFIT_HEADSET

	character.headset_choice = headset_choice

	if(icon_updates)
		character.force_update_limbs()
		character.update_mutations(0)
		character.update_body(0)
		character.update_hair(0)
		character.update_underwear(0)
		character.update_icon()

/datum/preferences/proc/open_load_dialog_sql(mob/user)
	var/dat = "<tt><center>"

	for(var/ckey in preferences_datums)
		var/datum/preferences/D = preferences_datums[ckey]
		if(D == src)
			if(!establish_db_connection(dbcon))
				return open_load_dialog_file(user)

			var/DBQuery/query = dbcon.NewQuery("SELECT id, name FROM ss13_characters WHERE ckey = :ckey: AND deleted_at IS NULL ORDER BY id ASC")
			query.Execute(list("ckey" = user.client.ckey))

			dat += "<b>Select a character slot to load</b><hr>"
			var/name
			var/id

			while (query.NextRow())
				id = text2num(query.item[1])
				name = query.item[2]
				if (id == current_character)
					dat += "<b><a href='?src=\ref[src];changeslot=[id];'>[name]</a></b><br>"
				else
					dat += "<a href='?src=\ref[src];changeslot=[id];'>[name]</a><br>"

			dat += "<hr>"
			dat += "<b>[query.RowCount()]/[config.character_slots] slots used</b><br>"
			if (query.RowCount() < config.character_slots)
				dat += "<a href='?src=\ref[src];new_character_sql=1'>New Character</a>"
			else
				dat += "<strike>New Character</strike>"

	dat += "<hr>"
	dat += "<a href='?src=\ref[src];close_load_dialog=1'>Close</a><br>"
	dat += "</center></tt>"
	send_theme_resources(user)
	user << browse(enable_ui_theme(user, dat), "window=saves;size=300x390")


/datum/preferences/proc/open_load_dialog_file(mob/user)
	var/dat = "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	send_theme_resources(user)
	user << browse(enable_ui_theme(user, dat), "window=saves;size=300x390")

/datum/preferences/proc/close_load_dialog(mob/user)
	user << browse(null, "window=saves")

// Logs a character to the database. For statistics.
/datum/preferences/proc/log_character(var/mob/living/carbon/human/H)
	if (!config.sql_saves || !config.sql_stats || !establish_db_connection(dbcon) || !H)
		return

	if(!H.mind.assigned_role)
		log_debug("Char-Log: Char [current_character] - [H.name] has joined with mind.assigned_role set to NULL")

	var/DBQuery/query = dbcon.NewQuery("INSERT INTO ss13_characters_log (char_id, game_id, datetime, job_name, alt_title) VALUES (:char_id:, :game_id:, NOW(), :job:, :alt_title:)")
	query.Execute(list("char_id" = current_character, "game_id" = game_id, "job" = H.mind.assigned_role, "alt_title" = H.mind.role_alt_title))

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

	//Reset the records when making a new char
	med_record = ""
	sec_record = ""
	incidents = list()
	gen_record = ""
	exploit_record = ""
	ccia_record = ""

	gear_list = list() //Dont copy the loadout

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
		home_system = "Unset"
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

		economic_status = ECONOMICALLY_AVERAGE

// Deletes a character from the database
/datum/preferences/proc/delete_character_sql(var/client/C)
	if (!C)
		return

	if (!current_character)
		to_chat(C, "<span class='notice'>You do not have a character loaded.</span>")
		return

	if (!establish_db_connection(dbcon))
		to_chat(C, "<span class='notice'>Unable to establish database connection.</span>")
		return

	var/DBQuery/query = dbcon.NewQuery("UPDATE ss13_characters SET deleted_at = NOW(), deleted_by = \"player\" WHERE id = :char_id:")
	query.Execute(list("char_id" = current_character))

	// Create a new character.
	new_setup(1)

	to_chat(C, "<span class='warning'>Character successfully deleted! Please make a new one or load an existing setup.</span>")

/datum/preferences/proc/get_species_datum()
	if (species)
		return all_species[species]

	return null
