/datum/category_item/player_setup_item/quirks
	name = "Quirks"
	sort_order = 1
	var/current_tab = "Disabilities"

/datum/category_item/player_setup_item/quirks/load_character(savefile/S)
	S["quirks"] >> pref.all_quirks

/datum/category_item/player_setup_item/quirks/save_character(savefile/S)
	S["quirks"] << pref.all_quirks

/datum/category_item/player_setup_item/quirks/content()
	var/list/raw_quirks = SSquirks.get_quirks()
	var/list/quirks = SSquirks.filter_invalid_quirks(raw_quirks)

	if (!SSquirks.initialized)
		return "<center><large>Quirks controller not initialized yet. Please wait a bit and reload this section.</large></center>"
	. = list()
	. += "<table align = 'center' width = 100%>"
	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>Quirks</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"

	. += "<tr><td colspan=3><center>"
	var/firstcat = 1
	for(var/category in SSquirks.quirk_categories)
		if(firstcat)
			firstcat = 0
		else
			. += " |"

		if(category == current_tab)
			. += " <span class='linkOn'>[category]</span> "
		else
			. += " <a href='?src=\ref[src];select_category=[category]'>[category]</a> "
	. += "</center></td></tr>"

	for(var/quirk_name in quirks)
		var/datum/quirk/Q = quirks[quirk_name]
		if(Q.category != current_tab)
			continue

		var/ticked = (Q.name in pref.all_quirks)
		var/style_class
		if(!validate_quirk(Q.name))
			style_class = "linkOff"
		else if(ticked)
			style_class = "linkOn"
		. += "<tr style='vertical-align:top;'><td width=25%><div align='center'><a style='white-space:normal;' [style_class ? "class='[style_class]' " : ""]href='?src=\ref[src];toggle_trait=[html_encode(Q.name)]'>[Q.name]</a></div></td>"
		. += "<td width = 10% style='vertical-align:top'>[Q.value]</td>"

		var/invalidity = test_for_invalidity(Q.name)
//		var/conflicts = Q.test_for_trait_conflict(pref.traits)
		var/invalid = ""
		if(invalidity)
			invalid += "[invalidity]  "
		//if(conflicts)
		//	invalid += "This trait is mutually exclusive with [conflicts]."

		. += "<td width = 75%><font size=2><i>[Q.desc]</i>\
		[invalid ? "<font color='#FF0000'><br>Cannot take trait.  Reason: [invalid]</font>":""]</font></td></tr>"
		if(ticked)
			. += "<tr><td colspan=3>"
//			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
//				. += " <a href='?src=\ref[src];gear=[G.display_name];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
			. += "</td></tr>"
	. += "</table>"
	. = jointext(., null)

/datum/category_item/player_setup_item/quirks/OnTopic(href, href_list, user)
	if(href_list["toggle_trait"])
		var/datum/quirk/Q = SSquirks.quirks[href_list["toggle_trait"]]
		if(Q.name in pref.all_quirks)
			pref.all_quirks -= Q.name
		else
			var/invalidity = test_for_invalidity(Q.name)
			if(invalidity)
				to_chat(user, "<span class='warning'>You cannot take the [Q.name] trait.  Reason: [invalidity]</span>")
				return TOPIC_NOACTION
/**
			var/conflicts = Q.test_for_trait_conflict(pref.all_quirks)
			if(conflicts)
				to_chat(user, "<span class='warning'>The [Q.name] trait is mutually exclusive with [conflicts].</span>")
				return TOPIC_NOACTION
			*/
			pref.all_quirks += Q.name
		validate_quirks()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["select_category"])
		current_tab = href_list["select_category"]
		return TOPIC_REFRESH
	return ..()


/datum/category_item/player_setup_item/quirks/proc/validate_quirks()
	var/mob/preference_mob = preference_mob()
	var/datum/species/species_type = preference_mob.get_species()
	var/singleton/origin_item/our_culture = GET_SINGLETON(text2path(pref.culture))
	var/singleton/origin_item/our_origin = GET_SINGLETON(text2path(pref.origin))
	var/list/quirks_removed
	for(var/quirk_name in pref.all_quirks)
		var/quirk_path = SSquirks.quirks[quirk_name]
		var/datum/quirk/quirk_prototype = SSquirks.quirk_prototypes[quirk_path]
		if(!quirk_prototype.is_species_appropriate(species_type))
			pref.all_quirks -= quirk_name
			LAZYADD(quirks_removed, quirk_name)
		if(!quirk_prototype.is_background_appropriate(our_culture))
			pref.all_quirks -= quirk_name
			LAZYADD(quirks_removed, quirk_name)
		if(!quirk_prototype.is_background_appropriate(our_origin))
			pref.all_quirks -= quirk_name
			LAZYADD(quirks_removed, quirk_name)
	var/list/feedback
	if(LAZYLEN(quirks_removed))
		LAZYADD(feedback, "The following quirks were removed as they are not appropriate for your character:")
		LAZYADD(feedback, jointext(quirks_removed, ", "))
	if(GetQuirkBalance() < 0)
		LAZYADD(feedback, "Your quirks have been reset.")
		pref.all_quirks = list()
	if(LAZYLEN(feedback))
		to_chat(preference_mob, SPAN_NOTICE(feedback.Join("\n")))

/datum/category_item/player_setup_item/quirks/proc/test_for_invalidity(quirk_name)
	var/mob/preference_mob = preference_mob()
	var/datum/species/species_type = preference_mob.get_species()
	var/quirk_path = SSquirks.quirks[quirk_name]
	if (!ispath(quirk_path))
		return "Invalid quirk."
	var/datum/quirk/quirk_prototype = SSquirks.quirk_prototypes[quirk_path]
	if(!quirk_prototype.is_species_appropriate(species_type))
		return "Not appropriate for your species."
	var/singleton/origin_item/culture/CL = GET_SINGLETON(text2path(pref.culture))
	if(!quirk_prototype.is_background_appropriate(CL))
		return "Not appropriate for your culture."
	var/singleton/origin_item/origin/OR = GET_SINGLETON(text2path(pref.origin))
	if(!quirk_prototype.is_background_appropriate(OR))
		return "Not appropriate for your origin."
	return null

/// Similar to above, but uses the above two procs, in one place.
/// Returns TRUE if everything is well.
/datum/category_item/player_setup_item/quirks/proc/validate_quirk(quirk_name)
	if(test_for_invalidity(quirk_name))
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/quirks/proc/GetQuirkBalance()
	var/bal = 3
	for(var/V in pref.all_quirks)
		var/datum/quirk/T = SSquirks.quirks[V]
		bal -= initial(T.value)
	return bal
