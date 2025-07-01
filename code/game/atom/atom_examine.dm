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
 *	The structure of an object's examine box is as follows:
 *	[ Name ] [ Size ]
 *	[ Damage/Condition ]
 *	[ Description ]
 *	[ Extended Description*** ]
 *	[ Mechanics*** ]
 *	[ Assembly/Disassembly*** ]
 *	[ Upgrades*** ]
 *	[ Antagonist Interactions*** ]
 *	[ Status Feedback ]
 *
*	Blocks marked with *** are collapsed by default.
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

	// Object name. I.e. "This is an Object. It is a normal-sized item."
	. += "[icon2html(src, user)] That's [f_name] [suffix]"

	if(src.desc)
		. += src.desc	// Object description.

	// Returns a SPAN_* based on health, if configured.
	var/condition_hints = src.condition_hints()
	if(condition_hints)
		LOG_DEBUG("[condition_hints]")
		. += condition_hints

	// Extra object descriptions examination code.
	if(show_extended)
		// If the item has a extended description, show it.
		if(desc_extended)
			. += desc_extended
		// If the item has a description regarding game mechanics, show it.
		if(desc_mechanics)
			. += FONT_SMALL(SPAN_NOTICE("<b>Mechanics</b>"))
			. += FONT_SMALL(SPAN_NOTICE("[desc_mechanics]"))
		// If the item has a description with assembly/disassembly instructions, show it.
		if(desc_build)
			. += FONT_SMALL(SPAN_NOTICE("<b>Assembly/Disassembly</b>"))
			// Not a span because desc_build can use both NOTICE and ALERT.
			. += FONT_SMALL("[desc_build]")
		// If the item has a description about its upgrade components and what they do, show it.
		// This one doesnt come prepended with a hyphen because theyre added when the desc is dynamically built.
		if(desc_upgrade)
			. += FONT_SMALL(SPAN_NOTICE("<b>Upgrades</b>"))
			. += FONT_SMALL(SPAN_NOTICE("[desc_upgrade]"))
		// If the item has an antagonist description and the user is an antagonist/ghost, show it.
		if(desc_antag && (player_is_antag(user.mind) || isghost(user) || isstoryteller(user)))
			. += FONT_SMALL(SPAN_ALERT("<b>Antagonism</b>"))
			. += FONT_SMALL(SPAN_ALERT("[desc_antag]"))
	else
		 // Checks if the object has a extended description, a mechanics description, and/or an antagonist description (and if the user is an antagonist).
		if(desc_extended || desc_mechanics || desc_build || desc_upgrade || (desc_antag && player_is_antag(user.mind)))
			// If any of the above are true, show that the object has more information available.
			. += FONT_SMALL(SPAN_NOTICE("\[?\] This object has additional examine information available:"))
			// If the item has a extended description, show that it is available.
			if(desc_extended)
				. +=  FONT_SMALL("- <b>Extended Description</b>")
			// If the item has a description regarding game mechanics, show that it is available.
			if(desc_mechanics)
				. += FONT_SMALL(SPAN_NOTICE("- <b>Mechanics</b>"))
			// If the item has a description regarding game mechanics, show that it is available.
			if(desc_build)
				. += FONT_SMALL(SPAN_NOTICE("- <b>Assembly/Disassembly</b>"))
			// If the item has a description regarding game mechanics, show that it is available.
			if(desc_upgrade)
				. += FONT_SMALL(SPAN_NOTICE("- <b>Upgrades</b>"))
			// If the item has an antagonist description and the user is an antagonist/ghost, show that it is available.
			if(desc_antag && (player_is_antag(user.mind) || isghost(user) || isstoryteller(user)))
				. += FONT_SMALL(SPAN_ALERT("- <b>Antagonist Interactions</b>"))
			. += FONT_SMALL(SPAN_NOTICE("<a href='byond://?src=[REF(src)];examine_fluff=1'>\[Show in Chat\]</a>"))
	// If the item has any feedback text, show it.
	. += "</br>[desc_feedback]"

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

/// Builds the text block variables for get_examine_text
/// In the future, we may want to give this a user param to customize what information is returned.
/atom/proc/update_desc_blocks()
	var/mechanics_hints = mechanics_hints()
	var/assembly_hints = assembly_hints()
	var/disassembly_hints = disassembly_hints()
	var/upgrade_hints = upgrade_hints()
	var/antagonist_hints = antagonist_hints()
	var/feedback_hints = feedback_hints()

	// A little ugly but it works.
	var/first_line

	if(mechanics_hints)
		first_line = TRUE
		desc_mechanics = ""
		for(var/mechanics_hint in mechanics_hints)
			LOG_DEBUG("[mechanics_hint]")
			if(!first_line)
				desc_mechanics += "</br>"
			first_line = FALSE
			desc_mechanics += SPAN_NOTICE("- [mechanics_hint]")

	if(assembly_hints || disassembly_hints)
		first_line = TRUE
		LOG_DEBUG("found assembly hints")
		desc_build = ""
		for(var/assembly_hint in assembly_hints)
			LOG_DEBUG("[assembly_hint]")
			if(!first_line)
				desc_build += "</br>"
			first_line = FALSE
			desc_build += SPAN_NOTICE("- [assembly_hint]")
		// Make sure line breaks work reliably whether or not there's only assembly, only disassembly, or both types available.
		if (assembly_hints().len > 0 && disassembly_hints)
			desc_build += "</br>"
		first_line = TRUE
		for(var/disassembly_hint in disassembly_hints)
			LOG_DEBUG("[disassembly_hint]")
			if(!first_line)
				desc_build += "</br>"
			first_line = FALSE
			desc_build += SPAN_ALERT("- [disassembly_hint]")

	if(upgrade_hints)
		first_line = TRUE
		LOG_DEBUG("found upgrade hints")
		desc_upgrade = ""
		for(var/upgrade_hint in upgrade_hints)
			if(!first_line)
				desc_upgrade += "<br>"
			desc_upgrade += "- [upgrade_hint]"
			first_line = FALSE

	if(antagonist_hints)
		first_line = TRUE
		LOG_DEBUG("found antag hints")
		desc_antag = ""
		for(var/antagonist_hint in antagonist_hints)
			LOG_DEBUG("[antagonist_hint]")
			if(!first_line)
				desc_antag += "</br>"
			first_line = FALSE
			desc_antag += SPAN_WARNING("- [antagonist_hint]")

	if(feedback_hints)
		first_line = TRUE
		LOG_DEBUG("found feedback hints")
		desc_feedback = ""
		for(var/feedback_hint in feedback_hints)
			LOG_DEBUG("[feedback_hint]")
			if(!first_line)
				desc_feedback += "</br>"
			first_line = FALSE
			desc_feedback += "[feedback_hint]"

/// Should return a list() of SPAN_* strings in whatever format you like.
/// Existing style is SPAN_NOTICE for minor damage and SPAN_ALERT for anything worse. If the object's destruction
/// could have major adverse consequences, you might use SPAN_DANGER for critical damage.
/atom/proc/condition_hints()
	return FALSE

/// Should return a list() of regular strings.
/atom/proc/mechanics_hints()
	return FALSE

/*
 *	Children of assembly_hints() and disassembly_hints() should check the current state of the object, whether it
 *	has any eligible steps in its assembly or disassembly respectively, and if so, return hints to that end.
 *
 *	It should be used to suggest steps toward or away from a completed 'form' of the object.
 *	For example, a table whose surface can be carpeted would have carpeting instructions in assembly_hints().
 *	However, an IV drip which can have a gas tank attached to it would not have that  described in assembly_hints(),
 *	as the IV drip itself is already 'completed,' and a gas tank is effectively just a swappable slot item for it.
 *
 *	Use your best judgement, and check out"/obj/modules/tables/table.dm" for a simple implementation example.
 */

/// Should return a list() of regular strings.
/atom/proc/assembly_hints(mob/user, distance, is_adjacent)
	return FALSE

/// Should return a list() of regular strings.
/atom/proc/disassembly_hints(mob/user, distance, is_adjacent)
	return FALSE

/atom/proc/upgrade_hints(mob/user, distance, is_adjacent)
	return FALSE

/// Should return a list() of regular strings.
/atom/proc/antagonist_hints(mob/user, distance, is_adjacent)
	return FALSE

/// Should return a list() of regular strings. It will accept SPAN_* strings, though for consistency's sake please
/// use SPAN_ALERT or SPAN_DANGER for negative/bad feedback.
/atom/proc/feedback_hints(mob/user, distance, is_adjacent)
	return FALSE

/*
	Until we finish migrating the 589217 objects needing to be moved to the new system, here's a code block to
	copy underneath an unmigrated object's definition that can then be (relatively) quickly edited to work.

/obj/THINGYDOO/condition_hints(mob/user, distance, is_adjacent)
	. = list()
	if (health < maxhealth)
		switch(health / maxhealth)
			if (0.0 to 0.5)
				. += SPAN_WARNING("It looks severely damaged!")
			if (0.25 to 0.5)
				. += SPAN_WARNING("It looks damaged!")
			if (0.5 to 1.0)
				. += SPAN_NOTICE("It has a few scrapes and dents.")

/obj/THINGYDOO/mechanics_hints(mob/user, distance, is_adjacent)
	. = list()
	if (anchored)
		. += "It could be [density ? "opened" : "closed"] to passage with a wrench."

/obj/THINGYDOO/assembly_hints(mob/user, distance, is_adjacent)
	. = list()
	if (health < maxhealth)
		. += "It could be repaired with a few choice <b>welds</b>."
	. += "It [anchored ? "is" : "could be"] anchored to the floor with a row of <b>screws</b>."
	if (!anchored)
		. += "It is held together by a couple of <b>bolts</b>."

/obj/THINGYDOO/upgrade_hints()
	. = list()
	. += "Upgraded <b>scanning modules</b> will provide the exact volume and composition of attached beakers."
	. += "Upgraded <b>manipulators</b> will allow patients to be hooked to IV through armor and increase the maximum reagent transfer rate."

/obj/THINGYDOO/feedback_hints()
	. = list()
	. += "[src] is [mode ? "injecting" : "taking blood"] at a rate of [src.transfer_amount] u/sec, the automatic injection stop mode is [toggle_stop ? "on" : "off"]."
	. += "The Emergency Positive Pressure system is [epp ? "on" : "off"]."
	if(attached)
		. += "\The [src] is attached to [attached]'s [vein.name]."
	if(beaker)
		if(LAZYLEN(beaker.reagents.reagent_volumes))
			. += "Attached is \a [beaker] with [adv_scan ? "[beaker.reagents.total_volume] units of primarily [beaker.reagents.get_primary_reagent_name()]" : "some liquid"]."
		else
			. += "Attached is \a [beaker]. It is empty."
	else
		. += SPAN_ALERT("No chemicals are attached.")
	if(tank)
		. += "Installed is [is_loose ? "\a [tank] sitting loose" : "\a [tank] secured"] on the stand. The meter shows [round(tank.air_contents.return_pressure())]kPa, \
		with the pressure set to [round(tank.distribute_pressure)]kPa. The valve is [valve_open ? "open" : "closed"]."
	else
		. += SPAN_ALERT("No gas tank installed.")
	if(breath_mask)
		. += "\The [src] has \a [breath_mask] installed. [breather ? breather : "No one"] is wearing it."
	else
		. += SPAN_ALERT("No breath mask installed.")
	. += "This is an extra placeholder value for feedback hints."

/obj/machinery/power/apc/antagonist_hints(mob/user, distance, is_adjacent)
	. = list()
	. += "This can be emagged to unlock it; it will cause the APC to have a blue error screen."
	. += "Wires can be pulsed remotely with a signaler attached to them."
	. += "A powersink will drain any APCs connected to the same powernet (wires) the powersink is on"
*/
