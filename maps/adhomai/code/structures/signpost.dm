/obj/structure/signpost/adhomai
	name = "signpost"
	desc = "A lone signpost. Pointing the way to a new adventure."

/obj/structure/signpost/adhomai/attack_hand(mob/user as mob)
	switch(alert("Start your Journey? There will be no return.","Journey","Yes","No"))
		if("Yes")
			for(var/obj/effect/landmark/C in landmarks_list)
				if(C.name == "AdhomaiJourney")
					user.forceMove(get_turf(C))
		if("No")
			return