#define NO_TALISMAN                  1
#define HAS_SPECIAL_TALISMAN_ACTION  2

/datum/rune
	var/name          // The rune's name.
	var/desc          // The rune's description. This and the name are used in the guide.
	var/rune_flags    // Things like if it can be a talisman or not.
	var/atom/movable/parent

/datum/rune/Initialize(atom/owner)
	. = ..()
	parent = owner

/datum/rune/proc/do_rune_action(var/mob/living/user, var/atom/movable/A)
	if(!isliving(user))
		return
	if(istype(A, /obj/item/paper/talisman) && (rune_flags & HAS_SPECIAL_TALISMAN_ACTION) && can_be_talisman())
		do_talisman_action(user, A)
		return

/datum/rune/proc/do_talisman_action(var/mob/living/user, var/obj/item/A)
	return

/datum/rune/proc/do_fizzle_action(var/mob/living/user, var/atom/movable/A)
	return

/datum/rune/proc/special_checks() //Use this proc if you need to check for pre-existing conditions before adding a rune.
	return TRUE

/datum/rune/proc/get_normal_fluff_text()
	. = SPAN_WARNING("A heavy smell of blood permeates the area around the arcane drawings.")

/datum/rune/proc/get_cultist_fluff_text()
	. = SPAN_CULT("You remember clear as the night that this is a [name].")

/datum/rune/proc/can_be_talisman()
	return !(rune_flags & NO_TALISMAN)
