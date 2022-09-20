/obj/effect/rune
	desc = "A strange collection of symbols drawn in blood."
	anchored = 1
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	unacidable = TRUE
	layer = AO_LAYER
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

/obj/effect/rune/examine(mob/user)
	..(user)
	if(iscultist(user) || isobserver(user))
		to_chat(user, rune.get_cultist_fluff_text())
		to_chat(user, "This rune [rune.can_be_talisman() ? SPAN_CULT("<b><i>can</i></b>") : SPAN_WARNING("<b><i>cannot</i></b>")] be turned into a talisman.")
		to_chat(user, "This rune [rune.can_memorize() ? SPAN_CULT("<b><i>can</i></b>") : SPAN_WARNING("<b><i>cannot</i></b>")] be memorized to be scribed without a tome.")
	else
		to_chat(user, rune.get_normal_fluff_text())

/obj/effect/rune/attackby(obj/I, mob/user)
	if(istype(I, /obj/item/book/tome) && iscultist(user))
		rune.do_tome_action(user, I)
		return TRUE
	else if(istype(I, /obj/item/nullrod))
		to_chat(user, SPAN_NOTICE("You disrupt the vile magic with the deadening field of \the [I]!"))
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
