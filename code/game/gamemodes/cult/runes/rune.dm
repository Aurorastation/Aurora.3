/obj/effect/rune
	name = "rune"
	desc = "A strange collection of symbols drawn in blood."
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	anchored = TRUE
	unacidable = TRUE
	layer = RUNE_LAYER
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	var/datum/rune/rune

/obj/effect/rune/Initialize(mapload, var/R)
	. = ..()
	if(!R)
		return INITIALIZE_HINT_QDEL
	icon_state = "[rand(1, 6)]"
	filters = filter(type="drop_shadow", x = 1, y = 1, size = 4, color = "#FF0000")
	rune = new R(src, src)
	SScult.add_rune(rune)

/obj/effect/rune/Destroy()
	QDEL_NULL(rune)
	return ..()

/obj/effect/rune/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(iscultist(user) || isobserver(user))
		. += rune.get_cultist_fluff_text()
		. += "This rune [rune.can_be_talisman() ? SPAN_CULT("can") : "[SPAN_CULT("cannot")]"] be turned into a talisman."
		. += "This rune [rune.can_memorize() ? SPAN_CULT("can") : "[SPAN_CULT("cannot")]"] be memorized to be scribed without a tome."
	else
		. += rune.get_normal_fluff_text()

/obj/effect/rune/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/book/tome) && iscultist(user))
		rune.do_tome_action(user, attacking_item)
		return TRUE
	else if(istype(attacking_item, /obj/item/nullrod))
		to_chat(user, SPAN_NOTICE("You disrupt the vile magic with the deadening field of \the [attacking_item]!"))
		qdel(src)
		return TRUE

/obj/effect/rune/attack_hand(mob/living/user)
	if(!iscultist(user))
		to_chat(user, SPAN_NOTICE("You can't mouth the arcane scratchings without fumbling over them."))
		return
	if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		to_chat(user, SPAN_WARNING("You are unable to speak the words of the rune."))
		return
	return rune.activate(user, src)

/obj/effect/rune/cultify()
	return
