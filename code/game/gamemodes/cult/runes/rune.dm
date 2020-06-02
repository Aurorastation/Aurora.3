var/global/list/static/rune_types = list(
			"Create Armor" = /obj/effect/rune/armor,
			"Create Construct" = /obj/effect/rune/create_construct,
			"Summon Tome" = /obj/effect/rune/summon_tome,
			"Summon Soulstone" = /obj/effect/rune/summon_soulstone,
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
//todomatt fuck that shit above

/obj/effect/rune
	desc = "A strange collection of symbols drawn in blood."
	anchored = 1
	icon = 'icons/obj/rune.dmi'
	icon_state = "1"
	unacidable = TRUE
	layer = AO_LAYER

	var/datum/rune/rune

	var/network // For teleportation runes. Can connect to other runes in the network.

/obj/effect/rune/Initialize()
	. = ..()
	SScult.add_rune(rune)

/obj/effect/rune/Destroy()
	SScult.remove_rune(rune)
	QDEL_NULL(rune)
	return ..()

/obj/effect/rune/examine(mob/user)
	..(user)
	if(iscultist(user) || isobserver(user))
		to_chat(user, rune.get_cultist_fluff_text())) //i'd just like to note that this was changing the desc earlier
		if(cult_description)
			to_chat(user, "This spell circle reads: [rune.desc]")
		to_chat(user, "This rune [rune.can_be_talisman() ? "<span class='cult'><b><i>can</i></b></span>" : "<span class='warning'><b><i>cannot</i></b></span>"] be turned into a talisman.")
	else
		to_chat(user, rune.get_normal_fluff_text())

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
		to_chat(user, SPAN_NOTICE("You can't mouth the arcane scratchings without fumbling over them."))
		return
	if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		to_chat(user, SPAN_WARNING("You are unable to speak the words of the rune."))
		return
	return rune.do_rune_action(user, src)

/obj/effect/rune/cultify()
	return