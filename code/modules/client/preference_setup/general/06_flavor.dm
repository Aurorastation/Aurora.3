/datum/category_item/player_setup_item/general/flavor
	name = "Flavor"
	sort_order = 6

/datum/category_item/player_setup_item/general/flavor/load_character(var/savefile/S)
	S["flavor_texts_general"] >> pref.flavor_texts["general"]
	S["flavor_texts_head"]    >> pref.flavor_texts["head"]
	S["flavor_texts_face"]    >> pref.flavor_texts["face"]
	S["flavor_texts_eyes"]    >> pref.flavor_texts["eyes"]
	S["flavor_texts_torso"]   >> pref.flavor_texts["torso"]
	S["flavor_texts_arms"]    >> pref.flavor_texts["arms"]
	S["flavor_texts_hands"]   >> pref.flavor_texts["hands"]
	S["flavor_texts_legs"]    >> pref.flavor_texts["legs"]
	S["flavor_texts_feet"]    >> pref.flavor_texts["feet"]

	//Flavour text for robots.
	S["flavour_texts_robot_Default"] >> pref.flavour_texts_robot["Default"]
	for(var/module in GLOB.robot_module_types)
		S["flavour_texts_robot_[module]"] >> pref.flavour_texts_robot[module]

	S["signature"] >> pref.signature
	S["signfont"]  >> pref.signfont

/datum/category_item/player_setup_item/general/flavor/save_character(var/savefile/S)
	S["flavor_texts_general"] << pref.flavor_texts["general"]
	S["flavor_texts_head"]    << pref.flavor_texts["head"]
	S["flavor_texts_face"]    << pref.flavor_texts["face"]
	S["flavor_texts_eyes"]    << pref.flavor_texts["eyes"]
	S["flavor_texts_torso"]   << pref.flavor_texts["torso"]
	S["flavor_texts_arms"]    << pref.flavor_texts["arms"]
	S["flavor_texts_hands"]   << pref.flavor_texts["hands"]
	S["flavor_texts_legs"]    << pref.flavor_texts["legs"]
	S["flavor_texts_feet"]    << pref.flavor_texts["feet"]

	S["flavour_texts_robot_Default"] << pref.flavour_texts_robot["Default"]
	for(var/module in GLOB.robot_module_types)
		S["flavour_texts_robot_[module]"] << pref.flavour_texts_robot[module]

	S["signature"] << pref.signature
	S["signfont"]  << pref.signfont

/datum/category_item/player_setup_item/general/flavor/gather_load_query()
	var/list/var_list = list(
		"flavour_general" = "flavor_texts/general",
		"flavour_head" = "flavor_texts/head",
		"flavour_face" = "flavor_texts/face",
		"flavour_eyes" = "flavor_texts/eyes",
		"flavour_torso" = "flavor_texts/torso",
		"flavour_arms" = "flavor_texts/arms",
		"flavour_hands" = "flavor_texts/hands",
		"flavour_legs" = "flavor_texts/legs",
		"flavour_feet" = "flavor_texts/feet",
		"robot_default" = "flavour_texts_robot/Default",
		"signature" = "signature",
		"signature_font" = "signfont"
	)

	for (var/module in GLOB.robot_module_types)
		var_list["robot_[lowertext(module)]"] = "flavour_texts_robot/[module]"

	return list(
		"ss13_characters_flavour" = list(
			"vars" = var_list,
			"args" = list("char_id")
		)
	)

/datum/category_item/player_setup_item/general/flavor/gather_load_parameters()
	return list("char_id" = pref.current_character)

/datum/category_item/player_setup_item/general/flavor/gather_save_query()
	var/list/var_list = list(
		"flavour_general",
		"flavour_head",
		"flavour_face",
		"flavour_eyes",
		"flavour_torso",
		"flavour_arms",
		"flavour_hands",
		"flavour_legs",
		"flavour_feet",
		"robot_default",
		"signature",
		"signature_font",
		"char_id" = 1
	)

	for (var/module in GLOB.robot_module_types)
		var_list += "robot_[lowertext(module)]"

	return list("ss13_characters_flavour" = var_list)

/datum/category_item/player_setup_item/general/flavor/gather_save_parameters()
	var/list/var_list = list(
		"char_id" = pref.current_character,
		"flavour_general" = pref.flavor_texts["general"],
		"flavour_head" = pref.flavor_texts["head"],
		"flavour_face" = pref.flavor_texts["face"],
		"flavour_eyes" = pref.flavor_texts["eyes"],
		"flavour_torso" = pref.flavor_texts["torso"],
		"flavour_arms" = pref.flavor_texts["arms"],
		"flavour_hands" = pref.flavor_texts["hands"],
		"flavour_legs" = pref.flavor_texts["legs"],
		"flavour_feet" = pref.flavor_texts["feet"],
		"robot_default" = pref.flavour_texts_robot["Default"],
		"signature" = pref.signature,
		"signature_font" = pref.signfont
	)

	for (var/module in GLOB.robot_module_types)
		var_list["robot_[lowertext(module)]"] += pref.flavour_texts_robot[module]

	return var_list

/datum/category_item/player_setup_item/general/flavor/sanitize_character(var/sql_load = 0)
	if (!pref.signature)
		pref.signature = "<i>[pref.real_name]</i>"
	if (!pref.signfont)
		pref.signfont = "Verdana"

/datum/category_item/player_setup_item/general/flavor/content(var/mob/user)
	var/list/dat = list(
		"<b>Flavor:</b><br>",
		"<a href='?src=\ref[src];flavor_text=open'>Set Flavor Text</a><br/>",
		"<a href='?src=\ref[src];flavour_text_robot=open'>Set Robot Flavor Text</a><br/>",
		"<br>",
		"Signature: <font face='[pref.signfont ? pref.signfont : "Verdana"]'>[pref.signature]</font><br/>",
		"<a href='?src=\ref[src];edit_signature=text'>Edit Text</a> | ",
		"<a href='?src=\ref[src];edit_signature=font'>Edit Font</a> | ",
		"<a href='?src=\ref[src];edit_signature=help'>Help</a> | ",
		"<a href='?src=\ref[src];edit_signature=reset'>Reset</a><br/>"
	)
	. = dat.Join()

/datum/category_item/player_setup_item/general/flavor/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["flavor_text"])
		if(href_list["flavor_text"] != "open")
			switch(href_list["flavor_text"])
				if("general")
					var/msg = sanitize(input(usr,"Give a general description of your character. This will be shown regardless of clothing.","Flavor Text",html_decode(pref.flavor_texts[href_list["flavor_text"]])) as message, extra = 0)
					if(CanUseTopic(user))
						pref.flavor_texts[href_list["flavor_text"]] = msg
				else
					var/msg = sanitize(input(usr,"Set the flavor text for your [href_list["flavor_text"]].","Flavor Text",html_decode(pref.flavor_texts[href_list["flavor_text"]])) as message, extra = 0)
					if(CanUseTopic(user))
						pref.flavor_texts[href_list["flavor_text"]] = msg
		SetFlavorText(user)
		return TOPIC_HANDLED

	else if(href_list["flavour_text_robot"])
		if(href_list["flavour_text_robot"] != "open")
			switch(href_list["flavour_text_robot"])
				if("Default")
					var/msg = sanitize(input(usr,"Set the default flavour text for your robot. It will be used for any module without individual setting.","Flavour Text",html_decode(pref.flavour_texts_robot["Default"])) as message, extra = 0)
					if(CanUseTopic(user))
						pref.flavour_texts_robot[href_list["flavour_text_robot"]] = msg
				else
					var/msg = sanitize(input(usr,"Set the flavour text for your robot with [href_list["flavour_text_robot"]] module. If you leave this empty, default flavour text will be used for this module.","Flavour Text",html_decode(pref.flavour_texts_robot[href_list["flavour_text_robot"]])) as message, extra = 0)
					if(CanUseTopic(user))
						pref.flavour_texts_robot[href_list["flavour_text_robot"]] = msg
		SetFlavourTextRobot(user)
		return TOPIC_HANDLED

	else if (href_list["edit_signature"])
		switch (href_list["edit_signature"])
			if ("text")
				var/new_sign = tgui_input_text(usr, "Please input the new character signature.", "New Signature", html2pencode(pref.signature))
				if (!new_sign)
					to_chat(usr, SPAN_NOTICE("Cancelled."))
					if (pref.signature)
						return TOPIC_NOACTION
					else
						pref.signature = "<i>[pref.real_name]</i>"
						return TOPIC_REFRESH
				new_sign = sanitize(new_sign, 100)
				new_sign = pencode2html(new_sign, 1)
				pref.signature = new_sign

				return TOPIC_REFRESH
			if ("font")
				var/new_font = tgui_input_list(usr, "Please select the font to use.", "New Font", list("Verdana", "Times New Roman", "Courier New"))
				if (!new_font)
					to_chat(usr, SPAN_NOTICE("Cancelled."))
					if (pref.signfont)
						return TOPIC_NOACTION
					else
						pref.signfont = "Verdana"
						return TOPIC_REFRESH
				pref.signfont = new_font

				return TOPIC_REFRESH
			if ("help")
				var/html = ""
				html += "A character's signature can be augmented with the following tags:<br>"
				html += "<ul><li><i>Italics</i> - \[i\]text\[/i\]</li>"
				html += "<li><b>Bold</b> - \[b\]text\[/b\]</li>"
				html += "<li><u>Underline</u> - \[u\]text\[/u\]</li>"
				html += "<li><font size='4'>Large text</font> - \[large\]text\[/large\]</li>"
				html += "<li><font size='1'>Small text</font> - \[small\]text\[/small\]</li></ul>"
				html += "<br><br>Beyond that, a maximum of 100 symbols are allowed for the signature text."
				html += " Note that this includes mark-up symbols."

				show_browser(usr, html, "window=signaturehelp;size=350x300")
				return TOPIC_HANDLED
			if ("reset")
				to_chat(usr, SPAN_NOTICE("Signature reset."))
				pref.signfont = "Verdana"
				pref.signature = "<i>[pref.real_name]</i>"
				return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/general/flavor/proc/SetFlavorText(mob/user)
	var/HTML = "<meta charset=\"utf-8\"><body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='?src=\ref[src];flavor_text=general'>General:</a> "
	HTML += TextPreview(pref.flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=head'>Head:</a> "
	HTML += TextPreview(pref.flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=face'>Face:</a> "
	HTML += TextPreview(pref.flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=eyes'>Eyes:</a> "
	HTML += TextPreview(pref.flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=torso'>Body:</a> "
	HTML += TextPreview(pref.flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=arms'>Arms:</a> "
	HTML += TextPreview(pref.flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=hands'>Hands:</a> "
	HTML += TextPreview(pref.flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=legs'>Legs:</a> "
	HTML += TextPreview(pref.flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=feet'>Feet:</a> "
	HTML += TextPreview(pref.flavor_texts["feet"])
	HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=flavor_text;size=430x300")
	return

/datum/category_item/player_setup_item/general/flavor/proc/SetFlavourTextRobot(mob/user)
	var/HTML = "<body>"
	HTML += "<tt><center>"
	HTML += "<b>Set Robot Flavour Text</b> <hr />"
	HTML += "<br></center>"
	HTML += "<a href='?src=\ref[src];flavour_text_robot=Default'>Default:</a> "
	HTML += TextPreview(pref.flavour_texts_robot["Default"])
	HTML += "<hr />"
	for(var/module in GLOB.robot_module_types)
		HTML += "<a href='?src=\ref[src];flavour_text_robot=[module]'>[module]:</a> "
		HTML += TextPreview(pref.flavour_texts_robot[module])
		HTML += "<br>"
	HTML += "<hr />"
	HTML += "<tt>"
	user << browse(HTML, "window=flavour_text_robot;size=430x300")
	return
