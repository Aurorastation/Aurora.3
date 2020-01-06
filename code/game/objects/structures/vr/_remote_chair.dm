/obj/structure/bed/chair/remote
	name = "virtual reality centre"
	desc = "A comfortable chair with full audio-visual transposition centres."
	icon_state = "shuttlechair_down"
	can_dismantle = FALSE
	var/list/remote_network // Which network does this remote control belong to?

/obj/structure/bed/chair/remote/update_icon()
	return

/obj/structure/bed/chair/remote/user_buckle_mob(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.old_mob)
			to_chat(H, span("warning", "The chair rejects you! You cannot recursively control bodies."))
			return
	add_overlay(image('icons/obj/furniture.dmi', src, "vr_helmet", MOB_LAYER + 1))

// Return to our body in the unfortunate event that we get unbuckled while plugged in
/obj/structure/bed/chair/remote/user_unbuckle_mob(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.body_return()
	cut_overlays()
	..()