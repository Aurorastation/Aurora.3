/obj/structure/bed/chair/remote/mech
	name = "mech control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to exosuits attached to the remote network."

/obj/structure/bed/chair/remote/mech/Initialize()
	..()
	remote_network = remotemechs // Generic mechs for a generic chair, whoda thunkit?

/obj/structure/bed/chair/remote/user_buckle_mob(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.mech_selection(remote_network)

/obj/structure/bed/chair/remote/mech/prison
	name = "brig mech control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to exosuits attached to the brig network."

/obj/structure/bed/chair/remote/mech/prison/Initialize()
	..()
	remote_network = prisonmechs