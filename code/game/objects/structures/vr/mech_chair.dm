/obj/structure/bed/chair/remote/mech
	name = "mech control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to exosuits attached to the remote network."
	remote_network = "remotemechs"

/obj/structure/bed/chair/remote/mech/user_buckle_mob(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		SSvirtualreality.mech_selection(H, remote_network)

/obj/structure/bed/chair/remote/mech/prison
	name = "brig mech control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to exosuits attached to the brig network."
	remote_network = "prisonmechs"