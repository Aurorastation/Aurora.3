/datum/category_item/player_setup_item/player_global/pai
	name = "pAI"
	sort_order = 4

	var/datum/paiCandidate/candidate

/datum/category_item/player_setup_item/player_global/pai/New()
	..()

	candidate = new()

/datum/category_item/player_setup_item/player_global/pai/load_preferences(var/savefile/S)
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_load(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/save_preferences(var/savefile/S)
	if(!candidate)
		return

	if(!preference_mob())
		return

	candidate.savefile_save(preference_mob())

/datum/category_item/player_setup_item/player_global/pai/gather_load_query()
	return list("ss13_player_pai" = list("vars" = list("name" = "pai/name", "description" = "pai/description", "role" = "pai/role", "comments" = "pai/comments"), "args" = list("ckey")))

/datum/category_item/player_setup_item/player_global/pai/gather_load_parameters()
	return list("ckey" = PREF_CLIENT_CKEY)

/datum/category_item/player_setup_item/player_global/pai/gather_save_query()
	return list("ss13_player_pai" = list("name", "description", "role", "comments", "ckey" = 1))

/datum/category_item/player_setup_item/player_global/pai/gather_save_parameters()
	if (!candidate)
		return list()

	return list("ckey" = PREF_CLIENT_CKEY, "name" = candidate.name, "description" = candidate.description, "role" = candidate.role, "comments" = candidate.comments)

/datum/category_item/player_setup_item/player_global/pai/sanitize_preferences(var/sql_load = 0)
	if (sql_load && candidate && pref.pai.len)
		candidate.name = pref.pai["name"]
		candidate.description = pref.pai["description"]
		candidate.role = pref.pai["role"]
		candidate.comments = pref.pai["comments"]

/datum/category_item/player_setup_item/player_global/pai/content(var/mob/user)
	if(!candidate)
		candidate = new()

	. += "<b>pAI:</b><br>"
	. += "Name: <a href='?src=\ref[src];option=name'>[candidate.name ? candidate.name : "None Set"]</a><br>"
	. += "Description: <a href='?src=\ref[src];option=desc'>[candidate.description ? TextPreview(candidate.description, 40) : "None Set"]</a><br>"
	. += "Role: <a href='?src=\ref[src];option=role'>[candidate.role ? TextPreview(candidate.role, 40) : "None Set"]</a><br>"
	. += "OOC Comments: <a href='?src=\ref[src];option=ooc'>[candidate.comments ? TextPreview(candidate.comments, 40) : "None Set"]</a><br>"

/datum/category_item/player_setup_item/player_global/pai/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["option"])
		var/t
		switch(href_list["option"])
			if("name")
				t = sanitizeName(input(user, "Enter a name for your pAI", "Global Preference", candidate.name) as text|null, MAX_NAME_LEN, 1)
				if(t && CanUseTopic(user))
					candidate.name = t
			if("desc")
				t = input(user, "Enter a description for your pAI", "Global Preference", html_decode(candidate.description)) as message|null
				if(!isnull(t) && CanUseTopic(user))
					candidate.description = sanitize(t)
			if("role")
				t = input(user, "Enter a role for your pAI", "Global Preference", html_decode(candidate.role)) as text|null
				if(!isnull(t) && CanUseTopic(user))
					candidate.role = sanitize(t)
			if("ooc")
				t = input(user, "Enter any OOC comments", "Global Preference", html_decode(candidate.comments)) as message
				if(!isnull(t) && CanUseTopic(user))
					candidate.comments = sanitize(t)
		return TOPIC_REFRESH

	return ..()
