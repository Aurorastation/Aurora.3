#define NO_TALISMAN	BITFLAG(1)
#define CAN_MEMORIZE	BITFLAG(2)
#define HAS_SPECIAL_TALISMAN_ACTION	BITFLAG(3)

/datum/rune
	///The rune's name
	var/name

	///The rune's description; this and the name are used in the guide
	var/desc

	///Things like if it can be a talisman or not, see defines in `code\game\gamemodes\cult\runes\_rune_datum.dm`
	var/rune_flags

	///Maximum number allowed of this rune
	var/max_number_allowed

	var/atom/movable/parent

/datum/rune/New(atom/owner)
	..()
	parent = owner

/datum/rune/Destroy()
	parent = null
	SScult.remove_rune(src)
	return ..()

/datum/rune/proc/activate(var/mob/living/user, var/atom/movable/A)
	if(!isliving(user))
		return
	if(!istype(A, /obj/effect/rune) && (rune_flags & HAS_SPECIAL_TALISMAN_ACTION) && can_be_talisman())
		do_talisman_action(user, A)
	else
		do_rune_action(user, A)

/datum/rune/proc/do_rune_action(var/mob/living/user, var/atom/movable/A)
	return

/datum/rune/proc/do_talisman_action(var/mob/living/user, var/atom/movable/A)
	return

/datum/rune/proc/do_tome_action(var/mob/living/user, var/atom/movable/A)
	to_chat(user, SPAN_NOTICE("You retrace your steps, carefully undoing the lines of the rune."))
	playsound(parent, 'sound/effects/projectile_impact/energy_meat1.ogg', 30)
	qdel(parent)

/datum/rune/proc/fizzle(var/mob/living/user, var/atom/movable/A)
	to_chat(user, SPAN_CULT("The rune sizzles with no result."))
	playsound(A, 'sound/effects/projectile_impact/energy_meat2.ogg', 30)

/datum/rune/proc/get_normal_fluff_text()
	. = SPAN_WARNING("A heavy smell of blood permeates the area around the arcane drawings.")

/datum/rune/proc/get_cultist_fluff_text()
	. = SPAN_CULT("You remember clear as the night that this is \an [name].")

/datum/rune/proc/can_be_talisman()
	return !(rune_flags & NO_TALISMAN)

/datum/rune/proc/can_memorize()
	return rune_flags & CAN_MEMORIZE
