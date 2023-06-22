/// Emoji icon set
#define EMOJI_SET 'icons/ui_icons/emoji/emoji.dmi'

/datum/asset/spritesheet/chat
	name = "chat"

/datum/asset/spritesheet/chat/create_spritesheets()
	InsertAll("emoji", EMOJI_SET)
	// catch languages which are pulling icons from another file
	for(var/path in typesof(/datum/language))
		var/datum/language/L = path
		var/icon = initial(L.icon)
		if (icon != 'icons/misc/language.dmi')
			var/icon_state = initial(L.icon_state)
			Insert("language-[icon_state]", icon, icon_state=icon_state)
	InsertAll("accent", 'icons/accent_tags.dmi')
