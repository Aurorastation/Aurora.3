
//list(ckey = real_name,)
//Since the ckey is used as the icon_state, the current system will only permit a single custom robot sprite per ckey.
//While it might be possible for a ckey to use that custom sprite for several real_names, it seems rather pointless to support it.
var/list/robot_custom_icons
/hook/startup/proc/load_robot_custom_sprites()
	if(config.load_customsynths_from == "sql")
		loadsynths_from_sql()
	else if(config.load_customsynths_from == "json")
		loadsynths_from_json()
	return 1

/mob/living/silicon/robot/proc/set_custom_sprite()
	if(!(name in robot_custom_icons))
		return
	var/datum/custom_synth/sprite = robot_custom_icons[name]
	if(istype(sprite) && sprite.synthckey == ckey)
		custom_sprite = 1
		icon = CUSTOM_ITEM_SYNTH
		var/list/valid_states = icon_states(icon)
		if(icon_state == "robot")
			if("[sprite.synthicon]-Standard" in valid_states)
				icon_state = "[sprite.synthicon]-Standard"
			else
				to_chat(src, SPAN_WARNING("Could not locate [sprite.synthicon]-Standard sprite."))
				icon = 'icons/mob/robots.dmi'
