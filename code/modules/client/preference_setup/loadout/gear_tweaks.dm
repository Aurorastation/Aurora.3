/**
 * Displays information about the currently active tweak.
 * For example: a color tweak might show the user the currently selected color
 */
/datum/gear_tweak/proc/get_contents(var/metadata)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	return

/**
 * Queries the user for additional information about the tweak.
 * For example: A color tweak might display a color selection menu to the user
 */
/datum/gear_tweak/proc/get_metadata(var/user, var/metadata, var/title, var/gear_path)
	return

/**
 * Returns a sensible default value for the tweak that is used when the tweak is newly applied.
 * For example: A alpha tweak might return 255
 */
/datum/gear_tweak/proc/get_default()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	return

/**
 * Returns a random (valid) value for the tweak.
 * For example: A alpha tweak might return something between 0 and 255
 */
/datum/gear_tweak/proc/get_random()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	return get_default()

/**
 * Tweaks the gear data (parameter) based on the metadata (parameter)
 */
/datum/gear_tweak/proc/tweak_gear_data(var/metadata, var/datum/gear_data/gear_data)
	SHOULD_NOT_SLEEP(TRUE)
	return

/**
 * Applies the tweak to the item
 */
/datum/gear_tweak/proc/tweak_item(var/obj/item/I, var/metadata, var/mob/living/carbon/human/H)
	SHOULD_NOT_SLEEP(TRUE)
	return

/*
Color adjustment
*/

/datum/gear_tweak/color
	var/list/valid_colors

/datum/gear_tweak/color/New(var/list/valid_colors)
	src.valid_colors = valid_colors
	..()

/datum/gear_tweak/color/get_contents(var/metadata)
	return "Color: <font color='[metadata]'>&#9899;</font>"

/datum/gear_tweak/color/get_default()
	return valid_colors ? valid_colors[1] : COLOR_GRAY

/datum/gear_tweak/color/get_random()
	return valid_colors ? pick(valid_colors) : COLOR_GRAY

/datum/gear_tweak/color/get_metadata(var/user, var/metadata, var/title = "Character Preference")
	if(valid_colors)
		return input(user, "Choose a color.", title, metadata) as null|anything in valid_colors
	return input(user, "Choose a color.", title, metadata) as color|null

/datum/gear_tweak/color/tweak_item(var/obj/item/I, var/metadata, var/mob/living/carbon/human/H)
	if(valid_colors && !(metadata in valid_colors))
		return
	I.color = sanitize_hexcolor(metadata, I.color)

/*
Alpha adjustment
*/

/datum/gear_tweak/alpha/get_contents(var/metadata)
	return "Alpha (0-255): [metadata]"

/datum/gear_tweak/alpha/get_default()
	return 255

/datum/gear_tweak/alpha/get_random()
	return 255

/datum/gear_tweak/alpha/get_metadata(var/user, var/metadata, var/title = "Character Preference")
	var/selected_alpha = tgui_input_number(user, "Choose a color.", title, 255)
	selected_alpha = clamp(selected_alpha, 0, 255)
	return selected_alpha

/datum/gear_tweak/alpha/tweak_item(var/obj/item/item, var/metadata, var/mob/living/carbon/human/H)
	item.alpha = metadata

/*
	Accent colour
*/

GLOBAL_DATUM_INIT(gear_tweak_accent_color, /datum/gear_tweak/color/accent, new())

/datum/gear_tweak/color/accent/get_contents(var/metadata)
	return "Accent Color: <font color='[metadata]'>&#9899;</font>"

/datum/gear_tweak/color/accent/tweak_item(var/obj/item/I, var/metadata, var/mob/living/carbon/human/H)
	if(valid_colors && !(metadata in valid_colors))
		return
	I.accent_color = metadata
	I.update_icon()

/*
Color Rotation adjustment
*/

GLOBAL_DATUM_INIT(gear_tweak_color_rotation, /datum/gear_tweak/color_rotation, new())

/datum/gear_tweak/color_rotation/get_contents(var/metadata)
	return "Color Rotation: [metadata]"

/datum/gear_tweak/color_rotation/get_default()
	return 0

/datum/gear_tweak/color_rotation/get_metadata(var/user, var/metadata, var/title = "Color Rotation")
	return tgui_input_number(user, "Choose the amount of degrees to rotate the hue around the color wheel. (-180 - 180)", title, 0, 180, -180, round_value = TRUE)

/datum/gear_tweak/color_rotation/tweak_item(var/obj/item/I, var/metadata, var/mob/living/carbon/human/H)
	I.color = color_rotation(metadata)

/*
Path adjustment
*/

/datum/gear_tweak/path
	var/list/valid_paths

/datum/gear_tweak/path/New(var/list/valid_paths)
	src.valid_paths = valid_paths
	..()

/datum/gear_tweak/path/get_contents(var/metadata)
	return "Type: [metadata]"

/datum/gear_tweak/path/get_default()
	return valid_paths[1]

/datum/gear_tweak/path/get_random()
	return pick(valid_paths)

/datum/gear_tweak/path/get_metadata(var/user, var/metadata)
	return tgui_input_list(user, "Choose a type.", "Character Preference", valid_paths, metadata)

/datum/gear_tweak/path/tweak_gear_data(var/metadata, var/datum/gear_data/gear_data)
	if(!(metadata in valid_paths))
		return
	gear_data.path = valid_paths[metadata]

/*
Faction-based Path adjustment
Same as the adjustment above, but the associated value is a list with the first value containing the path and the second the faction requirement
*/

/datum/gear_tweak/path/faction/tweak_gear_data(var/metadata, var/datum/gear_data/gear_data)
	if(!(metadata in valid_paths))
		return
	gear_data.path = valid_paths[metadata][1]
	gear_data.faction_requirement = valid_paths[metadata][2]

/*
Content adjustment
*/

/datum/gear_tweak/contents
	var/list/valid_contents

/datum/gear_tweak/contents/New()
	valid_contents = args.Copy()
	..()

/datum/gear_tweak/contents/get_contents(var/metadata)
	return "Contents: [english_list(metadata, and_text = ", ")]"

/datum/gear_tweak/contents/get_default()
	. = list()
	for(var/i = 1 to valid_contents.len)
		. += "Random"

/datum/gear_tweak/contents/get_metadata(var/user, var/list/metadata)
	. = list()
	for(var/i = metadata.len to (valid_contents.len - 1))
		metadata += "Random"
	for(var/i = 1 to valid_contents.len)
		var/entry = tgui_input_list(user, "Choose an entry.", "Character Preference", (list("None", "Random") + valid_contents[i]), metadata[i])
		if(entry)
			. += entry
		else
			return metadata

/datum/gear_tweak/contents/tweak_item(var/obj/item/I, var/list/metadata, var/mob/living/carbon/human/H)
	if(metadata.len != valid_contents.len)
		return
	for(var/i = 1 to valid_contents.len)
		var/path
		var/list/contents = valid_contents[i]
		if(metadata[i] == "Random")
			path = pick(contents)
			path = contents[path]
		else if(metadata[i] == "None")
			continue
		else
			path = 	contents[metadata[i]]
		if(path)
			new path(I)

/*
Reagents adjustment
*/
/datum/gear_tweak/reagents
	var/list/valid_reagents

/datum/gear_tweak/reagents/New(var/list/reagents)
	valid_reagents = reagents.Copy()
	..()

/datum/gear_tweak/reagents/get_contents(var/metadata)
	return "Reagents: [metadata]"

/datum/gear_tweak/reagents/get_default()
	return "Random"

/datum/gear_tweak/reagents/get_metadata(var/user, var/list/metadata)
	. = tgui_input_list(user, "Choose an entry.", "Character Preference", (valid_reagents + list("Random", "None")), metadata)
	if(!.)
		return metadata

/datum/gear_tweak/reagents/tweak_item(var/obj/item/I, var/list/metadata, var/mob/living/carbon/human/H)
	if(metadata == "None")
		return
	if(metadata == "Random")
		. = valid_reagents[pick(valid_reagents)]
	else
		. = valid_reagents[metadata]

	if(!isnull(.))
		I.reagents.add_reagent(., REAGENTS_FREE_SPACE(I.reagents))

/*
Custom Name
*/

GLOBAL_DATUM_INIT(gear_tweak_free_name, /datum/gear_tweak/custom_name, new())

/datum/gear_tweak/custom_name
	var/list/valid_custom_names

/datum/gear_tweak/custom_name/New(var/list/valid_custom_names)
	src.valid_custom_names = valid_custom_names
	..()

/datum/gear_tweak/custom_name/get_contents(var/metadata)
	return "Name: [metadata]"

/datum/gear_tweak/custom_name/get_default()
	return ""

/datum/gear_tweak/custom_name/get_metadata(var/user, var/metadata)
	var/custom_name_input = null
	if(valid_custom_names)
		custom_name_input = tgui_input_list(user, "Choose an item name.", "Character Preference", valid_custom_names, metadata)
	else
		custom_name_input = strip_html(tgui_input_text(user, "Choose an item name.", "Character Preference", metadata, MAX_LNAME_LEN))

	return custom_name_input

/datum/gear_tweak/custom_name/tweak_item(var/obj/item/I, var/metadata, var/mob/living/carbon/human/H)
	if(!metadata)
		return I.name
	I.name = metadata

	// For reasons unknown, using SEND_SIGNAL instead of what is below makes rag renaming completely break.
	var/datum/component/base_name/BN = I.GetComponent(/datum/component/base_name)
	if(BN)
		BN.rename(metadata)

/*
Custom Description
*/

GLOBAL_DATUM_INIT(gear_tweak_free_desc, /datum/gear_tweak/custom_desc, new())

/datum/gear_tweak/custom_desc
	var/list/valid_custom_desc

/datum/gear_tweak/custom_desc/New(var/list/valid_custom_desc)
	src.valid_custom_desc = valid_custom_desc
	..()

/datum/gear_tweak/custom_desc/get_contents(var/metadata)
	return "Description: [metadata]"

/datum/gear_tweak/custom_desc/get_default()
	return ""

/datum/gear_tweak/custom_desc/get_metadata(var/user, var/metadata)
	var/input_description = null

	if(valid_custom_desc)
		input_description = tgui_input_list(user, "Choose an item description.", "Character Preference", valid_custom_desc, metadata)
	else
		input_description = html_encode(STRIP_HTML_FULL(tgui_input_text(user, "Choose an item description.", "Character Preference", metadata, encode = FALSE, multiline = TRUE), MAX_MESSAGE_LEN))

	return input_description

/datum/gear_tweak/custom_desc/tweak_item(var/obj/item/I, var/metadata, var/mob/living/carbon/human/H)
	//Snowflake customization for badges
	if(istype(I, /obj/item/clothing/accessory/badge))
		var/obj/item/clothing/accessory/badge/badge_to_tweak = I

		badge_to_tweak.stored_name = H.real_name
		badge_to_tweak.desc = "[badge_to_tweak.desc]\nThe name [H.real_name] is written on it."

	//If we don't have any metadata to apply, return
	if(!metadata)
		return

	I.desc = metadata

/*
Paper Data
*/
/datum/gear_tweak/paper_data/get_contents(var/metadata)
	return "Written Content: [length(metadata) > 15 ? "[copytext_char(metadata, 1, 15)]..." : metadata]"

/datum/gear_tweak/paper_data/get_default()
	return ""

/datum/gear_tweak/paper_data/get_metadata(var/user, var/metadata)
	return strip_html(tgui_input_text(user, "Choose a pre-written message on the item.", "Pre-written Message", metadata, MAX_PAPER_MESSAGE_LEN))

/datum/gear_tweak/paper_data/tweak_item(var/obj/item/paper/P, var/metadata, var/mob/living/carbon/human/H)
	if(!metadata || !istype(P))
		return
	P.info = P.parsepencode(metadata)



// Buddy Tag Settings
/datum/gear_tweak/buddy_tag_config/get_contents(var/metadata)
	return "ID: [metadata[1]] | Distance: [metadata[2]] | Interval: [metadata[3]]s"

/datum/gear_tweak/buddy_tag_config/get_default()
	return list(1, 10, 30)

/datum/gear_tweak/buddy_tag_config/get_metadata(var/user, var/metadata)
	var/newcode = tgui_input_number(user, "Set new buddy ID number.", "Buddy Tag ID", metadata[1])
	if(isnull(newcode))
		newcode = metadata[1]

	var/newdist = tgui_input_number(user, "Set new maximum range.", "Buddy Tag Range", metadata[2])
	if(isnull(newdist))
		newdist = metadata[2]

	var/newtime = tgui_input_number(user, "Set new search interval in seconds (minimum 30s).", "Buddy Tag Time Interval", metadata[3])
	if(isnull(newtime))
		newtime = metadata[3]

	newtime = max(30, newtime)

	return list(newcode, newdist, newtime)

/datum/gear_tweak/buddy_tag_config/tweak_item(var/obj/item/clothing/accessory/buddytag/BT, var/list/metadata, var/mob/living/carbon/human/H)
	if(!length(metadata) || !istype(BT))
		return
	BT.id = metadata[1]
	BT.distance = metadata[2]
	BT.search_interval = metadata[3] SECONDS


// Accessory Slot Settings

GLOBAL_DATUM_INIT(gear_tweak_accessory_slot, /datum/gear_tweak/accessory_slot, new())

/datum/gear_tweak/accessory_slot
	var/static/list/accessory_slots = list(GEAR_TWEAK_ACCESSORY_SLOT_UNDER, GEAR_TWEAK_ACCESSORY_SLOT_SUIT, GEAR_TWEAK_ACCESSORY_SLOT_SUIT_STANDALONE)

/datum/gear_tweak/accessory_slot/get_contents(var/metadata)
	return "Spawn Slot: [metadata]"

/datum/gear_tweak/accessory_slot/get_default()
	return GEAR_TWEAK_ACCESSORY_SLOT_UNDER

/datum/gear_tweak/accessory_slot/get_metadata(var/user, var/metadata)
	return tgui_input_list(user, "Choose a type.", "Character Preference", accessory_slots, metadata)

/datum/gear_tweak/accessory_slot/tweak_item(var/obj/item/clothing/accessory/buddytag/BT, var/list/metadata, var/mob/living/carbon/human/H)
	return
