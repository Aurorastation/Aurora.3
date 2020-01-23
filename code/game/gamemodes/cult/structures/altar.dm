/obj/structure/cult/talisman
	name = "daemon altar"
	desc = "A bloodstained altar dedicated to Nar-Sie."
	description_antag = "If you are a cultist, you could click on this altar to pray to Nar'Sie, who will in turn heal some of your ailments."
	icon_state = "talismanaltar"
	var/last_use

/obj/structure/cult/talisman/examine(mob/user)
	..(user)
	if(!iscultist(user) || !isobserver(user))
		desc = "A bloodstained altar. Looking at it makes you feel slightly terrified."
	else
		desc = "A bloodstained altar dedicated to Nar-Sie."

/obj/structure/cult/talisman/attack_hand(mob/user)
	. = ..()
	if(iscultist(user))
		if(last_use >= world.time + 3000) // Cooldown of 5 minutes
			heal_overall_damage(20, 20)
			adjustBrainLoss(-2)
			to_chat(user, span("span", "You quietly pray to Nar'Sie and feel your wounds get sewn up."))
			last_use = world.time
		else
			to_chat(user, span("warning", "This altar isn't ready to be prayed at again."))