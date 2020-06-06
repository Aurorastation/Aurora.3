/obj/item/paper/talisman
	icon_state = "paper_talisman"
	var/datum/callback/imbued_rune
	var/network // Which network the teleport talisman is on
	var/uses = 1
	var/rune
	info = "<center><img src='talisman.png'></center><br/><br/>"

/obj/item/paper/talisman/Initialize()
	. = ..()
	name = "bloodied paper"
	color = "FF6D6D"

/obj/item/paper/talisman/examine(mob/user)
	..()
	if(iscultist(user) && rune)
		to_chat(user, "The spell inscription reads: <span class='cult'><b><i>[rune]</i></b></span>.")

/obj/item/paper/talisman/attack_self(mob/living/user)
	if(iscultist(user))
		if(imbued_rune)
			if(imbued_rune.Invoke(user, src))
				user.take_organ_damage(5, 0)
				use()
			return
		else
			to_chat(user, span("cult", "This talisman has not been imbued with power!"))
	else
		to_chat(user, span("cult", "You see strange symbols on the paper. Are they supposed to mean something?"))
		return

/obj/item/paper/talisman/proc/use()
	uses--
	if(uses <= 0)
		qdel(src)