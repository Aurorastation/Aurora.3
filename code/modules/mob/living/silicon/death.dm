/mob/living/silicon/gib()
	..("gibbed-r")
	gibs(loc, viruses, null, /obj/effect/gibspawner/robot)

/mob/living/silicon/dust()
	..(/obj/effect/decal/remains/robot)

/mob/living/silicon/death(gibbed,deathmessage)
	if(in_contents_of(/obj/structure/machinery/recharge_station))//exit the recharge station
		var/obj/structure/machinery/recharge_station/RC = loc
		RC.go_out()
	return ..(gibbed,deathmessage)
