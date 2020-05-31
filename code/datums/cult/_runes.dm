#define NO_TALISMAN 1

/datum/rune
	var/name          // The rune's name.
	var/desc          // The rune's description. This and the name are used in the guide.
	var/rune_flags    // Things like if it can be a talisman or not.

/datum/rune/Initialize()
	SScult.add_rune(src)

/datum/rune/Destroy()
	SScult.remove_rune(src)
	return ..()

/datum/rune/proc/do_rune_action(var/mob/user, var/atom/movable/A)
	return

/datum/rune/proc/do_fizzle_action(var/mob/user, var/atom/movable/A)
	return

/datum/rune/proc/special_checks() //Use this proc if you need to check for pre-existing conditions before adding a rune.
	return TRUE

/datum/rune/proc/get_normal_fluff_text()
	. = SPAN_WARNING("A heavy smell of blood permeates the area around the arcane drawings.")

/datum/rune/proc/get_cultist_fluff_text()
	. = SPAN_CULT("You remember clear as the night that this is a [name].")
