/obj/item/paper/talisman
	icon_state = "paper_talisman"
	can_change_icon_state = FALSE
	var/uses = 1
	var/network
	var/datum/rune/rune
	info = "<center><img src='talisman.png'></center><br/><br/>"

/obj/item/paper/talisman/Initialize()
	. = ..()
	name = "bloodied paper"
	color = "FF6D6D"

/obj/item/paper/talisman/Destroy()
	QDEL_NULL(rune)
	return ..()

/obj/item/paper/talisman/get_examine_text(mob/user)
	. = ..()
	if(iscultist(user) && rune)
		to_chat(user, "The spell inscription reads: <span class='cult'><b><i>[rune.name]</i></b></span>.")
		. += "The spell inscription reads: [SPAN_CULT(rune.name)]."
		. += "This spell's network tag reads: [SPAN_CULT(network)]."

/obj/item/paper/talisman/attack_self(mob/living/user)
	if(iscultist(user))
		if(rune)
			user.say("INVOKE!")
			rune.activate(user, src)
			return
		else
			to_chat(user, SPAN_CULT("This talisman has no power."))
	else
		to_chat(user, SPAN_CULT("The smell of blood permeates this paper. That can't be good."))
		return

/obj/item/paper/talisman/use()
	uses--
	if(uses <= 0)
		qdel(src)
