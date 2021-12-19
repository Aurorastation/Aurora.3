/obj/structure/bed/stool/chair/remote/mech
	name = "mech control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to exosuits attached to the remote network."
	remote_network = REMOTE_GENERIC_MECH

/obj/structure/bed/stool/chair/remote/mech/user_buckle(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		SSvirtualreality.mech_selection(H, remote_network)

/obj/structure/bed/stool/chair/remote/mech/portable
	portable_type = /obj/item/deployable_kit/remote_mech

/obj/structure/bed/stool/chair/remote/mech/prison
	name = "brig mech control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to exosuits attached to the brig network."
	remote_network = REMOTE_PRISON_MECH

/obj/structure/bed/stool/chair/remote/mech/prison/portable
	portable_type = /obj/item/deployable_kit/remote_mech/brig
