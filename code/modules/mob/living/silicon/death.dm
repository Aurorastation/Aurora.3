/mob/living/silicon/gib()
	..("gibbed-r")
	gibs(loc, viruses, null, /obj/effect/gibspawner/robot)

/mob/living/silicon/dust()
	..(/obj/effect/decal/remains/robot)

/mob/living/silicon/death(gibbed,deathmessage)
	if(in_contents_of(/obj/machinery/robot_charger))//exit the recharge station
		var/obj/machinery/robot_charger/RC = loc
		RC.go_out()
	return ..(gibbed,deathmessage)
