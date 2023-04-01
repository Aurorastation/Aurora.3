/obj/structure/bed/stool/chair/remote/teshari
	name = "virtual reality centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to a virtual reality body."

/obj/structure/bed/stool/chair/remote/teshari/user_buckle(mob/user)
	..()
	if(isteshari(user))
		var/mob/living/carbon/teshari/H = user
		SSvirtualreality.create_virtual_reality_avatar(H)