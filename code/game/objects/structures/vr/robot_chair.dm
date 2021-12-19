/obj/structure/bed/stool/chair/remote/robot
	name = "robot control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to robots attached to the remote network."
	remote_network = REMOTE_GENERIC_ROBOT

/obj/structure/bed/stool/chair/remote/robot/user_buckle(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		SSvirtualreality.robot_selection(H, remote_network)

/obj/structure/bed/stool/chair/remote/robot/bunker
	name = "bunker robot control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to robots attached to the bunker network."
	remote_network = REMOTE_BUNKER_ROBOT

/obj/structure/bed/stool/chair/remote/robot/prison
	name = "penal robot control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to robots attached to the penal network."
	remote_network = REMOTE_PRISON_ROBOT

/obj/structure/bed/stool/chair/remote/robot/warden
	name = "warden robot control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to robots attached to the warden's network."
	remote_network = REMOTE_WARDEN_ROBOT
