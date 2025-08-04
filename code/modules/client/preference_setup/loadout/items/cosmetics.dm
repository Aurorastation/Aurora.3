/datum/gear/cosmetic
	display_name = "handheld mirror"
	path = /obj/item/mirror
	sort_category = "Cosmetics"
	slot = slot_in_backpack

/datum/gear/cosmetic/haircomb
	display_name = "comb"
	path = /obj/item/haircomb
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/cosmetic/lipstick
	display_name = "lipstick selection"
	path = /obj/item/lipstick

/datum/gear/cosmetic/lipstick/New()
	..()
	var/list/lipsticks = list()
	lipsticks["lipstick, red"] = /obj/item/lipstick
	lipsticks["lipstick, purple"] = /obj/item/lipstick/purple
	lipsticks["lipstick, jade"] = /obj/item/lipstick/jade
	lipsticks["lipstick, black"] = /obj/item/lipstick/black
	lipsticks["lipstick, pink"] = /obj/item/lipstick/pink
	lipsticks["lipstick, amberred"] = /obj/item/lipstick/amberred
	lipsticks["lipstick, cherry"] = /obj/item/lipstick/cherry
	lipsticks["lipstick, orange"] = /obj/item/lipstick/orange
	lipsticks["lipstick, gold"] = /obj/item/lipstick/gold
	lipsticks["lipstick, deepred"] = /obj/item/lipstick/deepred
	lipsticks["lipstick, rosepink"] = /obj/item/lipstick/rosepink
	lipsticks["lipstick, nude"] = /obj/item/lipstick/nude
	lipsticks["lipstick, wine"] = /obj/item/lipstick/wine
	lipsticks["lipstick, peach"] = /obj/item/lipstick/peach
	lipsticks["lipstick, forestgreen"] = /obj/item/lipstick/forestgreen
	lipsticks["lipstick, skyblue"] = /obj/item/lipstick/skyblue
	lipsticks["lipstick, teal"] = /obj/item/lipstick/teal

	gear_tweaks += new /datum/gear_tweak/path(lipsticks)
	gear_tweaks += list(GLOB.gear_tweak_lipstick_application)

/datum/gear/cosmetic/lipstick_colorable // not a subtype because we dont want the path gear_tweaks
	display_name = "colorable lipstick"
	path = /obj/item/lipstick/custom
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/cosmetic/lipstick_colorable/New()
	..()
	gear_tweaks += list(GLOB.gear_tweak_lipstick_color)
	gear_tweaks += list(GLOB.gear_tweak_lipstick_application)

GLOBAL_DATUM_INIT(gear_tweak_lipstick_color, /datum/gear_tweak/color/lipstick, new())

/datum/gear_tweak/color/lipstick/get_contents(var/metadata)
	return "Lipstick Color: <font color='[metadata]'>&#9899;</font>"

/datum/gear_tweak/color/lipstick/tweak_item(var/obj/item/lipstick/lipstick, var/metadata, var/mob/living/carbon/human/H)
	lipstick.lipstick_color = metadata
	lipstick.update_icon()


GLOBAL_DATUM_INIT(gear_tweak_lipstick_application, /datum/gear_tweak/lipstick_application, new())

/datum/gear_tweak/lipstick_application/get_contents(var/metadata)
	return "Lipstick Applied: [metadata]"

/datum/gear_tweak/lipstick_application/get_default()
	return "No"

/datum/gear_tweak/lipstick_application/get_random()
	return "No"

/datum/gear_tweak/lipstick_application/get_metadata(var/user, var/metadata, var/title = "Character Preference")
	var/selected_lipstick = tgui_input_list(user, "Do you want your character to start with lipstick applied?", title, list("Yes", "No"), metadata)
	if(selected_lipstick)
		return selected_lipstick

/datum/gear_tweak/lipstick_application/tweak_item(var/obj/item/lipstick/lipstick, var/metadata, var/mob/living/carbon/human/H)
	if(metadata == "Yes")
		H.lipstick_color = lipstick.lipstick_color
		H.update_body()
