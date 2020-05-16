/datum/gear_tweak/proc/get_contents(var/metadata)
	return

/datum/gear_tweak/proc/get_metadata(var/user, var/metadata)
	return

/datum/gear_tweak/proc/get_default()
	return

/datum/gear_tweak/proc/get_random()
	return get_default()

/datum/gear_tweak/proc/tweak_gear_data(var/metadata, var/datum/gear_data)
	return

/datum/gear_tweak/proc/tweak_item(var/obj/item/I, var/metadata)
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

/datum/gear_tweak/color/tweak_item(var/obj/item/I, var/metadata)
	if(valid_colors && !(metadata in valid_colors))
		return
	I.color = sanitize_hexcolor(metadata, I.color)

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
	return input(user, "Choose a type.", "Character Preference", metadata) as null|anything in valid_paths

/datum/gear_tweak/path/tweak_gear_data(var/metadata, var/datum/gear_data/gear_data)
	if(!(metadata in valid_paths))
		return
	gear_data.path = valid_paths[metadata]

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
		var/entry = input(user, "Choose an entry.", "Character Preference", metadata[i]) as null|anything in (valid_contents[i] + list("Random", "None"))
		if(entry)
			. += entry
		else
			return metadata

/datum/gear_tweak/contents/tweak_item(var/obj/item/I, var/list/metadata)
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
	. = input(user, "Choose an entry.", "Character Preference", metadata) as null|anything in (valid_reagents + list("Random", "None"))
	if(!.)
		return metadata

/datum/gear_tweak/reagents/tweak_item(var/obj/item/I, var/list/metadata)
	if(metadata == "None")
		return
	if(metadata == "Random")
		. = valid_reagents[pick(valid_reagents)]
	else
		. = valid_reagents[metadata]
	I.reagents.add_reagent(., I.reagents.get_free_space())

/*
Custom Name
*/

var/datum/gear_tweak/custom_name/gear_tweak_free_name = new()

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
	if(valid_custom_names)
		return input(user, "Choose an item name.", "Character Preference", metadata) as null|anything in valid_custom_names
	return sanitize(input(user, "Choose the item's name. Leave it blank to use the default name.", "Item Name", metadata) as text|null, MAX_LNAME_LEN, extra = 0)

/datum/gear_tweak/custom_name/tweak_item(var/obj/item/I, var/metadata)
	if(!metadata)
		return I.name
	I.name = metadata

/*
Custom Description
*/
var/datum/gear_tweak/custom_desc/gear_tweak_free_desc = new()

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
	if(valid_custom_desc)
		return input(user, "Choose an item description.", "Character Preference", metadata) as null|anything in valid_custom_desc
	return sanitize(input(user, "Choose the item's description. Leave it blank to use the default description.", "Item Description", metadata) as message|null, extra = 0)

/datum/gear_tweak/custom_desc/tweak_item(var/obj/item/I, var/metadata)
	if(!metadata)
		return I.desc
	I.desc = metadata