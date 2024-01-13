/datum/tgui_module/appearance_changer
	var/name = "Appearance Changer"
	var/flags = APPEARANCE_ALL_HAIR

	var/datum/ui_state/ui_state
	var/datum/state_object

	var/datum/weakref/target_human
	var/datum/weakref/target_id //Mostly for ghostroles and plastic surgery machines. If there is an ID, update it when we close the UI to ensure the correct info is imprinted.
	var/change_id = FALSE //Prevents runtimes if target_id is null
	var/list/valid_species = list()
	var/list/valid_genders = list()
	var/list/valid_pronouns = list()
	var/list/valid_hairstyles = list()
	var/list/valid_facial_hairstyles = list()
	var/list/valid_cultures = list()
	var/list/valid_origins = list()
	var/list/valid_citizenships = list()
	var/list/valid_accents = list()
	var/list/valid_languages = list()

	var/check_whitelist
	var/list/whitelist
	var/list/blacklist

	var/list/culture_map = list()
	var/list/origin_map = list()
	var/list/culture_restrictions = list()
	var/list/origin_restrictions = list()

/datum/tgui_module/appearance_changer/New(var/mob/living/carbon/human/H, var/check_species_whitelist = 1, var/list/species_whitelist = list(), var/list/species_blacklist = list(), var/list/culture_restriction = list(), var/list/origin_restriction = list(), var/datum/ui_state/set_ui_state = always_state, var/datum/set_state_object = null, var/update_id)
	..()
	ui_state = set_ui_state
	state_object = set_state_object
	target_human = WEAKREF(H)
	if(istype(H) && update_id)
		var/obj/item/card/id/idcard = H.GetIdCard()
		if(idcard)
			target_id = WEAKREF(idcard)
			change_id = TRUE
	src.check_whitelist = check_species_whitelist
	src.whitelist = species_whitelist
	src.blacklist = species_blacklist
	culture_restrictions = culture_restriction
	origin_restrictions = culture_restriction
	generate_data(check_whitelist, whitelist, blacklist)

/datum/tgui_module/appearance_changer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE

	switch(action)
		if("race")
			if(can_change(APPEARANCE_RACE) && (params["race"] in valid_species))
				if(owner.change_species(params["race"]))
					clear_and_generate_data()
					. = TRUE
		if("gender")
			if(can_change(APPEARANCE_GENDER))
				if(owner.change_gender(params["gender"]))
					clear_and_generate_data()
					. = TRUE
		if("pronouns")
			if(can_change(APPEARANCE_GENDER))
				owner.pronouns = params["pronouns"]
				clear_and_generate_data()
				. = TRUE
		if("skin_tone")
			if(can_change_skin_tone())
				var/new_s_tone = input(usr, "Choose your character's skin-tone:\n(Light 30 - 220 Dark)", "Skin Tone", -owner.s_tone + 35) as num|null
				if(isnum(new_s_tone))
					new_s_tone = 35 - max(min( round(new_s_tone), 220),30)
					. = owner.change_skin_tone(new_s_tone)
		if("skin_color")
			if(can_change_skin_color())
				var/new_skin = input(usr, "Choose your character's skin colour: ", "Skin Color", rgb(owner.r_skin, owner.g_skin, owner.b_skin)) as color|null
				if(new_skin)
					var/r_skin = hex2num(copytext(new_skin, 2, 4))
					var/g_skin = hex2num(copytext(new_skin, 4, 6))
					var/b_skin = hex2num(copytext(new_skin, 6, 8))
					if(owner.change_skin_color(r_skin, g_skin, b_skin))
						update_dna()
						. = TRUE
		if("skin_preset")
			if(can_change_skin_preset())
				var/new_preset = input(usr, "Choose your character's body color preset:", "Character Preference", rgb(owner.r_skin, owner.g_skin, owner.b_skin)) as null|anything in owner.species.character_color_presets
				if(new_preset)
					new_preset = owner.species.character_color_presets[new_preset]
					var/r_skin = GetRedPart(new_preset)
					var/g_skin = GetGreenPart(new_preset)
					var/b_skin = GetBluePart(new_preset)
					if(owner.change_skin_color(r_skin, g_skin, b_skin))
						update_dna()
						. = TRUE
		if("hair")
			if(can_change(APPEARANCE_HAIR) && (params["hair"] in valid_hairstyles))
				if(owner.change_hair(params["hair"]))
					update_dna()
					. = TRUE
		if("hair_color")
			if(can_change(APPEARANCE_HAIR_COLOR))
				var/new_hair = input("Please select hair color.", "Hair Color", rgb(owner.r_hair, owner.g_hair, owner.b_hair)) as color|null
				if(new_hair)
					var/r_hair = hex2num(copytext(new_hair, 2, 4))
					var/g_hair = hex2num(copytext(new_hair, 4, 6))
					var/b_hair = hex2num(copytext(new_hair, 6, 8))
					if(owner.change_hair_color(r_hair, g_hair, b_hair))
						update_dna()
						. = TRUE
		if("facial_hair")
			if(can_change(APPEARANCE_FACIAL_HAIR) && (params["facial_hair"] in valid_facial_hairstyles))
				if(owner.change_facial_hair(params["facial_hair"]))
					update_dna()
					. = TRUE
		if("facial_hair_color")
			if(can_change(APPEARANCE_FACIAL_HAIR_COLOR))
				var/new_facial = input("Please select facial hair color.", "Facial Hair Color", rgb(owner.r_facial, owner.g_facial, owner.b_facial)) as color|null
				if(new_facial)
					var/r_facial = hex2num(copytext(new_facial, 2, 4))
					var/g_facial = hex2num(copytext(new_facial, 4, 6))
					var/b_facial = hex2num(copytext(new_facial, 6, 8))
					if(owner.change_facial_hair_color(r_facial, g_facial, b_facial))
						update_dna()
						. = TRUE
		if("eye_color")
			if(can_change(APPEARANCE_EYE_COLOR))
				var/new_eyes = input("Please select eye color.", "Eye Color", rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes)) as color|null
				if(new_eyes)
					var/r_eyes = hex2num(copytext(new_eyes, 2, 4))
					var/g_eyes = hex2num(copytext(new_eyes, 4, 6))
					var/b_eyes = hex2num(copytext(new_eyes, 6, 8))
					if(owner.change_eye_color(r_eyes, g_eyes, b_eyes))
						update_dna()
						. = TRUE
		if("culture")
			if(can_change(APPEARANCE_CULTURE))
				var/new_culture_id = params["culture"]
				if(new_culture_id in valid_cultures)
					var/singleton/origin_item/culture/new_culture = culture_map[new_culture_id]
					owner.set_culture(new_culture)
					if(!(owner.origin in new_culture.possible_origins))
						owner.set_origin(GET_SINGLETON(pick(new_culture.possible_origins)))
					clear_and_generate_data()
				. = TRUE
		if("origin")
			if(can_change(APPEARANCE_CULTURE))
				var/new_origin_id = params["origin"]
				if(new_origin_id in valid_origins)
					var/singleton/origin_item/origin/new_origin = origin_map[new_origin_id]
					owner.set_origin(new_origin)
					if(!(owner.accent in new_origin.possible_accents))
						owner.accent = new_origin.possible_accents[1]
					if(!(owner.religion in new_origin.possible_religions))
						owner.religion = new_origin.possible_religions[1]
					if(!(owner.citizenship in new_origin.possible_religions))
						owner.citizenship = new_origin.possible_citizenships[1]
					clear_and_generate_data()
				. = TRUE
		if("citizenship")
			if(can_change(APPEARANCE_CULTURE))
				var/new_citizenship = params["citizenship"]
				if(new_citizenship in valid_citizenships)
					owner.citizenship = new_citizenship
					clear_and_generate_data()
				. = TRUE
		if("accent")
			if(can_change(APPEARANCE_CULTURE))
				if(owner.set_accent(params["accent"]))
					clear_and_generate_data()
				. = TRUE
		if("language")
			if(can_change(APPEARANCE_LANGUAGE) && (params["language"] in valid_languages))
				if(owner.add_or_remove_language(params["language"]))
					clear_and_generate_data()
				. = TRUE
		if("speech_bubble")
			if(can_change(APPEARANCE_RACE) && (params["speech_bubble"] in owner.species.possible_speech_bubble_types))
				owner.speech_bubble_type = params["speech_bubble"]
				. = TRUE
		if("set_height")
			owner.height = clamp(params["height"], owner.species.height_min, owner.species.height_max)

/datum/tgui_module/appearance_changer/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AppearanceChanger", "Appearance Changer", 800, 450)
		ui.open()

/datum/tgui_module/appearance_changer/ui_data(mob/user)
	var/list/data = list()

	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		to_chat(user, SPAN_WARNING("We couldn't find you, closing."))
		SStgui.close_uis(src)
		return

	data["owner_species"] = owner.species.name
	data["change_race"] = can_change(APPEARANCE_RACE)
	data["valid_species"] = valid_species
	data["valid_speech_bubbles"] = owner.species.possible_speech_bubble_types
	data["owner_speech_bubble"] = owner.speech_bubble_type
	data["height_max"] = owner.species.height_max
	data["height_min"] = owner.species.height_min
	data["owner_height"] = owner.height

	data["owner_gender"] = owner.gender
	data["owner_pronouns"] = owner.pronouns
	data["change_gender"] = can_change(APPEARANCE_GENDER)
	data["valid_genders"] = valid_genders
	data["valid_pronouns"] = valid_pronouns

	data["change_culture"] = can_change(APPEARANCE_CULTURE)
	data["owner_culture"] = owner.culture.name
	data["valid_cultures"] = valid_cultures
	data["owner_origin"] = owner.origin.name
	data["valid_origins"] = valid_origins
	data["owner_citizenship"] = owner.citizenship
	data["valid_citizenships"] = valid_citizenships
	data["owner_accent"] = owner.accent
	data["valid_accents"] = valid_accents

	var/list/owner_languages = list()
	for(var/datum/language/L in owner.languages)
		owner_languages += L.name
	data["owner_languages"] = owner_languages
	data["change_language"] = can_change(APPEARANCE_LANGUAGE)
	data["valid_languages"] = valid_languages

	data["change_skin_tone"] = can_change_skin_tone()
	data["change_skin_color"] = can_change_skin_color()
	data["change_skin_preset"] = can_change_skin_preset()
	data["change_eye_color"] = can_change(APPEARANCE_EYE_COLOR)

	data["change_hair"] = can_change(APPEARANCE_HAIR)
	data["owner_hair_style"] = owner.h_style
	data["valid_hair_styles"] = valid_hairstyles

	data["change_facial_hair"] = can_change(APPEARANCE_FACIAL_HAIR)
	data["owner_facial_hair_style"] = owner.f_style
	data["valid_facial_hair_styles"] = valid_facial_hairstyles

	data["change_hair_color"] = can_change(APPEARANCE_HAIR_COLOR)
	data["change_facial_hair_color"] = can_change(APPEARANCE_FACIAL_HAIR_COLOR)

	return data

/datum/tgui_module/appearance_changer/ui_close(mob/user)
	. = ..()
	if(change_id)
		var/mob/living/carbon/human/owner = target_human.resolve()
		var/obj/item/card/id/I = target_id.resolve()
		if(!istype(I) || !(istype(owner)))
			return FALSE
		owner.set_id_info(I)

/datum/tgui_module/appearance_changer/proc/update_dna()
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	if(owner && (flags & APPEARANCE_UPDATE_DNA))
		owner.update_dna()

/datum/tgui_module/appearance_changer/proc/can_change(var/flag)
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	return owner && (flags & flag)

/datum/tgui_module/appearance_changer/proc/can_change_skin_tone()
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	return owner && (flags & APPEARANCE_SKIN) && owner.species.appearance_flags & HAS_SKIN_TONE

/datum/tgui_module/appearance_changer/proc/can_change_skin_color()
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	return owner && (flags & APPEARANCE_SKIN) && owner.species.appearance_flags & HAS_SKIN_COLOR

/datum/tgui_module/appearance_changer/proc/can_change_skin_preset()
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	return owner && (flags & APPEARANCE_SKIN) && owner.species.appearance_flags & HAS_SKIN_PRESET

/datum/tgui_module/appearance_changer/proc/clear_and_generate_data()
	// Making the assumption that the available species remain constant
	valid_genders = list()
	valid_pronouns = list()
	valid_hairstyles = list()
	valid_facial_hairstyles = list()
	valid_cultures = list()
	valid_origins = list()
	valid_citizenships = list()
	valid_accents = list()
	valid_languages = list()
	generate_data()

/datum/tgui_module/appearance_changer/proc/generate_data()
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	if(!length(valid_species))
		valid_species = owner.generate_valid_species(check_whitelist, whitelist, blacklist)
	if(!length(valid_genders) && length(owner.species.default_genders))
		valid_genders = owner.species.default_genders.Copy()
	if(!length(valid_pronouns) && length(owner.species.selectable_pronouns))
		valid_pronouns = owner.species.selectable_pronouns.Copy()
	if(!length(valid_hairstyles) || !length(valid_facial_hairstyles))
		valid_hairstyles = owner.generate_valid_hairstyles(check_gender = 1)
	if(!length(valid_facial_hairstyles))
		valid_facial_hairstyles = owner.generate_valid_facial_hairstyles()
	if(!length(valid_cultures))
		for(var/culture in owner.species.possible_cultures)
			var/singleton/origin_item/culture/CI = GET_SINGLETON(culture)
			if(length(culture_restrictions))
				if(!(CI.type in culture_restrictions))
					continue
			valid_cultures += CI.name
			culture_map[CI.name] = CI
		if(length(culture_restrictions))
			for(var/culture in culture_restrictions)
				var/singleton/origin_item/culture/CL = GET_SINGLETON(culture)
				for(var/origin in CL.possible_origins)
					var/singleton/origin_item/origin/OI = GET_SINGLETON(origin)
					valid_origins += OI.name
					origin_map[OI.name] = OI
		var/singleton/origin_item/culture/OC = owner.culture
		for(var/origin in OC.possible_origins)
			var/singleton/origin_item/origin/OI = GET_SINGLETON(origin)
			if(length(origin_restrictions))
				if(!(OI.type in origin_restrictions))
					continue
			valid_origins += OI.name
			origin_map[OI.name] = OI
		valid_citizenships = owner.origin.possible_citizenships
		valid_accents = owner.origin.possible_accents
	if(!length(valid_languages))
		valid_languages = owner.generate_valid_languages()
