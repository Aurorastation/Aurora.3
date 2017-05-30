/obj/item/weapon/ladder_mobile
	name = "mobile ladder"
	desc = "A lightweight deployable ladder, which you can use to move up or down. Or alternatively, you can bash some faces in."
	icon_state = "ladder01"
	icon = 'icons/obj/structures.dmi'
	throw_range = 3
	force = 10
	w_class = 4.0
	slot_flags = SLOT_BACK

/obj/item/weapon/ladder_mobile/proc/place_ladder(atom/A,mob/user)

	if(istype(A, /turf/simulated/open))         //Place into open space
		var/turf/below_loc = GetBelow(A)
		if (!below_loc || (istype(/turf/space,below_loc)))
			user << "<span class='notice'>Why would you do that?! There is only infinite space there...</span>"
			return
		user.visible_message("<span class='warning'>[user] begins to lower \the [src] into \the [A].</span>")
		if(!handle_action(A,user))
			return
		var/obj/structure/ladder/mobile/body/R = new(A)
		var/obj/structure/ladder/mobile/base/D = new(A)
		D.forceMove(below_loc)
		R.target_down = D 
		D.target_up = R

		user.drop_item()
		qdel(src)

	if(istype(A, /turf/simulated/floor))        //Place onto Floor
		var/turf/upper_loc = GetAbove(A)
		if (!upper_loc || !istype(upper_loc,/turf/simulated/open))
			user << "<span class='notice'>There is something above. You can't deploy!</span>"
			return
		user.visible_message("<span class='warning'>[user] begins deploying \the [src] on \the [A].</span>")
		if(!handle_action(A,user))
			return
		var/obj/structure/ladder/mobile/base/R = new(A)
		var/obj/structure/ladder/mobile/body/D = new(A)
		D.forceMove(upper_loc) // moves A up to upper_loc.
		R.target_up = D
		D.target_down = R

		user.drop_item()
		qdel(src)

/obj/item/weapon/ladder_mobile/afterattack(atom/A, mob/user,proximity) 
	if(!proximity)
		return
	//addtimer(CALLBACK(src, .proc/place_ladder, A, user), 5000)
	place_ladder(A,user)

/obj/item/weapon/ladder_mobile/proc/handle_action(atom/A, mob/user)
	if (!do_after(user, 30, act_target = user))
		to_chat(user, "Can't place ladder! You were interrupted!")
		return FALSE
	if (!A || QDELETED(src) || QDELETED(user))
		// Shit was deleted during delay, call is no longer valid.
		return FALSE
	return TRUE