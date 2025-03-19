/**
 * Called when a mob examines (shift click or verb) this atom
 *
 * Any overrides must either call parent (preferable), or return `TRUE` and set the `SHOULD_CALL_PARENT(FALSE)` (discouraged)
 *
 * There is no need to check the return value of `..()`, this is only used by the calling `examinate()` proc to validate the call chain.
 *
 * Default behaviour is to call `get_examine_text()` and send the result to the mob
 *
 * **You should usually be overriding `get_examine_text()`, unless you need special examine behaviour**
 *
 * Produces a signal [COMSIG_ATOM_EXAMINE]
 *
 * - user - The mob performing the examine
 * - distance - The distance in tiles from `user` to `src`
 * - is_adjacent - Whether `user` is adjacent to `src`
 * - infix String - String that is appended immediately after the atom's name
 * - suffix String - Additional string appended after the atom's name and infix
 * - show_extended Boolean - Whether to show extended examination text or not. Only passed to get_examine_text()
 *
 * Returns boolean - The caller always expects TRUE
 */
/atom/proc/examine(mob/user, distance, is_adjacent, infix = "", suffix = "", show_extended)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	var/list/examine_strings = get_examine_text(user, distance, is_adjacent, infix, suffix, show_extended)
	if(!length(examine_strings))
		crash_with("Examine called with no examine strings on [src].")
	to_chat(user, EXAMINE_BLOCK(examine_strings.Join("\n")))

	SEND_SIGNAL(src, COMSIG_ATOM_EXAMINE, examine_strings.Join("\n"))

	return TRUE

/**
 * Called to get the examine text info of an atom
 *
 * This proc is what you should usually override to get things to show up inside the examine box
 *
 * - user - The mob performing the examine
 * - distance - The distance in tiles from `user` to `src`
 * - is_adjacent - Whether `user` is adjacent to `src`
 * - infix String - String that is appended immediately after the atom's name
 * - suffix String - Additional string appended after the atom's name and infix
 * - show_extended Boolean - Whether to show extended examination text or not. If FALSE, will only show the existence of this text.
 *
 * Returns a `/list` of strings
 */
/atom/proc/get_examine_text(mob/user, distance, is_adjacent, infix = "", suffix = "", show_extended)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	. = list()
	var/f_name = "\a [src]. [infix]"
	if(src.blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		if(blood_color != COLOR_IPC_BLOOD && blood_color != COLOR_OIL)
			f_name += "<span class='danger'>blood-stained</span> [name][infix]!"
		else
			f_name += "oil-stained [name][infix]."

	. += "[icon2html(src, user)] That's [f_name] [suffix]" // Object name. I.e. "This is an Object. It is a normal-sized item."

	if(src.desc)
		. += src.desc	// Object description.

	// Extra object descriptions examination code.
	if(show_extended)
		if(desc_extended) // If the item has a extended description, show it.
			. += desc_extended
		if(desc_info) // If the item has a description regarding game mechanics, show it.
			. += FONT_SMALL(SPAN_NOTICE("- [desc_info]"))
		if(desc_antag && player_is_antag(user.mind)) // If the item has an antagonist description and the user is an antagonist, show it.
			. += FONT_SMALL(SPAN_ALERT("- [desc_antag]"))
	else
		if(desc_extended || desc_info || (desc_antag && player_is_antag(user.mind))) // Checks if the object has a extended description, a mechanics description, and/or an antagonist description (and if the user is an antagonist).
			. += FONT_SMALL(SPAN_NOTICE("\[?\] This object has additional examine information available. <a href='byond://?src=[REF(src)];examine_fluff=1>\[Show In Chat\]</a>")) // If any of the above are true, show that the object has more information available.
			if(desc_extended) // If the item has a extended description, show that it is available.
				. +=  FONT_SMALL("- This object has an extended description.")
			if(desc_info) // If the item has a description regarding game mechanics, show that it is available.
				. += FONT_SMALL(SPAN_NOTICE("- This object has additional information about mechanics."))
			if(desc_antag && player_is_antag(user.mind)) // If the item has an antagonist description and the user is an antagonist, show that it is available.
				. += FONT_SMALL(SPAN_ALERT("- This object has additional information for antagonists."))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses)
			H.glasses.glasses_examine_atom(src, H)

// Used to check if "examine_fluff" from the HTML link in examine() is true, i.e. if it was clicked.
/atom/Topic(href, href_list)
	. = ..()
	if (.)
		return

	if(href_list["examine_fluff"])
		examinate(usr, src, show_extended = TRUE)

	var/client/usr_client = usr.client
	var/list/paramslist = list()
	if(href_list["statpanel_item_click"])
		switch(href_list["statpanel_item_click"])
			if("left")
				paramslist[LEFT_CLICK] = "1"
			if("right")
				paramslist[RIGHT_CLICK] = "1"
			if("middle")
				paramslist[MIDDLE_CLICK] = "1"
			else
				return

		if(href_list["statpanel_item_shiftclick"])
			paramslist[SHIFT_CLICK] = "1"
		if(href_list["statpanel_item_ctrlclick"])
			paramslist[CTRL_CLICK] = "1"
		if(href_list["statpanel_item_altclick"])
			paramslist[ALT_CLICK] = "1"

		var/mouseparams = list2params(paramslist)
		usr_client.Click(src, loc, null, mouseparams)
		return TRUE
