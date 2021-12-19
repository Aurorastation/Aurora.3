/obj/structure/bed/stool/chair/remote/human
	name = "virtual reality centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to a virtual reality body."

/obj/structure/bed/stool/chair/remote/human/user_buckle(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		SSvirtualreality.create_virtual_reality_avatar(H)