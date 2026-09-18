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

/**
 * The structure of an object's examine box is as follows:
 * [ Name ] [ Size ]
 * [ Damage/Condition ]
 * [ Description ]
 * [ Extended Description*** ]
 * [ Mechanics*** ]
 * [ Assembly/Disassembly*** ]
 * [ Upgrades*** ]
 * [ Antagonist Interactions*** ]
 * [ Status Feedback ]
 *
 * Blocks marked with *** are collapsed by default.
 */
/atom/proc/get_examine_text(mob/user, distance, is_adjacent, infix = "", suffix = "", show_extended)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	update_desc_blocks(user, distance, is_adjacent)

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

	// Object name. I.e. "This is an Object. It is a normal-sized item."
	. += "[icon2html(src, user)] That's [f_name] [suffix]"

	// Object description.
	if(src.desc)
		. += src.desc

	var/list/tags_list = examine_tags(user)
	if(length(tags_list))
		var/tag_string = list()
		for (var/atom_tag in tags_list)
			tag_string += (isnull(tags_list[atom_tag]) ? atom_tag : SPAN_TOOLTIP(tags_list[atom_tag], atom_tag))
		// some regex to ensure that we don't add another "and" if the final element's main text (not tooltip) has one
		tag_string = english_list(tag_string, and_text = (findtext(tag_string[length(tag_string)], regex(@">.*?and .*?<"))) ? " " : " and ")
		. += "It is a [tag_string] [examine_descriptor(user)]."

	// Returns a SPAN_* based on health, if configured.
	var/list/condition_hints = src.condition_hints()
	if(length(condition_hints))
		. += condition_hints

	// Build the additional information once so it can either be displayed directly or folded out in chat.
	var/list/extended_examine_strings = list()
	var/list/extended_examine_categories = list()
	if(desc_extended)
		extended_examine_categories += "Extended Description"
		extended_examine_strings += desc_extended
	if(desc_mechanics)
		extended_examine_categories += "Mechanics"
		extended_examine_strings += FONT_SMALL(SPAN_NOTICE("<b>Mechanics</b>"))
		extended_examine_strings += FONT_SMALL("[desc_mechanics]")
	if(desc_build)
		extended_examine_categories += "Assembly/Disassembly"
		extended_examine_strings += FONT_SMALL(SPAN_NOTICE("<b>Assembly/Disassembly</b>"))
		// Not a span because desc_build can use both NOTICE and ALERT.
		extended_examine_strings += FONT_SMALL("[desc_build]")
	if(desc_upgrade)
		extended_examine_categories += "Upgrades"
		extended_examine_strings += FONT_SMALL("<b>Upgrades</b>")
		extended_examine_strings += FONT_SMALL("[desc_upgrade]")
	if(desc_antag && (player_is_antag(user.mind) || isghost(user) || isstoryteller(user)))
		extended_examine_categories += "Antagonism"
		extended_examine_strings += FONT_SMALL(SPAN_ALERT("<b>Antagonism</b>"))
		extended_examine_strings += FONT_SMALL("[desc_antag]")

	if(length(extended_examine_strings))
		if(show_extended)
			. += extended_examine_strings
		else
			var/extended_examine_text = extended_examine_strings.Join("<br>")
			var/extended_examine_summary = FONT_SMALL(SPAN_NOTICE("\[?\] Additional examine information: [english_list(extended_examine_categories)]"))
			. += "<details class='examine_foldout'><summary>[extended_examine_summary]</summary><div class='examine_foldout__content'>[extended_examine_text]<hr class='examine_foldout__divider'></div></details>"
	// If the item has any feedback text, show it.
	if(desc_feedback)
		if(length(extended_examine_strings) && !show_extended)
			. += desc_feedback
		else
			. += "</br>[desc_feedback]"

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses)
			H.glasses.glasses_examine_atom(src, H)

/// What this atom should be called in examine tags
/atom/proc/examine_descriptor(mob/user)
	return "object"

/**
 * A list of "tags" displayed after atom's description in examine.
 * This should return an assoc list of tags -> tooltips for them. If item is null, then no tooltip is assigned.
 *
 * * TGUI tooltips (not the main text) in chat cannot use HTML stuff at all, so
 * trying something like `<b><big>ffff</big></b>` will not work for tooltips.
 *
 * For example:
 * ```byond
 * . = list()
 * .["small"] = "It is a small item."
 * .["fireproof"] = "It is made of fire-retardant materials."
 * .["and conductive"] = "It's made of conductive materials and whatnot. Blah blah blah." // having "and " in the end tag's main text/key works too!
 * ```
 * will result in
 *
 * It is a *small*, *fireproof* *and conductive* item.
 *
 * where "item" is pulled from [/atom/proc/examine_descriptor]
 */
/atom/proc/examine_tags(mob/user)
	. = list()

	SEND_SIGNAL(src, COMSIG_ATOM_EXAMINE_TAGS, user, .)

/atom/Topic(href, href_list)
	. = ..()
	if (.)
		return

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

/**
 * Builds the text block variables for get_examine_text
 * Builds the text block variables for get_examine_text.
 * Objects themselves are responsible for handling their own logic to build these hints.
 * See mecha.dm for an example of a system that relays hints from contained items to a parent.
 */
/atom/proc/update_desc_blocks(mob/user, distance, is_adjacent)
	var/list/mechanics_hints = mechanics_hints(user, distance, is_adjacent)
	var/list/assembly_hints = assembly_hints(user, distance, is_adjacent)
	var/list/disassembly_hints = disassembly_hints(user, distance, is_adjacent)
	var/list/upgrade_hints = upgrade_hints(user, distance, is_adjacent)
	var/list/antagonist_hints = antagonist_hints(user, distance, is_adjacent)
	var/list/feedback_hints = feedback_hints(user, distance, is_adjacent)

	// A little ugly but it works.
	var/first_line

	desc_mechanics = ""
	if(length(mechanics_hints))
		first_line = TRUE
		for(var/mechanics_hint in mechanics_hints)
			if(!first_line)
				desc_mechanics += "</br>"
			first_line = FALSE
			desc_mechanics += SPAN_NOTICE("[mechanics_hint]")

	desc_build = ""
	if(length(assembly_hints) || length(disassembly_hints))
		first_line = TRUE
		for(var/assembly_hint in assembly_hints)
			if(!first_line)
				desc_build += "</br>"
			first_line = FALSE
			desc_build += SPAN_NOTICE("[assembly_hint]")
		// Make sure line breaks work reliably whether or not there's only assembly, only disassembly, or both types available.
		if (length(assembly_hints) && length(disassembly_hints))
			desc_build += "</br>"
		first_line = TRUE
		for(var/disassembly_hint in disassembly_hints)
			if(!first_line)
				desc_build += "</br>"
			first_line = FALSE
			desc_build += SPAN_ALERT("[disassembly_hint]")

	desc_upgrade = ""
	if(length(upgrade_hints))
		first_line = TRUE
		for(var/upgrade_hint in upgrade_hints)
			if(!first_line)
				desc_upgrade += "<br>"
			desc_upgrade += "[upgrade_hint]"
			first_line = FALSE

	desc_antag = ""
	if(length(antagonist_hints))
		first_line = TRUE
		for(var/antagonist_hint in antagonist_hints)
			if(!first_line)
				desc_antag += "</br>"
			first_line = FALSE
			desc_antag += SPAN_WARNING("[antagonist_hint]")

	desc_feedback = ""
	if(length(feedback_hints))
		first_line = TRUE
		for(var/feedback_hint in feedback_hints)
			if(!first_line)
				desc_feedback += "</br>"
			first_line = FALSE
			desc_feedback += "[feedback_hint]"

/**
 * Should return a list() of SPAN_* strings in whatever format you like.
 * Accepted style is SPAN_NOTICE for minor damage and SPAN_ALERT for anything worse. If the object's destruction
 * could have major adverse consequences, you might use SPAN_DANGER for critical damage.
 */
/atom/proc/condition_hints(mob/user, distance, is_adjacent)
	. = list()

/**
 * Should return a list() of regular strings.
 */
/atom/proc/mechanics_hints(mob/user, distance, is_adjacent)
	. = list()

/*
 * Children of assembly_hints() and disassembly_hints() should check the current state of the object, whether it
 * has any eligible steps in its assembly or disassembly respectively, and if so, return hints to that end.
 *
 * It should be used to suggest steps toward or away from a completed 'form' of the object.
 * For example, a table whose surface can be carpeted would have carpeting instructions in assembly_hints().
 * However, an IV drip which can have a gas tank attached to it would not have that  described in assembly_hints(),
 * as the IV drip itself is already 'completed,' and a gas tank is effectively just a swappable slot item for it.
 *
 * Look at existing objects' implementations and use your best judgement, or ask in Discord if need be!
 */

/**
 * Should return a list() of regular strings.
 * See the large comment block right above this in 'code/game/atom/atom_examine.dm' for nuanced details.
 */
/atom/proc/assembly_hints(mob/user, distance, is_adjacent)
	. = list()

/**
 * Should return a list() of regular strings.
 * See the large comment block right above this in 'code/game/atom/atom_examine.dm' for nuanced details.
 */
/atom/proc/disassembly_hints(mob/user, distance, is_adjacent)
	. = list()

/**
 * Should return a list() of regular strings.
 */
/atom/proc/upgrade_hints(mob/user, distance, is_adjacent)
	. = list()

/**
 * Should return a list() of regular strings.
 */
/atom/proc/antagonist_hints(mob/user, distance, is_adjacent)
	. = list()

/**
 * Should return a list() of regular strings. It will accept SPAN_* strings, though for consistency's sake please
 * use SPAN_ALERT or SPAN_DANGER for negative/bad feedback.
 *
 * For feedback data returning variable number values or important bools, please bold important var values for easy readability.
 * Reference 'code/game/machinery/iv_drip.dm' for how bolding is used.
 */
/atom/proc/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
