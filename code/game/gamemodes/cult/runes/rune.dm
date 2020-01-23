var/global/rune_boost = 0 // How many extra runes the cult can lay down

var/global/list/static/rune_types = list(
			"Armor" = /obj/effect/rune/armor,
			"Summon Tome" = /obj/effect/rune/summon_tome,
			"Become Ethereal" = /obj/effect/rune/ethereal,
			"Manifest Ghost" = /obj/effect/rune/manifest,
			"Raise Dead" = /obj/effect/rune/raise_dead,
			"Rune Wall" = /obj/effect/rune/wall,
			"Blind" = /obj/effect/rune/blind,
			"Blood Boil" = /obj/effect/rune/blood_boil,
			"Blood Drain" = /obj/effect/rune/blood_drain,
			"Communicate" = /obj/effect/rune/communicate,
			"Convert" = /obj/effect/rune/convert,
			"Create Talisman" = /obj/effect/rune/create_talisman,
			"Deafen Others" = /obj/effect/rune/deafen,
			"EMP" = /obj/effect/rune/emp,
			"Free Cultist" = /obj/effect/rune/freedom,
			"Hide Runes" = /obj/effect/rune/hiderunes,
			"Reveal Runes" = /obj/effect/rune/revealrunes,
			"Teleport" = /obj/effect/rune/teleport,
			"Sacrifice" = /obj/effect/rune/sacrifice,
			"See Invisible" = /obj/effect/rune/see_invisible,
			"Stun" = /obj/effect/rune/stun,
			"Summon Cultist" = /obj/effect/rune/summon_cultist,
			"Summon Nar'sie" = /obj/effect/rune/summon_narsie,
			"None" = /obj/effect/rune
			)

/obj/effect/rune
	desc = "A strange collection of symbols drawn in blood."
	anchored = 1
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	var/visible = FALSE
	unacidable = TRUE
	layer = AO_LAYER

	var/can_talisman = FALSE // some runes just don't work with talisman stuff
	var/cult_description // what does the cult see the rune as?

	var/network // For teleportation runes. Can connect to other runes in the network.
	var/image/blood_image
	var/list/converting = list()

/obj/effect/rune/Initialize()
	. = ..()
	blood_image = image(loc = src)
	blood_image.override = TRUE
	for(var/mob/living/silicon/ai/AI in player_list)
		if(AI.client)
			AI.client.images += blood_image
	rune_list += src
	name = "graffiti"

/obj/effect/rune/Destroy()
	for(var/mob/living/silicon/ai/AI in player_list)
		if(AI.client)
			AI.client.images -= blood_image
	qdel(blood_image)
	blood_image = null
	rune_list -= src
	return ..()

/obj/effect/rune/examine(mob/user)
	..()
	if(iscultist(user) && cult_description)
		to_chat(user, "This spell circle reads: <b><i>[cult_description]</i></b>.")

/obj/effect/rune/attackby(obj/I, mob/user)
	if(istype(I, /obj/item/book/tome) && iscultist(user))
		to_chat(user, span("notice", "You retrace your steps, carefully undoing the lines of the rune."))
		qdel(src)
		return
	else if(istype(I, /obj/item/nullrod))
		to_chat(user, span("notice", "You disrupt the vile magic with the deadening field of \the [I]!"))
		qdel(src)
		return
	return

/obj/effect/rune/attack_hand(mob/living/user)
	if(!iscultist(user))
		to_chat(user, span("notice", "You can't mouth the arcane scratchings without fumbling over them."))
		return
	if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		to_chat(user, span("warning", "You are unable to speak the words of the rune."))
		return
	return do_rune_action(user)

// Runes should override this
/obj/effect/rune/proc/do_rune_action(var/mob/living/user)
	return

/obj/effect/rune/proc/fizzle(var/mob/living/user)
	if(istype(src,/obj/effect/rune))
		user.say(pick("Hakkrutju gopoenjim.", "Nherasai pivroiashan.", "Firjji prhiv mazenhor.", "Tanah eh wakantahe.", "Obliyae na oraie.", "Miyf hon vnor'c.", "Wakabai hij fen juswix."))
	else
		user.whisper(pick("Hakkrutju gopoenjim.", "Nherasai pivroiashan.", "Firjji prhiv mazenhor.", "Tanah eh wakantahe.", "Obliyae na oraie.", "Miyf hon vnor'c.", "Wakabai hij fen juswix."))
		for(var/mob/V in viewers(src))
			to_chat(V, span("warning", "The markings pulse with a small burst of light, then fall dark."))
		return

/obj/effect/rune/cultify()
	return