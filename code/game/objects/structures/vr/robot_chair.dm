/obj/structure/bed/chair/remote/robot
	name = "robot control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to robots attached to the remote network."
	remote_network = "remoterobots"

/obj/structure/bed/chair/remote/robot/user_buckle_mob(mob/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		SSvirtualreality.robot_selection(H, remote_network)

/obj/structure/bed/chair/remote/robot/bunker
	name = "bunker robot control centre"
	desc = "A comfortable chair with full audio-visual transposition centres. This one gives you access to robots attached to the bunker network."
	remote_network = "bunkerrobots"