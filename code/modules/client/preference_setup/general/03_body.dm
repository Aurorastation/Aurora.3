GLOBAL_LIST_INIT(valid_bloodtypes, list(
	"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-",
	"SBS"	// Synthetic Blood Substitute. Intended for heavily augmented characters.
			// Sanitized below, removed if character is not augmented enough.
))

/datum/preferences
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

/datum/category_item/player_setup_item/general/body
	name = "Body"
	sort_order = 3
	var/species_menu_open = FALSE

/datum/category_item/player_setup_item/general/body/load_character(var/savefile/S)
	S["hair_red"]          >> pref.r_hair
	S["hair_green"]        >> pref.g_hair
	S["hair_blue"]         >> pref.b_hair
	S["facial_red"]        >> pref.r_facial
	S["facial_green"]      >> pref.g_facial
	S["facial_blue"]       >> pref.b_facial
	S["grad_red"]          >> pref.r_grad
	S["grad_green"]        >> pref.g_grad
	S["grad_blue"]         >> pref.b_grad
	S["skin_tone"]         >> pref.s_tone
	S["skin_red"]          >> pref.r_skin
	S["skin_green"]        >> pref.g_skin
	S["skin_blue"]         >> pref.b_skin
	S["tail_style_name"]   >> pref.tail_style
	S["hair_style_name"]   >> pref.h_style
	S["facial_style_name"] >> pref.f_style
	S["grad_style_name"]   >> pref.g_style
	S["eyes_red"]          >> pref.r_eyes
	S["eyes_green"]        >> pref.g_eyes
	S["eyes_blue"]         >> pref.b_eyes
	S["b_type"]            >> pref.b_type
	S["disabilities"]      >> pref.disabilities
	S["organ_data"]        >> pref.organ_data
	S["rlimb_data"]        >> pref.rlimb_data
	S["body_markings"]     >> pref.body_markings

/datum/category_item/player_setup_item/general/body/save_character(var/savefile/S)
	S["hair_red"]          << pref.r_hair
	S["hair_green"]        << pref.g_hair
	S["hair_blue"]         << pref.b_hair
	S["facial_red"]        << pref.r_facial
	S["facial_green"]      << pref.g_facial
	S["facial_blue"]       << pref.b_facial
	S["grad_red"]          << pref.r_grad
	S["grad_green"]        << pref.g_grad
	S["grad_blue"]         << pref.b_grad
	S["skin_tone"]         << pref.s_tone
	S["skin_red"]          << pref.r_skin
	S["skin_green"]        << pref.g_skin
	S["skin_blue"]         << pref.b_skin
	S["tail_style_name"]   << pref.tail_style
	S["hair_style_name"]   << pref.h_style
	S["facial_style_name"] << pref.f_style
	S["grad_style_name"]   << pref.g_style
	S["eyes_red"]          << pref.r_eyes
	S["eyes_green"]        << pref.g_eyes
	S["eyes_blue"]         << pref.b_eyes
	S["b_type"]            << pref.b_type
	S["disabilities"]      << pref.disabilities
	S["organ_data"]        << pref.organ_data
	S["rlimb_data"]        << pref.rlimb_data
	S["body_markings"]     << pref.body_markings
	S["bgstate"]           << pref.bgstate

/datum/category_item/player_setup_item/general/body/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"hair_colour",
				"facial_colour",
				"grad_colour",
				"skin_tone" = "s_tone",
				"skin_colour",
				"tail_style",
				"hair_style" = "h_style",
				"facial_style" = "f_style",
				"gradient_style" = "g_style",
				"eyes_colour",
				"b_type",
				"disabilities",
				"organs_data" = "organ_data",
				"organs_robotic" = "rlimb_data",
				"body_markings",
				"bgstate"
			),
			"args" = list("id")
		)
	)

/datum/category_item/player_setup_item/general/body/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/general/body/gather_save_query()
	return list(
		"ss13_characters" = list(
			"hair_colour",
			"facial_colour",
			"grad_colour",
			"skin_tone",
			"skin_colour",
			"tail_style",
			"hair_style",
			"facial_style",
			"gradient_style",
			"eyes_colour",
			"b_type",
			"disabilities",
			"organs_data",
			"organs_robotic",
			"body_markings",
			"bgstate",
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/general/body/gather_save_parameters()
	return list(
		"hair_colour"   = rgb(pref.r_hair, pref.g_hair, pref.b_hair),
		"facial_colour" = rgb(pref.r_facial, pref.g_facial, pref.b_facial),
		"grad_colour"   = rgb(pref.r_grad, pref.g_grad, pref.b_grad),
		"skin_tone"     = pref.s_tone,
		"skin_colour"   = rgb(pref.r_skin, pref.g_skin, pref.b_skin),
		"tail_style"    = pref.tail_style,
		"hair_style"    = pref.h_style,
		"facial_style"  = pref.f_style,
		"gradient_style"= pref.g_style,
		"eyes_colour"   = rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes),
		"b_type"        = pref.b_type,
		"disabilities"  = json_encode(pref.disabilities),
		"organs_data"   = list2params(pref.organ_data),
		"organs_robotic"= list2params(pref.rlimb_data),
		"body_markings" = json_encode(pref.body_markings),
		"id"            = pref.current_character,
		"bgstate"       = pref.bgstate,
		"ckey"          = pref.client.ckey
	)

/datum/category_item/player_setup_item/general/body/sanitize_character(var/sql_load = 0)
	if (sql_load)
		pref.hair_colour = sanitize_hexcolor(pref.hair_colour)
		pref.r_hair      = GetRedPart(pref.hair_colour)
		pref.g_hair      = GetGreenPart(pref.hair_colour)
		pref.b_hair      = GetBluePart(pref.hair_colour)

		pref.facial_colour = sanitize_hexcolor(pref.facial_colour)
		pref.r_facial      = GetRedPart(pref.facial_colour)
		pref.g_facial      = GetGreenPart(pref.facial_colour)
		pref.b_facial      = GetBluePart(pref.facial_colour)

		pref.grad_colour = sanitize_hexcolor(pref.grad_colour)
		pref.r_grad      = GetRedPart(pref.grad_colour)
		pref.g_grad      = GetGreenPart(pref.grad_colour)
		pref.b_grad      = GetBluePart(pref.grad_colour)

		pref.s_tone = text2num(pref.s_tone)

		pref.skin_colour = sanitize_hexcolor(pref.skin_colour)
		pref.r_skin      = GetRedPart(pref.skin_colour)
		pref.g_skin      = GetGreenPart(pref.skin_colour)
		pref.b_skin      = GetBluePart(pref.skin_colour)

		pref.skin_colour = sanitize_hexcolor(pref.skin_colour)
		pref.r_eyes      = GetRedPart(pref.eyes_colour)
		pref.g_eyes      = GetGreenPart(pref.eyes_colour)
		pref.b_eyes      = GetBluePart(pref.eyes_colour)

		if (istext(pref.organ_data))
			pref.organ_data = params2list(pref.organ_data)
		if (istext(pref.rlimb_data))
			pref.rlimb_data = params2list(pref.rlimb_data)
		if (istext(pref.body_markings))
			var/before = pref.body_markings
			try
				pref.body_markings = json_decode(pref.body_markings)
			catch (var/exception/e)
				LOG_DEBUG("BODY MARKINGS: Caught [e]. Initial value: [before]")
				pref.body_markings = list()
		if (istext(pref.disabilities))
			var/before = pref.disabilities
			try
				pref.disabilities = json_decode(pref.disabilities)
			catch (var/exception/e)
				LOG_DEBUG("DISABILITIES: Caught [e]. Initial value: [before]")
				pref.disabilities = list()

	var/datum/species/mob_species = GLOB.all_species[pref.species]

	pref.r_hair   = sanitize_integer(pref.r_hair, 0, 255, initial(pref.r_hair))
	pref.g_hair   = sanitize_integer(pref.g_hair, 0, 255, initial(pref.g_hair))
	pref.b_hair   = sanitize_integer(pref.b_hair, 0, 255, initial(pref.b_hair))
	pref.r_facial = sanitize_integer(pref.r_facial, 0, 255, initial(pref.r_facial))
	pref.g_facial = sanitize_integer(pref.g_facial, 0, 255, initial(pref.g_facial))
	pref.b_facial = sanitize_integer(pref.b_facial, 0, 255, initial(pref.b_facial))
	pref.s_tone   = sanitize_integer(pref.s_tone, -mob_species.upper_skin_tone_bound + 35, -mob_species.lower_skin_tone_bound + 35, initial(pref.s_tone))
	pref.r_skin   = sanitize_integer(pref.r_skin, 0, 255, initial(pref.r_skin))
	pref.g_skin   = sanitize_integer(pref.g_skin, 0, 255, initial(pref.g_skin))
	pref.b_skin   = sanitize_integer(pref.b_skin, 0, 255, initial(pref.b_skin))
	pref.tail_style = sanitize_inlist(pref.tail_style, mob_species.selectable_tails, mob_species.tail)
	pref.h_style  = sanitize_inlist(pref.h_style, GLOB.hair_styles_list, initial(pref.h_style))
	pref.f_style  = sanitize_inlist(pref.f_style, GLOB.facial_hair_styles_list, initial(pref.f_style))
	pref.g_style = sanitize_inlist(pref.g_style, GLOB.hair_gradient_styles_list, initial(pref.g_style))
	pref.r_eyes   = sanitize_integer(pref.r_eyes, 0, 255, initial(pref.r_eyes))
	pref.g_eyes   = sanitize_integer(pref.g_eyes, 0, 255, initial(pref.g_eyes))
	pref.b_eyes   = sanitize_integer(pref.b_eyes, 0, 255, initial(pref.b_eyes))
	pref.b_type   = sanitize_text(pref.b_type, initial(pref.b_type))

	if (!pref.organ_data || !islist(pref.organ_data))
		pref.organ_data = list()
	if (!pref.rlimb_data || !islist(pref.rlimb_data))
		pref.rlimb_data = list()
	if (!pref.body_markings || !islist(pref.body_markings))
		pref.body_markings = list()
	if (!pref.disabilities || !islist(pref.disabilities))
		pref.disabilities = list()

	if(!pref.bgstate || !(pref.bgstate in list_values(pref.bgstate_options)))
		pref.bgstate = "plain_black"

	// Synthetic Blood Substitute checks.
	if((pref.b_type == "SBS") && ((length(pref.organ_data) + length(pref.rlimb_data)) < 8))
		to_chat(pref.client, SPAN_WARNING("Synthetic Blood Substitute (SBS) is intended for heavily augmented characters. To pick it, you must have at least eight augmented limbs or organs. Resetting blood type..."))
		pref.b_type = initial(pref.b_type)

/datum/category_item/player_setup_item/general/body/proc/get_prosthesis_label(organ_name, status)
	var/pretty_name = capitalize_first_letters(parse_zone(organ_name))
	if(status == ORGAN_PREF_CYBORG || status == ORGAN_PREF_MECHANICAL)
		var/datum/robolimb/R = GLOB.basic_robolimb
		if(pref.rlimb_data[organ_name] && GLOB.all_robolimbs[pref.rlimb_data[organ_name]])
			R = GLOB.all_robolimbs[pref.rlimb_data[organ_name]]
		return status == ORGAN_PREF_CYBORG ? "[R.company] [pretty_name] Prosthesis" : "[R.company] Mechanical [pretty_name]"
	if(status == ORGAN_PREF_AMPUTATED)
		return "Amputated [pretty_name]"
	if(status == ORGAN_PREF_NYMPH)
		return "Diona Nymph [pretty_name]"
	if(status == ORGAN_PREF_ASSISTED)
		switch(organ_name)
			if(BP_HEART)
				return "Pacemaker-Assisted [pretty_name]"
			if("voicebox")
				return "Surgically Altered [pretty_name]"
			if(BP_EYES)
				return "Retinal Overlayed [pretty_name]"
			if(BP_BRAIN)
				return "Pseudoneuron-Assisted [pretty_name]"
			else
				return "Mechanically Assisted [pretty_name]"
	if(status == ORGAN_PREF_REMOVED)
		return "Removed [pretty_name]"

/datum/category_item/player_setup_item/general/body/ui_data(var/mob/user)
	var/datum/species/mob_species = GLOB.all_species[pref.species]
	var/list/fields = list(
		list("label" = "Species", "value" = pref.species, "action" = "show_species"),
		list("label" = "Blood Type", "value" = pref.b_type, "action" = "blood_type")
	)
	if(has_flag(mob_species, HAS_SKIN_TONE))
		fields += list(list("label" = "Skin Tone", "value" = "[-pref.s_tone + 35]/[mob_species.upper_skin_tone_bound]", "action" = "skin_tone"))

	var/list/internal_organs = list()
	if(length(mob_species.alterable_internal_organs))
		for(var/organ in pref.organ_data)
			var/output_pref = pref.organ_data[organ] || "Default"
			internal_organs += list(list("name" = capitalize_first_letters(parse_zone(organ)), "status" = capitalize(output_pref)))

	var/list/prostheses = list()
	for(var/organ_name in pref.organ_data)
		var/label = get_prosthesis_label(organ_name, pref.organ_data[organ_name])
		if(label)
			prostheses += label

	var/list/preview_actions = list(
		list("label" = "Cycle Background", "action" = "cycle_bg", "value" = 1),
		list("label" = "Select Background", "action" = "select_bg", "value" = 1),
		list("label" = "Set Preview Scale: [pref.scale_x] × [pref.scale_y]", "action" = "set_preview_scale", "value" = 1),
		list("label" = pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout", "action" = "toggle_preview_value", "value" = EQUIP_PREVIEW_LOADOUT),
		list("label" = pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear", "action" = "toggle_preview_value", "value" = EQUIP_PREVIEW_JOB),
		list("label" = pref.equip_preview_mob & EQUIP_PREVIEW_JOB_HAT ? "Hide hat" : "Show hat", "action" = "toggle_preview_value", "value" = EQUIP_PREVIEW_JOB_HAT),
		list("label" = pref.equip_preview_mob & EQUIP_PREVIEW_JOB_UNIFORM ? "Hide uniform" : "Show uniform", "action" = "toggle_preview_value", "value" = EQUIP_PREVIEW_JOB_UNIFORM),
		list("label" = pref.equip_preview_mob & EQUIP_PREVIEW_JOB_SUIT ? "Hide suit" : "Show suit", "action" = "toggle_preview_value", "value" = EQUIP_PREVIEW_JOB_SUIT),
		list("label" = pref.equip_preview_mob & EQUIP_PREVIEW_CUSTOM_ITEMS ? "Hide custom items" : "Show custom items", "action" = "toggle_preview_value", "value" = EQUIP_PREVIEW_CUSTOM_ITEMS)
	)

	var/list/appearance = list()
	if(length(mob_species.selectable_tails))
		appearance += list(list("name" = "Tail", "style" = pref.tail_style || "None", "style_action" = "tail_style"))
	appearance += list(list("name" = "Hair", "style" = pref.h_style, "style_action" = "hair_style", "previous_action" = "previous_hair_style", "next_action" = "next_hair_style", "color" = rgb(pref.r_hair, pref.g_hair, pref.b_hair), "color_action" = has_flag(mob_species, HAS_HAIR_COLOR) ? "hair_color" : null))
	appearance += list(list("name" = "Facial", "style" = pref.f_style, "style_action" = "facial_style", "previous_action" = "previous_facial_style", "next_action" = "next_facial_style", "color" = rgb(pref.r_facial, pref.g_facial, pref.b_facial), "color_action" = has_flag(mob_species, HAS_HAIR_COLOR) ? "facial_color" : null))
	appearance += list(list("name" = "Gradient", "style" = pref.g_style, "style_action" = "gradient_style", "color" = rgb(pref.r_grad, pref.g_grad, pref.b_grad), "color_action" = has_flag(mob_species, HAS_HAIR_COLOR) ? "gradient_color" : null))
	if(has_flag(mob_species, HAS_EYE_COLOR))
		appearance += list(list("name" = "Eyes", "color" = rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes), "color_action" = "eye_color"))
	if(has_flag(mob_species, HAS_SKIN_COLOR))
		appearance += list(list("name" = "Body Color", "color" = rgb(pref.r_skin, pref.g_skin, pref.b_skin), "color_action" = "skin_color"))

	var/list/markings = list()
	for(var/marking in pref.body_markings)
		markings += list(list(
			"name" = marking,
			"color" = pref.body_markings[marking],
			"can_reorder" = pref.body_markings.len > 1,
			"has_preset" = length(mob_species.character_color_presets)
		))

	var/list/species_categories = list()
	if(species_menu_open)
		for(var/category_name in GLOB.playable_species)
			var/list/species_options = list()
			for(var/species_name in GLOB.playable_species[category_name])
				var/datum/species/species_option = GLOB.all_species[species_name]
				if(!species_option)
					continue
				var/description = replacetext(species_option.blurb, "<br>", "\n")
				description = replacetext(description, "<br/>", "\n")
				description = replacetext(description, "</p>", "\n\n")
				description = html_decode(strip_html_properly(description))
				species_options += list(list(
					"name" = species_option.name,
					"description" = description,
					"language" = species_option.language || "None",
					"traits" = get_species_traits(species_option),
					"available" = species_is_available(species_option, user),
					"current" = (species_option.name == pref.species),
					"selected" = (species_option.name == pref.species_preview)
				))
			species_categories += list(list(
				"name" = category_name,
				"species" = species_options
			))

	return list(
		"kind" = "body",
		"name" = name,
		"ref" = REF(src),
		"fields" = fields,
		"disabilities" = pref.disabilities,
		"has_internal_organs" = length(mob_species.alterable_internal_organs),
		"internal_organs" = internal_organs,
		"prostheses" = prostheses,
		"preview_actions" = preview_actions,
		"appearance" = appearance,
		"has_skin_preset" = has_flag(mob_species, HAS_SKIN_PRESET),
		"markings" = markings,
		"species_menu_open" = species_menu_open,
		"species_categories" = species_categories
	)

/datum/category_item/player_setup_item/general/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/general/body/proc/get_species_traits(var/datum/species/selected_species)
	var/list/species_traits = list()
	if(selected_species.spawn_flags & CAN_JOIN)
		species_traits += "Often present on human stations"
	if(selected_species.spawn_flags & IS_WHITELISTED)
		species_traits += "Whitelist restricted"
	if(selected_species.flags & NO_BLOOD)
		species_traits += "Does not have blood"
	if(selected_species.flags & NO_BREATHE)
		species_traits += "Does not breathe"
	if(selected_species.flags & NO_SCAN)
		species_traits += "Does not have DNA"
	if(selected_species.flags & NO_PAIN)
		species_traits += "Does not feel pain"
	if(selected_species.flags & NO_SLIP)
		species_traits += "Has excellent traction"
	if(selected_species.flags & NO_POISON)
		species_traits += "Immune to most poisons"
	if(selected_species.appearance_flags & HAS_SKIN_TONE)
		species_traits += "Has a variety of skin tones"
	if(selected_species.appearance_flags & HAS_SKIN_COLOR)
		species_traits += "Has a variety of skin colours"
	if(selected_species.appearance_flags & HAS_EYE_COLOR)
		species_traits += "Has a variety of eye colours"
	if(selected_species.flags & IS_PLANT)
		species_traits += "Has a plantlike physiology"
	return species_traits

/datum/category_item/player_setup_item/general/body/proc/species_is_playable(var/species_name)
	for(var/category_name in GLOB.playable_species)
		if(species_name in GLOB.playable_species[category_name])
			return TRUE
	return FALSE

/datum/category_item/player_setup_item/general/body/proc/species_is_available(var/datum/species/selected_species, var/mob/user)
	if(!GLOB.config.usealienwhitelist || check_rights(R_ADMIN, FALSE, user))
		return TRUE
	if(!(selected_species.spawn_flags & CAN_JOIN))
		return FALSE
	if((selected_species.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(preference_mob(), selected_species.name))
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/general/body/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/mob_species = GLOB.all_species[pref.species]

	if(href_list["random"])
		pref.randomize_appearance_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_type"])
		var/new_b_type = tgui_input_list(user, "Choose your character's blood-type:", "Character Preference", GLOB.valid_bloodtypes)
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return TOPIC_REFRESH

	else if(href_list["show_species"])
		species_menu_open = TRUE
		pref.species_preview = pref.species
		return TOPIC_REFRESH

	else if(href_list["preview_species"])
		var/choice = html_decode(href_list["preview_species"])
		if(!species_menu_open || !species_is_playable(choice) || !(choice in GLOB.all_species))
			return TOPIC_NOACTION
		pref.species_preview = choice
		return TOPIC_REFRESH

	else if(href_list["close_species"])
		species_menu_open = FALSE
		pref.species_preview = null
		return TOPIC_REFRESH

	else if(href_list["confirm_species"])
		var/choice = pref.species_preview
		var/datum/species/selected_species = GLOB.all_species[choice]
		if(!species_menu_open || !selected_species || !species_is_playable(choice) || !species_is_available(selected_species, user))
			return TOPIC_NOACTION
		species_menu_open = FALSE
		pref.alternate_languages.Cut()
		return OnTopic(null, list("set_species" = choice), user)

	else if(href_list["set_species"])
		var/choice = html_decode(href_list["set_species"])
		var/datum/species/selected_species = GLOB.all_species[choice]
		if(!pref.species_preview || choice != pref.species_preview || !selected_species || !species_is_playable(choice) || !species_is_available(selected_species, user))
			return TOPIC_NOACTION

		var/prev_species = pref.species
		pref.species = choice
		if(prev_species != pref.species)
			mob_species = GLOB.all_species[pref.species]

			pref.gender = sanitize_gender(pref.gender, pref.species)
			//var/bodytype = mob_species.get_bodytype()

			//grab one of the valid hair styles for the newly chosen species
			var/list/valid_hairstyles = list()

			// Snowflake check for industrials - they're an IPC bodytype but don't have IPC screens.
			for(var/hairstyle in GLOB.hair_styles_list)
				var/datum/sprite_accessory/S = GLOB.hair_styles_list[hairstyle]
				if(pref.gender == MALE && S.gender == FEMALE)
					continue
				if(pref.gender == FEMALE && S.gender == MALE)
					continue
				if(!(mob_species.type in S.species_allowed))
					continue
				if(!verify_robolimb_appropriate(S))
					continue

				valid_hairstyles[hairstyle] = GLOB.hair_styles_list[hairstyle]

			if(valid_hairstyles.len)
				pref.h_style = pick(valid_hairstyles)
			else	// Species has no hair, or something fucked up.
				pref.h_style = GLOB.hair_styles_list["Bald"]

			if(length(mob_species.selectable_tails))
				pref.tail_style = pick(mob_species.selectable_tails)
			else
				pref.tail_style = null

			//grab one of the valid facial hair styles for the newly chosen species
			var/list/valid_facialhairstyles = list()
			for(var/facialhairstyle in GLOB.facial_hair_styles_list)
				var/datum/sprite_accessory/S = GLOB.facial_hair_styles_list[facialhairstyle]
				if(pref.gender == MALE && S.gender == FEMALE)
					continue
				if(pref.gender == FEMALE && S.gender == MALE)
					continue
				if(!(mob_species.type in S.species_allowed))
					continue
				if(!verify_robolimb_appropriate(S))
					continue

				valid_facialhairstyles[facialhairstyle] = GLOB.facial_hair_styles_list[facialhairstyle]

			if(valid_facialhairstyles.len)
				pref.f_style = pick(valid_facialhairstyles)
			else
				//this shouldn't happen
				pref.f_style = GLOB.facial_hair_styles_list["Shaved"]

			var/list/valid_hair_gradients = list()
			for(var/hair_gradient in GLOB.hair_gradient_styles_list)
				var/datum/sprite_accessory/S = GLOB.hair_gradient_styles_list[hair_gradient]
				if(pref.gender == MALE && S.gender == FEMALE)
					continue
				if(pref.gender == FEMALE && S.gender == MALE)
					continue
				if(!(mob_species.type in S.species_allowed))
					continue
				if(!verify_robolimb_appropriate(S))
					continue

				valid_hair_gradients[hair_gradient] = valid_hair_gradients[hair_gradient]

			if(length(valid_hair_gradients))
				pref.g_style = pick(valid_hair_gradients)
			else
				//this shouldn't happen
				pref.g_style = valid_hair_gradients["None"]

			//reset hair colour and skin colour
			pref.r_hair = 0//hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = 0//hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = 0//hex2num(copytext(new_hair, 6, 8))
			pref.s_tone = 0

			pref.organ_data.Cut()
			pref.rlimb_data.Cut()
			pref.body_markings.Cut()

			var/new_culture = mob_species.possible_cultures[1]
			pref.culture = "[new_culture]"
			var/singleton/origin_item/culture/OC = GET_SINGLETON(text2path(pref.culture))
			var/new_origin = OC.possible_origins[1]
			pref.origin = "[new_origin]"
			var/singleton/origin_item/origin/OO = GET_SINGLETON(text2path(pref.origin))
			pref.accent = OO.possible_accents[1]
			pref.citizenship = OO.possible_citizenships[1]
			pref.religion = OO.possible_religions[1]

			var/datum/faction/current_faction = SSjobs.name_factions[pref.faction]
			if(!current_faction?.can_select(pref, user))
				to_chat(user, SPAN_WARNING("[pref.faction] does not employ [mob_species.name_plural]. Resetting to [SSjobs.default_faction.name]!"))
				pref.faction = SSjobs.default_faction.name

			// Follows roughly the same way hair does above, but for gradient styles
			var/global/list/valid_gradients = list()

			if(!valid_gradients[mob_species.type])
				valid_gradients[mob_species.type] = list()
				for(var/gradient in GLOB.hair_gradient_styles_list)
					var/datum/sprite_accessory/S = GLOB.hair_gradient_styles_list[gradient]
					if(mob_species.type in S.species_allowed)
						valid_gradients[mob_species.type] += gradient

			if(!(pref.g_style in valid_gradients[mob_species.type]))
				pref.g_style = GLOB.hair_gradient_styles_list["None"]

			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour.", "Character Preference", rgb(pref.r_hair, pref.g_hair, pref.b_hair)) as color|null
		if(new_hair && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_hair = GetRedPart(new_hair)
			pref.g_hair = GetGreenPart(new_hair)
			pref.b_hair = GetBluePart(new_hair)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["gradient_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_grad = input(user, "Choose your character's secondary hair color.", "Character Preference", rgb(pref.r_grad, pref.g_grad, pref.b_grad)) as color|null
		if(new_grad && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_grad = GetRedPart(new_grad)
			pref.g_grad = GetGreenPart(new_grad)
			pref.b_grad = GetBluePart(new_grad)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_style"])
		if(!length(mob_species.selectable_tails))
			return
		var/new_tail_style = tgui_input_list(user, "Choose your character's tail style:", "Character Preference", mob_species.selectable_tails, pref.tail_style)
		if(new_tail_style && CanUseTopic(user))
			pref.tail_style = new_tail_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"] || href_list["next_hair_style"] || href_list["previous_hair_style"])
		if(mob_species.bald)
			return
		//var/bodytype = mob_species.get_bodytype()
		var/list/valid_hairstyles = list()
		for(var/hairstyle in GLOB.hair_styles_list)
			var/datum/sprite_accessory/S = GLOB.hair_styles_list[hairstyle]
			if(pref.gender == MALE && S.gender == FEMALE)
				continue
			if(pref.gender == FEMALE && S.gender == MALE)
				continue
			if(!(mob_species.type in S.species_allowed))
				continue
			if(!verify_robolimb_appropriate(S))
				continue

			valid_hairstyles[hairstyle] = GLOB.hair_styles_list[hairstyle]

		var/new_h_style
		var/selected_style_index = valid_hairstyles.Find(pref.h_style)

		if(href_list["next_hair_style"])
			if(selected_style_index >= valid_hairstyles.len)
				new_h_style = valid_hairstyles[1]
			else
				new_h_style = valid_hairstyles[selected_style_index + 1]

		else if(href_list["previous_hair_style"])
			if(selected_style_index <= 1)
				new_h_style = valid_hairstyles[valid_hairstyles.len]
			else
				new_h_style = valid_hairstyles[selected_style_index - 1]

		else
			new_h_style = tgui_input_list(
				user,
				"Choose your character's hair style.",
				"Character Preference",
				valid_hairstyles,
				pref.h_style
			)

		if(new_h_style && CanUseTopic(user))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["gradient_style"])
		var/list/valid_gradients = list()
		for(var/gradstyle in GLOB.hair_gradient_styles_list)
			var/datum/sprite_accessory/S = GLOB.hair_gradient_styles_list[gradstyle]
			if(!(mob_species.type in S.species_allowed))
				continue

			valid_gradients[gradstyle] = GLOB.hair_gradient_styles_list[gradstyle]

		var/new_g_style = tgui_input_list(user, "Choose a color pattern for your hair.", "Character Preference", valid_gradients, pref.g_style)
		if(new_g_style && CanUseTopic(user))
			pref.g_style = new_g_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour.", "Character Preference", rgb(pref.r_facial, pref.g_facial, pref.b_facial)) as color|null
		if(new_facial && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_facial = GetRedPart(new_facial)
			pref.g_facial = GetGreenPart(new_facial)
			pref.b_facial = GetBluePart(new_facial)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour.", "Character Preference", rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes)) as color|null
		if(new_eyes && has_flag(mob_species, HAS_EYE_COLOR) && CanUseTopic(user))
			pref.r_eyes = GetRedPart(new_eyes)
			pref.g_eyes = GetGreenPart(new_eyes)
			pref.b_eyes = GetBluePart(new_eyes)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_SKIN_TONE))
			return TOPIC_NOACTION
		var/new_s_tone = tgui_input_number(user, "Choose your character's skin-tone. (Light [mob_species.lower_skin_tone_bound] - [mob_species.upper_skin_tone_bound] Dark)", "Character Preference", (-pref.s_tone) + 35, mob_species.upper_skin_tone_bound, mob_species.lower_skin_tone_bound)
		if(new_s_tone && has_flag(mob_species, HAS_SKIN_TONE) && CanUseTopic(user))
			pref.s_tone = 35 - clamp(round(new_s_tone), mob_species.lower_skin_tone_bound, mob_species.upper_skin_tone_bound)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(has_flag(mob_species, HAS_SKIN_COLOR))
			var/new_skin = input(user, "Choose your character's skin colour.", "Character Preference", rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as color|null
			if(new_skin && has_flag(mob_species, HAS_SKIN_COLOR) && CanUseTopic(user))
				pref.r_skin = GetRedPart(new_skin)
				pref.g_skin = GetGreenPart(new_skin)
				pref.b_skin = GetBluePart(new_skin)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_preset"])
		if(has_flag(mob_species, HAS_SKIN_PRESET))
			var/new_preset = tgui_input_list(user, "Choose your character's body color preset.", "Character Preference", mob_species.character_color_presets, rgb(pref.r_skin, pref.g_skin, pref.b_skin))
			new_preset = mob_species.character_color_presets[new_preset]
			pref.r_skin = GetRedPart(new_preset)
			pref.g_skin = GetGreenPart(new_preset)
			pref.b_skin = GetBluePart(new_preset)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"] || href_list["next_facial_style"] || href_list["previous_facial_style"])
		if(mob_species.bald)
			return
		var/list/valid_facialhairstyles = list()
		//var/bodytype = mob_species.get_bodytype()
		for(var/facialhairstyle in GLOB.facial_hair_styles_list)
			var/datum/sprite_accessory/S = GLOB.facial_hair_styles_list[facialhairstyle]
			if(pref.gender == MALE && S.gender == FEMALE)
				continue
			if(pref.gender == FEMALE && S.gender == MALE)
				continue
			if(!(mob_species.type in S.species_allowed))
				continue
			if(!verify_robolimb_appropriate(S))
				continue

			valid_facialhairstyles[facialhairstyle] = GLOB.facial_hair_styles_list[facialhairstyle]

		var/new_f_style
		var/selected_style_index = valid_facialhairstyles.Find(pref.f_style)

		if(href_list["next_facial_style"])
			if(selected_style_index >= valid_facialhairstyles.len)
				new_f_style = valid_facialhairstyles[1]
			else
				new_f_style = valid_facialhairstyles[selected_style_index + 1]

		else if(href_list["previous_facial_style"])
			if(selected_style_index <= 1)
				new_f_style = valid_facialhairstyles[valid_facialhairstyles.len]
			else
				new_f_style = valid_facialhairstyles[selected_style_index - 1]

		else
			new_f_style = tgui_input_list(
				user,
				"Choose your character's facial-hair style:",
				"Character Preference",
				valid_facialhairstyles,
				pref.f_style
			)

		if(new_f_style && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/usable_markings = pref.body_markings ^ GLOB.body_marking_styles_list
		var/datum/species/species = GLOB.all_species[pref.species]
		for(var/M in usable_markings)
			var/datum/sprite_accessory/S = usable_markings[M]
			if(!length(S.species_allowed))
				continue
			else if(!(species.type in S.species_allowed))
				usable_markings -= M
			if(!verify_robolimb_appropriate(S))
				usable_markings -= M

		if (!usable_markings.len)
			alert(user, "This species does not have any body markings available.")
			return TOPIC_NOACTION

		var/new_marking = tgui_input_list(user, "Choose a body marking:", "Character Preference", usable_markings)
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking] = "#000000" //New markings start black
			return TOPIC_REFRESH_UPDATE_PREVIEW


	else if(href_list["marking_up"])
		var/M = href_list["marking_up"]
		var/start = pref.body_markings.Find(M)
		if(start != 1) //If we're not the beginning of the list, swap with the previous element.
			moveElement(pref.body_markings, start, start-1)
		else //But if we ARE, become the final element -ahead- of everything else.
			moveElement(pref.body_markings, start, pref.body_markings.len+1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_down"])
		var/M = href_list["marking_down"]
		var/start = pref.body_markings.Find(M)
		if(start != pref.body_markings.len) //If we're not the end of the list, swap with the next element.
			moveElement(pref.body_markings, start, start+2)
		else //But if we ARE, become the first element -behind- everything else.
			moveElement(pref.body_markings, start, 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/M = href_list["marking_remove"]
		pref.body_markings -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		var/mark_color = input(user, "Choose the [M] color: ", "Character Preference", pref.body_markings[M]) as color|null
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M] = "[mark_color]"
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_preset"])
		var/M = href_list["marking_preset"]
		var/mark_preset = tgui_input_list(user, "Choose the [M] preset: ", "Character Preference", mob_species.character_color_presets, rgb(pref.r_skin, pref.g_skin, pref.b_skin))
		mark_preset = mob_species.character_color_presets[mark_preset]
		if(mark_preset && CanUseTopic(user))
			pref.body_markings[M] = "[mark_preset]"
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["limbs"])
		var/list/acceptable_organ_input = list("Head", "Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand")
		var/limb_name = tgui_input_list(user, "Which limb do you want to change?", "Limbs", acceptable_organ_input)
		if(!limb_name && !CanUseTopic(user)) return TOPIC_NOACTION

		var/carries_organs = 0
		var/limb = null
		var/second_limb = null // if you try to change the arm, the hand should also change
		var/third_limb = null  // if you try to unchange the hand, the arm should also change
		switch(limb_name)
			if("Left Leg")
				limb = BP_L_LEG
				second_limb = BP_L_FOOT
			if("Right Leg")
				limb = BP_R_LEG
				second_limb = BP_R_FOOT
			if("Left Arm")
				limb = BP_L_ARM
				second_limb = BP_L_HAND
			if("Right Arm")
				limb = BP_R_ARM
				second_limb = BP_R_HAND
			if("Left Foot")
				limb = BP_L_FOOT
				third_limb = BP_L_LEG
			if("Right Foot")
				limb = BP_R_FOOT
				third_limb = BP_R_LEG
			if("Left Hand")
				limb = BP_L_HAND
				third_limb = BP_L_ARM
			if("Right Hand")
				limb = BP_R_HAND
				third_limb = BP_R_ARM
			if("Lower Body")
				limb = BP_GROIN
				carries_organs = 1
			if("Upper Body")
				limb = BP_CHEST
				carries_organs = 1
			if("Head")
				limb = BP_HEAD
				carries_organs = 1
			else
				to_chat(user, SPAN_NOTICE("Cancelled."))
				return TOPIC_NOACTION

		var/list/available_states = mob_species.possible_external_organs_modifications
		if(carries_organs)
			available_states = list("Normal","Prosthesis")
		var/new_state = tgui_input_list(user, "What state do you wish the limb to be in?", "Limbs", available_states)
		if(!new_state && !CanUseTopic(user))
			return TOPIC_NOACTION

		switch(new_state)
			if("Normal")
				pref.organ_data -= limb
				pref.rlimb_data -= limb
				if(third_limb)
					pref.organ_data -= third_limb
					pref.rlimb_data -= third_limb

			if("Amputated")
				pref.organ_data[limb] = ORGAN_PREF_AMPUTATED
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = ORGAN_PREF_AMPUTATED
					pref.rlimb_data[second_limb] = null

			if("Prosthesis")
				var/tmp_species = pref.species ? pref.species : SPECIES_HUMAN
				var/list/usable_manufacturers = list()
				for(var/company in GLOB.chargen_robolimbs)
					var/datum/robolimb/M = GLOB.chargen_robolimbs[company]
					if(!(tmp_species in M.species_can_use))
						continue
					if(!(limb in M.allowed_external_organs))
						continue
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = tgui_input_list(user, "Which manufacturer do you wish to use for this limb?", "Limb Manufacturer", usable_manufacturers)
				if(!choice)
					return
				pref.rlimb_data[limb] = choice
				pref.organ_data[limb] = ORGAN_PREF_CYBORG
				if(second_limb)
					pref.rlimb_data[second_limb] = choice
					pref.organ_data[second_limb] = ORGAN_PREF_CYBORG
				if(third_limb && pref.organ_data[third_limb] == ORGAN_PREF_AMPUTATED)
					pref.organ_data[third_limb] = null

			if("Diona Nymph")
				pref.organ_data[limb] = ORGAN_PREF_NYMPH
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = ORGAN_PREF_NYMPH
					pref.rlimb_data[second_limb] = null

		// Recheck markings in case we changed prosthetics.
		recheck_markings_and_facial_hair()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["organs"])
		if(!mob_species.alterable_internal_organs.len)
			return
		var/organ_name = tgui_input_list(user, "Which internal function do you want to change?", "Alter Organs", mob_species.alterable_internal_organs)
		if(!organ_name)
			return

		var/organ_type = mob_species.has_organ[organ_name]
		var/obj/item/organ/internal/altered_organ = new organ_type(null)

		if(!altered_organ)
			return

		var/new_state = tgui_input_list(user, "What state do you wish the organ to be in?", "Alter Organs", altered_organ.possible_modifications)

		qdel(altered_organ)

		if(!new_state) return

		switch(new_state)
			if("Normal")
				pref.organ_data[organ_name] = null
			if("Assisted")
				pref.organ_data[organ_name] = ORGAN_PREF_ASSISTED
			if("Mechanical")

				var/tmp_species = pref.species ? pref.species : SPECIES_HUMAN
				var/list/usable_manufacturers = list()
				for(var/company in GLOB.internal_robolimbs)
					var/datum/robolimb/M = GLOB.chargen_robolimbs[company]
					if(!(tmp_species in M.species_can_use))
						continue
					if(!(organ_name in M.allowed_internal_organs))
						continue
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = tgui_input_list(user, "Which manufacturer do you wish to use for this organ?", "Alter Organs", usable_manufacturers)
				if(!choice)
					return

				pref.rlimb_data[organ_name] = choice
				pref.organ_data[organ_name] = ORGAN_PREF_MECHANICAL

			if("Removed")
				pref.organ_data[organ_name] = ORGAN_PREF_REMOVED

			// IPC cooling unit options.
			if("Air Cooling")
				pref.organ_data[organ_name] = null
			if("Liquid Cooling")
				pref.organ_data[organ_name] = ORGAN_PREF_LIQUIDCOOLED
			if("Passive Cooling")
				pref.organ_data[organ_name] = ORGAN_PREF_PASSIVECOOLED

			// IPC reactor options.
			if("Electric")
				pref.organ_data[organ_name] = null
			if("Biological")
				pref.organ_data[organ_name] = ORGAN_PREF_BIOPOWER
			if("Solar")
				pref.organ_data[organ_name] = ORGAN_PREF_SOLARPOWER

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["reset_organs"])
		pref.organ_data.Cut()
		pref.rlimb_data.Cut()
		recheck_markings_and_facial_hair()

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["trait_add"])
		var/list/available_disabilities = pref.disabilities ^ GLOB.chargen_disabilities_list

		var/new_trait = tgui_input_list(user, "Choose a disability.", "Character Preference", available_disabilities)
		if(new_trait && CanUseTopic(user))
			pref.disabilities += new_trait
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["trait_remove"])
		var/M = href_list["trait_remove"]
		pref.disabilities -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cycle_bg"])
		pref.bgstate = next_in_assoc_list(pref.bgstate, pref.bgstate_options)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["select_bg"])
		var/choice = tgui_input_list(user, "Which background would you like for your preview?", "Select Preview Background", pref.bgstate_options)
		if(choice)
			pref.bgstate = pref.bgstate_options[choice]
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["set_preview_scale"])
		var/new_x = input(user, "Set X Scale for Preview", "Preview Preference") as null|num
		pref.scale_x = new_x ? clamp(new_x, 0.1, 2) : 1
		var/new_y = input(user, "Set Y Scale for Preview", "Preview Preference") as null|num
		pref.scale_y = new_y ? clamp(new_y, 0.1, 2) : 1
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_preview_value"])
		pref.equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
		return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/// This proc verifies if a sprite accessory can be put on a robolimb, checking its manufacturer.
/datum/category_item/player_setup_item/general/body/proc/verify_robolimb_appropriate(datum/sprite_accessory/S)
	var/organ_status = pref.organ_data[S.required_organ]
	var/robolimb_manufacturer = pref.rlimb_data[S.required_organ]
	. = check_robolimb_appropriate(S, organ_status, robolimb_manufacturer)

/// This proc is used to check markings and facial hair after changing prosthesis.
/datum/category_item/player_setup_item/general/body/proc/recheck_markings_and_facial_hair()
	if(length(pref.body_markings))
		for(var/marking in pref.body_markings)
			var/datum/sprite_accessory/S = GLOB.body_marking_styles_list[marking]
			if(!verify_robolimb_appropriate(S))
				pref.body_markings -= marking
				to_chat(pref.client, SPAN_WARNING("Removed the [marking] marking as it is not appropriate for your current robo-limb!"))

	if(pref.f_style)
		var/datum/sprite_accessory/F = GLOB.facial_hair_styles_list[pref.f_style]
		if(!verify_robolimb_appropriate(F))
			var/datum/species/user_species = GLOB.all_species[pref.species]
			var/organ_status = pref.organ_data[F.required_organ]
			var/robolimb_manufacturer = pref.rlimb_data[F.required_organ]
			pref.f_style = random_facial_hair_style(pref.gender, user_species.type, organ_status, robolimb_manufacturer)
