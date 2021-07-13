var/datum/antagonist/morph/morphs = null

/datum/antagonist/morph
	id = MODE_MORPH
	role_text = "Morph"
	role_text_plural = "Morphs"
	welcome_text = "You have been released as a morph. Help your changeling achieve their goals!"
	antaghud_indicator = "hudchangeling"
	faction = "Changeling"
	antag_sound = 'sound/effects/antag_notice/ling_alert.ogg'
	flags = ANTAG_NO_ROUNDSTART_SPAWN

/datum/antagonist/morph/New()
	..()
	morphs = src

/datum/antagonist/morph/greet(datum/mind/player)
	. = ..()
	to_chat(player.current, SPAN_DANGER("As a morph, you can disguise as objects by alt-clicking on them."))
	to_chat(player.current, SPAN_DANGER("You can eat people and items by clicking on them, but only if they're dead."))

/datum/antagonist/morph/is_obvious_antag(datum/mind/player)
	return TRUE