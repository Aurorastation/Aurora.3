/datum/vueui_module/appearance_changer
	var/name = "Appearance Changer"
	var/flags = APPEARANCE_ALL_HAIR

	var/datum/topic_state/ui_state
	var/datum/state_object

	var/datum/weakref/target_human
	var/list/valid_species = list()
	var/list/valid_genders = list()
	var/list/valid_pronouns = list()
	var/list/valid_hairstyles = list()
	var/list/valid_facial_hairstyles = list()
	var/list/valid_accents = list()
	var/list/valid_languages = list()

	var/check_whitelist
	var/list/whitelist
	var/list/blacklist

/datum/vueui_module/appearance_changer/New(var/mob/living/carbon/human/H, var/check_species_whitelist = 1, var/list/species_whitelist = list(), var/list/species_blacklist = list(), var/datum/topic_state/set_ui_state = interactive_state, var/datum/set_state_object = null)
	..()
	ui_state = set_ui_state
	state_object = set_state_object
	target_human = WEAKREF(H)
	src.check_whitelist = check_species_whitelist
	src.whitelist = species_whitelist
	src.blacklist = species_blacklist
	generate_data(check_whitelist, whitelist, blacklist)

/datum/vueui_module/appearance_changer/Topic(ref, href_list, var/datum/topic_state/state = ui_state)
	if(..())
		return 1

	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE

	if(href_list["race"])
		if(can_change(APPEARANCE_RACE) && (href_list["race"] in valid_species))
			if(owner.change_species(href_list["race"]))
				clear_and_generate_data()
				return 1
	if(href_list["gender"])
		if(can_change(APPEARANCE_GENDER))
			if(owner.change_gender(href_list["gender"]))
				clear_and_generate_data()
				return 1
	if(href_list["pronouns"])
		if(can_change(APPEARANCE_GENDER))
			owner.pronouns = href_list["pronouns"]
			clear_and_generate_data()
			return 1
	if(href_list["skin_tone"])
		if(can_change_skin_tone())
			var/new_s_tone = input(usr, "Choose your character's skin-tone:\n(Light 30 - 220 Dark)", "Skin Tone", -owner.s_tone + 35) as num|null
			if(isnum(new_s_tone))
				new_s_tone = 35 - max(min( round(new_s_tone), 220),30)
				return owner.change_skin_tone(new_s_tone)
	if(href_list["skin_color"])
		if(can_change_skin_color())
			var/new_skin = input(usr, "Choose your character's skin colour: ", "Skin Color", rgb(owner.r_skin, owner.g_skin, owner.b_skin)) as color|null
			if(new_skin)
				var/r_skin = hex2num(copytext(new_skin, 2, 4))
				var/g_skin = hex2num(copytext(new_skin, 4, 6))
				var/b_skin = hex2num(copytext(new_skin, 6, 8))
				if(owner.change_skin_color(r_skin, g_skin, b_skin))
					update_dna()
					return 1
	if(href_list["skin_preset"])
		if(can_change_skin_preset())
			var/new_preset = input(usr, "Choose your character's body color preset:", "Character Preference", rgb(owner.r_skin, owner.g_skin, owner.b_skin)) as null|anything in owner.species.character_color_presets
			if(new_preset)
				new_preset = owner.species.character_color_presets[new_preset]
				var/r_skin = GetRedPart(new_preset)
				var/g_skin = GetGreenPart(new_preset)
				var/b_skin = GetBluePart(new_preset)
				if(owner.change_skin_color(r_skin, g_skin, b_skin))
					update_dna()
					return 1
	if(href_list["hair"])
		if(can_change(APPEARANCE_HAIR) && (href_list["hair"] in valid_hairstyles))
			if(owner.change_hair(href_list["hair"]))
				update_dna()
				return 1
	if(href_list["hair_color"])
		if(can_change(APPEARANCE_HAIR_COLOR))
			var/new_hair = input("Please select hair color.", "Hair Color", rgb(owner.r_hair, owner.g_hair, owner.b_hair)) as color|null
			if(new_hair)
				var/r_hair = hex2num(copytext(new_hair, 2, 4))
				var/g_hair = hex2num(copytext(new_hair, 4, 6))
				var/b_hair = hex2num(copytext(new_hair, 6, 8))
				if(owner.change_hair_color(r_hair, g_hair, b_hair))
					update_dna()
					return 1
	if(href_list["facial_hair"])
		if(can_change(APPEARANCE_FACIAL_HAIR) && (href_list["facial_hair"] in valid_facial_hairstyles))
			if(owner.change_facial_hair(href_list["facial_hair"]))
				update_dna()
				return 1
	if(href_list["facial_hair_color"])
		if(can_change(APPEARANCE_FACIAL_HAIR_COLOR))
			var/new_facial = input("Please select facial hair color.", "Facial Hair Color", rgb(owner.r_facial, owner.g_facial, owner.b_facial)) as color|null
			if(new_facial)
				var/r_facial = hex2num(copytext(new_facial, 2, 4))
				var/g_facial = hex2num(copytext(new_facial, 4, 6))
				var/b_facial = hex2num(copytext(new_facial, 6, 8))
				if(owner.change_facial_hair_color(r_facial, g_facial, b_facial))
					update_dna()
					return 1
	if(href_list["eye_color"])
		if(can_change(APPEARANCE_EYE_COLOR))
			var/new_eyes = input("Please select eye color.", "Eye Color", rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes)) as color|null
			if(new_eyes)
				var/r_eyes = hex2num(copytext(new_eyes, 2, 4))
				var/g_eyes = hex2num(copytext(new_eyes, 4, 6))
				var/b_eyes = hex2num(copytext(new_eyes, 6, 8))
				if(owner.change_eye_color(r_eyes, g_eyes, b_eyes))
					update_dna()
					return 1
	if(href_list["accent"])
		if(can_change(APPEARANCE_ACCENT) && (href_list["accent"] in valid_accents))
			if(owner.set_accent(href_list["accent"]))
				clear_and_generate_data()
			return 1
	if(href_list["language"])
		if(can_change(APPEARANCE_LANGUAGE) && (href_list["language"] in valid_languages))
			if(owner.add_or_remove_language(href_list["language"]))
				clear_and_generate_data()
			return 1

	return 0

/datum/vueui_module/appearance_changer/ui_interact(var/mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "misc-appearancechanger", 800, 450, name, state = ui_state, set_state_object = state_object)
	ui.open()

/datum/vueui_module/appearance_changer/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		data = list()

	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		to_chat(user, SPAN_WARNING("We couldn't find you, closing."))
		ui.close()
		return

	data["owner_species"] = owner.species.name
	data["change_race"] = can_change(APPEARANCE_RACE)
	data["valid_species"] = valid_species

	data["owner_gender"] = owner.gender
	data["owner_pronouns"] = owner.pronouns
	data["change_gender"] = can_change(APPEARANCE_GENDER)
	data["valid_gender"] = valid_genders
	data["valid_pronouns"] = valid_pronouns

	data["owner_accent"] = owner.accent
	data["change_accent"] = can_change(APPEARANCE_ACCENT)
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

/datum/vueui_module/appearance_changer/proc/update_dna()
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	if(owner && (flags & APPEARANCE_UPDATE_DNA))
		owner.update_dna()

/datum/vueui_module/appearance_changer/proc/can_change(var/flag)
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	return owner && (flags & flag)

/datum/vueui_module/appearance_changer/proc/can_change_skin_tone()
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	return owner && (flags & APPEARANCE_SKIN) && owner.species.appearance_flags & HAS_SKIN_TONE

/datum/vueui_module/appearance_changer/proc/can_change_skin_color()
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	return owner && (flags & APPEARANCE_SKIN) && owner.species.appearance_flags & HAS_SKIN_COLOR

/datum/vueui_module/appearance_changer/proc/can_change_skin_preset()
	var/mob/living/carbon/human/owner = target_human.resolve()
	if(!istype(owner))
		return FALSE
	return owner && (flags & APPEARANCE_SKIN) && owner.species.appearance_flags & HAS_SKIN_PRESET

/datum/vueui_module/appearance_changer/proc/clear_and_generate_data()
	// Making the assumption that the available species remain constant
	valid_genders = list()
	valid_pronouns = list()
	valid_hairstyles = list()
	valid_facial_hairstyles = list()
	valid_accents = list()
	valid_languages = list()
	generate_data()

/datum/vueui_module/appearance_changer/proc/generate_data()
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
	if(!length(valid_accents) && length(owner.species.allowed_accents))
		valid_accents = owner.species.allowed_accents.Copy()
	if(!length(valid_languages))
		valid_languages = owner.generate_valid_languages()