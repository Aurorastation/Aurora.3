var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

/datum/category_item/player_setup_item/general/body
	name = "Body"
	sort_order = 3

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
				log_debug("BODY MARKINGS: Caught [e]. Initial value: [before]")
				pref.body_markings = list()
		if (istext(pref.disabilities))
			var/before = pref.disabilities
			try
				pref.disabilities = json_decode(pref.disabilities)
			catch (var/exception/e)
				log_debug("DISABILITIES: Caught [e]. Initial value: [before]")
				pref.disabilities = list()

	var/datum/species/mob_species = all_species[pref.species]

	pref.r_hair   = sanitize_integer(pref.r_hair, 0, 255, initial(pref.r_hair))
	pref.g_hair   = sanitize_integer(pref.g_hair, 0, 255, initial(pref.g_hair))
	pref.b_hair   = sanitize_integer(pref.b_hair, 0, 255, initial(pref.b_hair))
	pref.r_facial = sanitize_integer(pref.r_facial, 0, 255, initial(pref.r_facial))
	pref.g_facial = sanitize_integer(pref.g_facial, 0, 255, initial(pref.g_facial))
	pref.b_facial = sanitize_integer(pref.b_facial, 0, 255, initial(pref.b_facial))
	pref.s_tone   = sanitize_integer(pref.s_tone, -185, 5, initial(pref.s_tone))
	pref.r_skin   = sanitize_integer(pref.r_skin, 0, 255, initial(pref.r_skin))
	pref.g_skin   = sanitize_integer(pref.g_skin, 0, 255, initial(pref.g_skin))
	pref.b_skin   = sanitize_integer(pref.b_skin, 0, 255, initial(pref.b_skin))
	pref.tail_style = sanitize_inlist(pref.tail_style, mob_species.selectable_tails, mob_species.tail)
	pref.h_style  = sanitize_inlist(pref.h_style, hair_styles_list, initial(pref.h_style))
	pref.f_style  = sanitize_inlist(pref.f_style, facial_hair_styles_list, initial(pref.f_style))
	pref.g_style = sanitize_inlist(pref.g_style, hair_gradient_styles_list, initial(pref.g_style))
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

	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "000"

/datum/category_item/player_setup_item/general/body/content(var/mob/user)
	var/list/out = list()

	var/datum/species/mob_species = all_species[pref.species]
	out += "<table><tr style='vertical-align:top'><td><b>Body</b> "
	out += "(<a href='?src=\ref[src];random=1'>&reg;</A>)"
	out += "<br>"
	out += "Species: <a href='?src=\ref[src];show_species=1'>[pref.species]</a><br>"
	out += "Blood Type: <a href='?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"
	if(has_flag(mob_species, HAS_SKIN_TONE))
		out += "Skin Tone: <a href='?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/220</a><br>"
	out += "Disabilities: <a href='?src=\ref[src];trait_add=1'>Adjust</a><br>"
	for(var/M in pref.disabilities)
		out += "     [M] <a href='?src=\ref[src];trait_remove=[M]'>-</a><br>"
	out += "Limbs: <a href='?src=\ref[src];limbs=1'>Adjust</a><br>"
	if(length(mob_species.alterable_internal_organs))
		out += "Internal Organs: <a href='?src=\ref[src];organs=1'>Adjust</a><br>"
	out += "Prosthesis/Amputations: <a href='?src=\ref[src];reset_organs=1'>Reset</a><br>"

	//display limbs below
	var/ind = 0
	for(var/name in pref.organ_data)
		var/status = pref.organ_data[name]
		var/organ_name = name

		if(status == "cyborg")
			++ind
			if(ind > 1)
				out += ", "
			var/datum/robolimb/R
			if(pref.rlimb_data[name] && all_robolimbs[pref.rlimb_data[name]])
				R = all_robolimbs[pref.rlimb_data[name]]
			else
				R = basic_robolimb
			out += "\t[R.company] [organ_name] prosthesis"
		else if(status == "amputated")
			++ind
			if(ind > 1)
				out += ", "
			out += "\tAmputated [organ_name]"
		else if(status == "mechanical")
			++ind
			if(ind > 1)
				out += ", "
			var/datum/robolimb/R
			if(pref.rlimb_data[name] && all_robolimbs[pref.rlimb_data[name]])
				R = all_robolimbs[pref.rlimb_data[name]]
			else
				R = basic_robolimb
			out += "\t[R.company] Mechanical [organ_name]"
		else if(status == "nymph")
			++ind
			if(ind > 1)
				out += ", "
			out += "\tDiona Nymph [organ_name]"
		else if(status == "assisted")
			++ind
			if(ind > 1)
				out += ", "
			switch(organ_name)
				if(BP_HEART)
					out += "\tPacemaker-assisted [organ_name]"
				if("voicebox") //on adding voiceboxes for speaking skrell/similar replacements
					out += "\tSurgically altered [organ_name]"
				if(BP_EYES)
					out += "\tRetinal overlayed [organ_name]"
				else
					out += "\tMechanically assisted [organ_name]"
		else if(status == "removed")
			++ind
			if(ind > 1)
				out += ", "
			out += "\tRemoved [organ_name]"
	if(!ind)
		out += "\[...\]<br><br>"
	else
		out += "<br><br>"

	out += "</td><td><b>Preview</b>"
	out += "<br><a href='?src=\ref[src];cycle_bg=1'>Cycle background</a>"
	out += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a>"
	out += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"
	out += "</td></tr></table>"

	var/tail_spacing = FALSE
	if(length(mob_species.selectable_tails))
		out += "<b>Tail</b><br>"
		out += "<a href='?src=\ref[src];tail_style=1'>[pref.tail_style ? "Style: [pref.tail_style]" : "Style: None"]</a><br>"
		tail_spacing = TRUE

	out += "[tail_spacing ? "<br>" : ""]<b>Hair</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		out += "<a href='?src=\ref[src];hair_color=1'>Change Color</a> [HTML_RECT(rgb(pref.r_hair, pref.g_hair, pref.b_hair))] "
	out += " Style: <a href='?src=\ref[src];hair_style=1'>[pref.h_style]</a><br>"

	out += "<br><b>Facial</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		out += "<a href='?src=\ref[src];facial_color=1'>Change Color</a> [HTML_RECT(rgb(pref.r_facial, pref.g_facial, pref.b_facial))] "
	out += " Style: <a href='?src=\ref[src];facial_style=1'>[pref.f_style]</a><br>"

	out += "<br><b>Gradient</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		out += "<a href='?src=\ref[src];gradient_color=1'>Change Color</a> [HTML_RECT(rgb(pref.r_grad, pref.g_grad, pref.b_grad))] "
	out += " Style: <a href='?src=\ref[src];gradient_style=1'>[pref.g_style]</a><br>"

	if(has_flag(mob_species, HAS_EYE_COLOR))
		out += "<br><b>Eyes</b><br>"
		out += "<a href='?src=\ref[src];eye_color=1'>Change Color</a> [HTML_RECT(rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes))] <br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR) || has_flag(mob_species, HAS_SKIN_PRESET))
		if(has_flag(mob_species, HAS_SKIN_PRESET))
			out += "<br><b>Body Color Presets</b><br>"
			out += "<a href='?src=\ref[src];skin_color=1'>Choose Preset</a><br>"
		else
			out += "<br><b>Body Color</b><br>"
			out += "<a href='?src=\ref[src];skin_color=1'>Change Color</a> [HTML_RECT(rgb(pref.r_skin, pref.g_skin, pref.b_skin))] <br>"



	out += "<br><a href='?src=\ref[src];marking_style=1'>Body Markings +</a><br>"
	for(var/M in pref.body_markings)
		out += "[M] [pref.body_markings.len > 1 ? "<a href='?src=\ref[src];marking_up=[M]'>&#708;</a> <a href='?src=\ref[src];marking_down=[M]'>&#709;</a> " : ""]<a href='?src=\ref[src];marking_remove=[M]'>-</a> <a href='?src=\ref[src];marking_color=[M]'>Color</a>"
		out += HTML_RECT(pref.body_markings[M])
		out += "<br>"

	. = out.Join()

/datum/category_item/player_setup_item/general/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/general/body/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/mob_species = all_species[pref.species]

	if(href_list["random"])
		pref.randomize_appearance_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_type"])
		var/new_b_type = input(user, "Choose your character's blood-type:", "Character Preference") as null|anything in valid_bloodtypes
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return TOPIC_REFRESH

	else if(href_list["show_species"])
		// Actual whitelist checks are handled elsewhere, this is just for accessing the preview window.
		var/species_choice = input(usr, "Which species would you like to look at?", "Species Selection") as null|anything in playable_species
		if(!species_choice)
			return
		var/choice
		if(length(playable_species[species_choice]) == 1)
			choice = playable_species[species_choice][1]
		else
			choice = input(usr, "Which subspecies would you like to look at?", "Sub-species Selection") as null|anything in playable_species[species_choice]
			if(!choice)
				return
		choice = html_decode(choice)
		pref.species_preview = choice
		SetSpecies(preference_mob())
		pref.alternate_languages.Cut() // Reset their alternate languages. Todo: attempt to just fix it instead?
		return TOPIC_HANDLED

	else if(href_list["set_species"])
		user << browse(null, "window=species")
		if(!pref.species_preview || !(pref.species_preview in all_species))
			return TOPIC_NOACTION

		var/prev_species = pref.species
		pref.species = html_decode(href_list["set_species"])
		if(prev_species != pref.species)
			mob_species = all_species[pref.species]

			pref.gender = sanitize_gender(pref.gender, pref.species)
			//var/bodytype = mob_species.get_bodytype()

			//grab one of the valid hair styles for the newly chosen species
			var/list/valid_hairstyles = list()

			// Snowflake check for industrials - they're an IPC bodytype but don't have IPC screens.
			for(var/hairstyle in hair_styles_list)
				var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
				if(pref.gender == MALE && S.gender == FEMALE)
					continue
				if(pref.gender == FEMALE && S.gender == MALE)
					continue
				if(!(mob_species.type in S.species_allowed))
					continue
				valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

			if(valid_hairstyles.len)
				pref.h_style = pick(valid_hairstyles)
			else	// Species has no hair, or something fucked up.
				pref.h_style = hair_styles_list["Bald"]

			if(length(mob_species.selectable_tails))
				pref.tail_style = pick(mob_species.selectable_tails)
			else
				pref.tail_style = null

			//grab one of the valid facial hair styles for the newly chosen species
			var/list/valid_facialhairstyles = list()
			for(var/facialhairstyle in facial_hair_styles_list)
				var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
				if(pref.gender == MALE && S.gender == FEMALE)
					continue
				if(pref.gender == FEMALE && S.gender == MALE)
					continue
				if(!(mob_species.type in S.species_allowed))
					continue

				valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

			if(valid_facialhairstyles.len)
				pref.f_style = pick(valid_facialhairstyles)
			else
				//this shouldn't happen
				pref.f_style = facial_hair_styles_list["Shaved"]

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

			// Follows roughly the same way hair does above, but for gradient styles
			var/global/list/valid_gradients = list()

			if(!valid_gradients[mob_species.type])
				valid_gradients[mob_species.type] = list()
				for(var/gradient in hair_gradient_styles_list)
					var/datum/sprite_accessory/S = hair_gradient_styles_list[gradient]
					if(mob_species.type in S.species_allowed)
						valid_gradients[mob_species.type] += gradient

			if(!(pref.g_style in valid_gradients[mob_species.type]))
				pref.g_style = hair_gradient_styles_list["None"]

			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", rgb(pref.r_hair, pref.g_hair, pref.b_hair)) as color|null
		if(new_hair && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_hair = GetRedPart(new_hair)
			pref.g_hair = GetGreenPart(new_hair)
			pref.b_hair = GetBluePart(new_hair)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["gradient_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_grad = input(user, "Choose your character's secondary hair color:", "Character Preference", rgb(pref.r_grad, pref.g_grad, pref.b_grad)) as color|null
		if(new_grad && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_grad = GetRedPart(new_grad)
			pref.g_grad = GetGreenPart(new_grad)
			pref.b_grad = GetBluePart(new_grad)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["tail_style"])
		if(!length(mob_species.selectable_tails))
			return
		var/new_tail_style = input(user, "Choose your character's tail style:", "Character Preference", pref.tail_style) as null|anything in mob_species.selectable_tails
		if(new_tail_style && CanUseTopic(user))
			pref.tail_style = new_tail_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		if(mob_species.bald)
			return
		//var/bodytype = mob_species.get_bodytype()
		var/list/valid_hairstyles = list()
		for(var/hairstyle in hair_styles_list)
			var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
			if(pref.gender == MALE && S.gender == FEMALE)
				continue
			if(pref.gender == FEMALE && S.gender == MALE)
				continue
			if(!(mob_species.type in S.species_allowed))
				continue

			valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

		var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference", pref.h_style)  as null|anything in valid_hairstyles
		if(new_h_style && CanUseTopic(user))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["gradient_style"])
		var/list/valid_gradients = list()
		for(var/gradstyle in hair_gradient_styles_list)
			var/datum/sprite_accessory/S = hair_gradient_styles_list[gradstyle]
			if(!(mob_species.type in S.species_allowed))
				continue

			valid_gradients[gradstyle] = hair_gradient_styles_list[gradstyle]

		var/new_g_style = input(user, "Choose a color pattern for your hair:", "Character Preference", pref.g_style)  as null|anything in valid_gradients
		if(new_g_style && CanUseTopic(user))
			pref.g_style = new_g_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", rgb(pref.r_facial, pref.g_facial, pref.b_facial)) as color|null
		if(new_facial && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_facial = GetRedPart(new_facial)
			pref.g_facial = GetGreenPart(new_facial)
			pref.b_facial = GetBluePart(new_facial)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes)) as color|null
		if(new_eyes && has_flag(mob_species, HAS_EYE_COLOR) && CanUseTopic(user))
			pref.r_eyes = GetRedPart(new_eyes)
			pref.g_eyes = GetGreenPart(new_eyes)
			pref.b_eyes = GetBluePart(new_eyes)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_SKIN_TONE))
			return TOPIC_NOACTION
		var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 30 - 220 Dark)", "Character Preference", (-pref.s_tone) + 35)  as num|null
		if(new_s_tone && has_flag(mob_species, HAS_SKIN_TONE) && CanUseTopic(user))
			pref.s_tone = 35 - max(min( round(new_s_tone), 220),30)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR) && !has_flag(mob_species, HAS_SKIN_PRESET))
			return TOPIC_NOACTION
		if(has_flag(mob_species, HAS_SKIN_COLOR) && !has_flag(mob_species, HAS_SKIN_PRESET))
			var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference", rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as color|null
			if(new_skin && has_flag(mob_species, HAS_SKIN_COLOR) && CanUseTopic(user))
				pref.r_skin = GetRedPart(new_skin)
				pref.g_skin = GetGreenPart(new_skin)
				pref.b_skin = GetBluePart(new_skin)
			return TOPIC_REFRESH_UPDATE_PREVIEW

		else if(has_flag(mob_species, HAS_SKIN_PRESET))
			var/new_preset = input(user, "Choose your character's body color preset:", "Character Preference", rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as null|anything in mob_species.character_color_presets
			new_preset = mob_species.character_color_presets[new_preset]
			pref.r_skin = GetRedPart(new_preset)
			pref.g_skin = GetGreenPart(new_preset)
			pref.b_skin = GetBluePart(new_preset)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])
		if(mob_species.bald)
			return
		var/list/valid_facialhairstyles = list()
		//var/bodytype = mob_species.get_bodytype()
		for(var/facialhairstyle in facial_hair_styles_list)
			var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
			if(pref.gender == MALE && S.gender == FEMALE)
				continue
			if(pref.gender == FEMALE && S.gender == MALE)
				continue
			if(!(mob_species.type in S.species_allowed))
				continue

			valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

		var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference", pref.f_style)  as null|anything in valid_facialhairstyles
		if(new_f_style && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/usable_markings = pref.body_markings ^ body_marking_styles_list
		var/datum/species/species = global.all_species[pref.species]
		for(var/M in usable_markings)
			var/datum/sprite_accessory/S = usable_markings[M]
			if(!S.species_allowed.len)
				continue
			else if(!(species.type in S.species_allowed))
				usable_markings -= M

		if (!usable_markings.len)
			alert(user, "This species does not have any body markings available.")
			return TOPIC_NOACTION

		var/new_marking = input(user, "Choose a body marking:", "Character Preference")  as null|anything in usable_markings
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

	else if(href_list["limbs"])
		var/list/acceptable_organ_input = list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand")
		var/limb_name = input(user, "Which limb do you want to change?") as null|anything in acceptable_organ_input
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
			if(BP_HEAD)
				limb = BP_HEAD
				carries_organs = 1
			else
				to_chat(user, "<span class='notice'>Cancelled.</span>")
				return TOPIC_NOACTION

		var/list/available_states = mob_species.possible_external_organs_modifications
		if(carries_organs)
			available_states = list("Normal","Prosthesis")
		var/new_state = input(user, "What state do you wish the limb to be in?") as null|anything in available_states
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
				pref.organ_data[limb] = "amputated"
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = "amputated"
					pref.rlimb_data[second_limb] = null

			if("Prosthesis")
				var/tmp_species = pref.species ? pref.species : SPECIES_HUMAN
				var/list/usable_manufacturers = list()
				for(var/company in chargen_robolimbs)
					var/datum/robolimb/M = chargen_robolimbs[company]
					if(!(tmp_species in M.species_can_use))
						continue
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = input(user, "Which manufacturer do you wish to use for this limb?") as null|anything in usable_manufacturers
				if(!choice)
					return
				pref.rlimb_data[limb] = choice
				pref.organ_data[limb] = "cyborg"
				if(second_limb)
					pref.rlimb_data[second_limb] = choice
					pref.organ_data[second_limb] = "cyborg"
				if(third_limb && pref.organ_data[third_limb] == "amputated")
					pref.organ_data[third_limb] = null

			if("Diona Nymph")
				pref.organ_data[limb] = "nymph"
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = "nymph"
					pref.rlimb_data[second_limb] = null

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["organs"])
		if(!mob_species.alterable_internal_organs.len)
			return
		var/organ_name = input(user, "Which internal function do you want to change?") as null|anything in mob_species.alterable_internal_organs
		if(!organ_name)
			return

		var/organ_type = mob_species.has_organ[organ_name]
		var/obj/item/organ/internal/altered_organ = new organ_type(null)

		if(!altered_organ)
			return

		var/new_state = input(user, "What state do you wish the organ to be in?") as null|anything in altered_organ.possible_modifications

		qdel(altered_organ)

		if(!new_state) return

		switch(new_state)
			if("Normal")
				pref.organ_data[organ_name] = null
			if("Assisted")
				pref.organ_data[organ_name] = "assisted"
			if("Mechanical")

				var/tmp_species = pref.species ? pref.species : SPECIES_HUMAN
				var/list/usable_manufacturers = list()
				for(var/company in internal_robolimbs)
					var/datum/robolimb/M = chargen_robolimbs[company]
					if(!(tmp_species in M.species_can_use))
						continue
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = input(user, "Which manufacturer do you wish to use for this organ?") as null|anything in usable_manufacturers
				if(!choice)
					return


				var/datum/robolimb/R = all_robolimbs[choice]
				if(!(organ_name in R.allowed_internal_organs))
					alert(user, "You can not select this manufacturer for this organ.")
					return
				pref.rlimb_data[organ_name] = choice
				pref.organ_data[organ_name] = "mechanical"

			if("Removed")
				pref.organ_data[organ_name] = "removed"

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["reset_organs"])
		pref.organ_data.Cut()
		pref.rlimb_data.Cut()

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["trait_add"])
		var/list/available_disabilities = pref.disabilities ^ chargen_disabilities_list

		var/new_trait = input(user, "Choose a disability:", "Character Preference")  as null|anything in available_disabilities
		if(new_trait && CanUseTopic(user))
			pref.disabilities += new_trait
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["trait_remove"])
		var/M = href_list["trait_remove"]
		pref.disabilities -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cycle_bg"])
		pref.bgstate = next_in_list(pref.bgstate, pref.bgstate_options)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_preview_value"])
		pref.equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
		return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/general/body/proc/SetSpecies(mob/user)
	if(!pref.species_preview || !(pref.species_preview in all_species))
		pref.species_preview = SPECIES_HUMAN
	var/datum/species/current_species = all_species[pref.species_preview]
	var/list/dat = list(
		"<center><h2>[current_species.name] \[<a href='?src=\ref[src];show_species=1'>change</a>\]</h2></center><hr/>",
		"<table padding='8px'>",
		"<tr>",
		"<td width = 400>[current_species.blurb]</td>",
		"<td width = 200 align='center'>"
	)
	if(current_species.preview_icon)
		var/icon/preview = icon(current_species.preview_icon, "")
		preview.Scale(64, 64)	// Scale it here to stop it blurring.
		send_rsc(usr, icon(icon = preview, icon_state = ""), "species_preview_[current_species.short_name].png")
		dat += "<img src='species_preview_[current_species.short_name].png' width='64px' height='64px'><br/><br/>"
	dat += "<b>Language:</b> [current_species.language]<br/>"
	dat += "<small>"
	if(current_species.spawn_flags & CAN_JOIN)
		dat += "</br><b>Often present on human stations.</b>"
	if(current_species.spawn_flags & IS_WHITELISTED)
		dat += "</br><b>Whitelist restricted.</b>"
	if(current_species.flags & NO_BLOOD)
		dat += "</br><b>Does not have blood.</b>"
	if(current_species.flags & NO_BREATHE)
		dat += "</br><b>Does not breathe.</b>"
	if(current_species.flags & NO_SCAN)
		dat += "</br><b>Does not have DNA.</b>"
	if(current_species.flags & NO_PAIN)
		dat += "</br><b>Does not feel pain.</b>"
	if(current_species.flags & NO_SLIP)
		dat += "</br><b>Has excellent traction.</b>"
	if(current_species.flags & NO_POISON)
		dat += "</br><b>Immune to most poisons.</b>"
	if(current_species.appearance_flags & HAS_SKIN_TONE)
		dat += "</br><b>Has a variety of skin tones.</b>"
	if(current_species.appearance_flags & HAS_SKIN_COLOR)
		dat += "</br><b>Has a variety of skin colours.</b>"
	if(current_species.appearance_flags & HAS_EYE_COLOR)
		dat += "</br><b>Has a variety of eye colours.</b>"
	if(current_species.flags & IS_PLANT)
		dat += "</br><b>Has a plantlike physiology.</b>"
	dat += "</small></td>"
	dat += "</tr>"
	dat += "</table><center><hr/>"

	var/restricted = 0
	if(config.usealienwhitelist) //If we're using the whitelist, make sure to check it!
		if(!(current_species.spawn_flags & CAN_JOIN))
			restricted = 2
		else if((current_species.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(preference_mob(),current_species.name))
			restricted = 1

	if(restricted)
		if(restricted == 1)
			dat += "<span class='warning'><b>You cannot play as this species.</br><small>If you wish to be whitelisted, you can make an application post on <a href='?src=\ref[user];preference=open_whitelist_forum'>the forums</a>.</small></b></span></br>"
		else if(restricted == 2)
			dat += "<span class='warning'><b>You cannot play as this species.</br><small>This species is not available for play as a station race.</small></b></span></br>"
	if(!restricted || check_rights(R_ADMIN, 0))
		dat += "\[<a href='?src=\ref[src];set_species=[html_encode(pref.species_preview)]'>select</a>\]"
	dat += "</center>"

	send_theme_resources(user)
	user << browse(enable_ui_theme(user, dat.Join()), "window=species;size=700x400")

/*/datum/category_item/player_setup_item/general/body/proc/reset_limbs()

	for(var/organ in pref.organ_data)
		pref.organ_data[organ] = null
	while(null in pref.organ_data)
		pref.organ_data -= null

	for(var/organ in pref.rlimb_data)
		pref.rlimb_data[organ] = null
	while(null in pref.rlimb_data)
		pref.rlimb_data -= null*/
